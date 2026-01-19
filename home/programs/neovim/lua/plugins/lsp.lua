-- LSP configuration: lspconfig, lspsaga, completion (nvim-cmp), Copilot

-- ============================================
-- COPILOT SETUP
-- ============================================
local copilot_ok, copilot = pcall(require, 'copilot')
if copilot_ok then
  copilot.setup({
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = '<Tab>',
        accept_word = false,
        accept_line = false,
        next = '<M-]>',
        prev = '<M-[>',
        dismiss = '<C-]>',
      },
    },
    panel = {
      enabled = true,
      auto_refresh = false,
      keymap = {
        jump_prev = '[[',
        jump_next = ']]',
        accept = '<CR>',
        refresh = 'gr',
        open = '<M-CR>',
      },
    },
    filetypes = {
      yaml = true,
      markdown = true,
      help = false,
      gitcommit = true,
      gitrebase = true,
      hgcommit = false,
      svn = false,
      cvs = false,
      ['.'] = false,
    },
  })
end

-- ============================================
-- LSP SAGA (nice LSP UI)
-- ============================================
require('lspsaga').setup({
  symbol_in_winbar = { enable = false },
  lightbulb = { enable = false },
  ui = { border = 'rounded' },
})

-- ============================================
-- COMPLETION SETUP (nvim-cmp)
-- ============================================
local cmp = require('cmp')
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()

-- Try to load copilot-cmp if available
local has_copilot_cmp = pcall(require, 'copilot_cmp')
if has_copilot_cmp then
  require('copilot_cmp').setup()
end

cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'copilot', group_index = 2 },
    { name = 'nvim_lsp', group_index = 2 },
    { name = 'luasnip', group_index = 2 },
    { name = 'buffer', group_index = 2 },
    { name = 'path', group_index = 2 },
  }),
})

-- LSP setup (using native vim.lsp.config API for Neovim 0.11+)
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Common LSP on_attach
local on_attach = function(client, bufnr)
  -- LSP keybindings are set in keybindings.lua via which-key
end

-- Language servers (add more as needed)
local servers = { 'nixd', 'pyright', 'lua_ls', 'rust_analyzer', 'ts_ls' }

-- Configure each server
for _, server in ipairs(servers) do
  vim.lsp.config(server, {
    capabilities = capabilities,
    on_attach = on_attach,
  })
end

-- Enable all configured servers
vim.lsp.enable(servers)
