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
  bits = bits or 32
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
  assert(math.type(x) == 'integer', 'number has no integer representation')
  return _bigint_newempty():_fromunsigned(x)
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
    n = (n * (base ^ #part)):_add(d)
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

function bigint.clone(x)
  assert(getmetatable(x) == bigint, 'invalid bigint')
  local n = {}
  for i=1,BIGINT_SIZE do
    n[i] = x[i]
  end
  setmetatable(n, bigint)
  return n
end

function bigint.from(x)
  if getmetatable(x) == bigint then
    return x
  elseif type(x) == 'number' then
    return bigint.fromnumber(x)
  else
    return bigint.fromstring(x, 10)
  end
end

function bigint.new(x)
  if getmetatable(x) == bigint then
    return x:clone()
  elseif type(x) == 'number' then
    return bigint.fromnumber(x)
  else
    return bigint.fromstring(x, 10)
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

function bigint.__mul(x, y)
  x, y = bigint.from(x), bigint.from(y)
  local row, tmp = _bigint_newempty(), _bigint_newempty()
  local res = bigint.zero()
  for i=1,BIGINT_SIZE do
    row:_zero()
    for j=1,BIGINT_SIZE do
      local nshifts = i+j-2
      if nshifts < BIGINT_SIZE then
        row:_add(tmp:_fromunsigned(x[i] * y[j]):_shlvals(nshifts))
      end
    end
    res:_add(row)
  end
  return res
end

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

function bigint.umod(x, y)
  x, y = bigint.from(x), bigint.from(y)
  return x - (bigint.udiv(x, y) * y)
end

function bigint.udivmod(x, y)
  x, y = bigint.from(x), bigint.from(y)
  local quot = bigint.udiv(x, y)
  local rem = x - (quot * y)
  return quot, rem
end

function bigint.__idiv(x, y)
  -- integer division, round quotient towards minus infinity, that is floor(x / y)
  x, y = bigint.from(x), bigint.from(y)
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

function bigint.__mod(x, y)
  x, y = bigint.from(x), bigint.from(y)
  local quot = x // y
  return x - (quot * y)
end

function bigint.idivmod(x, y)
  x, y = bigint.from(x), bigint.from(y)
  local quot = x // y
  local rem = x - (quot * y)
  return quot, rem
end

function bigint.__pow(x, y)
  x = bigint.from(x)
  assert(y <= math.maxinteger, 'attempt to pow to a very large integer')
  assert(y >= 0, 'attempt to pow to a negative power')
  if y == 0 then
    return bigint.one()
  else
    x = bigint.from(x)
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

return bigint
