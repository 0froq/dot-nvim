return {
  cmd = { "pylsp" },
  filetypes = { "python" },
  settings = {
    pylsp = {
      settings = {
        pylsp = {
          plugins = {
            pycodestyle = {
              maxLineLength = 100,
            },
          },
        },
      },
    },
  }
}
