	include 'parf0'
	include 'parf1'
	parameter ( NPFC=KF-4)
	include 'parf2'
	include 'parf2e'
	include 'parf3'
	include 'parf4'
	include 'parf5'

	include 'parf7'
	include 'parf8'

	include 'parf_bound'


	common
     *	/n_m/n,m,mp

	common
     *  /igr/ygr(iy,ny),tgr(ny),igr

	common
     *	/ge1/pi
     *	/ge1e/rs0,tpl
     *  /ge2/NTAY,TAY,TT
     *  /ge2e/t_end
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
     *  /ge4/EPS1,EPS2,EPS0
     *  /ge5/kpr
     *  /ge6/zeff(npo),qpr(npo),ppr(npo),pr0,prg,zar
     *  /ge6e/zeff_a,zeff_b
     *  /ge7/eu,rout,zout,elong
     *  /ge7e/eu_u
     *  /ge8/pcch
     *  /ge8e/pcchp
     *  /ge12e/indpf(kf),seps1,seps2,seps3

	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nr),y(nz),dx,dy
   
     *  /eq1g/psi_g(nr,nz)

     *  /eq1e/psext(nwnh),re(nre),ze(nze),dr,dz
     *  /eq2/ke,xu(mu_l),yu(mu_l)
     *  /eq2e/kex,xue(mu),yue(mu)
     *  /eq4/xpl(npo,ntet),ypl(npo,ntet)
     *  /eq6/sinus(ntet),cosin(ntet)

     *  /eq8/jbound,xbound(ntet),ybound(ntet),alfa0

     *  /eq11/psval(npo),psval0(npo)
     *  /eq3/FLUXARR(nwnh,kf)
     *  /eq3e/FLUXARRE(nwnhe,kf)
     *  /eq10/vesarr(nwnh,mu)
     *  /eq10e/vesarre(nwnhe,mu)
     *  /eq12/omega,pspl0(nwnh)
     *  /eq15/pll,zsep,rsep,zsepup,rsepup,zsepdw,rsepdw
     *  /eq15e/pll0,tpl0,udd
     *  /eq23/xleft,xright

	common
     *  /DFM2/PSI8(npo),PFI(npo),DM0(npo),DMN(npo)
     *  /dfm3e/dfmaxc(npo),dfmaxh(npo)
     *  /dfm3/dfmax(npo),dfmax0(npo)
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)
     *  /dfm5/pt01,pt02
     *  /dfm7/bt0,uind
     *  /dfm8/ajb(npo),sigk(npo)
     *  /dfm9/aj0(npo)
     *  /dfm11/c20(npo),tok1(npo),tok2(npo)
     *  /dfm12/betj,dlint,bett,bet2,betpc,tk,tkp,tkf
     *  /dfm13/tokel,tokfi,tokbut
     *  /dfm13e/tokuv
     *  /dfm14/tokae,ajae(npo),ajae0(npo),enae
     *	/dfm15/uli

	common
     *  /pol1/ RO(npo,ntet),AJ(npo,ntet),
     *  /pol2/Qx(npo),ANUx(npo),Px(npo),Fx(npo),
     *   PPxx(npo),PFFxx(npo)
     *  /pol4/UM,VM,UK(ntet),VK(ntet)
     *  /pol5/psend
     *  /pol6/ppx(npo),pffx(npo)
     *  /pol6d/ppxd(npo),pffxd(npo)

	common
     *	/efit4/coef_efit
     *	/efit5/it1,it2

	common
     *  /en1/PNE(npo),PD0(npo),PT0(npo),PH0(npo),PDN(npo),
     *  PTN(npo),PHN(npo)
     *  /en1e/te_a,ti_a,te_b,ti_b,pw_e
     *  /en1d/te_a0
     *  /en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),WE0(npo),
     *  WQ0(npo)
     *  /en2e/pd0_a,pt0_a,pd0_b,pt0_b,pw_p
     *  /en5/SD0(npo),ST0(npo),SH0(npo)
     *  /en6/Vn(npo)
     *  /en9/QE0(npo),QQ0(npo),QDG(npo)
     *  /en12/pnal(npo),pnaln(npo),zalfa,talfa
     *  /en14e/t_dop
     *  /en14/EMOE,EMOQ,NDOP,QDE0(npo),QDQ0(npo)
     *  /en25/zhib,tego
     *  /en28/wen1,wen2
     *  /en33/anom_e,anom_i,key_t11,kcchp



	common
     *  /cont1/vchopper(kf),veps
     *  /CONT5/	FCOM(NPFC)
     *  /cont6/cip1,cip2,time1,time2
     *	/cont9/brad,kefit
     *  /cont13/zmag,zvel,delrmag,delzmag
     *  /cont13e/zmag0,rmag,rmag0,rvel
     *	/cont18/t_vde,time_disr
     *  /cont20/x_gaps(kf_c),y_gaps(kf_c),gaps(kf_c),n_gaps
     *  /cont21/n_ga,n_int
     *  /cont23/v_gaps(kf_c),d_gaps0(kf_c)      

	common
     *	/point1/r0,z0




	common
     *	/keys1/i_graph
     *	/keys2/key_b
     *	/keys3/kzero,iread,iwrite
     *  /keys4/k_ener,k_uv
     *  /keys5/next
     *  /keys6/i_svd,i_cal,kpf
     *  /keys7/i_c
     *  /keys10/ngra
     *  /keys12/i_v
	

	common
     *  /halo2/kmaj,k_q,k_d,kaxis,ndisrup
     *  /halo2e/next0,li_drop,n_li,n_dif,nmix
     *  /halo3/tay_00,tay_th,t_disr,d_tpl,tpl_end
     *  /halo4/expfg,avalb,w_h,del_r,al0
     *  /halo5/q_vde,q_95,del_f,i_halo
     *  /halo10/fves,fves0,self_v
     *  /halo14/hpart

        common
     *	/con1/gain,ta,zref,kzref
     *  /con2/rref,krref,bvert
	common
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /pf7/plasma(kf),plasma0(kf)
     *  /pf8/pfind(kf,kf),pfres(kf),a1(kf,kf),e1(kf),e2(kf)
         
        common 
     *  /sh1/dind(kf,10)
     *  /sh2/ps(10),n_ps
     *  /sh2e/ps0(10)
     *  /sh3/k_feed,time_vde
     *  /sh4/s_int,s_int0
     *  /sh5/dis(10),dis0(10),vel(10),sint(10),sint0(10)
     *  /sh6/rref_p,zref_p

	common
     *  /point_brz/r_point,z_point

	common
     *	/fluxc0/ind1(50)
     *	/fluxc1/xp1(50,mu1),yp1(50,mu1)
     *  /fluxc2/delta0,pom(ntet)
     *	/fluxc3/u(nwnh),work(nwnh),sib(nwnh)
     *  /fluxc4/mcurve,x11(mu1),y11(mu1)
     *	/fluxc5/nhalo,xtest(nwnh),ytest(nwnh)
     *	/fluxc6/pmag,pbound,psep,p_s,delaval,dr_h
     *	/fluxc7/coef,coef1,api
     *  /fluxc11/npl,pl_cur(nwnh),x_cur(nwnh),y_cur(nwnh)
     *  /fluxc9/fdd,fdd0
     *	/fluxc10/x1,y1,dx1,dy1
     *  /fluxc13/volt_sec(kf)
     *  /fluxc14/vs_pf,vs_pl,vs_tot 
     *	/fluxc16/tor_flh,tor_flp,tor_fl
     *  /fluxc17/f_index
     *  /fluxc18/alf_tok,int_tok


       	common
     *  /ves1/psp(mu),psp0(mu),tcam(mu),tcam0(mu)
     *  /ves2/ncam,rc(mu),zc(mu)
     *  /ves3/b(mu,mu),pmj(mu,mu)
     *  /ves4/rcam(mu)
     *  /ves5/pfc(mu,kf)
     *  /ves6/pind(mu),pind0(mu),pindn(mu)
     *  /ves9/tokc,tokc0

	common
     *  /loop1/kloop,RL(nloop),ZL(nloop),psloop(nloop)
     *  /loop2/pfgreen(nloop,kf),vesgreen(nloop,mu)
     *	/loop5e/pslgreene(nwnhe,nloop)
     *  /loop3/vloop,psf1a,psf1a0
     *  /loop6/psloopp(nloop)
	common
     *  /probe1/kprobe,bprobe(nprobe)
     *  /probe2/pfprobe(nprobe,kf),vesprobe(nprobe,mu)
     *	/probe4e/bprgreene(nwnhe,nprobe)
     *  /probe5/bprobep(nprobe)

