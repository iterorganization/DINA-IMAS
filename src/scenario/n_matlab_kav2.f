!> equil2 is a main subroutine to produce the DINA modeling in one time step
!> with energy and particle 1D transport modules if time > tt_kavin

	subroutine equil2()

	include 'double.inc'
	include 'new_com.inc'

	call equil2_c(
     *  ncam,tcam,tcam0,pf,npf,nps,rps,zps,rout,bt0,pll,	
     *  rref_p,q,tay_simul,int_2000,int_2005,
     *       z_cur,z_cur0,r_cur,tt_1,tt_2,i_wr,
     *       ksepa,ksepa_0,gaps0,i_bound,
     &       r_tok,z_tok,r_tok0,z_tok0,zvel_tok,
     *       del_ramp,omega,
     *       ro_bar,alf_bar,vchopper,pf0,pf_p,key_lh,key_h_to_l,
     *       tt_dw,tt_h,betp_flat,coef_kessel_1,vs_start,tt_emo,omg_ppx,
     *       fdd,fdd0,tau_p,xu,yu,xu_dist,yu_dist,ke,r_lh_new,pf_turns,
     *       pll0)

	return
	end


	subroutine equil2_c(
     *  ncam,tcam,tcam0,pf,npf,nps,rps,zps,rout,bt0,pll,
     *  rref_p,q,tay_simul,int_2000,int_2005,
     *       z_cur,z_cur0,r_cur,tt_1,tt_2,i_wr,
     *       ksepa,ksepa_0,gaps0,i_bound,
     &       r_tok,z_tok,r_tok0,z_tok0,zvel_tok,
     *       del_ramp,omega,
     *       ro_bar,alf_bar,vchopper,pf0,pf_p,key_lh,key_h_to_l,
     *       tt_dw,tt_h,betp_flat,coef_kessel_1,vs_start,tt_emo,omg_ppx,
     *       fdd,fdd0,tau_p,xu,yu,xu_dist,yu_dist,ke,r_lh_new,pf_turns,
     *       pll0)
     
	include 'double.inc'
	include 'parf0'
	include 'parf1'

	dimension pf(*),q(*),gaps0(*),vchopper(*),pf0(*),pf_p(*)
	dimension xu(*),yu(*),xu_dist(*),yu_dist(*),pf_turns(*)

	common

     *  /ge6e/zeff_a,zeff_b

     *	/n_m/n,m,mp
	common
     *	/keys1/i_graph
     *	/keys2/key_b
     *	/keys3/kzero,iread,iwrite
     *  /keys4/k_ener,k_uv
     *  /keys5/next
     *  /keys7/i_c
     *  /keys8/ndh
     *  /keys9/i_d3d,i_iter,i_smal
     *  /keys10/ngra
     *  /keys11/i_ramp
     *  /keys12/i_v
     *  /keys13/i_con,i_act
     *  /keys14/i_beta,i_gap5
     *  /keys15/i_br
     *  /keys17/i_feed,i_ecoil
	common
     *	/con1/gain,ta,zref,kzref
     *  /con2/rref,krref,bvert
     *  /con3/i_pf
     *  /con5/n_exp,k_cont
     *  /con6/ind_r(2),ind_z(2)
	common
     *  /pol4/ UM,VM,UK(ntet),VK(ntet)
	common
     *	/ge1/pi
     *	/ge1e/rs0,tpl
     *  /ge2/NTAY,TAY,TT
     *  /ge2e/t_end
     *  /ge4/EPS1,EPS2,EPS0
     *  /ge4e/it_v,it_pf
     *  /ge5/kpr
	common
     *  /cont13/zmag,zvel,delrmag,delzmag
     *  /cont13e/zmag0,rmag,rmag0,rvel
	common
     *	/efit4/coef
     *	/efit5/it1,it2
	common
     *  /DFM2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)
	common
     *  /mid2/vi(npo),spo(npo)
     *  /mid3/GRA1(npo),GRA2(npo)
	common
     *  /en6/Vn(npo)
     *  /en14/EMOE,EMOQ,NDOP,QDE0(npo),QDQ0(npo)
     *  /en14e/t_dop
     *  /en33/anom_e,anom_i,key_t11,kcchp
	common
     *	/point1/r0,z0
     *  /halo2/kmaj,k_q,k_d,kaxis,ndisrup
     *  /halo2e/next0,li_drop,n_li,n_dif,nmix
     *  /halo3/tay_00,tay_th,t_disr,d_tpl,tpl_end
     *  /halo4/expfg,avalb,w_h,del_r,al0
     *  /halo5/q_vde,q_95,del_f,i_halo
     *  /halo9/fluxt,fluxt0
     *  /halo10/fves,fves0,self_v
        common
     *	/ge7/eu,rs,zout,eksk
     *  /ge7e/eu_u
        common
     *	/fluxc12/r00,z00,eu00
	common
     *	/cont18/t_vde,time_disr

	common
     *  /cont4/ZPP,RPP,WVSPIP,ZXP,ELP,SHAPE,GAPINP,
     *  DFZP, DFZP0
     *	/cont9/brad,kefit_old
     *	/efit0/kefit
	common
     *  /ef_0/key_ef
	common
     *  /c_con8/key_con
     *  /c_con9/key_sig_coef

        common/vic_vic/coef_port
     *  /vic_014/dt_term_h
     *  /vic_015/dt_end
     *  /vic_016/tt_rampup

      common 
     * /c_imas_t_end2/t_end2

       common /c_imas_time_eq/time_eq
           
      common /c_tran2/k_ener_ext,k_dens_ext,k_ajb_ext
      common /c_dw_c14/tay_dw_c14

      common /c_tt_kavin2_c1/tt_rampup_c1,dt_end_sim_c1,
     * dtpl_term_l_c1,cIp_end_c1,CS1_eob_c1,rms_noise_c1
      common /c_q_test/q_test
      common /maksim_06/r_lh_coef

	dimension tcam(*),tcam0(*),ind(kf),pfhelp(kf)

	dimension uk_help(ntet),vk_help(ntet)
	dimension uk_help1(ntet),vk_help1(ntet)
	dimension uk_help2(ntet),vk_help2(ntet),tcam_help(200)

	character *30 apr
	dimension a_print(200)


!!! Ics1_eob=-30e-3*ntur(3); t_eob2=25; c_eob=0.9999; 
!!! cIp_end=1.5; dt_end=dtpl_term_l*cIp_end/7.5;

c********* FROM KAVIN ********
c*** tt_dw - start of ramp down
c*** dt_end - time duration of ramp down form 1.5 MA up to 0
c*** dt_term_h - time duration between tt_dw and H to L transition
c*** tt_rampup - SOF time


!           read (41,*)dtpl_term_h,dtpl_term_l,cIp_end,
!            CS1_eob,dt_contr_hl


!!           dt_term_h=dtpl_term_h*1e3

!!        cIp_hl=tpl/1e3

!           dt_end=cIp_end/cIp_hl*dtpl_term_l*1e3


!!        if(pf(3)/pf_turns(3).lt.CS1_eob .and. k_CS1.eq.0 
!!     *     .and. tt.gt.dt_contr_hl*1e3) then
!!        k_CS1=1
!!        tt_eob=tt-1e-3
!!        tt_dw=tt_eob


!      kpr=1

!      tt_dw=1.e8

      i_en=i_en+1
      
!      k_ener_ext=1
      
      if(kpr.eq.1)print *,'k_ener_ext=',k_ener_ext
      if(kpr.eq.1)print *,'k_dens_ext=',k_dens_ext
      if(kpr.eq.1)print *,'k_ajb_ext=',k_ajb_ext
      

      	if(i_en2.eq.-1)then	
        open (unit=1,file='kpr.dat',form='formatted')
        read (1,*)
        read (1,*)kpr
        
!              i_con=3

        close ( unit=1)       
	end if

      if(i_en.gt.1)goto 2323
      
!      next=2
      
      eps2=1.e-5
      
      tt_HL_xx=600.e3
     
       key_sig_coef=1.d0
     
    !   kpr=1


c  ro edge barier
      ro_bar=0.9
c  alf of edge thermal barier

!	alf_bar=0.1
	alf_bar=1.

c      i_matlab=0 old case 
c      i_matlab=1 matlab greens reading 

	i_matlab=1

c  i_fil=0 old case without reconstruction
c  i_fil=1  reconstruction with Polar rmag.zmag
c  i_fil=2  reconstruction with OLD rectangular grid rmag.zmag
c  i_fil=3  reconstruction with rgeom.zgeom from filament reconstruction

	i_fil=0
	i_old=0

	i_map=1
ccc	i_map=0

c   del_psi from boundary...

	del_ramp=0.1

c---  we think ....???
	ARG=1.
	pi=4.*atan(ARG)
	coef=10./(4.*pi)
	ntay=0
c---

	call shape_emo()

!	call den_read()
	call den_read_t()
      call n_dd_read()
      call dens_prof()
      if(k_dens_ext.eq.1.and.k_ener.eq.1)call dens_corr()
	call bet_li_dat()

!	call read_data2()
c	call shape_d3d()


!          open (unit=40,file='zvel_max.dat',form='formatted') 

          zv_max=0.01e5
          n_svd=10
          i_avr=0
          i_filter=0
          tau_p=100.
          
          
          if(kpr.eq.1)print *,' zv_max,n_svd,i_avr,i_filter,tau_p',
     *    zv_max,n_svd,i_avr,i_filter,tau_p
          
