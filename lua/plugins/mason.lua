return {
  'mason-org/mason.nvim',
  event = { 'VimEnter' },
  opts = function()
    local pip_args = {}
    local proxy = os.getenv 'PIP_PROXY'
    if proxy then pip_args = { '--proxy', proxy } end

    return {
      pip = { upgrade_pip = false, install_args = pip_args },
      ui = { border = 'single', width = 0.7, height = 0.7 },
    }
  end,
}
