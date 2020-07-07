-- Simple RSA cryptosystem example
-- See https://en.wikipedia.org/wiki/RSA_(cryptosystem)

local bint = require 'bint'

bint.scale(512)

local function gcd(a, b)
  while not bint.iszero(b) do
    a, b = b, bint.umod(a, b)
  end
  return a
end

local function lcm(a, b)
  return bint.abs(a * b) // gcd(a, b)
end

local function modinverse(a, m)
  assert(bint.isone(gcd(a, m)), 'no inverse')
  if bint.isone(m) then
    return m
  end
  local m0, inv, x0 = m, 1, 0
  while a > 1 do
    local quot, rem = bint.udivmod(a, m)
    inv = inv - quot * x0
    a, m = m, rem
    inv, x0 = x0, inv
  end
  if inv < 0 then
    inv = inv + m0
  end
  return inv
end

-- 1. Choose two distinct primes
local p = bint(7)
local q = bint(19)

-- 2. Compute n = p * q
local n = p * q
assert(n == bint(133))

-- 3. Compute the totient
local phi_n = lcm(p - 1, q - 1)
assert(phi_n == bint(18))

-- 4. Choose any number e that 1 < e < phi_n and is coprime to phi_n.
local e = bint(17)

-- 5. Compute d, the modular multiplicative inverse
local d = modinverse(e, phi_n)
assert(d == bint(17))

-- The public key is (n, e)
local function encrypt(msg)
  return bint.umod(bint.ipow(msg, e), n)
end

-- The private key is (n, d)
local function decrypt(msg)
  return bint.umod(bint.ipow(msg, d), n)
end

local function test(x)
  local c = encrypt(x)
  local m = decrypt(c)
  print(m)
  assert(bint.eq(m, x))
end

for i=0,(n-1):tonumber(),11 do
  test(i)
end
