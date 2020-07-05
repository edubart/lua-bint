--[[
The MIT License (MIT)

Copyright (c) 2020 Eduardo Bart (https://github.com/edubart)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

--[[-- A small multiple-precision integer implementation in pure Lua
Small portable arbitrary-precision integer arithmetic in pure Lua for
calculating with large numbers.

Uses an array of lua integers as underlying data-type utilizing all bits in each word.

## Design goals

The main design goal of this library is to be small, correct, self contained and use few
resources while retaining acceptable performance and feature completeness.
Clarity of the code is also highly valued.

The library is designed to follow recent Lua integer semantics, this means,
integer overflow warps around,
signed integers are implemented using two-complement arithmetic rules and
integer division operations rounds towards minus infinity.

The library is designed to be possible to work with only unsigned integer arithmetic when
when using the proper methods.

The basic lua integer arithmetic operators (+, -, *, //, /, %) and bitwise operators (&, |, ~, <<, >>)
are implemented as metamethods.

## Usage

First on you should configure how many bits the library work with,
to do that call @{bigint.scale} once on startup with the desired number of bits in multiples of 32,
for example bigint.scale(1024). By default bigint uses 256 bits integers.

Then when you need create a bigint, you can use one of the following functions:

* @{bigint.fromuinteger}
* @{bigint.frominteger}
* @{bigint.fromnumber}
* @{bigint.frombase} (use to convert from strings)
* @{bigint.new} (use to convert from anything)
* @{bigint.zero}
* @{bigint.one}
* bigint

You can also call `bigint`, it is an alias to `bigint.new`. In doubt use @{bigint.new}
to create a new bigint.

Then you can use all the usual lua numeric operations on it, all the metamethods are implemented.
When you are done computing and need to get the result, get the output from one of the following functions:

* @{bigint.touinteger}
* @{bigint.tointeger}
* @{bigint.tonumber}
* @{bigint.tobase} (use to convert to strings)
* @{bigint.__tostring}

Note that outputting to lua number will make the integer overflow and its value wraps around.
To output very large integer with no loss of precision you probably want to use @{bigint.tobase}
to get a string representation.
]]

local bigint = {}
bigint.__index = bigint

local BIGINT_SIZE
local BIGINT_WORDBITS
local BIGINT_WORDMAX
local BIGINT_SIGNBIT
local BIGINT_HALFMAX

-- Returns number of bits of the internal lua integer type.
local function luainteger_bitsize()
  local n = -1
  local i = 0
  repeat
    i = i + 1
    n = n >> 1
  until n==0
  return i
end

--- Scale bigint to represent integers of the desired bit size.
-- Must be called only once on startup.
-- @param bits Number of bits for the integer representation, must be multiple of wordbits and
-- at least 64.
-- @param[opt] wordbits Number of the bits for the internal world, defaults to 32.
function bigint.scale(bits, wordbits)
  wordbits = wordbits or 32
  assert(bits % wordbits == 0, 'bitsize is not multiple of word bitsize')
  assert(2*wordbits <= luainteger_bitsize(), 'word bitsize must be half of the lua integer bitsize')
  assert(bits >= 64, 'bitsize must be >= 64')
  BIGINT_SIZE = bits / wordbits
  BIGINT_WORDBITS = wordbits
  BIGINT_WORDMAX = (1 << BIGINT_WORDBITS) - 1
  BIGINT_SIGNBIT = (1 << (BIGINT_WORDBITS - 1))
  BIGINT_HALFMAX = 1 + BIGINT_WORDMAX // 2
end

-- set default scale
bigint.scale(256)

-- Return a new bigint not fully initialized yet.
local function bigint_newempty()
  return setmetatable({}, bigint)
end

-- Convert a value to a lua integer without losing precision.
local function tointeger(x)
  x = tonumber(x)
  if math.type(x) == 'float' then
    local floorx = math.floor(x)
    if floorx ~= x then
      return nil
    end
    x = floorx
  end
  return x
end

-- Assign bigint to an unsigned integer.  Used only internally.
function bigint:_fromuinteger(x)
  for i=1,BIGINT_SIZE do
    self[i] = x & BIGINT_WORDMAX
    x = x >> BIGINT_WORDBITS
  end
  return self
end

--- Create a bigint from an unsigned integer.
-- Treats signed integers as an unsigned integer.
-- @param x A value to initialize from, usually convertible to a lua integer.
-- @return A new bigint or nil in case the input cannot be represented by an integer.
-- @see bigint.frominteger
function bigint.fromuinteger(x)
  x = tointeger(x)
  if not x then return nil end
  return bigint_newempty():_fromuinteger(x)
end

--- Create a bigint from a signed integer.
-- @param x A value to initialize from, usually convertible to a lua integer.
-- @return A new bigint or nil in case the input cannot be represented by an integer.
-- @see bigint.fromuinteger
function bigint.frominteger(x)
  x = tointeger(x)
  if not x then return nil end
  local neg = false
  if x < 0 then
    x = math.abs(x)
    neg = true
  end
  local n = bigint_newempty():_fromuinteger(x)
  if neg then
    n:_unm()
  end
  return n
end

--- Create a bigint from a number.
-- Floats values are truncated, that is, the fractional port is discarded.
-- @param x A value to initialize from, usually convertible to a number.
-- @return A new bigint or nil in case the input cannot be represented by an integer.
function bigint.fromnumber(x)
  x = tonumber(x)
  if not x then return nil end
  local ty = math.type(x)
  if ty == 'float' then
    -- truncate to integer
    x = math.modf(x)
  end
  return bigint.frominteger(x)
end

--- Create a bigint from a string of the desired base.
-- @param s The string to be converted from, must have only alphanumeric and '+-' characters.
-- @param[opt] base Base that the number is represented, defaults to 10.
-- Must be at least 2 and at most 36.
-- @return A new bigint.
-- @raise An assert is thrown in case the string has invalid characters or the base is invalid.
function bigint.frombase(s, base)
  s = s:lower()
  base = base or 10
  assert(base >= 2, base <= 36, 'number base is too large')
  local sign, int = s:match('^([+-]?)(%w+)$')
  assert(sign and int, 'invalid integer string representation')
  local n = bigint.zero()
  local step = 10
  for i=1,#int,step do
    local part = int:sub(i,i+step-1)
    local d = tonumber(part, base)
    assert(d, 'invalid integer string representation')
    n = (n * (base ^ #part)):_add(d)
  end
  if sign == '-' then
    n:_unm()
  end
  return n
end

--- Create a bigint from a value in case needed.
-- @param x A value convertible to a bigint (string, number or another bigint).
-- @return A bigint, will be the same input value in case it already is a bigint.
-- @raise An assert is thrown in case x is not convertible to a bigint.
-- @see bigint.new
function bigint.from(x)
  if getmetatable(x) ~= bigint then
    if type(x) == 'number' then
      x = bigint.frominteger(x)
    else
      x = bigint.frombase(x, 10)
    end
  end
  assert(x, 'value cannot be represented by a bigint')
  return x
end

local function bigint_assert_from(x)
  return assert(bigint.from(x), 'value has no bigint representation')
end

--- Convert a bigint to an unsigned integer.
-- Note that large unsigned integers are still represented as negative values in lua integers.
-- Note that lua cannot represent values larger than 64 bits, in that case integer values wraps around.
-- @param x A bigint or a number to be converted into an unsigned integer.
-- @return An integer or nil in case the input cannot be represented by an integer.
-- @see bigint.tointeger
function bigint.touinteger(x)
  if getmetatable(x) ~= bigint then
    return tointeger(x)
  end
  local n = 0
  for i=1,BIGINT_SIZE do
    n = n | (x[i] << (BIGINT_WORDBITS * (i - 1)))
  end
  return n
end

--- Convert a bigint to a signed integer.
-- It works by taking absolute values then applying the sign bit in case needed.
-- Note that lua cannot represent values larger than 64 bits, in that case integer values wraps around.
-- @param x A bigint or value to be converted into an unsigned integer.
-- @return An integer or nil in case the input cannot be represented by an integer.
-- @see bigint.touinteger
function bigint.tointeger(x)
  if getmetatable(x) ~= bigint then
    return tointeger(x)
  end
  local n = 0
  local neg = x:isneg()
  if neg then
    x = -x
  end
  for i=1,BIGINT_SIZE do
    n = n | (x[i] << (BIGINT_WORDBITS * (i - 1)))
  end
  if neg then
    n = -n
  end
  return n
end

local function bigint_assert_tointeger(x)
  return assert(bigint.tointeger(x), 'value has no integer representation')
end

--- Convert a bigint to a number. This is an alias to @{bigint.tointeger}.
-- @param x A bigint or value to be converted into a number.
-- @return An integer or nil in case the input cannot be represented by a number.
-- @see bigint.tointeger
function bigint.tonumber(x)
  if getmetatable(x) ~= bigint then
    return tonumber(x)
  end
  return x:tointeger()
end

--- Convert a bigint to a string in the desired base.
-- The sign cahracter ('-') for negative integers is only prepended when the base is 10.
-- All other bases treats negative integers as unsigned integers following two's complement
-- rules on this conversion.
-- @param x The bigint to be converted from.
-- @param[opt] base Base that the number is represented, defaults to 10.
-- Must be at least 2 and at most 36.
-- @return A string representing the input.
-- @raise An assert is thrown the base is invalid.
function bigint.tobase(x, base)
  x = bigint.new(x)
  base = base or 10
  assert(base >= 2 and base <= 36, 'number base is too large')
  local BASE_LETTERS = '0123456789abcdefghijklmnopqrstuvwxyz'
  local ss = {}
  local neg = base == 10 and x:isneg()
  if neg then
    x:_abs()
  end
  while not x:iszero() do
    local d
    x, d = bigint.udivmod(x, base)
    d = d:touinteger()
    table.insert(ss, 1, BASE_LETTERS:sub(d+1,d+1))
  end
  if neg then
    table.insert(ss, 1, '-')
  end
  if #ss == 0 then
    return '0'
  end
  return table.concat(ss)
end

--- Create a new bigint from a value.
-- @param x A value convertible to a bigint (string, number or another bigint).
-- @return A new bigint, guaranteed to be clone in case needed.
-- @raise An assert is thrown in case x is not convertible to a bigint.
-- @see bigint.from
function bigint.new(x)
  if getmetatable(x) == bigint then
    x = x:clone()
  elseif type(x) == 'number' then
    x = bigint.frominteger(x)
  else
    x = bigint.frombase(x, 10)
  end
  assert(x, 'value cannot be represented by a bigint')
  return x
end

--- Clone a bigint.
-- This is useful only to use in-place operations on cloned values.
-- @param x The bigint to be cloned.
-- @return A new bigint with the same data.
-- @raise An assert is thrown in case x is not a bigint.
function bigint.clone(x)
  assert(getmetatable(x) == bigint, 'invalid bigint')
  local n = {}
  for i=1,BIGINT_SIZE do
    n[i] = x[i]
  end
  setmetatable(n, bigint)
  return n
end

--- Create a new bigint with 1 value.
function bigint:iszero()
  for i=1,BIGINT_SIZE do
    if self[i] ~= 0 then
      return false
    end
  end
  return true
end

--- Check if bigint is -1.
function bigint:isminusone()
  for i=1,BIGINT_SIZE do
    if self[i] ~= BIGINT_WORDMAX then
      return false
    end
  end
  return true
end

--- Check if bigint is negative.
-- Zero is guaranteed to never be negative.
function bigint:isneg()
  return self[BIGINT_SIZE] & BIGINT_SIGNBIT ~= 0
end

--- Assign a bigint to zero (in-place).
function bigint:_zero()
  for i=1,BIGINT_SIZE do
    self[i] = 0
  end
  return self
end

--- Create a new bigint with 0 value.
function bigint.zero()
  return bigint_newempty():_zero()
end

--- Assign a bigint to 1 (in-place).
function bigint:_one()
  self[1] = 1
  for i=2,BIGINT_SIZE do
    self[i] = 0
  end
  return self
end

--- Create a new bigint with 1 value.
function bigint.one()
  return bigint_newempty():_one()
end

--- Bitwise left shift a bigint in one bit (in-place).
function bigint:_shlone()
  for i=BIGINT_SIZE,2,-1 do
    self[i] = ((self[i] << 1) | (self[i-1] >> (BIGINT_WORDBITS - 1))) & BIGINT_WORDMAX
  end
  self[1] = (self[1] << 1) & BIGINT_WORDMAX
  return self
end

--- Bitwise right shift a bigint in one bit (in-place).
function bigint:_shrone()
  for i=1,BIGINT_SIZE-1 do
    self[i] = ((self[i] >> 1) | (self[i+1] << (BIGINT_WORDBITS - 1))) & BIGINT_WORDMAX
  end
  self[BIGINT_SIZE] = self[BIGINT_SIZE] >> 1
  return self
end

-- Bitwise left shift words of a bigint (in-place). Used only internally.
function bigint:_shlwords(n)
  for i=BIGINT_SIZE,n+1,-1 do
    self[i] = self[i - n]
  end
  for i=1,n do
    self[i] = 0
  end
  return self
end

-- Bitwise right shift words of a bigint (in-place). Used only internally.
function bigint:_shrwords(n)
  if n < BIGINT_SIZE then
    for i=1,BIGINT_SIZE-n+1 do
      self[i] = self[i + n]
    end
    for i=BIGINT_SIZE-n,BIGINT_SIZE do
      self[i] = 0
    end
  else
    for i=1,BIGINT_SIZE do
      self[i] = 0
    end
  end
  return self
end

--- Increment a bigint by one (in-place).
function bigint:_inc()
  for i=1,BIGINT_SIZE do
    local tmp = self[i]
    local v = (tmp + 1) & BIGINT_WORDMAX
    self[i] = v
    if v > tmp then
      break
    end
  end
  return self
end

--- Increment a bigint by one.
-- @param x A value to be incremented.
function bigint.inc(x)
  return bigint.new(x):_inc()
end

--- Decrement a bigint by one (in-place).
function bigint:_dec()
  for i=1,BIGINT_SIZE do
    local tmp = self[i]
    local v = (tmp - 1) & BIGINT_WORDMAX
    self[i] = v
    if not (v > tmp) then
      break
    end
  end
  return self
end

--- Decrement a bigint by one.
-- @param x A value to be decremented.
function bigint.dec(x)
  return bigint.new(x):_dec()
end

--- Assign a bigint to a new value (in-place).
-- @param y A value to be copied from.
function bigint:_assign(y)
  y = bigint_assert_from(y)
  for i=1,BIGINT_SIZE do
    self[i] = y[i]
  end
  return self
end

--- Take absolute of a bigint (in-place).
function bigint:_abs()
  if self:isneg() then
    self:_unm()
  end
  return self
end

--- Take absolute of a bigint.
-- @param x A value to take the absolute from.
function bigint.abs(x)
  return bigint.new(x):_abs()
end

--- Add value to a bigint (in-place).
-- @param y A value to be added.
function bigint:_add(y)
  y = bigint_assert_from(y)
  local carry = 0
  for i=1,BIGINT_SIZE do
    local tmp = self[i] + y[i] + carry
    carry = tmp > BIGINT_WORDMAX and 1 or 0
    self[i] = tmp & BIGINT_WORDMAX
  end
  return self
end

--- Add value to a bigint.
-- @param x A value to be added.
-- @param y A value to be added.
function bigint.__add(x, y)
  return bigint.new(x):_add(y)
end

--- Subtract value from a bigint (in-place).
-- @param y A value to subtract.
function bigint:_sub(y)
  y = bigint_assert_from(y)
  local borrow = 0
  for i=1,BIGINT_SIZE do
    local tmp1 = self[i] + (BIGINT_WORDMAX + 1)
    local tmp2 = y[i] + borrow
    local res = tmp1 - tmp2
    self[i] = res & BIGINT_WORDMAX
    borrow = res <= BIGINT_WORDMAX and 1 or 0
  end
  return self
end

--- Subtract value from a bigint.
-- @param x A value to be subtract from.
-- @param y A value to subtract.
function bigint.__sub(x, y)
  return bigint.new(x):_sub(y)
end

--- Multiply two bigints.
-- @param x A value to multiply.
-- @param y A value to multiply.
function bigint.__mul(x, y)
  x, y = bigint_assert_from(x), bigint_assert_from(y)
  local row, tmp = bigint_newempty(), bigint_newempty()
  local res = bigint.zero()
  for i=1,BIGINT_SIZE do
    row:_zero()
    for j=1,BIGINT_SIZE do
      local nshifts = i+j-2
      if nshifts < BIGINT_SIZE then
        row:_add(tmp:_fromuinteger(x[i] * y[j]):_shlwords(nshifts))
      end
    end
    res:_add(row)
  end
  return res
end

--- Perform unsigned division between two bigints.
-- @param x The numerator.
-- @param y The denominator.
-- @return The quotient.
-- @raise Asserts on attempt to divide by zero.
function bigint.udiv(x, y)
  local current = bigint.one()
  local dividend = bigint.new(x)
  local denom = bigint.new(y)
  assert(not denom:iszero(), 'attempt to divide by zero')
  local overflow = false
  while denom:ule(dividend) do
    if denom[BIGINT_SIZE] >= BIGINT_HALFMAX then
      overflow = true
      break
    end
    current:_shlone()
    denom:_shlone()
  end
  if not overflow then
    current:_shrone()
    denom:_shrone()
  end
  local quot = bigint.zero()
  while not current:iszero() do
    if denom:ule(dividend) then
      dividend:_sub(denom)
      quot:_bor(current)
    end
    current:_shrone()
    denom:_shrone()
  end
  return quot
end

--- Perform unsigned integer modulo operation between two bigints.
-- @param x The numerator.
-- @param y The denominator.
-- @return The remainder.
-- @raise Asserts on attempt to divide by zero.
function bigint.umod(x, y)
  x, y = bigint_assert_from(x), bigint_assert_from(y)
  return x - (bigint.udiv(x, y) * y)
end

--- Perform unsigned division and modulo operation between two bigints.
-- This is effectively the same of @{bigint.udiv} and @{bigint.umod}.
-- @param x The numerator.
-- @param y The denominator.
-- @return The quotient following the remainder
-- @raise Asserts on attempt to divide by zero.
-- @see bigint.udiv
-- @see bigint.umod
function bigint.udivmod(x, y)
  x, y = bigint_assert_from(x), bigint_assert_from(y)
  local quot = bigint.udiv(x, y)
  local rem = x - (quot * y)
  return quot, rem
end

--- Perform integer floor division between two bigints.
-- Floor division is a division that rounds the quotient towards minus infinity,
-- resulting in the floor of the division of its operands.
-- @param x The numerator.
-- @param y The denominator.
-- @return The quotient.
-- @raise Asserts on attempt to divide by zero.
function bigint.__idiv(x, y)
  -- integer division, round quotient towards minus infinity, that is floor(x / y)
  x, y = bigint_assert_from(x), bigint_assert_from(y)
  if y:isminusone() then
    return -x
  end
  local quot = bigint.udiv(x:abs(), y:abs())
  if x:isneg() ~= y:isneg() then
    quot:_unm()

    -- round quotient towards minus infinity
    local rem = x - (y * quot)
    if not rem:iszero() then
      quot:_dec()
    end
  end
  return quot
end

bigint.__div = bigint.__idiv

--- Perform integer floor modulo operation between two bigints.
-- The operation is defined as the remainder of the floor division
-- (division that rounds the quotient towards minus infinity).
-- @param x The numerator.
-- @param y The denominator.
-- @return The remainder.
-- @raise Asserts on attempt to divide by zero.
function bigint.__mod(x, y)
  x, y = bigint_assert_from(x), bigint_assert_from(y)
  local quot = x // y
  return x - (quot * y)
end

--- Perform integer floor division and modulo operation between two bigints.
-- This is effectively the same of @{bigint.__idiv} and @{bigint.__mod}.
-- @param x The numerator.
-- @param y The denominator.
-- @return The quotient following the remainder
-- @raise Asserts on attempt to divide by zero.
-- @see bigint.__idiv
-- @see bigint.__mod
function bigint.idivmod(x, y)
  x, y = bigint_assert_from(x), bigint_assert_from(y)
  local quot = x // y
  local rem = x - (quot * y)
  return quot, rem
end

--- Perform integer power between two bigints.
-- @param x The base.
-- @param y The exponent, cannot be negative.
-- @return The result of the pow operation.
-- @raise Asserts on attempt pow with a negative exponent or very large exponent.
function bigint.__pow(x, y)
  x = bigint_assert_from(x)
  assert(y <= math.maxinteger, 'attempt to pow to a very large integer')
  assert(y >= 0, 'attempt to pow to a negative power')
  if y == 0 then
    return bigint.one()
  else
    x = bigint_assert_from(x)
    if x:iszero() then
      return bigint.zero()
    else
      local res = x:clone()
      for _=2,y do
        res = res * x
      end
      return res
    end
  end
end

--- Bitwise left shift bigints.
-- @param x A value to perform the bitwise shift.
-- @param y Number of bits to shift.
function bigint.__shl(x, y)
  x, y = bigint.new(x), bigint_assert_tointeger(y)
  if y < 0 then return x >> -y end
  local nvals = y // BIGINT_WORDBITS
  if nvals ~= 0 then
    x:_shlwords(nvals)
    y = y - nvals * BIGINT_WORDBITS
  end
  if y ~= 0 then
    for i=BIGINT_SIZE,2,-1 do
      x[i] = ((x[i] << y) | (x[i-1] >> (BIGINT_WORDBITS - y))) & BIGINT_WORDMAX
    end
    x[1] = (x[1] << y) & BIGINT_WORDMAX
  end
  return x
end

--- Bitwise right shift bigints.
-- @param x A value to perform the bitwise shift.
-- @param y Number of bits to shift.
function bigint.__shr(x, y)
  x, y = bigint.new(x), bigint_assert_tointeger(y)
  if y < 0 then return x << -y end
  local nvals = y // BIGINT_WORDBITS
  if nvals ~= 0 then
    x:_shrwords(nvals)
    y = y - nvals * BIGINT_WORDBITS
  end
  if y ~= 0 then
    for i=1,BIGINT_SIZE-1 do
      x[i] = ((x[i] >> y) | (x[i+1] << (BIGINT_WORDBITS - y))) & BIGINT_WORDMAX
    end
    x[BIGINT_SIZE] = x[BIGINT_SIZE] >> y
  end
  return x
end

--- Bitwise AND bigints (in-place).
-- @param y A value to perform bitwise AND.
function bigint:_band(y)
  y = bigint_assert_from(y)
  for i=1,BIGINT_SIZE do
    self[i] = self[i] & y[i]
  end
  return self
end

--- Bitwise AND bigints.
-- @param x A value to perform bitwise AND.
-- @param y A value to perform bitwise AND.
function bigint.__band(x, y)
  return bigint.new(x):_band(y)
end

--- Bitwise OR bigints (in-place).
-- @param y A value to perform bitwise OR.
function bigint:_bor(y)
  y = bigint_assert_from(y)
  for i=1,BIGINT_SIZE do
    self[i] = self[i] | y[i]
  end
  return self
end

--- Bitwise OR bigints.
-- @param x A value to perform bitwise OR.
-- @param y A value to perform bitwise OR.
function bigint.__bor(x, y)
  return bigint.new(x):_bor(y)
end

--- Bitwise XOR bigints (in-place).
-- @param y A value to perform bitwise XOR.
function bigint:_bxor(y)
  y = bigint_assert_from(y)
  for i=1,BIGINT_SIZE do
    self[i] = self[i] ~ y[i]
  end
  return self
end

--- Bitwise XOR bigints.
-- @param x A value to perform bitwise XOR.
-- @param y A value to perform bitwise XOR.
function bigint.__bxor(x, y)
  return bigint.new(x):_bxor(y)
end

--- Bitwise NOT a bigint (in-place).
function bigint:_bnot()
  for i=1,BIGINT_SIZE do
    self[i] = (~self[i]) & BIGINT_WORDMAX
  end
  return self
end

--- Bitwise NOT a bigint.
-- @param x A value to perform bitwise NOT.
function bigint.__bnot(x)
  return bigint.new(x):_bnot()
end

--- Negate a bigint (in-place). This apply effectively apply two's complements.
function bigint:_unm()
  return self:_bnot():_inc()
end

--- Negate a bigint. This apply effectively apply two's complements.
-- @param x A value to perform negation.
function bigint.__unm(x)
  return bigint.new(x):_unm()
end

--- Check if bigints are equal.
-- @param x A value to compare.
-- @param y A value to compare.
function bigint.__eq(x, y)
  for i=1,BIGINT_SIZE do
    if x[i] ~= y[i] then
      return false
    end
  end
  return true
end

--- Compare if bigint x is less than y (unsigned version).
-- @param x Left value to compare.
-- @param y Right value to compare.
-- @see bigint.__lt
function bigint.ult(x, y)
  x, y = bigint_assert_from(x), bigint_assert_from(y)
  for i=BIGINT_SIZE,1,-1 do
    if x[i] < y[i] then
      return true
    elseif x[i] > y[i] then
      return false
    end
  end
  return false
end

--- Compare if bigint x is less or equal than y (unsigned version).
-- @param x Left value to compare.
-- @param y Right value to compare.
-- @see bigint.__le
function bigint.ule(x, y)
  x, y = bigint_assert_from(x), bigint_assert_from(y)
  for i=BIGINT_SIZE,1,-1 do
    if x[i] < y[i] then
      return true
    elseif x[i] ~= y[i] then
      return false
    end
  end
  return true
end

--- Compare if bigint x is less than y (signed version).
-- @param x Left value to compare.
-- @param y Right value to compare.
-- @see bigint.ult
function bigint.__lt(x, y)
  x, y = bigint_assert_from(x), bigint_assert_from(y)
  local xneg, yneg = x:isneg(), y:isneg()
  if xneg == yneg then
    return bigint.ult(x, y)
  else
    return xneg and not yneg
  end
end

--- Compare if bigint x is less or equal than y (signed version).
-- @param x Left value to compare.
-- @param y Right value to compare.
-- @see bigint.ule
function bigint.__le(x, y)
  x, y = bigint_assert_from(x), bigint_assert_from(y)
  local xneg, yneg = x:isneg(), y:isneg()
  if xneg == yneg then
    return bigint.ule(x, y)
  else
    return xneg and not yneg
  end
end

--- Convert a bigint to a string (uses base 10)
-- @see bigint.tobase
function bigint:__tostring()
  return self:tobase(10)
end

setmetatable(bigint, {
  __call = function(_, x)
    return bigint.new(x)
  end
})

return bigint
