-- File explorer configuration (nvim-tree)

require('nvim-tree').setup({
  view = { width = 35 },
  renderer = {
    group_empty = true,
    icons = { show = { folder_arrow = false } },
  },
  filters = { dotfiles = false },
  git = { enable = true, ignore = false },
})
