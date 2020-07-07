-- Compute the factorial of 100
-- See https://en.wikipedia.org/wiki/Factorial

local bint = require 'bint'

bint.scale(576)

local function factorial(n)
  if n <= 0 then
    return 1
  else
    return n * factorial(n-1)
  end
end

local x = factorial(bint(100))
print(x)

assert(tostring(x) == '\z
933262154439441526816992388562667004907159682643816214685929638952175999932299\z
15608941463976156518286253697920827223758251185210916864000000000000000000000000')
