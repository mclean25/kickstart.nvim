# Buffer History Plugin

A Neovim plugin that tracks buffer history per project and provides breadcrumb-style navigation through Telescope.

## Features

- **Project-scoped history**: Tracks file visits per project (detects `.git`, `package.json`, etc.)
- **Persistent across sessions**: History is saved to `.nvim-buffer-history` in your project root
- **Telescope integration**: Beautiful UI for browsing history and breadcrumbs
- **Smart filtering**: Excludes temp files, git directories, and special buffers
- **Time-aware**: Shows when files were last visited

## Usage

### Keybindings

- `<leader>sh` - Open buffer history picker (all files in project history)
- `<leader>sb` - Open breadcrumb picker (recent 10 files for quick navigation)

### Commands

- `:BufferHistory` - Open full buffer history
- `:BufferBreadcrumbs` - Open recent breadcrumbs

### How it works

1. **Automatic tracking**: Every time you open a file (`BufEnter`/`BufRead`), it's added to history
2. **Project detection**: Uses common project markers (`.git`, `package.json`, etc.) to scope history
3. **Smart exclusions**: Filters out temporary files, node_modules, .git, etc.
4. **Persistent storage**: History saved to `.nvim-buffer-history` in project root

### Configuration

The plugin is configured in your `custom/plugins/init.lua`:

```lua
buffer_history.setup({
  max_history_size = 100,           -- Maximum files to track per project
  history_file = '.nvim-buffer-history',  -- Filename for history storage
  exclude_patterns = {              -- File patterns to ignore
    '%.git/',
    'node_modules/',
    '%.cache/',
    '/tmp/',
  },
  exclude_filetypes = {             -- Filetypes to ignore
    'help', 'NvimTree', 'neo-tree', 'telescope', 'lazy', 'mason',
  }
})
```

## Telescope UI

- **Time stamps**: Shows "2m ago", "1h ago", "3d ago" for each file
- **Relative paths**: Shows project-relative paths for cleaner display
- **File preview**: Full file preview in telescope
- **Quick navigation**: Press Enter to open file

## Use Cases

1. **Session recovery**: Reopen nvim and see your recent file trail
2. **Code exploration**: When diving deep into references, see your breadcrumb trail
3. **Project context**: Quickly return to recently viewed files in current project
4. **Cross-session continuity**: History persists between nvim sessions