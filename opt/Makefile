CHC_TOOLS ?= ../py/chc-tools
PYTHON ?= python3

#PARALLEL ?= /usr/local/bin/parallel
#PARALLEL_N_JOBS ?= 8
#
#PROGS ?= ../bin/z3m ../bin/gspacer
#TIMEOUTS ?= 900 3600


original converted ../data ../run:
	mkdir $@

hwmcc20benchmarks.tar.xz:
	curl -Lo $@ http://fmv.jku.at/hwmcc20/hwmcc20benchmarks.tar.xz

original/hwmcc20: hwmcc20benchmarks.tar.xz | original
	tar -xf $< -C original

converted/rules converted/smt2: | converted
	mkdir $@

../data/rules ../data/smt2: | ../data
	mkdir $@

../run/lists: | ../run
	mkdir $@

hwmcc20_btor_files := $(shell find original/hwmcc20/btor2 -name '*.btor')
hwmcc20_btor_files := $(shell for f in $(hwmcc20_btor_files); do \
	grep -El "$$f" -e '^[0-9]+ *sort *bitvec'; done)

hwmcc20_btor2_files := $(shell find original/hwmcc20/btor2 -name '*.btor2')
hwmcc20_btor2_files := $(shell for f in $(hwmcc20_btor2_files); do \
	grep -El "$$f" -e '^[0-9]+ *sort *bitvec'; done)

hwmcc20_rules_files_1 := $(patsubst original/%,converted/rules/%,$(addsuffix \
	.smt2,$(basename $(hwmcc20_btor_files))))
hwmcc20_rules_files_2 := $(patsubst original/%,converted/rules/%,$(addsuffix \
	.smt2,$(basename $(hwmcc20_btor2_files))))

hwmcc20_smt2_files_1 := $(patsubst original/%,converted/smt2/%,$(addsuffix \
	.smt2,$(basename $(hwmcc20_btor_files))))
hwmcc20_smt2_files_2 := $(patsubst original/%,converted/smt2/%,$(addsuffix \
	.smt2,$(basename $(hwmcc20_btor2_files))))

rules_files_1 := $(hwmcc20_rules_files_1)
rules_files_2 := $(hwmcc20_rules_files_2)

smt2_files_1 := $(hwmcc20_smt2_files_1)
smt2_files_2 := $(hwmcc20_smt2_files_2)

$(rules_files_1): converted/rules/%.smt2: original/%.btor \
		$(CHC_TOOLS)/chctools $(CHC_TOOLS)/chctools/btor2.py | converted/rules
	mkdir -p $(dir $@)
	PYTHONPATH=$(CHC_TOOLS) $(PYTHON) -m chctools.btor2 "$<" -fmt rules -o "$@"

$(rules_files_2): converted/rules/%.smt2: original/%.btor2 \
		$(CHC_TOOLS)/chctools $(CHC_TOOLS)/chctools/btor2.py | converted/rules
	mkdir -p $(dir $@)
	PYTHONPATH=$(CHC_TOOLS) $(PYTHON) -m chctools.btor2 "$<" -fmt rules -o "$@"

$(smt2_files_1): converted/smt2/%.smt2: original/%.btor \
		$(CHC_TOOLS)/chctools $(CHC_TOOLS)/chctools/btor2.py | converted/rules
	mkdir -p $(dir $@)
	PYTHONPATH=$(CHC_TOOLS) $(PYTHON) -m chctools.btor2 "$<" -fmt smt -o "$@"

$(smt2_files_2): converted/smt2/%.smt2: original/%.btor2 \
		$(CHC_TOOLS)/chctools $(CHC_TOOLS)/chctools/btor2.py | converted/rules
	mkdir -p $(dir $@)
	PYTHONPATH=$(CHC_TOOLS) $(PYTHON) -m chctools.btor2 "$<" -fmt smt -o "$@"

lists := ../run/lists/hwmcc20-rules.txt ../run/lists/hwmcc20-smt2.txt

#shs := $(shell for timeout in $(TIMEOUTS); do \
#	for prog in $(PROGS); do \
#	  	echo \
#	  		../run/run-exp-$$time-$$prog-hwmcc20-rules.sh \
#	  		../run/run-exp-$$time-$$prog-hwmcc20-smt2.sh; \
#	  	done \
#	done)

converted/rules/hwmcc20: $(hwmcc20_rules_files_1) $(hwmcc20_rules_files_2)

converted/smt2/hwmcc20: $(hwmcc20_smt2_files_1) $(hwmcc20_smt2_files_2)

../data/rules/hwmcc20 ../data/smt2/hwmcc20: ../data/%/hwmcc20: converted/%/hwmcc20 | ../data/%
	rm -rf $@
	mkdir -p $@
	for type in array bv; do \
		for src in $$(find "$</btor2/$$type" -name '*.smt2'); do \
			cp "$$src" "$@"/"$$type-$$(basename $$src)"; \
		done \
	done

../run/lists/hwmcc20-rules.txt: ../run/lists/%-rules.txt: ../data/rules/% | ../run/lists
	echo $$(realpath $$(find "$<" -name '*.smt2')) | sed 's/ /\n/g' >"$@"

../run/lists/hwmcc20-smt2.txt: ../run/lists/%-smt2.txt: ../data/smt2/% | ../run/lists
	echo $$(realpath $$(find "$<" -name '*.smt2')) | sed 's/ /\n/g' >"$@"

#../run/z3.sh: ../run/templates/z3.sh
#	sed \
#		-e 's,@Z3@,$(realpath $(Z3)),g' \
#		-e 's,@TIMEOUT@,$(TIMEOUT),g' \
#		"$<" >"$@"
#	chmod +x "$@"
#
#../run/gspacer.sh: ../run/templates/gspacer.sh
#	sed \
#		-e 's,@GSPACER@,$(realpath $(GSPACER)),g' \
#		-e 's,@TIMEOUT@,$(TIMEOUT),g' \
#		"$<" >"$@"
#	chmod +x "$@"
#
#$(shs): ../run/templates/run-exp.sh | ../run/z3.sh ../run/lists/%.txt
#	sed \
#		-e 's,@EXP_NAME@,$(patsubst ../run/run-exp-%,%,$(basename $@)),g' \
#		-e 's,@PROJECT@,$(realpath ..),g' \
#		-e 's,@SCRATCH@,$(realpath ..),g' \
#		-e 's,@PARALLEL@,$(PARALLEL),g' \
#		-e 's,@PARALLEL_N_JOBS@,$(PARALLEL_N_JOBS),g' \
#		"$<" >"$@"
#	chmod +x "$@"

rules: $(rules_files_1) $(rules_files_2)

list: $(lists)

#sh:
#	sed \
#		-e 's,@GSPACER@,$(realpath $(GSPACER)),g' \
#		-e 's,@TIMEOUT@,$(TIMEOUT),g' \
#		"$<" >"$@"
#	chmod +x "$@"
#	sed \
#		-e 's,@EXP_NAME@,$(patsubst ../run/run-exp-%,%,$(basename $@)),g' \
#		-e 's,@PROJECT@,$(realpath ..),g' \
#		-e 's,@SCRATCH@,$(realpath ..),g' \
#		-e 's,@PARALLEL@,$(PARALLEL),g' \
#		-e 's,@PARALLEL_N_JOBS@,$(PARALLEL_N_JOBS),g' \
#		"$<" >"$@"
#	chmod +x "$@"

all: rules list

clean:
	rm -rf hwmcc20benchmarks.tar.xz converted ../data ../run/lists

.DELETE_ON_ERROR:
.PHONY: all rules lists clean
