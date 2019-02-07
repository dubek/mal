SOURCES_BASE = src/mal/types.pony src/mal/reader.pony src/mal/printer.pony # TODO
SOURCES_LISP = src/mal/env.pony src/mal/core.pony src/stepA_mal/stepA_mal.pony # TODO
SOURCES = $(SOURCES_BASE) $(SOURCES_LISP)

STEPS = step0_repl step1_read_print step2_eval step3_env \
        step4_if_fn_do step5_tco step6_file step7_quote \
        step8_macros step9_try stepA_mal

BINS = $(STEPS)

#####################

all: $(BINS)

dist: mal

mal: $(word $(words $(BINS)),$(BINS))
	cp $< $@

$(BINS): %:
	ponyc src/$@

clean:
	rm -f $(BINS) mal

.PHONY: stats stats-lisp tests $(TESTS)

stats: $(SOURCES)
	@wc $^
	@printf "%5s %5s %5s %s\n" `grep -E "^[[:space:]]*//|^[[:space:]]*$$" $^ | wc` "[comments/blanks]"
stats-lisp: $(SOURCES_LISP)
	@wc $^
	@printf "%5s %5s %5s %s\n" `grep -E "^[[:space:]]*//|^[[:space:]]*$$" $^ | wc` "[comments/blanks]"
