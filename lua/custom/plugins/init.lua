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
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
            neotree = { 'neo-tree', 'NeoTree' },
            harpoon = {},
            terminal = { 'toggleterm', 'toggleterm.nvim' },
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
                modified = '[+]', -- When file is modified.
                readonly = '[-]', -- When file is non-modifiable or readonly.
                unnamed = '[No Name]',
                newfile = '[New]',
              },
            },
          },
          lualine_x = {},
          lualine_y = {},
          lualine_z = { 'location' },
        },
        tabline = {
          -- lualine_a = {
          --   {
          --     'buffers',
          --     max_length = vim.o.columns * 2 / 3,
          --     mode = 0,
          --     separator = { left = '', right = '' },
          --     filetype_names = {
          --       TelescopePrompt = 'Telescope',
          --       dashboard = 'Dashboard',
          --       packer = 'Packer',
          --       fzf = 'FZF',
          --       alpha = 'Alpha',
          --     },
          --     filter = function(buf)
          --       -- Only show buffers that have unsaved changes.
          --       return vim.bo[buf].modified
          --     end,
          --     buffers_color = {
          --       active = { fg = '#c0caf5', bg = '#7aa2f7' },
          --       inactive = { fg = '#c0caf5', bg = '#1a1b26' },
          --     },
          --   },
          -- },
        },
      }
    end,
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
    event = 'VeryLazy',
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
    vim.keymap.set('n', '<leader>ex', '<CMD>Neotree action=show source=filesystem position=left toggle=true<CR>', { desc = 'Toggle Neo-tree' }),
    opts = {
      close_if_last_window = true,
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = true,
          hide_by_name = {
            'node_modules',
            '.git',
          },
          hide_by_pattern = {},
        },
      },
    },
  },
  {
    'petertriho/nvim-scrollbar',
    config = function()
      require('scrollbar').setup {
        show = true,
      }
    end,
  },
  {
    'ruifm/gitlinker.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitlinker').setup {
        opts = {
          remote = nil, -- force the use of a specific remote
          -- adds current line nr in the url for normal mode
          add_current_line_on_normal_mode = true,
          -- callback for what to do with the url
          action_callback = require('gitlinker.actions').copy_to_clipboard,
          -- print the url after performing the action
          print_url = true,
        },
        callbacks = {
          ['github.com'] = require('gitlinker.hosts').get_github_type_url,
          ['gitlab.com'] = require('gitlinker.hosts').get_gitlab_type_url,
          ['try.gitea.io'] = require('gitlinker.hosts').get_gitea_type_url,
          ['codeberg.org'] = require('gitlinker.hosts').get_gitea_type_url,
          ['bitbucket.org'] = require('gitlinker.hosts').get_bitbucket_type_url,
          ['try.gogs.io'] = require('gitlinker.hosts').get_gogs_type_url,
          ['git.sr.ht'] = require('gitlinker.hosts').get_srht_type_url,
          ['git.launchpad.net'] = require('gitlinker.hosts').get_launchpad_type_url,
          ['repo.or.cz'] = require('gitlinker.hosts').get_repoorcz_type_url,
          ['git.kernel.org'] = require('gitlinker.hosts').get_cgit_type_url,
          ['git.savannah.gnu.org'] = require('gitlinker.hosts').get_cgit_type_url,
        },
        mappings = '<leader>gl',
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
  -- Disabling because it doesnt' play nice with the scrollbar
  -- {
  --   'karb94/neoscroll.nvim',
  --   config = function()
  --     require('neoscroll').setup {
  --       mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
  --       hide_cursor = true,
  --       stop_eof = true,
  --       respect_scrolloff = false,
  --       cursor_scrolls_alone = true,
  --       easing_function = 'quadratic',
  --       pre_hook = nil,
  --       post_hook = nil,
  --       performance_mode = false,
  --     }
  --
  --     -- default is 250ms
  --     local t = {}
  --     t['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '110' } }
  --     t['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '110' } }
  --
  --     require('neoscroll.config').set_mappings(t)
  --   end,
  -- },
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'marilari88/neotest-vitest',
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require 'neotest-vitest' {
            filter_dir = function(name, rel_path, root)
              return name ~= 'node_modules'
            end,
            -- Handle your specific vitest config setup
            is_test_file = function(file_path)
              return string.match(file_path, '%.spec%.') or string.match(file_path, '%.test%.') or string.match(file_path, '%.integration%.')
            end,
            vitestConfigPath = function(root_dir)
              -- Look for your specific config files
              local configs = {
                'vitest.config.mts',
                'vitest.config.ts',
                'vitest.config.js',
                'vite.config.ts',
                'vite.config.js',
              }
              for _, config in ipairs(configs) do
                local config_path = root_dir .. '/' .. config
                if vim.fn.filereadable(config_path) == 1 then
                  return config_path
                end
              end
              return nil
            end,
            -- Set working directory to find package.json
            cwd = function(path)
              -- Walk up the directory tree to find package.json
              local current = path
              while current and current ~= '/' do
                if vim.fn.filereadable(current .. '/package.json') == 1 then
                  return current
                end
                current = vim.fn.fnamemodify(current, ':h')
              end
              return vim.fn.getcwd()
            end,
          },
        },
        output = {
          enabled = true,
          open_on_run = 'short',
        },
      }

      local neotest = require 'neotest'

      vim.keymap.set('n', '<leader>tt', function()
        neotest.run.run()
      end, { desc = '[T]est run nearest [T]est' })

      vim.keymap.set('n', '<leader>tf', function()
        neotest.run.run(vim.fn.expand '%')
      end, { desc = '[T]est run current [F]ile' })

      vim.keymap.set('n', '<leader>ts', function()
        neotest.run.run { suite = true }
      end, { desc = '[T]est run [S]uite' })

      vim.keymap.set('n', '<leader>to', function()
        neotest.output.open { enter = true }
      end, { desc = '[T]est [O]utput' })

      vim.keymap.set('n', '<leader>tp', function()
        neotest.output_panel.toggle()
      end, { desc = '[T]est output [P]anel' })
    end,
  },

  -- File History Plugin (local development)
  {
    dir = vim.fn.stdpath 'config' .. '/nvim-file-history',
    name = 'file-history-dev',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      local file_history = require 'nvim-file-history'
      local telescope_integration = require 'nvim-file-history.telescope'

      file_history.setup {
        max_history_size = 100,
        exclude_patterns = {
          '%.git/',
          'node_modules/',
          '%.cache/',
          '/tmp/',
          '^oil:/',
        },
        exclude_filetypes = {
          'help',
          'NvimTree',
          'neo-tree',
          'telescope',
          'lazy',
          'mason',
          'oil',
        },
      }

      -- Keybindings for file history
      vim.keymap.set('n', '<leader>b', telescope_integration.file_history_picker, { desc = 'File [B]ack history' })

      -- Commands
      vim.api.nvim_create_user_command('FileHistory', telescope_integration.file_history_picker, {})
    end,
  },
}
