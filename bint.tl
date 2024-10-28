global record BigInteger
  bits: integer

  -- Create a new bint with 0 value
  zero: function(): BigInteger
  -- Create a new bint with 1 value
  one: function(): BigInteger
  -- Create a bint from an unsigned integer
  fromuinteger: function(x: number): BigInteger
  -- Create a bint from a signed integer
  frominteger: function(x: number): BigInteger
  -- Create a bint from a string of the desired base
  frombase: function(s: string, base: integer): BigInteger
  -- Create a new bint from a string (decimal, binary, or hexadecimal)
  fromstring: function(s: string): BigInteger
  -- Create a new bint from a buffer of little-endian bytes
  fromle: function(buffer: string): BigInteger
  -- Create a new bint from a buffer of big-endian bytes
  frombe: function(buffer: string): BigInteger
  -- Create a new bint from a value
  new: function(x: number | string | BigInteger): BigInteger
  -- Convert a value to a bint if possible
  tobint: function(x: number | string | BigInteger, clone: boolean): BigInteger
  -- Convert a bint to an unsigned integer
  touinteger: function(x: BigInteger | number): integer
  -- Convert a bint to a signed integer
  tointeger: function(x: BigInteger | number): integer
  -- Convert a bint to a lua float or integer
  tonumber: function(x: BigInteger): number
  -- Convert a bint to a string in the desired base
  tobase: function(x: BigInteger, base: integer, unsigned: boolean): string
  -- Convert a bint to a buffer of little-endian bytes
  tole: function(x: BigInteger, trim: boolean): string
  -- Convert a bint to a buffer of big-endian bytes
  tobe: function(x: BigInteger, trim: boolean): string

  -- Check if a number is 0 considering bints
  iszero: function(x: BigInteger): boolean
  -- Check if a number is 1 considering bints
  isone: function(x: BigInteger): boolean
  -- Check if a number is -1 considering bints
  isminusone: function(x: BigInteger): boolean
  -- Check if the input is a bint
  isbint: function(x: any): boolean
  -- Check if the input is a lua integer or a bint
  isintegral: function(x: any): boolean
  -- Check if the input is a bint or a lua number
  isnumeric: function(x: any): boolean
  -- Get the number type of the input (bint, integer or float)
  type: function(x: any): string | nil
  -- Check if a number is negative considering bints
  isneg: function(x: BigInteger): boolean
  -- Check if a number is positive considering bints
  ispos: function(x: BigInteger): boolean
  -- Check if a number is even considering bints
  iseven: function(x: BigInteger): boolean
  -- Check if a number is odd considering bints
  isodd: function(x: BigInteger): boolean

  -- Create a new bint with the maximum possible integer value
  maxinteger: function(): BigInteger
  -- Create a new bint with the minimum possible integer value
  mininteger: function(): BigInteger

  -- Increment a number by one considering bints
  inc: function(x: BigInteger): BigInteger
  -- Decrement a number by one considering bints
  dec: function(x: BigInteger): BigInteger
  -- Take absolute of a number considering bints
  abs: function(x: BigInteger): BigInteger
  -- Take the floor of a number considering bints
  floor: function(x: BigInteger): BigInteger
  -- Take ceil of a number considering bints
  ceil: function(x: BigInteger): BigInteger
  -- Wrap around bits of an integer (discarding left bits) considering bints
  bwrap: function(x: BigInteger, y: integer): BigInteger
  -- Rotate left integer x by y bits considering bints
  brol: function(x: BigInteger, y: integer): BigInteger
  -- Rotate right integer x by y bits considering bints
  bror: function(x: BigInteger, y: integer): BigInteger
  -- Take maximum between two numbers considering bints
  max: function(x: BigInteger, y: BigInteger): BigInteger
  -- Take minimum between two numbers considering bints
  min: function(x: BigInteger, y: BigInteger): BigInteger

  -- Perform unsigned division and modulo operation between two integers considering bints
  udivmod: function(x: BigInteger, y: BigInteger): BigInteger, BigInteger
  -- Perform unsigned division between two integers considering bints
  udiv: function(x: BigInteger, y: BigInteger): BigInteger
  -- Perform unsigned integer modulo operation between two integers considering bints
  umod: function(x: BigInteger, y: BigInteger): BigInteger
  -- Perform integer truncate division and modulo operation between two numbers considering bints
  tdivmod: function(x: BigInteger, y: BigInteger): BigInteger, BigInteger
  -- Perform truncate division between two numbers considering bints
  tdiv: function(x: BigInteger, y: BigInteger): BigInteger
  -- Perform integer truncate modulo operation between two numbers considering bints
  tmod: function(x: BigInteger, y: BigInteger): BigInteger
  -- Perform integer floor division and modulo operation between two numbers considering bints
  idivmod: function(x: BigInteger, y: BigInteger): BigInteger, BigInteger

  -- Perform integer power between two BigIntegers
  ipow: function(x: BigInteger, y: BigInteger): BigInteger
  -- Perform integer power between two unsigned integers over a modulus considering bints
  upowmod: function(x: BigInteger, y: BigInteger, m: BigInteger): BigInteger

  -- Compare if integer x is less than y considering bints (unsigned version)
  ult: function(x: BigInteger, y: BigInteger): boolean
  -- Compare if bint x is less or equal than y considering bints (unsigned version)
  ule: function(x: BigInteger, y: BigInteger): boolean

  -- Check if numbers are equal considering bints
  eq: function(x: BigInteger, y: BigInteger): boolean

  -- Add an integer to a bint (in-place)
  _add: function(self: BigInteger, y: BigInteger): BigInteger
  -- Subtract an integer from a bint (in-place)
  _sub: function(self: BigInteger, y: BigInteger): BigInteger
  -- Increment a bint by one (in-place)
  _inc: function(self: BigInteger): BigInteger
  -- Decrement a bint by one (in-place)
  _dec: function(self: BigInteger): BigInteger
  -- Assign a bint to a new value (in-place)
  _assign: function(self: BigInteger, y: BigInteger): BigInteger
  -- Take absolute of a bint (in-place)
  _abs: function(self: BigInteger): BigInteger
  -- Bitwise left shift a bint in one bit (in-place)
  _shlone: function(self: BigInteger): BigInteger
  -- Bitwise right shift a bint in one bit (in-place)
  _shrone: function(self: BigInteger): BigInteger
  -- Bitwise left shift words of a bint (in-place)
  _shlwords: function(self: BigInteger, n: integer): BigInteger
  -- Bitwise right shift words of a bint (in-place)
  _shrwords: function(self: BigInteger, n: integer): BigInteger
  -- Bitwise AND bints (in-place)
  _band: function(self: BigInteger, y: integer): BigInteger
  -- Bitwise OR bints (in-place)
  _bor: function(self: BigInteger, y: BigInteger): BigInteger
  -- Bitwise XOR bints (in-place)
  _bxor: function(self: BigInteger, y: BigInteger): BigInteger
  -- Bitwise NOT a bint (in-place)
  _bnot: function(self: BigInteger): BigInteger
  -- Negate a bint (in-place)
  _unm: function(self: BigInteger): BigInteger

  -- Add two numbers considering bints
  __add: function(self: BigInteger, y: BigInteger): BigInteger
  -- Subtract two numbers considering bints
  __sub: function(self: BigInteger, y: BigInteger): BigInteger
  -- Multiply two numbers considering bints
  __mul: function(self: BigInteger, y: BigInteger): BigInteger
  -- Perform division between two numbers considering bints
  __div: function(self: BigInteger, y: BigInteger): number
  -- Perform floor division between two numbers considering bints
  __idiv: function(self: BigInteger, y: BigInteger): BigInteger, BigInteger
  -- Perform integer floor modulo operation between two numbers considering bints
  __mod: function(self: BigInteger, y: BigInteger): BigInteger
  -- Negate a bint
  __unm: function(self: BigInteger): BigInteger
  -- Bitwise AND two integers considering bints
  __band: function(x: BigInteger, y:integer): BigInteger
  -- Bitwise OR two integers considering bints
  __bor: function(self: BigInteger, y: BigInteger): BigInteger
  -- Bitwise XOR two integers considering bints
  __bxor: function(self: BigInteger, y: BigInteger): BigInteger
  -- Bitwise NOT a bint
  __bnot: function(self: BigInteger): BigInteger
  -- Bitwise left shift integers considering bints
  __shl: function(self: BigInteger, y: integer): BigInteger
  -- Bitwise right shift integers considering bints
  __shr: function(self: BigInteger, y: integer): BigInteger
  -- Compare if number x is less than y considering bints and signs
  lt: function(self: BigInteger, y: BigInteger): boolean
  gt: function(self: BigInteger, y: BigInteger): boolean
  -- Compare if number x is less or equal than y considering bints and signs
  le: function(self: BigInteger, y: BigInteger): boolean
  ge: function(self: BigInteger, y: BigInteger): boolean
  -- Check if bints are equal
  __eq: function(self: BigInteger, y: BigInteger): boolean
  -- Convert a bint to a string on base 10
  __tostring: function(self: BigInteger): string

  -- Allow creating bints by calling bint itself
  __call: function(self: BigInteger, x: number | string | BigInteger): BigInteger

  __index: any

  -- Add two numbers considering bints
  metamethod __add: function(self: BigInteger, y: BigInteger): BigInteger
  -- Subtract two numbers considering bints
  metamethod __sub: function(self: BigInteger, y: BigInteger): BigInteger
  -- Multiply two numbers considering bints
  metamethod __mul: function(self: BigInteger, y: BigInteger): BigInteger
  -- Perform division between two numbers considering bints
  metamethod __div: function(self: BigInteger, y: BigInteger): number
  -- Perform floor division between two numbers considering bints
  metamethod __idiv: function(self: BigInteger, y: BigInteger): BigInteger
  -- Perform integer floor modulo operation between two numbers considering bints
  metamethod __mod: function(self: BigInteger, y: BigInteger): BigInteger
  -- Negate a bint
  metamethod __unm: function(self: BigInteger): BigInteger
  -- Bitwise AND two integers considering bints
  metamethod __band: function(x: BigInteger, y:integer): BigInteger
  -- Bitwise OR two integers considering bints
  metamethod __bor: function(self: BigInteger, y: BigInteger): BigInteger
  -- Bitwise XOR two integers considering bints
  metamethod __bxor: function(self: BigInteger, y: BigInteger): BigInteger
  -- Bitwise NOT a bint
  metamethod __bnot: function(self: BigInteger): BigInteger
  -- Bitwise left shift integers considering bints
  metamethod __shl: function(self: BigInteger, y: integer): BigInteger
  -- Bitwise right shift integers considering bints
  metamethod __shr: function(self: BigInteger, y: integer): BigInteger
  -- Check if bints are equal
  metamethod __eq: function(self: BigInteger, y: BigInteger): boolean
  -- Convert a bint to a string on base 10
  metamethod __tostring: function(self: BigInteger): string

  metamethod __index: function(self: BigInteger, key: integer): integer
  -- Allow creating bints by calling bint itself
  metamethod __call: function(self: BigInteger, x: number | string | BigInteger): BigInteger
  

