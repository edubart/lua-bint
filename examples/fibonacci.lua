local bint = require 'bint'

bint.scale(1024)

local function fibonacci(n)
  local first, second = bint.zero(), bint.one()
  for _=0,n-1 do
    first, second = second, first
    second = second + first
  end
  return first
end

local x = fibonacci(1001)
print(x)
assert('703303677114228158218352548771835497701812698363587327426049050871545371'..
       '181969335797422494945626117334877504492417659910881863632654502236471060'..
       '12053374121273867339111198139373125598767690091902245245323403501' == tostring(x))