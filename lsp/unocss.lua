return {
  cmd = {
    vim.fn.stdpath('data') .. '/mason/bin/unocss-language-server',
    '--stdio'
  },
  filetypes = {
    'erb',
    'haml',
    'hbs',
    'html',
    'css',
    'postcss',
    'javascript',
    'javascriptreact',
    'markdown',
    'ejs',
    'php',
    'svelte',
    'typescript',
    'typescriptreact',
    'vue-html',
    'vue',
    'sass',
    'scss',
    'less',
    'stylus',
    'astro',
    'rescript',
    'rust'
  },
  root_markers = {
    'uno.config.mjs',
    'uno.config.mts',
    'uno.config.js',
    'uno.config.ts'
  },
  -- root_dir = vim.fs.root(0, { 'uno.config.mjs', 'uno.config.mts', 'uno.config.js', 'uno.config.ts' }),
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, {
      'uno.config.ts',
      'uno.config.js',
      'uno.config.mts',
      'uno.config.mjs',
      'package.json',
    })
    on_dir(root)
  end,
  workspace_required = true,
  workspace_folders = {
    {
      name = 'unocss',
      uri = 'file://' .. vim.fs.root(0, { 'uno.config.mjs', 'uno.config.mts', 'uno.config.js', 'uno.config.ts' }),
    },
  },
}