end

local function luainteger_bitsize(): integer
  local n: integer = -1
  local i: integer = 0
  repeat
    n, i = n >> 16, i + 16
  until n==0
  return i
end

local math_type = math.type
local math_floor = math.floor
local math_abs = math.abs
local math_ceil = math.ceil
local math_modf = math.modf
local math_mininteger = math.mininteger
local math_maxinteger = math.maxinteger
local math_max = math.max
local math_min = math.min
local string_format = string.format
local table_insert = table.insert
local table_concat = table.concat
local table_unpack = table.unpack

local memo: table = {}

--- Create a new bint module representing integers of the desired bit size.
-- This is the returned function when `require 'bint'` is called.
-- @function newmodule
-- @param bits Number of bits for the integer representation, must be multiple of wordbits and
-- at least 64.
-- @param[opt] wordbits Number of the bits for the internal word,
-- defaults to half of Lua's integer size.
local function newmodule(bits: integer, wordbits: integer): BigInteger

local intbits: integer = luainteger_bitsize()
bits = bits or 256
wordbits = wordbits or (intbits // 2)

-- Memoize bint modules
local memoindex: integer = bits * 64 + wordbits
if memo[memoindex] then
  return memo[memoindex] as BigInteger
end

-- Validate
assert(bits % wordbits == 0, 'bitsize is not multiple of word bitsize')
assert(2*wordbits <= intbits, 'word bitsize must be half of the lua integer bitsize')
assert(bits >= 64, 'bitsize must be >= 64')
assert(wordbits >= 8, 'wordbits must be at least 8')
assert(bits % 8 == 0, 'bitsize must be multiple of 8')

-- Create bint module
local bint = {} as BigInteger
bint.__index = bint

--- Number of bits representing a bint instance.
bint.bits = bits

-- Constants used internally
local BINT_BITS: integer = bits
local BINT_BYTES: integer = bits // 8
local BINT_WORDBITS: integer = wordbits
local BINT_SIZE: integer = BINT_BITS // BINT_WORDBITS
local BINT_WORDMAX: integer = (1 << BINT_WORDBITS) - 1
local BINT_WORDMSB: integer = (1 << (BINT_WORDBITS - 1))
local BINT_LEPACKFMT: string = '<'..('I'..(wordbits // 8)):rep(BINT_SIZE)
local BINT_MATHMININTEGER: BigInteger
local BINT_MATHMAXINTEGER: BigInteger
local BINT_MININTEGER: BigInteger

--- Function to check that the x metatable is a bint one
local function has_bint_metatable(x: any): boolean
  return type(x) == "table" and (getmetatable(x as table) as metatable<BigInteger>) == getmetatable(bint)
end

--- Create a new bint with 0 value.
function bint.zero(): BigInteger
  local x: BigInteger = setmetatable({}, bint as metatable<BigInteger>)
  for i=1,BINT_SIZE do
    x[i] = 0
  end
  return x
end
local bint_zero: function(): BigInteger = bint.zero

--- Create a new bint with 1 value.
function bint.one(): BigInteger
  local x: BigInteger = setmetatable({}, bint as metatable<BigInteger>)
  x[1] = 1
  for i=2,BINT_SIZE do
    x[i] = 0
  end
  return x
end
local bint_one: function(): BigInteger = bint.one

-- Convert a value to a lua integer without losing precision.
local function tointeger(x: number): integer
  x = tonumber(x)
  local ty: string = math_type(x)
  if ty == 'float' then
    local floorx: integer = math_floor(x)
    if floorx == x then
      x = floorx
      ty = math_type(x)
    end
  end
  if ty == 'integer' then
    return x as integer
  end
end

--- Create a bint from an unsigned integer.
-- Treats signed integers as an unsigned integer.
-- @param x A value to initialize from convertible to a lua integer.
-- @return A new bint or nil in case the input cannot be represented by an integer.
-- @see bint.frominteger
function bint.fromuinteger(x: number): BigInteger
  x = tointeger(x)
  if x then
    if x == 1 then
      return bint_one()
    elseif x == 0 then
      return bint_zero()
    end
    local n: BigInteger = setmetatable({}, bint as metatable<BigInteger>)
    for i=1,BINT_SIZE do
      n[i] = x & BINT_WORDMAX
      x = x >> BINT_WORDBITS
    end
    return n
  end
end
local bint_fromuinteger: function(x: number): BigInteger = bint.fromuinteger

--- Create a bint from a signed integer.
-- @param x A value to initialize from convertible to a lua integer.
-- @return A new bint or nil in case the input cannot be represented by an integer.
-- @see bint.fromuinteger
function bint.frominteger(x: number): BigInteger
  x = tointeger(x)
  if x then
    if x == 1 then
      return bint_one()
    elseif x == 0 then
      return bint_zero()
    end
    local neg: boolean = false
    if x < 0 then
      x = math_abs(x)
      neg = true
    end
    local n: BigInteger = setmetatable({}, bint as metatable<BigInteger>)
    for i=1,BINT_SIZE do
      n[i] = x & BINT_WORDMAX
      x = x >> BINT_WORDBITS
    end
    if neg then
      n:_unm()
    end
    return n
  end
end
local bint_frominteger: function(x: number): BigInteger = bint.frominteger

-- XXX is this correct??
local basesteps: {number} = {}

-- Compute the read step for frombase function
local function getbasestep(base: integer): integer
  local step: integer = basesteps[base] as integer
  if step then
    return step
  end
  step = 0
  local dmax: integer = 1
  local limit: integer = math_maxinteger // base
  repeat
    step = step + 1
    dmax = dmax * base
  until dmax >= limit
  basesteps[base] = step
  return step
end

-- Compute power with lua integers.
local function ipow(y: integer, x: integer, n: integer): integer
  if n == 1 then
    return y * x
  elseif n & 1 == 0 then --even
    return ipow(y, x * x, n // 2)
  end
  return ipow(x * y, x * x, (n-1) // 2)
end


--- Check if the input is a bint.
-- In order to support upgradability (i.e. operate on bint values created with another bint package)
-- this check doesn't have maximum accuracy.
-- @param x Any lua value.
function bint.isbint(x: any): boolean
  -- disable the strict condition
  -- return getmetatable(x) == bint
  
  -- use a more relaxed condition
  local isTable = type(x) == 'table'
  local mt = getmetatable(x) as {string: function}
  -- no 100% confidence, but enough for our purposes
  local isBintish = mt and mt.isbint
    and mt.tobint 
    and mt.zero 
    and mt.iszero 
    and mt.frombase 
    and mt.tobase 
    and mt.isneg
    and mt.ispos
    and true

  return isTable and isBintish
end


local function bint_assert_convert(x: BigInteger): BigInteger
  if not bint.isbint(x) then
    print(debug.traceback())
    assert(bint.isbint(x), 'bint_assert_convert: expected BigInteger, got '..type(x)..' value '..tostring(x))
  end
  return x
end


local function bint_assert_convert_clone(x: BigInteger): BigInteger
  if not bint.isbint(x) then
    print(debug.traceback())
    assert(bint.isbint(x), 'bint_assert_convert_clone: expected BigInteger, got '..type(x)..' value '..tostring(x))
  end
  local n: BigInteger = setmetatable({}, bint as metatable<BigInteger>)
  local xi: BigInteger = x
  for i=1,BINT_SIZE do
    n[i] = xi[i]
  end
  return n
end


local function bint_assert_convert_from_integer(x: integer): BigInteger
  local xi = bint_frominteger(x)
  assert(xi, 'bint_assert_convert_from_integer: could not convert integer to big integer'..type(x)..' value '..tostring(x))
  return xi
end

--- Create a bint from a string of the desired base.
-- @param s The string to be converted from,
-- must have only alphanumeric and '+-' characters.
-- @param[opt] base Base that the number is represented, defaults to 10.
-- Must be at least 2 and at most 36.
-- @return A new bint or nil in case the conversion failed.
function bint.frombase(s: string, base: integer): BigInteger
  if type(s) ~= 'string' then
    error('s is not a string')
  end
  base = base or 10
  if not (base >= 2 and base <= 36) then
    error('number base is too large')
  end
  local step: integer = getbasestep(base)
  if #s < step then
    -- string is small, use tonumber (faster)
    return bint_frominteger(tonumber(s, base))
  end
  local sign: string
  local int: string
  sign, int = s:lower():match('^([+-]?)(%w+)$')
  if not (sign and int) then
    error('invalid integer string representation')
  end
  local n: BigInteger = bint_zero()
  for i=1,#int,step do
    local part: string = int:sub(i,i+step-1)
    local d: integer = tonumber(part, base)
    if not d then
      error('invalid integer string representation')
    end
    if i > 1 then
      n = n * bint_frominteger(ipow(1, base, #part))
    end
    if d ~= 0 then
      n:_add(bint_frominteger(d))
    end
  end
  if sign == '-' then
    n:_unm()
  end
  return n
end
local bint_frombase: function(s: string, base: integer): BigInteger = bint.frombase

--- Create a new bint from a string.
-- The string can by a decimal number, binary number prefixed with '0b' or hexadecimal number prefixed with '0x'.
-- @param s A string convertible to a bint.
-- @return A new bint or nil in case the conversion failed.
-- @see bint.frombase
function bint.fromstring(s: string): BigInteger
  if type(s) ~= 'string' then
    error('s is not a string')
  end
  if s:find('^[+-]?[0-9]+$') then
    return bint_frombase(s, 10)
  elseif s:find('^[+-]?0[xX][0-9a-fA-F]+$') then
    return bint_frombase(s:gsub('0[xX]', '', 1), 16)
  elseif s:find('^[+-]?0[bB][01]+$') then
    return bint_frombase(s:gsub('0[bB]', '', 1), 2)
  end
end
local bint_fromstring: function(s: string): BigInteger = bint.fromstring

--- Create a new bint from a buffer of little-endian bytes.
-- @param buffer Buffer of bytes, extra bytes are trimmed from the right, missing bytes are padded to the right.
-- @raise An assert is thrown in case buffer is not an string.
-- @return A bint.
function bint.fromle(buffer: string): BigInteger
  assert(type(buffer) == 'string', 'buffer is not a string')
  if #buffer > BINT_BYTES then -- trim extra bytes from the right
    buffer = buffer:sub(1, BINT_BYTES)
  elseif #buffer < BINT_BYTES then -- add missing bytes to the right
    buffer = buffer..('\x00'):rep(BINT_BYTES - #buffer)
  end
  return setmetatable({BINT_LEPACKFMT:unpack(buffer) as {integer}} as BigInteger, bint as metatable<BigInteger>)
end

--- Create a new bint from a buffer of big-endian bytes.
-- @param buffer Buffer of bytes, extra bytes are trimmed from the left, missing bytes are padded to the left.
-- @raise An assert is thrown in case buffer is not an string.
-- @return A bint.
function bint.frombe(buffer: string): BigInteger
  assert(type(buffer) == 'string', 'buffer is not a string')
  if #buffer > BINT_BYTES then -- trim extra bytes from the left
    buffer = buffer:sub(-BINT_BYTES, #buffer)
  elseif #buffer < BINT_BYTES then -- add missing bytes to the left
    buffer = ('\x00'):rep(BINT_BYTES - #buffer)..buffer
  end
  return setmetatable({BINT_LEPACKFMT:unpack(buffer:reverse()) as {integer}} as BigInteger, bint as metatable<BigInteger>)
end

--- Create a new bint from a value.
-- @param x A value convertible to a bint (string, number or another bint).
-- @return A new bint, guaranteed to be a new reference in case needed.
-- @raise An assert is thrown in case x is not convertible to a bint.
-- @see bint.tobint
function bint.new(x: number | string | BigInteger): BigInteger
  if not has_bint_metatable(x) then
    local ty: string = type(x)
    if ty == 'number' then
      x = bint_frominteger(x as number)
      assert(x, 'value cannot be represented by a bint')
      return x
    elseif ty == 'string' then
      x = bint_fromstring(x as string)
      assert(x, 'value cannot be represented by a bint')
      return x
    end
  end
  -- return a clone
  return bint_assert_convert_clone(x as BigInteger)
end
local bint_new: function(x: number | string | BigInteger): BigInteger = bint.new


--- Convert a value to a bint if possible.
-- @param x A value to be converted (string, number or another bint).
-- @param[opt] clone A boolean that tells if a new bint reference should be returned.
-- Defaults to false.
-- @return A bint or nil in case the conversion failed.
-- @see bint.new
function bint.tobint(x: number | string | BigInteger, clone: boolean): BigInteger
  if has_bint_metatable(x) then
    if not clone then
      return bint_assert_convert(x as BigInteger)
    end
    -- return a clone
    return bint_assert_convert_clone(x as BigInteger)
  end
  local ty: string = type(x)
  if ty == 'number' then
    return bint_frominteger(x as number)
  elseif ty == 'string' then
    return bint_fromstring(x as string)
  end
end
local tobint: function(x: number | string | BigInteger, clone: boolean): BigInteger = bint.tobint

function bint.touinteger(x: BigInteger | number): integer
  if has_bint_metatable(x) then
    local n = 0
    local xi = bint_assert_convert_clone(x as BigInteger) as BigInteger
    for i=1,BINT_SIZE do
      n = n | (xi[i] << (BINT_WORDBITS * (i - 1)))
    end
    return n
  end
  return tointeger(x as number)
end


--- Convert a bint to a signed integer.
-- It works by taking absolute values then applying the sign bit in case needed.
-- Note that lua cannot represent values larger than 64 bits,
-- in that case integer values wrap around.
-- @param x A bint or value to be converted into an unsigned integer.
-- @return An integer or nil in case the input cannot be represented by an integer.
-- @see bint.touinteger
function bint.tointeger(x: BigInteger | number): integer
  if has_bint_metatable(x) then
    local xi = bint_assert_convert_clone(x as BigInteger)
    local n = 0
    for i=1,BINT_SIZE do
      n = n | (xi[i] << (BINT_WORDBITS * (i - 1)))
    end
    return n
  end
  return tointeger(x as number)
end

local bint_tointeger: function(x: BigInteger | number): integer = bint.tointeger

local function bint_assert_tointeger(x: BigInteger | integer): integer
  local xi = bint_tointeger(x)
  if not xi then
    error('bint_assert_tointeger: cannot convert to integer, got '..type(x)..' value '..tostring(x))
  end
  return xi
end

--- Convert a bint to a lua float in case integer would wrap around or lua integer otherwise.
-- Different from @{bint.tointeger} the operation does not wrap around integers,
-- but digits precision are lost in the process of converting to a float.
-- @param x A bint or value to be converted into a lua number.
-- @return A lua number or nil in case the input cannot be represented by a number.
-- @see bint.tointeger
function bint.tonumber(x: BigInteger): number
  x = bint_assert_convert_clone(x)
  if x:le(BINT_MATHMAXINTEGER) and x:ge(BINT_MATHMININTEGER) then
    return x:tointeger()
  end
  print('warning: too big for int, casting to number, potential precision loss')
  return tonumber(x)
end
local bint_tonumber: function(x: BigInteger): number = bint.tonumber

-- Compute base letters to use in bint.tobase
local BASE_LETTERS = {}
do
  for i=1,36 do
    BASE_LETTERS[i-1] = ('0123456789abcdefghijklmnopqrstuvwxyz'):sub(i,i)
  end
end

--- Convert a bint to a string in the desired base.
-- @param x The bint to be converted from.
-- @param[opt] base Base to be represented, defaults to 10.
-- Must be at least 2 and at most 36.
-- @param[opt] unsigned Whether to output as an unsigned integer.
-- Defaults to false for base 10 and true for others.
-- When unsigned is false the symbol '-' is prepended in negative values.
-- @return A string representing the input.
-- @raise An assert is thrown in case the base is invalid.
function bint.tobase(x: BigInteger, base: integer, unsigned: boolean): string
  x = bint_assert_convert_clone(x)
  if not x then
    error('x is a fractional float or something else')
  end
  base = base or 10
  if not (base >= 2 and base <= 36) then
    -- number base is too large
    return
  end
  if unsigned == nil then
    unsigned = base ~= 10
  end
  local isxneg = x:isneg()
  if (base == 10 and not unsigned) or (base == 16 and unsigned and not isxneg) then
    if x:le(BINT_MATHMAXINTEGER) and x:ge(BINT_MATHMININTEGER) then
      -- integer is small, use tostring or string.format (faster)
      local n = x:tointeger()
      if base == 10 then
        return tostring(n)
      elseif unsigned then
        return string_format('%x', n)
      end
    end
  end
  local ss = {}
  local neg = not unsigned and isxneg
  x = neg and x:abs() or bint_new(x)
  local xiszero = x:iszero()
  if xiszero then
    return '0'
  end
  -- calculate basepow
  local step = 0
  local basepow = 1
  local limit = (BINT_WORDMSB - 1) // base
  repeat
    step = step + 1
    basepow = basepow * base
  until basepow >= limit
  -- serialize base digits
  local size = BINT_SIZE
  local xd: integer
  local carry: integer
  local d: integer
  repeat
    -- single word division
    carry = 0
    xiszero = true
    for i=size,1,-1 do
      carry = carry | x[i]
      d, xd = carry // basepow, carry % basepow
      if xiszero and d ~= 0 then
        size = i
        xiszero = false
      end
      x[i] = d
      carry = xd << BINT_WORDBITS
    end
    -- digit division
    for _=1,step do
      xd, d = xd // base, xd % base
      if xiszero and xd == 0 and d == 0 then
        -- stop on leading zeros
        break
      end
      table_insert(ss, 1, BASE_LETTERS[d])
    end
  until xiszero
  if neg then
    table_insert(ss, 1, '-')
  end
  return table_concat(ss)
end



--- Convert a bint to a buffer of little-endian bytes.
-- @param x A bint or lua integer.
-- @param[opt] trim If true, zero bytes on the right are trimmed.
-- @return A buffer of bytes representing the input.
-- @raise Asserts in case input is not convertible to an integer.
function bint.tole(x: BigInteger, trim: boolean): string
  x = bint_assert_convert_clone(x)
  local s: string = BINT_LEPACKFMT:pack(table_unpack(x as {integer}))
  if trim then
    s = s:gsub('\x00+$', '')
    if s == '' then
      s = '\x00'
    end
  end
  return s
end

--- Convert a bint to a buffer of big-endian bytes.
-- @param x A bint or lua integer.
-- @param[opt] trim If true, zero bytes on the left are trimmed.
-- @return A buffer of bytes representing the input.
-- @raise Asserts in case input is not convertible to an integer.
function bint.tobe(x: BigInteger, trim: boolean): string
  x = bint_assert_convert_clone(x)
  local xt: {integer} = {table_unpack(x as {integer})}
  local s = BINT_LEPACKFMT:pack(table_unpack(xt)):reverse()
  if trim then
    s = s:gsub('^\x00+', '')
    if s == '' then
      s = '\x00'
    end
  end
  return s
end

--- Check if a bint is 0 considering bints.
-- @param x A bint or a lua number.
function bint.iszero(x: BigInteger): boolean
  local xi = bint_assert_convert(x)
  for i=1,BINT_SIZE do
    if xi[i] ~= 0 then
      return false
    end
  end
  return true
end

--- Check if a bint is 1 considering bints.
-- @param x A bint or a lua number.
function bint.isone(x: BigInteger): boolean
  local xi = bint_assert_convert(x)
  if xi[1] ~= 1 then
    return false
  end
  for i=2,BINT_SIZE do
    if xi[i] ~= 0 then
      return false
    end
  end
  return true
end

--- Check if a bint is -1 considering bints.
-- @param x A bint or a lua number.
function bint.isminusone(x: BigInteger): boolean
  local xi = bint_assert_convert(x)
  if xi[1] ~= BINT_WORDMAX then
    return false
  end
  return true
end
local bint_isminusone: function(x: BigInteger): boolean = bint.isminusone

--- Check if the input is a lua integer or a bint.
-- @param x Any lua value.
function bint.isintegral(x: any): boolean
  return has_bint_metatable(x) or math_type(x) == 'integer'
end

--- Check if the input is a bint or a lua number.
-- @param x Any lua value.
function bint.isnumeric(x: any): boolean
  return has_bint_metatable(x) or type(x) == 'number'
end

--- Get the number type of the input (bint, integer or float).
-- @param x Any lua value.
-- @return Returns "bint" for bints, "integer" for lua integers,
-- "float" from lua floats or nil otherwise.
function bint.type(x: any): string | nil
  if has_bint_metatable(x) then
    return 'bint'
  end
  return math_type(x)
end

--- Check if a number is negative considering bints.
-- Zero is guaranteed to never be negative for bints.
-- @param x A bint or a lua number.
function bint.isneg(x: BigInteger): boolean
  bint_assert_convert(x)
  return x[BINT_SIZE] & BINT_WORDMSB ~= 0
end
local bint_isneg: function(x: BigInteger): boolean = bint.isneg

--- Check if a number is positive considering bints.
-- @param x A bint or a lua number.
function bint.ispos(x: BigInteger): boolean
  bint_assert_convert(x)
  return not x:isneg() and not x:iszero()
end

--- Check if a number is even considering bints.
-- @param x A bint or a lua number.
function bint.iseven(x: BigInteger): boolean
  bint_assert_convert(x)
  return x[1] & 1 == 0
end

--- Check if a number is odd considering bints.
-- @param x A bint or a lua number.
function bint.isodd(x: BigInteger): boolean
  bint_assert_convert(x)
  return x[1] & 1 == 1
end

--- Create a new bint with the maximum possible integer value.
function bint.maxinteger(): BigInteger
  local x: BigInteger = setmetatable({}, bint as metatable<BigInteger>)
  for i=1,BINT_SIZE-1 do
    x[i] = BINT_WORDMAX
  end
  x[BINT_SIZE] = BINT_WORDMAX ~ BINT_WORDMSB
  return x
end

--- Create a new bint with the minimum possible integer value.
function bint.mininteger(): BigInteger
  local x: BigInteger = setmetatable({}, bint as metatable<BigInteger>)
  for i=1,BINT_SIZE-1 do
    x[i] = 0
  end
  x[BINT_SIZE] = BINT_WORDMSB
  return x
end

--- Bitwise left shift a bint in one bit (in-place).
function bint:_shlone(): BigInteger
  local wordbitsm1: integer = BINT_WORDBITS - 1
  for i=BINT_SIZE,2,-1 do
    self[i] = ((self[i] << 1) | (self[i-1] >> wordbitsm1)) & BINT_WORDMAX
  end
  self[1] = (self[1] << 1) & BINT_WORDMAX
  return self
end

--- Bitwise right shift a bint in one bit (in-place).
function bint:_shrone(): BigInteger
  local wordbitsm1: integer = BINT_WORDBITS - 1
  for i=1,BINT_SIZE-1 do
    self[i] = ((self[i] >> 1) | (self[i+1] << wordbitsm1)) & BINT_WORDMAX
  end
  self[BINT_SIZE] = self[BINT_SIZE] >> 1
  return self
end

-- Bitwise left shift words of a bint (in-place). Used only internally.
function bint:_shlwords(n: integer): BigInteger
  for i=BINT_SIZE,n+1,-1 do
    self[i] = self[i - n]
  end
  for i=1,n do
    self[i] = 0
  end
  return self
end

-- Bitwise right shift words of a bint (in-place). Used only internally.
function bint:_shrwords(n: integer): BigInteger
  if n < BINT_SIZE then
    for i=1,BINT_SIZE-n do
      self[i] = self[i + n]
    end
    for i=BINT_SIZE-n+1,BINT_SIZE do
      self[i] = 0
    end
  else
    for i=1,BINT_SIZE do
      self[i] = 0
    end
  end
  return self
end

--- Increment a bint by one (in-place).
function bint:_inc(): BigInteger
  for i=1,BINT_SIZE do
    local tmp: integer = self[i]
    local v: integer = (tmp + 1) & BINT_WORDMAX
    self[i] = v
    if v > tmp then
      break
    end
  end
  return self
end

--- Increment a number by one considering bints.
-- @param x A bint or a lua number to increment.
function bint.inc(x: BigInteger): BigInteger
  local ix: BigInteger = bint_assert_convert(x)
  return ix:_inc()
end

--- Decrement a bint by one (in-place).
function bint:_dec(): BigInteger
  for i=1,BINT_SIZE do
    local tmp: integer = self[i]
    local v: integer = (tmp - 1) & BINT_WORDMAX
    self[i] = v
    if v <= tmp then
      break
    end
  end
  return self
end

--- Decrement a number by one considering bints.
-- @param x A bint or a lua number to decrement.
function bint.dec(x: BigInteger): BigInteger
  local ix: BigInteger = bint_assert_convert(x)
  return ix:_dec()
end

--- Assign a bint to a new value (in-place).
-- @param y A value to be copied from.
-- @raise Asserts in case inputs are not convertible to integers.
function bint:_assign(y: BigInteger): BigInteger
  y = bint_assert_convert(y)
  for i=1,BINT_SIZE do
    self[i] = y[i]
  end
  return self
end

--- Take absolute of a bint (in-place).
function bint:_abs(): BigInteger
  if self:isneg() then
    self:_unm()
  end
  return self
end

--- Take absolute of a number considering bints.
-- @param x A bint or a lua number to take the absolute.
function bint.abs(x: BigInteger): BigInteger
  local ix = bint_assert_convert_clone(x)
  return ix:_abs()
end
local bint_abs: function(x: BigInteger): BigInteger = bint.abs

--- Take the floor of a number considering bints.
-- @param x A bint or a lua number to perform the floor operation.
function bint.floor(x: BigInteger): BigInteger
  return bint_assert_convert_clone(x)
end

--- Take ceil of a number considering bints.
-- @param x A bint or a lua number to perform the ceil operation.
function bint.ceil(x: BigInteger): BigInteger
  return bint_assert_convert_clone(x)
end

--- Wrap around bits of an integer (discarding left bits) considering bints.
-- @param x A bint or a lua integer.
-- @param y Number of right bits to preserve.
function bint.bwrap(x: BigInteger, y: integer): BigInteger
  x = bint_assert_convert(x)
  if y <= 0 then
    return bint_zero()
  elseif y < BINT_BITS then
    local tmp = (bint_one() << y)
    local tmp2 = tmp:_dec():tointeger()
    return x & tmp2
  end
  return bint_new(x)
end

--- Rotate left integer x by y bits considering bints.
-- @param x A bint or a lua integer.
-- @param y Number of bits to rotate.
function bint.brol(x: BigInteger, y: integer): BigInteger
  x, y = bint_assert_convert(x), bint_assert_tointeger(y)
  if y > 0 then
    return (x << y) | (x >> (BINT_BITS - y))
  elseif y < 0 then
    if y ~= math_mininteger then
      return x:bror(-y)
    else
      x:bror(-(y+1))
      x:bror(1)
    end
  end
  return x
end

--- Rotate right integer x by y bits considering bints.
-- @param x A bint or a lua integer.
-- @param y Number of bits to rotate.
function bint.bror(x: BigInteger, y: integer): BigInteger
  x, y = bint_assert_convert(x), bint_assert_tointeger(y)
  if y > 0 then
    return (x >> y) | (x << (BINT_BITS - y))
  elseif y < 0 then
    if y ~= math_mininteger then
      return x:brol(-y)
    else
      x:brol(-(y+1))
      x:brol(1)
    end
  end
  return x
end

--- Take maximum between two numbers considering bints.
-- @param x A bint or lua number to compare.
-- @param y A bint or lua number to compare.
-- @return A bint or a lua number. Guarantees to return a new bint for integer values.
function bint.max(x: BigInteger, y: BigInteger): BigInteger
  local ix: BigInteger = bint_assert_convert(x)
  local iy: BigInteger = bint_assert_convert(y)
  return bint_new(ix:gt(iy) and ix or iy)
end

--- Take minimum between two numbers considering bints.
-- @param x A bint or lua number to compare.
-- @param y A bint or lua number to compare.
-- @return A bint or a lua number. Guarantees to return a new bint for integer values.
function bint.min(x: BigInteger, y: BigInteger): BigInteger
  local ix: BigInteger = bint_assert_convert(x)
  local iy: BigInteger = bint_assert_convert(y)
  return bint_new(ix:lt(iy) and ix or iy)
end

--- Add an integer to a bint (in-place).
-- @param y An integer to be added.
-- @raise Asserts in case inputs are not convertible to integers.
function bint:_add(y: BigInteger): BigInteger
  y = bint_assert_convert(y)
  local carry: integer = 0
  for i=1,BINT_SIZE do
    local tmp: integer = self[i] + y[i] + carry
    carry = tmp >> BINT_WORDBITS
    self[i] = tmp & BINT_WORDMAX
  end
  return self
end

--- Add two numbers considering bints.
-- @param x A bint or a lua number to be added.
-- @param y A bint or a lua number to be added.
function bint.__add(x: BigInteger, y: BigInteger): BigInteger
  local ix: BigInteger = bint_assert_convert(x)
  local iy: BigInteger = bint_assert_convert(y)
  local z: BigInteger = setmetatable({}, bint as metatable<BigInteger>)
  local carry: integer = 0
  for i=1,BINT_SIZE do
      local tmp: integer = ix[i] + iy[i] + carry
      carry = tmp >> BINT_WORDBITS
      z[i] = tmp & BINT_WORDMAX
  end
  return z
end

--- Subtract an integer from a bint (in-place).
-- @param y An integer to subtract.
-- @raise Asserts in case inputs are not convertible to integers.
function bint:_sub(y: BigInteger): BigInteger
  y = bint_assert_convert(y)
  local borrow: integer = 0
  local wordmaxp1: integer = BINT_WORDMAX + 1
  for i=1,BINT_SIZE do
    local res: integer = self[i] + wordmaxp1 - y[i] - borrow
    self[i] = res & BINT_WORDMAX
    borrow = (res >> BINT_WORDBITS) ~ 1
  end
  return self
end

--- Subtract two numbers considering bints.
-- @param x A bint or a lua number to be subtracted from.
-- @param y A bint or a lua number to subtract.
function bint.__sub(x: BigInteger, y: BigInteger): BigInteger
  local ix: BigInteger = bint_assert_convert(x)
  local iy: BigInteger = bint_assert_convert(y)
  local z: BigInteger = setmetatable({}, bint as metatable<BigInteger>)
  local borrow: integer = 0
  local wordmaxp1: integer = BINT_WORDMAX + 1
    for i=1,BINT_SIZE do
      local res: integer = ix[i] + wordmaxp1 - iy[i] - borrow
      z[i] = res & BINT_WORDMAX
      borrow = (res >> BINT_WORDBITS) ~ 1
  end
  return z
end

--- Multiply two numbers considering bints.
-- @param x A bint or a lua number to multiply.
-- @param y A bint or a lua number to multiply.
function bint.__mul(x: BigInteger, y: BigInteger): BigInteger
  local ix: BigInteger = bint_assert_convert(x)
  local iy: BigInteger = bint_assert_convert(y)
  local z: BigInteger = bint_zero()
  local sizep1: integer = BINT_SIZE+1
    local s: integer = sizep1
    local e: integer = 0
    for i=1,BINT_SIZE do
      if ix[i] ~= 0 or iy[i] ~= 0 then
        e = math_max(e, i)
        s = math_min(s, i)
      end
    end
    for i=s,e do
      for j=s,math_min(sizep1-i,e) do
        local a: integer = ix[i] * iy[j]
        if a ~= 0 then
          local carry: integer = 0
          for k=i+j-1,BINT_SIZE do
            local tmp: integer = z[k] + (a & BINT_WORDMAX) + carry
            carry = tmp >> BINT_WORDBITS
            z[k] = tmp & BINT_WORDMAX
            a = a >> BINT_WORDBITS
          end
        end
      end
    end
  return z
end

--- Check if bints are equal.
-- @param x A bint to compare.
-- @param y A bint to compare.
function bint.__eq(x: BigInteger, y: BigInteger): boolean
  bint_assert_convert(x)
  bint_assert_convert(y)
  for i=1,BINT_SIZE do
    if x[i] ~= y[i] then
      return false
    end
  end
  return true
end

--- Check if numbers are equal considering bints.
-- @param x A bint or lua number to compare.
-- @param y A bint or lua number to compare.
function bint.eq(x: BigInteger, y: BigInteger): boolean
  local ix: BigInteger = bint_assert_convert(x)
  local iy: BigInteger = bint_assert_convert(y)
  return ix == iy
end
local bint_eq: function(x: BigInteger, y: BigInteger): boolean = bint.eq

local function findleftbit(x: BigInteger): integer, integer
  for i=BINT_SIZE,1,-1 do
    local v: integer = x[i]
    if v ~= 0 then
      local j: integer = 0
      repeat
        v = v >> 1
        j = j + 1
      until v == 0
      return (i-1)*BINT_WORDBITS + j - 1, i
    end
  end
end

-- Single word division modulus
local function sudivmod(nume: BigInteger, deno: integer): integer
  local rema: integer
  local carry: integer = 0
  for i=BINT_SIZE,1,-1 do
    carry = carry | nume[i]
    nume[i] = carry // deno
    rema = carry % deno
    carry = rema << BINT_WORDBITS
  end
  return rema
end

--- Perform unsigned division and modulo operation between two integers considering bints.
-- This is effectively the same of @{bint.udiv} and @{bint.umod}.
-- @param x The numerator, must be a bint or a lua integer.
-- @param y The denominator, must be a bint or a lua integer.
-- @return The quotient following the remainder, both bints.
-- @raise Asserts on attempt to divide by zero
-- or if inputs are not convertible to integers.
-- @see bint.udiv
-- @see bint.umod
function bint.udivmod(x: BigInteger, y: BigInteger): BigInteger, BigInteger
  local nume: BigInteger = bint_assert_convert_clone(x)
  local deno: BigInteger = bint_assert_convert(y)
  -- compute if high bits of denominator are all zeros
  local ishighzero = true
  for i=2,BINT_SIZE do
    if deno[i] ~= 0 then
      ishighzero = false
      break
    end
  end
  if ishighzero then
    -- try to divide by a single word (optimization)
    local low = deno[1]
    assert(low ~= 0, 'attempt to divide by zero')
    if low == 1 then
      -- denominator is one
      return nume, bint_zero()
    elseif low <= (BINT_WORDMSB - 1) then
      -- can do single word division
      local rema = sudivmod(nume, low)
      return nume, bint_fromuinteger(rema)
    end
  end
  if nume:ult(deno) then
    -- denominator is greater than numerator
    return bint_zero(), nume
  end
  -- align leftmost digits in numerator and denominator
  local denolbit = findleftbit(deno)
  local numelbit, numesize = findleftbit(nume)
  local bit = numelbit - denolbit
  deno = deno << bit
  local wordmaxp1 = BINT_WORDMAX + 1
  local wordbitsm1 = BINT_WORDBITS - 1
  local denosize = numesize
  local quot = bint_zero()
  while bit >= 0 do
    -- compute denominator <= numerator
    local le = true
    local size = math_max(numesize, denosize)
    for i=size,1,-1 do
      local a, b = deno[i], nume[i]
      if a ~= b then
        le = a < b
        break
      end
    end
    -- if the portion of the numerator above the denominator is greater or equal than to the denominator
    if le then
      -- subtract denominator from the portion of the numerator
      local borrow = 0
      for i=1,size do
        local res = nume[i] + wordmaxp1 - deno[i] - borrow
        nume[i] = res & BINT_WORDMAX
        borrow = (res >> BINT_WORDBITS) ~ 1
      end
      -- concatenate 1 to the right bit of the quotient
      local i = (bit // BINT_WORDBITS) + 1
      quot[i] = quot[i] | (1 << (bit % BINT_WORDBITS))
    end
    -- shift right the denominator in one bit
    for i=1,denosize-1 do
      deno[i] = ((deno[i] >> 1) | (deno[i+1] << wordbitsm1)) & BINT_WORDMAX
    end
    local lastdenoword = deno[denosize] >> 1
    deno[denosize] = lastdenoword
    -- recalculate denominator size (optimization)
    if lastdenoword == 0 then
      while deno[denosize] == 0 do
        denosize = denosize - 1
      end
      if denosize == 0 then
        break
      end
    end
    -- decrement current set bit for the quotient
    bit = bit - 1
  end
-- the remaining numerator is the remainder
return quot, nume
end
local bint_udivmod: function(x: BigInteger, y: BigInteger): BigInteger, BigInteger = bint.udivmod

--- Perform unsigned division between two integers considering bints.
-- @param x The numerator, must be a bint or a lua integer.
-- @param y The denominator, must be a bint or a lua integer.
-- @return The quotient, a bint.
-- @raise Asserts on attempt to divide by zero
-- or if inputs are not convertible to integers.
function bint.udiv(x: BigInteger, y: BigInteger): BigInteger
  bint_assert_convert(x)
  bint_assert_convert(y)
  return (bint_udivmod(x, y))
end

--- Perform unsigned integer modulo operation between two integers considering bints.
-- @param x The numerator, must be a bint or a lua integer.
-- @param y The denominator, must be a bint or a lua integer.
-- @return The remainder, a bint.
-- @raise Asserts on attempt to divide by zero
-- or if the inputs are not convertible to integers.
function bint.umod(x: BigInteger, y: BigInteger): BigInteger
  bint_assert_convert(x)
  bint_assert_convert(y)
  local _, rema: BigInteger = bint_udivmod(x, y)
  return rema
end
local bint_umod: function(x: BigInteger, y: BigInteger): BigInteger = bint.umod

--- Perform integer truncate division and modulo operation between two numbers considering bints.
-- This is effectively the same of @{bint.tdiv} and @{bint.tmod}.
-- @param x The numerator, a bint or lua number.
-- @param y The denominator, a bint or lua number.
-- @return The quotient following the remainder, both bint or lua number.
-- @raise Asserts on attempt to divide by zero or on division overflow.
-- @see bint.tdiv
-- @see bint.tmod
function bint.tdivmod(x: BigInteger, y: BigInteger): BigInteger, BigInteger
  bint_assert_convert(x)
  bint_assert_convert(y)
  local ax: BigInteger
  local ay: BigInteger
  ax, ay = bint_abs(x), bint_abs(y)

  local ix: BigInteger
  local iy: BigInteger
  ix, iy = tobint(ax, false), tobint(ay, false)
  local quot: BigInteger
  local rema: BigInteger
  if ix and iy then
    assert(not (bint_eq(x, BINT_MININTEGER) and bint_isminusone(y)), 'division overflow')
    quot, rema = bint_udivmod(ix, iy)
  else
    quot, rema = ax // ay, ax % ay
  end
  local isxneg: boolean
  local isyneg: boolean
  isxneg, isyneg = bint_isneg(x), bint_isneg(y)

  if isxneg ~= isyneg then
    quot = -quot
  end
  if isxneg then
    rema = -rema
  end
  return quot, rema
end
local bint_tdivmod: function(x: BigInteger, y: BigInteger): BigInteger, BigInteger = bint.tdivmod

--- Perform truncate division between two numbers considering bints.
-- Truncate division is a division that rounds the quotient towards zero.
-- @param x The numerator, a bint or lua number.
-- @param y The denominator, a bint or lua number.
-- @return The quotient, a bint or lua number.
-- @raise Asserts on attempt to divide by zero or on division overflow.
function bint.tdiv(x: BigInteger, y: BigInteger): BigInteger
  bint_assert_convert(x)
  bint_assert_convert(y)
  return (bint_tdivmod(x, y))
end

--- Perform integer truncate modulo operation between two numbers considering bints.
-- The operation is defined as the remainder of the truncate division
-- (division that rounds the quotient towards zero).
-- @param x The numerator, a bint or lua number.
-- @param y The denominator, a bint or lua number.
-- @return The remainder, a bint or lua number.
-- @raise Asserts on attempt to divide by zero or on division overflow.
function bint.tmod(x: BigInteger, y: BigInteger): BigInteger
  local _, rema: BigInteger = bint_tdivmod(x, y)
  return rema
end


--- Perform integer floor division and modulo operation between two numbers considering bints.
-- This is effectively the same of @{bint.__idiv} and @{bint.__mod}.
-- @param x The numerator, a bint or lua number.
-- @param y The denominator, a bint or lua number.
-- @return The quotient following the remainder, both bint or lua number.
-- @raise Asserts on attempt to divide by zero.
-- @see bint.__idiv
-- @see bint.__mod
function bint.idivmod(x: BigInteger, y: BigInteger): BigInteger, BigInteger
  local ix: BigInteger = bint_assert_convert(x)
  local iy: BigInteger = bint_assert_convert(y)
  local isnumeneg: boolean = ix[BINT_SIZE] as integer & BINT_WORDMSB ~= 0
  local isdenoneg: boolean = iy[BINT_SIZE] as integer & BINT_WORDMSB ~= 0
  if isnumeneg then
    ix = -ix
  end
  if isdenoneg then
    iy = -iy
  end
  local quot: BigInteger
  local rema: BigInteger
  quot, rema = bint_udivmod(ix, iy)
  if isnumeneg ~= isdenoneg then
    quot:_unm()
    -- round quotient towards minus infinity
    if not rema:iszero() then
      quot:_dec()
      -- adjust the remainder
      if isnumeneg and not isdenoneg then
        rema:_unm():_add(y)
      elseif isdenoneg and not isnumeneg then
        rema:_add(y)
      end
    end
  elseif isnumeneg then
    -- adjust the remainder
    rema:_unm()
  end
  return quot, rema
end
local bint_idivmod: function(x: BigInteger, y: BigInteger): BigInteger, BigInteger = bint.idivmod

--- Perform floor division between two numbers considering bints.
-- Floor division is a division that rounds the quotient towards minus infinity,
-- resulting in the floor of the division of its operands.
-- @param x The numerator, a bint or lua number.
-- @param y The denominator, a bint or lua number.
-- @return The quotient, a bint or lua number.
-- @raise Asserts on attempt to divide by zero.
function bint.__idiv(x: BigInteger, y: BigInteger): BigInteger, BigInteger
  local ix: BigInteger = bint_assert_convert(x)
  local iy: BigInteger = bint_assert_convert(y)
  local isnumeneg: boolean = ix[BINT_SIZE] as integer & BINT_WORDMSB ~= 0
  local isdenoneg: boolean = iy[BINT_SIZE] as integer & BINT_WORDMSB ~= 0
  if isnumeneg then
    ix = -ix
  end
  if isdenoneg then
    iy = -iy
  end
  local quot: BigInteger
  local rema: BigInteger
  quot, rema = bint_udivmod(ix, iy)
  if isnumeneg ~= isdenoneg then
    quot:_unm()
    -- round quotient towards minus infinity
    if not rema:iszero() then
      quot:_dec()
    end
  end
  return quot, rema
end


--- Perform integer floor modulo operation between two numbers considering bints.
-- The operation is defined as the remainder of the floor division
-- (division that rounds the quotient towards minus infinity).
-- @param x The numerator, a bint or lua number.
-- @param y The denominator, a bint or lua number.
-- @return The remainder, a bint or lua number.
-- @raise Asserts on attempt to divide by zero.
function bint.__mod(x: BigInteger, y: BigInteger): BigInteger
  local _, rema: BigInteger = bint_idivmod(x, y)
  return rema
end

--- Perform integer power between two integers considering bints.
-- If y is negative then pow is performed as an unsigned integer.
-- @param x The base, an integer.
-- @param y The exponent, an integer.
-- @return The result of the pow operation, a bint.
-- @raise Asserts in case inputs are not convertible to integers.
-- @see bint.__pow
-- @see bint.upowmod
function bint.ipow(x: BigInteger, y: BigInteger): BigInteger
  local ix: BigInteger = bint_assert_convert(x)
  local iy: BigInteger = bint_assert_convert(y)
  if iy:iszero() then
    return bint_one()
  elseif iy:isone() then
    return bint_new(ix)
  end
  -- compute exponentiation by squaring
  x, y = bint_new(x),  bint_new(y)
  local z = bint_one()
  repeat
    if y:iseven() then
      x = x * x
      y:_shrone()
    else
      z = x * z
      x = x * x
      y:_dec():_shrone()
    end
  until y:isone()
  return x * z
end

--- Perform integer power between two unsigned integers over a modulus considering bints.
-- @param x The base, an integer.
-- @param y The exponent, an integer.
-- @param m The modulus, an integer.
-- @return The result of the pow operation, a bint.
-- @raise Asserts in case inputs are not convertible to integers.
-- @see bint.__pow
-- @see bint.ipow
function bint.upowmod(x: BigInteger, y: BigInteger, m: BigInteger): BigInteger
  local mi = bint_assert_convert(m)
  if mi:isone() then
    return bint_zero()
  end
  local xi = bint_new(x)
  local yi = bint_new(y)
  local z = bint_one()
  xi = bint_umod(xi, mi)
  while not yi:iszero() do
    if yi:isodd() then
      z = bint_umod(z*xi, mi)
    end
    yi:_shrone()
    xi = bint_umod(xi*xi, mi)
  end
  return z
end


--- Bitwise left shift integers considering bints.
-- @param x An integer to perform the bitwise shift.
-- @param y An integer with the number of bits to shift.
-- @return The result of shift operation, a bint.
-- @raise Asserts in case inputs are not convertible to integers.
function bint.__shl(x: BigInteger, y: integer): BigInteger
  x, y = bint_assert_convert_clone(x), bint_assert_tointeger(y)
  if y == math_mininteger or math_abs(y) >= BINT_BITS then
    return bint_zero()
  end
  if y < 0 then
    return x >> -y
  end
  local nvals: integer = y // BINT_WORDBITS
  if nvals ~= 0 then
    x:_shlwords(nvals)
    y = y - nvals * BINT_WORDBITS
  end
  if y ~= 0 then
    local wordbitsmy: integer = BINT_WORDBITS - y
    for i=BINT_SIZE,2,-1 do
      x[i] = ((x[i] << y) | (x[i-1] >> wordbitsmy)) & BINT_WORDMAX
    end
    x[1] = (x[1] << y) & BINT_WORDMAX
  end
  return x
end

--- Bitwise right shift integers considering bints.
-- @param x An integer to perform the bitwise shift.
-- @param y An integer with the number of bits to shift.
-- @return The result of shift operation, a bint.
-- @raise Asserts in case inputs are not convertible to integers.
function bint.__shr(x: BigInteger, y: integer): BigInteger
  x, y = bint_assert_convert_clone(x), bint_assert_tointeger(y)
  if y == math_mininteger or math_abs(y) >= BINT_BITS then
    return bint_zero()
  end
  if y < 0 then
    return x << -y
  end
  local nvals: integer = y // BINT_WORDBITS
  if nvals ~= 0 then
    x:_shrwords(nvals)
    y = y - nvals * BINT_WORDBITS
  end
  if y ~= 0 then
    local wordbitsmy: integer = BINT_WORDBITS - y
    for i=1,BINT_SIZE-1 do
      x[i] = ((x[i] >> y) | (x[i+1] << wordbitsmy)) & BINT_WORDMAX
    end
    x[BINT_SIZE] = x[BINT_SIZE] >> y
  end
  return x
end

--- Bitwise AND bints (in-place).
-- @param y An integer to perform bitwise AND.
-- @raise Asserts in case inputs are not convertible to integers.
function bint:_band(y: integer): BigInteger
  local yi: BigInteger = bint_assert_convert_from_integer(y)
  for i=1,BINT_SIZE do
    self[i] = self[i] & yi[i]
  end
  return self
end

--- Bitwise AND two integers considering bints.
-- @param x An integer to perform bitwise AND.
-- @param y An integer to perform bitwise AND.
-- @raise Asserts in case inputs are not convertible to integers.
function bint.__band(x: BigInteger, y: integer): BigInteger
  return bint_assert_convert_clone(x):_band(y)
end

--- Bitwise OR bints (in-place).
-- @param y An integer to perform bitwise OR.
-- @raise Asserts in case inputs are not convertible to integers.
function bint:_bor(y: BigInteger): BigInteger
  y = bint_assert_convert(y)
  for i=1,BINT_SIZE do
    self[i] = self[i] | y[i]
  end
  return self
end

--- Bitwise OR two integers considering bints.
-- @param x An integer to perform bitwise OR.
-- @param y An integer to perform bitwise OR.
-- @raise Asserts in case inputs are not convertible to integers.
function bint.__bor(x: BigInteger, y: BigInteger): BigInteger
  return bint_assert_convert_clone(x):_bor(y)
end

--- Bitwise XOR bints (in-place).
-- @param y An integer to perform bitwise XOR.
-- @raise Asserts in case inputs are not convertible to integers.
function bint:_bxor(y: BigInteger): BigInteger
  y = bint_assert_convert(y)
  for i=1,BINT_SIZE do
    self[i] = self[i] ~ y[i]
  end
  return self
end

--- Bitwise XOR two integers considering bints.
-- @param x An integer to perform bitwise XOR.
-- @param y An integer to perform bitwise XOR.
-- @raise Asserts in case inputs are not convertible to integers.
function bint.__bxor(x: BigInteger, y: BigInteger): BigInteger
  return bint_assert_convert_clone(x):_bxor(y)
end

--- Bitwise NOT a bint (in-place).
function bint:_bnot(): BigInteger
  for i=1,BINT_SIZE do
    self[i] = (~self[i]) & BINT_WORDMAX
  end
  return self
end

function bint.__bnot(x: BigInteger): BigInteger
  local y: BigInteger = setmetatable({}, bint as metatable<BigInteger>)
  for i=1,BINT_SIZE do
    y[i] = (~x[i]) & BINT_WORDMAX
  end
  return y
end

--- Negate a bint (in-place). This effectively applies two's complements.
function bint:_unm():BigInteger
return self:_bnot():_inc()
end

--- Negate a bint. This effectively applies two's complements.
-- @param x A bint to perform negation.
function bint.__unm(x: BigInteger): BigInteger
return (~x):_inc()
end

--- Compare if integer x is less than y considering bints (unsigned version).
-- @param x Left integer to compare.
-- @param y Right integer to compare.
-- @raise Asserts in case inputs are not convertible to integers.
-- @see bint.__lt
function bint.ult(x: BigInteger, y: BigInteger): boolean
  for i=BINT_SIZE,1,-1 do
    local a: integer = x[i]
    local b: integer = y[i]
    if a ~= b then
      return a < b
    end
  end
  return false
end

--- Compare if bint x is less or equal than y considering bints (unsigned version).
-- @param x Left integer to compare.
-- @param y Right integer to compare.
-- @raise Asserts in case inputs are not convertible to integers.
-- @see bint.__le
function bint.ule(x: BigInteger, y: BigInteger): boolean
  x, y = bint_assert_convert(x), bint_assert_convert(y)
  for i=BINT_SIZE,1,-1 do
    local a: integer = x[i]
    local b: integer = y[i]
    if a ~= b then
      return a < b
    end
  end
  return true
end

--- Compare if number x is less than y considering bints and signs.
-- @param x Left value to compare, a bint or lua number.
-- @param y Right value to compare, a bint or lua number.
-- @see bint.ult
function bint.lt(x: BigInteger, y: BigInteger): boolean
  local ix: BigInteger = bint_assert_convert(x)
  local iy: BigInteger = bint_assert_convert(y)

  local xneg: boolean = ix[BINT_SIZE] as integer & BINT_WORDMSB ~= 0
  local yneg: boolean = iy[BINT_SIZE] as integer & BINT_WORDMSB ~= 0
  if xneg == yneg then
    for i=BINT_SIZE,1,-1 do
      local a: integer = ix[i]
      local b: integer = iy[i]
      if a ~= b then
        return a < b
      end
    end
    return false
  end
  return xneg and not yneg
end

function bint:gt(y: BigInteger): boolean
  return not self:eq(y) and not self:lt(y)
end

--- Compare if number x is less or equal than y considering bints and signs.
-- @param x Left value to compare, a bint or lua number.
-- @param y Right value to compare, a bint or lua number.
-- @see bint.ule
function bint.le(x: BigInteger, y: BigInteger): boolean
  local ix: BigInteger = bint_assert_convert(x)
  local iy: BigInteger = bint_assert_convert(y)
  local xneg: boolean = ix[BINT_SIZE] as integer & BINT_WORDMSB ~= 0
  local yneg: boolean = iy[BINT_SIZE] as integer & BINT_WORDMSB ~= 0
  if xneg == yneg then
    for i=BINT_SIZE,1,-1 do
      local a: integer = ix[i]
      local b: integer = iy[i]
      if a ~= b then
        return a < b
      end
    end
    return true
  end
  return xneg and not yneg
end

function bint:ge(y: BigInteger): boolean
  return self:eq(y) or self:gt(y)
end

--- Convert a bint to a string on base 10.
-- @see bint.tobase
function bint:__tostring(): string
  return self:tobase(10, false)
end

-- Allow creating bints by calling bint itself
setmetatable(bint, {
  __call = function(_: BigInteger, x: number | string | BigInteger): BigInteger
    return bint_new(x)
  end,
})

BINT_MATHMININTEGER, BINT_MATHMAXINTEGER = bint_new(math.mininteger), bint_new(math.maxinteger)
BINT_MININTEGER = bint.mininteger()
memo[memoindex] = bint

return bint

end

return newmodule