c  here new coomon block values begin.....

	common
     *  /c_ge1/b_tor(nr,nz)
     *  /c_ge2/kp
     *  /c_ge3/dmo
     *  /c_ge4/rmag_in,zmag_in
     *  /c_ge5/ksepa 

	common
     *  /c_keys1/i_comp,i_ma,k_sh,k_force,k_magn
     *  /c_keys2/i_st


c  here new common blocks Victor has done...

	common
     *	/v_keys1/time_svd

c control keys...
	common
     *  /con_keys1/k_dm0


	common
     *  /c_avr1/int_2000

c  here Gen subroutine common blocks
	common
     *  /gen1/n_gen
     *  /gen2/a1_gen(mu,mu)
     *  /gen3/a_gen(mu,mu)
     *  /gen6/d0(mu),d1(mu),d2(mu)

     *  /gen7/n_gen2
     *  /gen8/b1_gen(mu,mu)
     *  /gen9/index(kf)

	common
     *  /c_con4/vps(npfc),kvert(npfc)
     *  /c_con7/volt_c(kf)
     *  /en9e/volt(npo)

c  here we start D3D control keys------
	common
     *  /c_cont1/r_r,r_l1,r_l2,r_3
     *  /c_cont2/v_e
     *  /c_cont3/tau_p,tau_i,tau_d,ECOIL_GP,ECOIL_GD,ECOIL_GI,
     *  /c_cont4/e_inp,p_out
     *  /c_cont5/v_out,vecoil
     *  /c_cont6/key_time,int_read
     *  /c_cont7/tt_ext,tay_ext
     *  /c_cont8/key_con_ext

     *  /c_cont9/g_r_p(2),g_r_d(2),g_r_i(2)
     *  /c_cont10/g_z_p(2),g_z_d(2),g_z_i(2)
     *  /c_cont11/z_vel,t_zvel
     *  /c_cont12/r_vel,t_rvel

     *  /c_cont13/ps_com(kf),ps_out(kf)
     *  /c_cont14/volt_chop(kf)
     *  /c_cont15/eps_com
     *  /c_cont16/n_pcs
     *  /c_cont17/fcom_pcs(kf)



