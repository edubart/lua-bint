docs:
	ldoc -d docs -f markdown bigint.lua
test:
	lua tests.lua
	lua examples/factorial.lua
	lua examples/rsa.lua

.PHONY: docs
