# Lua Bigint

Small portable arbitrary-precision integer arithmetic in pure Lua for
calculating with large numbers.

Different from most arbitrary-precision integer libraries in pure Lua out there this one
uses an array of lua integers as underlying data-type in its implementation instead of
using strings or large tables, so regarding that that aspect this library should be more efficient.

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

The basic lua integer arithmetic operators (+, -, *, //, %) and bitwise operators (&, |, ~, <<, >>)
are implemented as metamethods.

## Documentation

The full API reference and documentation can viewed in the [documentation website](https://edubart.github.io/lua-bigint/).

## Example

```lua
local bigint = require 'bigint'

-- set bigint to use 256 bits
bigint.scale(256)

-- outputs: 340282366920938463463374607431768211456
local x = bigint(1)
print(x << 128)
```

For more usage examples check the [examples directory](https://github.com/edubart/lua-bigint/tree/master/examples)

## Tests

To check if everything is working as expected under your machine run `lua tests.lua` or `make test`.

## Limitations

It is intended only to be used in Lua 5.3 and 5.4. The library can theoretically be backported
to Lua 5.1/LuaJIT but there is not plan.

## License

MIT License
