---@diagnostic disable: undefined-global, unused-local
local opt = vim.opt
local g = vim.g
local o = vim.o

-- Get neovim version
if vim.fn.has('nvim-0.12') == 1 then
  o.pumborder = 'single'
end

-- Relative line numbers
o.number = true
o.numberwidth = 4
o.relativenumber = true

-- Sign column
o.signcolumn = 'yes:1'

-- Highlight 80 column to encourage line length limit
o.colorcolumn = '80'

-- Color scheme and appearance
o.background = 'dark'
o.termguicolors = true
o.winblend = 0
o.pumblend = 0

-- Highlight current line and line number
o.cursorline = true
o.cursorlineopt = 'both'

-- Tabs and indentation
o.shiftwidth = 2
o.smartindent = true
o.expandtab = true
o.tabstop = 2

-- Special characters display
o.list = true
o.listchars = [[trail:·,tab:» ]]
o.fillchars = [[eob: ,fold: ,foldopen:▾,foldsep: ,foldclose:▸]]

-- Word wrapping and navigation across lines
o.whichwrap = '<,>'
o.wrap = false

-- Splitting behavior
o.splitbelow = true
o.splitright = true

-- Scroll 'buffers'
o.sidescrolloff = 8
o.scrolloff = 8

-- Key sequence timeout
o.timeoutlen = 400

-- Save undo history to an undo file
o.undofile = true

-- `+` for default clipboard register
o.clipboard = 'unnamedplus'

-- Folding settings using Treesitter
o.foldenable = true
o.foldlevel = 99
o.foldlevelstart = 99
o.foldmethod = 'expr'
o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
o.ruler = false
o.foldcolumn = '0'

local function fold_virt_text(result, s, lnum, coloff)
  if not coloff then
    coloff = 0
  end
  local text = ''
  local hl
  for i = 1, #s do
    local char = s:sub(i, i)
    local hls = vim.treesitter.get_captures_at_pos(0, lnum, coloff + i - 1)
    local _hl = hls[#hls]
    if _hl then
      local new_hl = '@' .. _hl.capture
      if new_hl ~= hl then
        table.insert(result, { text, hl })
        text = ''
        hl = nil
      end
      text = text .. char
      hl = new_hl
    else
      text = text .. char
    end
  end
  table.insert(result, { text, hl })
end

function _G.custom_foldtext()
  local start = vim.fn.getline(vim.v.foldstart):gsub('\t', string.rep(' ', vim.o.tabstop))
  local end_str = vim.fn.getline(vim.v.foldend)
  local end_ = vim.trim(end_str)
  local result = {}
  local lines = vim.v.foldend - vim.v.foldstart
  fold_virt_text(result, start, vim.v.foldstart - 1)
  table.insert(result, { ' ... ', 'Comment' })
  fold_virt_text(result, end_, vim.v.foldend - 1, #(end_str:match '^(%s+)' or ''))
  table.insert(result, { '  (' .. lines .. ' lines)  ', 'FoldCount' })
  return result
end

o.foldtext = 'v:lua.custom_foldtext()'

-- Session options
o.sessionoptions = 'buffers,curdir,folds,tabpages'

-- Quickfix and location list formatting
local fn = vim.fn

function _G.qftf(info)
  local items
  local ret = {}

  if info.quickfix == 1 then
    items = fn.getqflist({ id = info.id, items = 0 }).items
  else
    items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end
  local limit = 31
  local fnameFmt1, fnameFmt2 = '%-' .. limit .. 's', '…%.' .. (limit - 1) .. 's'
  local validFmt = '%s │%4d:%-3d│%s %s'
  for i = info.start_idx, info.end_idx do
    local e = items[i]
    local fname = ''
    local str
    if e.valid == 1 then
      if e.bufnr > 0 then
        fname = fn.bufname(e.bufnr)
        if fname == '' then
          fname = '[No Name]'
        else
          fname = fname:gsub('^' .. vim.env.HOME, '~')
        end
        -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
        if #fname <= limit then
          fname = fnameFmt1:format(fname)
        else
          fname = fnameFmt2:format(fname:sub(1 - limit))
        end
      end
      local lnum = e.lnum > 99999 and -1 or e.lnum
      local col = e.col > 999 and -1 or e.col
      local qtype = e.type == '' and '' or ' ' .. e.type:sub(1, 1):upper()
      str = validFmt:format(fname, lnum, col, qtype, e.text)
    else
      str = e.text
    end
    table.insert(ret, str)
  end
  return ret
end

vim.o.qftf = '{info -> v:lua._G.qftf(info)}'

