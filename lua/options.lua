---@diagnostic disable: undefined-global
local opt = vim.opt
local g = vim.g
local o = vim.o

-- Get neovim version
if vim.fn.has("nvim-0.12") == 1 then
  o.pumborder = "single"
end

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
-- opt.wildmenu = true
-- opt.laststatus = 2
opt.colorcolumn = '80'
-- opt.completeopt = 'preinsert'
-- opt.cmdheight = 0

o.background = "dark"
opt.termguicolors = true
opt.winblend = 0
opt.pumblend = 0

opt.cursorline = true
opt.cursorlineopt = "both"
opt.shiftwidth = 2
opt.smartindent = true
opt.expandtab = true
opt.tabstop = 2

opt.list = true
opt.listchars = { trail = "·", tab = "» " }
opt.whichwrap = "<,>"
opt.wrap = false
o.fillchars = [[eob: ,fold: ,foldopen:▾,foldsep: ,foldclose:▸]]

o.splitbelow = true
o.splitright = true

o.timeoutlen = 400
o.undofile = true

o.clipboard = "unnamedplus"
o.foldenable = true
o.foldlevel = 99
o.foldlevelstart = 99
o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldtext = "???"
o.number = true
o.numberwidth = 4
o.ruler = false
o.signcolumn = "yes"
o.sessionoptions = "buffers,curdir,folds,tabpages"

opt.foldcolumn = "0"
opt.fillchars:append { fold = " " }

local function fold_virt_text(result, s, lnum, coloff)
  if not coloff then
    coloff = 0
  end
  local text = ""
  local hl
  for i = 1, #s do
    local char = s:sub(i, i)
    local hls = vim.treesitter.get_captures_at_pos(0, lnum, coloff + i - 1)
    local _hl = hls[#hls]
    if _hl then
      local new_hl = "@" .. _hl.capture
      if new_hl ~= hl then
        table.insert(result, { text, hl })
        text = ""
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
  local start = vim.fn.getline(vim.v.foldstart):gsub("\t", string.rep(" ", vim.o.tabstop))
  local end_str = vim.fn.getline(vim.v.foldend)
  local end_ = vim.trim(end_str)
  local result = {}
  local lines = vim.v.foldend - vim.v.foldstart
  fold_virt_text(result, start, vim.v.foldstart - 1)
  table.insert(result, { " ... ", "Comment" })
  fold_virt_text(result, end_, vim.v.foldend - 1, #(end_str:match "^(%s+)" or ""))
  table.insert(result, { "  (" .. lines .. " lines)  ", "FoldCount" })
  return result
end

opt.foldtext = "v:lua.custom_foldtext()"

