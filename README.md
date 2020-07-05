# Lua Bigint

Small arbitrary precision library for calculating with large integers in pure lua.
Uses two's complement integer value for signed integers.
It uses arrays of 32bit integers, the ideia is derived from [tiny-bignum-c](https://github.com/kokke/tiny-bignum-c).

It have methods for both unsigned and signed operations.

It is intended only for Lua 5.3/5.4.

This was developed to be used in the [nelua-lang](https://github.com/edubart/nelua-lang/commits/master) compiler.

## Example

```
local bigint = require 'bigint'

bigint.scale(8, 32)

local x = bigint(1)

-- outputs: 340282366920938463463374607431768211456
print(x << 128)

```

## Usage

All the usual arithmetic metamethods for lua integers are implemented, so
you can use bigint numbers like usual numbers.

Read the full API in the `bigint.lua` lua.

## Tests

Just run `test.lua` it should work with Lua 5.3/5.4.
