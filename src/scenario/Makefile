# Makefile for compilation of DINA components

AR = ar
ARFLAGS = -ru
FC = gfortran

f2c= cc -fpic

FFLAGS = -w -ffixed-line-length-none -fd-lines-as-comments -fno-automatic -fPIC

DINASRC = \
		a_dina.f  add.f atsv_kav.f\
		bispl.f bispla.f bisplee.f Bohm_gyroBohm_L.f\
		bound.f bp_gribov_1.f bpol3.f break_new.f brz.f bunema.f\
		camloop.f camlxt.f con_fil.f con_mike.f\
		ddunew0.f disr.f diter_1.f\
		dop_imp_new.f dop_pet.f edf.f efi_fil.f efi_ves.f elem_i.f eni_ae.f\
		eni_imp.f  fit.f flux_pl.f\
		forces_for_control.f g_gaps_rus.f gen.f gr_psi_d_pc.f\
		green_br_N.f green_d.f inh.f imp_new2.f map.f\
		min_distance_1cm_w.f min_distance_pfw_1cm.f\
		move.f n_matlab_kav.f n_matlab_kav2.f ndop1_new2_400.f neut_dif3.f neut_dif.f\
		ndop_4.f neq0_sep_lim_32.f neqm.f obrm.f oosep_4.f\
		out42_for.f pet.f pf_t.f pfsvd11x.f pid.f pp0.f progonu.f\
		read_por.f sh.f sh1_N2.f sh_astra_dt_beam.f  solpsz2_vic.f\
		sh_br.f sh_d3d.f solver.f spline.f svd.f svd0m.f svd2.f uuu.f\
		victor_imp_new1_H.f write_eqdsk_scen_tok.f write_jetto.f\
		write_plasma_W_imas.f zca_tsp.f zcam_d3d.f zcamit.f\
		zu0_w.f zyb0_0.f


DINAOBJ = $(DINASRC:.f=.o)

all: dina_99.a

dina_99.a: $(DINAOBJ)
	$(RM) -r dina_99.a
	$(AR) $(ARFLAGS) $@ $(DINAOBJ)

%.o: %.f
	$(FC) $(FFLAGS) -c $<

%.o: %.c
	$(f2c)  -c $<


clean:
	-rm -f *.o 
	-rm -f *.a
