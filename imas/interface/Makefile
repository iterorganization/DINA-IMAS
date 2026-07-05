INCDIR := ../../src/include
DINADIR := ../../src/scenario
GREENDIR := ../../src/green
CONTROLDIR := ../../src/controllers
ASTRADIR := ../astra_transp

FCOMPILER?=gfortran

PACKAGES=
#PACKAGES+=imas-$(FCOMPILER)
PACKAGES+=al-fortran
#PACKAGES+=libxml-2.0
PACKAGES+=xmllib


F90LIB=
F90INC=-I$(INCDIR)

F90DEF=-D'GIT_URL="$(GIT_URL)"'
F90DEF+=-D'GIT_COMMIT_ID="$(GIT_COMMIT_ID)"'
F90DEF+=-D'GIT_VERSION="$(GIT_VERSION)"'

F90FLAGS=-fPIC -w
# COMPILER-SPECIFIC FLAGS
ifeq ($(FCOMPILER), ifort)
  F90FLAGS+=-fpp
  F90FLAGS+=-real-size 64 -assume no2underscores -extend_source
else ifeq ($(FCOMPILER), gfortran)
  F90FLAGS+=-cpp
  F90FLAGS+=-freal-4-real-8 -fno-second-underscore -ffree-line-length-none
else
  $(error Unsupported Fortran compiler)
endif

F90FLAGS+=$(F90DEF)
F90=$(FCOMPILER)

# FLAGS OF PACKAGES
F90LIB+=`pkg-config $(PACKAGES) --libs` -mcmodel=large -Wl,--no-relax
F90INC+=`pkg-config $(PACKAGES) --cflags`

F90FLAGS+=$(F90INC)
FFLAGS = $(F90FLAGS)

DEBUG = -g -O0
ifeq ($(TARGET), DEBUG)
  F90FLAGS += $(DEBUG)
  FFLAGS += $(DEBUG) -ffixed-form -fno-inline
endif


DINATRANSP = dina_transp1.o tran1.o dina_transp2.o tran2.o dina_transp3.o tran3.o dina_transp4.o tran4.o dina_transp5.o tran5.o

FORTRANWF = test_dina_to_imas test_dina test_dina_pfpo1a test_dina_pfpo1b test_dina_2madiv
#FORTRANWF += test_mast

TARGETS += $(FORTRANWF) dina_imas.a dina_sdn.a kmc.a kmc_pfpo1_1a.a kmc_pfpo1_1b.a kmc_2madiv.a dina_transp_energy.a dina_transp_density.a dina_transp_density_test.a dina_transp_density_test0.a dina_transp_bootcond.a dina_transp_curdrive.a dina_transp_heatsrc.a solps_imas.a 
#TARGETS += dina_iwrap_wf.a


LIB_SOURCEDINA := dina_imas.o dina_params_imas.o

LIB_SOURCECTRL := dina_contr.o kav_contr.o contr_params_imas.o



all: $(TARGETS)

test_dina: test_dina_imas.o dina_green.a dina_imas.a kmc.a solps_imas.a
	@echo "   * $^ -> $@"
	$(F90) -o $@ $^ $(F90LIB)

test_mast: test_mast.o dina_green.a dina_imas.a
	@echo "   * $^ -> $@"
	$(F90) -o $@ $^ $(F90LIB)

test_dina_pfpo1a: test_dina_imas.o dina_green.a dina_imas.a kmc_pfpo1_1a.a solps_imas.a
	@echo "   * $^ -> $@"
	$(F90) -o $@ $^ $(F90LIB)

test_dina_pfpo1b: test_dina_imas.o dina_green.a dina_imas.a kmc_pfpo1_1b.a solps_imas.a
	@echo "   * $^ -> $@"
	$(F90) -o $@ $^ $(F90LIB)

test_dina_pfpo1c: test_dina_imas.o dina_green.a dina_imas.a kmc_pfpo1_1a.a solps_imas.a
	@echo "   * $^ -> $@"
	$(F90) -o $@ $^ $(F90LIB)

test_dina_2madiv: test_dina_imas.o dina_green.a dina_imas.a kmc_2madiv.a solps_imas.a
	@echo "   * $^ -> $@"
	$(F90) -o $@ $^ $(F90LIB)

