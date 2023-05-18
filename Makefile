all: build

include rust/Makefile
include go/Makefile

build: go rust

.PHONY: clean

clean: go_clean
