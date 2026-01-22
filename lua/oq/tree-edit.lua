-- ~/.config/nvim/lua/user/tree-edit.lua
-- True editable tree file manager - edit buffer directly to modify filesystem

local M = {
  state = {
    buf_id = -1,
    win_id = -1,
    root_dir = vim.fn.getcwd(),
    tree_data = {},
    snapshot = {},
    line_to_path = {},
  },
}

local function get_indent(level)
  return string.rep('  ', level)
end

-- 递归构建树
local function build_tree(dir, level, max_level)
  level = level or 0
  max_level = max_level or 3

  local entries = {}
  local ok, items = pcall(vim.fn.readdir, dir)
  if not ok or not items then return entries end

  table.sort(items)

  for _, item in ipairs(items) do
    if item:sub(1, 1) ~= '.' then
      local full_path = dir .. '/' .. item
      local is_dir = vim.fn.isdirectory(full_path) == 1

      local entry = {
        path = full_path,
        name = item,
        level = level,
        is_dir = is_dir,
        children = {},
      }

      if is_dir and level < max_level then
        entry.children = build_tree(full_path, level + 1, max_level)
      end

      table.insert(entries, entry)
    end
  end

  return entries
end

-- 平铺树为行列表
local function flatten_tree(entries)
  local lines = {}
  local line_to_path = {}

  local function traverse(entries)
    for _, entry in ipairs(entries) do
      local prefix = entry.is_dir and '📁 ' or '📄 '
      local line = get_indent(entry.level) .. prefix .. entry.name
      table.insert(lines, line)
      table.insert(line_to_path, entry.path)

      if #entry.children > 0 then
        traverse(entry.children)
      end
    end
  end

  traverse(entries)
  return lines, line_to_path
end

