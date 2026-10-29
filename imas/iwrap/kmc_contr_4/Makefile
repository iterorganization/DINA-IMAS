FC?=gfortran
FCFLAGS?=-fPIC -w
F90FLAGS?=-fPIC -w
ACTOR=kav_mag_contr
INCDIR:=../../../src/include


PACKAGES=
PACKAGES+=al-fortran
PACKAGES+=xmllib

F90LIB=
F90INC=-I$(INCDIR)

F90DEF=-D'GIT_URL="$(GIT_URL)"'
F90DEF+=-D'GIT_COMMIT_ID="$(GIT_COMMIT_ID)"'
F90DEF+=-D'GIT_VERSION="$(GIT_VERSION)"'


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
	$(FC) $(F90FLAGS) -o $@ $^ $(F90LIB)

$(ACTOR).a: $(OBJ_ACTOR) $(IMAS_OBJ)
	@cp $< $@
	ar -rcs $@ $^

%.o:%.f90
	$(FC) $(F90FLAGS) -c $< $(F90INC)

%.o: %.f
	@echo "   * $^ -> $@"
	$(FC) $(FCFLAGS) -I$(INCDIR) -c $<

validate:
	xmllint --noout test_wf_parameters.xsd test_wf_parameters.xml
	xmllint --noout --schema test_wf_parameters.xsd test_wf_parameters.xml
	xmllint --noout code_parameters.xsd code_parameters.xml
	xmllint --noout --schema code_parameters.xsd code_parameters.xml

clean:
	rm -rf *.exe *.a *.mod *.o
	rm -rf $(IWRAP_ACTORS_DIR)/$(ACTOR)

