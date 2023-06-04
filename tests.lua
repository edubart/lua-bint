local function luainteger_bitsize()
  local n, i = -1, 0
  repeat
    n, i = n >> 16, i + 16
  until n==0
  return i
end

local function test(bits, wordbits)
  local bint = require 'bint'(bits, wordbits)
  local luabits = luainteger_bitsize()
  local bytes = bits // 8

  local function assert_eq(a, b)
    if a ~= b then --luacov:disable
      local msg = string.format(
        "assertion failed:\n  expected '%s' of type '%s',\n  but got '%s' of type '%s'",
        b, type(b), a, type(a))
      error(msg)
    end --luacov:enable
  end

  local function assert_eqf(a, b)
    assert(bint.abs(a - b) <= 1e-6, 'assertion failed')
  end

  do --utils
    assert(bint(-2):iszero() == false)
    assert(bint(-1):iszero() == false)
    assert(bint(0):iszero() == true)
    assert(bint(1):iszero() == false)
    assert(bint(2):iszero() == false)
    assert(bint.iszero(0) == true)

    assert(bint(-2):isone() == false)
    assert(bint(-1):isone() == false)
    assert(bint(0):isone() == false)
    assert(bint(1):isone() == true)
    assert(bint(2):isone() == false)
    assert(bint(1 | (1 << 31)):isone() == false)
    assert(bint.isone(1) == true)

    assert(bint(-1):isminusone() == true)
    assert(bint(-2):isminusone() == false)
    assert(bint(1):isminusone() == false)
    assert(bint(0):isminusone() == false)
    assert(bint(2):isminusone() == false)
    assert(bint.isminusone(-1) == true)

    assert(bint(-1):isneg() == true)
    assert(bint(-2):isneg() == true)
    assert(bint(0):isneg() == false)
    assert(bint(1):isneg() == false)
    assert(bint(2):isneg() == false)
    assert(bint.isneg(-1) == true)

    assert(bint(-1):ispos() == false)
    assert(bint(-2):ispos() == false)
    assert(bint(0):ispos() == false)
    assert(bint(1):ispos() == true)
    assert(bint(2):ispos() == true)
    assert(bint.ispos(1) == true)

    assert(bint(-2):iseven() == true)
    assert(bint(-1):iseven() == false)
    assert(bint(0):iseven() == true)
    assert(bint(1):iseven() == false)
    assert(bint(2):iseven() == true)
    assert(bint(3):iseven() == false)
    assert(bint.iseven(2) == true)
    assert(bint.iseven(-2) == true)

    assert(bint(-2):isodd() == false)
    assert(bint(-1):isodd() == true)
    assert(bint(0):isodd() == false)
    assert(bint(1):isodd() == true)
    assert(bint(2):isodd() == false)
    assert(bint(3):isodd() == true)
    assert(bint.isodd(1) == true)
    assert(bint.isodd(-1) == true)

    assert(bint.eq(1, 1) == true)
    assert(bint.eq(1, 0) == false)
    assert(bint.eq(1.5, 1.5) == true)
    assert(bint.eq(1.5, 1) == false)
    assert(bint.eq(1.5, 2.5) == false)

    assert(bint(1) < 1.5 == true)
    assert(bint(1) <= 1.5 ==  true)
    assert(bint(1) <= 1e20 == true)

    assert(bint.isbint(1) == false)
    assert(bint.isbint(bint(1)) == true)
    assert(bint.isintegral(1) == true)
    assert(bint.isintegral(bint(1)) == true)
    assert(bint.isnumeric(1) == true)
    assert(bint.isnumeric(1.5) == true)
    assert(bint.isnumeric(bint(1)) == true)
    assert(bint.type(1) == 'integer')
    assert(bint.type(1.5) == 'float')
    assert(bint.type(bint(1)) == 'bint')

    assert(tostring(bint.frombase('9223372036854775807')) == '9223372036854775807')
    assert(tostring(bint.frombase('-9223372036854775808')) == '-9223372036854775808')
    assert(bint.frombase('AAAAAAAAAAAAAAAAAAA') == nil)
    assert(bint.frombase('AAAAAAAAAAAAAAAAAAA_') == nil)

    assert(bint.fromstring(1) == nil)
    assert(bint.eq(bint.fromstring('0xff'), 0xff))
    assert(bint.eq(bint.fromstring('+0xff'), 0xff))
    assert(bint.eq(bint.fromstring('-0xff'), -0xff))
    assert(bint.eq(bint.fromstring('0b10100'), 0x14))
    assert(bint.eq(bint.fromstring('0b0'), 0))
    assert(bint.eq(bint.fromstring('0b1'), 1))
    assert(bint.eq(bint.fromstring('-0b1'), -1))
    assert(bint.eq(bint.fromstring('+0b1'), 1))
    assert(bint.eq(bint.fromstring('0'), 0))
    assert(bint.eq(bint.fromstring('-1'), -1))
    assert(bint.eq(bint.fromstring('1234'), 1234))

    assert(bint.fromle('\x00') == bint.zero())
    assert(bint.fromle('\x01') == bint.one())
    assert(bint.fromle('\x01\x02\x03') == bint.frombase('030201', 16))
    assert(bint.fromle(string.rep('\x00', bytes)) == bint.zero())
    assert(bint.fromle(string.rep('\x01', bytes)) == bint.frombase(string.rep('01', bytes), 16))
    assert(bint.fromle(string.rep('\x01', bytes+32)) == bint.frombase(string.rep('01', bytes), 16))
    assert(bint.fromle(string.rep('\xff', bytes)) == bint.frombase(string.rep('ff', bytes), 16))
    assert(bint.fromle(string.rep('\xff', bytes+32)) == bint.frombase(string.rep('ff', bytes), 16))

    assert(bint.frombe('\x00') == bint.zero())
    assert(bint.frombe('\x01') == bint.one())
    assert(bint.frombe('\x03\x02\x01') == bint.frombase('030201', 16))
    assert(bint.frombe(string.rep('\x00', bytes)) == bint.zero())
    assert(bint.frombe(string.rep('\x01', bytes)) == bint.frombase(string.rep('01', bytes), 16))
    assert(bint.frombe(string.rep('\x01', bytes+32)) == bint.frombase(string.rep('01', bytes), 16))
    assert(bint.frombe(string.rep('\xff', bytes)) == bint.frombase(string.rep('ff', bytes), 16))
    assert(bint.frombe(string.rep('\xff', bytes+32)) == bint.frombase(string.rep('ff', bytes), 16))

    if bits == 160 then
      local x = bint.new('0x4340ac4FcdFC5eF8d34930C96BBac2Af1301DF40')
      local x_be = '\x43\x40\xac\x4F\xcd\xFC\x5e\xF8\xd3\x49\x30\xC9\x6B\xBa\xc2\xAf\x13\x01\xDF\x40'
      assert(bint.frombe(bint.tobe(x)) == x)
      assert(bint.fromle(bint.tole(x)) == x)
      assert(bint.tobe(bint.frombe(x_be)) == x_be)
      assert(bint.tole(bint.fromle(x_be:reverse())) == x_be:reverse())
    end

    assert(bint.tole(0) == string.rep('\x00', bytes))
    assert(bint.tole(0, true) == '\x00')
    assert(bint.tole(1) == '\x01'..string.rep('\x00', bytes-1))
    assert(bint.tole(1, true) == '\x01')
    assert(bint.tole(0x010203) == '\x03\x02\x01'..string.rep('\x00', bytes-3))
    assert(bint.tole(0x010203, true) == '\x03\x02\x01')
    assert(bint.tole(-1) == string.rep('\xff', bytes))
    assert(bint.tole(-1, true) == string.rep('\xff', bytes))

    assert(bint.tobe(0) == string.rep('\x00', bytes))
    assert(bint.tobe(0, true) == '\x00')
    assert(bint.tobe(1) == string.rep('\x00', bytes-1)..'\x01')
    assert(bint.tobe(1, true) == '\x01')
    assert(bint.tobe(0x010203) == string.rep('\x00', bytes-3)..'\x01\x02\x03')
    assert(bint.tobe(0x010203, true) == '\x01\x02\x03')
    assert(bint.tobe(-1) == string.rep('\xff', bytes))
    assert(bint.tobe(-1, true) == string.rep('\xff', bytes))

    assert((bint.maxinteger() + 1) == bint.mininteger())
    assert((bint.mininteger() - 1) == bint.maxinteger())

    assert(bint.max(bint(1), bint(2)) == bint(2))
    assert(bint.max(bint(1), 2) == bint(2))
    assert(bint.max(bint(1), 2.5) == 2.5)
    assert(bint.max(1.5, bint(2)) == bint(2))

    assert(bint.min(bint(3), bint(2)) == bint(2))
    assert(bint.min(bint(3), 2) == bint(2))
    assert(bint.min(bint(3), 2.5) == 2.5)
    assert(bint.min(3.5, bint(2)) == bint(2))

    if bits > 96 then
      assert((bint(1) << 96):tonumber() > 1e28)
      assert((-(bint(1) << 96)):tonumber() < -1e28)
    end
  end

  do -- number conversion
    local function test_num2num(x)
      assert_eq(bint(x):tointeger(), x)
      assert_eq(bint.new(x):tointeger(), x)
      assert_eq(bint.tobint(x):tointeger(), x)
      assert_eq(bint.fromuinteger(x):tointeger(), x)
      assert_eq(bint.new(bint(x)):tointeger(), x)
      assert_eq(bint.tobint(bint(x)):tointeger(), x)
      assert_eq(bint.new(tostring(x)):tointeger(), x)
      assert_eq(bint.tobint(tostring(x)):tointeger(), x)
      assert_eq(bint.tointeger(x), x)
      assert_eq(bint.tointeger(bint(x)), x)
      assert_eq(bint.tointeger(x), x)
      assert_eq(bint.tointeger(x * 1.0), x)
      assert_eq(bint.tointeger(bint(x)), x)
      assert_eq(bint.zero():_assign(x):tointeger(), x)
    end
    local function test_num2hex(x)
      assert_eq(bint(x):tobase(16), ('%x'):format(x))
    end
    local function test_num2dec(x)
      assert_eq(tostring(bint(x)), ('%d'):format(x))
    end
    local function test_num2oct(x)
      assert_eq(bint(x):tobase(8), ('%o'):format(x))
    end
    local function test_str2num(x)
      assert_eq(bint.frombase(tostring(x)):tointeger(), x)
    end
    local function test_ops(x)
      test_num2num(x)
      test_num2num(-x)
      test_num2hex(x)
      test_num2oct(x)
      if bits == luabits then
        test_num2hex(-x)
        test_num2oct(-x)
      end
      test_num2dec(x)
      test_num2dec(-x)
      test_str2num(x)
      test_str2num(-x)
    end
    assert_eq(bint.frominteger(nil), nil)
    assert_eq(bint.fromuinteger(nil), nil)

    assert_eq(bint.frombase(nil), nil)
    assert_eq(bint.frombase('ff', 10), nil)
    assert_eq(bint.frombase('x', 37), nil)
    assert_eq(bint.frombase('', 10), nil)

    assert_eq(bint.trunc(nil), nil)
    assert_eq(bint.trunc(1.5):tointeger(), 1)
    assert_eq(bint.trunc(-1.5):tointeger(), -1)
    assert_eq(bint.trunc(bint(1)), bint(1))

    assert_eq(bint.tonumber(1), 1)
    assert_eq(bint.tonumber(bint(1)), 1)

    assert_eq(bint.tointeger(1.0/0.0), nil)
    assert_eq(bint.tointeger(-1.0/0.0), nil)
    assert_eq(bint.tointeger(0.0/0.0), nil)
    assert_eq(bint.tointeger(1.5), nil)
    assert_eq(bint.tointeger(1), 1)
    assert_eq(bint.tointeger(bint(1)), 1)
    assert_eq(bint.tointeger(bint(math.mininteger)), math.mininteger)
    assert_eq(bint.tointeger(bint(math.maxinteger)), math.maxinteger)

    assert_eq(bint.touinteger(1.5), nil)
    assert_eq(bint.touinteger(1), 1)
    assert_eq(bint.touinteger(bint(1)), 1)

    assert_eq(bint.tobint(nil), nil)
    assert_eq(bint.tobint(1), bint(1))
    assert_eq(bint.tobint(1.5), nil)

    assert_eq(bint.parse(1), bint(1))
    assert_eq(bint.parse(1.5), 1.5)

    assert_eq(bint.tobase(math.mininteger, 10), tostring(math.mininteger))
    assert_eq(bint.tobase(math.maxinteger, 10), tostring(math.maxinteger))
    assert_eq(bint.tobase(1, 10), '1')
    assert_eq(bint.tobase(8, 7), '11')
    assert_eq(bint.tobase(1, 37), nil)
    assert_eq(bint.tobase(1.5, 10), nil)
    assert_eq(bint.tobase(0xff, 16, true), 'ff')
    assert_eq(bint.tobase(-0xff, 16, false), '-ff')
    if bits == 64 then
      assert_eq(bint.tobase(-1, 16, true), 'ffffffffffffffff')
      assert_eq(bint.tobase(-2, 16, true), 'fffffffffffffffe')
    elseif bits == 128 then
      assert_eq(bint.tobase('-1', 16, true), ('f'):rep(32))
    end

    test_ops(0)
    test_ops(1)
    if luabits >= 64 then
      test_ops(0xfffffffffe)
      test_ops(0x123456789abc)
    end
    test_ops(0xfffffff)
    test_ops(0xfffffff)
    test_ops(0xf505c2)
    test_ops(0x9f735a)
    test_ops(0xcf7810)
    test_ops(0xbbc55f)
  end

  do -- add/sub/mul/band/bor/bxor/eq/lt/le
    local function test_add(x, y)
      assert_eq((bint(x) + bint(y)):tointeger(), x + y)
      assert_eq((bint(x):_add(y)):tointeger(), x + y)
      assert_eq(bint(x) + (y+0.5), x + (y+0.5))
    end
    local function test_sub(x, y)
      assert_eq((bint(x) - bint(y)):tointeger(), x - y)
      assert_eq((bint(x):_sub(y)):tointeger(), x - y)
      assert_eq(bint(x) - (y+0.5), x - (y+0.5))
    end
    local function test_mul(x, y)
      assert_eq((bint(x) * bint(y)):tointeger(), x * y)
      assert_eq(bint(x) * (y+0.5), x * (y+0.5))
    end
    local function test_band(x, y)
      assert_eq((bint(x) & bint(y)):tointeger(), x & y)
    end
    local function test_bor(x, y)
      assert_eq((bint(x) | bint(y)):tointeger(), x | y)
    end
    local function test_bxor(x, y)
      assert_eq((bint(x) ~ bint(y)):tointeger(), x ~ y)
    end
    local function test_eq(x, y)
      assert_eq(bint(x) == bint(y), x == y)
    end
    local function test_lt(x, y)
      assert_eq(bint(x) < bint(y), x < y)
    end
    local function test_ult(x, y)
      assert_eq(bint.ult(bint(x), bint(y)), math.ult(x, y))
    end
    local function test_le(x, y)
      assert_eq(bint(x) <= bint(y), x <= y)
    end
    local function test_ule(x, y)
      assert_eq(bint.ule(bint(x), bint(y)), x == y or math.ult(x, y))
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
      test_ult(x, y) test_ult(y, x) test_ult(x, x) test_ult(y, y)
      test_le(x, y) test_le(y, x) test_le(x, x) test_le(y, y)
      test_ule(x, y) test_ule(y, x) test_ule(x, x) test_ule(y, y)
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
      assert_eq((bint(x) << y):tointeger(), x << y)
    end
    local function test_shr(x, y)
      assert_eq((bint(x) >> y):tointeger(), x >> y)
    end
    local function test_brol(x, y)
      assert_eq(bint(x):brol(y):tointeger(), (x << y) | (x >> (64 - y)))
    end
    local function test_bror(x, y)
      assert_eq(bint(x):bror(y):tointeger(), (x >> y) | (x << (64 - y)))
    end
    local function test_shlone(x)
      assert_eq(bint(x):_shlone():tointeger(), x << 1)
    end
    local function test_shrone(x)
      assert_eq(bint(x):_shrone():tointeger(), x >> 1)
    end
    local function test_bwrap(x, y)
      assert_eq(bint.bwrap(x, y):tointeger(), x & ((1 << math.max(y, 0))-1))
    end
    local function test_ops(x, y)
      test_shl(x, y) test_shl(x, -y)
      test_shr(x, y) test_shr(x, -y)
      test_bwrap(x, y) test_bwrap(x, -y) test_bwrap(-x, y)
      test_shlone(x) test_shlone(y)
      test_shrone(x) test_shrone(y)
      if bits == 64 then
        test_brol(x, y)
        test_bror(x, y)
      end
    end
    test_ops(math.maxinteger, 1)
    test_ops(math.maxinteger, math.maxinteger)
    if bits == 64 then
      test_ops(-1, 0)
      test_ops(-1, 1)
      test_ops(math.mininteger, 1)
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
    test_ops(1, 64)
    test_ops(1, 100)
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
    test_ops(0xa0, 100)
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
    test_ops(1048576, 100)
    assert_eq(bint(1) << math.mininteger, bint(0))
    assert_eq(bint(1) >> math.mininteger, bint(0))
    assert_eq(bint.brol(1, math.mininteger), bint(1))
    assert_eq(bint.bror(1, math.mininteger), bint(1))
    assert_eq(bint.brol(1, -1), bint.mininteger())
    assert_eq(bint.bror(1, 1), bint.mininteger())
    assert_eq(bint.brol(bint.mininteger(), 1), bint(1))
    assert_eq(bint.bror(bint.mininteger(), -1), bint(1))
  end

  do -- pow
    local function test_ipow(x, y)
      assert_eq(bint.ipow(x, y):tointeger(), math.floor(x ^ y))
      assert_eq(bint.ipow(x, y):tointeger(), math.floor(x ^ y))
    end
    local function test_pow(x, y)
      assert_eq(bint(x) ^ bint(y), x ^ y)
      assert_eq(bint(x) ^ bint(y), x ^ y)
    end
    local function test_ops(x, y)
      test_ipow(x, y)
      test_ipow(-x, y)
      test_pow(x, y)
      test_pow(-x, y)
      test_pow(x, -y)
      test_pow(-x, -y)
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
      assert_eq((~bint(x)):tointeger(), ~x)
      assert_eq((~ ~bint(x)):tointeger(), x)
    end
    local function test_unm(x)
      assert_eq((-bint(x)):tointeger(), -x)
      assert_eq((- -bint(x)):tointeger(), x)
    end
    local function test_inc(x)
      assert_eq(bint(x):inc():tointeger(), x + 1)
      assert_eq(bint.inc(x + 0.5), x + 1.5)
    end
    local function test_dec(x)
      assert_eq(bint(x):dec():tointeger(), x - 1)
      assert_eq(bint.dec(x - 0.5), x - 1.5)
    end
    local function test_abs(x)
      assert_eq(bint(x):abs():tointeger(), math.abs(x))
      assert_eq(bint.abs(x + 0.5), math.abs(x + 0.5))
    end
    local function test_floor(x)
      assert_eq(bint(x):floor():tointeger(), math.floor(x))
      assert_eq(bint.floor(x + 0.5):tointeger(), math.floor(x + 0.5))
    end
    local function test_ceil(x)
      assert_eq(bint(x):ceil():tointeger(), math.ceil(x))
      assert_eq(bint.ceil(x + 0.5):tointeger(), math.ceil(x + 0.5))
    end
    local function test_ops(x)
      test_bnot(x) test_bnot(-x)
      test_unm(x) test_unm(-x)
      test_inc(x) test_inc(-x)
      test_dec(x) test_dec(-x)
      test_abs(x) test_abs(-x)
      test_floor(x) test_floor(-x)
      test_ceil(x) test_ceil(-x)
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
    local function test_udiv(x, y)
      assert_eq(bint.udiv(x, y):tointeger(), x // y)
    end
    local function test_div(x, y)
      assert_eq(bint(x) / bint(y), x / y)
      assert_eq(bint(x) / (y+0.5), x / (y+0.5))
    end
    local function test_idiv(x, y)
      assert_eq((bint(x) // bint(y)):tointeger(), x // y)
      assert_eq(bint(x) // (y+0.5), x // (y+0.5))
    end
    local function test_umod(x, y)
      assert_eq(bint.umod(x, y):tointeger(), x % y)
    end
    local function test_mod(x, y)
      assert_eq((bint(x) % bint(y)):tointeger(), x % y)
      assert_eq(bint(x) % (y+0.5), x % (y+0.5))
    end
    local function test_udivmod(x, y)
      local quot, rem = bint.udivmod(x, y)
      assert_eq(quot:tointeger(), x // y)
      assert_eq(rem:tointeger(), x % y)
    end
    local function test_idivmod(x, y)
      local quot, rem = bint.idivmod(x, y)
      assert_eq(quot:tointeger(), x // y)
      assert_eq(rem:tointeger(), x % y)
    end
    local function test_ops(x, y)
      test_udiv(x, y)
      test_idiv(x, y)
      test_idiv(x, -y)
      test_idiv(-x, -y)
      test_idiv(-x, y)
      test_idiv(y, y)
      test_idiv(-y, -y)
      test_div(x, y)
      test_div(x, -y)
      test_div(-x, -y)
      test_div(-x, y)
      test_div(y, y)
      test_div(-y, -y)
      test_umod(x, y)
      test_mod(x, y)
      test_mod(x, -y)
      test_mod(-x, y)
      test_mod(-x, -y)
      test_mod(y, y)
      test_mod(-y, -y)
      test_udivmod(x, y)
      test_idivmod(x, y)
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
    test_ops(11, 7)
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
    test_ops(0xfffffff, 1)
    test_ops(0xfffffff, 0xef)
    test_ops(0xfffffff, 0x10000)
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

  do --tdivmod
    assert_eq(bint.tdiv( 7,  3  ):tointeger(),  2)
    assert_eq(bint.tdiv(-7,  3  ):tointeger(), -2)
    assert_eq(bint.tdiv( 7, -3  ):tointeger(), -2)
    assert_eq(bint.tdiv(-7, -3  ):tointeger(),  2)
    assert_eq(bint.tdiv( 6,  3  ):tointeger(),  2)
    assert_eq(bint.tdiv(-6,  3  ):tointeger(), -2)
    assert_eq(bint.tdiv( 6, -3  ):tointeger(), -2)
    assert_eq(bint.tdiv(-6, -3  ):tointeger(),  2)

    assert_eq(bint.tmod( 7,  3  ):tointeger(),  1)
    assert_eq(bint.tmod(-7,  3  ):tointeger(), -1)
    assert_eq(bint.tmod( 7, -3  ):tointeger(),  1)
    assert_eq(bint.tmod(-7, -3  ):tointeger(), -1)
    assert_eq(bint.tmod( 6,  3  ):tointeger(), 0)
    assert_eq(bint.tmod(-6,  3  ):tointeger(), 0)
    assert_eq(bint.tmod( 6, -3  ):tointeger(), 0)
    assert_eq(bint.tmod(-6, -3  ):tointeger(), 0)

    assert_eqf(bint.tdiv(7.5, 2.2), 3.0) assert_eqf(bint.tmod(7.5, 2.2), 0.9)
    assert_eqf(bint.tdiv(-7.5, 2.2), -3.0) assert_eqf(bint.tmod(-7.5, 2.2), -0.9)
    assert_eqf(bint.tdiv(7.5, -2.2), -3.0) assert_eqf(bint.tmod(7.5, -2.2), 0.9)
    assert_eqf(bint.tdiv(-7.5, -2.2), 3.0) assert_eqf(bint.tmod(-7.5, -2.2), -0.9)
  end

  do -- upowmod
    assert_eq(bint.upowmod(65, 17, 3233):tointeger(), 2790)
    assert_eq(bint.upowmod(2790, 413, 3233):tointeger(), 65)
    assert_eq(bint.upowmod(2790, 413, 1):tointeger(), 0)
  end
end

test(64)
test(64, 16)
test(64, 8)
test(72, 8)
test(64, 4)
test(80, 4)
test(128)
test(160)
test(256)
