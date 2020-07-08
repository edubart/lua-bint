-- Compute the first 100 digits of Euler's number
-- See https://en.wikipedia.org/wiki/E_(mathematical_constant)

local bint = require 'bint'

bint.scale(512)

local digits = 100
local e = bint.zero()
local one = bint.ipow(10, digits+10)
local factorial = bint.one()
for i=0,digits+10 do
  e = e + (one // factorial)
  factorial = factorial * (i+1)
end
e = tostring(e)
e = e:sub(1,1) .. '.' .. e:sub(2, digits+1)
print(e)
assert(e == '2.7182818284590452353602874713526624977572470936999595749669676277240766303535475945713821785251664274')