!           close (40)

	   zv_max_help=zv_max
	   zv_max=1.e10

      	eps20=eps2
        eps20_mem=eps20

      	VMAX=1.E5
      	DO I=1,n
    	VN(I)=VI(I)/VMAX
	end do

       call gamma_z1_read()
       call gamma_z2_read()
       call gamma_z3_read()
       call gamma_z4_read()
!       call gamma_z5_read()

!      print *,' YERE'
!      read (*,*)
      

!	if(k_ener.eq.1)call dens_prog()
	if(k_ener.eq.1)call dens_prog_dt()
      if(k_dens_ext.eq.1.and.k_ener.eq.1)call dens_corr()
	call pp_calc()
     
	if(k_ener.eq.1)then
      if(kcchp.eq.0)then      
       call srs_feed()
       call solpszb()
!       call solpsz()
      end if
	CALL ENERGY(N)
	if(k_ajb_ext.eq.1)CALL ajb_corr()
	if(k_ener_ext.eq.1)CALL ENERGY_corr()
      if(k_dens_ext.eq.1)call dens_corr()
	end if
      
	if(k_ener.ne.1)call enit(n)
      if(k_ener.eq.0)call prof_astra()
!      if(k_ener.eq.0)call prof_astra_hl()
	call pp_calc()

c!!!	CALL BTA(n,mp,RS0)
	call DOPP()

c* vic  To read tay_simul
        call vic_tay()

	key_h_to_l=0
	tt_h_to_l=1.e8

!          open (unit=40,file='scen_data_3.dat',form='formatted') 
 !         read (40,*)tt_emo,tt_h,tt_avr,betp_flat,coef_kessel_1,vs_start
        tt_emo=200.e3 
        tt_h=66100.
        tt_avr=66100.
        betp_flat=0.678
        coef_kessel_1=1.2
        vs_start2=2.53035

!          open (unit=40,file='dw.dat',form='formatted') 
!          tay_dw=5.
!          open (unit=40,file='dw.dat',form='formatted') 
!          read (49,*) 
!          read (40,*)tt_dw,tay_dw
!          read (49,*)tay_dw
          tay_dw=tay_dw_c14

!	  close (40)


	del_tt=0.
	i_lim=0
	
	time_to=20.d6
	time_back=200.d6

	do i=1,ke
	   xu_dist(i)=xu(i)
	   yu_dist(i)=yu(i)
	end do
!          open (unit=40,file='tt_kavin2.dat',form='formatted') 
!          read (39,*) 
!          read (39,*)tt_rampup
!          read (39,*) 
!          read (39,*)dt_end_sim,dtpl_term_l,cIp_end

          tt_rampup=tt_rampup_c1
          dt_end_sim=dt_end_sim_c1
          dtpl_term_l=dtpl_term_l_c1
          cIp_end=cIp_end_c1
          

          dtpl_term_h=0
          
!          read (39,*) 
!          read (39,*)CS1_eob,rms_noise

!	  close (39)

          CS1_eob=CS1_eob_c1
          rms_noise=rms_noise_c1
          

        dt_term_h=dtpl_term_h*1e3

          if(kpr.eq.1)print*,
     *   'dtpl_term_h,dtpl_term_l,cIp_end',
     *   dtpl_term_h,dtpl_term_l,cIp_end

          if(kpr.eq.1)print*,
     *   'CS1_eob,dt_contr_hl',
     *   CS1_eob,dt_contr_hl

          if(kpr.eq.1)print*,
     *   'pf3 pf_turns(3) dt_term_h',
     *   pf(3),pf_turns(3),dt_term_h


!      kpr=3

       	tt_h=1.e8
       	t_end2=1.e10

          if(kpr.eq.1)print*,
     *   'tt tt_rampup r_lh_new tt_h',tt,tt_rampup,r_lh_new,tt_h

          if(kpr.eq.1)print*,
     *   ' ++tt t_end2',tt,t_end2
       
       goto 2323


c  	call shape_f9a() 

c	if(kpr.eq.1)print *,' ENTER'
c	read (*,*)

	if(kpr.eq.1)print *,' END of READfor002'

	if(i_graph.eq.1)call initvm(10,10,800,780)
c	call initvm(10,10,800,780)

	call anglep()
	call angl_p()
	call ONE2()
c	call pl_bound_p()
	call pl_bound()

c!!!!!	call read_gaps()


	if(kpr.eq.1)print *,' i_matlab',i_matlab
c	read (*,*)

	if(i_matlab.eq.0)then

	CALL TOK()
	call shape_pf_iam() 
c	if(kpr.eq.1)print*,(pf(i),i=1,npf)
c	read(*,*)


        if(ntay.gt.next)call vic_shape_ip_iam()

c!!!!!!!!!!!!!!!!
      call brz_vec_r()

	call limiter()
	call vessel()
	call res_ves()
	call ves_pf_r()
	call cam_t()

      call pf_ind()
c--------------
c  here we multiply by c_pf_res all PF coils resistances...
	call coef_pf_res()
      call inv()
      if(kpr.eq.1)print *,' call to inv==='

      end if

	

	if(i_matlab.eq.1)then
c----------------------  FLAT files reading.....
 !       call flat_ext()
c----------------------  end of FLAT files reading.....
!	call shape_pf_iam() 
!      call brz_vec_r()

	else

	call read_flux()
	call loop_r()
	call prob_r()

	end if


c###	call inv_gen()
	call cam_t()
!      call inv()
      call shape_pfres()
      call inv_gen()
!	call gen()


	call f_40()
	if(i_fil.ge.1)then
	call read_fwt()
	call read_fwt_coef()
	end if


	i_bound=0


c!!!!!!!! NEW call....

	call plasma_bz()

	i_sh=1
	if(i_sh.eq.1.and.tt.lt.5000.)then
c$
           open (unit=40,file='I_v3a.dat',form='formatted') 
	   read (40,*)(tcam(i),i=1,ncam)
           close (40)
	do i=1,ncam
	   tcam(i)=tcam(i)*1000.
c	   if(kpr.eq.1)print*,tcam(i)
c	   read(*,*)
	end do

	call tcam_w()
c$
	call tcam_r()

	end if




  	call s_zpp()
  	call shape_rpp()
!	rref=rref_p
	r0=rref
	z0=zref

	um=r0
	vm=z0

	if(ntay.le.next)call shape_ip()

c	if(kpr.eq.1)print*,(pf(i),i=1,npf)
c	pause


c!!!	call shape_volt()
c!!!	call shape_pow()

	call shape_emo()

c	if(i_iter.eq.1)	call f_40()

!!!	call read_flux()

c*** Input of PF turns - must be consistent with 'koor' file!
        call vic_turn()

c*** Input of Zeff waveform ***
!        if(k_ener.eq.1)call vic_zeff_read()
        if(k_ener.eq.0)call prof_astra()
!      if(k_ener.eq.0)call prof_astra_hl()
	call cur_prof()


	if(kefit.eq.5)call pet_tab()

      if(kefit.eq.4)then
      call prof_in()
      call shape_pf()
      call shape_tcam()
      call shape_rpp2()
      call shape_zpp2()
      
     	rref=rmag
     	zref=zmag
     	
	r0=rref
	z0=zref

	um=r0
	vm=z0
      end if


c	call read_sh()
c	call contr_r()
c------------

c	CALL TOK()

c----

	k_avr=1
	eu_a=amax1(eu,eu_u)
	call avr(r0,z0,1.5*eu,k_avr)
	call movem(i_c)
	i_bound=0

	if(key_b.eq.1)call read_psgrid()

c	call choppers()
c	read (*,*)


ccc!!!	zref=vm

c!!!	if(i_smal.eq.1)call prog_val()

	if(kpr.eq.1)print *,' i_ramp=',i_ramp

c        kpr=0

        ntay_h=ntay

        ntay=0

        if(i_ter.eq.1.and.i_c.eq.1)then
           eu_00=eu
           um_00=um
           vm_00=vm
        end if



c	if(i_smal.eq.1)call movem(i_c)

c	call flat_ext2()

	if(kpr.eq.1)print *,' call ptoke0=============='
	call ptoke0()
	pt0z=-tpl
	it1=1
	if(iread.eq.1)	then
           call read_write()
	call movem(i_c)
		i_bound=0

        end if

	int=0
	niter=1
	call ves_pind()
	self_v=0.2*fluxt0
	if(kpr.eq.1)print *,' sef_v===',self_v
c	read (*,*)
c	kpr=1

c*** reading of mode.dat file to chose mode of simulations
        call vic_wr()        
c        if(kpr.eq.1)print*,'i_wr=',i_wr
c        pause 'from main'

c!!!!!	i_wr=0
cccccc	i_wr=1
c	call shape_pf_iam() 
	if(i_wr.eq.0)call r_tokk()

c	if(kpr.eq.1)print*,(pf(i),i=1,npf)
c	pause


c*** vic Gaps_data for ramp-up stuff
        call vic_read_gaps()

 	if(i_fil.ge.1)then
	   call fil_dis_cir()
	end if

	if(tt.gt.2000.)go to 1
c	if(tt.gt.1000.)go to 1

	tt_1=tt

	tt=0.
	do i=1,10000
	   tt=tt+tay
	   
	   if(tt.ge.tt_1)go to 1

	   call shape_pf_iam() 
