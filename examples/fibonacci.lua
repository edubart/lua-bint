-- Compute the 1000th Fibonacci number
-- See https://en.wikipedia.org/wiki/Fibonacci_number

local bint = require 'bint'

bint.scale(768)

local function fibonacci(n)
  local first, second = bint.zero(), bint.one()
  for _=0,n-1 do
    first, second = second, first
    second = second + first
  end
  return first
end

local x = fibonacci(1001)
print('The 1000th fibonnaci number is:')
print(x)

assert(tostring(x) == '\z
703303677114228158218352548771835497701812698363587327426049050871545371181969\z
335797422494945626117334877504492417659910881863632654502236471060120533741212\z
73867339111198139373125598767690091902245245323403501')