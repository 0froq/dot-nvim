---@diagnostic disable: undefined-global
local M = {}



---@param mods string|table<string>
---@param key string|string[]
---@param func string|function|{neovim?: string|function, vscode?: string|function}
---@param opts string|table
M.map = function(mods, key, func, opts)
  ---@diagnostic disable: undefined-global
  -- If opts is a string, treat it as description
  if type(opts) == 'string' then
    opts = { desc = opts }
  end
  -- vim.keymap.set(mods, keys, func, opts)
  if type(func) == 'table' then
    if vim.g.vscode and func.vscode and type(func.vscode) == 'string' then
      func = function()
        require('vscode').action(func.vscode, opts)
      end
    elseif vim.g.vscode and func.vscode then
      func = func.vscode
    elseif not vim.g.vscode and func.neovim then
      func = func.neovim
    else
      vim.notify(
        'No valid function provided for mapping ' .. key,
        vim.log.levels.WARN
      )
    end
  else
    func = func
    if type(key) == 'string' then
      key = { key }
    end
    for _, k in ipairs(key) do
      vim.keymap.set(mods, k, func, opts)
    end
  end
end

---@param native string|function
---@param cmd string|function
---@param opts? table
M.vscode_action = function(native, cmd)
  -- opts = opts or {}
  return function()
    if vim.g.vscode then
      if type(cmd) == 'string' then
        require('vscode').action(cmd)
      else
        cmd()
      end
    else
      if type(native) == 'string' then
        if native:sub(1, 1) == ':' then
          vim.cmd(native:sub(2))
        else
          vim.api.nvim_input(native)
        end
      else
        native()
      end
    end
  end
end

---@param native string|function
---@param cmd string|function
---@param opts? table
M.vscode_call = function(native, cmd, opts)
  opts = opts or {}
  return function()
    if vim.g.vscode then
      if type(cmd) == 'string' then
        require('vscode').call(cmd, opts)
      else
        cmd()
      end
    else
      if type(native) == 'string' then
        if native:sub(1, 1) == ':' then
          vim.cmd(native:sub(2))
        else
          vim.api.nvim_input(native)
        end
      else
        native()
      end
    end
  end
end


---
---@param cmd function
---@param config string
M.pick_with_rg_config = function(cmd, config)
  local rg_env = 'RIPGREP_CONFIG_PATH'
  local cached_rg_config = vim.uv.os_getenv(rg_env) or ''
  vim.uv.os_setenv(rg_env, vim.fn.stdpath('config') .. '/rg-configs/rg-' .. config)
  cmd()
  vim.uv.os_setenv(rg_env, cached_rg_config)
end


return M
