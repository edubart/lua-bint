local tl = require("tl")
tl.loader()
-- Compute the first 100 digits of Euler's number
-- See https://en.wikipedia.org/wiki/E_(mathematical_constant)

local bint = require 'bint' (512)

local digits = bint(100)
local e = bint.zero()
local one = bint.ipow(bint(10), digits + bint(10))
local factorial = bint.one()
for i = 0, (digits + bint(10)):tointeger() do
  e = e + (one // factorial)
  factorial = factorial * (bint(i) + bint(1))
end
e = tostring(e)
e = e:sub(1, 1) .. '.' .. e:sub(2, digits:tointeger() + 1)
print(e)
assert(e == '2.7182818284590452353602874713526624977572470936999595749669676277240766303535475945713821785251664274')
