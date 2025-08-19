return {
  {
    'gmr458/vscode_modern_theme.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('vscode_modern').setup {
        cursorline = true,
        transparent_background = false,
        nvim_tree_darker = true,
      }
      -- vim.cmd.colorscheme 'vscode_modern'
    end,
  },
  -- ==========================================
  -- Themes
  -- ==========================================
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme 'gruvbox'
    end,
  },
  {
    'rose-pine/neovim',
    priority = 1000,
    name = 'rose-pine',
    config = function()
      -- vim.cmd 'colorscheme rose-pine'
    end,
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'tokyonight'
    end,
  },
  {
    'olivercederborg/poimandres.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('poimandres').setup {
        -- leave this setup function empty for default config
        -- or refer to the configuration section
        -- for configuration options
      }
    end,

    -- optionally set the colorscheme within lazy config
    init = function()
      -- vim.cmd 'colorscheme poimandres'
    end,
  },
  {
    'shaunsingh/nord.nvim',
    priority = 1000,
  },
  { 'EdenEast/nightfox.nvim', priority = 1000 },
  {
    'zaldih/themery.nvim',
    lazy = false,
    config = function()
      require('themery').setup {
        themes = { 'nightfox', 'dawnfox', 'terafox', 'carbonfox', 'duskfox', 'nordfox', 'vscode_modern', 'tokyonight', 'rose-pine', 'poimandres', 'nord' },
        livePreview = true,
      }
    end,
  },
}
