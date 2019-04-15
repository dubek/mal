SOURCES_BASE = types.zig readline.zig reader.zig printer.zig env.zig core.zig

#####################

SRCS = step0_repl.zig step1_read_print.zig step2_eval.zig step3_env.zig \
       step4_if_fn_do.zig step5_tco.zig step6_file.zig step7_quote.zig \
       step8_macros.zig step9_try.zig stepA_mal.zig
BINS = $(SRCS:%.zig=%)

#####################

all: $(BINS)

dist: mal

mal: $(word $(words $(BINS)),$(BINS))
	cp $< $@

$(BINS): %: %.zig
	zig build-exe --release-safe $<

clean:
	rm -f $(BINS) *.o mal
