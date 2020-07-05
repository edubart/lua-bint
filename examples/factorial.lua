local bigint = require 'bigint'

bigint.scale(256)

local function factorial(n)
  if n <= 0 then
    return 1
  else
    return n * factorial(n-1)
  end
end

local num = bigint(50)
num = factorial(num)
print(num)

assert(tostring(num) == '30414093201713378043612608166064768844377641568960512000000000000')
