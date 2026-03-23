local function review_requested_prs()
  vim.cmd [[Octo search is:pr state:open review-requested:@me]]
end

local function octo_pr_changed_files()
  require('octo.picker').changed_files(require('octo.utils').get_current_buffer())
end

local function octo_pr_commits()
  require('octo.picker').commits(require('octo.utils').get_current_buffer())
end

local function octo_pr_diff()
  require('octo.commands').show_pr_diff()
end

local function octo_review_browse()
  require('octo.reviews').browse_review()
end

local function set_octo_buffer_keymaps(bufnr)
  local octo_buffer = require('octo.utils').get_current_buffer()
  if not octo_buffer then
    return
  end

  local map = function(lhs, rhs, desc)
    vim.keymap.set('n', lhs, rhs, { buffer = bufnr, silent = true, noremap = true, desc = desc })
  end

  if octo_buffer:isPullRequest() then
    map(',pf', octo_pr_changed_files, 'Octo PR changed files')
    map(',pd', octo_pr_diff, 'Octo PR diff')
    map(',pc', octo_pr_commits, 'Octo PR commits')
    map(',vb', octo_review_browse, 'Octo browse review')
  end
end

return {
  {
    'pwntester/octo.nvim',
    cmd = 'Octo',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'ibhagwan/fzf-lua',
    },
    keys = {
      { '<leader>oo', '<cmd>Octo actions<cr>', desc = 'Octo actions' },
      { '<leader>op', '<cmd>Octo pr list<cr>', desc = 'Octo PR list' },
      { '<leader>ob', octo_review_browse, desc = 'Octo browse review' },
      { '<leader>of', octo_pr_changed_files, desc = 'Octo PR changed files' },
      { '<leader>od', octo_pr_diff, desc = 'Octo PR diff' },
      { '<leader>om', octo_pr_commits, desc = 'Octo PR commits' },
      { '<leader>or', '<cmd>Octo review start<cr>', desc = 'Octo start review' },
      { '<leader>oc', '<cmd>Octo review comments<cr>', desc = 'Octo review comments' },
      { '<leader>oP', review_requested_prs, desc = 'Octo PRs for review' },
    },
    opts = {
      picker = 'fzf-lua',
      enable_builtin = true,
      default_remote = { 'upstream', 'origin' },
      mappings_disable_default = false,
      pull_requests = {
        order_by = {
          field = 'UPDATED_AT',
          direction = 'DESC',
        },
      },
      reviews = {
        auto_show_threads = true,
        focus = 'right',
      },
      mappings = {
        pull_request = {
          review_start = { lhs = '<localleader>vs', desc = 'start a review for the current PR' },
          review_resume = { lhs = '<localleader>vr', desc = 'resume a pending review for the current PR' },
          list_changed_files = { lhs = '<localleader>pf', desc = 'list PR changed files' },
          show_pr_diff = { lhs = '<localleader>pd', desc = 'show PR diff' },
          list_commits = { lhs = '<localleader>pc', desc = 'list PR commits' },
          resolve_thread = { lhs = '<localleader>rt', desc = 'resolve PR thread' },
          unresolve_thread = { lhs = '<localleader>rT', desc = 'unresolve PR thread' },
        },
        review_diff = {
          submit_review = { lhs = '<localleader>vs', desc = 'submit review' },
          discard_review = { lhs = '<localleader>vd', desc = 'discard review' },
          add_review_comment = { lhs = '<localleader>ca', desc = 'add a new review comment', mode = { 'n', 'x' } },
          add_review_suggestion = { lhs = '<localleader>sa', desc = 'add a new review suggestion', mode = { 'n', 'x' } },
          focus_files = { lhs = '<localleader>e', desc = 'move focus to changed file panel' },
          toggle_files = { lhs = '<localleader>b', desc = 'hide/show changed files panel' },
          toggle_viewed = { lhs = '<localleader><space>', desc = 'toggle viewer viewed state' },
        },
        review_thread = {
          add_comment = { lhs = '<localleader>ca', desc = 'add comment' },
          add_reply = { lhs = '<localleader>cr', desc = 'add reply' },
          add_suggestion = { lhs = '<localleader>sa', desc = 'add suggestion' },
          resolve_thread = { lhs = '<localleader>rt', desc = 'resolve PR thread' },
          unresolve_thread = { lhs = '<localleader>rT', desc = 'unresolve PR thread' },
        },
        file_panel = {
          submit_review = { lhs = '<localleader>vs', desc = 'submit review' },
          discard_review = { lhs = '<localleader>vd', desc = 'discard review' },
          focus_files = { lhs = '<localleader>e', desc = 'move focus to changed file panel' },
          toggle_files = { lhs = '<localleader>b', desc = 'hide/show changed files panel' },
          toggle_viewed = { lhs = '<localleader><space>', desc = 'toggle viewer viewed state' },
        },
      },
    },
    config = function(_, opts)
      require('octo').setup(opts)

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'octo', 'octo_panel', 'octo_review_thread', 'octo_review_diff', 'octo_changed_files' },
        callback = function(event)
          vim.bo[event.buf].buflisted = false
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(event.buf) then
              set_octo_buffer_keymaps(event.buf)
            end
          end)
        end,
      })
    end,
  },
}
