test:
	lua tests.lua
	lua examples/simple.lua
	lua examples/fibonacci.lua
	lua examples/factorial.lua
	lua examples/rsa.lua

docs:
	ldoc -d docs -f markdown bint.lua

coverage:
	rm -f *.out
	lua -lluacov tests.lua
	luacov

clean:
	rm -f *.out

.PHONY: test docs coverage clean
