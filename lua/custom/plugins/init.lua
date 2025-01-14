-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'christoomey/vim-tmux-navigator',
    lazy = false,
    vim.keymap.set('n', 'C-h', ':TmuxNavigateLeft<CR>'),
    vim.keymap.set('n', 'C-j', ':TmuxNavigateDown<CR>'),
    vim.keymap.set('n', 'C-k', ':TmuxNavigateUp<CR>'),
    vim.keymap.set('n', 'C-l', ':TmuxNavigateRight<CR>'),
  },
  -- Dressing
  {
    'stevearc/dressing.nvim',
    opts = {},
  },
  -- Windline
  {
    'windwp/windline.nvim',
    config = function()
      require 'wlsample.airline'
    end,
  },
  {
    'supermaven-inc/supermaven-nvim',
    lazy = false,
    opts = {
      keymaps = {
        accept_suggestion = '<C-Enter>',
        clear_suggestion = '<C-]>',
        accept_word = '<C-j>',
      },
      color = {
        suggestion_color = '#C08D3D',
      },
    },
  },
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = true,
    vim.keymap.set('n', '<leader>`', ':ToggleTerm<CR>'),
  },
  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; remove for the latest version
    config = function()
      require('nvim-surround').setup {}
    end,
  },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
    config = function()
      -- Declare a global function to retrieve the current directory
      function _G.get_oil_winbar()
        local dir = require('oil').get_current_dir()
        if dir then
          return vim.fn.fnamemodify(dir, ':~')
        else
          -- If there is no current directory (e.g. over ssh), just show the buffer name
          return vim.api.nvim_buf_get_name(0)
        end
      end
      require('oil').setup {
        view_options = {
          show_hidden = true,
        },
        win_options = {
          winbar = '%!v:lua.get_oil_winbar()',
        },
      }
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open Oil (parent dir)' })
      -- Open Oil parent directory in float window
      vim.keymap.set('n', '<leader>-', require('oil').toggle_float, { desc = 'Open Oil (parent dir) in float window' })
    end,
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
      '3rd/image.nvim', -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    vim.keymap.set('n', '<leader>b', '<CMD>Neotree action=show source=filesystem position=left toggle=true<CR>', { desc = 'Toggle Neo-tree' }),
    config = function()
      require('neo-tree').setup {
        close_if_last_window = true,
        filesystem = {
          follow_current_file = {
            enabled = true,
          },
        },
      }
    end,
  },
}
