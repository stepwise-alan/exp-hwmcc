downloads original:
	mkdir $@

downloads/hwmcc20benchmarks.tar.xz: | downloads
	curl -Lo $@ http://fmv.jku.at/hwmcc20/hwmcc20benchmarks.tar.xz

original/hwmcc20: downloads/hwmcc20benchmarks.tar.xz | original
	tar -mxf $< -C $|

download: downloads/hwmcc20benchmarks.tar.xz

extract: original/hwmcc20

all: extract
	$(MAKE) -f main.mk all

clean:
	$(MAKE) -f main.mk clean
	rm -rf downloads original

.DEFAULT_GOAL := all

%::
	$(MAKE) -f main.mk $@

.SECONDARY: downloads/hwmcc20benchmarks.tar.xz
.DELETE_ON_ERROR:
.PHONY: download extract all clean
