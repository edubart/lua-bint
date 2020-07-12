ROCKSPEC=rockspecs/bint-0.*.rockspec
LUA?=lua

test:
	$(LUA) tests.lua
	$(LUA) examples/simple.lua
	$(LUA) examples/fibonacci.lua
	$(LUA) examples/factorial.lua
	$(LUA) examples/pi.lua
	$(LUA) examples/e.lua
	$(LUA) examples/rsa.lua

docs:
	ldoc -d docs -f markdown bint.lua

coverage:
	rm -f *.out
	lua -lluacov tests.lua
	luacov

clean:
	rm -f *.out

install:
	luarocks make --local

upload:
	luarocks upload --api-key=$(LUAROCKS_APIKEY) $(ROCKSPEC)

.PHONY: test docs coverage clean
