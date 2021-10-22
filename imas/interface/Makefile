F90_gfortran=gfortran -w
COPTS_gfortran = -O0 -freal-4-real-8 -cpp -fPIC -fno-second-underscore -ffree-line-length-none `pkg-config imas-gfortran --cflags` -g  
#LIBS_gfortran=-L$(UAL)/fortraninterface -lUALFORTRANInterface_gfortran -Wl,-rpath,$(UAL)/itmcatalog/lib -L$(UAL)/lowlevel -lUALLowLevel -lm
LIBS_gfortran=`pkg-config imas-gfortran --libs`

f2c= gfortran -w  -ffixed-line-length-none -fd-lines-as-comments -fno-automatic -fPIC

DINATRANSP = dina_transp1.o tran1.o dina_transp2.o tran2.o dina_transp3.o tran3.o dina_transp4.o tran4.o dina_transp5.o tran5.o

FORTRANWF = test_dina_to_imas test_dina test_dina_pfpo1a test_dina_pfpo1b test_dina_2madiv
TARGETS += $(FORTRANWF) dina_imas.a dina_put_slice.a kmc.a kmc_pfpo1_1a.a kmc_pfpo1_1b.a kmc_2madiv.a dina_transp_energy.a dina_transp_density.a dina_transp_density_test.a dina_transp_density_test0.a dina_transp_bootcond.a dina_transp_curdrive.a dina_transp_heatsrc.a solps_imas.a test_wr_prof

DINADIR := ../../src/scenario
CONTROLDIR := ../../src/controllers
ASTRADIR := ../astra_transp

LIB_SOURCEDINA := dina_imas.o wr_prof_imas.o n_dina_imas3.o out42_for.o green_imas.o pers2.o

LIB_SOURCECTRL := dina_contr.o n_kav.o out42_for.o main_1l.o



all: $(TARGETS)

#--------------------- gfortran ------------------------
test_dina: test_dina_imas.o dina_put_slice.a dina_imas.a kmc.a solps_imas.a
	@echo "   * $^ -> $@"
	$(F90_gfortran) -o $@ $^ $(LIBS_gfortran)

test_dina_pfpo1a: test_dina_imas.o dina_put_slice.a dina_imas.a kmc_pfpo1_1a.a solps_imas.a
	@echo "   * $^ -> $@"
	$(F90_gfortran) -o $@ $^ $(LIBS_gfortran)

test_dina_pfpo1b: test_dina_imas.o dina_put_slice.a dina_imas.a kmc_pfpo1_1b.a solps_imas.a
	@echo "   * $^ -> $@"
	$(F90_gfortran) -o $@ $^ $(LIBS_gfortran)

test_dina_pfpo1c: test_dina_imas.o dina_put_slice.a dina_imas.a kmc_pfpo1_1a.a solps_imas.a
	@echo "   * $^ -> $@"
	$(F90_gfortran) -o $@ $^ $(LIBS_gfortran)

test_dina_2madiv: test_dina_imas.o dina_put_slice.a dina_imas.a kmc_2madiv.a solps_imas.a
	@echo "   * $^ -> $@"
	$(F90_gfortran) -o $@ $^ $(LIBS_gfortran)

test_dina_astra: test_dina_imas_astra.o dina_put_slice.a dina_imas.a dina_contr.a solps_imas.a astra_transp_density.a
	@echo "   * $^ -> $@"
	$(F90_gfortran) -o $@ $^ $(LIBS_gfortran)

astra_transp_density.a: $(ASTRADIR)/astra_transp_density.a
	@echo "   * $^ -> $@"
	@cp $< $@

test_dina_to_imas: test_dina_to_imas.o n_dina_imas4.o dina_to_imas.o
	@echo "   * $^ -> $@"
	$(F90_gfortran) -o $@ $^ $(LIBS_gfortran)

test_wr_prof: test_wr_prof.o wr_prof_imas.o
	@echo "   * $^ -> $@"
	$(F90_gfortran) -o $@ $^ $(LIBS_gfortran)

%.o: %.f90
	@echo "   * $^ -> $@"
	$(F90_gfortran) $(COPTS_gfortran) -c -o $@ $^

%.o: %.f
	@echo "   * $^ -> $@"
	$(f2c) -c $<

dina_imas.a: $(DINADIR)/dina_99.a $(LIB_SOURCEDINA)
	@echo "   * $^ -> $@"
	@cp $< $@
	ar -rcs $@ $(LIB_SOURCEDINA)

dina_put_slice.a: dina_put_slice.o
	@echo "   * $^ -> $@"
	ar -rcs $@ $^

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

external_transp.a: external_transp.o
	@echo "   * $^ -> $@"
	ar -rcs $@ $^

clean:
	rm -f *.o
	rm -f *.a
	rm -f $(TARGETS)