c!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
c!!!!! Transfer PF_DINA_order to PF=PF_original_order !!!!!!!!!!!
c!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	if(i_wr.eq.0)call r_tokk()

	   call ful()

c@@@	   call pf_volt()

c	   call DOPP()

	   call time_step()


	end do


1	continue

        do i=1,npf
           if(kpr.eq.1)print*,i,pf(i)
        end do
c        pause 'from main'
c*******************************

	if(kpr.eq.1)print *,' call ptoke1=============='
	niter=niter+1

        apr= 'pf 111 '
        if(kpr.eq.1)print 71,apr,(pf(i),i=1,npf)

	if(kpr.eq.1)print *,' ZPP RPP BEFORE ptoke1',zpp,rpp
	call ptoke1()
	
	if(i_iter.eq.1.and.i_ramp.eq.0) then                                   
c        call gsvd0()
        end if
 

	if(i_c.eq.1)then

	if(niter.gt.2.and.niter.eq.3*(niter/3))then
	k_avr=1
	call avr(rout,zmag,eu,k_avr)

	call movem(i_c)
		i_bound=0

	end if

	if(niter.gt.1.and.niter.lt.5)then
	k_avr=1
	call avr(rout,zmag,eu,k_avr)

	call movem(i_c)
		i_bound=0

	end if

	end if

	if(kpr.eq.1)print *,' --um vm eu niter ntay',um,vm,eu,niter,ntay
c----------
c  plot magnetic surfaces...
	if(i_graph.eq.1) call graphic(it1,n)

	if(it1.ne.0)go to 1


ccc      call ppx_pffx_save(1)
      
        call loopflux()                                                       
        call probefield()

 	call q_calc()
c
      if(kefit.eq.4)then
       kzref=0
        krref=0
      end if


      if(kzref.eq.1.and.krref.eq.1)then
	   eps2_help=eps2
	   eps2=1.d-5
         call stab(ich,i_graph)

ccc         call ppx_pffx_save(1)

	if(i_c.eq.1)then
      k_avr=1
	call avr(rout,zmag,eu,k_avr)
      call movem(i_c)
      i_bound=0
	end if

      call stab(ich,i_graph)

	if(i_c.eq.1)then
      k_avr=1
	call avr(rout,zmag,eu,k_avr)
      call movem(i_c)
      i_bound=0
      call stab(ich,i_graph)
	end if


           kzref=0
           krref=0
	   eps2=eps2_help

ccc      call ppx_pffx_save(1)
		
	end if

!	if(i_graph.eq.1) call graphic(it1,n)

c	stop


        call kpl_out()

c        read (*,*)



	int=int+1
	call polar_data()
	kp=1

	if(i_map.eq.0)then

      CALL POLAR1(n,mp,rs0,kp,pt0z)
	call polar_res()
	CALL BTA(n,mp,RS0)
	end if

	if(i_map.eq.1)then
	call map_tor()
	CALL BTA(n,mp,RS0)
!!!	call tab_w()
	end if


	a_print(1)=i_map
	n_pr=1
	apr=' i_map '
	num=30
	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)


	
  	do j=1,mp
	   uk_help(j)=uk(j)
	   vk_help(j)=vk(j)
	end do
	um_help=um
	vm_help=vm
	
	
c	stop

	if(i_fil.ge.1)then
	call read_exp()
	call svd_fil()
	call ptoke1_fil_0()

	if(i_fil.eq.1)then
	call polar_fil()
	z_tok_pol=z_tok
	end if

	end if


c	if(int.eq.1)go to 1

c	call pfves_d3d()
c	call pfves()

c        ntay=ntay_h

        if(kpr.eq.1)print *,' ntay===',ntay

c        kzref=0

c        read (*,*)

	if(iwrite.eq.1)	then
	call read_write()
	stop
	end if

c	call pll_calc()
c----------------------------------
c  toroidal coordinates...

!	call den_read()
	call den_read_t()
      call n_dd_read()
c**** pcchp calculations with regards Greenwald limit
        call vic_dens_dt()
      
         if(k_dens_ext.eq.1.and.k_ener.eq.1)call dens_corr()

c*** Here we are doing te0(n)=tq0(n)=g_edge*tec !!!
!!!        call vic_t_edge()

	if(i_map.eq.0)then
	call transf_data()
	else
	call transf_data_new()
	end if

      	VMAX=1.E5
      	DO I=1,n
    	VN(I)=VI(I)/VMAX
	end do

       call gamma_z1_read()
       call gamma_z2_read()
       call gamma_z3_read()
       call gamma_z4_read()

!	if(k_ener.eq.1)call dens_prog()
	if(k_ener.eq.1)call dens_prog_dt()
      if(k_dens_ext.eq.1.and.k_ener.eq.1)call dens_corr()
      call pp_calc()


	if(k_ener.eq.1)then
      if(kcchp.eq.0)then      
       call srs_feed()
       call solpszb()
!       call solpsz()
      end if
	CALL ENERGY(N)
	if(k_ajb_ext.eq.1)CALL ajb_corr()
	if(k_ener_ext.eq.1)CALL ENERGY_corr()
      if(k_dens_ext.eq.1)call dens_corr()
	end if
	

	if(k_ener.ne.1)call enit(n)
      if(k_ener.eq.0)call prof_astra()
!      if(k_ener.eq.0)call prof_astra_hl()
	call pp_calc()



c!!!	CALL BTA(n,mp,RS0)
	call DOPP()


c	call gen()

      call shape_pfres()
	call gen()

	call ful()

c	call d3d_corr_pf()

c	call d3d_corr()
	call time_gen()
	call time_step()
	call time_st_ppx_pffx()

	call time_out()

	eps20=eps2

	rmag_in=rmag
	zmag_in=zmag
	del_r=0.
	next0=next
	k_q=0
	k_d=0
	kaxis=0
	i_di=0

	call ful()

	do i=1,npf
	   pfhelp(i)=pf(i)
	end do
c* vic  To read tay_simul
        call vic_tay()

        eps20_mem=eps20
c        kpr=0

c        if(kpr.eq.1)print*,'beginning!!!!!!!!!!!'
c        if(kpr.eq.1)print*,'rmag zmag',rmag,zmag
c        if(kpr.eq.1)print*,'r_cur z_cur',r_cur,z_cur
c        pause 'from main'

c	omega=1.

	key_h_to_l=0
	tt_h_to_l=1.e8

          open (unit=40,file='scen_data_3.dat',form='formatted') 
          read (40,*) 
          read (40,*)tt_emo,tt_h,tt_avr,betp_flat,coef_kessel_1,vs_start
           close (40)
c	   if(kpr.eq.1)print*,tt_dw,tt_h,betp_flat,coef_kessel_1,vs_start
c	   read(*,*)

	   omg_ppx=1.d0

         zref=zmag0


  	do j=1,mp
	   uk_help2(j)=uk_help(j)
	   vk_help2(j)=vk_help(j)
        end do

	um_help2=um_help
	vm_help2=vm_help

	del_tt=0.
	i_lim=0
	
	time_to=20.d6
	time_back=200.d6
	
	do i=1,ke
	   xu_dist(i)=xu(i)
	   yu_dist(i)=yu(i)
	end do

	if(kpr.eq.1)print *,' time_to time_back=',time_to,time_back

!!!	call wr_tabppf()
!!!        call wr_pf()
!!!        call wr_tcam()
!!!      call wr_rpp()
!!!      call wr_zpp()

          open (unit=40,file='elm.dat',form='formatted') 
          read (40,*) 
          read (40,*)tt_elm,tay_elm
          read (40,*) 

	  close (40)


          open (unit=40,file='dw.dat',form='formatted') 
          read (40,*) 
!          read (40,*)tt_dw,tay_dw
          read (40,*)tay_dw
          read (40,*) 

	  close (40)


	tt_h=1.e8

      stop

        return

      
2323	continue

       kpr=1

c*** !!!!! *** FROM KAVIN ******
	   if(ntay.le.next+1)then
ccc	      tt_h=1.e8
	      tt_avr=1.e8
	   else	      
ccc	      tt_h=tt_rampup+1100.
	      tt_avr=tt_rampup+1100.
	   end if

	   
	   if(tt.gt.tt_rampup+1100..and.r_lh_new.gt.r_lh_coef.and.
     *         key_help.eq.0)then
	      key_help=1
	      tt_h=tt
	   end if
          if(kpr.eq.1)print*,
     *   'tt tt_rampup r_lh_new tt_h',tt,tt_rampup,r_lh_new,tt_h
!!!	   tt_h=1.e8

c*******************************

      if(i_3323.eq.1)goto 3323

      i_kavin=0
      
!  If write eqdsk_files then =1 ! 03.12.2019      
!      i_kavin=1  

      if(i_kavin.eq.1.and.k_zyb.eq.0)then

      key=1
      call psi_g_c(key)



      do i=1,ncam
      tcam_help(i)=tcam(i)
      end do


           kz_help=kzref
           kr_help=krref

           kzref=1
           krref=2
!           krref=1

           zref=zmag
           rref=rmag 

c-------  calculate...


      int_2005=0
      
      it1=1
      
	   call ppx_pffx()

	eps2=eps20                                                             

