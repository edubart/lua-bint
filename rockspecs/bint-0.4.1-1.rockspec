package = "bint"
version = "0.4.1-1"
source = {
  url = "git://github.com/edubart/lua-bint.git",
  tag = "v0.4.1"
}
description = {
  summary = "Arbitrary precision integer arithmetic library in pure Lua",
  detailed = [[Small portable arbitrary-precision integer arithmetic library in pure Lua for
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
