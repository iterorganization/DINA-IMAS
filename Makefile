# Top-level Makefile for DINA

all: dina controllers interface fc2k

dina:
	make -C src/scenario

controllers:
	make -C src/controllers/kmc
	make -C src/controllers/kmc_pfpo1_1a
	make -C src/controllers/kmc_pfpo1_1c-m1
	make -C src/controllers/kmc_2madiv

interface: dina controllers
	make -C imas/astra_transp
	make -C imas/eq_test
	make -C imas/interface
	make -C imas/circ

fc2k: interface
	make -C imas/fc2k

clean:
	make -C src/scenario clean
	make -C src/controllers/kmc clean
	make -C src/controllers/kmc_pfpo1_1a clean
	make -C src/controllers/kmc_pfpo1_1c-m1 clean
	make -C src/controllers/kmc_2madiv clean
	make -C imas/astra_transp clean
	make -C imas/eq_test clean
	make -C imas/circ clean
	make -C imas/interface clean
	make -C imas/fc2k clean
