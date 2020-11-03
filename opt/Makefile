VERBOSE ?= 1

#PARALLEL ?= /usr/local/bin/parallel
#PARALLEL_N_JOBS ?= 8
#
#PROGS ?= ../bin/z3m ../bin/gspacer
#TIMEOUTS ?= 900 3600

CHC_TOOLS ?= ../py/chc-tools
PYTHON ?= python3

list-rem = $(wordlist 2,$(words $1),$1)
pairmap = $(and $(strip $2),$(strip $3),$(call \
    $1,$(firstword $2),$(firstword $3)) $(call \
    pairmap,$1,$(call list-rem,$2),$(call list-rem,$3)))


ifeq ($(VERBOSE),0)
	MAKEFLAGS += --silent
endif

MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables

ifeq ($(wildcard original/hwmcc20/*.smt2),)
ifeq ($(wildcard downloads/hwmcc20benchmarks.tar.xz),)
ifeq ($(wildcard downloads),)
$(info Creating directory: downloads)
out := $(shell mkdir downloads)
endif
$(info Downloading hwmcc20benchmarks.tar.xz)
out := $(shell curl -Lo downloads/hwmcc20benchmarks.tar.xz \
http://fmv.jku.at/hwmcc20/hwmcc20benchmarks.tar.xz)
endif
ifeq ($(wildcard original),)
$(info Extracting hwmcc20benchmarks.tar.xz)
out := $(shell mkdir original)
endif
out := $(shell tar -mxf downloads/hwmcc20benchmarks.tar.xz -C original)
endif


hwmcc20_btor_files := $(shell grep -REwl --include='*.btor' 'original' -e '^[0-9]+ *sort *bitvec')
hwmcc20_btor2_files := $(shell grep -REwl --include='*.btor2' 'original' -e '^[0-9]+ *sort *bitvec')

converted_hwmcc20_rules_files_1 := $(hwmcc20_btor_files:original/%.btor=converted/rules/%.smt2)
converted_hwmcc20_rules_files_2 := $(hwmcc20_btor2_files:original/%.btor2=converted/rules/%.smt2)

converted_hwmcc20_smt2_files_1 := $(hwmcc20_btor_files:original/%.btor=converted/smt2/%.smt2)
converted_hwmcc20_smt2_files_2 := $(hwmcc20_btor2_files:original/%.btor2=converted/smt2/%.smt2)

converted_rules_files_1 := $(converted_hwmcc20_rules_files_1)
converted_rules_files_2 := $(converted_hwmcc20_rules_files_2)
converted_rules_files := $(converted_rules_files_1) $(converted_rules_files_2)

converted_smt2_files_1 := $(converted_hwmcc20_smt2_files_1)
converted_smt2_files_2 := $(converted_hwmcc20_smt2_files_2)
converted_smt2_files := $(converted_smt2_files_1) $(converted_smt2_files_2)

converted_hwmcc20_bv_rules_files := \
	$(filter converted/rules/hwmcc20/btor2/bv/%,$(converted_rules_files))
converted_hwmcc20_bv_smt2_files := \
	$(filter converted/smt2/hwmcc20/btor2/bv/%,$(converted_smt2_files))

converted_hwmcc20_array_rules_files := \
	$(filter converted/rules/hwmcc20/btor2/array/%,$(converted_rules_files))
converted_hwmcc20_array_smt2_files := \
	$(filter converted/smt2/hwmcc20/btor2/array/%,$(converted_smt2_files))

converted_hwmcc20_rules_files := \
	$(converted_hwmcc20_bv_rules_files) $(converted_hwmcc20_array_rules_files)
converted_hwmcc20_smt2_files := \
	$(converted_hwmcc20_bv_smt2_files) $(converted_hwmcc20_array_smt2_files)

hwmcc20_bv_rules_files := \
	$(addprefix ../data/rules/hwmcc20/bv-,$(notdir $(converted_hwmcc20_bv_rules_files)))
hwmcc20_bv_smt2_files := \
	$(addprefix ../data/smt2/hwmcc20/bv-,$(notdir $(converted_hwmcc20_bv_smt2_files)))

hwmcc20_array_rules_files := \
	$(addprefix ../data/rules/hwmcc20/array-,$(notdir $(converted_hwmcc20_array_rules_files)))
hwmcc20_array_smt2_files := \
	$(addprefix ../data/smt2/hwmcc20/array-,$(notdir $(converted_hwmcc20_array_smt2_files)))

flattened_hwmcc20_rules_files := $(hwmcc20_bv_rules_files) $(hwmcc20_array_rules_files)
flattened_hwmcc20_smt2_files := $(hwmcc20_bv_smt2_files) $(hwmcc20_array_smt2_files)

converted/. ../data/.:
	mkdir $(dir $@)

converted/rules/. converted/smt2/.:
	mkdir $(dir $@)

../data/rules/. ../data/smt2/.: | ../data/.
	mkdir $(dir $@)

../data/rules/hwmcc20/.: ../data/rules/.
	mkdir $(dir $@)

../data/smt2/hwmcc20/.: ../data/smt2/.
	mkdir $(dir $@)

.SECONDEXPANSION:

converted/rules/%/.: original/%
	mkdir -p $(dir $@)

converted/smt2/%/.: original/%
	mkdir -p $(dir $@)

$(converted_rules_files_1): converted/rules/%.smt2: original/%.btor \
		$(CHC_TOOLS)/chctools/ $(CHC_TOOLS)/chctools/btor2.py | $$(@D)/.
	PYTHONPATH=$(CHC_TOOLS) $(PYTHON) -m chctools.btor2 "$<" -fmt rules -o "$@"

$(converted_rules_files_2): converted/rules/%.smt2: original/%.btor2 \
		$(CHC_TOOLS)/chctools/ $(CHC_TOOLS)/chctools/btor2.py | $$(@D)/.
	PYTHONPATH=$(CHC_TOOLS) $(PYTHON) -m chctools.btor2 "$<" -fmt rules -o "$@"

$(converted_smt2_files_1): converted/smt2/%.smt2: original/%.btor \
		$(CHC_TOOLS)/chctools/ $(CHC_TOOLS)/chctools/btor2.py | $$(@D)/.
	PYTHONPATH=$(CHC_TOOLS) $(PYTHON) -m chctools.btor2 "$<" -fmt smt -o "$@"

$(converted_smt2_files_2): converted/smt2/%.smt2: original/%.btor2 \
		$(CHC_TOOLS)/chctools/ $(CHC_TOOLS)/chctools/btor2.py | $$(@D)/.
	PYTHONPATH=$(CHC_TOOLS) $(PYTHON) -m chctools.btor2 "$<" -fmt smt -o "$@"

cp-rule = $(eval $(1): $(2) | $(dir $(1)).; cp $$< $$@)

$(eval $(call pairmap,cp-rule,$(flattened_hwmcc20_rules_files),$(converted_hwmcc20_rules_files)))
$(eval $(call pairmap,cp-rule,$(flattened_hwmcc20_smt2_files),$(converted_hwmcc20_smt2_files)))

#lists := ../run/lists/hwmcc20-rules.txt ../run/lists/hwmcc20-smt2.txt

#shs := $(shell for timeout in $(TIMEOUTS); do \
#	for prog in $(PROGS); do \
#	  	echo \
#	  		../run/run-exp-$$time-$$prog-hwmcc20-rules.sh \
#	  		../run/run-exp-$$time-$$prog-hwmcc20-smt2.sh; \
#	  	done \
#	done)
#
#../run/lists/hwmcc20-rules.txt: ../run/lists/%-rules.txt: ../data/rules/% | ../run/lists
#	echo $$(realpath $$(find "$<" -name '*.smt2')) | sed 's/ /\n/g' >"$@"
#
#../run/lists/hwmcc20-smt2.txt: ../run/lists/%-smt2.txt: ../data/smt2/% | ../run/lists
#	echo $$(realpath $$(find "$<" -name '*.smt2')) | sed 's/ /\n/g' >"$@"
#
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

#rules: $(rules_files_1) $(rules_files_2)
#
#list: $(lists)

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

rules: $(converted_rules_files)

smt2: $(converted_smt2_files)

convert: rules smt2

flatten: $(flattened_hwmcc20_rules_files) $(flattened_hwmcc20_smt2_files)

all: flatten

clean:
	rm -rf converted ../data ../run/lists

.SECONDARY: $(converted_rules_files) $(converted_smt2_files)
.SUFFIXES:
.DELETE_ON_ERROR:
.PHONY: rules smt2 convert flatten all clean
