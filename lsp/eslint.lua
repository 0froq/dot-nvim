return {
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
    'vue',
    'html',
    'markdown',
    'json',
    'jsonc',
    'yaml',
    'toml',
    'xml',
    'gql',
    'graphql',
    'astro',
    'svelte',
    'css',
    'less',
    'scss',
    'pcss',
    'postcss',
  },
  cmd = { 'vscode-eslint-language-server', '--stdio' },
  root_markers = {
    '.eslintrc.js',
    '.eslintrc.cjs',
    '.eslintrc.json',
    '.eslintrc',
    'eslint.config.js',
    'eslint.config.mjs',
    'eslint.config.ts',
    'eslint.config.mts',
    'package.json',
    '.git',
  },
  workspace_required = true,
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspEslintFixAll', function()
      client:request_sync('workspace/executeCommand', {
        command = 'eslint.applyAllFixes',
        arguments = {
          {
            uri = vim.uri_from_bufnr(bufnr),
            version = vim.lsp.util.buf_versions[bufnr],
          },
        },
      }, nil, bufnr)
    end, {})

    -- vim.api.nvim_create_autocmd('BufWritePre', {
    --   buffer = bufnr,
    --   command = 'LspEslintFixAll',
    -- })
  end,

  settings = {
    validate = 'on',
    ---@diagnostic disable-next-line: assign-type-mismatch
    -- packageManager = nil,
    -- useESLintClass = false,
    experimental = {
      useFlatConfig = true
    },
    -- codeActionOnSave = {
    --   enable = true,
    --   mode = 'all',
    -- },
    -- format = true,
    -- quiet = false,
    -- onIgnoredFiles = 'off',
    -- run = 'onType',
    problems = {
      shortenToSingleLine = false,
    },
    -- -- nodePath configures the directory in which the eslint server should start its node_modules resolution.
    -- -- This path is relative to the workspace folder (root dir) of the server instance.
    nodePath = 'node_modules',
    -- -- use the workspace folder location or the file location (if no workspace folder is open) as the working directory
    -- workingDirectory = { mode = 'auto' },
    -- codeAction = {
    --   disableRuleComment = {
    --     enable = true,
    --     location = 'separateLine',
    --   },
    --   showDocumentation = {
    --     enable = true,
    --   },
    --   applyAllFixes = {
    --     enable = true,
    --   },
    -- },
    rulesCustomizations = {
      -- { rule = 'style/*',   severity = 'off', fixable = true },
      -- { rule = 'format/*',  severity = 'off', fixable = true },
      -- { rule = '*-indent',  severity = 'off', fixable = true },
      -- { rule = '*-spacing', severity = 'off', fixable = true },
      -- { rule = '*-spaces',  severity = 'off', fixable = true },
      -- { rule = '*-order',   severity = 'off', fixable = true },
      -- { rule = '*-dangle',  severity = 'off', fixable = true },
      -- { rule = '*-newline', severity = 'off', fixable = true },
      -- { rule = '*quotes',   severity = 'off', fixable = true },
      -- { rule = '*semi',     severity = 'off', fixable = true },
    },
  },
}
