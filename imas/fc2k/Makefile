.phony: all clean fc2k

pyworkspace = ../python_wf/actors
#kepler = true


dina_actors = dinaimas21.xml dinacontr21.xml dinaputslice21.xml dinatransp_energy.xml dinatransp_density.xml dinatransp_bootcond.xml dinatransp_curdrive.xml dinatransp_heatsrc.xml dinasdn21.xml
astra_actors = solps_imas.xml density_control_pellet.xml density_control_valve.xml astra_sources_pellet.xml astra_sources_valve.xml


ifdef kepler
usekep = ""
else
usekep = -nokepler
endif


ifdef pyworkspace
usepy = -pyworkspace $(pyworkspace)
else
usepy = ""
endif



all: $(dina_actors) $(astra_actors)
ifdef pyworkspace
	mkdir -p $(pyworkspace)
endif
	$$FC2K/bin/fc2k -nocompile dinaimas21.xml $(usekep) $(usepy)
	$$FC2K/bin/fc2k -nocompile dinacontr21.xml $(usekep) $(usepy)
	$$FC2K/bin/fc2k -nocompile dinaputslice21.xml $(usekep) $(usepy)
	$$FC2K/bin/fc2k -nocompile dinatransp_energy.xml $(usekep) $(usepy)
	$$FC2K/bin/fc2k -nocompile dinatransp_density.xml $(usekep) $(usepy)
	$$FC2K/bin/fc2k -nocompile dinatransp_density_test.xml $(usekep) $(usepy)
	$$FC2K/bin/fc2k -nocompile dinatransp_density_test0.xml $(usekep) $(usepy)
	$$FC2K/bin/fc2k -nocompile density_control_pellet.xml $(usekep) $(usepy)
	$$FC2K/bin/fc2k -nocompile density_control_valve.xml $(usekep) $(usepy)
	$$FC2K/bin/fc2k -nocompile astra_sources_pellet.xml $(usekep) $(usepy)
	$$FC2K/bin/fc2k -nocompile astra_sources_valve.xml $(usekep) $(usepy)
	$$FC2K/bin/fc2k -nocompile astra_transp_density.xml $(usekep) $(usepy)
	$$FC2K/bin/fc2k -nocompile dina_equil.xml $(usekep) $(usepy)
	$$FC2K/bin/fc2k -nocompile dinatransp_bootcond.xml $(usekep) $(usepy)
	$$FC2K/bin/fc2k -nocompile dinatransp_curdrive.xml $(usekep) $(usepy)
	$$FC2K/bin/fc2k -nocompile dinatransp_heatsrc.xml $(usekep) $(usepy)
	$$FC2K/bin/fc2k -nocompile dinasdn21.xml $(usekep) $(usepy)
	$$FC2K/bin/fc2k -nocompile solps_imas.xml $(usekep) $(usepy)
	$$FC2K/bin/fc2k -nocompile dinacontr21_1a.xml $(usekep) $(usepy)
	$$FC2K/bin/fc2k -nocompile dinacontr21_1b.xml $(usekep) $(usepy)
	$$FC2K/bin/fc2k -nocompile dinacontr21_2madiv.xml $(usekep) $(usepy)

ifdef kepler
	cd $(KEPLER)/build-area && ant clean-cache && ant compile && ant make-kars
endif

fc2k:
	@echo "This option is obsolete"


dinaimas: dinaimas21.xml
	$$FC2K/bin/fc2k -nocompile $< $(usekep) $(usepy)


clean:
	rm -rf $(pyworkspace)/*
