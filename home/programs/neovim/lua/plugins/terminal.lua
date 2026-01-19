-- Terminal integration (toggleterm)
-- Bottom tabs: Ctrl+Alt+1-9 for terminal instances

require('toggleterm').setup({
  size = 15,
  open_mapping = [[<C-`>]],
  direction = 'horizontal',
  shade_terminals = true,
  persist_mode = true,
})

-- Create functions to toggle specific terminal instances
local Terminal = require('toggleterm.terminal').Terminal

-- Store terminal instances
_G.term_instances = {}

-- Function to get or create terminal instance
_G.get_or_create_term = function(num)
  if not _G.term_instances[num] then
    _G.term_instances[num] = Terminal:new({
      count = num,
      direction = 'horizontal',
      on_open = function(term)
        vim.cmd('startinsert!')
      end,
    })
  end
  return _G.term_instances[num]
end

-- Function to toggle specific terminal
_G.toggle_term = function(num)
  local term = _G.get_or_create_term(num)
  term:toggle()
end