-- 从 buffer 内容重建树结构
local function parse_tree_from_buffer(lines)
  local entries = {}
  local stack = {}

  for _, line in ipairs(lines) do
    if line:gsub('^%s*', '') ~= '' then
      local level = (line:len() - line:gsub('^(%s*)', ''):len()) / 2
      local name = line:gsub('^%s*', ''):gsub('^[📁📄%s]+', '')

      if name ~= '' then
        local entry = {
          name = name,
          level = level,
        }

        while #stack > 0 and stack[#stack][1] >= level do
          table.remove(stack)
        end

        if #stack > 0 then
          if not stack[#stack][2].children then
            stack[#stack][2].children = {}
          end
          table.insert(stack[#stack][2].children, entry)
        else
          table.insert(entries, entry)
        end

        table.insert(stack, { level, entry })
      end
    end
  end

  return entries
end

-- 对比新旧 buffer，计算文件系统变更
local function compute_diff(old_lines, new_lines, old_line_to_path, root_dir)
  local changes = {
    renamed = {},
    deleted = {},
    created = {},
  }

  -- 无变化则返回空
  if #old_lines == #new_lines then
    local unchanged = true
    for i = 1, #old_lines do
      if old_lines[i] ~= new_lines[i] then
        unchanged = false
        break
      end
    end
    if unchanged then return changes end
  end

  -- 构建旧路径映射
  local old_paths = {}
  for i, path in ipairs(old_line_to_path) do
    old_paths[i] = path
  end

  -- 提取新文件名
  local new_tree = parse_tree_from_buffer(new_lines)
  local new_files = {}
  local function collect_files(entries, level)
    for _, entry in ipairs(entries) do
      table.insert(new_files, { name = entry.name, level = level })
      if entry.children then
        collect_files(entry.children, level + 1)
      end
    end
  end
  collect_files(new_tree, 0)

  -- 检测删除（行数减少或内容不同）
  if #old_lines > #new_lines then
    for i = #new_lines + 1, #old_lines do
      table.insert(changes.deleted, old_paths[i])
    end
  end

  -- 检测重命名
  for i = 1, math.min(#old_lines, #new_lines) do
    local old_name = old_lines[i]:gsub('^%s*', ''):gsub('^[📁📄%s]+', '')
    local new_name = new_lines[i]:gsub('^%s*', ''):gsub('^[📁📄%s]+', '')

    if old_name ~= new_name and old_name ~= '' and new_name ~= '' then
      table.insert(changes.renamed, { path = old_paths[i], new_name = new_name })
    end
  end

  -- 检测创建（行数增加）
  if #new_lines > #old_lines then
    for i = #old_lines + 1, #new_lines do
      local name = new_lines[i]:gsub('^%s*', ''):gsub('^[📁📄%s]+', '')
      if name ~= '' then
        table.insert(changes.created, { name = name, index = i })
      end
    end
  end

  return changes
end

-- 应用文件系统变更
local function apply_changes(changes, root_dir)
  -- 重命名
  for _, item in ipairs(changes.renamed) do
    local new_path = vim.fn.fnamemodify(item.path, ':h') .. '/' .. item.new_name
    local ok = pcall(vim.fn.rename, item.path, new_path)
    if ok then
      vim.notify('Renamed: ' .. vim.fn.fnamemodify(item.path, ':t') .. ' → ' .. item.new_name)
    else
      vim.notify('Failed to rename: ' .. item.path, vim.log.levels.ERROR)
    end
  end

  -- 删除
  for _, path in ipairs(changes.deleted) do
    local ok
    if vim.fn.isdirectory(path) == 1 then
      ok = pcall(vim.fn.system, 'rm -rf ' .. vim.fn.shellescape(path))
    else
      ok = pcall(vim.fn.delete, path)
    end
    if ok then
      vim.notify('Deleted: ' .. vim.fn.fnamemodify(path, ':t'))
    else
      vim.notify('Failed to delete: ' .. path, vim.log.levels.ERROR)
    end
  end

  -- 创建
  for _, item in ipairs(changes.created) do
    local new_path = root_dir .. '/' .. item.name
    local ok = pcall(vim.fn.writefile, {}, new_path)
    if ok then
      vim.notify('Created: ' .. item.name)
    else
      vim.notify('Failed to create: ' .. item.name, vim.log.levels.ERROR)
    end
  end
end

-- 创建/更新浮窗
local function win_buf(self)
  local height = math.ceil(vim.o.lines * 0.75)
  local width = math.ceil(vim.o.columns * 0.7)

  local win_cfg = {
    relative = 'editor',
    width = width,
    height = height,
    title = ' Tree Edit: ' .. vim.fn.fnamemodify(self.state.root_dir, ':~') .. ' ',
    footer = ' Edit freely • :w to apply changes • q to close ',
    focusable = true,
    row = (vim.o.lines - height) / 2,
    col = (vim.o.columns - width) / 2,
    border = 'rounded',
  }

  if not vim.api.nvim_buf_is_valid(self.state.buf_id) then
    self.state.buf_id = vim.api.nvim_create_buf(false, true)
  end

  if not vim.api.nvim_win_is_valid(self.state.win_id) then
    self.state.win_id = vim.api.nvim_open_win(self.state.buf_id, true, win_cfg)

    -- 重要：设置虚拟文件名
    vim.api.nvim_buf_set_name(self.state.buf_id, 'tree-edit://' .. self.state.root_dir)

    vim.api.nvim_set_option_value('filetype', 'tree-edit', { buf = self.state.buf_id })
    vim.api.nvim_set_option_value('buftype', '', { buf = self.state.buf_id })
    vim.api.nvim_set_option_value('number', false, { win = self.state.win_id })
    vim.api.nvim_set_option_value('wrap', true, { win = self.state.win_id })
  else
    vim.api.nvim_win_set_config(self.state.win_id, win_cfg)
  end

  return self.state.win_id, self.state.buf_id
end

-- 刷新 buffer 显示
local function refresh_buffer(self)
  local win_id, buf_id = win_buf(self)

  local lines, line_to_path = flatten_tree(self.state.tree_data)
  vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)

  self.state.line_to_path = line_to_path
  self.state.snapshot = vim.deepcopy(lines)

  -- 标记为未修改
  vim.api.nvim_buf_set_option(buf_id, 'modified', false)
end

-- 同步 buffer 改动到文件系统
local function sync_changes(self)
  local buf_id = self.state.buf_id
  if not vim.api.nvim_buf_is_valid(buf_id) then return end

  local current_lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)
  local changes = compute_diff(
    self.state.snapshot,
    current_lines,
    self.state.line_to_path,
    self.state.root_dir
  )

  if #changes.deleted > 0 or #changes.created > 0 or #changes.renamed > 0 then
    apply_changes(changes, self.state.root_dir)

    -- 重新构建树并刷新
    self.state.tree_data = build_tree(self.state.root_dir)
    refresh_buffer(self)

    vim.notify('✓ Tree synced to filesystem', vim.log.levels.INFO)
  else
    vim.notify('No changes detected', vim.log.levels.WARN)
  end
end

-- 设置自动命令和键位
local function setup_commands(self, buf_id)
  local group = vim.api.nvim_create_augroup('TreeEditUI', { clear = true })

  -- 拦截 :w 命令
  vim.api.nvim_create_autocmd('BufWriteCmd', {
    buffer = buf_id,
    group = group,
    callback = function()
      sync_changes(self)
      vim.api.nvim_buf_set_option(buf_id, 'modified', false)
    end,
  })

  -- 关闭时清理
  vim.api.nvim_create_autocmd('WinLeave', {
    buffer = buf_id,
    group = group,
    callback = function()
      if vim.api.nvim_win_is_valid(self.state.win_id) then
        vim.api.nvim_win_close(self.state.win_id, true)
      end
    end,
  })

  -- q 快速关闭
  vim.keymap.set('n', 'q', function()
    if vim.api.nvim_win_is_valid(self.state.win_id) then
      vim.api.nvim_win_close(self.state.win_id, true)
    end
  end, { buffer = buf_id, noremap = true })
end

-- 切换 UI
function M:toggle()
  if vim.api.nvim_win_is_valid(self.state.win_id) then
    vim.api.nvim_win_close(self.state.win_id, true)
    return
  end

  self.state.root_dir = vim.fn.getcwd()
  self.state.tree_data = build_tree(self.state.root_dir, 0, 2)

  local win_id, buf_id = win_buf(self)
  setup_commands(self, buf_id)
  refresh_buffer(self)
end

return M