c  new_halo common blocks...
	common
     *  /c_new_halo1/volt_tor(npo),volt_pol(npo),q_eq(npo)
     *  /c_new_halo6/u_h(nwnh)
     *  /c_new_halo8/fsol,fsol0,alf_dis
     *  /c_new_halo10/dpsi_ax

     *  /c_new_halo19/cur_tor(npo)


c  d3d common blocks...
	common
     *  /c_d3d_1/tpl_exp
     *  /c_d3d_2/taup,v_offset


c  d3d smal common blocks...
	common
     *  /c_smal_1/bz_tot,bz_pf,bz_ves,bz_pl
     *  /c_smal_2/dbz_tot,dbz_pf,dbz_ves,dbz_pl
     *  /c_smal_3/f_index_br,f_index_pf,f_index_ves
     *  /c_smal_4/pf_volts(kf)
     *  /c_smal_5/c_pf_res(kf)
     *  /c_smal_6/key_volt6,key_volt7
     *  /c_smal_7/bzz_pl

        include 'parf_mike1'

        common
     *  /c_d3d_mike1/pr(n_mat1,n_mat),pvm(n_mat,n_mat),
     *  pvr(n_mat,n_mat),pvv(n_mat,n_vec)
     *  /c_d3d_mike2/a1_mat(n_mat,n_mat)
     *  /c_d3d_mike3/volt_mat(n_vec),t_cur(n_mat1)
     *  /c_d3d_mike4/t_vec(n_mat),t_vec0(n_mat)

        common
     *  /c_verta1/verta,vertb,delta


       	common
     *  /c_ves1/res_coef
     *  /c_ves2/tok_tf

       	common
     *  /c_polar1/n_polar


	include 'parf_mario'


c*** new Victor's block 3 Sept. 1999
	common
     *	/v_jp/f_jp(nwnh)
     *	/v_t_edge/tec
c*** Turns of PF coils consistent with koor file!!!
     *	/v_turn/pf_turns(kf)
c*** new Victor's block June 2000
     *	/v_wr/i_wr	
     *	/v_surface/surface,volume
     *	/v_ffw/u_ffw(kf)
     *  /v_delta_time/delta_time
     *	/v_r_lh/r_lh


