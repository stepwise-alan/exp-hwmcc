downloads original:
	mkdir $@

downloads/hwmcc20benchmarks.tar.xz: | downloads
	curl -Lo $@ http://fmv.jku.at/hwmcc20/hwmcc20benchmarks.tar.xz

original/hwmcc20: downloads/hwmcc20benchmarks.tar.xz | original
	tar -mxf $< -C $|

download: downloads/hwmcc20benchmarks.tar.xz

extract: original/hwmcc20

rules smt2 convert flatten all: extract
	$(MAKE) -f main.mk $@

clean:
	$(MAKE) -f main.mk clean
	rm -rf downloads original

.DEFAULT_GOAL := all

.SECONDARY: downloads/hwmcc20benchmarks.tar.xz
.DELETE_ON_ERROR:
.PHONY: download extract rules smt2 convert flatten all clean
