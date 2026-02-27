-- A custom capabilities setup for Neovim LSP servers
local capabilities = require('mini.completion').get_lsp_capabilities()
-- local capabilities
-- if not vim.g.vscode then
--   capabilities = require('blink.cmp').get_lsp_capabilities({
--     textDocument = {
--       foldingRange = {
--         dynamicRegistration = false,
--         lineFoldingOnly = true
--       }
--     }
--   })
-- else
--   capabilities = vim.lsp.protocol.make_client_capabilities()
-- end

-- Enhanced capabilities for better completion and other features
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { 'documentation', 'detail', 'additionalTextEdits' },
}
capabilities.textDocument.completion.completionItem.documentationFormat = {
  'markdown'
}
capabilities.textDocument.codeAction = {
  dynamicRegistration = true,
  codeActionLiteralSupport = {
    codeActionKind = {
      valueSet = (function()
        local res = vim.tbl_values(vim.lsp.protocol.CodeActionKind)
        table.sort(res)
        return res
      end)(),
    },
  },
}

capabilities.documentFormattingProvider = true
capabilities.documentRangeFormattingProvider = true

vim.diagnostic.config {
  virtual_lines = {
    current_line = true,
  },
  -- virtual_text = {
  --   spacing = 4,
  --   prefix = "",
  -- },
  float = {
    severity_sort = true,
    source = 'if_many',
    border = 'single',
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = 'E',
      [vim.diagnostic.severity.WARN] = 'W',
      [vim.diagnostic.severity.INFO] = 'I',
      [vim.diagnostic.severity.HINT] = 'H',
    },
  },
}

local function setup_server(server_name, config)
  -- Set capabilities
  config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})

  vim.lsp.config(server_name, config)
  vim.lsp.enable(server_name)
end

-- For config files in `lua/lsp/`, load them automatically
-- Each file will return a table with configuration options for the server
local lspconfig_path = vim.fn.stdpath('config') .. '/lsp/'

if vim.fn.isdirectory(lspconfig_path) == 1 then
  for _, file in ipairs(vim.fn.readdir(lspconfig_path)) do
    if file:sub(-4) == '.lua' then
      local server_name = file:sub(1, -5)
      local config_file = lspconfig_path .. file
      local _, server_config = pcall(dofile, config_file)

      if type(server_config) == 'table' then
        setup_server(server_name, server_config)
      else
        vim.notify('Failed to load LSP config for ' .. server_name, vim.log.levels.WARN)
      end
    end
  end
else
  vim.notify('LSP config directory not found: ' .. lspconfig_path, vim.log.levels.WARN)
end

-- local map = require('utils').map
local useMap = require('useMap')

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- Mappings
    useMap.nmap('<leader>cf', function()
      vim.lsp.buf.format { async = true }
    end, { buffer = bufnr, desc = 'Format current buffer with LSP' })

    if client and client.name == 'eslint' then
      useMap.nmap('<leader>cx', function()
        vim.cmd('LspEslintFixAll')
      end, { buffer = bufnr, desc = 'Fix all ESLint issues in current buffer' })
    end
  end,
})
