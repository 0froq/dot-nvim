local function codelens_supported(bufnr)
  for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if c.server_capabilities and c.server_capabilities.codeLensProvider then
      return true
    end
  end
  return false
end

return {
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  },
  on_attach = function(_, bufnr)
    vim.api.nvim_create_autocmd(
      { 'TextChanged', 'InsertLeave', 'CursorHold', 'BufEnter' },
      {
        buffer = bufnr,
        callback = function()
          if codelens_supported(bufnr) then
            vim.lsp.codelens.refresh({ bufnr = bufnr })
          end
        end,
      }
    )

    vim.lsp.codelens.refresh({ bufnr = bufnr })
  end
}
