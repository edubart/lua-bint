ROCKSPEC=rockspecs/bint-0.*.rockspec

test:
	lua tests.lua
	lua examples/simple.lua
	lua examples/fibonacci.lua
	lua examples/factorial.lua
	lua examples/pi.lua
	lua examples/e.lua
	lua examples/rsa.lua

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
