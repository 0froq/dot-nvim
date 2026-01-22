-- File Name: useMap.lua
-- Last Modified: 2026-01-22 10:27:31
-- Line Count: 310
-- Git Status: unknown
--
-- Unified Keymap Mapper for Neovim + VSCode

local M = {}

---@class VSCodeCallOptions
---@field cmd string The VSCode command to call
---@field args table<string, any> Optional arguments for the command

---@class FuncConfig
---@field neovim string|function|table Neovim handler
---@field vscode string|VSCodeCallOptions|{cmd: string, args?: table, async?: boolean} VSCode handler
---@field use_call boolean Use VSCode.call (async) instead of VSCode.action

local function is_vscode()
  return vim.g.vscode == 1
end

---Parse various VSCode config formats into normalized structure
---@param vscode_config string|table
---@return {cmd: string, args: table?, async: boolean?}
local function parse_vscode_config(vscode_config)
  -- Case: simple string "commandId"
  if type(vscode_config) == 'string' then
    return { cmd = vscode_config }
  end

  -- Must be a table from here
  if type(vscode_config) ~= 'table' then
    error('Invalid vscode config type: ' .. type(vscode_config))
  end

  -- Case: { "cmd", ... } where second element can be various things
  if vscode_config[1] and type(vscode_config[1]) == 'string' then
    local result = { cmd = vscode_config[1] }
    local second = vscode_config[2]

    -- Helper function to check if a table contains only reserved keys
    local function is_reserved_only(tbl)
      for key, _ in pairs(tbl) do
        if key ~= 'async' and key ~= 'args' then
          return false
        end
      end
      return true
    end

    if second and type(second) == 'table' then
      -- { args = { ... } }
      if second.args then
        result.args = second.args
        -- Direct args like { line = 10, column = 5 }
        -- If table has keys other than 'async' and 'args', treat as args
      elseif not is_reserved_only(second) then
        result.args = second
      end

      -- Extract async flag if present (can be at root or in second element)
      if second.async ~= nil then
        result.async = second.async
      end
    end

    -- Check for async flag at root level (overrides nested one)
    if vscode_config.async ~= nil then
      result.async = vscode_config.async
    end

    return result
  end

  -- Case: { cmd = "...", args = { ... }, async = bool }
  if vscode_config.cmd then
    return {
      cmd = vscode_config.cmd,
      args = vscode_config.args,
      async = vscode_config.async
    }
  end

  error('Invalid vscode config structure')
end

---Execute VSCode action or call
---@param cmd string Command ID
---@param args table? Command arguments
---@param async boolean? Use async call instead of action
local function execute_vscode(cmd, args, async)
  local vscode = require('vscode')

  if async and vscode.call then
    -- Use async call
    vscode.call(cmd, args)
  else
    -- Use sync action
    vscode.action(cmd, { args = args })
  end
end

---Resolve the handler function from various input formats
---@param func string|function|table Function or config
---@param use_call boolean? Whether to prefer async call over action
---@return function The resolved handler function
local function resolve_handler(func, use_call)
  -- Case: Direct function
  if type(func) == 'function' then
    return func
  end

  -- Case: String (treated as Neovim command or VSCode action)
  if type(func) == 'string' then
    -- if is_vscode() then
    --   -- In VSCode, treat string as command
    --   local cmd = func
    --   return function()
    --     execute_vscode(cmd, nil, use_call)
    --   end
    -- else
    -- In Neovim, treat string as ex-command
    if func:sub(1, 1) == ':' and func:sub(-1) ~= ' ' and #func > 1 then
      return function()
        vim.cmd(func:sub(2))
      end
    else
      return function()
        vim.api.nvim_input(func)
      end
    end
    -- end
  end

  -- Case: Table with mode-specific handlers
  if type(func) == 'table' then
    if is_vscode() then
      if func.vscode then
        local vscode_config = parse_vscode_config(func.vscode)
        local cmd = vscode_config.cmd
        local args = vscode_config.args
        local async = vscode_config.async or use_call

        return function()
          execute_vscode(cmd, args, async)
        end
      else
        error('No vscode handler provided in VSCode mode')
      end
    else
      if func.neovim then
        return resolve_handler(func.neovim, use_call)
      else
        error('No neovim handler provided in Neovim mode')
      end
    end
  end

  error('Invalid function format: ' .. type(func))