test_dina_astra: test_dina_imas_astra.o dina_green.a dina_imas.a kmc.a solps_imas.a astra_transp_density.a
	@echo "   * $^ -> $@"
	$(F90) -o $@ $^ $(F90LIB)

astra_transp_density.a: $(ASTRADIR)/astra_transp_density.a
	@echo "   * $^ -> $@"
	@cp $< $@

test_dina_to_imas: test_dina_to_imas.o n_dina_imas4.o dina_to_imas.o
	@echo "   * $^ -> $@"
	$(F90) -o $@ $^ $(F90LIB)

%.o: %.f90
	@echo "   * $^ -> $@"
	$(F90) $(F90FLAGS) -c -o $@ $^

dina_green.a: $(GREENDIR)/green.a dina_green.o tokamak_green.o
	@echo "   * $^ -> $@"
	@cp $< $@
	ar -rcs $@ dina_green.o tokamak_green.o

%.o: %.f
	@echo "   * $^ -> $@"
	$(F90) $(FFLAGS) -c $<

dina_imas.a: $(DINADIR)/dina_99.a $(LIB_SOURCEDINA)
	@echo "   * $^ -> $@"
	@cp $< $@
	ar -rcs $@ $(LIB_SOURCEDINA)

kmc.a: $(CONTROLDIR)/kmc/kmc.a $(LIB_SOURCECTRL)
	@echo "   * $^ -> $@"
	@cp $< $@
	ar -rcs $@ $(LIB_SOURCECTRL)

kmc_pfpo1_1a.a: $(CONTROLDIR)/kmc_pfpo1_1a/kmc.a $(LIB_SOURCECTRL)
	@echo "   * $^ -> $@"
	@cp $< $@
	ar -rcs $@ $(LIB_SOURCECTRL)

kmc_pfpo1_1b.a: $(CONTROLDIR)/kmc_pfpo1_1b/kmc.a $(LIB_SOURCECTRL)
	@echo "   * $^ -> $@"
	@cp $< $@
	ar -rcs $@ $(LIB_SOURCECTRL)

kmc_2madiv.a: $(CONTROLDIR)/kmc_2madiv/kmc.a $(LIB_SOURCECTRL)
	@echo "   * $^ -> $@"
	@cp $< $@
	ar -rcs $@ $(LIB_SOURCECTRL)

dina_transp_energy.a: dina_transp_energy.o tran1.o add_dll.o
	@echo "   * $^ -> $@"
	ar -rcs $@ $^

dina_transp_density.a: dina_transp_density.o tran2.o add_dll.o
	@echo "   * $^ -> $@"
	ar -rcs $@ $^

dina_transp_density_test.a: dina_transp_density_test.o tran2.o add_dll.o
	@echo "   * $^ -> $@"
	ar -rcs $@ $^

dina_transp_density_test0.a: dina_transp_density_test0.o tran2.o add_dll.o
	@echo "   * $^ -> $@"
	ar -rcs $@ $^

dina_transp_bootcond.a: dina_transp_bootcond.o tran3.o add_dll.o
	@echo "   * $^ -> $@"
	ar -rcs $@ $^

dina_transp_curdrive.a: dina_transp_curdrive.o tran4.o add_dll.o
	@echo "   * $^ -> $@"
	ar -rcs $@ $^

dina_transp_heatsrc.a: dina_transp_heatsrc.o tran5.o add_dll.o
	@echo "   * $^ -> $@"
	ar -rcs $@ $^

dina_sdn.a: dina_sdn.o
	@echo "   * $^ -> $@"
	ar -rcs $@ $^

solps_imas.a: $(DINADIR)/solpsz2_vic.o solps_imas.o
	@echo "   * $^ -> $@"
	ar -rcs $@ $^

dina_iwrap_wf.a: dina_iwrap_wf.o
	@echo "   * $^ -> $@"
	ar -rcs $@ $^


external_transp.a: external_transp.o
	@echo "   * $^ -> $@"
	ar -rcs $@ $^

clean:
	rm -f *.o
	rm -f *.a
	rm -f *.exe
	rm -f $(TARGETS)
