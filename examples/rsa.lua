-- Simple RSA cryptosystem example
-- See https://en.wikipedia.org/wiki/RSA_(cryptosystem)

local bint = require 'bint'(512)

local function gcd(a, b)
  while not bint.iszero(b) do
    a, b = b, bint.umod(a, b)
  end
  return a
end

local function lcm(a, b)
  return bint.abs(a * b) // gcd(a, b)
end

local function modinv(a, m)
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
local d = modinv(e, phi_n)
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
print('Message encryption test:')
local msg = 'Hello world!'
print('Message: '..msg)
local x = bint.frombe(msg)
assert(x < n)
print('x = 0x' .. bint.tobase(x, 16))
local c = encrypt(x)
print('c = 0x' .. bint.tobase(c, 16))
assert(c == bint.frombase('81fa941a0bf7a387f0ad060b90a5cd251be4031b4df39a', 16))
local m = decrypt(c)
print('m = 0x' .. bint.tobase(m, 16))
assert(m == x)
local decoded = bint.tobe(m, true)
print('Decoded: '..decoded)
assert(decoded == msg)
print('success!')
