# Makefile for compilation of DINA components

AR?=ar
ARFLAGS?=-ru
FC?=gfortran

INCDIR=../include



FCFLAGS=-fPIC -w
# COMPILER-SPECIFIC FLAGS
ifeq ($(FC), ifort)
  FCFLAGS+=-extend-source -nod-lines -save -init=zero -real-size 64
else ifeq ($(FC), gfortran)
  FCFLAGS+=-ffixed-line-length-none -fd-lines-as-comments -fno-automatic -freal-4-real-8
else
  $(error Unsupported Fortran compiler)
endif


DEBUG = -g -O0 -ffixed-form -fno-inline
ifeq ($(TARGET), DEBUG)
  FCFLAGS += $(DEBUG)
endif


FCFLAGS += -I$(INCDIR)



DINASRC = \
		a_dina.f  add.f atsv_kav.f\
		bispl.f bispla.f bisplee.f Bohm_gyroBohm_L.f\
		bound.f bp_gribov_1.f bpol3.f break_new.f brz.f bunema.f\
		camloop.f camlxt.f con_fil.f con_mike.f\
		ddunew0.f disr.f diter_1.f\
		dop_imp_new.f dop_pet.f edf.f efi_fil.f efi_ves.f elem_i.f eni_ae.f\
		eni_imp_H.f  fit.f flux_pl.f\
		forces_for_control.f g_gaps_rus.f gen.f gr_psi_d_pc.f\
		green_br_N.f green_d.f inh.f map.f\
		min_distance_1cm_w.f min_distance_pfw_1cm.f\
		move.f n_matlab_kav.f n_matlab_kav2.f n_matlab_kav3.f ndop1_new2_400.f neut_dif3.f\
		ndop_4.f neq0_sep_lim_32.f neqm.f obrm.f oosep_4.f\
		out42_for.f pet.f pf_t.f pfsvd11x.f pid.f pp0.f progonu.f\
		read_por.f sh.f sh1_N2.f sh_astra_dt_beam.f  solpsz2_vic.f\
		sh_br.f sh_d3d.f solver.f spline.f svd.f svd0m.f svd2.f uuu.f\
		victor_imp_new1_H.f write_eqdsk_scen_tok.f write_jetto.f\
		write_plasma_W_imas.f zca_tsp.f zcam_d3d.f zcamit.f\
		zu0_w.f zyb0_0.f n_dina_imas33.f green_imas.f pers2.f params_dat.f


DINAOBJ = $(DINASRC:.f=.o)

all: test.exe dina_99.a

test.exe: test.o dina_99.a
	@echo "   * $^ -> $@"
	$(FC) -Wl,--no-relax -o $@ $^

dina_99.a: $(DINAOBJ)
	$(RM) -r $@
	$(AR) $(ARFLAGS) $@ $(DINAOBJ)

%.o: %.f
	$(FC) $(FCFLAGS) -c $<

clean:
	-rm -f *.o
	-rm -f *.a
	-rm -f *.exe
