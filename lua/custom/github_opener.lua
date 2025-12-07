local M = {}

local function run_command(cmd)
  local handle = io.popen(cmd)
  if not handle then
    return nil
  end
  local result = handle:read('*a')
  handle:close()
  if not result then
    return nil
  end
  return result:gsub('\n$', '') -- Remove trailing newline
end

function M.open_commit_in_github()
  local gitsigns = require('gitsigns')
  
  -- Get file info
  local file = vim.fn.expand('%:p')
  local file_dir = vim.fn.expand('%:p:h')
  local relative_file = vim.fn.expand('%')
  local line = vim.fn.line('.')
  
  -- Get hunks for current file
  local hunks = gitsigns.get_hunks()
  
  if not hunks or #hunks == 0 then
    vim.notify('No git hunks found in current file', vim.log.levels.WARN)
    return
  end
  
  -- Find which hunk we're in
  local current_hunk = nil
  local hunk_line = nil
  
  for _, hunk in ipairs(hunks) do
    -- Check if cursor is in the added lines range
    if hunk.added.count > 0 then
      local hunk_start = hunk.added.start
      local hunk_end = hunk.added.start + hunk.added.count - 1
      if line >= hunk_start and line <= hunk_end then
        current_hunk = hunk
        hunk_line = line
        break
      end
    end
    
    -- For deleted lines, check the line right before the deletion
    if hunk.removed.count > 0 and hunk.added.count == 0 then
      -- Pure deletion - cursor should be on the line where deletion marker appears
      if line == hunk.added.start then
        current_hunk = hunk
        -- Use the old line number for blame
        hunk_line = hunk.removed.start
        break
      end
    end
  end
  
  if not current_hunk or not hunk_line then
    vim.notify('Cursor is not on a git hunk', vim.log.levels.WARN)
    return
  end
  
  -- Use git blame to find the commit that introduced this specific change
  -- For new changes (not yet committed), blame will fail, so we fall back to HEAD
  local blame_cmd = string.format(
    "cd %s && git blame -L %d,%d --porcelain %s 2>/dev/null | head -n 1 | awk '{print $1}'",
    vim.fn.shellescape(file_dir),
    hunk_line,
    hunk_line,
    vim.fn.shellescape(relative_file)
  )
  local commit_hash = run_command(blame_cmd)
  
  -- If blame fails (uncommitted changes), use the last commit that touched this file
  if not commit_hash or commit_hash == '' or commit_hash:match('^0+$') then
    local log_cmd = string.format(
      "cd %s && git log -1 --pretty=format:%%H -- %s",
      vim.fn.shellescape(file_dir),
      vim.fn.shellescape(relative_file)
    )
    commit_hash = run_command(log_cmd)
  end
  
  if not commit_hash or commit_hash == '' then
    vim.notify('Could not find commit hash for this hunk', vim.log.levels.WARN)
    return
  end
  
  -- Get remote URL
  local remote_cmd = string.format("cd %s && git config --get remote.origin.url", vim.fn.shellescape(file_dir))
  local remote_url = run_command(remote_cmd)
  
  if not remote_url or remote_url == '' then
    vim.notify('No remote origin found', vim.log.levels.WARN)
    return
  end
  
  -- Convert git URL to HTTPS if needed
  -- Handle git@github.com:user/repo.git format
  remote_url = remote_url:gsub('git@(.+):(.+)', 'https://%1/%2')
  -- Remove .git suffix
  remote_url = remote_url:gsub('%.git$', '')
  
  -- Build GitHub URL pointing to the commit with the file context
  local github_url = string.format('%s/commit/%s#diff-%s', 
    remote_url, 
    commit_hash,
    vim.fn.sha256(relative_file):sub(1, 16)
  )
  
  -- Detect which open command to use
  local open_cmd = 'open'
  if vim.fn.executable('xdg-open') == 1 then
    open_cmd = 'xdg-open'
  elseif vim.fn.executable('wsl-open') == 1 then
    open_cmd = 'wsl-open'
  end
  
  -- Open in browser
  local exec_cmd = string.format("%s %s > /dev/null 2>&1 &", open_cmd, vim.fn.shellescape(github_url))
  os.execute(exec_cmd)
  vim.notify(string.format('Opening commit %s in browser', commit_hash:sub(1, 7)))
end

return M
