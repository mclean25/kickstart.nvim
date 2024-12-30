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
        accept_suggestion = '<Tab>',
        clear_suggestion = '<C-]>',
        accept_word = '<C-j>',
      },
    },
  },
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = true,
    vim.keymap.set('n', '<leader>`', ':ToggleTerm<CR>'),
  },
}
