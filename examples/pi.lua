-- Compute the first 100 digits on pi using the Machin-like formula
-- See https://en.wikipedia.org/wiki/Machin-like_formula

local bint = require 'bint'(512)

local function arctan_denom(x, ndigits)
  local sum = bint.zero()
  local one = bint.ipow(10, ndigits)
  local d = bint.new(x)
  local d2 = -(d*d)
  local i = 0
  repeat
    local term = one // (d * (2*i + 1))
    sum = sum + term
    d = d * d2
    i = i + 1
  until term:iszero()
  return sum
end

local function compute_pi(ndigits)
  local ndigits2 = ndigits + 10
  local pi = 4*(4*arctan_denom(5, ndigits2) - arctan_denom(239, ndigits2))
  pi = tostring(pi)
  pi = pi:sub(1,1) .. '.' .. pi:sub(2, ndigits + 1)
  return pi
end

local pi = compute_pi(100)
print('The first 100 pi digits are:')
print(pi)
assert(pi == '3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679')