end

---Set a keymap with automatic mode and environment handling
---@param mods string|string[] Modifier keys or mode (e.g., "n", "i", { "n", "v" })
---@param key string|string[] The key sequence
---@param func string|function|table Handler(s)
---@param opts string|table Options or description
---@return nil
M.map = function(mods, key, func, opts)
  -- Parse options
  if type(opts) == 'string' then
    opts = { desc = opts }
  end
  opts = opts or {}

  -- Resolve handler based on environment
  local handler = resolve_handler(func, opts.use_call)

  -- Set the keymap
  if type(key) == 'string' then
    key = { key }
  end
  for _, k in ipairs(key) do
    vim.keymap.set(mods, k, handler, opts)
  end
end

---Map in normal mode
---@param key string|string[] The key sequence
---@param func string|function|table Handler(s)
---@param opts string|table Options or description
M.nmap = function(key, func, opts)
  M.map('n', key, func, opts)
end

---Map in insert mode
---@param key string|string[] The key sequence
---@param func string|function|table Handler(s)
---@param opts string|table Options or description
M.imap = function(key, func, opts)
  M.map('i', key, func, opts)
end

---Map in visual mode
---@param key string|string[] The key sequence
---@param func string|function|table Handler(s)
---@param opts string|table Options or description
M.vmap = function(key, func, opts)
  M.map('v', key, func, opts)
end

---Map in normal and visual mode
---@param key string|string[] The key sequence
---@param func string|function|table Handler(s)
---@param opts string|table Options or description
M.nvmap = function(key, func, opts)
  M.map({ 'n', 'v' }, key, func, opts)
end

---Create a VSCode action handler
---@param cmd string Command ID
---@param args table? Command arguments
---@param async boolean? Use async call
---@return function
M.vscode_action = function(cmd, args, async)
  return function()
    execute_vscode(cmd, args, async)
  end
end

---Create a dual-mode handler
---@param neovim_handler function|string Neovim handler
---@param vscode_handler string|table VSCode handler
---@return table
M.dual = function(neovim_handler, vscode_handler)
  return {
    neovim = neovim_handler,
    vscode = vscode_handler
  }
end

---Set multiple keymaps at once
---
---Supports multiple formats:
---
---1. Object format:
---   { mode = 'n', key = 'x', func = fn, opts = '...' }
---
---2. Array format (with explicit mode):
---   { { 'i', 't' }, 'x', fn, '...' }
---   { 'n', 'x', fn, '...' }
---
---3. Array format (use shared/default mode):
---   { 'x', fn, '...' }
---
---4. Batch with shared mode (can be overridden by local mode):
---   { mode = { 'i', 't' }, { 'x', fn }, { 'y', fn2 } }
---   { mode = 'n', { 'v', 'x', fn }, { 'y', fn2 } }
---
---@param mappings table|{mode?: string|string[], [number]: table}
M.batch = function(mappings)
  -- Set default shared mode to 'n' if not provided
  local shared_mode = mappings.mode or 'n'

  -- Extract array items
  local items = {}
  for _, item in ipairs(mappings) do
    table.insert(items, item)
  end

  -- Process each mapping
  for _, mapping in ipairs(items) do
    local mode, key, func, opts

    -- Object format: { mode = ..., key = ..., func = ..., opts = ... }
    if mapping.mode ~= nil or mapping.key ~= nil or mapping.func ~= nil then
      mode = mapping.mode or shared_mode -- Local overrides shared
      key = mapping.key
      func = mapping.func
      opts = mapping.opts

      -- Array format
    else
      local first = mapping[1]

      -- Detect if first element is a local mode
      if #mapping == 4 then
        -- Has local mode: { mode, key, func, opts }
        mode = mapping[1]
        key = mapping[2]
        func = mapping[3]
        opts = mapping[4]
      elseif #mapping == 3 then
        -- No local mode: { key, func, opts } - use shared mode
        mode = shared_mode
        key = mapping[1]
        func = mapping[2]
        opts = mapping[3]
      else
        error('Invalid mapping format in batch')
      end
    end

    M.map(mode, key, func, opts)
  end
end

_G.useMap = M

return M
