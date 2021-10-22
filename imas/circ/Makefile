F90_gfortran=gfortran -w
COPTS_gfortran = -O0 -fdefault-real-8 -fPIC -fno-second-underscore -ffree-line-length-none `pkg-config imas-gfortran --cflags` -g  
#LIBS_gfortran=-L$(UAL)/fortraninterface -lUALFORTRANInterface_gfortran -Wl,-rpath,$(UAL)/itmcatalog/lib -L$(UAL)/lowlevel -lUALLowLevel -lm
LIBS_gfortran=`pkg-config imas-gfortran --libs`

f2c= gfortran -w  -ffixed-line-length-none -fd-lines-as-comments -fno-automatic -fPIC  

TARGETS += dina_imas_circ.a test_dina test_circ

DINADIR := ../../src/scenario/


LIB_SOURCE1 += dina_circ.a dina_imas_circ.o n_dina_imas3.o test_dina_imas.o


#SCHEMAS = $(UAL)/fortraninterface/ids_schemas.f90


all: $(TARGETS)

#--------------------- gfortran ------------------------
test_dina: test_dina_imas.o dina_imas_circ.a dina_contr.a dina_put_slice.a
	@echo "   * $^ -> $@"
	$(F90_gfortran) -o $@ $^ $(LIBS_gfortran)

test_circ: test_dina_circ.o dina_imas_circ.a dina_put_slice.a
	@echo "   * $^ -> $@"
	$(F90_gfortran) -o $@ $^ $(LIBS_gfortran)

%.o: %.f90
	@echo "   * $^ -> $@"
	$(F90_gfortran) $(COPTS_gfortran) -c -o $@ $^

n_dina_imas3.o: n_dina_imas3.f 
	$(f2c) -c n_dina_imas3.f

dina_imas_circ.a: $(LIB_SOURCE1)
	@echo "   * $^ -> $@"
	@cp dina_circ.a dina_imas_circ.a
	ar -rcs dina_imas_circ.a n_dina_imas3.o dina_imas_circ.o

dina_circ.a:
	make -f Makefile_circ

dina_contr.a: 
	@cp ../interface/kmc.a dina_contr.a

dina_put_slice.a:
	@cp ../interface/dina_put_slice.a dina_put_slice.a

clean:
	rm -f *.o
	rm -f *.a
	rm -f test_circ
	rm -f test_dina
	make -f Makefile_circ clean
