if vim.g.vscode then
  return {}
end

return {
  'tamton-aquib/duck.nvim',
  event = 'BufRead',
  config = function()
    require('duck').setup()

    local severity_to_emoji = {
      [1] = '🐞',
      [2] = '🐤',
      [3] = '🐟',
      [4] = '🐸',
    }

    local has_animals = false

    local function count_diagnostics(bufnr)
      bufnr = bufnr or vim.api.nvim_get_current_buf()
      local diagnostics = vim.diagnostic.get(bufnr)
      local counts = { 0, 0, 0, 0 }

      for _, d in ipairs(diagnostics) do
        local s = d.severity
        -- Limit the num to 5
        if counts[s] >= 4 then
          counts[s] = 4
        end
        if s and s >= 1 and s < 4 then
          counts[s] = counts[s] + 1
        end
      end

      return counts
    end

    local function clear_animals()
      if has_animals then
        require('duck').cook_all()
        has_animals = false
      end
    end

    local function refresh_animals()
      clear_animals()

      if vim.fn.mode() == 'i' then
        return
      end

      local counts = count_diagnostics()
      for severity, count in ipairs(counts) do
        for _ = 1, count do
          require('duck').hatch(severity_to_emoji[severity])
          has_animals = true
        end
      end
    end

    vim.api.nvim_create_autocmd({ 'DiagnosticChanged' }, {
      pattern = '*',
      callback = function(args)
        if args.buf == vim.api.nvim_get_current_buf() then
          vim.defer_fn(refresh_animals, 100)
        end
      end,
    })

    vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
      pattern = '*',
      callback = clear_animals,
    })

    vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
      pattern = '*',
      callback = refresh_animals,
    })

    vim.api.nvim_create_autocmd({ 'BufEnter' }, {
      pattern = '*',
      callback = function()
        vim.defer_fn(refresh_animals, 500)
      end,
    })
  end,
}
