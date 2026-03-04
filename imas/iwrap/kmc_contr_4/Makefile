FCOMPILER?=gfortran
ACTOR=kav_mag_contr
INCDIR:=../../../src/include


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
FCFLAGS=-fPIC -w
# COMPILER-SPECIFIC FLAGS
ifeq ($(FCOMPILER), ifort)
  F90FLAGS+=-fpp
  F90FLAGS+=-real-size 64 -assume no2underscores -no-wrap-margin
  FCFLAGS+=-real-size 64 -extend-source
else ifeq ($(FCOMPILER), gfortran)
  F90FLAGS+=-cpp
  F90FLAGS+=-freal-4-real-8 -fno-second-underscore -ffree-line-length-none
  FCFLAGS+=-freal-4-real-8 -ffixed-line-length-none
else
  $(error Unsupported Fortran compiler)
endif


DEBUG = -g -O0
ifeq ($(TARGET), DEBUG)
  F90FLAGS += $(DEBUG)
  FCFLAGS += $(DEBUG)
endif


F90FLAGS+=$(F90DEF)

F90=$(FCOMPILER)

FC = $(FCOMPILER) $(FCFLAGS) -I$(INCDIR)

# FLAGS OF PACKAGES
F90LIB+=`pkg-config $(PACKAGES) --libs`
F90INC+=`pkg-config $(PACKAGES) --cflags`

# LIST OF OBJECT FILES
IMAS_OBJ = kav_contr.o dina_contr.o contr_params_imas.o
OBJ_ACTOR = ../../../src/controllers/kmc_contr_4/kmc.a
OBJS_TEST  = test_actor.o 

IWRAP_ACTORS_DIR ?= $(HOME)/IWRAP_ACTORS

TEST=test_actor

all: lib exe

lib: $(ACTOR).a

exe: $(TEST).exe

actor : lib ## Builds the IWrap actor
	iwrap -a $(ACTOR) -f iwrap_settings.yaml -i $(IWRAP_ACTORS_DIR)

actor-gui : lib ## Opens IWrap GUI 
	iwrap-gui -a $(ACTOR) -f iwrap_settings.yaml -i $(IWRAP_ACTORS_DIR)

$(TEST).exe: $(OBJS_TEST) $(ACTOR).a
	$(F90) $(F90FLAGS) -o $@ $^ $(F90LIB)

$(ACTOR).a: $(OBJ_ACTOR) $(IMAS_OBJ)
	@cp $< $@
	ar -rcs $@ $^

%.o:%.f90
	$(F90) $(F90FLAGS) -c $< $(F90INC)

%.o: %.f
	@echo "   * $^ -> $@"
	$(FC) -c $<

validate:
	xmllint --noout test_wf_parameters.xsd test_wf_parameters.xml
	xmllint --noout --schema test_wf_parameters.xsd test_wf_parameters.xml
	xmllint --noout code_parameters.xsd code_parameters.xml
	xmllint --noout --schema code_parameters.xsd code_parameters.xml

clean:
	rm -rf *.exe *.a *.mod *.o
	rm -rf $(IWRAP_ACTORS_DIR)/$(ACTOR)

