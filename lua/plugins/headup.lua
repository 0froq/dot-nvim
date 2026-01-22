return {
  'Fro-Q/headup.nvim',
  dev = true,
  dir = '/Users/oQ/2_areas/development/nvim_plugins/headup.nvim',
  lazy = false,
  config = function()
    local func = require('headup.func')

    func.register_generator('git_file_status', function(bufnr)
      local file = vim.api.nvim_buf_get_name(bufnr)
      if file == '' then return 'unknown' end

      local toplevel_out = vim.fn.systemlist({ 'git', 'rev-parse', '--show-toplevel' })
      if vim.v.shell_error ~= 0 or not toplevel_out or not toplevel_out[1] or toplevel_out[1] == '' then
        return 'unknown'
      end
      local root = toplevel_out[1]

      local rel_out = vim.fn.systemlist({ 'git', '-C', root, 'ls-files', '--full-name', '--error-unmatch', file })
      local rel_path
      if vim.v.shell_error ~= 0 or not rel_out or not rel_out[1] or rel_out[1] == '' then
        local status_out = vim.fn.systemlist({ 'git', '-C', root, 'status', '--porcelain', '--', file })
        if vim.v.shell_error == 0 and status_out and status_out[1] then
          local line = status_out[1]
          if line:match('^%?%?') then
            return 'U' -- Untracked
          end
        end
        return 'unknown'
      else
        rel_path = rel_out[1]
      end

      local status_out = vim.fn.systemlist({ 'git', '-C', root, 'status', '--porcelain', '--', rel_path })
      if vim.v.shell_error ~= 0 or not status_out then
        return 'unknown'
      end

      if #status_out == 0 then
        return 'C' -- Clean/unchanged
      end

      local line = status_out[1]
      local index_status = line:sub(1, 1)
      local work_status = line:sub(2, 2)

      local main_status = ''
      if index_status == 'A' then
        main_status = 'A' -- Added
      elseif index_status == 'M' then
        main_status = 'M' -- Modified in index
      elseif index_status == 'D' then
        main_status = 'D' -- Deleted in index
      elseif index_status == 'R' then
        main_status = 'R' -- Renamed
      elseif index_status == 'C' then
        main_status = 'C' -- Copied
      elseif work_status == 'M' then
        main_status = 'M' -- Modified in working tree
      elseif work_status == 'D' then
        main_status = 'D' -- Deleted in working tree
      elseif line:match('^%?%?') then
        main_status = 'U' -- Untracked
      else
        main_status = '?' -- Unknown status
      end

      if main_status == 'M' then
        local diff_out = vim.fn.systemlist({ 'git', '-C', root, 'diff', '--numstat', '--', rel_path })
        if vim.v.shell_error == 0 and diff_out and diff_out[1] then
          local stats = diff_out[1]
          local added, deleted = stats:match('^(%d+)%s+(%d+)')
          if added and deleted then
            return string.format('M(+%s-%s)', added, deleted)
          end
        end

        local diff_lines = vim.fn.systemlist({ 'git', '-C', root, 'diff', '--', rel_path })
        if vim.v.shell_error == 0 and diff_lines then
          local added_lines = 0
          local deleted_lines = 0
          for _, diff_line in ipairs(diff_lines) do
            if diff_line:match('^%+') and not diff_line:match('^%+%+%+') then
              added_lines = added_lines + 1
            elseif diff_line:match('^%-') and not diff_line:match('^%-%-%- ') then
              deleted_lines = deleted_lines + 1
            end
          end
          if added_lines > 0 or deleted_lines > 0 then
            return string.format('M(+%d-%d)', added_lines, deleted_lines)
          end
        end
      end

      return main_status
    end)

    func.register_generator('cowsay_fortune_flat', function()
      if vim.fn.executable('fortune') ~= 1 or vim.fn.executable('cowsay') ~= 1 then
        return 'unknown'
      end
      local out = vim.fn.systemlist({ 'sh', '-c', 'fortune -s | cowsay -W 40' })
      if vim.v.shell_error ~= 0 or not out or not out[1] then
        return 'unknown'
      end

      local lines = {}
      for _, line in ipairs(out) do
        if line:match('^%s*[_%-%.\\/|]+%s*$') then
          goto continue
        end
        line = line:gsub('^%s*[<|/\\]%s?', '')
        line = line:gsub('%s*[>/\\]%s*$', '')
        line = line:gsub('%s+', ' '):gsub('^%s+', ''):gsub('%s+$', '')
        if line ~= '' then table.insert(lines, line) end
        ::continue::
      end

      if #lines == 0 then return 'unknown' end
      return table.concat(lines, ' ')
    end)

    require('headup').setup({
      enabled = true,
      silent = false,
      time_format = '%Y-%m-%d %H:%M:%S',
      max_lines = 20,
      end_pattern = '^%s*$',           -- stop at first empty line
      exclude_pattern = '*/archive/*', -- skip archived notes
      {
        pattern = '*',
        match_pattern = '.-[Ll]ast[%s_%-][Mm]odified:%s(.-)%s*$',
        content = 'current_time',
      },
      {
        pattern = '*',
        match_pattern = '.-[Ll]ine[%s_%-][Cc]ount:%s(.-)%s*$',
        content = 'line_count',
      },
      {
        pattern = '*',
        match_pattern = '.-[Ff]ile[%s_%-][Ss]ize:%s(.-)%s*$',
        content = 'file_size',
      },
      {
        pattern = '*',
        match_pattern = '.-[Ff]ile[%s_%-][Pp]ath:%s(.-)%s*$',
        content = 'file_path',
      },
      {
        pattern = '*',
        match_pattern = '.-[Gg]it[%s_%-][Ss]tatus:%s(.-)%s*$',
        content = 'git_file_status',
      },
      {
        pattern = '*',
        match_pattern = '.-[Ff]ile[%s_%-][Nn]ame:%s(.-)%s*$',
        content = 'file_name',
      },
    })
  end
}