2006  continue
      
      int_2005=int_2005+1
         
                     
       call ptoke1()
     
	if(int_2005.gt.10)eps2=eps2*1.5
	if(it1.ne.0.and.int_2005.lt.20)go to 2006

	if(kpr.eq.1)print *,'-+int_2005 eps2  ',int_2005,eps2

        kzref=kz_help
        krref=kr_help

      do i=1,ncam
      tcam(i)=tcam_help(i)
      end do

      key=0
      call psi_g_c(key)

      end if !  for_kavin


        cs1_help=pf(3)/pf_turns(3)
        
        print *,' cs1_help CS1_eob dt_contr_hl=',
     *  cs1_help,CS1_eob,dt_contr_hl
      
        if(pf(3)/pf_turns(3).lt.CS1_eob .and. k_CS1.eq.0 
     *     .and. tt.gt.dt_contr_hl*1e3) then
        k_CS1=1
        tt_eob=tt-1.e-3
        tt_dw=tt_eob
        end if
        

      if(tt.gt.time_to.and.tt.le.time_back.and.i_lim.eq.0)then
      i_lim=1
	call new_lim(i_lim)
	end if
      if(tt.gt.time_back.and.i_lim.eq.1)then
      i_lim=2
	call new_lim(i_lim)
	end if
	

	if(tt.ge.93.41e6.and.tt.le.93.44e6)then
c	   del_tt=del_tt+tay
c	   if(del_tt.ge.1000.)then
c	      del_tt=0.
	      open (unit=70,file='tcam_kavin.dat',access='append',
     *      form='formatted') 
	      write (70,*)tt
	      write (70,5002)(tcam(i),i=1,ncam)
	      write (70,5002)(pf(i),i=13,15)
	      close (70)
c	   end if
	end if

 5002   format (150(1pe12.4))
c============================================================

	if(tt.gt.30.e3)zv_max=zv_max_help

c++++++++++++++++++++++++++++++++++++
c	if(tt.ge.150.e3)then
c	   call bp_gribov()
c	   stop
c	end if
c++++++++++++++++++++++++++++++++++++


c	if(kpr.eq.1)print *,' t_end==',t_end

c	if(kpr.eq.1)print*,(pf(i),i=1,npf)
c	if(kpr.eq.1)print*,'!!!!!'
c	read(*,*)


c        if(tt.gt.1020000.)kpr=1
c        kpr=1

        ksepa_0=ksepa

c        if(kpr.eq.1)print*,'ntay=',ntay
c        pause 'from main'

c****************
        eps20=eps20_mem
c        if(tt.gt.tt_1.and.tt.lt.tt_2)eps20=1.e-3
c****************

c	if(ntay.eq.100*(ntay/100).and.i_graph.eq.1)call endvm
c	if(ntay.eq.100*(ntay/100).and.i_graph.eq.1)call initvm(10,10,800,780)

c        coef_port=150.
c        if(tt.gt.25000.)read(*,*)coef_port


c*vic To read elong_ref
c        call vic_elong_read() 

c*vic
c        call r_volt()
c	if(ntay.gt.next+1)then
c	   call vic_portone()
c	end if

c	tt_elm=68.e3
ccc	tt_elm=69.98e3
ccc	tay_elm=1.

c	if(ntay.gt.next+1.and.tay.lt.99)then
!	if(ntay.gt.next+1.and.tay.lt.tay_simul*0.99.and.krref.eq.0)then


	if(ntay.gt.next+1.and.tay.lt.tay_simul*0.99
     *   .and.ntay.lt.next+30)then
	   tay=tay*1.2
	if(kpr.eq.1)print *,' HERE tay has chaged tay==',tay
c*vic	   if(tay.gt.100.)tay=100.
c	   if(tay.gt.20.)tay=20.
c	   if(tay.gt.10.)tay=10.
	   if(tay.gt.tay_simul)tay=tay_simul
c	   if(tay.gt.5.)tay=5.
      	call cam_t()
!         call inv()
      call shape_pfres()
	      call inv_gen()
!	   call gen()
	end if

c****** tay decreasing ******
ccc	   if(tt.ge.tt_elm)then
!	   if(tt.ge.tt_dw-5.e3)then

	   if(tt.lt.tt_dw)then
	   tpl_flat=tpl
         end if

	   if(tt.ge.tt_dw.and.tay.gt.tay_dw)then
c	      tay=tay/1.2
	      tay=tay/1.5
ccc	      if(tay.lt.tay_elm)tay=tay_elm
	      if(tay.lt.tay_dw)tay=tay_dw
	      call cam_t()
            call shape_pfres()
	      call inv_gen()
!	      call gen()
	   end if
c***************************
	
c	if(kpr.eq.1)print *,' 2323 ntay tt=',ntay,tt
c	read(*,*)

c	if(ntay.eq.ngra*(ntay/ngra))then


!	ntay=ntay+1

	if(tt.gt.time_disr)i_di=i_di+1
	if(i_di.eq.1)ndisrup=ntay

	if(kpr.eq.1)print *,' ndisrup=== ntay ',ndisrup,ntay

c!!!	call index_calc()

	if(kpr.eq.1)print *,' END index==='

	if(i_c.eq.1)then	
	k_avr=1
	eu_a=amax1(eu,eu_u)
        zmag_0=0.
	call avr(rout,zmag,eu_a,k_avr)

	call movem(i_c)
		i_bound=0
	end if

	if(kpr.eq.1)print *,' END movem==='

!	if(ntay.ge.next)tt=tt+tay
!	tt=tt+tay

	if(kpr.eq.1)print *,' ntay ndisrup tt tay===========',ntay,
     *	ndisrup,tt,tay


!	print *,' ntay tt tay===========',ntay,
!     *	tt,tay


	int_dif=0

	if(tt.ge.t_dop)ndop=1

	int_2000=0

	i_sh=0

! 03_12_2019
!  	call s_zpp()
!  	call shape_rpp() 



!	rref=rref_p

!	call vic_shape_elong()

!	if(ntay.le.next)call shape_ip()

c!!!	call shape_volt()
c!!!	call shape_pow()

c**********************
c	if(tt.ge.tt_dw)then
c	   emoe_help=emoe
c	   emoq_help=emoq 
c	end if
c**********************	

	call shape_emo()

c*************
	pnor=6.25e8
c	if(tt.gt.tt_dw+20.)emoe=15.*pnor
c	if(tt.gt.tt_dw+40.)emoe=0.
!	if(tt.gt.tt_dw+dt_term_h)emoe=0.
	if(tt.gt.tt_dw+dt_term_h+20.)emoe=0.
c*************
	if(kpr.eq.1)print*,'emoe= tpl_flat',emoe,tpl_flat
	if(kpr.eq.1)print*,'!!!! tt tt_dw=',tt,tt_dw

c	if(kpr.eq.1)print*,'!!!! tt_dw=',tt_dw
c	if(kpr.eq.1)print*,'!!!!!tt key_lh key_h_to_l',
c     *       tt,key_lh,key_h_to_l

c!!!!!!!!!	if(ntay.gt.15)call vic_feed_aux()
ccccc	if(ntay.gt.15.and.key_lh.eq.1.and.tt.le.tt_h_to_l)
	if(ntay.gt.15.and.key_lh.eq.1.and.key_h_to_l.eq.0)
c	if(ntay.gt.15.and.key_lh.eq.1.and.tt.lt.tt_dw)
c	if(ntay.gt.15.and.key_lh.eq.1)
     *   call vic_feed_aux()

c	if(tt.ge.tt_dw)then
c	   emoe=emoe_help
c	   emoq=emoq_help 
c	end if


	if(tt.gt.200000..and.key_h_to_l.eq.1)then
	   emoe=0.
	   emoq=0.
	end if
c	if(kpr.eq.1)print*,'!!!tt emoe emoq',tt,emoe,emoq
c$

!	call den_read()
	call den_read_t()
      call n_dd_read()
c**** pcchp calculations with regards Greenwald limit
        call vic_dens_dt()
         if(k_dens_ext.eq.1.and.k_ener.eq.1)call dens_corr()
c*** Input of Zeff waveform and ***
c!!!!!!        if(k_ener.eq.1)call vic_zeff_read()
c$
c*vic  	call shape_pf_iam() 
  
c*** To read Ip and PF_p preprogrammed waveforms (in DINA order)
c*** from scr_data file 
!	if(kpr.eq.1)print*,'@@@@@from main'

!      call vic_shape_ip_iam()
!	if(i_wr.eq.0.and.ntay.gt.next)call r_tok_p()

c	if(kpr.eq.1)print*,(pf(i),i=1,npf)
c	if(kpr.eq.1)print*,'111'
c	read(*,*)

c	call shape_3() 
c	call shape_4() 

c	call gen_cor()

	if(ntay.gt.next)then
c	   kzref=0
	end if

c	if(kzref.eq.0)call v_act()

	if(tpl.lt.-1000.)i_tpl=1

	if(i_tpl.eq.1)then
	   krref=0
	end if

!	bt0=bt0*rs0/rout
!	rs0=rout

c	if(kpr.eq.1)print *,' bt0 rs0==',bt0,rs0

c	call shape_ipp()

cc	if(ntay.gt.next+5)then
cc           call ip_it_feed()
cc	end if

c*** Forces for control calculations ***
ccc	if(ntay.gt.next)call f_cs()

	call li_d()

	call tem_con2()
	   
      if(kpr.eq.1)print *,' i_fil==',i_fil



