local bint = require 'bint'

bint.scale(512)

local function gcd(a, b)
  a, b = bint.convert(a), bint.convert(b)
  while not b:iszero() do
    a, b = b, a % b
  end
  return a
end

local function modinverse(a, m)
  a, m = bint.convert(a), bint.convert(m)
  assert(gcd(a, m):isone(), 'no inverse')
  if m:isone() then
    return m
  end
  local m0, inv, x0 = m, 1, 0
  while a > 1 do
    inv = inv - (a // m) * x0
    a, m = m, (a % m)
    inv, x0 = x0, inv
  end
  if inv < 0 then
    inv = inv + m0
  end
  return inv
end

local p = bint(7)
local q = bint(19)

local n = p * q
assert(n == bint(133))

local phi_n = (p-1)*(q-1)
assert(phi_n == bint(108))

local e = bint(5)
local d = modinverse(e, phi_n)
assert(d == bint(65))

local function encrypt(msg)
  return bint.ipow(msg, e) % n
end

local function decrypt(msg)
  return bint.ipow(msg, d) % n
end

local function test(msg)
  msg = bint.convert(msg)
  local emsg = encrypt(msg)
  print(msg, emsg)
  local dmsg = decrypt(emsg)
  assert(dmsg == msg)
end

for i=0,(n-1):tonumber(),11 do
  test(i)
end
