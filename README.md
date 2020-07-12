# Lua Bint

Small portable arbitrary-precision integer arithmetic library in pure Lua for
computing with large integers.

Different from most arbitrary-precision integer libraries in pure Lua out there this one
uses an array of lua integers as underlying data-type in its implementation instead of
using strings or large tables, this make it efficient for working with fixed width integers
and to make bitwise operations.

Bint stands for Big Integer.

The library implementation was highly inspired by
[tiny-bignum-c](https://github.com/kokke/tiny-bignum-c).

## Design goals

The main design goal of this library is to be small, correct, self contained and use few
resources while retaining acceptable performance and feature completeness.

The library is designed to follow recent Lua integer semantics, this means that
integer overflow warps around,
signed integers are implemented using two-complement arithmetic rules,
integer division operations rounds towards minus infinity,
any mixed operations with float numbers promotes the value to a float,
and the usual division/power operation always promotes to floats.

The library is designed to be possible to work with only unsigned integer arithmetic
when using the proper methods.

All the lua arithmetic operators (+, -, *, //, /, %) and bitwise operators (&, |, ~, <<, >>)
are implemented as metamethods.

The integer size must be fixed in advance and the library is designed to be more efficient when
working with integers of sizes between 64-4096 bits. If you need to work with really huge numbers
without size restrictions then use another library. This choice has been made to have more efficiency
in that specific size range.

## Features

* Small, simple and self contained.
* Efficient (for a pure Lua integer library).
* Works with fixed width integers.
* Follows Lua 5.3+ integer arithmetic semantics by default.
* All integer overflows wraps around.
* Can work with large integer widths with reasonable speed (such as 1024bit integers).
* Implements all lua arithmetic metamethods.
* Provide methods to work with unsigned arithmetic only.
* Supports signed integers by default using two-complement arithmetic rules on unsigned operations.
* Allow to mix any operation with lua numbers, promoting to lua floats where needed.
* Can perform bitwise operations.

## Documentation

The full API reference and documentation can be viewed in the
[documentation website](https://edubart.github.io/lua-bint/).

## Install

You can use luarocks to install quickly:

```bash
luarocks install bint
```

Or just copy the `bint.lua` file, the library is self contained in this single file with no dependencies.

## Examples

```lua
local bint = require 'bint'(256) -- use 256 bits integers
local x = bint(1)
x = x << 128
print(x) -- outputs: 340282366920938463463374607431768211456
assert(tostring(x) == '340282366920938463463374607431768211456')
```

For more usage examples check the
[examples directory](https://github.com/edubart/lua-bint/tree/master/examples).

Some interesting examples there:

* [factorial.lua](https://github.com/edubart/lua-bint/blob/master/examples/factorial.lua) - calculate factorial of 100
* [fibonacci.lua](https://github.com/edubart/lua-bint/blob/master/examples/fiboncaci.lua) - calculate the 1001th number of the Fibonacci sequence
* [pi.lua](https://github.com/edubart/lua-bint/blob/master/examples/pi.lua) - calculate the first 100 digits of Pi
* [e.lua](https://github.com/edubart/lua-bint/blob/master/examples/e.lua) - calculate the first 100 digits of Euler's number
* [rsa.lua](https://github.com/edubart/lua-bint/blob/master/examples/rsa.lua) - simple RSA example for encrypting/decrypting messages

## Tests

To check if everything is working as expected under your machine run `lua tests.lua` or `make test`.

## Limitations

It is intended only to be used in Lua 5.3+.
The library can theoretically be backported to Lua 5.1/LuaJIT but there is no plan at the moment.
The integer size is limited in advance, this is a design choice.

## License

MIT License