c** it is used in cur, dop_port.inc, victor.f
     *  /vic_rz_cur/r_cur,z_cur,z_cur0
     *  /vic_kavin/u_1(num_coils),u_kd(num_coils)
     *	/vic_tay_simul/tay_simul,tt_1,tt_2
     *	/vic_elong_ref/elong_ref
     *	/vic_pf_p/pf_p(kf)
     *	/vic_mario_filt/state(kf_c),state_old(kf_c)
     *	/vic_mario_filt1/state_vert(kf_c),state_old_vert(kf_c)
     *	/vic_int_2005/int_2005
     *  /vic_satur/zvconverter(kf),zvresist(kf)
     *	/vic_mario_ksepa/ksepa_0
     *  /vic_elong/elong_sep
     *  /vic_rref/rref_0
     *  /vic_b/b_cs(3)
     *  /vic_uli/del_li,uli_p,ch_k,ulivel,pcchp0
     *  /vic_pf_lim/pf_lim(kf)

     *  /vic_imp/coef_imp,nz_imp
     *  /vic_imp1/coef_imp1,nz_imp1

     *  /vic_imp2/coef_imp2,nz_imp2

     *  /vic_imp3/coef_imp3,nz_imp3
     *  /vic_imp4/coef_imp4,nz_imp4


     *  /vic_em_data/force_r(kf),force_z(kf) 
     *  /vic_psi_av/psipl_av,psiext_av
     *  /vic_scen_data/tt_h,betp_flat,coef_kessel_1,vs_start
	  common
     *  /vic_001/bpmax(kf)
     *  /vic_002/elong_p
     *  /vic_003/psi_pf
     *  /vic_004/key_lh
     *  /vic_005/tt_dw,s_plasma
     *  /vic_006/key_h_to_l
     *  /vic_007/tt_emo
     *  /vic_008/rsep2_gr,zsep2_gr,rsep2_l,zsep2_l,
     *           rsep2_r,zsep2_r
     *  /vic_009/p_sep_tot
     *  /vic_010/tt_errIp
     *  /vic_011/n_pasc

c---------------------------

     *  /vic_012/pion,palf,w_imp2,w_imp3,w_imp4,w_imp5
    
     *  /vic_013/w_imp
     *  /vic_014/dt_term_h
     *  /vic_015/dt_end
     *  /vic_016/tt_rampup
     *  /vic_017/w_fusion
     *  /vic_018/r_lh_new
     *  /vic_019/cIp_min

c----------


     *  /vic_015_imas/sigma_jetto(npo),sigma_dina(npo)
     *  /vic_016_imas/xu_dist(mu_l),yu_dist(mu_l)

        common
     *	/c_vec1/vec_br(kf),vec_bz(kf)
     *	/c_vec2/ves_br(mu),ves_bz(mu)

	common
     *  /abcdx/x_c(kf_c),x0_c(kf_c),gaps0(kf_c),d_gaps(kf_c)


	common
     *  /c_map1/x_map(npo,ntet),y_map(npo,ntet)
     *  /c_map2/p_nor(npo)
     *  /c_map3/k_map
     *  /c_map5/e_pol(npo),dl_pol(npo)

        COMMON
     *  /mid1/C1(npo),C2(npo),C3(npo)
     *  /mid2/vi(npo),spo(npo)
     *  /mid2_0/vi0(npo),pfi0(npo)
     *  /mid2e/vol(npo),spov(npo),pcur(npo)
     *  /mid3/GRA1(npo),GRA2(npo)
	common
     *  /mid6/bp_0(npo),a_m(npo),r_m(npo)
     *  /mid7/bsq(npo),bsqi(npo),fasp(npo)


	common
     *  /c_mit_r1/heli
     *  /c_mit_r2/t_beta,alf_beta
     *  /c_mit_r3/t_li

	common /fwt/fwtp(nloop),fwtb(nprobe)
	common /fwt_coef1/time_dis,alf_loop(nloop),alf_probe(nprobe)

	common
     *  /svd1/psloop_e(nloop),bprobe_e(nprobe)
     *  /svd2/pf_e(kf)


        include 'par_fil'

	common
     *  /efil_1/g_loop(nloop,k_fil),g_probe(nprobe,k_fil)
     *  /efil_2/tok_fil(k_fil)
     *  /efil_3/r_fil(k_fil),z_fil(k_fil)
     *  /efil_4/n_fil
     *  /efil_5/ind_fil(nwnh)
     *  /efil_6/psi_min,psi_max
     *  /efil_7/chi_sqr,chi_ps,chi_bp,chi_pf
     *  /efil_8/ves_coef,tpl_coef
     *  /efil_9/seps_fil(k_fil)
     *  /efil_10/plasma_coef
     *  /efil_11/i_shot
     *  /efil_12/gr_fil(nwnh,k_fil)
     *  /efil_13/ds_fil(k_fil)
     *  /efil_14/niter
     *  /efil_15/psi_pp(k_fil),psi_pff(k_fil)
     *  /efil_16/n_pp
     *  /efil_17/eu_fil
     *  /efil_18/x_b(ntet),y_b(ntet)

     *  /efil_19/n_rad_old,n_tet

     *  /efil_20/i_beta

	common
     *  /ef_1/gr_f(nwnh,k_cur),al_f(k_cur)
     *  /ef_2/a_loop(nloop,k_cur),a_probe(nprobe,k_cur)
     *  /ef_3/tok_f(k_cur)
     *  /ef_4/n_cur
     *  /ef_5/alf_end
     *  /ef_6/num_shot
     *  /ef_7/niter_max
     *  /ef_8/pl_sqr

	real *8 gr_f



        common
     *  /c_svd1/chi(1000)



