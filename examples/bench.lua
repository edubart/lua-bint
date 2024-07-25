local tl = require("tl")
tl.loader()
-- Perform some benchmarks to compare bint and lua number speed

local bint = require 'bint' (256)
local os_clock = os.clock

local function bench(n, name, f, a, b)
  -- warmup
  for _ = 1, n / 100 do
    assert(f(a, b) ~= nil)
  end
  local start = os_clock()
  for _ = 1, n do
    assert(f(a, b) ~= nil)
  end
  local elapsed = (os_clock() - start) * 1000
  print(string.format('%s %10.02fms', name, elapsed))
  return elapsed
end

local function bench2(n, name, f, a, b)
  local tluan = bench(n, string.format('luan %8s', name), f, a, b)
  local tbint = bench(n, string.format('bint %8s', name), f, bint.tobint(a), bint.tobint(b))
  local factor = tbint / tluan
  print(string.format('fact %8s %10.02fx', name, factor))
end

bench2(100000, 'add', function(a, b) return a + b end, 1, 2)
bench2(100000, 'sub', function(a, b) return a - b end, 1, 2)
bench2(100000, 'mul', function(a, b) return a * b end, 1, 2)
bench2(30000, 'idiv', function(a, b) return a // b end, 1, 2)
bench2(30000, 'mod', function(a, b) return a % b end, 1, 2)
bench2(30000, 'div', function(a, b) return a / b end, 1, 2)
bench2(100000, 'shl', function(a, b) return a << b end, 1, 2)
bench2(100000, 'shr', function(a, b) return a >> b end, 1, 2)
bench2(100000, 'band', function(a, b) return a & b end, 1, 2)
bench2(100000, 'bor', function(a, b) return a | b end, 1, 2)
bench2(100000, 'bxor', function(a, b) return a ~ b end, 1, 2)
bench2(100000, 'bnot', function(a) return ~a end, 1)
bench2(100000, 'unm', function(a) return -a end, 1)
bench2(100000, 'eq', function(a, b) return a == b end, 1, 2)
bench2(100000, 'lt', function(a, b) return a < b end, 1, 2)
bench2(100000, 'le', function(a, b) return a <= b end, 1, 2)
bench2(30000, 'pow', function(a, b) return a ^ b end, 1, 2)

bench(100000, 'bint      abs', function(a) return bint.abs(a) end, 1)
bench(100000, 'bint      dec', function(a) return bint.dec(a) end, 1)
bench(100000, 'bint      inc', function(a) return bint.inc(a) end, 1)
bench(30000, 'bint      ult', function(a, b) return bint.ult(a, b) end, 1, 2)
bench(30000, 'bint      ule', function(a, b) return bint.ule(a, b) end, 1, 2)
bench(30000, 'bint     ipow', function(a, b) return bint.ipow(a, b) end, 1, 2)

bench(30000, 'luab tonumber', function(a) return tonumber(a) end, '2147483648')
bench(30000, 'bint frombase', function(a) return bint.frombase(a) end, '2147483648')
bench2(30000, 'tostring', function(a) return tostring(a) end, 1)
