SRC := $(wildcard dashboards/*.jsonnet)
OUT := $(patsubst dashboards/%.jsonnet,build/%.json,$(SRC))

.PHONY: all deps fmt check clean

all: $(OUT)

deps:
	jb install

build/%.json: dashboards/%.jsonnet $(wildcard lib/*.libsonnet)
	@mkdir -p build
	jsonnet -J vendor $< > $@

fmt:
	find dashboards lib -name '*.*sonnet' -exec jsonnetfmt -i {} +

check:
	find dashboards lib -name '*.*sonnet' -exec jsonnetfmt --test {} +

clean:
	rm -rf build
