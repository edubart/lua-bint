docs:
	ldoc -d docs -f markdown bigint.lua
coverage:
	rm -f *.out
	lua -lluacov tests.lua
	luacov
test:
	lua tests.lua
	lua examples/simple.lua
	lua examples/fibonacci.lua
	lua examples/factorial.lua
	lua examples/rsa.lua

.PHONY: docs