c!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
c!!!!! Transfer PF_original_order to PF !!!!!!!!!!!!!!
c!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
c!!!!! Transfer VCHOPPER_DINA_order to VCHOPPER !!!!!!
c!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
c*** Br, Bz in any point ***
c!!!!!	call vic_br_bz()

	it1=1
c----------
      if(i_ngra.eq.0)then
!          open (unit=40,file='time_ngra.dat',form='formatted') 
        time1=350.e3 
        time2=450.e3
	  i_ngra=1
	  end if
	  

	  if(tt.ge.time1.and.key_ngra.eq.0)then
	     key_ngra=1
	     ngra_help=ngra
	     ngra=1
	  end if

	  if(tt.ge.time2)ngra=ngra_help

	if(ntay.eq.ngra*(ntay/ngra).or.ntay.eq.0)then
!!!	   call write_prof()
	   call write_prof0()
	if(kpr.eq.1)print *,' END write_prof '
         call  write_surf()
c         call  write_surf_eq()
!!!	 call write_tok()
ccc	 call write_separ_coor()
ccc	 call write_separ_coor2()
	if(kpr.eq.1)print *,' END write_surf '

c	if(kpr.eq.1)print*,(pf(i),i=1,11)
c	read(*,*)

ccc           call kpl_out()
	end if

	if(tt.ge.93.43e5.and.k_cur_tor.eq.0)then
	   k_cur_tor=k_cur_tor+1
	   call cur_tor_out()
c	   stop
	end if
c	if(tt.ge.93.42e3.and.k_cur_tor.eq.1)then
c	   k_cur_tor=k_cur_tor+1
c	   call cur_tor_out()
c	   stop
c	end if

c%%%%%%% eqdsk writing %%%%%%%%%
      if(i_kavin.eq.1)then
	if(tt.ge.130.062e5.and.k_eqdsk.eq.0)then
	   k_eqdsk=k_eqdsk+1
	   call equidsk_write(k_eqdsk)
	   call te0_write(k_eqdsk)
	   call write_separ_coor()
	   call write_separ_coor2()
c	   stop
	end if

	if(tt.ge.130.0906e5.and.k_eqdsk.eq.1)then
	   k_eqdsk=k_eqdsk+1
	   call equidsk_write(k_eqdsk)
	   call write_separ_coor()
	   call write_separ_coor2()
c	   stop
	end if

	if(tt.ge.658.e5.and.k_eqdsk.eq.2)then
	   k_eqdsk=k_eqdsk+1
c	   call equidsk_write(k_eqdsk)
	   call write_separ_coor()
	   call write_separ_coor2()
	end if

	if(tt.ge.618.6e3.and.k_eqdsk.eq.3)then
	   k_eqdsk=k_eqdsk+1
c	   call equidsk_write(k_eqdsk)
	end if

	if(tt.ge.624.5e5.and.k_eqdsk.eq.4)then
	   k_eqdsk=k_eqdsk+1
c	   call equidsk_write(k_eqdsk)
	end if

	if(tt.ge.629.2e5.and.k_eqdsk.eq.5)then
	   k_eqdsk=k_eqdsk+1
c	   call equidsk_write(k_eqdsk)
	end if


	end if  ! i_kavin=1


ccc     call ppx_pffx_save(2)

!	if(ntay.gt.20)then


      if(tt.le.61.66e9)then
!      kzref=0	
!      krref=0	

      if(kpr.eq.1)print *,' ++kzref tt',kzref,tt

      end if

!      n_svd=2
!      n_svd=20
       
      ntay1=ntay-1
      if( ntay1.eq.n_svd*( ntay1/n_svd ))then
	k_svd=0
     	do j=1,mp
	   uk_help1(j)=uk_help2(j)
	   vk_help1(j)=vk_help2(j)

	   uk_help2(j)=uk_help(j)
	   vk_help2(j)=vk_help(j)
        end do

	um_help1=um_help2
	vm_help1=vm_help2

	um_help2=um_help
	vm_help2=vm_help

      end if
      
      i_zvel=0

      k_svd=k_svd+1
      if(kpr.eq.1)print *,'k_svd ntay n_svd=',k_svd,ntay,n_svd


      if(k_ener.eq.0)call prof_astra()

      call shape_pfres()
!	call gen()

2000	continue
	int_2000=int_2000+1

      
c
      ngra2=1
!      ngra2=1000

!	if(ntay.eq.ngra2*(ntay/ngra2).and.ntay.gt.20)then
	if(ntay.eq.ngra2*(ntay/ngra2).and.ntay.gt.2)then

      omg_ppx=omg_ppx*0.99
      if(omg_ppx.le.0.5d0)omg_ppx=0.5d0
     
      ! pprime and ffprime
      call ppx_pffx()
      call ppx_pffx_corr2()
	   	      
	end if

	zvel_0=zvel

	eps2=eps20
	int_2005=0

	if(krref.eq.-3)then
	   it1=0
	   go to 2001
	   end if



2005	continue
	int_2005=int_2005+1
c        if(i_iter.eq.1.and.i_ramp.eq.0.and.ntay.le.1)then                      
c        call gsvd0()
c        end if
c	call svd_d3d()

	if(kpr.eq.1)print *,' call ptoke1 i_bound',i_bound
	if(kpr.eq.1)print *,' Zref Rref BEFORE ptoke1',zref,rref
	
	if(kpr.eq.1)print *,' kzref krref BEFORE ptoke1',kzref,krref

	do i=1,ncam
c	   tcam(i)=0.5*(tcam0(i)+tcam(i))
	end do


	call ptoke1()

	  call loopflux()                                                       
        call probefield()

c
c	call gen()

	call index_calc()

        rmag=um
        zmag=vm

c	call v_feed()

c*vic
c!!!!!!!!!!!!!        call r_volt()
c!!!!!!!!!!!!!        call get_gaps()
c	if(kpr.eq.1)print*,'z_cur r_cur',z_cur,r_cur
c        pause 'from main'
c        call vic_gaps0_read()

	if(ntay.gt.next)then
c! 	   kzref=0
c!c	   krref=0
c	   kzref=0
c	   krref=0
	brad=0.
	bvert=0.
c!!!	   call vic_z_feed()

c***
ccccccccccccccccccc           call SCEN_CONTROL()
c***

c!!!!!!!	   call vic_portone()
c	   call z_feed()
c	   call r_feed()
	end if

c	if(i_tpl.eq.1)then
c	   call r_feed()
c	end if

!!!	if(ntay.gt.next)call gen()

c*** Setting currents mode !!!!! ***
c	if(kpr.eq.1)print*,pf0(5),ntay
c	vchopper(5)=1000.*pf0(5)*1.e3
c	if(ntay.gt.next)vchopper(5)=1000.*pf_p(5)*1.e3
c	if(kpr.eq.1)print*,'vchopper(5)=',vchopper(5)
c	if(kpr.eq.1)print*,'pf0(5) pf_p(5)',pf0(5),pf_p(5)
ccc	read(*,*)
c***********************************

	if(tt.ge.70.e6)then
	   do i=1,npf
	      vchopper(i)=0.
	      end do
        end if

      call shape_pfres()
	call gen()
!	call ful()

c	if(kpr.eq.1)print*,'!!!!!!!!!tt=',tt
c	if(kpr.eq.1)print*,(pf(i),i=1,npf)
c	read(*,*)

c        call loopflux()                                                       

c        call probefield()

c	call pfves_d3d()
c	call pfves()

c###	if(ntay.gt.next)call gen()

c	call d3d_corr_pf()

c	call d3d_corr()


c----------------

!	eps2=eps2*2.

	zvel=(zmag-zmag0)/tay	

      if(tt.ge.60.7e9)then
      i_zvel=1
      end if
      

	if(dabs(zvel).gt.zv_max.and.i_zvel.eq.0)then
!	if(ntay.gt.0)then
!      kzref=3

      i_zvel=1
      
      kzref=1
      krref=2
      if(zvel.gt.0)then
      zref=zmag0+zv_max*tay
!      zref=zmag0
      else
      zref=zmag0-zv_max*tay      
!      zref=zmag0      
      end if
      
      rref=0.5*(rmag+rmag0)
!      rref=rmag0
      
      if(kpr.eq.1)print *,' ++zref zmag0 zvel',zref,zmag0,zvel
      if(kpr.eq.1)print *,' ++rref rmag0 rvel',rref,rmag0,rvel
      
	else
!      kzref=0	
!      krref=0	
	end if

	
	if(int_2005.gt.10)eps2=eps2*1.5


      if(int_2005.gt.50)go to 6666

	if(it1.ne.0)go to 2005
	
	tpl_equ=tpl

c----------------
	delzmag=zmag-zmag_in
	delrmag=rmag-rmag_in

	zvel=(zmag-zmag0)/tay	
	
	zvel_tran=zvel

c	zcur=z_cur

c	call z_cur_filter(zcur)

c	if(kpr.eq.1)print *,' zcur z_cur=',zcur,z_cur

c	z_cur=0.5*(z_cur+z_cur0)

