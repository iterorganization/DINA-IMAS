FC?=gfortran
F90FLAGS?=-fPIC -w
ACTOR=dina_green
INCDIR:=../../../src/include


PACKAGES=
PACKAGES+=al-fortran
PACKAGES+=xmllib

F90LIB=
F90INC=-I$(INCDIR)


# FLAGS OF PACKAGES
F90LIB+=`pkg-config $(PACKAGES) --libs`
F90INC+=`pkg-config $(PACKAGES) --cflags`

# LIST OF OBJECT FILES
OBJS_ACTOR = ../../../src/green/green.a dina_green.o tokamak_green.o
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

$(ACTOR).a: $(OBJS_ACTOR)
	@cp $< $@
	ar -rcs $@ $^

%.o:%.f90
	$(FC) $(F90FLAGS) -c $< $(F90INC)

validate:
	xmllint --noout test_wf_parameters.xsd test_wf_parameters.xml
	xmllint --noout --schema test_wf_parameters.xsd test_wf_parameters.xml
	xmllint --noout code_parameters.xsd code_parameters.xml
	xmllint --noout --schema code_parameters.xsd code_parameters.xml

clean:
	rm -rf *.exe *.a *.mod *.o
	rm -rf $(IWRAP_ACTORS_DIR)/$(ACTOR)

