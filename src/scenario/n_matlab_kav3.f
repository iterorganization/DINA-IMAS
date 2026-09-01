!> equil3 is a subroutine to produce the plasma equilibria for restart

	subroutine equil3()

	include 'double.inc'
	include 'new_com.inc'

	call equil3_c(
     *  ncam,tcam,tcam0,pf,npf,nps,rps,zps,rout,bt0,pll,	
     *  rref_p,q,tay_simul,int_2000,int_2005,
     *       z_cur,z_cur0,r_cur,tt_1,tt_2,i_wr,
     *       ksepa,ksepa_0,gaps0,i_bound,
     &       r_tok,z_tok,r_tok0,z_tok0,zvel_tok,
     *       del_ramp,omega,
     *       ro_bar,alf_bar,vchopper,pf0,pf_p,key_lh,key_h_to_l,
     *       tt_dw,tt_h,betp_flat,coef_kessel_1,vs_start,tt_emo,omg_ppx,
     *       fdd,fdd0,tau_p,xu,yu,xu_dist,yu_dist,ke,r_lh_new,pf_turns,
     *       ha)

	return
	end


	subroutine equil3_c(
     *  ncam,tcam,tcam0,pf,npf,nps,rps,zps,rout,bt0,pll,
     *  rref_p,q,tay_simul,int_2000,int_2005,
     *       z_cur,z_cur0,r_cur,tt_1,tt_2,i_wr,
     *       ksepa,ksepa_0,gaps0,i_bound,
     &       r_tok,z_tok,r_tok0,z_tok0,zvel_tok,
     *       del_ramp,omega,
     *       ro_bar,alf_bar,vchopper,pf0,pf_p,key_lh,key_h_to_l,
     *       tt_dw,tt_h,betp_flat,coef_kessel_1,vs_start,tt_emo,omg_ppx,
     *       fdd,fdd0,tau_p,xu,yu,xu_dist,yu_dist,ke,r_lh_new,pf_turns,
     *       ha)

	include 'double.inc'
	include 'parf0'
	include 'parf1'

	dimension pf(*),q(*),gaps0(*),vchopper(*),pf0(*),pf_p(*)
	dimension xu(*),yu(*),xu_dist(*),yu_dist(*),pf_turns(*),ha(*)

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
      
      if(kp.eq.1)print *,'k_ener_ext=',k_ener_ext
      

      	if(i_en2.eq.-1)then	
        open (unit=1,file='kpr.dat',form='formatted')
        read (1,*)
        read (1,*)kpr
        
!              i_con=3

        close ( unit=1)       
	end if

      if(i_en.gt.1)goto 2323
      
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

	r0=rs0
	z0=0

!      r0=588.

	rref=r0
	zref=z0

	um=r0
	vm=z0


 !     call prof_dm0()
      
      if(k_ener.eq.0)call prof_astra()

!	if(k_ener.ne.1)call enit(n)

!      if(k_ener.eq.0)call prof_astra_hl()
!	call pp_calc()

       call gamma_z_read()
       call gamma_z1_read()
       call gamma_z2_read()
       call gamma_z3_read()
       call gamma_z4_read()



c*** Input of PF turns - must be consistent with 'koor' file!
        call vic_turn()

        call bound_psgrid()

 !     stop

      call plas_circ()

      call bound_pf_calc()
!      stop for testing separate parts of inverse solving
      stop


	call ptoke0()


		call ptoke1()

         eps2=1.d-6
         call stab(ich,i_graph)
         call write_surf()

           apr='-dmn-'
           if(kpr.eq.1)print 71,apr,(dmn(i),i=n-5,n)

	  call v_sec()
!      call dm0_calc()

 !        stop
	call map_ps()

	call map_tor()
	call eq_res_ps()
      
      do i=1,n
      dm0(i)=dmn(i)
      end do
      
      do i=2,n
      psi(i)=(dm0(i)-dm0(i-1))/ha(i)
      end do
      psi(1)=psi(2)

           apr='-psi-'
           if(kpr.eq.1)print 71,apr,(psi(i),i=n-5,n)
           apr='-dm0-'
           if(kpr.eq.1)print 71,apr,(dm0(i),i=n-5,n)

	call transf_b_tor()
      CALL BTA(n,mp,RS0)


	call pp_calc()
	call pff_calc()

 !     return

!!!	call ptoke_res()

