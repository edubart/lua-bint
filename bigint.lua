local bigint = {}
bigint.__index = bigint

local BIGINT_SIZE
local BIGINT_VALBITS
local BIGINT_VALMAX
local BIGINT_SIGNBIT
local BIGINT_HALFMAX

local function _bigint_newempty()
  return setmetatable({}, bigint)
end

function bigint.scale(size, bits)
  assert(bits <= 32)
  assert(size * bits >= 64)
  BIGINT_SIZE = size
  BIGINT_VALBITS = bits
  BIGINT_VALMAX = (1 << BIGINT_VALBITS) - 1
  BIGINT_SIGNBIT = (1 << (BIGINT_VALBITS - 1))
  BIGINT_HALFMAX = 1 + BIGINT_VALMAX // 2
end

bigint.scale(4, 32)

function bigint:_fromunsigned(x)
  for i=1,BIGINT_SIZE do
    self[i] = x & BIGINT_VALMAX
    x = x >> BIGINT_VALBITS
  end
  return self
end

function bigint.fromunsigned(x)
  x = tonumber(x)
  assert(math.type(x) == 'integer', 'number has no integer representation')
  return _bigint_newempty():fromunsigned(x)
end

function bigint.frominteger(x)
  x = tonumber(x)
  assert(math.type(x) == 'integer', 'number has no integer representation')
  local neg = false
  if x < 0 then
    x = math.abs(x)
    neg = true
  end
  local n = _bigint_newempty():_fromunsigned(x)
  if neg then
    n:_unm()
  end
  return n
end

function bigint.fromnumber(x)
  x = tonumber(x)
  local ty = math.type(x)
  assert(ty, 'invalid number')
  if ty ~= 'integer' then
    -- truncate to integer
    x = math.modf(x)
  end
  return bigint.frominteger(x)
end

