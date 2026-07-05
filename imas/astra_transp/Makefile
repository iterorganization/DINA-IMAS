FC?=gfortran

PACKAGES=
#PACKAGES+=imas-$(FC)
PACKAGES+=al-fortran
#PACKAGES+=libxml-2.0
PACKAGES+=xmllib

F90LIB=
F90INC=

F90DEF=-D'GIT_URL="$(GIT_URL)"'
F90DEF+=-D'GIT_COMMIT_ID="$(GIT_COMMIT_ID)"'
F90DEF+=-D'GIT_VERSION="$(GIT_VERSION)"'

F90FLAGS=-fPIC -w
# COMPILER-SPECIFIC FLAGS
ifeq ($(FC), ifort)
  F90FLAGS+=-fpp
  F90FLAGS+=-real-size 64 -assume no2underscores -extend_source
else ifeq ($(FC), gfortran)
  F90FLAGS+=-cpp
  F90FLAGS+=-freal-4-real-8 -fno-second-underscore -ffree-line-length-none
else
  $(error Unsupported Fortran compiler)
endif

DEBUG = -g -O0
ifeq ($(TARGET), DEBUG)
  F90FLAGS += $(DEBUG)
endif

F90FLAGS+=$(F90DEF)

# FLAGS OF PACKAGES
F90LIB+=`pkg-config $(PACKAGES) --libs`
F90INC+=`pkg-config $(PACKAGES) --cflags`

F90FLAGS+=$(F90INC)


FCFLAGS=-fPIC -w
# COMPILER-SPECIFIC FLAGS
ifeq ($(FC), ifort)
  FCFLAGS+=-extend-source -save -init=zero
else ifeq ($(FC), gfortran)
  FCFLAGS+=-ffixed-line-length-none -fno-automatic
else
  $(error Unsupported Fortran compiler)
endif



S=./
V=$(S)



os=		a_main_dina.o add_dll.o main_astra.o \
		solsrs_IMAS.o neutex_IMAS.o pelsrs1_IMAS.o solpsz3.o nbicomR_IMAS.o

os1=		add_dll.o \
	        neutex_IMAS.o pelsrs1_IMAS.o solpsz3.o nbicomR_IMAS.o


os_d= $(os) a_dina.o tran6.o
os_s_pel= $(os1) tran_pel.o mainp_astra.o solsrsP_IMAS.o
os_s_puff= $(os1) tran_neut.o main_astra.o solsrs_IMAS.o

os_pel= feed_pel.o 
os_puff= feed_src.o 


all: p_4dina astra_transp_density.a  density_control_pellet.a density_control_valve.a astra_sources_pellet.a astra_sources_valve.a

astra_transp_density.a: astra_transp_density.o $(os_d)
	@echo "   * $^ -> $@"
	ar -rcs astra_transp_density.a astra_transp_density.o $(os_d) 


density_control_pellet.a: density_control_pellet.o $(os_pel)
	@echo "   * $^ -> $@"
	ar -rcs density_control_pellet.a density_control_pellet.o $(os_pel)

density_control_valve.a: density_control_valve.o $(os_puff)
	@echo "   * $^ -> $@"
	ar -rcs density_control_valve.a density_control_valve.o $(os_puff)

astra_sources_pellet.a: astra_sources_pellet.o $(os_s_pel)
	@echo "   * $^ -> $@"
	ar -rcs astra_sources_pellet.a astra_sources_pellet.o $(os_s_pel)

astra_sources_valve.a: astra_sources_valve.o $(os_s_puff)
	@echo "   * $^ -> $@"
	ar -rcs astra_sources_valve.a astra_sources_valve.o $(os_s_puff)

%.o: %.f90
	@echo "   * $^ -> $@"
	$(FC) $(F90FLAGS) -c -o $@ $^

p_4dina:	$(os_d)
		$(FC) -o p_4dina $(os_d) -lm -L$(XLIB) -lX11


a_main_dina.o:	$(S)a_main_dina.f
		$(FC) $(F90FLAGS) -c -w $(S)a_main_dina.f

a_dina.o:	$(S)a_dina.f
		$(FC) $(F90FLAGS) -c -w $(S)a_dina.f


add_dll.o:	$(S)add_dll.f
		$(FC) $(F90FLAGS) -c -w  $(S)add_dll.f

feed_pel.o:	$(S)feed_pel.f
		$(FC) $(F90FLAGS) -c -w  $(S)feed_pel.f

feed_src.o:	$(S)feed_src.f
		$(FC) $(F90FLAGS) -c -w  $(S)feed_src.f

tran6.o:	$(S)tran6.f
		$(FC) $(F90FLAGS) -c -w  $(S)tran6.f

tran_pel.o:	$(S)tran_pel.f
		$(FC) $(F90FLAGS) -c -w  $(S)tran_pel.f

tran_neut.o:	$(S)tran_neut.f
		$(FC) $(F90FLAGS) -c -w  $(S)tran_neut.f

main_astra.o:	$(S)main_astra.f
		$(FC) $(F90FLAGS) -c -w  $(S)main_astra.f
mainp_astra.o:	$(S)mainp_astra.f
		$(FC) $(F90FLAGS) -c -w  $(S)mainp_astra.f

solsrs_IMAS.o:	$(S)solsrs_IMAS.f
		$(FC) $(F90FLAGS) -c -w  $(S)solsrs_IMAS.f
solsrsP_IMAS.o:	$(S)solsrsP_IMAS.f
		$(FC) $(F90FLAGS) -c -w  $(S)solsrsP_IMAS.f

neutex_IMAS.o:	$(S)neutex_IMAS.f
		$(FC) $(F90FLAGS) -c -w  $(S)neutex_IMAS.f

pelsrs1_IMAS.o:	$(S)pelsrs1_IMAS.f
		$(FC) $(F90FLAGS) -c -w  $(S)pelsrs1_IMAS.f

solpsz3.o:	$(S)solpsz3.f
		$(FC) $(F90FLAGS) -c -w  $(S)solpsz3.f
nbicomR_IMAS.o:	$(S)nbicomR_IMAS.f
		$(FC) $(F90FLAGS) -c -w  $(S)nbicomR_IMAS.f

clean:
	rm -f *.o
	rm -f *.a
	rm -f p_4dina
	rm -f p_4dina_src
