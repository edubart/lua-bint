-- Simple Elliptic Curve Cryptography of secp256k1 for encrypting/decrypting messages
-- See https://en.bitcoin.it/wiki/Secp256k1

local bint = require 'bint'(768)

-- Returns modular multiplicative inverse m s.t. (a * m) % m == 1
local function modinv(a, m)
    local r, inv, s = bint(m), bint.one(), bint.zero()
    while not r:iszero() do
        local quo, rem = bint.idivmod(a, r)
        s, r, inv, a = inv - quo * s, rem, s, r
    end
    assert(a:isone(), 'no inverse')
    return inv % m
end

-- Curve prime number
local P = bint('0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f')

-- Curve parameters
local A = bint(0)
local B = bint(7)

-- Curve point class
local CurvePoint = setmetatable({_secp256k1 = true}, {__call = function(mt, a) return setmetatable(a, mt) end})
CurvePoint.__index = CurvePoint

-- Curve point at infinity
local O = CurvePoint{x=bint.zero(), y=math.huge}

-- Checks if points in the curve are equal.
function CurvePoint.__eq(a, b)
    return a.x == b.x and bint.eq(b.y, b.y)
end

-- Convert a curve point to a string.
function CurvePoint:__tostring()
    return string.format("{x=%s, y=%s}", self.x, self.y)
end

-- Add two points in the curve
function CurvePoint.__add(a, b)
    assert(a._secp256k1 and b._secp256k1, 'invalid params')
    -- handle special case of P + O = O + P = O
    if a == O then return b end
    if b == O then return a end
    -- handle special case of P + (-P) = O
    if a.x == b.x and a.y ~= b.y then return O end
    -- compute the "slope"
    local m
    if a.x == b.x then -- (a.y = b.y is guaranteed too per above check)
        m = ((3 * a.x:upowmod(2, P) + A) * modinv(2 * a.y, P) % P)
    else
        m = ((a.y - b.y) * modinv(a.x - b.x, P) % P)
    end
    -- compute the new point
    local x = (m*m - a.x - b.x) % P
    local y = (-(m*(x - a.x) + a.y)) % P
    return CurvePoint{x=x, y=y}
end

-- Multiply point p by scalar n.
function CurvePoint.__mul(p, n)
    n = bint(n)
    assert(n:ispos() and p._secp256k1, 'invalid params')
    local res = O
    local acc = p
    while n:ispos() do
        if n:isodd() then
            res = res + acc
        end
        n:_shrone()
        acc = acc + acc
    end
    return res
end

-- Checks if a point is on the curve, meaning if y^2 = x^3 + 7 holds true.
function CurvePoint:valid()
    if self == O then return true end
    local rem = (self.y:upowmod(2, P) - self.x:upowmod(3, P) - 7) % P
    return rem:iszero()
end

-- Curve generator point
local G = CurvePoint{
    x = bint('0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798'),
    y = bint('0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8'),
}

-- Curve order
local N = bint('0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141')

do -- Tests some curve operations
    assert(G:valid())
    assert(O:valid())
    assert((G+G):valid())
    assert(((G+G)+G):valid())
    assert((G+(G+G)):valid())
    assert((O+G):valid())
    assert((G+O):valid())
    assert((G*1):valid())
    assert((G*2):valid())
    assert((G*3):valid())
    assert(G*2 == G+G)
    assert(G*3 == G+G+G)
end

-- Very simple XOR crypt (very insecure, but works for demo purposes, use a better cipher like AES!)
local function xorcrypt(msg, symmetric_private_key)
    local xor_key = symmetric_private_key.x ~ symmetric_private_key.y
    return msg ~ xor_key
end

-- Encrypt message using a private symmetric key and the curve public key.
local function encrypt(msg, symmetric_private_key, public_key)
    return xorcrypt(msg, public_key * symmetric_private_key)
end

-- Decrypt message using a public symmetric key and the curve secret key.
local function decrypt(msg, symmetric_public_key, secret_key)
    return xorcrypt(msg, symmetric_public_key * secret_key)
end

-- Choose a secret key
local secret_key = bint.frombe('This is my secret key, hide it!')
print('secret_key = ' .. tostring(secret_key))

-- Compute public key
local public_key = G * secret_key
assert(public_key:valid())
print('public_key = ' .. tostring(public_key))

-- Test encrypt and decrypt
print 'Message encryption test:'

-- Generate a random symmetric key (ideally should be a random number)
local symmetric_private_key = bint.frombe('Symmetric key random, hide it!')
local symmetric_public_key = G * symmetric_private_key
assert(symmetric_public_key:valid())

local message = bint.frombe('Hello world!')
local encrypted_message = encrypt(message, symmetric_private_key, public_key)
print('Message: ' .. message:tobe(true))
print('encrypted_message = 0x' .. encrypted_message:tobase(16))

local decrypted_message = decrypt(encrypted_message, symmetric_public_key, secret_key)
print('Decoded: ' .. decrypted_message:tobe(true))
assert(message == decrypted_message)
print('success!')
