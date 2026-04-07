return {
  'altermo/ultimate-autopair.nvim',
  event = { 'InsertEnter', 'CmdlineEnter' },
  branch = 'v0.6',
  opts = {
    --Config goes here
    bs = {
      delete_from_end = false,
    },
    cr = {
      autoclose = true,
    },
    space2 = {
      enable = true,
    },
    fastwarp = {
      map = ']]',
      rmap = '[[',
      nocursormove = false,
    }
  },
}
