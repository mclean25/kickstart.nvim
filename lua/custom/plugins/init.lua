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
  -- Lualine
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
            neotree = {},
            harpoon = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          always_show_tabline = true,
          globalstatus = false,
          refresh = {
            statusline = 100,
            tabline = 100,
            winbar = 100,
          },
        },
        sections = {
          lualine_a = {
            {
              'mode',
              color = function()
                --- Map each mode to a Tokyo Night inspired background color.
                local mode_colors = {
                  n = '#7aa2f7', -- Normal (blue)
                  i = '#9ece6a', -- Insert (green)
                  v = '#bb9af7', -- Visual (purple)
                  V = '#bb9af7', -- Visual line (purple)
                  [''] = '#bb9af7', -- Visual block (purple)
                  c = '#e0af68', -- Command (orange)
                  R = '#f7768e', -- Replace (red)
                  t = '#7aa2f7', -- Terminal (blue)
                }
                local mode = vim.fn.mode()
                return { fg = '#ffffff', bg = mode_colors[mode] or '#7aa2f7' }
              end,
            },
          },
          lualine_b = {},
          lualine_c = {
            {
              'filename',
              path = 1,
              symbols = {
                modified = '[+]', -- Text to show when the file is modified.
                readonly = '[-]', -- Text to show when the file is non-modifiable or readonly.
                unnamed = '[No Name]', -- Text to show for unnamed buffers.
                newfile = '[New]', -- Text to show for newly created file before first write
              },
            },
          },
          lualine_x = {},
          lualine_y = {},
          lualine_z = { 'location' },
        },
        tabline = {},
      }
    end,
  },
  {
    'supermaven-inc/supermaven-nvim',
    lazy = false,
    opts = {
      keymaps = {
        accept_suggestion = '<C-y>',
        clear_suggestion = '<C-]>',
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
  {
    'karb94/neoscroll.nvim',
    config = function()
      local neoscroll = require 'neoscroll'
      neoscroll.setup()
      local keymap = {
        -- Use the "sine" easing function
        ['<C-u>'] = function()
          neoscroll.ctrl_u { duration = 250, easing = 'sine' }
        end,
        ['<C-d>'] = function()
          neoscroll.ctrl_d { duration = 250, easing = 'sine' }
        end,
        -- Use the "circular" easing function
        ['<C-b>'] = function()
          neoscroll.ctrl_b { duration = 450, easing = 'circular' }
        end,
        ['<C-f>'] = function()
          neoscroll.ctrl_f { duration = 450, easing = 'circular' }
        end,
        -- When no value is passed the `easing` option supplied in `setup()` is used
        ['<C-y>'] = function()
          neoscroll.scroll(-0.1, { move_cursor = false, duration = 100 })
        end,
        ['<C-e>'] = function()
          neoscroll.scroll(0.1, { move_cursor = false, duration = 100 })
        end,
      }
      local modes = { 'n', 'v', 'x' }
      for key, func in pairs(keymap) do
        vim.keymap.set(modes, key, func)
      end
    end,
  },
}
