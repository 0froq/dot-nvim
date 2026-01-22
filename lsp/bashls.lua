return {
  filetypes = { "bash", "sh", "zsh" },
  capabilities = {
    textDocument = {
      callHierarchy = {
        dynamicRegistration = true,
      },
    },
  }
}
