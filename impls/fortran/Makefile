MAINS=$(wildcard step*.f90)
TARGETS=$(MAINS:%.f90=%)

.PHONY: all
all: $(TARGETS)

mal: stepA_mal

step0_repl: step0_repl.o readline.o
step0_repl.o: readline.o

$(TARGETS):
	gfortran $+ -o $@

%.o: %.f90
	gfortran -c $< -o $@

.PHONY: clean
clean:
	rm $(BINS) *.o *.mod