c   dina_efit data for vessel...
        include 'parf_ves'
	common
     *  /ves_ef_1/ves_loop(nloop,k_ves),ves_probe(nprobe,k_ves)
     *  /ves_ef_2/tok_ves(k_ves)
     *  /ves_ef_3/n_ves
     *  /ves_ef_4/ind_ves(mu)
     *  /ves_ef_5/ves_vec(mu,k_ves)
     *  /ves_ef_6/ves_curr(k_ves)




c----  for PET subroutines...

	common
     *  /c_wrk1/wrk(nwnh)

	common
     *  /c_pet1/coef_pet
     *  /c_pet2/ui(nr,nz)
     *  /c_pet3/rwork(nbndp),zwork(nbndp)
     *  /c_pet4/ind(nbndp)
	common
     *  /c_bound1/x_bb(nbndp),y_bb(nbndp),c_bb(nbndp)
     *  /c_bound2/green_b(nbnd,nbnd),green_ves(nbnd*mu)
     *  /c_bound3/g(nr,nz),dgdn(nbndp),psi_bound(nbndp)
     *	/c_bound4/i_bound

       common
     *	/v_rz_tok/r_tok,z_tok
     *	/v_rz_tok1/r_tok0,z_tok0,zvel_tok

c   -------FOR ramp---------

	   common
     *  /c_ramp1/del_ramp
     *  /c_ramp2/rsep2,zsep2,psep2
 
       common /sep_points/n_sep,x_sep(mu1),y_sep(mu1)
       common /sep_points2/n_sep2,x_sep2(mu1),y_sep2(mu1)
  
c  Energy commons

        common /c_ener1/tene_e
        common /c_ener2/ro_bar,alf_bar

        common /c_ener3/diff_ext(npo),dxe_ext(npo),
     *  dxq_ext(npo),ajb_ext(npo),psin_ext(npo),
     *  vd_ext(npo)

        common /c_ener4/key_ext
        common /c_ener5/tene,ptot_dop
        common /c_ener6/vd_bound,v_ext
        common /c_ener7/ext_transp(npo)
        common /c_ener8/x_e_neo(npo),x_i_neo(npo)
        common /c_ener9/ft(npo)

        common /c_ener10/power_el,pow_el,ro_el,del_el
        common /c_ener11/power_ion,pow_ion,ro_ion,del_ion
        common /c_ener12/p_e(npo),p_i(npo),
     *  aj_cd(npo),pne_ext(npo)
        common /c_ener13/te_ext(npo),ti_ext(npo)
        common /c_ener14/sigma_ext(npo)
        common /c_ener15/p_ext(npo)

        common /c_ener16/qe0_ext(npo),qq0_ext(npo),
     *  del_ext(npo)
        common /c_ener17/sigk_ext(npo)







	    common
     *  /pol6_add1/ppx1(npo),pffx1(npo),ppx2(npo),pffx2(npo)
c Runaway
	common
     *  /c_ae3/sp_p,sp_p0,r_avr,d_aev,d_enae
     *  /c_ae4/paj(npo),paj0(npo)
