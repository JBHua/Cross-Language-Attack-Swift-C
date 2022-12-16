SRCDIR = CSources
SRCDIRBUILD = CSources/Build
SAFESHAREDLIB = libCLASwift-safe.so
UNSAFESHAREDLIB = libCLASwift-unsafe.so

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	SHAREDLIBPATH = /usr/lib
endif
ifeq ($(UNAME_S),Darwin)
	SHAREDLIBPATH = /usr/local/lib
endif

all: Unsafe-C-Shared-Lib Safe-C-Shared-Lib

Unsafe-C-Shared-Lib: $(SRCDIR)/init.c
	clang -fPIC -c -o $(SRCDIRBUILD)/unsafe-lib.o $(SRCDIR)/init.c
	clang -fPIC -shared -o $(SRCDIRBUILD)/$(UNSAFESHAREDLIB) $(SRCDIRBUILD)/unsafe-lib.o
# 	cp $(SRCDIR)/$(SHAREDLIB) $(SHAREDLIBPATH)

WASM-Sandbox-C: $(SRCDIR)/init.c
# build the unsafe library to C with emcc
	emcc $(SRCDIR)/init.c -O3 -o $(SRCDIRBUILD)/safe-lib.wasm -s WASM2C --no-entry
# build the unsafe library's C to an object normally
	clang -fPIC $(SRCDIR)/Build/safe-lib.wasm.c -c -o  $(SRCDIRBUILD)/safe-lib.o

# https://kripken.github.io/blog/wasm/2020/07/27/wasmboxc.html
Safe-C-Shared-Lib: WASM-Sandbox-C
# build into shared library
	clang -fPIC -shared -o $(SRCDIRBUILD)/$(SAFESHAREDLIB) $(SRCDIRBUILD)/safe-lib.o
# this should be done manually as sudo. Or ignore this and provide path to so when linking
# cp $(SRCDIR)/$(SHAREDLIB) $(SHAREDLIBPATH)

clean:
	-rm -rf $(SRCDIRBUILD)/*
