-- Editor enhancement plugins: treesitter, autopairs, comment, surround, indent-blankline, better-escape, neoscroll

-- Treesitter (syntax highlighting)
-- Note: treesitter is configured via nvim-treesitter.withAllGrammars in neovim.nix
-- Just enable the features here
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false -- Start with folds open

-- Autopairs (auto close brackets)
require('nvim-autopairs').setup()

-- Comment (gcc, gc in visual)
require('Comment').setup()

-- Surround (quotes, brackets manipulation)
require('nvim-surround').setup()

-- Indent blankline (indent guides)
require('ibl').setup({
  indent = { char = '│' },
  scope = { enabled = true },
})

-- Better escape (jj, jk to exit insert mode)
require('better_escape').setup({
  timeout = 200,
  mappings = {
    i = {
      j = {
        k = "<Esc>",
        j = "<Esc>",
      },
    },
  },
})

-- Neoscroll (smooth scrolling)
require('neoscroll').setup()
