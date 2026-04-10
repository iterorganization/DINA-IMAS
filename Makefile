# Top-level Makefile for DINA

all: dina controllers interface iwrap

dina:
	make -C src/green
	make -C src/scenario

controllers:
	make -C src/controllers/kmc
	make -C src/controllers/kmc_2madiv
	make -C src/controllers/kmc_pfpo1_1a
	make -C src/controllers/kmc_pfpo1_1b
	make -C src/controllers/kmc_contr_4

interface: dina controllers
	make -C imas/iwrap/dina_green
	make -C imas/iwrap/dina_imas
	make -C imas/iwrap/kmc
	make -C imas/iwrap/kmc_contr_4
	make -C imas/iwrap/wf
	make -C imas/iwrap/wf_contr_4
	make -C imas/iwrap/wf_vde

iwrap: interface
	make -C imas/iwrap/dina_green actor
	make -C imas/iwrap/dina_imas actor
	make -C imas/iwrap/kmc actor

clean:
	make -C src/scenario clean
	make -C src/green clean
	make -C src/controllers/kmc clean
	make -C src/controllers/kmc_2madiv clean
	make -C src/controllers/kmc_pfpo1_1a clean
	make -C src/controllers/kmc_pfpo1_1b clean
	make -C imas/astra_transp clean
	make -C imas/eq_test clean
	make -C imas/circ clean
	make -C imas/interface clean
	make -C imas/iwrap/dina_green clean
	make -C imas/iwrap/dina_imas clean
	make -C imas/iwrap/kmc clean
	make -C imas/iwrap/kmc_contr_4 clean
	make -C imas/iwrap/wf clean
	make -C imas/iwrap/wf_contr_4 clean
	make -C imas/iwrap/wf_vde clean
