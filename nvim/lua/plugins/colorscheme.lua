-- return {
--   { "connorholyday/vim-snazzy" },
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "snazzy",
--     },
--   },
-- }

return {
  {
    "alexwu/nvim-snazzy",
    dependencies = { "rktjmp/lush.nvim" },
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("snazzy")
    end,
  },
}


-- Plug 'tjdevries/colorbuddy.nvim'
-- Plug 'bbenzikry/snazzybuddy.nvim'

-- colorscheme snazzybuddy