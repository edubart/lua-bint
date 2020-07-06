package = "bint"
version = "dev-1"
source = {
  url = "git://github.com/edubart/lua-bint.git",
  branch = "master"
}
description = {
  summary = "Arbitrary precision integer arithmetic library in pure Lua",
  detailed = [[Small portable arbitrary precision integer arithmetic library in pure Lua for
computing with large integers.
  ]],
  homepage = "https://github.com/edubart/lua-bint",
  license = "MIT"
}
dependencies = {
  "lua >= 5.3",
}
build = {
  type = "builtin",
  modules = {
    ['bint'] = 'bint.lua',
  }
}