function bigint.fromstring(s, base)
  s = s:lower()
  base = base or 10
  assert(base <= 36, 'number base is too large')
  local sign, int = s:match('^([+-]?)(%w+)$')
  assert(sign and int, 'invalid integer string representation')
  local n = bigint.zero()
  local step = 10
  for i=1,#int,step do
    local part = int:sub(i,i+step-1)
    local d = tonumber(part, base)
    assert(d, 'invalid integer string representation')
    n:_mul(base ^ #part):_add(d)
  end
  if sign == '-' then
    n:_unm()
  end
  return n
end

function bigint.tostring(x, base)
  x = bigint.new(x)
  base = base or 10
  assert(base <= 36, 'number base is too large')
  local BASE_LETTERS = '0123456789abcdefghijklmnopqrstuvwxyz'
  local ss = {}
  local neg = base == 10 and x:isneg()
  if neg then
    x:_abs()
  end
  while not x:iszero() do
    local d
    x, d = bigint.udivmod(x, base)
    d = d:tounsigned()
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

function bigint.from(x)
  if getmetatable(x) == bigint then
    return x
  elseif type(x) == 'number' then
    return bigint.fromnumber(x)
  else
    return bigint.frombase(x, 10)
  end
end

function bigint.clone(x)
  assert(getmetatable(x) == bigint, 'invalid bigint')
  local n = {}
  for i=1,BIGINT_SIZE do
    n[i] = x[i]
  end
  setmetatable(n, bigint)
  return n
end

function bigint.new(x)
  if getmetatable(x) == bigint then
    return x:clone()
  elseif type(x) == 'number' then
    return bigint.fromnumber(x)
  else
    return bigint.frombase(x, 10)
  end
end

function bigint:_zero()
  for i=1,BIGINT_SIZE do
    self[i] = 0
  end
  return self
end

function bigint.zero()
  return _bigint_newempty():_zero()
end

function bigint:_one()
  self[1] = 1
  for i=2,BIGINT_SIZE do
    self[i] = 0
  end
  return self
end

function bigint.one()
  return _bigint_newempty():_one()
end

function bigint.iszero(x)
  x = bigint.from(x)
  for i=1,BIGINT_SIZE do
    if x[i] ~= 0 then
      return false
    end
  end
  return true
end

function bigint.isminusone(x)
  x = bigint.from(x)
  for i=1,BIGINT_SIZE do
    if x[i] ~= BIGINT_VALMAX then
      return false
    end
  end
  return true
end

function bigint.isneg(x)
  x = bigint.from(x)
  return x[BIGINT_SIZE] & BIGINT_SIGNBIT ~= 0
end

function bigint.tounsigned(x)
  x = bigint.from(x)
  local n = 0
  for i=1,BIGINT_SIZE do
    n = n | (x[i] << (BIGINT_VALBITS * (i - 1)))
  end
  return n
end

function bigint.tosigned(x)
  x = bigint.from(x)
  local n = 0
  local neg = x:isneg()
  if neg then
    x = -x
  end
  for i=1,BIGINT_SIZE do
    n = n | (x[i] << (BIGINT_VALBITS * (i - 1)))
  end
  if neg then
    n = -n
  end
  return n
end

function bigint.tonumber(x)
  if getmetatable(x) == bigint then
    return bigint.tosigned(x)
  end
  return tonumber(x)
end

function bigint.tointeger(x)
  if getmetatable(x) == bigint then
    return bigint.tosigned(x)
  else
    x = tonumber(x)
    assert(x, 'invalid number')
    if math.type(x) == 'integer' then
      return x
    else
      return math.floor(x)
    end
  end
end

function bigint:_shlone()
  for i=BIGINT_SIZE,2,-1 do
    self[i] = ((self[i] << 1) | (self[i-1] >> (BIGINT_VALBITS - 1))) & BIGINT_VALMAX
  end
  self[1] = (self[1] << 1) & BIGINT_VALMAX
  return self
end

function bigint:_shrone()
  for i=1,BIGINT_SIZE-1 do
    self[i] = ((self[i] >> 1) | (self[i+1] << (BIGINT_VALBITS - 1))) & BIGINT_VALMAX
  end
  self[BIGINT_SIZE] = self[BIGINT_SIZE] >> 1
  return self
end

function bigint:_shlvals(n)
  for i=BIGINT_SIZE,n+1,-1 do
    self[i] = self[i - n]
  end
  for i=1,n do
    self[i] = 0
  end
  return self
end

function bigint:_shrvals(n)
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

function bigint:_inc()
  for i=1,BIGINT_SIZE do
    local tmp = self[i]
    local v = (tmp + 1) & BIGINT_VALMAX
    self[i] = v
    if v > tmp then
      break
    end
  end
  return self
end

function bigint.inc(x)
  return bigint.new(x):_inc()
end

function bigint:_dec()
  for i=1,BIGINT_SIZE do
    local tmp = self[i]
    local v = (tmp - 1) & BIGINT_VALMAX
    self[i] = v
    if not (v > tmp) then
      break
    end
  end
  return self
end

function bigint.dec(x)
  return bigint.new(x):_dec()
end

function bigint:_assign(x)
  x = bigint.from(x)
  for i=1,BIGINT_SIZE do
    self[i] = x[i]
  end
  return self
end

function bigint:_abs()
  if self:isneg() then
    self:_unm()
  end
  return self
end

function bigint.abs(x)
  return bigint.new(x):_abs()
end

function bigint:_add(y)
  y = bigint.from(y)
  local carry = 0
  for i=1,BIGINT_SIZE do
    local tmp = self[i] + y[i] + carry
    carry = tmp > BIGINT_VALMAX and 1 or 0
    self[i] = tmp & BIGINT_VALMAX
  end
  return self
end

function bigint.__add(x, y)
  return bigint.new(x):_add(y)
end

function bigint:_sub(y)
  y = bigint.from(y)
  local borrow = 0
  for i=1,BIGINT_SIZE do
    local tmp1 = self[i] + (BIGINT_VALMAX + 1)
    local tmp2 = y[i] + borrow
    local res = tmp1 - tmp2
    self[i] = res & BIGINT_VALMAX
    borrow = res <= BIGINT_VALMAX and 1 or 0
  end
  return self
end

function bigint.__sub(x, y)
  return bigint.new(x):_sub(y)
end

local mul_tmp1 = _bigint_newempty()
local mul_tmp2 = _bigint_newempty()
local mul_tmp3 = _bigint_newempty()

function bigint:_mul(y)
  local x, row, tmp = mul_tmp1, mul_tmp2, mul_tmp3
  x:_assign(self)
  y = bigint.from(y)
  self:_zero()
  for i=1,BIGINT_SIZE do
    row:_zero()
    for j=1,BIGINT_SIZE do
      local nshifts = i+j-2
      if nshifts < BIGINT_SIZE then
        row:_add(tmp:_fromunsigned(x[i] * y[j]):_shlvals(nshifts))
      end
    end
    self:_add(row)
  end
  return self
end

function bigint.__mul(x, y)
  return bigint.new(x):_mul(y)
end

local udiv_tmp1 = _bigint_newempty()
local udiv_tmp2 = _bigint_newempty()
local udiv_tmp3 = _bigint_newempty()

function bigint:_udiv(y)
  y = bigint.from(y)
  assert(not y:iszero(), 'attempt to divide by zero')
  local current, dividend, denom = udiv_tmp1, udiv_tmp2, udiv_tmp3
  current:_one()
  dividend:_assign(self)
  denom:_assign(y)
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
  local quot = self
  quot:_zero()
  while not current:iszero() do
    if denom:ule(dividend) then
      dividend:_sub(denom)
      quot:_bor(current)
    end
    current:_shrone()
    denom:_shrone()
  end
  return self
end

function bigint.udiv(x, y)
  return bigint.new(x):_udiv(y)
end

local udivmod_tmp1 = _bigint_newempty()
function bigint.udivmod(x, y)
  x = bigint.new(x)
  y = bigint.from(y)
  local quot = bigint.new(x):_udiv(y)
  local rem = x:_sub(udivmod_tmp1:_assign(quot):_mul(y))
  return quot, rem
end

local umod_tmp1 = _bigint_newempty()
function bigint:_umod(y)
  y = bigint.from(y)
  return self:_sub(umod_tmp1:_assign(self):_udiv(y):_mul(y))
end

function bigint.umod(x, y)
  return bigint.new(x):_umod(y)
end

local idiv_tmp1 = _bigint_newempty()
local idiv_tmp2 = _bigint_newempty()
local idiv_tmp3 = _bigint_newempty()

function bigint:_idiv(y)
  -- integer division, round quotient towards minus infinity, that is floor(x / y)
  local x = idiv_tmp1:_assign(self)
  y = bigint.from(y)
  if y:isminusone() then
    return -x
  end
  local tmp = idiv_tmp2
  local quot = self
  quot:_abs():_udiv(tmp:_assign(y):_abs())
  if x:isneg() ~= y:isneg() then
    quot:_unm()

    -- round quotient towards minus infinity
    local rem = idiv_tmp3
    rem:_assign(x):_sub(tmp:_assign(y):_mul(quot))
    if not rem:iszero() then
      quot:_dec()
    end
  end
  return self
end

function bigint.__idiv(x, y)
  x = bigint.new(x)
  return x:_idiv(y)
end

local mod_tmp1 = _bigint_newempty()
function bigint:_mod(y)
  y = bigint.from(y)
  return self:_sub(mod_tmp1:_assign(self):_idiv(y):_mul(y))
end

function bigint.__mod(x, y)
  return bigint.new(x):_mod(y)
end

local pow_tmp1 = _bigint_newempty()
function bigint:_pow(y)
  y = bigint.tointeger(y)
  assert(y <= math.maxinteger, 'attempt to pow to a very large integer')
  assert(y >= 0, 'attempt to pow to a negative power')
  if y == 0 then
    self:_one()
  elseif not self:iszero() then
    local x = pow_tmp1:_assign(self)
    for _=2,y do
      self:_mul(x)
    end
  end
  return self
end

function bigint.__pow(x, y)
  return bigint.new(x):_pow(y)
end

function bigint.__shl(x, y)
  x, y = bigint.new(x), bigint.tointeger(y)
  if y < 0 then return x >> -y end
  local nvals = y // BIGINT_VALBITS
  if nvals ~= 0 then
    x:_shlvals(nvals)
    y = y - nvals * BIGINT_VALBITS
  end
  if y ~= 0 then
    for i=BIGINT_SIZE,2,-1 do
      x[i] = ((x[i] << y) | (x[i-1] >> (BIGINT_VALBITS - y))) & BIGINT_VALMAX
    end
    x[1] = (x[1] << y) & BIGINT_VALMAX
  end
  return x
end

function bigint.__shr(x, y)
  x, y = bigint.new(x), bigint.tointeger(y)
  if y < 0 then return x << -y end
  local nvals = y // BIGINT_VALBITS
  if nvals ~= 0 then
    x:_shrvals(nvals)
    y = y - nvals * BIGINT_VALBITS
  end
  if y ~= 0 then
    for i=1,BIGINT_SIZE-1 do
      x[i] = ((x[i] >> y) | (x[i+1] << (BIGINT_VALBITS - y))) & BIGINT_VALMAX
    end
    x[BIGINT_SIZE] = x[BIGINT_SIZE] >> y
  end
  return x
end

function bigint:_band( y)
  y = bigint.from(y)
  for i=1,BIGINT_SIZE do
    self[i] = self[i] & y[i]
  end
  return self
end

function bigint.__band(x, y)
  return bigint.new(x):_band(y)
end

function bigint:_bor(y)
  y = bigint.from(y)
  for i=1,BIGINT_SIZE do
    self[i] = self[i] | y[i]
  end
  return self
end

function bigint.__bor(x, y)
  return bigint.new(x):_bor(y)
end

function bigint._bxor(self, y)
  y = bigint.from(y)
  for i=1,BIGINT_SIZE do
    self[i] = self[i] ~ y[i]
  end
  return self
end

function bigint.__bxor(x, y)
  return bigint.new(x):_bxor(y)
end

function bigint:_bnot()
  for i=1,BIGINT_SIZE do
    self[i] = (~self[i]) & BIGINT_VALMAX
  end
  return self
end

function bigint.__bnot(x)
  return bigint.new(x):_bnot()
end

function bigint:_unm()
  -- apply two's complement
  return self:_bnot():_inc()
end

function bigint.__unm(x)
  return bigint.new(x):_unm()
end

function bigint.__eq(x, y)
  for i=1,BIGINT_SIZE do
    if x[i] ~= y[i] then
      return false
    end
  end
  return true
end

function bigint.ult(x, y)
  x, y = bigint.from(x), bigint.from(y)
  for i=BIGINT_SIZE,1,-1 do
    if x[i] < y[i] then
      return true
    elseif x[i] > y[i] then
      return false
    end
  end
  return false
end

function bigint.ule(x, y)
  x, y = bigint.from(x), bigint.from(y)
  for i=BIGINT_SIZE,1,-1 do
    if x[i] < y[i] then
      return true
    elseif x[i] ~= y[i] then
      return false
    end
  end
  return true
end

function bigint.__lt(x, y)
  x, y = bigint.from(x), bigint.from(y)
  local xneg, yneg = x:isneg(), y:isneg()
  if xneg == yneg then
    return bigint.ult(x, y)
  else
    return xneg and not yneg
  end
end

function bigint.__le(x, y)
  x, y = bigint.from(x), bigint.from(y)
  local xneg, yneg = x:isneg(), y:isneg()
  if xneg == yneg then
    return bigint.ule(x, y)
  else
    return xneg and not yneg
  end
end

function bigint:__tostring()
  return self:tostring(10)
end

setmetatable(bigint, {
  __call = function(_, x)
    return bigint.new(x)
  end
})

local function test(size, bits)
  bigint.scale(size, bits)

  local function assert_eq(a , b)
    if a ~= b then
      error('assertion failed: ' .. tostring(a) .. ' ~= ' .. tostring(b), 2)
    end
  end

  do --utils
    assert(bigint(0):iszero() == true)
    assert(bigint(1):iszero() == false)
    assert(bigint(-1):iszero() == false)

    assert(bigint(1):isminusone() == false)
    assert(bigint(0):isminusone() == false)
    assert(bigint(-1):isminusone() == true)
    assert(bigint(-2):isminusone() == false)

    assert(bigint(-1):isneg() == true)
    assert(bigint(-2):isneg() == true)
    assert(bigint(0):isneg() == false)
    assert(bigint(1):isneg() == false)
    assert(bigint(2):isneg() == false)
  end

  do -- number conversion
    local function test_num2num(x)
      assert_eq(bigint(x):tonumber(), x)
    end
    local function test_num2hex(x)
      assert_eq(bigint(x):tostring(16), ('%x'):format(x))
    end
    local function test_num2dec(x)
      assert_eq(bigint(x):tostring(10), ('%d'):format(x))
    end
    local function test_num2oct(x)
      assert_eq(bigint(x):tostring(8), ('%o'):format(x))
    end
    local function test_str2num(x)
      assert_eq(bigint.fromstring(tostring(x)):tonumber(), x)
    end
    local function test_ops(x)
      test_num2num(x)
      test_num2num(-x)
      test_num2hex(x)
      test_num2oct(x)
      if BIGINT_SIZE * BIGINT_VALBITS == 64 then
        test_num2hex(-x)
        test_num2oct(-x)
      end
      test_num2dec(x)
      test_num2dec(-x)
      test_str2num(x)
      test_str2num(-x)
    end
    test_ops(0)
    test_ops(1)
    test_ops(0xfffffffffe)
    test_ops(0xffffffff)
    test_ops(0xffffffff)
    test_ops(0x123456789abc)
    test_ops(0xf505c2)
    test_ops(0x9f735a)
    test_ops(0xcf7810)
    test_ops(0xbbc55f)
  end

  do -- add/sub/mul/band/bor/bxor/eq/lt/le
    local function test_add(x, y)
      assert_eq((bigint(x) + bigint(y)):tonumber(), x + y)
    end
    local function test_sub(x, y)
      assert_eq((bigint(x) - bigint(y)):tonumber(), x - y)
    end
    local function test_mul(x, y)
      assert_eq((bigint(x) * bigint(y)):tonumber(), x * y)
    end
    local function test_band(x, y)
      assert_eq((bigint(x) & bigint(y)):tonumber(), x & y)
    end
    local function test_bor(x, y)
      assert_eq((bigint(x) | bigint(y)):tonumber(), x | y)
    end
    local function test_bxor(x, y)
      assert_eq((bigint(x) ~ bigint(y)):tonumber(), x ~ y)
    end
    local function test_eq(x, y)
      assert_eq(bigint(x) == bigint(y), x == y)
    end
    local function test_le(x, y)
      assert_eq(bigint(x) <= bigint(y), x <= y)
    end
    local function test_lt(x, y)
      assert_eq(bigint(x) < bigint(y), x < y)
    end
    local function test_ops2(x, y)
      test_add(x, y)
      test_sub(x, y) test_sub(y, x)
      test_mul(x, y) test_mul(y, x)
      test_band(x, y)
      test_bor(x, y)
      test_bxor(x, y)
      test_eq(x, y) test_eq(y, x) test_eq(x, x) test_eq(y, y)
      test_lt(x, y) test_lt(y, x) test_lt(x, x) test_lt(y, y)
      test_le(x, y) test_le(y, x) test_le(x, x) test_le(y, y)
    end
    local function test_ops(x, y)
      test_ops2(x, y)
      test_ops2(-x, y)
      test_ops2(-x, -y)
      test_ops2(x, -y)
    end
    test_ops(0, 0)
    test_ops(1, 1)
    test_ops(1, 2)
    test_ops(80, 20)
    test_ops(18, 22)
    test_ops(12, 8)
    test_ops(100080, 20)
    test_ops(18, 559022)
    test_ops(2000000000, 2000000000)
    test_ops(0x00ffff, 1)
    test_ops(0x00ffff00, 0x00000100)
    test_ops(1000001, 1000000)
    test_ops(42, 0)
    test_ops(101, 100)
    test_ops(242, 42)
    test_ops(1042, 0)
    test_ops(101010101, 101010100)
    test_ops(0x010000, 1)
    test_ops(0xf505c2, 0x0fffe0)
    test_ops(0x9f735a, 0x65ffb5)
    test_ops(0xcf7810, 0x04ff34)
    test_ops(0xbbc55f, 0x4eff76)
    test_ops(0x100000, 1)
    test_ops(0x010000, 1)
    test_ops(0xb5beb4, 0x01ffc4)
    test_ops(0x707655, 0x50ffa8)
    test_ops(0xf0a990, 0x1cffd1)
    test_ops(0x010203, 0x1020)
    test_ops(42, 0)
    test_ops(42, 1)
    test_ops(42, 2)
    test_ops(42, 10)
    test_ops(42, 100)
    test_ops(420, 1000)
    test_ops(200, 8)
    test_ops(2, 256)
    test_ops(500, 2)
    test_ops(500000, 2)
    test_ops(500, 500)
    test_ops(1000000000, 2)
    test_ops(2, 1000000000)
    test_ops(1000000000, 4)
    test_ops(0xfffffffe, 0xffffffff)
    test_ops(0xffffffff, 0xffffffff)
    test_ops(0xffffffff, 0x10000)
    test_ops(0xffffffff, 0x1000)
    test_ops(0xffffffff, 0x100)
    test_ops(0xffffffff, 1)
    test_ops(1000000, 1000)
    test_ops(1000000, 10000)
    test_ops(1000000, 100000)
    test_ops(1000000, 1000000)
    test_ops(1000000, 10000000)
    test_ops(0xffffffff, 0x005500aa)
    test_ops(7, 3)
    test_ops(0xffffffff, 0)
    test_ops(0, 0xffffffff)
    test_ops(0xffffffff, 0xffffffff)
    test_ops(0xffffffff, 0)
    test_ops(0, 0xffffffff)
    test_ops(0x00000000, 0xffffffff)
    test_ops(0x55555555, 0xaaaaaaaa)
    test_ops(0xffffffff, 0xffffffff)
    test_ops(4, 3)
  end

  do --shl/shr
    local function test_shl(x, y)
      assert_eq((bigint(x) << y):tonumber(), x << y)
    end
    local function test_shr(x, y)
      assert_eq((bigint(x) >> y):tonumber(), x >> y)
    end
    local function test_ops(x, y)
      test_shl(x, y) test_shl(x, -y)
      test_shr(x, y) test_shr(x, -y)
    end
    test_ops(0, 0)
    test_ops(1, 0)
    test_ops(1, 1)
    test_ops(1, 2)
    test_ops(1, 3)
    test_ops(1, 4)
    test_ops(1, 5)
    test_ops(1, 6)
    test_ops(1, 7)
    test_ops(1, 8)
    test_ops(1, 9)
    test_ops(1, 10)
    test_ops(1, 11)
    test_ops(1, 12)
    test_ops(1, 13)
    test_ops(1, 14)
    test_ops(1, 15)
    test_ops(1, 16)
    test_ops(1, 17)
    test_ops(1, 18)
    test_ops(1, 19)
    test_ops(1, 20)
    test_ops(0xdd, 0x18)
    test_ops(0x68, 0x02)
    test_ops(0xf6, 1)
    test_ops(0x1a, 1)
    test_ops(0xb0, 1)
    test_ops(0xba, 1)
    test_ops(0x10, 3)
    test_ops(0xe8, 4)
    test_ops(0x37, 4)
    test_ops(0xa0, 7)
    test_ops(      1,  0)
    test_ops(      2,  1)
    test_ops(      4,  2)
    test_ops(      8,  3)
    test_ops(     16,  4)
    test_ops(     32,  5)
    test_ops(     64,  6)
    test_ops(    128,  7)
    test_ops(    256,  8)
    test_ops(    512,  9)
    test_ops(   1024, 10)
    test_ops(   2048, 11)
    test_ops(   4096, 12)
    test_ops(   8192, 13)
    test_ops(  16384, 14)
    test_ops(  32768, 15)
    test_ops(  65536, 16)
    test_ops( 131072, 17)
    test_ops( 262144, 18)
    test_ops( 524288, 19)
    test_ops(1048576, 20)
  end

  do -- pow
    local function test_pow(x, y)
      assert_eq((bigint(x) ^ y):tonumber(), math.floor(x ^ y))
    end
    local function test_ops(x, y)
      test_pow(x, y)
      test_pow(-x, y)
    end
    test_ops(0, 0)
    test_ops(0, 1)
    test_ops(0, 2)
    test_ops(0, 15)
    test_ops(1, 0)
    test_ops(1, 1)
    test_ops(1, 2)
    test_ops(1, 15)
    test_ops(2, 0)
    test_ops(2, 1)
    test_ops(2, 2)
    test_ops(2, 15)
    test_ops(7, 4)
    test_ops(7, 11)
  end

  do --bnot/unm
    local function test_bnot(x)
      assert_eq((~bigint(x)):tonumber(), ~x)
      assert_eq((~ ~bigint(x)):tonumber(), x)
    end
    local function test_unm(x)
      assert_eq((-bigint(x)):tonumber(), -x)
      assert_eq((- -bigint(x)):tonumber(), x)
    end
    local function test_ops(x)
      test_bnot(x) test_bnot(-x)
      test_unm(x) test_unm(-x)
    end
    test_ops(0)
    test_ops(1)
    test_ops(2)
    test_ops(15)
    test_ops(16)
    test_ops(17)
    test_ops(0xffffffff)
    test_ops(0xfffffffe)
    test_ops(0xf505c2)
    test_ops(0x9f735a)
    test_ops(0xcf7810)
    test_ops(0xbbc55f)
  end

  do -- idiv/mod
    local function test_idiv(x, y)
      assert_eq((bigint(x) // bigint(y)):tonumber(), x // y)
    end
    local function test_mod(x, y)
      assert_eq((bigint(x) % bigint(y)):tonumber(), x % y)
    end
    local function test_ops(x, y)
      test_idiv(x, y)
      test_idiv(x, -y)
      test_idiv(-x, -y)
      test_idiv(-x, y)
      test_mod(x, y)
      test_mod(x, -y)
      test_mod(-x, y)
      test_mod(-x, -y)
    end
    test_ops(0xffffffff, 0xffffffff)
    test_ops(0xffffffff, 0x10000)
    test_ops(0xffffffff, 0x1000)
    test_ops(0xffffffff, 0x100)
    test_ops(1000000, 1000)
    test_ops(1000000, 10000)
    test_ops(1000000, 100000)
    test_ops(1000000, 1000000)
    test_ops(1000000, 10000000)
    test_ops(8, 3)
    test_ops(28, 7)
    test_ops(27, 7)
    test_ops(26, 7)
    test_ops(25, 7)
    test_ops(24, 7)
    test_ops(23, 7)
    test_ops(22, 7)
    test_ops(21, 7)
    test_ops(20, 7)
    test_ops(0, 12)
    test_ops(1, 16)
    test_ops(10, 1)
    test_ops(1024, 1000)
    test_ops(12345678, 16384)
    test_ops(0xffffff, 1234)
    test_ops(0xffffffff, 1)
    test_ops(0xffffffff, 0xef)
    test_ops(0xffffffff, 0x10000)
    test_ops(0xb36627, 0x0dff95)
    test_ops(0xe5a18e, 0x09ff82)
    test_ops(0x45edd0, 0x04ff1a)
    test_ops(0xe7a344, 0x71ffe8)
    test_ops(0xa3a9a1, 0x2ff44)
    test_ops(0xc128b2, 0x60ff61)
    test_ops(0xdc2254, 0x517fea)
    test_ops(0x769c99, 0x2cffda)
    test_ops(0xc19076, 0x31ffd4)
  end
end

test(16, 4)
test(8, 8)
test(4, 16)
test(4, 28)
test(4, 32)
test(2, 32)
test(17, 4)
test(8, 32)

return bigint
