MAINS = $(wildcard step*.f90)
TARGETS = $(MAINS:%.f90=%)

COMPILE = gfortran
COMPILEFLAGS = -g -O3 -cpp
LINK = gfortran
LINKFLAGS = -O3

.PHONY: all
all: $(TARGETS)

mal: stepA_mal
	cp $< $@

.deps: *.f90
	$(COMPILE) $(COMPILEFLAGS) -MM *.f90 > .deps

$(TARGETS): %: %.o
	$(LINK) $+ -o $@ $(LINKFLAGS)

step0_repl: readline.o

%.o: %.f90
	$(COMPILE) $(COMPILEFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -f $(TARGETS) mal *.o *.mod .deps

-include .deps
