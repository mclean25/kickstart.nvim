-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
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
}