c	zvel=(z_cur-z_cur0)/tay

	rvel=(rmag-rmag0)/tay
	if(kpr.eq.1)
     *	print *,' delzmag delrmag rvel',delzmag,delrmag,rvel

	d_zvel=abs(zvel-zvel_0)/(abs(zvel)+1.e-4)
	if(kpr.eq.1)
     *	print *,' ZVEL d_zvel INT_2000',zvel,d_zvel,int_2000

	print *,' int_2005 eps2 int_2000 ',int_2005,eps2,int_2000

	if(kpr.eq.1)print *,' delzmag delrmag',delzmag,delrmag
        if(kpr.eq.1)print*,'zmag zref zmag0 zvel',zmag,zref,zmag0,zvel
        if(kpr.eq.1)print*,'rmag rref rmag0 rvel',rmag,rref,rmag0,rvel
c        if(ntay.gt.next)pause 'from main'


 6666   continue


!      kzref=0
!      krref=0


      call ppx_pffx_save(1)

	if(abs(zvel-zvel_0).gt.(0.05*abs(zvel)+1.e-3).and.int_2000.lt.11)then
	it1=1
	end if

	if(ntay.lt.-1)then
	call polar_data()
        CALL POLAR1(n,mp,rs0,kp,pt0z)
	call polar_res()
	CALL BTA(n,mp,RS0)

c  toroidal coordinates...
	call transf_data()
	end if



	if(i_map.eq.1)then


	call map_ps()

ccc      call li_calc()


  	do j=1,mp
	   uk_help(j)=uk(j)
	   vk_help(j)=vk(j)
	end do
	um_help=um
	vm_help=vm
	
	
!	c*** If i_avr=1 >>>>> plasma boundary averaging
!	i_avr=0
	if(i_avr.eq.1)then

	 do j=1,mp
	   uk(j)=uk_help1(j)+( uk_help2(j)-uk_help1(j) )*
     *  float(k_svd)/float(n_svd)

	   vk(j)=vk_help1(j)+( vk_help2(j)-vk_help1(j) )*
     *  float(k_svd)/float(n_svd)
     
       end do

	   um=um_help1+( um_help2-um_help1 )*
     *  float(k_svd)/float(n_svd)

	   vm=vm_help1+( vm_help2-vm_help1 )*
     *  float(k_svd)/float(n_svd)

	end if

c!!! If call ro_tran() the tansport is doing p' & ff' to the initial surfaces
c!!! so transport does not know about time evolution of surfaces 
	
!      call ro_tran()
	call transf_b_tor()

!!!	call tab_w()

	end if

 2001	continue

	if(krref.eq.3)call transf_b_tor()

	if(i_map.eq.0)then

	if(ntay.ge.-1)then

	if(i_old.eq.1)then
	call ptoke_res()
	call polar_tor()
	call tor_data()
	else

	call polar_data_tor()
      call transf_b_tor()

	end if

	end if

	CALL BTA(n,mp,RS0)

	end if
 
	dmo=dm0(n)

	tpl_it=tpl

	next_help=next
	
	if(krref.eq.3)then
	   next=ntay+1
	   end if

      if(k_ener.eq.0)call prof_astra_bs()
!      if(k_ener.eq.0)call prof_astra_bs_hl()


	if(tt.ge.59.0e9)then
        fdd0=fdd
        end if

      if(ntay.le.9.and.k_ener.eq.0)then
      pll0=pll
      fdd0=fdd
      
            if(kpr.eq.1)print *,' pll pll0=',pll,pll0

      end if
      
	call tpl_cal()
      tpl_o=tpl

      i_filter=0
      tau_p=5.*tay
      if(kpr.eq.1)print *,' tay tau_p=',tay,tau_p
!      if(i_filter.eq.1)call fdd_filter()
      if(kpr.eq.1)print *,' tpl_o tpl=',tpl_o,tpl

	next=next_help

c!	call tpl_calc()

	call pp_calc()
	call pff_calc()

	call z_cur_calc()
	zvel_tran=(z_cur-z_cur0)/tay


	errd=2.*abs(dmo-dm0(n))/( abs(dmo)+abs(dm0(n)) )
	int_dif=int_dif+1


c	call v_ec()

	err_tpl=2.*abs(tpl-tpl_it)/( abs(tpl)+abs(tpl_it) )

	if(kpr.eq.1)print *,' -it1 errdifmf- err_tpl int_2000',
     *  it1,errd,err_tpl,int_2000

c**vic************
        if(int_2000.gt.50)go to 5555
c************

!	if(errd.gt.1.e-3.and.int_dif.lt.4) it1=1
!	if(err_tpl.gt.1.e-3) it1=1

	CALL BTA(n,mp,RS0)



	int_dif=0

ccc      call ppx_pffx_save(2)

	if(it1.ne.0.and.int_2000.lt.10)go to 2000

!        call write_equil()
      
      if(tt.ge.time_eq-0.5d0*tay.and.tt.lt.time_eq+0.5d0*tay)then
      	
      	tpl=tpl_equ
        call write_equil()
!        stop
      end if

      
      goto 63

            kz_help=kzref
           kr_help=krref

     ! goto 33
           
            eps2=eps20

           	rref=rmag
           	zref=zmag

           	kzref=1
           	krref=4

      niter=0            
21	continue          

	niter=niter+1                                                          
                                                                       
	call ptoke1()                                                          
                                                                        
	if(kpr.eq.1)print *,' --um vm--niter it1',
     *  um,vm,niter,it1           
                                                                        
	if(it1.ne.0.and.niter.lt.20)go to 21      

      if(tt.ge.time_eq-0.5d0*tay.and.tt.lt.time_eq+0.5d0*tay)then
           call write_equil()
      end if


33	continue       
!        if(i_en2.eq.22)then
        if(ntay.eq.-2000)then
      
        kpr=1
 
           	kzref=0
           	krref=0
   	     call ptoke1()       

        	call read_data() 


            call read_equil()

            brad=0.d0
            bvert=0.d0

   	       call ptoke0()       

           	kzref=1
           	krref=1

           	rref=rmag
           	zref=zmag
      niter=0            
31	continue          

	niter=niter+1                                                          
                                                                       
	call ptoke1()                                                          
                                                                        
	if(kpr.eq.1)print *,' --um vm--niter it1',
     *  um,vm,niter,it1           
                                                                        
	if(it1.ne.0.and.niter.lt.20)go to 31      

         eps2=1.d-6
         call stab(ich,i_graph)
         call write_surf()
         stop


      end if

         kzref=kz_help
         krref=kr_help 
         
 63	continue       

!	call wr_tabppf()
!        call wr_pf()
!        call wr_tcam()
!      call wr_rpp()
!      call wr_zpp()

!      call wr_equil()

	zvel=zvel_tran

 5555   continue

      

	CALL BTA(n,mp,RS0)

	do i=1,npf
	   pfhelp(i)=pf(i)
	end do

c-----------------------------
c   vessel cuurents taken after convergance of equilibrium---

c----------------------------
	if(k_ener.eq.1)then

      if(kcchp.eq.1)then      

!      call vic_prof_chg2()

	if(tt.gt.tt_h-500.)then
	   call vic_prof_chg()
	end if

	if(tt.gt.tt_h_to_l-500.)then
	   call vic_prof_chg1()
	end if

      end if
	
       call gamma_z1_read()
       call gamma_z2_read()
       call gamma_z3_read()
       call gamma_z4_read()

!	 call dens_prog()
	call dens_prog_dt()
         if(k_dens_ext.eq.1.and.k_ener.eq.1)call dens_corr()

       end if
      

c
      	VMAX=1.E5
      	DO I=1,n
    	VN(I)=VI(I)/VMAX
	end do
	if(kpr.eq.1)
     *	print *,' -----k_ener t_dop-- q(2)',k_ener,t_dop,q(2)

c*** Here we are doing te0(n)=tq0(n)=g_edge*tec !!!
      if(kcchp.eq.1)then      
        call vic_t_edge()
      end if
      

	if(k_ener.eq.1)then
      if(kcchp.eq.0)then      
       call srs_feed()
       call solpszb()
!       call solpsz()
      end if
	CALL ENERGY(N)
	if(k_ajb_ext.eq.1)CALL ajb_corr()
	if(k_ener_ext.eq.1)CALL ENERGY_corr()
      if(k_dens_ext.eq.1)call dens_corr()
	end if
	
	print *,' k_ener k_ener_ext',k_ener,k_ener_ext,k_dens_ext
	

	if(k_ener.ne.1)call enit(n)
      if(k_ener.eq.0)call prof_astra()
!      if(k_ener.eq.0)call prof_astra_hl()

c	if(q(2).le.0.7)call zyb(n,ires)
c	if(q(2).le.0.8)call zyb(n,ires)

c**********************************************
ccc	q_test=0.90
c	q_test=0.96
        if(kpr.eq.1)print *,' q_test=',q_test

        if(q_test.le.0.1)then
	q_test=0.97
        end if
cccccccc	q_test=0.8
c	q_test=0.7
c	q_test=0.98
	i_min=0
	q_min=q(2)

c-----------------------

	do i=3,n
	   if(q(i).le.q_min)then
	      i_min=i
	      q_min=q(i)
	      if(kpr.eq.1)print *,' i i_min q(i) q_min',i,i_min,q(i),q_min
	   end if
	end do

	if(kpr.eq.1)print *,' q(2)*** q_test',q(2),q_test
	if(kpr.eq.1)print *,' k_zyb==',k_zyb

	i_oldd=1

	k_zyb=0

	if(i_oldd.eq.1.and.ntay.gt.10)then
	if(q_min.le.q_test)then
	if(kpr.eq.1)print *,' q_min==== q_test ntay',q_min,q_test,ntay
	if(kpr.eq.1)print *,' call zyb'
	      if(kpr.eq.1)print*,(q(ii),ii=1,n)
