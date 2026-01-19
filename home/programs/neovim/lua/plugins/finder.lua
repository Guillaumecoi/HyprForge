-- Fuzzy finder configuration (telescope)

local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['<C-q>'] = actions.close,
        ['<Esc>'] = actions.close,
      },
    },
    file_ignore_patterns = { 'node_modules', '.git/', '%.lock' },
  },
})

telescope.load_extension('fzf')
