-- UI plugins: bufferline, lualine, alpha dashboard, notify, dressing

-- Bufferline (top tabs)
require('bufferline').setup({
  options = {
    mode = 'buffers',
    numbers = 'ordinal',
    close_command = 'bdelete! %d',
    diagnostics = 'nvim_lsp',
    show_buffer_close_icons = true,
    show_close_icon = false,
    separator_style = 'thin',
    offsets = {{ filetype = 'NvimTree', text = 'Explorer', highlight = 'Directory' }},
  },
})

-- Lualine (status bar)
require('lualine').setup({
  options = {
    theme = 'auto',
    component_separators = '|',
    section_separators = "",
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
})

-- Alpha (dashboard on startup)
local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')

dashboard.section.header.val = {
  '                                   ',
  '   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣭⣿⣶⣿⣦⣼⣆         ',
  '    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ',
  '          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷⠄⠄⠄⠄⠻⠿⢿⣿⣧⣄     ',
  '           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ',
  '          ⢠⣿⣿⣿⠈  ⠡⠌⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ',
  '   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘⠄ ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ',
  '  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ',
  ' ⣠⣿⠿⠛⠄⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ',
  ' ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇⠄⠛⠻⢷⣄ ',
  '      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     ',
  '       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ',
  '                                   ',
  '         N E O V I M               ',
}

dashboard.section.buttons.val = {
  dashboard.button('f', '  Find file', ':Telescope find_files<CR>'),
  dashboard.button('e', '  New file', ':ene <BAR> startinsert<CR>'),
  dashboard.button('r', '  Recent files', ':Telescope oldfiles<CR>'),
  dashboard.button('g', '  Find text', ':Telescope live_grep<CR>'),
  dashboard.button('c', '  Config', ':e ~/HyprForge/home/programs/neovim/neovim.nix<CR>'),
  dashboard.button('q', '  Quit', ':qa<CR>'),
}

alpha.setup(dashboard.config)

-- Notify (notifications)
vim.notify = require('notify')

-- Dressing (better UI for inputs/selects)
require('dressing').setup()
