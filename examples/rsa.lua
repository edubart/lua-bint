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
local p = bint('5011956100955230700919988831')
local q = bint('5989833698158308593254005067')
print('p = ' .. tostring(p))
print('q = ' .. tostring(q))

-- 2. Compute n = p * q
local n = p * q
print('n = ' .. tostring(n))
assert(n == bint('30020783547191766561527759475184666413598963507657406677'))

-- 3. Compute the totient
local phi_n = lcm(p - 1, q - 1)
print('phi_n = ' .. tostring(phi_n))
assert(phi_n == bint('5003463924531961093587959910697146102414237368913902130'))

-- 4. Choose any number e that 1 < e < phi_n and is coprime to phi_n
local e = bint('65537')
print('e = ' .. tostring(e))

-- 5. Compute d, the modular multiplicative inverse
local d = modinverse(e, phi_n)
print('d = ' .. tostring(d))
assert(d == bint('2768292749187922993934715143535384861582621221551460873'))

-- The public key is (n, e), implement the encrypt function
local function encrypt(msg)
  return bint.upowmod(msg, e, n)
end

-- The private key is (n, d), implement the decrypt function
local function decrypt(msg)
  return bint.upowmod(msg, d, n)
end

-- Test encrypt and decrypt
print('testing')
local x = bint.frombase('thequickbrownfoxjumpsoverthelazydog', 36)
assert(x < n)
print('x = ' .. bint.tobase(x, 36))
local c = encrypt(x)
print('c = ' .. bint.tobase(c, 36))
assert(c == bint.frombase('9z4qp01to1q9203h34li5itqmoshbjqii6r9', 36))
local m = decrypt(c)
print('m = ' .. bint.tobase(m, 36))
assert(m == x)
print('success!')
