local bigint = require 'bigint'

bigint.scale(512)

local function gcd(a, b)
  a, b = bigint.convert(a), bigint.convert(b)
  while not b:iszero() do
    a, b = b, a % b
  end
  return a
end

local function modinverse(a, m)
  a, m = bigint.convert(a), bigint.convert(m)
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

local p = bigint(7)
local q = bigint(19)

local n = p * q
assert(n == bigint(133))

local phi_n = (p-1)*(q-1)
assert(phi_n == bigint(108))

local e = bigint(5)
local d = modinverse(e, phi_n)
assert(d == bigint(65))

local function encrypt(msg)
  return bigint.ipow(msg, e) % n
end

local function decrypt(msg)
  return bigint.ipow(msg, d) % n
end

local function test(msg)
  msg = bigint.convert(msg)
  local emsg = encrypt(msg)
  print(msg, emsg)
  local dmsg = decrypt(emsg)
  assert(dmsg == msg)
end

for i=0,(n-1):tonumber(),11 do
  test(i)
end