c	   call zyb(n,ires,q_test)

	   call zyb(n,ires)
		k_zyb=1

c	      if(kpr.eq.1)print*,(q(ii),ii=1,n)
c	      read(*,*)
      if(k_ener.eq.1)then
	if(k_ener_ext.eq.1)CALL ENERGY_corr()
      if(k_dens_ext.eq.1)call dens_corr()
      end if

      if(k_ener.eq.0)call prof_astra()
      
	   call pp_calc()
	   call pff_calc()

	end if
	end if
c**********************************************
      k_zyb=0



ccc	if(q(2).le.0.9.and.ntay.gt.next+10)call zyb(n,ires)
ccc	if(q(2).le.0.92.and.ntay.gt.next+10)call zyb(n,ires)

c*** H-mode switching in case of Coppi-Tang model ***
        key_lh=0

cccccc        tt_h=80100.
c        tt_h=70100.
c        tt_h=50100.
cccccccc        tt_h_to_l=600000.
	if(kpr.eq.1)print*,'!!!tt key_h_to_l tt_h_to_l ntay',
     *  tt,key_h_to_l,tt_h_to_l,ntay 

	if(key_h_to_l.eq.1)tt_h_to_l=tt
c
        if(tt.gt.tt_h)key_lh=1
        if(key_h_to_l.eq.1)key_lh=0

	if(kpr.eq.1)print*,'!!!tt tt_h tt_h_to_l',tt,tt_h,tt_h_to_l
	if(kpr.eq.1)print*,'!!!key_h_to_l key_lh',key_h_to_l,key_lh
c****************************************************
	
      
	if(ntay.eq.next)then
      call shape_pfres()
	call gen()
      end if
      
c****** PF current limits checking ***********
!        call vic_pf_limits()
c*********************************************

c###	if(ntay.eq.next)call gen()

c@@@	call pf_volt()

c!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
c!!!!! Save PF to PF_original_order !!!!!!!!!!!!!!!!!!
c!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
c!!!!! Transfer PF to PF_DINA_order !!!!!!!!!!!!!!!!!!
c!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
c!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
c!!!!! Save VCHOPPER to VCHOPPER_original_order !!!!!!!!!!!!!!!!!!
c!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
c!!!!! Transfer VCHOPPER to VCHOPPER_DINA_order !!!!!!!!!!!!!!!!!!
c!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
c**** pfc_new.dat and volt_new.dat files writing ***
!           call wr_tok_new()
!           call wr_volt_new()

	call v_sec()

	call q_calc()

	call DOPP()
c	do i=1,npf
c	   if(kpr.eq.1)print*,pf0(i),pf(i)
c	end do
c	if(kpr.eq.1)print*,'from main 333 tt',tt
c	read(*,*)
c!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
c!!!!! Transfer PF_DINA_order to PF_original_order !!!!!!!!!!!!!!!!!!
c!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
c!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
c!!!!! Transfer VCHOPPER_DINA_order to VCHOPPER_original_order !!!!!!
c!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
c*** Here we are doing te0(n)=tq0(n)=g_edge*tec !!!
cccccc        call vic_t_edge()

c  	call shape_f9a() 
c	call filter()

	call time_gen()

c	if(i_fil.ge.1)then
c 	 zvel_tok=(z_tok-z_tok0)/tay
c       if(kpr.eq.1)print*,'r_tok z_tok',r_tok,z_tok
c       if(kpr.eq.1)print*,'r_tok0 z_tok0',r_tok0,z_tok0
c      if(kpr.eq.1)print*,'zvel zvel_tok',zvel,zvel_tok

c	end if


	call time_step()

ccc      call ppx_pffx_save(2)
	call time_st_ppx_pffx()

c*vic Writing of kavin.dat file
c!!!        call wr_kavin() 

	if(kpr.eq.1)print *,' END time step==='

	call time_out()

      ttt_stop=15.5e8
	if(kpr.eq.1)print *,' ttt_stop  tt',ttt_stop,tt

      if(tt.ge.ttt_stop)then
      print *,' tt GT ttt_stop',tt,ttt_stop
      stop
      end if

c	if(tt.lt.t_end)go to 2323
c	stop
	cIp_min=dabs(cIp_end)*1.e3


      
!!!	if(tt.lt.100.e3.or.tpl.gt.tpl_end)go to 2323
!!!	if(tt.lt.100.e3.or.tpl.gt.tpl_end)then
!	if(tt.lt.5.67e5.and.tpl.gt.tpl_end)then
	if(ntay.lt.5000.or.tpl.gt.cIp_min)return

!!!	go to 2323
      
!      kpr=1
      
	t_end2=tt
	
!	t_vde=t_end+250.e3

!      if(kpr.eq.1)print*,'t_vde t_end',t_vde,t_end

!      dt_end=dtpl_term_l*cIp_end/7.5*1e3;
!      dt_end=dtpl_term_l*cIp_end/15.*1e3;
      dt_end=dtpl_term_l*cIp_end/tpl_flat*1.e6

      if(kpr.eq.1)print*,'dt_end',dt_end
	
      t_tpl_down=dt_end

	if(t_tpl_down.gt.1.e-10)then
	   d_tpl=tpl/t_tpl_down
	else
	   d_tpl=1.e6
	end if


      if(kpr.eq.1)print*,'t_tpl_down d_tpl',t_tpl_down,d_tpl

	i_3323=1

c      tpl=1.d-10
      
c      tpl0=1.d-10
	

	if(kpr.eq.1)print*,'before 3323'
	if(kpr.eq.1)print*,'tt tpl t_end2 t_vde',tt,tpl,t_end2,t_vde
	return

3323	continue



!	ntay=ntay+1

!	tt=tt+tay
	
      call curr_calc(tpl)

	if(kpr.eq.1)print*,'ntay tt tpl',ntay,tt,tpl

	tpl=tpl-d_tpl*tay

      cIp_hl=tpl/1e3

      if(tpl.lt.1.d-8)then
      tpl=1.d-8
      d_tpl=0.d0
      end if
	
!	if(tpl.le.1.d0)tpl=1.d0

	a_print(1)=tt
	a_print(2)=d_tpl
	a_print(3)=tpl
	a_print(4)=tay

	n_pr=4
	apr=' tt d_tpl tpl tay '
	num=30
	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)


c*** To read Ip and PF_p preprogrammed waveforms (in DINA order)
c*** from scr_data file 
c      call vic_shape_ip_iam()
	   
c        call r_volt()

c        call vic_gaps0_read()
c	call SCEN_CONTROL(key_h_to_l)

	  call loopflux()
                                                      
        call probefield()

        call shape_pfres()
        call gen()

c        call gen_pf()

!      	call ful()

c****** PF current limits checking ***********
c        call vic_pf_limits()
c*********************************************
c!!!!! Transfer VCHOPPER to VCHOPPER_DINA_order !!!!!!!!!!!!!!!!!!
c!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
c**** pfc_new.dat and volt_new.dat files writing ***
!           call wr_tok_new()
!           call wr_volt_new()

	call v_sec()

	call DOPP_2()

	call time_gen()

	call time_step()

	call time_out()

c	if(tt.lt.t_vde)go to 3323
!	if(tt.lt.t_vde)then


