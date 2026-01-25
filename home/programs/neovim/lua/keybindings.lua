-- Keybindings configuration
-- Clean, organized keybindings following the central keybindings system
-- Space is the leader key for vim-style commands (discoverable via which-key)

-- ============================================
-- LEADER KEY - MUST BE SET FIRST!
-- ============================================
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Import centrally-defined keybindings from keys.lua (generated from keybindings.nix)
local status_ok, keys = pcall(require, 'keys')
if not status_ok then
  vim.notify('Failed to load keys.lua - using fallback keybindings', vim.log.levels.WARN)
  keys = { help = { shortcuts = '<C-F1>' } } -- Minimal fallback
end

local map = vim.keymap.set

-- ============================================
-- HELP (Ctrl+F1 - Universal help shortcut)
-- ============================================
if keys.help and keys.help.shortcuts then
  map('n', keys.help.shortcuts, ':Telescope keymaps<CR>', { desc = 'Show all keybindings' })
end

-- ============================================
-- SAVE (Ctrl+S)
-- ============================================
if keys.editing then
  map('n', keys.editing.save, ':w<CR>', { desc = 'Save file' })
  map('i', keys.editing.save, '<Esc>:w<CR>a', { desc = 'Save file (insert mode)' })
  map('n', keys.editing.saveAll, ':wa<CR>', { desc = 'Save all' })

  -- Standard cut/copy/paste (alongside vim defaults)
  if keys.editing.cut then
    map('v', keys.editing.cut, '"+x', { desc = 'Cut to clipboard' })
    map('n', keys.editing.cut, '"+dd', { desc = 'Cut line to clipboard' })
  end
  if keys.editing.copy then
    map('v', keys.editing.copy, '"+y', { desc = 'Copy to clipboard' })
    map('n', keys.editing.copy, '"+yy', { desc = 'Copy line to clipboard' })
  end
  if keys.editing.paste then
    map('n', keys.editing.paste, '"+p', { desc = 'Paste from clipboard' })
    map('v', keys.editing.paste, '"+p', { desc = 'Paste from clipboard' })
    map('i', keys.editing.paste, '<C-r>+', { desc = 'Paste from clipboard' })
  end
  if keys.editing.undo then
    map('n', keys.editing.undo, 'u', { desc = 'Undo' })
  end
  if keys.editing.redo then
    map('n', keys.editing.redo, '<C-r>', { desc = 'Redo' })
  end
end

-- ============================================
-- FIND/SEARCH (Ctrl+P, Ctrl+Shift+F, etc.)
-- ============================================
if keys.navigation then
  if keys.navigation.goToFile then
    map('n', keys.navigation.goToFile, ':Telescope find_files<CR>', { desc = 'Find files' })
  end
  if keys.navigation.commandPalette then
    map('n', keys.navigation.commandPalette, ':Telescope commands<CR>', { desc = 'Command palette' })
  end
  if keys.navigation.find then
    map('n', keys.navigation.find, '/', { desc = 'Find in file' })
  end
  if keys.navigation.findInFiles then
    map('n', keys.navigation.findInFiles, ':Telescope live_grep<CR>', { desc = 'Fuzzy search in files' })
  end
  if keys.navigation.goToSymbol then
    map('n', keys.navigation.goToSymbol, ':Telescope lsp_document_symbols<CR>', { desc = 'Go to symbol' })
  end
end
-- Fuzzy search in current buffer (Ctrl+/)
map('n', '<C-_>', ':Telescope current_buffer_fuzzy_find<CR>', { desc = 'Fuzzy search in buffer' })
map('n', '<C-/>', ':Telescope current_buffer_fuzzy_find<CR>', { desc = 'Fuzzy search in buffer' })
map('n', '<C-S-f>', ':Telescope live_grep<CR>', { desc = 'Find in files' })
-- Go to line with : (standard vim)
map('n', '<C-g>', ':', { desc = 'Go to line' })