c  additional  for runaways..
	common
     *  /c_run1/e_par(npo)
     *  /c_run2/cur_ohm(npo)
     *  /c_run3/qdg_ohm(npo),qdg_crit(npo)

	common
     *  /c_run4/pne_psi(npo),te0_psi(npo),zeff_psi(npo),
     * ajae_psi(npo),e_par_psi(npo),tok1_psi(npo),ro_psi(npo)

	common /c_imp_out4/qe0_av_prim,qe0_av_plas,pd0_av,
     * pt0_av,pn_av,pn1_av,pn0_av,ppr_imp_av

	common /c_imp_out5/pn0_av_imp,
     *  vt0_imp,prog_n0_imp



	common
     *	/v_com7/pne_vic(npo)

	common
     *  /c_grib1/u_nor(nr,nz)


	common /c_imp_out3/ratio_imp,ratio_imp2,gamma_z,gamma_z2


	common
     *	/c_add1/omg_ppx

	common
     *  /c_new_halo13/i_e(nwnh)


c ECH

	common
     *  /c_ech0/i_ech
     *  /c_ech1/power_ech1,tpl_ech1
     *  /c_ech2/aj0_ech1(npo),sb_ech1(npo)

     *  /c_ech3/power_ech2,tpl_ech2
     *  /c_ech4/aj0_ech2(npo),sb_ech2(npo)

     *  /c_ech5/power_ech,tpl_ech
     *  /c_ech6/aj0_ech(npo),sb_ech(npo)

     *  /c_ech7/p_e1,r_e1,z_e1,dz_e1,dr_e1
     *  /c_ech8/p_e2(10),r_e2(10),z_e2(10),dz_e2(10),dr_e2(10)
     *  /c_ech9/key_ech,k_bu
     *  /c_ech10/ro_ech,del_ech
     *  /c_ech11/num_ech

     *  /c_ech12/power_ech3,tpl_ech3
     *  /c_ech13/aj0_ech3(npo),sb_ech3(npo)
     *  /c_ech14/c_e2(10)
     *  /c_ech15/del_ech0
     *  /c_ech16/aj0_ech_1(npo),sb_ech_1(npo)
     *  /c_ech17/tpl_ech_1,power_ech_1

c zyb commons

        common 
     *  /c_imp1/sel(npo)
     *  /c_imp2/q_loss(npo),q_rad(npo)
     *  /c_imp3/tt1
     *  /c_imp4/alf_n,tay_lo
     *  /c_imp5/tempe(npo),tempi(npo)


  
c
	common
     *  /c_br4/wdh,p_oh

	common /c_imp_out1/dens_imp_neut(10)
	common /c_imp_out2/qlos_e,qlos_imp,qloss_ion

	common
     *  /c_tab1/pstab(npo),pptab(npo),fptab(npo),qtab(npo)
     *  /c_tab2/nutab
     *  /c_tab3/pptab0(npo),fptab0(npo)

c*** Victor's common blocks
     *   /vic_1/uact
	common 
     *  /c_ktm_1/vs_bound
     *  /c_ktm_2/vs_res,vs_ext


        common
     *  /graf1/tri,tri_up,tri_dw,el_up,el_dw

	common
     *  /c_grib2/rp1,zp1,dist1,rp2,zp2,dist2

        common /c_imas1/dxe0(npo),dxq0(npo),ajb0(npo)
     *  /c_imas2/pd0_p,pt0_p

        common /c_tran1/te0_tran(npo),tq0_tran(npo)
        common /c_tran3/pd0_tran(npo),pt0_tran(npo),pne_tran(npo)
        common /c_tran4/ajb_tran(npo),sigk_tran(npo)

c  BEAM Commons...

	common
     *  /inj0/i_beam
     *  /inj2/klz0,z_0,ab
     *  /inj3/t_inj
     *  /inj4/aj0_b(npo)
     *  /inj5/b_shape(npo)
     *  /inj6/pn_beam(npo)
     *  /inj7/p_b_par(npo),p_b_per(npo)
     *  /inj8/r_py
     *  /inj9/i_null
     *  /inj10/tpl_beam
     *  /inj11/s_beam(npo)
     *  /inj12/eee2,sb2(npo),s_beam2(npo)

c************************************************
        common
     *  /maksim_03/wr(150),wr_imas(150)
     *  /maksim_04/s_surf(npo)
     *  /maksim_05/s_bound
     *  /maksim_06/r_lh_coef
     
        common /c_teit_98/teit_98
        
        

     
     