71	FORMAT(5X,A10/,(2x,6(1PE11.3)))
	return
	end
	subroutine read_data2()
	include 'double.inc'
	include 'new_com.inc'


	call read_data2_c(
     *  res_coef,n_polar,
     *  k_ion)

	return
	end
	subroutine read_data2_c(
     *  res_coef,n_polar,
     *  k_ion)

	include 'double.inc'
        include 'parf0'
	include 'parf2'
	common
     *  /cont13/zmag,zvel,delrmag,delzmag
     *  /cont13e/zmag0,rmag,rmag0,rvel
	common
     *	/n_m/n,m,mp
	common
     *  /eq12/omega,pspl0(nwnh)
	common
     *	/ge1e/rs0,tpl
     *  /ge2/NTAY,TAY,TT
     *  /ge2e/t_end
     *  /ge4/EPS1,EPS2,EPS0
     *  /ge5/kpr
     *  /ge6e/zeff_a,zeff_b
     *	/ge7/eu,rs,zout,eksk
	common
     *  /DFM1/UDM,ZDM,L3,SIG0
     *  /dfm7/bt0,uind
	common
     *	/efit0/kefit
     *	/efit1/alfax(2),betax(2)
     *	/efit2/alfa0,beta,alfa1
     *	/efit3/pw_1,pw_2
	common
     *  /pol5/psend
	common
     *  /en1e/te_a,ti_a,te_b,ti_b,pw_e
     *  /en2e/pd0_a,pt0_a,pd0_b,pt0_b,pw_p
     *  /en7/UD,ZD,UT,ZT,UH,ZH,LD,LT,LH,ID,IT,IH,KTP,Neng
     *  /en11/un(4),zn(2),ll,ken,ken1,ken2,noit
     *  /en12/pnal(npo),pnaln(npo),zalfa,talfa
     *  /en13/KPIN,VPIN,ALP1,POT,SKOR
     *  /en14/EMOE,EMOQ,NDOP,QDE0(npo),QDQ0(npo)
     *  /en14e/t_dop
     *  /eq15e/pll0,tpl0,udd
     *  /en19/DD,DT,DH,SIN0,SINK,ALPY,Sss,Ppp,Eee
     *  /en33/anom_e,anom_i,key_t11,kcchp
     *  /en25/zhib,tego

	common
     *	/keys1/i_graph
     *	/keys2/key_b
     *	/keys3/kzero,iread,iwrite
     *  /keys4/k_ener,k_uv
     *  /keys5/next
     *  /keys7/i_c
     *  /keys8/ndh
     *  /keys9/i_d3d,i_iter,i_smal
     *  /keys10/ngra
     *  /keys11/i_ramp
     *  /keys12/i_v
     *  /keys13/i_con,i_act
     *  /keys14/i_beta,i_gap5
     *  /keys15/i_br
     *  /keys17/i_feed,i_ecoil
	common
     *	/con1/gain,ta,zref,kzref
     *  /con2/rref,krref,bvert
     *  /con3/i_pf
     *  /con5/n_exp,k_cont
     *  /con6/ind_r(2),ind_z(2)
	common
     *	/point1/r0,z0
	common
     *  /halo1/c_h,d_halo,fmax_in,tpl_in
     *  /halo2/kmaj,k_q,k_d,kaxis,ndisrup
     *  /halo2e/next0,li_drop,n_li,n_dif,nmix
     *  /halo3/tay_00,tay_th,t_disr,d_tpl,tpl_end
     *  /halo4e/w_h0,delaval0,pshalo0,te_h0
     *  /halo5/q_vde,q_95,del_f,i_halo
     *  /halo12/te_h
     *  /halo14/hpart
     *  /halo15/e_sep,nsep
	common
     *  /pol4/UM,VM,UK(ntet),VK(ntet)
	common
     *	/cont18/t_vde,time_disr
	common
     *  /ef_0/key_ef

     	open(unit=2,file='for002',form='formatted')
        if(kpr.eq.1)print *,' begin for002 reading'

	read (2,*)
	read (2,*)n,m,next
	read (2,*)
	read (2,*)tt,tay,t_end,rs0,psend
	read (2,*)
	read (2,*)i_graph
	read (2,*)
	read (2,*)alfa0,beta,alfa1,omega
	read (2,*)
	read (2,*)iread,kzero,iwrite,kefit
	read (2,*)
	read (2,*)alfax,betax
	read (2,*)
	read (2,*)pw_1,pw_2
	read (2,*)
	read (2,*)te_a,ti_a,te_b,ti_b,pw_e
	read (2,*)
	read (2,*)pd0_a,pt0_a,pd0_b,pt0_b,pw_p
	read (2,*)
	read (2,*)zeff_a,zeff_b
	read (2,*)
	read (2,*)sig0
	read (2,*)
	read (2,*)zhib,tego,zalfa,talfa,alp1
	read (2,*)
	read(2,*)ktp,kpin,ken,ken1,ken2,kd2,nal
	read (2,*)
	read(2,*)edop,ppp,eee,dd,dt,dh,df
	read (2,*)
	read(2,*)lt,ld,lh,ll,lm,it,id,ih
	read (2,*)
	read(2,*)eps0,eps1,eps2
	read (2,*)
	read (2,*)anom_e,anom_i,key_t11,kcchp
	read (2,*)
	read (2,*)emoe,emoq
	read (2,*)
	read (2,*)udd
	read (2,*)
	read (2,*)k_ener,k_uv
	read (2,*)
	read (2,*)t_dop
	read (2,*)
	read (2,*)r0,z0,zref
	read (2,*)
	read (2,*)kzref,krref,key_b,i_pf
	read (2,*)
	read (2,*)i_c
	read (2,*)
	read (2,*)q_vde
	read (2,*)
	read (2,*)tay_00,tay_th,t_disr
	read (2,*)
	read (2,*)d_tpl,tpl_end
	read (2,*)
	read (2,*)c_h,d_halo
	read (2,*)
	read (2,*)kmaj,li_drop,ndisrup,n_dif,nmix
	read (2,*)
	read (2,*)hpart,te_h
	read (2,*)
	read (2,*)i_d3d,i_iter,i_smal
	read (2,*)
	read (2,*)ngra,i_ramp,i_v,i_con
	read (2,*)
	read (2,*)tpl,bt0,eu,eksk
	read (2,*)
	read (2,*)e_sep
	read (2,*)
	read (2,*)i_beta,i_gap5
	read (2,*)
	read (2,*)i_br
	read (2,*)
	read (2,*)ind_r,ind_z
	read (2,*)
	read (2,*)key_ef
	read (2,*)
	read (2,*)res_coef
	read (2,*)
	read (2,*)n_polar
c	read (2,*)
c        read (2,*)k_ion,pow_el,pow_ion


	if(kpr.eq.1)then
	   print *,' key_ef ===',key_ef
	   print *,' res_coef===',res_coef
	   print *,' n_polar===',n_polar
	   print *,' k_ion===',k_ion
	   print *,' pow_el pow_ion===',pow_el,pow_ion
	   print*,'tt=',tt

	   print *,' end for002 reading'
	end if


	call edim1

        if(kpr.eq.1)print *,' CALL ELKE...'
c        read (*,*)

	pnor=6.25e8
	emoe=emoe*pnor
	emoq=emoq*pnor

	ndh=1


	close(2)

c##	mp=(m-2)/2+2
	mp=m
	if(kpr.eq.1)print *,' n m mp',n,m,mp
c	read (*,*)


        rs=r0
        zout=z0
	um=r0
	vm=z0
	rmag=um
	zmag=vm

	if(kpr.eq.1)print *,' um vm eu elong',um,vm,eu,eksk

        if(kmaj.eq.1)then

     	open(unit=2,file='halo',form='formatted')
        if(kpr.eq.1)print *,' begin halo reading'

	read (2,*)
	read (2,*)w_h0,te_h0
        if(kpr.eq.1)print *,' w_h0  te_h0==',w_h0,te_h0
	close(2)

        end if


     	open(unit=2,file='time',form='formatted')
        if(kpr.eq.1)print *,' begin time reading'

	read (2,*)
	read (2,*)t_vde,time_disr
        if(kpr.eq.1)print *,' t_vde time_disr',t_vde,time_disr

	close(2)

	return
	end

c
	subroutine curr_calc(tpl)
	include 'double.inc'
      include 'parf2'

	common
     *  /ge1/pi
     *  /ge5/kpr
     *	/fluxc7/coef,coef1,api
	common
     *	/v_jp/f(nwnh)
	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nn),y(MM),dx,dy

	COEF=10./(4.*PI)
	api=1./(2.*pi)

      TOk=0.d0
      do kk=1,nwnh
	f00=F(kk)
	TOK=TOK+f00
      end do
	TOK=TOK*COEF*dx*dy

	if(kpr.eq.1)print *,'coef ',tpl,COEF*dx*dy
	al1=tpl/tok
C
	if(kpr.eq.1)print *,'tpl tok ',tpl,tok
      
c
	coef1=al1*dx*dy*coef
c-------
c  calc. flux from plasma to vessel,PF loops and probes...
	call pl_out(f)

      do kk=1,nwnh
	F(kk)=F(kk)*al1
      end do


	return
	end

	subroutine ENERGY_corr()
        include 'double.inc'
	include 'new_com.inc'

	call ENERGY_corr_c(
     *  n,te0,tq0,te0_tran,tq0_tran)


	return
	end

	subroutine ENERGY_corr_c(
     *  n,te0,tq0,te0_tran,tq0_tran)
        include 'double.inc'

      dimension te0(*),tq0(*),te0_tran(*),tq0_tran(*)
      
      print *,' FROM ENERGY_corr='      
      
	do i=1,n
      TE0(I)=TE0_tran(I)
	Tq0(I)=TQ0_tran(I)
      end do

	return
	end

	subroutine dens_corr()
        include 'double.inc'
	include 'new_com.inc'

	call dens_corr_c(
     *  n,pd0,pt0,pne,pd0_tran,pt0_tran,pne_tran)


	return
	end

	subroutine dens_corr_c(
     *  n,pd0,pt0,pne,pd0_tran,pt0_tran,pne_tran)
        include 'double.inc'

      dimension pd0(*),pt0(*),pne(*),pd0_tran(*),pt0_tran(*),pne_tran(*)
      
      print *,' FROM dens_corr='      
      
	do i=1,n
      pd0(I)=pd0_tran(I)
	pt0(I)=pt0_tran(I)
	pne(I)=pne_tran(I)
      end do

	return
	end
                                                                        

	subroutine ajb_corr()
        include 'double.inc'
	include 'new_com.inc'

	call ajb_corr_c(
     *  n,ajb,sigk,ajb_tran,sigk_tran)


	return
	end

	subroutine ajb_corr_c(
     *  n,ajb,sigk,ajb_tran,sigk_tran)
        include 'double.inc'

      dimension ajb(*),sigk(*),ajb_tran(*),sigk_tran(*)
      
      print *,' FROM ajb_corr='      
      
	do i=1,n
      ajb(I)=ajb_tran(I)
	sigk(I)=sigk_tran(I)
      end do

	return
	end


                                                                        

