docs:
	ldoc -d docs -f markdown bigint.lua
test:
	lua tests.lua
.PHONY: docs