-- ============================================
-- PANELS (Ctrl+1/2/3 toggle, Ctrl+Shift+1/2/3 focus)
-- ============================================
if keys.panels then
  map('n', keys.panels.left, ':NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
  map('n', keys.panels.bottom, ':ToggleTerm<CR>', { desc = 'Toggle terminal' })
  map('n', keys.panels.focusLeft, ':NvimTreeFocus<CR>', { desc = 'Focus file explorer' })
  map('n', keys.panels.focusEditor, '<C-w>p', { desc = 'Focus editor' })
  map('t', keys.panels.bottom, [[<C-\><C-n>:ToggleTerm<CR>]], { desc = 'Toggle terminal (from terminal)' })
end

-- Terminal mode: Escape to normal mode
map('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })

-- ============================================
-- TABS/BUFFERS (Ctrl+W close, Alt+Shift+1-9 goto)
-- ============================================
if keys.tabs then
  map('n', keys.tabs.close, ':bdelete<CR>', { desc = 'Close buffer/tab' })
  map('n', keys.tabs.next, ':BufferLineCycleNext<CR>', { desc = 'Next buffer' })
  map('n', keys.tabs.prev, ':BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })

  -- Direct buffer navigation (Alt+Shift+1-9)
  map('n', keys.tabs.goto1, ':BufferLineGoToBuffer 1<CR>', { desc = 'Go to buffer 1' })
  map('n', keys.tabs.goto2, ':BufferLineGoToBuffer 2<CR>', { desc = 'Go to buffer 2' })
  map('n', keys.tabs.goto3, ':BufferLineGoToBuffer 3<CR>', { desc = 'Go to buffer 3' })
  map('n', keys.tabs.goto4, ':BufferLineGoToBuffer 4<CR>', { desc = 'Go to buffer 4' })
  map('n', keys.tabs.goto5, ':BufferLineGoToBuffer 5<CR>', { desc = 'Go to buffer 5' })
  map('n', keys.tabs.goto6, ':BufferLineGoToBuffer 6<CR>', { desc = 'Go to buffer 6' })
  map('n', keys.tabs.goto7, ':BufferLineGoToBuffer 7<CR>', { desc = 'Go to buffer 7' })
  map('n', keys.tabs.goto8, ':BufferLineGoToBuffer 8<CR>', { desc = 'Go to buffer 8' })
  map('n', keys.tabs.goto9, ':BufferLineGoToBuffer 9<CR>', { desc = 'Go to buffer 9' })
end

-- ============================================
-- WINDOW NAVIGATION (Alt+hjkl or Alt+Arrows)
-- Note: Using Alt instead of Ctrl since Ctrl+W closes tabs
-- ============================================
map('n', '<A-h>', '<C-w>h', { desc = 'Focus window left' })
map('n', '<A-j>', '<C-w>j', { desc = 'Focus window down' })
map('n', '<A-k>', '<C-w>k', { desc = 'Focus window up' })
map('n', '<A-l>', '<C-w>l', { desc = 'Focus window right' })

map('n', '<A-Left>', '<C-w>h', { desc = 'Focus window left' })
map('n', '<A-Down>', '<C-w>j', { desc = 'Focus window down' })
map('n', '<A-Up>', '<C-w>k', { desc = 'Focus window up' })
map('n', '<A-Right>', '<C-w>l', { desc = 'Focus window right' })

-- ============================================
-- WINDOW RESIZE (Ctrl+Shift+hjkl matching panel grow/shrink)
-- Inspired by Hyprland's Super+Shift+hjkl for window resizing
-- ============================================
if keys.vimApps then
  -- Grow/resize window in direction (Ctrl+Shift+hjkl)
  map('n', '<C-S-h>', ':vertical resize -5<CR>', { desc = 'Grow/resize window left' })
  map('n', '<C-S-j>', ':resize +5<CR>', { desc = 'Grow/resize window down' })
  map('n', '<C-S-k>', ':resize -5<CR>', { desc = 'Grow/resize window up' })
  map('n', '<C-S-l>', ':vertical resize +5<CR>', { desc = 'Grow/resize window right' })

  -- Shrink window (Ctrl+Alt+Shift+hjkl)
  map('n', '<C-A-S-h>', ':vertical resize +5<CR>', { desc = 'Shrink window from left' })
  map('n', '<C-A-S-j>', ':resize -5<CR>', { desc = 'Shrink window from bottom' })
  map('n', '<C-A-S-k>', ':resize +5<CR>', { desc = 'Shrink window from top' })
  map('n', '<C-A-S-l>', ':vertical resize -5<CR>', { desc = 'Shrink window from right' })
else
  -- Fallback window resize (Ctrl+Alt+hjkl)
  map('n', '<C-A-h>', ':vertical resize -2<CR>', { desc = 'Shrink window left' })
  map('n', '<C-A-l>', ':vertical resize +2<CR>', { desc = 'Expand window right' })
  map('n', '<C-A-k>', ':resize -2<CR>', { desc = 'Shrink window up' })
  map('n', '<C-A-j>', ':resize +2<CR>', { desc = 'Expand window down' })

  map('n', '<C-A-Left>', ':vertical resize -2<CR>', { desc = 'Shrink window left' })
  map('n', '<C-A-Right>', ':vertical resize +2<CR>', { desc = 'Expand window right' })
  map('n', '<C-A-Up>', ':resize -2<CR>', { desc = 'Shrink window up' })
  map('n', '<C-A-Down>', ':resize +2<CR>', { desc = 'Expand window down' })
end

-- ============================================
-- VIM-SPECIFIC KEYBINDINGS (from vimApps section)
-- ============================================
if keys.vimApps then
  -- Tab management (Neovim buffers = tabs)
  -- Standard vim: gt/gT for tab navigation
  map('n', 'gt', ':BufferLineCycleNext<CR>', { desc = 'Next buffer/tab' })
  map('n', 'gT', ':BufferLineCyclePrev<CR>', { desc = 'Previous buffer/tab' })
  map('n', 'g0', ':BufferLineGoToBuffer 1<CR>', { desc = 'First buffer/tab' })
  map('n', 'g$', ':BufferLineGoToBuffer -1<CR>', { desc = 'Last buffer/tab' })

  -- Alternative tab navigation with Shift+J/K
  map('n', '<S-j>', ':BufferLineCycleNext<CR>', { desc = 'Next buffer/tab (Shift+J)' })
  map('n', '<S-k>', ':BufferLineCyclePrev<CR>', { desc = 'Previous buffer/tab (Shift+K)' })

  -- Close tab with 'x' (in addition to Ctrl+W)
  map('n', 'x', ':bdelete<CR>', { desc = 'Close buffer/tab' })

  -- New tab with 't' (like Yazi/Vimium)
  map('n', 't', ':tabnew<CR>', { desc = 'New tab' })

  -- Split management from vimApps
  if keys.vimApps.splitVertical then
    -- Note: In neovim, Ctrl+\ doesn't work well, using Ctrl+Backslash
    map('n', '<C-\\>', ':vsplit<CR>', { desc = 'Split vertical' })
  end
  if keys.vimApps.splitHorizontal then
    map('n', '<C-S-\\>', ':split<CR>', { desc = 'Split horizontal' })
  end
end

-- ============================================
-- LINE OPERATIONS (Alt+Shift+Up/Down)
-- ============================================
if keys.editing then
  -- Move lines
  map('n', keys.editing.moveLineUp, ':m .-2<CR>==', { desc = 'Move line up' })
  map('n', keys.editing.moveLineDown, ':m .+1<CR>==', { desc = 'Move line down' })
  map('i', keys.editing.moveLineUp, '<Esc>:m .-2<CR>==gi', { desc = 'Move line up' })
  map('i', keys.editing.moveLineDown, '<Esc>:m .+1<CR>==gi', { desc = 'Move line down' })
  map('v', keys.editing.moveLineUp, ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
  map('v', keys.editing.moveLineDown, ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })

  -- Copy/duplicate lines
  if keys.editing.copyLineUp then
    map('n', keys.editing.copyLineUp, ':t.-1<CR>', { desc = 'Copy line up' })
    map('n', keys.editing.copyLineDown, ':t.<CR>', { desc = 'Copy line down' })
  end
end

-- ============================================
-- AI / COPILOT (Ctrl+Alt+I for chat)
-- ============================================
if keys.ai and keys.ai.chat then
  map('n', keys.ai.chat, '<cmd>lua vim.fn.feedkeys(":Copilot ")<CR>', { desc = 'Copilot command' })
  map('i', keys.ai.chat, '<cmd>lua vim.fn.feedkeys(":Copilot ")<CR>', { desc = 'Copilot command' })
end

-- Copilot accept suggestion (Tab in insert mode, handled by copilot plugin)
-- Copilot panel (Ctrl+Enter to open suggestions)
map('i', '<C-CR>', '<cmd>Copilot panel<CR>', { desc = 'Copilot suggestions panel' })

-- ============================================
-- LEADER KEY MAPPINGS (Space + key)
-- Press Space and wait to see all options via which-key
-- ============================================

local wk_ok, wk = pcall(require, 'which-key')
if wk_ok then
  wk.setup({
    plugins = {
      spelling = { enabled = true },
    },
    win = {
      border = 'rounded',
    },
  })

  wk.add({
    -- File operations
    { '<leader>w', ':w<CR>', desc = 'Save file' },
    { '<leader>W', ':wa<CR>', desc = 'Save all files' },
    { '<leader>q', ':q<CR>', desc = 'Quit window' },
    { '<leader>Q', ':qa<CR>', desc = 'Quit all' },
    { '<leader>x', ':x<CR>', desc = 'Save & quit' },

    -- Find/Search
    { '<leader>f', group = 'Find' },
    { '<leader>ff', ':Telescope find_files<CR>', desc = 'Find files' },
    { '<leader>fg', ':Telescope live_grep<CR>', desc = 'Grep in files' },
    { '<leader>fb', ':Telescope buffers<CR>', desc = 'Find buffers' },
    { '<leader>fh', ':Telescope help_tags<CR>', desc = 'Help tags' },
    { '<leader>fr', ':Telescope oldfiles<CR>', desc = 'Recent files' },
    { '<leader>fc', ':Telescope commands<CR>', desc = 'Commands' },
    { '<leader>fs', ':Telescope lsp_document_symbols<CR>', desc = 'Document symbols' },
    { '<leader>fk', ':Telescope keymaps<CR>', desc = 'Keymaps' },

    -- Buffer/Tab operations
    { '<leader>b', group = 'Buffers' },
    { '<leader>bd', ':bdelete<CR>', desc = 'Delete buffer' },
    { '<leader>bn', ':bnext<CR>', desc = 'Next buffer' },
    { '<leader>bp', ':bprevious<CR>', desc = 'Previous buffer' },
    { '<leader>bl', ':Telescope buffers<CR>', desc = 'List buffers' },
    { '<leader>bw', ':bwipeout<CR>', desc = 'Wipeout buffer' },

    -- File Explorer
    { '<leader>e', ':NvimTreeToggle<CR>', desc = 'Toggle file explorer' },
    { '<leader>E', ':NvimTreeFocus<CR>', desc = 'Focus file explorer' },

    -- Git
    { '<leader>g', group = 'Git' },
    { '<leader>gg', ':LazyGit<CR>', desc = 'LazyGit' },
    { '<leader>gs', ':Telescope git_status<CR>', desc = 'Git status' },
    { '<leader>gc', ':Telescope git_commits<CR>', desc = 'Git commits' },
    { '<leader>gb', ':Telescope git_branches<CR>', desc = 'Git branches' },
    { '<leader>gd', ':Gitsigns diffthis<CR>', desc = 'Diff this' },
    { '<leader>gp', ':Gitsigns preview_hunk<CR>', desc = 'Preview hunk' },
    { '<leader>gr', ':Gitsigns reset_hunk<CR>', desc = 'Reset hunk' },
    { '<leader>gS', ':Gitsigns stage_hunk<CR>', desc = 'Stage hunk' },
    { '<leader>gu', ':Gitsigns undo_stage_hunk<CR>', desc = 'Undo stage hunk' },
    { '<leader>gR', ':Gitsigns reset_buffer<CR>', desc = 'Reset buffer' },
    { '<leader>gB', ':Gitsigns blame_line<CR>', desc = 'Blame line' },

    -- LSP (Language Server Protocol)
    { '<leader>l', group = 'LSP' },
    { '<leader>ld', ':Lspsaga peek_definition<CR>', desc = 'Peek definition' },
    { '<leader>lD', ':Lspsaga goto_definition<CR>', desc = 'Go to definition' },
    { '<leader>lr', ':Lspsaga rename<CR>', desc = 'Rename symbol' },
    { '<leader>la', ':Lspsaga code_action<CR>', desc = 'Code actions' },
    { '<leader>lf', ':lua vim.lsp.buf.format()<CR>', desc = 'Format document' },
    { '<leader>lh', ':Lspsaga hover_doc<CR>', desc = 'Hover documentation' },
    { '<leader>ls', ':Lspsaga outline<CR>', desc = 'Symbols outline' },
    { '<leader>lR', ':Telescope lsp_references<CR>', desc = 'Find references' },
    { '<leader>le', ':Telescope diagnostics<CR>', desc = 'Show diagnostics' },
    { '<leader>ln', ':Lspsaga diagnostic_jump_next<CR>', desc = 'Next diagnostic' },
    { '<leader>lp', ':Lspsaga diagnostic_jump_prev<CR>', desc = 'Previous diagnostic' },

    -- Copilot / AI
    { '<leader>c', group = 'Copilot' },
    { '<leader>ce', ':Copilot enable<CR>', desc = 'Enable Copilot' },
    { '<leader>cd', ':Copilot disable<CR>', desc = 'Disable Copilot' },
    { '<leader>cp', ':Copilot panel<CR>', desc = 'Copilot panel' },
    { '<leader>cs', ':Copilot status<CR>', desc = 'Copilot status' },

    -- Split/Window management
    { '<leader>v', ':vsplit<CR>', desc = 'Split vertical' },
    { '<leader>h', ':split<CR>', desc = 'Split horizontal' },
    { '<leader>o', ':only<CR>', desc = 'Close other windows' },

    -- Terminal
    { '<leader>`', ':ToggleTerm<CR>', desc = 'Toggle terminal' },
    { '<leader>t', group = 'Terminal' },
    { '<leader>tt', ':ToggleTerm<CR>', desc = 'Toggle terminal' },
    { '<leader>tf', ':ToggleTerm direction=float<CR>', desc = 'Floating terminal' },
    { '<leader>tv', ':ToggleTerm direction=vertical size=60<CR>', desc = 'Vertical terminal' },
    { '<leader>th', ':ToggleTerm direction=horizontal<CR>', desc = 'Horizontal terminal' },

    -- Quick shortcuts
    { '<leader>/', ':Telescope live_grep<CR>', desc = 'Search in files' },
    { '<leader>?', ':Telescope keymaps<CR>', desc = 'Show keymaps' },
    { '<leader><space>', ':Telescope find_files<CR>', desc = 'Find files' },
  })
end

-- ============================================
-- QUALITY OF LIFE IMPROVEMENTS
-- ============================================

-- Keep cursor centered when scrolling
map('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down (centered)' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up (centered)' })
map('n', 'n', 'nzzzv', { desc = 'Next match (centered)' })
map('n', 'N', 'Nzzzv', { desc = 'Previous match (centered)' })

-- Better indenting in visual mode (stay in visual mode)
map('v', '<', '<gv', { desc = 'Indent left' })
map('v', '>', '>gv', { desc = 'Indent right' })

-- Clear search highlight on Escape
map('n', '<Esc>', ':nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Don't yank on single character delete
map('n', 'x', '"_x', { desc = 'Delete character (no yank)' })
map('n', 'X', '"_X', { desc = 'Delete character backward (no yank)' })

-- Better paste (don't replace clipboard with deleted text)
map('v', 'p', '"_dP', { desc = 'Paste (keep clipboard)' })

-- Move to beginning/end of line
map('n', 'H', '^', { desc = 'Start of line' })
map('n', 'L', '$', { desc = 'End of line' })
map('v', 'H', '^', { desc = 'Start of line' })
map('v', 'L', '$', { desc = 'End of line' })

-- ============================================
-- LSP STANDARD MAPPINGS (gd, gr, K, etc.)
-- ============================================
map('n', 'gd', ':Lspsaga goto_definition<CR>', { desc = 'Go to definition' })
map('n', 'gD', ':lua vim.lsp.buf.declaration()<CR>', { desc = 'Go to declaration' })
map('n', 'gi', ':lua vim.lsp.buf.implementation()<CR>', { desc = 'Go to implementation' })
map('n', 'gr', ':Telescope lsp_references<CR>', { desc = 'Find references' })
map('n', 'K', ':Lspsaga hover_doc<CR>', { desc = 'Hover documentation' })
map('n', '<C-k>', ':lua vim.lsp.buf.signature_help()<CR>', { desc = 'Signature help' })
map('n', '[d', ':Lspsaga diagnostic_jump_prev<CR>', { desc = 'Previous diagnostic' })
map('n', ']d', ':Lspsaga diagnostic_jump_next<CR>', { desc = 'Next diagnostic' })
map('n', '[e', function() require('lspsaga.diagnostic'):goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, { desc = 'Previous error' })
map('n', ']e', function() require('lspsaga.diagnostic'):goto_next({ severity = vim.diagnostic.severity.ERROR }) end, { desc = 'Next error' })


-- ============================================
-- LEADER KEY MAPPINGS (Space + key)
-- Press Space and wait to see all options via which-key
-- ============================================

local wk = require('which-key')
wk.setup({
  plugins = {
    spelling = { enabled = true },
  },
  win = {
    border = 'rounded',
  },
})

wk.add({
  -- File operations
  { '<leader>w', ':w<CR>', desc = 'Save' },
  { '<leader>W', ':wa<CR>', desc = 'Save all' },
  { '<leader>q', ':q<CR>', desc = 'Quit' },
  { '<leader>Q', ':qa<CR>', desc = 'Quit all' },
  { '<leader>x', ':x<CR>', desc = 'Save & quit' },

  -- Find/Search
  { '<leader>f', group = 'Find' },
  { '<leader>ff', ':Telescope find_files<CR>', desc = 'Files' },
  { '<leader>fg', ':Telescope live_grep<CR>', desc = 'Grep' },
  { '<leader>fb', ':Telescope buffers<CR>', desc = 'Buffers' },
  { '<leader>fh', ':Telescope help_tags<CR>', desc = 'Help' },
  { '<leader>fr', ':Telescope oldfiles<CR>', desc = 'Recent' },
  { '<leader>fc', ':Telescope commands<CR>', desc = 'Commands' },
  { '<leader>fs', ':Telescope lsp_document_symbols<CR>', desc = 'Symbols' },

  -- Buffer/Tab operations
  { '<leader>b', group = 'Buffer' },
  { '<leader>bd', ':bdelete<CR>', desc = 'Delete buffer' },
  { '<leader>bn', ':bnext<CR>', desc = 'Next' },
  { '<leader>bp', ':bprevious<CR>', desc = 'Previous' },
  { '<leader>bl', ':Telescope buffers<CR>', desc = 'List' },

  -- Explorer
  { '<leader>e', ':NvimTreeToggle<CR>', desc = 'Explorer' },
  { '<leader>E', ':NvimTreeFocus<CR>', desc = 'Focus explorer' },

  -- Git
  { '<leader>g', group = 'Git' },
  { '<leader>gg', ':LazyGit<CR>', desc = 'LazyGit' },
  { '<leader>gs', ':Telescope git_status<CR>', desc = 'Status' },
  { '<leader>gc', ':Telescope git_commits<CR>', desc = 'Commits' },
  { '<leader>gb', ':Telescope git_branches<CR>', desc = 'Branches' },
  { '<leader>gd', ':Gitsigns diffthis<CR>', desc = 'Diff' },
  { '<leader>gp', ':Gitsigns preview_hunk<CR>', desc = 'Preview hunk' },
  { '<leader>gr', ':Gitsigns reset_hunk<CR>', desc = 'Reset hunk' },

  -- LSP (Language Server)
  { '<leader>l', group = 'LSP' },
  { '<leader>ld', ':Lspsaga peek_definition<CR>', desc = 'Definition' },
  { '<leader>lD', ':Lspsaga goto_definition<CR>', desc = 'Go to definition' },
  { '<leader>lr', ':Lspsaga rename<CR>', desc = 'Rename' },
  { '<leader>la', ':Lspsaga code_action<CR>', desc = 'Code action' },
  { '<leader>lf', ':lua vim.lsp.buf.format()<CR>', desc = 'Format' },
  { '<leader>lh', ':Lspsaga hover_doc<CR>', desc = 'Hover' },
  { '<leader>ls', ':Lspsaga outline<CR>', desc = 'Outline' },
  { '<leader>lR', ':Telescope lsp_references<CR>', desc = 'References' },
  { '<leader>le', ':Telescope diagnostics<CR>', desc = 'Diagnostics' },

  -- Split/Window management
  { '<leader>v', ':vsplit<CR>', desc = 'Split vertical' },
  { '<leader>h', ':split<CR>', desc = 'Split horizontal' },
  { '<leader>c', ':close<CR>', desc = 'Close window' },

  -- Terminal
  { '<leader>`', ':ToggleTerm<CR>', desc = 'Terminal' },
  { '<leader>t', group = 'Terminal' },
  { '<leader>tt', ':ToggleTerm<CR>', desc = 'Toggle' },
  { '<leader>tf', ':ToggleTerm direction=float<CR>', desc = 'Float' },
  { '<leader>tv', ':ToggleTerm direction=vertical size=60<CR>', desc = 'Vertical' },

  -- Misc
  { '<leader>/', ':Telescope live_grep<CR>', desc = 'Search in files' },
  { '<leader>?', ':Telescope keymaps<CR>', desc = 'Show keymaps' },
  { '<leader><space>', ':Telescope find_files<CR>', desc = 'Find files' },
})

-- ============================================
-- QUALITY OF LIFE
-- ============================================

-- Keep cursor centered when scrolling
map('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up' })
map('n', 'n', 'nzzzv', { desc = 'Next match (centered)' })
map('n', 'N', 'Nzzzv', { desc = 'Prev match (centered)' })

-- Better indenting in visual mode
map('v', '<', '<gv', { desc = 'Indent left' })
map('v', '>', '>gv', { desc = 'Indent right' })

-- Clear search highlight
map('n', '<Esc>', ':nohlsearch<CR>', { desc = 'Clear search' })

-- Quick pairs (jj, jk to exit insert mode - handled by better-escape plugin)

-- Don't yank on delete/change
map('n', 'x', '"_x', { desc = 'Delete char' })

-- LSP mappings (gd, K, etc. - standard vim LSP keys)
map('n', 'gd', ':Lspsaga goto_definition<CR>', { desc = 'Go to definition' })
map('n', 'gD', ':lua vim.lsp.buf.declaration()<CR>', { desc = 'Go to declaration' })
map('n', 'gr', ':Telescope lsp_references<CR>', { desc = 'References' })
map('n', 'K', ':Lspsaga hover_doc<CR>', { desc = 'Hover docs' })
map('n', '[d', ':Lspsaga diagnostic_jump_prev<CR>', { desc = 'Prev diagnostic' })
map('n', ']d', ':Lspsaga diagnostic_jump_next<CR>', { desc = 'Next diagnostic' })
