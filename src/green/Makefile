# Makefile for compilation of DINA components

AR=ar
ARFLAGS=-ru
FC?=gfortran
FCFLAGS?=-fPIC -w

INCDIR=../include


FCFLAGS += -I$(INCDIR)


DINASRC = green_imas.f pers2.f green_br_N.f params_dat.f svd0m.f pet.f bunema.f svd2.f

DINAOBJ = $(DINASRC:.f=.o)

all: test.exe green.a

test.exe: test.o green.a
	@echo "   * $^ -> $@"
	$(FC) -o $@ $^

green.a: $(DINAOBJ)
	@echo "   * $^ -> $@"
	$(AR) $(ARFLAGS) $@ $(DINAOBJ)

%.o: %.f
	$(FC) $(FCFLAGS) -c $<

clean:
	-rm -f *.o
	-rm -f *.a
	-rm -f *.exe