c-----------------
      i_1=0
      if(i_1.eq.1)then

	call ppx_pffx()
	call ppx_pffx_corr2

	call ppx_pffx_tab()         
      
      end if
      

	                                                       
      call shape_pfres()
	if(i_gen.eq.0)call inv_gen()
	if(i_gen.eq.1)call inv_gen_pf()
      
      call gen()
	
	call time_step()
	call time_gen()

      kzref=0
      krref=0

c!!!	CALL BTA(n,mp,RS0)
!	call DOPP()

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
       
         return
      


2323	continue

c*** !!!!! *** FROM KAVIN ******
	      tt_avr=tt_rampup+1100.

c*******************************

      if(i_3323.eq.1)goto 3323

        cs1_help=pf(3)/pf_turns(3)
        
        print *,' cs1_help CS1_eob dt_contr_hl=',
     *  cs1_help,CS1_eob,dt_contr_hl
      
        if(pf(3)/pf_turns(3).lt.CS1_eob .and. k_CS1.eq.0 
     *     .and. tt.gt.dt_contr_hl*1e3) then
        k_CS1=1
        tt_eob=tt-1.e-3
        tt_dw=tt_eob
        end if
        

 5002   format (150(1pe12.4))
c============================================================

	if(tt.gt.30.e3)zv_max=zv_max_help

c****************
        eps20=eps20_mem

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


	int_dif=0

	int_2000=0

	i_sh=0

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
	if(kpr.eq.1)print *,' END write_surf '
	end if


      if(k_ener.eq.0)call prof_astra()


2000	continue
	int_2000=int_2000+1

!      if(int_2000.le.2)then
!      call shape_pfres()
!	call gen()
!      end if

c
	if(k_zyb.eq.0)then

      ngra2=1
	if(ntay.eq.ngra2*(ntay/ngra2).and.ntay.gt.20)then

      omg_ppx=omg_ppx*0.99
      if(omg_ppx.le.0.5d0)omg_ppx=0.5d0
 
!      omg_ppx=0.d0
     
      if(tt.lt.-56930e9)then
	   call ppx_pffx()
ccc	   call avr_ppx_pffx2()
	   
!         call ppx_pffx_corr2()

ccc         call ppx_pffx_corr4()

      end if

	   else
!	   omg_ppx=1.d0
	end if

	   if(krref.eq.0.and.tt.gt.tt_avr)then 
	      call ppx_pffx_corr2()
	   end if
	   	      
	end if

	zvel_0=zvel

	eps2=eps20
	int_2005=0



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

	if(ntay.gt.next)then
	brad=0.
	bvert=0.
	end if

	call gen()

	zvel=(zmag-zmag0)/tay	

	
	if(int_2005.gt.10)eps2=eps2*1.5


      if(int_2005.gt.50)go to 6666

	if(it1.ne.0)go to 2005

c----------------
	delzmag=zmag-zmag_in
	delrmag=rmag-rmag_in

	zvel=(zmag-zmag0)/tay	
	
	zvel_tran=zvel

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


 6666   continue


      call ppx_pffx_save(1)

	if(abs(zvel-zvel_0).gt.(0.05*abs(zvel)+1.e-3).and.int_2000.lt.11)then
	it1=1
	end if

	if(i_map.eq.1)then
	call map_ps()
	call transf_b_tor()
	end if

 2001	continue


	CALL BTA(n,mp,RS0)

 
	dmo=dm0(n)

	tpl_it=tpl

	next_help=next

      if(k_ener.eq.0)call prof_astra_bs()

 !     if(i_filter.eq.1)call fdd_filter()

	call tpl_cal()
	next=next_help

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

	CALL BTA(n,mp,RS0)



	int_dif=0

ccc      call ppx_pffx_save(2)

	if(it1.ne.0.and.int_2000.lt.10)go to 2000
      

	zvel=zvel_tran

 5555   continue

	CALL BTA(n,mp,RS0)

	do i=1,npf
	   pfhelp(i)=pf(i)
	end do

	if(k_ener.ne.1)call enit(n)
	
	if(kpr.eq.1)print *,' call prof_astra k_ener==',k_ener
	
      if(k_ener.eq.0)call prof_astra()

	q_test=0.97
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

      if(k_ener.eq.0)call prof_astra()
      
	   call pp_calc()
	   call pff_calc()

	end if
	end if
c**********************************************
      k_zyb=0

	call v_sec()

	call q_calc()



	call DOPP()

	call time_gen()

	call time_step()

ccc      call ppx_pffx_save(2)
	call time_st_ppx_pffx()


	if(kpr.eq.1)print *,' END time step==='

	call time_out()

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
