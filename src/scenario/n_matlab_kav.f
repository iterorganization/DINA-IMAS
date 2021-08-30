                                                                        
	subroutine equil()                                                     
      include 'double.inc'

	include 'new_com.inc'                                                  
                                                                        
	call equil_c(                                                          

     *  k_help,dfmax,dfmax0,bt0,beta,brad,

     *  xbound,ybound,errm,i_en2,key_eq,power_ech,q,
     *  i_ech,q_test,omg_ppx,key_ext,int_2000,it_ext,tokc,i_en3,k_efit,
     *  te0,eps_vel,key_equil,vchopper,pf,i_gen,ajb,betj,i_new,key_ne,
     *  tpl0,i_pres,i_bound,fdd,fdd0,pll,i_exit,n_pas,npf,pfres,tt1,
     *  a,ha,elong,k_dm0,tcam,ncam,udd)

	return                                                                 

	end                                                                    

                                                                        

                                                                        

                                                                        

	subroutine  equil_c(                                                   

     *  k_help,dfmax,dfmax0,bt0,beta,brad,

     *  xbound,ybound,errm,i_en2,key_eq,power_ech,q,
     *  i_ech,q_test,omg_ppx,key_ext,int_2000,it_ext,tokc,i_en3,k_efit,
     *  te0,eps_vel,key_equil,vchopper,pf,i_gen,ajb,betj,i_new,key_ne,
     *  tpl0,i_pres,i_bound,fdd,fdd0,pll,i_exit,n_pas,npf,pfres,tt1,
     *  a,ha,elong,k_dm0,tcam,ncam,udd)

      	include 'double.inc'

      dimension xbound(*),ybound(*),q(*),te0(*),vchopper(*),pf(*),
     *  ajb(*),pfres(*),tcam(*)

                                                                        

	include 'parf0'                                                        

	common                                                                 

     *	/n_m/n,m,mp                                                      

	common                                                                 

     *	/keys1/i_graph                                                   

     *	/keys2/key_b                                                     

     *	/keys3/kzero,iread,iwrite                                        

     *  /keys4/k_ener,k_uv                                              

     *  /keys5/next                                                     

     *  /keys6/i_svd,i_cal,kpf                                          

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

	common                                                                 

     *  /halo1/c_h,d_halo,fmax_in,tpl_in                                

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

     *  /fluxc18/alf_tok,int_tok                                        

      common 
     * /c_imas_t_end2/t_end2

	common /c_data_in_time2/i_c_data,i_c_data1       

	dimension df_help(npo),dm_help(npo),uk_help(ntet),

     *  vk_help(ntet),v_help(100)

                                                                        

	dimension dfmax(*),dfmax0(*),a(*),ha(*),tcam_help(300)   

                                                                        
	real *8 tt_in

                                                                        

	character *30 apr                                                      

	dimension a_print(200),a_print1(200)

c______________________________                                         


      

	n_graf=1

	if(n_pas.ne.0)i_ktm=1

	i_eqb=1

   	kf43=1

	i_en2=i_en2+1            


	if(i_en2.eq.1)then	
		key_equil=3
       	t_end2=1.e10

        if(kpr.eq.1)print *,' i_en2==key_equil kpr ',i_en2,key_equil,kpr

        open (unit=1,file='kpr.dat',form='formatted')
        read (1,*)
        read (1,*)kpr


        if(kpr.eq.1)print *,' i_en2==key_equil kpr ',i_en2,key_equil,kpr
        
!              i_con=3

        close ( unit=1)       
	end if

c	print *,' HYU!!!!'


        if(kpr.eq.1)print *,' i_en2==key_equil kpr ',i_en2,key_equil,kpr

      
      if((key_equil.eq.2.or.key_equil.eq.3).and.i_en2.eq.1)then

	i_c_data=1
	i_c_data1=1

	ARG=1.d0                                     
	pi=4.d0*datan(ARG) 
	coef=10.d0/(4.d0*pi)                                                       
	amu0=0.4*pi

	call read_data() 


	                                                       
!	tt=0.

           open (unit=41,file='t_end.dat',form='formatted') 
           read (41,*)
           read (41,*)t_end 
           read (41,*)
           read (41,*)tt_br
           read (41,*)
           read (41,*)time_end

	      next_in=1

           read (41,*)
           read (41,*)next_in


		 close (41)

	     tpl_init=tpl
	     tpl_init1=tpl
	     tt_end=t_end-tt_br
	     
	     tt_end=tt+tt_end
	     t_end=tt+t_end

	if(kpr.eq.1)print *,' tt t_end tt_end time_end==',
     *  tt,t_end,tt_end
	if(kpr.eq.1)print *,' time_end==',
     *  time_end

!      stop
      
	tpl_imp=tpl+100.d0

!	call anglep()                                                          
	call anglep_kav()                                                          


	call angl_p()                                                          

	call ONE2()  
!	call ONE2d()  

	call cur_prof_data() 
	                                              
	call cur_prof()  

	call pl_bound()
	do i=2,n
	vol1=vol
	vol=a(i)*rmag*pi*eu**2*elong
	vi(i)=(vol-vol1)/ha(i)
	end do

	vol=vol*2.d0*pi

      	VMAX=1.E5                                                        

      	DO I=1,n                                                         

    	VN(I)=VI(I)/VMAX                                                   

	end do                                                                 

!!!      V_p=2.*pi*R*pi*a**2*elong

	if(kpr.eq.1)print *,' rmag eu elong vol==',
     *  rmag,eu,elong,vol

c	stop

      i_flat_ext=0
      
!      print *,' i_flat==',i_flat_ext
       
      if(i_flat_ext.eq.1)then
        call flat_ext()

!      call tcam_r()
	k_avr=1
	eu_a=amax1(eu,eu_u)
	call avr(r0,z0,1.5*eu,k_avr)
	call movem(i_c)

      end if
      

	CALL TOK()

	call cam_t()   

      call shape_pfres()
	if(i_gen.eq.0)call inv_gen()
!	if(i_gen.eq.0)call inv_gen_kav()

	if(i_gen.eq.1)call inv_gen_pf()
	if(i_ktm.eq.1)call tcam_corr()

      call loopflux()
      call probefield()

!      if(i_gen.eq.0)call gen_corr_kav()
	if(i_gen.eq.0)call gen() 
	if(i_gen.eq.1)call gen_pf() 

      call write_fc()
	
 	call dopp_in()


	call time_gen()                                                        
	call time_step()                                                       



	call v_sec()


!	call vic_br_bz()
!	call vic_br_bz_psi()


      return

      end if


      if((key_equil.eq.2.or.key_equil.eq.3).and.i_en2.ge.1)then

!	ntay=ntay+1

c	if(ntay.gt.5)ntay=5
!	tt=tt+tay

!      write(6,'("tt tt_end ", 3(1pe13.6))'),
!     *  tt,tt_end

	if(tt.le.tt_end.and.i_imp.eq.0)then
		 	call dopp_in()
	end if

	if(tt.gt.tt_end.and.i_imp.eq.0)then
		
	tay_imp=tay

!!!	tay=0.1*tay


!!!	tt=tt-tt_end

	nsteps=tt_br/tay

	d_tpl=(tpl_imp-tpl_init)/float(nsteps)

      if(kpr.eq.1)write(6,'("tpl_imp tpl_init d_tpl ", 3(1pe13.6))'),
     *  tpl_imp,tpl_init,d_tpl

	tpl=tpl_init

	call ptoke0() 

c     following reading necessary only once for impurity
	  call readmc_y
        call readehr1_y 

	tt1=0
	ksteps=1

	a_print(1)=tpl
	a_print(2)=tt 
	a_print(3)=i_imp 
	a_print(4)=ntay 

	n_pr=4
	apr='tpl tt i_imp ntay'
	num=20
	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)

	    call imp_neut_calc()
	    call imp_neut_calc2()
	    call ech_calc()

         call n_dd_read()
         call gamma_z_read()
         call gamma_z2_read()
         call anom_e_read()
c         call alf_n_read()

          call in_neut_0d()
	   call in_imp_0d()


	   i_test=0
	   if(i_test.eq.1)then
         tpl=1.e3
         tt_help=tt
         tt=1600.
         call n_dd_read()
         call gamma_z_read()
         call gamma_z2_read()

         tt=tt_help


	   call en_01()
	   call en_01_min()
         call into_impu()

         i=1
!         do kk=1,200
         do kk=1,2
         tt=tt+tay
         ntay=ntay+1
         call into_impu_test()
         call den_imp_bal()
         call kin_imp_testt(i)
         call to_0d()
	   call en_loss()

         call into_imp_kav()

        	call dopp_00()
	  call DOPP_kav()                                                            
	  call time_out()
	  call time_out_kav()

            call time_step_00()
     	      call imp_time_step()
	      call neut_time_step()

            end do
            

         stop
         end if
         


	   do kk=1,1

	   call en_01()
	   call en_01_min()
         call into_impu()


         call den_imp_bal()
	   call den_imp_0d()
         call to_0d()
	   call en_loss()
	
	   end do

         call into_imp_kav()

 		call dopp_00()

	call write_data_in_time_kav()
	call DOPP_kav()                           

	call time_step_00()
      	call imp_time_step()
		call neut_time_step()

c	print *,' v_v0==',v_v0

		call time_out()
	call time_out_kav()

	tpl_init1=tpl_init

	end if

	if(tt.gt.tt_end.and.tt.lt.t_end+0.5d0*tay)then
	i_imp=i_imp+1
	if(ksteps.eq.nsteps)then
	i_imp=1
	if(kpr.eq.1)print *,' ksteps nsteps==',
     *  dfloat(ksteps),dfloat(nsteps)	
	end if
	end if


	if(kpr.eq.1)print *,' tt i_imp==',tt,dfloat(i_imp)

	if(i_imp.eq.2)then


	i_imp=1

	ksteps=ksteps+1

	tpl=tpl_init+d_tpl*(ksteps-1)

	a_print(1)=tpl
	a_print(2)=tt 
	a_print(3)=i_imp 
	a_print(4)=ntay 

	n_pr=4
	apr='tpl tt i_imp ntay'
	num=20
	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)


	if(kpr.eq.1)print *,' ksteps nsteps==',
     *  dfloat(ksteps),dfloat(nsteps)

	if(kpr.eq.1)print *,' ksteps nsteps==',ksteps,nsteps
      if(kpr.eq.1)write(6,'("tpl tpl_init d_tpl ", 3(1pe13.6))'),
     *  tpl,tpl_init,d_tpl


	call ptoke0() 

	    call imp_neut_calc()
	    call imp_neut_calc2()
	    call ech_calc()

c	print *,' i_imp==',i_imp


         call n_dd_read()
         call gamma_z_read()
         call gamma_z2_read()
         call anom_e_read()
c         call alf_n_read()
 
       !  	k_dm0=1

      
	   do kk=1,3

c         call den_imp_bal()
c	   call den_imp_0d()

c	   call en_loss()
c         call to_0d()

	   call en_01()
	   call en_01_min()
         call into_impu()

         call den_imp_bal()
	   call den_imp_0d()
         call to_0d()
	   call en_loss()

	   end do


      call into_imp_kav()

c         call dif_s_imp_n()

c	   call dens_01_min()
c         call into_impu()
c	   call kin_imp_min()
c         call to_0d()


 	call dopp_00()
	call write_data_in_time_kav()
	call DOPP_kav()                       

      call time_step_00()
     	call imp_time_step()
	call neut_time_step()
	call time_out()
	call time_out_kav()

!      call wr_tpl()
!      call wr_rpp()
!      call wr_zpp()


	tpl_init1=tpl

	end if

!!!	tpl=tpl_init1

!      if(i_gen.eq.0)call gen_corr_kav()
      call shape_pfres()
      if(i_gen.eq.0)call gen()              
	if(i_gen.eq.1)call gen_pf()              
      call write_fc()
!	if(i_con.eq.2)call psl_corr()
!	if(i_ktm.eq.1)call tcam_corr()

      call loopflux()
      call probefield()

!	call vic_br_bz()

	call time_gen()                                                       
	call time_step()


	a_print(1)=rmag
	a_print(2)=zmag

	n_pr=2

	apr='rmag zmag'

	num=20

c	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)

	call v_sec()

c--------------------

c	if(kpr.eq.3)call print3(' tt t_end tay==',tt,t_end,tay)


	if(tt.gt.t_end-0.5d0*tay)then 
	i_imp=0
	key_equil=0   
	i_en2=1
	i_en3=0
	i_en4=0

	do i=1,npf
	v_help(i)=0.
c	pfres(i)=1.e-6
	end do


	go to 1001
	end if                                      

	return
      end if


1001  continue


c	stop
c	if(i_en2.eq.2) go to 323
	
	if(kpr.eq.1)call print2(' tt time_end==',
     *  tt,time_end)


	if(tt.gt.time_end) go to 3323


      a_print(1)=tt
      a_print(2)=time_end
      a_print(3)=i_en2
      n_pr=3
      
      num=20
      apr='tt t_end i_en2='
      
	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)

!      return

	if(i_en2.gt.1) go to 2323


	ksteps=ksteps+1

	tpl=tpl_init+d_tpl*(ksteps-1)

	a_print(1)=tpl
	a_print(2)=tt 
	a_print(3)=i_imp 
	a_print(4)=ntay 

	n_pr=4
	apr='--tpl tt i_imp ntay'
	num=20
	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)


      a_print(1)=tt
      n_pr=1      
      num=20
      apr='0=='
      
!	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)


	call ppx_pffx_tab()         


!	if(kpr.eq.1)print *,' call ptoke0=============='                      


c        call psi_wr()
                                                                        

	pt0z=-tpl                                                              

	it1=1                                                                  

                                                                        

	int=0                                                                  

	niter=1                                                                

      a_print(1)=tt
      n_pr=1      
      num=20
      apr='1=='
      
!	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)


	call lim_mesh()

	call ves_pind()  

      a_print(1)=tt
      n_pr=1      
      num=20
      apr='2=='
      
!	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)


	self_v=0.2*fluxt0                                                      

	if(kpr.eq.1)print *,' sef_v===',self_v      

	a_print(1)=rmag

	a_print(2)=zmag

	a_print(3)=tpl
	a_print(4)=eu
	a_print(5)=i_new

	n_pr=4

	apr='rmag zmag i_pl a'

	num=20

	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)


	apr='** k_efit i_new k_ener i_pres'
	a_print(1)=k_efit
	a_print(2)=i_new
	a_print(3)=k_ener
	a_print(4)=i_pres

	n_pr=4

	num=20

	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)


	apr='** ntay next tpl'
	a_print(1)=ntay
	a_print(2)=next
	a_print(3)=tpl

	n_pr=3

	num=20

	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)


      rref=rmag
      zref=zmag

!      call brz_vec_r()


	int=0
	
	next2=next_in

9	continue


	if(i_con.eq.3)then
    	call s_zpp()
  	call shape_rpp() 
  	call shape_udd() 
	end if

	if(kpr.eq.3.or.kpr.eq.1)call print2(' kzref krref==',
     *  dfloat(kzref),dfloat(krref))

	a_print(1)=rmag
	a_print(2)=zmag
	a_print(3)=rref
	a_print(4)=zref

	n_pr=4

	apr='rm zm rref zref'

	num=20

	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)


1	continue                                                              

                                                                        

!	if(kpr.eq.1)print *,'zref==',zref                                     

                                                                        

	niter=niter+1                                                          

                                                                       
	call ptoke1()                                                          

	rmag_eq=rmag
	zmag_eq=zmag
                                                                        
	if(kpr.eq.1)print *,' --um vm--niter it1',
     *  um,vm,niter,it1           

	a_print(1)=rmag
	a_print(2)=zmag
	a_print(3)=brad
	a_print(4)=bvert
	a_print(5)=niter

	n_pr=5

	apr='rm zm br bz niter'

	num=20

	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)

                                                                        
	if(it1.ne.0.and.niter.lt.200)go to 1      

      call ppx_pffx_save(1)

         call  write_surf()
         call write_prof0()
         call write_prof4()

c 	call print1(' -- eu==',eu)

                                                                        
	a_print(1)=rmag
	a_print(2)=zmag

	a_print(3)=tpl
	a_print(4)=brad
	a_print(5)=bvert
	a_print(6)=niter

	n_pr=6

	apr='rmag zmag i_pl bz br niter'

	num=20

	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)

	i_stab=0



	call map_tor()
	call eq_res_ps()
      CALL BTA(n,mp,RS0)


      int=0
      
66	continue

c	call p_calc()

c	call transf_data_new()

	if(kpr.eq.1)call print2(' tt a==',tt,eu)


	call pp_calc()
	call pff_calc()

!!!	call ptoke_res()

c-----------------

	call ppx_pffx()
	call ppx_pffx_corr2

	call ppx_pffx_tab()         

	niter=0

	niter=0                                                         

      it1=1
      
!      call ppx_pffx_save(0)

2	continue

	niter=niter+1

	call ptoke1()
	a_print(1)=rmag
	a_print(2)=zmag
	a_print(3)=brad
	a_print(4)=bvert
	a_print(5)=niter

	n_pr=5

	apr=' -- 2-- rm zm br bz niter'

	num=20

	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)

	if(it1.ne.0.and.niter.lt.100)go to 2

22	continue


	int=int+1

	call map_tor()
	call eq_res_ps()
!      call pl_bound()  
!	call transf_b_tor()

      CALL BTA(n,mp,RS0)

!      if(int.eq.1)goto 66


      call kpl_out()


      if(kzref.eq.1.and.krref.eq.-1)then
	
!	   call ppx_pffx_save(0)

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

	call map_tor()
	call eq_res_ps()
      CALL BTA(n,mp,RS0)

ccc      call ppx_pffx_save(1)
		
	end if



	ntay=0
	
	call trian()



      	VMAX=1.E5                                                        

      	DO I=1,n                                                         

    	VN(I)=VI(I)/VMAX                                                   

	end do                                                                 

c!!!	call dens_ext()
c	call dens_prog()

c!!!	call temp_ext()

c	call pau()

	if(i_pres.eq.0)then
c	if(k_ener.eq.1)	CALL ENERGY(N)                                         
	if(k_ener.ne.1)call enit_kav(n)      

	end if


!	  call prof_astra_HL()
!        call prof_astra_bs_hl()

!        stop

        if(k_ener.eq.0)then
!	   if(tt.le.tt_HL_xx)call prof_astra()
!	   if(tt.gt.tt_HL_xx)call prof_astra_HL()
cc	   if(tt.le.tt_dw)call prof_astra()
cc	   if(tt.gt.tt_dw)call prof_astra_HL()

 	call dopp_00()
	call DOPP_kav()                                                            
	call time_out()
	call time_out_kav()
	end if



        call q_calc()

	call v_sec()

c	call DOPP()                                                            

	i_ppx=1

	if(next.eq.9999)i_ppx=0

	if(next.eq.9998)i_ppx=0

c	if(i_ppx.eq.1)call ppx_pffx()


	   call loopflux()

	   call probefield()
                                                                        

!      if(i_gen.eq.0)call gen_corr_kav()

      call shape_pfres()
	if(i_gen.eq.0)call gen() 
	if(i_gen.eq.1)call gen_pf() 
      call write_fc()
	call time_gen()                                                        

                                                                        
	call time_step()                                                       


	psi_eav0=psi_eav

	eps20=eps2                                                             

	rmag_in=rmag                                                           

	zmag_in=zmag                                                           

	next0=next                                                             

	k_q=0                                                                  

	k_d=0                                                                  

	kaxis=0                                                                

	eu_in=eu                                                               

	i_c=i_c0                                                               

                                                                        

c	d_bt0=2.                                                               

	do j=1,mp

	   uk_help(j)=uk(j)

	   vk_help(j)=vk(j)

	end do



	um_help=um

	vm_help=vm

	omg_ppx=1.

	a_print(1)=zmag
	n_pr=1
	apr='  *zmag *'
	num=20
c	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)


c	call pau()

	call separ_coor()                                                

	if(kpr.eq.2)print 73,rmag,zmag,zvel,d_zvel,int_tok,int_2000

	kk=0
      do i=1,npf
	kk=kk+1
	a_print(kk)=vchopper(i)

      end do
	n_pr=kk
	apr='Volts'
c	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)

      call  write_surf()
      call write_prof0()
      call write_prof4()

	call index_calc()                                                     
 
c 	call print1(' ** eu==',eu)

!	call equidsk_write()

!      call wr_tpl()
!      call wr_rpp()
!      call wr_zpp()

!      call prof_astra()
!      stop

	return



2323	continue


      i_kavin=0
      if(i_kavin.eq.1.and.tt.gt.1300.and.k_zyb.eq.0)then

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



	i_c_data=0
	i_c_data1=0

	if(ntay.gt.5)then
	k_dm0=1
	end if



	if(ntay.le.2)then
	zmag_in=zmag     
	end if



	                                                      

	do i=1,npf
c	vchopper(i)=v_help(i)
	end do


	kk=0
      do i=1,npf
	kk=kk+1
	a_print(kk)=vchopper(i)

      end do
	n_pr=kk
	apr='Volts'
c	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)



!	ntay=ntay+1
	ntay1=ntay1+1

c!!!	if(ntay.ge.20)ntay=20   
!	tt=tt+tay

	a_print(1)=i_con
	a_print(2)=next2
	a_print(3)=ntay
	a_print(4)=next

	n_pr=4

	apr='- i_c next2 ntay next=-'

	num=25


	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)



c	if(key_ech.eq.1)then
c	call p_emo1() 
c	call p_emo2() 
c	end if

	if(ntay.eq.ngra*(ntay/ngra))then
	
!	call write_tok
	
	end if
	
	

c	call tem_con_d()


                                                                     


                                                                        

                                                                        

c	call li_d()                                                           

                                                                        

c	call li_dropp()                                                       

                                                                        

	it1=1                                                                  

	ipage=1                                                                

!	if(i_graph.eq.0)ipage=0                                               

c----------                                                             

c  plot magnetic surfaces...                                            

c	if(ipage.eq.1) call graphic(it1,n)                                    

c--------------------                                                   

                                                                        

	if(i_c.eq.1)then                                                       

	k_avr=1                                                                

	eu_a=dmax1(eu,eu_u)                                                    

	call avr(rmag,zmag,eu_a,k_avr)                                         

	call movem(i_c)                                                        

	end if                                                                 

                                                                        

                                                                        

c        if(kmaj.eq.1)call maj_dis()                                    

c!!!	call vde2()                                                        

                                                                        

c        if(kmaj.eq.0)call vde()                                        

                                                                        

                                                                        


                                                                        

	if(kpr.eq.1)print *,' ntay ndisrup tt tay===========',ntay,

     *	ndisrup,tt,tay                                                   

                                                                        

	int_dif=0                                                              

	ndop=1                                                  

	int_2000=0                                                             

                                                                        

	eps2=eps20               

	
	if(ntay.gt.next2+1.and.i_con.ne.3)then     
                                                                        
	kzref=0
	krref=0

c      brad=0.d0                                                     
c      bvert=0.d0                                                      

	end if

	if(ntay.le.next.and.i_con.eq.3)then
!         call shape_ip()
      end if
      
!	if(ntay.ge.10)then     
	if(ntay.ge.next2+1)then     

!	   kzref=0                                                             

	   brad=brad*0.95d0                               
	   bvert=bvert*0.95d0                             

!	   brad=0.                                                             

	end if                                                                 



	if(i_con.eq.3)then
    	call s_zpp()
  	call shape_udd() 
  	call shape_rpp() 

	end if

	a_print(1)=i_con
	a_print(2)=kzref
	a_print(3)=krref
	a_print(4)=brad
	a_print(5)=bvert

	n_pr=5

	apr='- i_c kz kr br bz =-'

	num=25


	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)


c	   brad=0.d0                                                     
c	   bvert=0.d0                                                      

                                                                        

c!	call power_ech_read()



c!	call vic_yr0_read()

                                                                        

c	call cur_prof2()
c	call ppx_pffx_tab()         

c	if(ntay.gt.1.)omg_ppx=omg_ppx*0.98

                                                                        
c	if(ntay.gt.1.)omg_ppx=omg_ppx*0.95

c	if(ntay.gt.1)omg_ppx=0.



	apr=' 1 te0--'                                                       
c	print 71,apr,(te0(j),j=1,n)


	   pkzref=kzref
	   pkrref=krref
	   pk_dm0=k_dm0

c  	call print3(' kzref krref k_dm0==',pkzref,pkrref,pk_dm0)
c	call print3(' brad bvert Ip==',brad,bvert,tpl)


     
2000	continue                  



                                       
	int_2000=int_2000+1                                                    

	i_ppx=1
	if(int_2000.eq.1)then
	i_ppx=1
	end if

	if(i_ppx.eq.1)then
!	call ppx_pffx()
!	call ppx_pffx_corr2()                                  
!	call ppx_pffx_tab()         
	end if

	i_ppx=1

      ntay1=ntay+1

!      if(ntay.le.10)then 
     	call ppx_pffx()
	call ppx_pffx_corr2
	
!      call ppx_pffx_save(1)
!      end if

                                                                        

	zvel_0=zvel                                                            

                                                                        

	eps2=eps20                                                             

	int_tok=0                                                              

c         print *,' key_equil====',key_equil
                                                                        
	if(key_equil.eq.1)then
	   it1=0

c	   print *,' key_equil====',key_equil

	   go to 2001
	end if


c	   go to 2001

c 	call ppx_pffx_corr()

c	call pet_tab_read()

	tpl_help=tpl

!!!	tpl=0.5d0*(tpl+tpl0)

!       call shape_ip()

      
2005	continue                                                           

	int_tok=int_tok+1                                                      

!	if(kpr.eq.1)print *,' call ptoke1=============='                      

c	tpl_help=tpl
c	tpl=tpl0

	a_print(1)=tpl_help
	a_print(2)=tpl0
	a_print(3)=tpl
	n_pr=3

	apr='-- tpl_help tpl0  tpl'

	num=25

      do i=1,ncam
 !     tcam(i)=0.5d0*(tcam_help(i)+tcam(i))
      end do
      
	call ptoke1()    
	
	

	if(i_exit.eq.1)then 

	a_print(1)=i_exit
	n_pr=1

	apr='-- i_exit'

	num=25

	call out42(n_pr,a_print,num,apr)

	   return
	   end if
	       

c	call pp_pff_save()

c	tpl=tpl_help




      do i=1,ncam
      tcam_help(i)=tcam(i)
      end do

!      if(i_gen.eq.0)call gen_corr_kav()
      call shape_pfres()
	if(i_gen.eq.0)call gen()              
	if(i_gen.eq.1)call gen_pf()              


c	print *,' i_gen===',i_gen
                                               
!!!	if(i_con.eq.2)call psl_corr()
!!!	if(i_ktm.eq.1)call tcam_corr()




cGEN	call ful()                                                            

c	call gen()                                                             

c--------------------------------

	call loopflux()

	call probefield()

c----------------------------------
c	call gen_pf()                                                         
	                                              


!	if(int_tok.gt.15)eps2=eps2*2.d0
	if(int_tok.gt.5)eps2=eps2*2.d0
                                                                        

c----------------                                                       

	delzmag=zmag-zmag_in                                                   

	delrmag=rmag-rmag_in                                                   

                                                                        

	zvel=(zmag-zmag0)/tay                                                  

                                                                        

	z_dis=dabs(zmag-zmag0)                                                  

                                                                        

	rvel=(rmag-rmag0)/tay                                                  

                                                                        

	if(int_tok.le.3)it1=1

	a_print1(int_tok)=zmag


	if(it1.ne.0) go to 2005



	tpl=tpl_help

      call ppx_pffx_save(1)


	if(next.eq.9998)then
	a_print(1)=aver_psi
	a_print(2)=aver_psi0
	a_print(3)=tpl
	n_pr=3

	apr='-- aver_psi aver_psi0 tpl'

	num=25

	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)

	end if



	um=rmag

	vm=zmag

                                                                         

	d_zvel=dabs(zvel-zvel_0)/(dabs(zvel)+1.e-1)                              

	if(kpr.eq.2.and.key_eq.eq.0)then

	print 73,rmag,zmag,zvel,d_zvel,int_tok,int_2000

73	FORMAT(1X,' rm zm,zv d_zv i_tok,I_2000',
     * 1x,4(1PE11.3),2i4)

c	if(i_con.eq.1)then
c        print *,' ZVEL Zmag d_zvel eps_vel INT_2000 U Pf',
c     *  zvel,zmag,d_zvel,eps_vel,int_2000,vchopper(6),pf(6)
c	   else
c        print *,' ZVEL Zmag d_zvel eps_vel INT_2000 ',
c     *  zvel,zmag,d_zvel,eps_vel,int_2000
c	   end if

	   end if

c	print *,' eps_vel===',eps_vel

!!!	if(d_zvel.gt.0.001.                  
	if(d_zvel.gt.5.e-2.                  
     *  and.int_2000.lt.15)then                                         
	it1=1     	
        end if 


	if(kpr.eq.1)then
        print *,' ZVEL Zmag d_zvel eps_vel INT_2000 ',
     *  zvel,zmag,d_zvel,eps_vel,int_2000

        print *,' brad bvert  ',
     *  brad,bvert

        print *,' key_eq int_200 it1  ',
     *  key_eq,int_2000,it1


	end if



c        print *,' key_eq===',key_eq


	n_pr=int_tok

	apr=' zmag ='

	num=10

	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print1,num,apr)



	a_print(1)=tpl

	a_print(2)=rmag

	a_print(3)=zmag

	a_print(4)=zvel

	a_print(5)=d_zvel

	a_print(6)=int_tok

	a_print(7)=int_2000


	n_pr=7

	apr=' i_p z_m zv d_zv i_tk i_200'

	num=30

	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)

c	if(it1.eq.0)go to 888
                                                                        



 2001	continue                                                          



c  plot magnetic surfaces...                                            

c	if(ipage.eq.1) call graphic(it1,n)                                    

        

      if(int_2000.eq.1)then

  	do j=1,mp

	   uk_help(j)=uk(j)

	   vk_help(j)=vk(j)

c           print *,' j xbound ybound ',j,xbound(j),ybound(j)

	end do

	um_help=um

	vm_help=vm

        end if

	i_avr=0
	if(i_avr.eq.1)then

	do j=1,mp

	   uk(j)=0.5*(uk_help(j)+uk(j))

	   vk(j)=0.5*(vk_help(j)+vk(j))

c           print *,' j uk vk  ',j,uk(j),vk(j)

        end do



	um=0.5*(um_help+um)

	vm=0.5*(vm_help+vm)


	end if

      i_tor=0
      if(i_tor.eq.1)then
	call map_tor()
	call eq_res_ps()
!	CALL BTA(n,mp,RS0)
      else
      call map_ps()
      end if
      

!	call dfmax_calc()
	call transf_b_tor()

!	udd=-(fdd-fdd0)/(tay*100.)

!      udd=10.
!      fdd=fdd0-udd*tay*100.d0
	if(i_con.eq.3)then
!      fdd0=fdd+udd*tay*100.d0
	end if

        if(k_ener.eq.0)then
!	   if(tt.le.tt_HL_xx)call prof_astra_bs()
!	   if(tt.gt.tt_HL_xx)call prof_astra_bs_HL()
cc	   if(tt.le.tt_dw)call prof_astra_bs()
cc	   if(tt.gt.tt_dw)call prof_astra_bs_HL()
	end if

      if(kpr.eq.1)print *,' tpl_calc'
	tpl_in=tpl
	call tpl_cal()
!	call tpl_cal_kav()

!	tpl_o=tpl

!	tpl=0.5*(tpl_in+tpl)

	call pp_calc()
	call pff_calc()


	errd=2.*dabs(dmo-dm0(n))/( dabs(dmo)+dabs(dm0(n)) )  

	err_tpl=dabs(tpl-tpl_in)/tpl                        

	int_dif=int_dif+1                                                      

!	if(err_tpl.gt.1.d-4.and.int_2000.lt.20)it1=1
	if(err_tpl.gt.1.d-3.and.int_2000.lt.10)it1=1
                                                                        
	if(it1.ne.0)go to 2000                                                 

	eps2=eps20                                                             

!	call vic_br_bz()

	call trian()


      call dfmax_calc()

	call index_calc()                                                     


	int_dif=0  
	                                                            
	a_print(1)=key_eq

	a_print(2)=it1

	n_pr=2

	apr=' key_eq it1'

	num=30




 888	continue

	CALL BTA(n,mp,RS0)


	if(next.eq.9998.or.next.eq.9997)go to 59


c	q_zyb=0.94
	q_zyb=q_test

	if(kpr.eq.1)print *,' -q_zyb q(2)-',q_zyb,q(2)

	a_print(1)=q_zyb
	a_print(2)=udd_e
	a_print(3)=delzmag
c	a_print(4)=psi_eav
c	a_print(5)=psi_eav0
c	a_print(6)=psi_eav00

	n_pr=3

	apr='q_z u_e delzmag'

	num=25

c	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)


	if(q(2).le.q_zyb.and.ntay.ge.5)then
	call zyb(n,ires)
	end if

                                                                        

c-----------------------------                                          

c   vessel cuurents taken after convergance of equilibrium---           

                                                                        

c----------------------------                                           

	if(i_pres.eq.0)then

c	if(key_ech.eq.1)then
	i_ech=1
	call pow_emo() 
c	end if

	if(key_ech.eq.1)then
	call p_emo1() 
	call p_emo2() 
	end if

	end if

c                                                 

      	VMAX=1.E5                                                        

      	DO I=1,n                                                         

    	VN(I)=VI(I)/VMAX                                                   

	end do                                                                 

	if(kpr.eq.1)print *,' -----k_ener t_dop---',k_ener,t_dop              

         tpl_help=tpl


	if(i_pres.eq.0)then 

	if(k_ener.eq.1)	then 

!!!	CALL ENERGY(N)                                         

c--------------------------

	tt1=tt1+tay
c
	    call imp_neut_calc()
	    call imp_neut_calc2()
	    call ech_calc()

         call n_dd_read()
         call gamma_z_read()
         call gamma_z2_read()
 
	   if(kpr.eq.1)print *,' anom_e_read '

         call anom_e_read()

	   if(kpr.eq.1)print *,' anom_e_read2 '

!
!         call shape_ip()

	a_print(1)=tpl
	a_print(2)=tpl_help

	n_pr=2

	apr=' tpl tpl_help'

	num=15

	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)


	   do kk=1,3

	  
	   call en_01()
	   call en_01_min()
         call into_impu()


         call den_imp_bal()
	   call den_imp_0d()
         call to_0d()
	   call en_loss()
	
	   end do
	   


         call into_imp_kav()
      
      tpl=tpl_help
      
 	call dopp_00()
	call write_data_in_time_kav()
	call enit_kav(n)

	call DOPP_kav()                                                            


      call time_step_00()
     	call imp_time_step()
	call neut_time_step()

	call time_out()
	call time_out_kav()

c--------------------------
	end if

      
        if(k_ener.eq.0)then
!	   if(tt.le.tt_HL_xx)call prof_astra()
!	   if(tt.gt.tt_HL_xx)call prof_astra_HL()
cc	   if(tt.le.tt_dw)call prof_astra()
cc	   if(tt.gt.tt_dw)call prof_astra_HL()

 	call dopp_00()
	call DOPP_kav()                                                            
	call time_out()
	call time_out_kav()
	end if
	

c	call trian()
	do i=1,n
c	a_print(i)=ajb(i)
	end do
	n_pr=n
	num=25

	apr='-1-ajb '
c	call out42(n_pr,a_print,num,apr)

	end if



59	continue

      call q_calc()





	do i=1,n
c	a_print(i)=ajb(i)
	end do
	n_pr=n
	num=25

	apr='-2-ajb '
c	call out42(n_pr,a_print,num,apr)

	if(i_pres.eq.0)then 
	call v_sec()
	a_print(1)=0
	apr='-dopp '
c	call out42(n_pr,a_print,num,apr)

c	call DOPP()
	end if



	do i=1,n
c	a_print(i)=ajb(i)
	end do
	n_pr=n
	num=25

	apr='-3-ajb '
c	call out42(n_pr,a_print,num,apr)

      call write_fc()
      call ppx_pffx_save(0)
      call pet_tab_wr()
      
	do i=1,ncam
	   tcam_help(i)=tcam(i)*1.d-3
	end do
	
       open (unit=40,file='I_v3a.txt',form='formatted') 
       write (40,*)(tcam_help(i),i=1,ncam)
       close (40)

      
	call time_gen() 
	                                                      
	do i=1,n
c	a_print(i)=ajb(i)
	end do
	n_pr=n
	num=25

	apr='-4-ajb '
c	call out42(n_pr,a_print,num,apr)

	call time_step()

c	aver_psi0=aver_psi
	psi_eav0=psi_eav

c	call con_time_step()

      if(ntay.eq.n_graf*(ntay/n_graf))then 
      call  write_surf()
      call write_prof0()
      call write_prof4()
      end if
                                                       
                                                                       

c!!!	if(tt.lt.t_end)go to 2323                                          



c        close (43)



	do j=1,mp

	   uk_help(j)=uk(j)

	   vk_help(j)=vk(j)

c           print *,' j xbound ybound ',j,xbound(j),ybound(j)

	end do



	um_help=um

	vm_help=vm
	do i=1,n
c	a_print(i)=ajb(i)
	end do
	n_pr=1
	num=25

	a_print(1)=0
	apr='-HyI '
c	call out42(n_pr,a_print,num,apr)


	a_print(1)=0
	apr='-trian '
c	call out42(n_pr,a_print,num,apr)

	do i=1,n
c	a_print(i)=ajb(i)
	end do
	n_pr=n
	num=25

	apr='-6-ajb '
c	call out42(n_pr,a_print,num,apr)
                                                                        
	call separ_coor()                                                

	a_print(1)=0
	apr='-separ_coor '
c	call out42(n_pr,a_print,num,apr)


	do i=1,n
c	a_print(i)=ajb(i)
	end do
	n_pr=n
	num=25

	apr='-7-ajb '
c	call out42(n_pr,a_print,num,apr)



c	call map_tor()
c	call eq_res_ps()
c	call polar_tor_in()



c      write(*,*) 'operation time=',(t_finish-t_start)

!      call wr_tpl()
!      call wr_rpp()
!      call wr_zpp()


	if(dabs(delzmag).ge.300.)then
c	if(dabs(delzmag).ge.3.)then

	a_print(1)=delzmag

	n_pr=1

	apr=' delzmag gt 200'

	num=25

	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)


	call pau()

	i_exit=1


	end if

	return                                                                 
 


3323	continue

!      if(i_gen.eq.0)call gen_corr_kav()
      call shape_pfres()
	if(i_gen.eq.0)call gen()              
	if(i_gen.eq.1)call gen_pf()              
      call write_fc()

	call v_sec()
	call loopflux()
	call probefield()
	call time_gen() 

	return                                                                 
                                                                      
                                                                        

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))                                      

	return                                                                 

	end                                                                    
	subroutine read_data()
	include 'double.inc'
	include 'new_com.inc'


	call read_data_c(
     *  res_coef,n_polar,
     *  k_ion)

	return
	end
	subroutine read_data_c(
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
     
       

     	open(unit=2,file='for002_kav',form='formatted')
        if(kpr.eq.1)print *,' begin for002_kav reading'

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
	   print *,' i_con ===',i_con
	   print *,' key_ef ===',key_ef
	   print *,' res_coef===',res_coef
	   print *,' n_polar===',n_polar
	   print *,' k_ion===',k_ion
	   print *,' pow_el pow_ion===',pow_el,pow_ion
	   print*,'tt=',tt
	   print*,'tpl=',tpl
 	   print *,' -----k_ener t_dop---',k_ener,t_dop    
 	             
	   print *,' ken2===',ken2

 	   print *,' -----ind_r---',ind_r              
 	   print *,' -----ind_z---',ind_z              

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


	subroutine gsvd_ef(indpf,seps1,seps2,seps3)
	return
	end

c




  	subroutine read_exp() 
	include 'double.inc'
	include 'new_com.inc'

	call read_exp_c(
     *  kloop,kprobe,npf,	
     *  psloop_e,bprobe_e,pf_e,
     *  psloop,bprobe,pf)

	return
	end

c

	subroutine read_exp_c(
     *  kloop,kprobe,npf,	
     *  psloop_e,bprobe_e,pf_e,
     *  psloop,bprobe,pf)

	include 'double.inc'
	dimension psloop_e(*),bprobe_e(*),pf_e(*)
	dimension psloop(*),bprobe(*),pf(*)


	do i=1,npf
	pf_e(i)=pf(i)
	end do

	do i=1,kloop
	psloop_e(i)=psloop(i)
	end do

	do i=1,kprobe
	bprobe_e(i)=bprobe(i)
	end do

	return
	end

   
	subroutine ptoke1_fil_0()
	include 'double.inc'
        include 'parf0'
        include 'parf2'
	common
     *	/n_m/n,m,mp
	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nn),y(MM),dx,dy
     *  /eq1g/psi_g(nr,nz)
     *  /eq8/jbound,xbound(ntet),ybound(ntet),alfa0_xx
     *  /eq15/pll,zsep,rsep,zsepup,rsepup,zsepdw,rsepdw
	common
     *  /pol4/ UM,VM,UK(ntet),VK(ntet)
     *  /pol5/psend
     *  /pol6/ppx(npo),pffx(npo)
	common
     *  /ge1/pi
     *	/ge1e/rs0,tpl
     *  /ge2/NTAY,TAY,TT
     *  /ge3/AI(npo),poA0(npo),HA2(npo),poa(npo),ha(npo)
     *  /ge4/EPS1,EPS2,EPS0
     *  /ge5/kpr
	common
     *	/fluxc2/delta0,pom(ntet)
     *	/fluxc6/pmag,pbound,psep,p_s,delaval,dr_h
     *	/fluxc7/coef,coef1,api
     *  /fluxc9/fdd,fdd0


	common
     *	/point1/r0,z0
	common
     *  /halo4/expfg,avalb,w_h,del_r,al0
     *  /halo4e/w_h0,delaval0,pshalo0,te_h0
     *  /halo5e/pshalo
     *  /halo15/e_sep,nsep
	common
     *  /eq11/psval(npo),psval0(npo)
	common
     *	/keys1/i_graph
     *	/keys2/key_b
     *  /keys11/i_ramp
        common
     *	/efit2/alfa0,beta,alfa1
	common
     *	/efit5/it1,it2
        common
     *  /ves9/tokc,tokc0
	common
     *  /ef_0/key_ef
        common
     *  /efil_6/psi_min,psi_max
     *  /efil_10/plasma_coef
	common
     *  /cont13/zmag,zvel,delrmag,delzmag
     *  /cont13e/zmag0,rmag,rmag0,rvel
c----------
	dimension f(nwnh),pspl_help(nwnh)

	rmag_help=rmag
	zmag_help=zmag

	pmag_help=pmag

	rsep_help=rsep
	zsep_help=zsep
	psep_help=psep

	do i=1,nwnh
	pspl_help(i)=pspl(i)
	end do

	delta0=sqrt(dx**2+dy**2)
	COEF=10./(4.*PI)
	api=1./(2.*pi)

	nw_h=10
	n1=nr-1
	m1=nz-1
c------------------------------------
c calc.psi(i,j)
	if(kpr.eq.1)print *,' call to psi_tot_fil--'

	call psi_fil()

	coef1=dx*dy*coef
c	call psi_fil_pl()

	call psi_tot_fil()

c	call li_calc()



c   call to plasma-limiter contact...
	if(kpr.eq.1)print *,' call to pom_lim--'
	call pom_lim()
c--------------------------
c calc. boundary values...
	if(kpr.eq.1)print *,' call to psi_b--'
	call psi_b_fil(psep,rsep,zsep,ksepa)
	if(kpr.eq.1)print *,'  psep rsep zsep',psep,rsep,zsep

	call bound_fil()
	call separ_coor()                                                
	call separ_coor2()                                                


	do i=1,nwnh
	pspl(i)=pspl_help(i)
	end do

	rmag=rmag_help
	zmag=zmag_help
	pmag=pmag_help

	rsep=rsep_help
	zsep=zsep_help
	psep=psep_help

c      call q_b_calc()


71	format(20x,a6/,(6(1pe10.3)))
	return
	end


	subroutine psi_b_fil(psep,rsep,zsep,ksepa)
	include 'double.inc'
        include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *  /eq6/sinus(ntet),cosin(ntet)
     *  /eq14e/rsep_pf,zsep_pf
	common
     *  /pol4/ UM,VM,UK(ntet),VK(ntet)
	common
     *  /ge5/kpr
     *  /ge7/eu,rout,zout,elong

	common
     *	/fluxc2/delta0,pom(ntet)

	dimension pdd(6)
	dimension  vkref(ntet),ukref(ntet)


c!!!	abeg=eu
	abeg=0.8*eu

	do j=1,m
	ukref(j)=um+ABEG*cosin(j)
	vkref(j)=vm+elong*ABEG*sinus(j)
	end do

71	format(20x,a6/,(6(1pe10.3)))

	i1=2
	i2=m-1
c---------
	pom_m=pom(2)
	i3=2
	do i=3,m-1
	if(pom(i).lt.pom_m)i3=i
	end do
c	i1=2
c	i2=m-1
c	i3=2
	pocoef=0.1*delta0
	kc=1
	psepa=-1.e14
c-----------------------------------------------
c PSEPA(from separatrix1) - max psi in limiter
c RSEPA,ZSEPA - coordinates of this point

	call separatrix1 (i1,i2,i3,m,ukref,vkref,um,vm,pom,
     *  sinus,cosin,pocoef,psepa,rsepa,zsepa,isep,ksepa,kc)
	if(kpr.eq.1)print *,'psepa***=',psepa
	if(kpr.eq.1)print *,'zsepa rsepa',zsepa,rsepa
	posepa=sqrt( (rsepa-um)**2+(zsepa-vm)**2 )
	ksepa=1
	do i=2,m-1
	if(abs(posepa-pom(i)).lt.1.e-4)then
	if(kpr.eq.1)print *,'i posepa pom(i)',i,posepa,pom(i)
c
	if(kpr.eq.1)print *,' plasma touchs limiter'
	ksepa=0
	urr=rsepa
	vrr=zsepa

	rsep_pf=rsepa
	zsep_pf=zsepa

	call boxd(urr,vrr,pdd,ier)
	psepa=pdd(1)
	end if
	end do
c__________________________
c  search for separatrix...
	ksep=2
	psep=-1.e12
	psep1=-1.e12
	if(ksepa.ne.0)then
	xw=rsepa
	yw=zsepa
	call spoint(ksep,xw,yw,fint,rmag,zmag,pmag,
     *  rsep,zsep,psep,rsep1,zsep1,psep1)
	end if
c__________________________
c
	if(psepa.gt.psep.and.ksepa.eq.0)then
c	if(kpr.eq.1)print *,'***psepa gt psep---',psepa,psep
	psep=psepa
	rsep=rsepa
	zsep=zsepa
	end if
	if(abs(psep).gt.1.e10)then
	psep=psepa
	rsep=rsepa
	zsep=zsepa
	end if
c------------------------------------
	return
	end



	subroutine stab(ich_xx,i_graph_xx)
      	include 'double.inc'

	include 'new_com.inc'



	call stab_c(ich_xx,i_graph_xx,

     *  rref,zref,bvert,brad,it1,dx,dy,

     *  rmag,zmag,pmag,psep,zsep,kpr)

      

	return

	end





	subroutine stab_c(ich,i_graph,

     *  rl,zl,clr,clz,it1,dx,dy,

     *  rmag,zmag,pmag,psep,zsep,kpr)

      	include 'double.inc'


	character *30 apr

	dimension a_print(200)



	pbound=psep

	iter=0

c	ceps=0.1

c	ceps=0.02

	ceps=0.02

	a_print(1)=clr

	a_print(2)=clz

	a_print(3)=zl

	a_print(4)=rl

	n_pr=4

	apr=' clr clz zl rl ENTER '

	num=30

	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)


 1000	continue

      

	it1=1





	if(ich.eq.0) then  


	   rl0=rl                                

	   zl0=zl                                

	 

	   clr0=clr                              

	   clz0=clz                              

                                                       

	   ddzl=dy*ceps



	   zl=zl0+ddzl                            

	   int_it=0



 1	   continue

	   int_it=int_it+1

c	      call cur_prof()

	      call ptoke1()

	      if(int_it.gt.40)it1=0

	      if(it1.eq.1)go to 1

	a_print(1)=clr

	a_print(2)=clz

	a_print(3)=zl

	a_print(4)=rl

	a_print(5)=ich

	a_print(6)=int_it

	a_print(7)=iter

	n_pr=6

	apr=' clr clz zl rl ich int '

	num=30

	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)

      ich=ich+1                             


	endif                                   



	it1=1



	if(kpr.eq.1)print *,' ich==',ich



c	if(i_graph.eq.1)call graphic(it1,n)

                                                       

	if(ich.eq.1) then  

	   clr1=clr                              

	   clz1=clz                              

	   ddrl=dx*ceps



!!!	   rl=rl+ddrl
	   rl=rl0+ddrl

	   zl=zl0  
	                                 
	   int_it=0

 2	   continue

	   int_it=int_it+1

c	      call cur_prof()

	      call ptoke1()

	      if(int_it.gt.40)it1=0

	   if(it1.eq.1)go to 2

	a_print(1)=clr

	a_print(2)=clz

	a_print(3)=zl

	a_print(4)=rl

	a_print(5)=ich

	a_print(6)=int_it

	a_print(7)=iter

	n_pr=6

	apr=' clr clz zl rl ich int '

	num=30

	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)

      ich=ich+1                             

	endif                                   



c	if(i_graph.eq.1)call graphic(it1,n)


                                                       

	if(kpr.eq.1)print *,' ich==',ich



	if(ich.eq.2) then  





	   dcrdr=(clr-clr0)/ddrl                 

	   dczdr=(clz-clz0)/ddrl                 



	   if(kpr.eq.1)print *,' clr clr0  ddrl',clr,clr0,ddrl

	   if(kpr.eq.1)print *,' clz clz0  ddrl',clz,clz0,ddrl



                 

	   dcrdz=(clr1-clr0)/ddzl                

	   dczdz=(clz1-clz0)/ddzl                

                 

	   if(kpr.eq.1)print *,' clr1 clr0  ddzl',clr1,clr0,ddzl

	   if(kpr.eq.1)print *,' clz1 clz0  ddzl',clz1,clz0,ddzl



	   det=dcrdr*dczdz-dczdr*dcrdz           

               

	   if(kpr.eq.1)then

	   print *,' det dcrdr dczdz dczdr dcrdr',

     *      det,dcrdr,dczdz,dczdr,dcrdr

	   end if



      delrl0=delrl
	delzl0=delzl
	
	         

	   delrl= (clz0*dcrdz-clr0*dczdz)/det       

	   delzl= (clr0*dczdr-clz0*dcrdr)/det       

	if(iter.gt.2)then
c	delrl=0.5d0*(delrl+delrl0)
c	delzl=0.5d0*(delzl+delzl0)
	end if


	   if(kpr.eq.1)print *,' delrl delzl',delrl,delzl

                                                       

	   dll=sqrt(delrl**2 + delzl**2)           

	 

	   dllim=0.5*sqrt(dx**2+dy**2)

                          

	   if(kpr.eq.1)print *,' dll dllim',dll,dllim

	a_print(1)=delrl

	a_print(2)=delzl

	a_print(3)=dll

	a_print(4)=dllim

	a_print(5)=dcrdr

	a_print(6)=dczdr

	a_print(7)=dcrdz

	a_print(8)=dczdz



	n_pr=8

	apr=' delr delz dll dllim dcrdr dczdr dcrdz dczdz '

	num=30

	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)


	   if(dll .gt. dllim) then                  

                                                       

	      nstp=dll/dllim                       

                                                       

	      ddrr=delrl/nstp                      

	      ddzz=delzl/nstp                      



	      if(nstp.ge.5)nstp=5

c	      if(nstp.ge.2)nstp=2

c	      if(nstp.ge.50)nstp=50



	      do  istep=1,nstp                  

                                                       

          if(kpr.eq.1)write(6,*) 'slow shift',istep,nstp   

                                                       

		 rl=rl0+ ddrr*istep                   

		 zl=zl0+ ddzz*istep



		 it1=1




	   int_it=0


 3		 continue

		 int_it=int_it+1

c		    call cur_prof()

		    call ptoke1()

		    if(int_it.gt.40)it1=0

		    if(it1.eq.1)go to 3



c	if(i_graph.eq.1)call graphic(it1,n)

	a_print(1)=clr

	a_print(2)=clz

	a_print(3)=zl

	a_print(4)=rl

	a_print(5)=istep

	a_print(6)=int_it


	n_pr=6

	apr=' CLR  CLZ zl rl ISTEP int '

	num=30

	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)



	      end do

	a_print(1)=clr

	a_print(2)=clz

	a_print(3)=zl

	a_print(4)=rl

	a_print(5)=ich

	a_print(6)=int_it

	a_print(7)=iter

	n_pr=6

	apr=' clr clz zl rl ich int '

	num=30

	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)
		

	   else                                     

                                                       

	      rl=rl0+ delrl                         

	      zl=zl0+ delzl



	      it1=1



	   int_it=0



 4	      continue

	      int_it=int_it+1

c		 call cur_prof()

		 call ptoke1()

		 if(int_it.gt.40)it1=0

		 if(it1.eq.1)go to 4



c	if(i_graph.eq.1)call graphic(it1,n)

	a_print(1)=clr

	a_print(2)=clz

	a_print(3)=zl

	a_print(4)=rl

	a_print(5)=ich

	a_print(6)=int_it

	a_print(7)=iter

	n_pr=6

	apr=' clr clz zl rl ich int '

	num=30

	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)


	   endif                                    


	   ich=0


	endif                                    



c	ceps=ceps*0.5



        crz=abs(clr*rmag/(pmag-pbound))+

     *  abs(clz*(zmag-zsep)/(pmag-pbound))



	

	iter=iter+1



	if(kpr.eq.1)print *,' ITER pmag pbound zsep==',pmag,pbound,zsep

	if(kpr.eq.1)print *,' ITER clr clz crz==',iter,clr,clz,crz




	a_print(1)=clr

	a_print(2)=clz

	a_print(3)=iter

	n_pr=3

	apr=' clr clz iter'

	num=30

	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)

c	if(abs(crz).gt.1.d-5.and.iter.le.25)go to 1000
	if(abs(crz).gt.1.d-5.and.iter.le.10)go to 1000

c	if(abs(crz).gt.1.d-5)go to 1000

c	if(dabs(crz).gt.1.d-3)go to 1000



	a_print(1)=crz

	a_print(2)=clr

	a_print(3)=clz

	a_print(4)=zl

	a_print(5)=rl

	a_print(6)=iter

	n_pr=6

	apr='crz clr clz zl rl ITER'

	num=20

	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)

c	stop

                                                       

	return

	end




	subroutine flat_ext2()
	include 'double.inc'
	include 'new_com.inc'

	call flat_ext2_c(
     *  nwnh,nr,nz,npf,ncam,pf,tcam,
     *  fluxarr,vesarr,
     *  kf,mu,
     *  xu,yu,ke)
	
	return
	end



	subroutine flat_ext2_c(
     *  nwnh,nr,nz,npf,ncam,pf,tcam,
     *  fluxarr,vesarr,
     *  kf,mu,
     *  xu,yu,ke)

	include 'double.inc'

	dimension pf(*),tcam(*),fluxarr(nwnh,*),
     *  vesarr(nwnh,*),xu(*),yu(*)

	dimension ttt(100)

74	format(a110)

	open (unit=41,file='test_data.dat',form='formatted')                  
	read (41,*)npf,ncam,kloop,kprobe,ke

	read (41,5000)(xu(k),k=1,ke)                                                   
	read (41,5000)(yu(k),k=1,ke)                                                   

	read (41,5000)(pf(k),k=1,npf)                                                   
	read (41,5000)(tcam(k),k=1,ncam)                                                   

	do k=1,npf                                                        
	   read (41,5000)(fluxarr(kk,k),kk=1,nwnh)                                     
	end do                                                                 

	do k=1,ncam                                                        
	      read (41,5000)(vesarr(kk,k),kk=1,nwnh)
	end do                                                                 


	close (41)

5000    format (6(1pe14.7))

	return
	end






                                                                        
	subroutine flat_ext2_wr()
	include 'double.inc'
	include 'new_com.inc'

	call flat_ext2_wr_c(
     *  nwnh,nr,nz,npf,ncam,pf,tcam,
     *  fluxarr,vesarr,
     *  kf,mu,
     *  xu,yu,ke)
	
	return
	end



	subroutine flat_ext2_wr_c(
     *  nwnh,nr,nz,npf,ncam,pf,tcam,
     *  fluxarr,vesarr,
     *  kf,mu,
     *  xu,yu,ke)

	include 'double.inc'

	dimension pf(*),tcam(*),fluxarr(nwnh,*),
     *  vesarr(nwnh,*),xu(*),yu(*)

	dimension ttt(100)

74	format(a110)



	open (unit=41,file='test_data.dat',form='formatted')                  

	write (41,*)npf,ncam,kloop,kprobe,ke

	write (41,5000)(xu(k),k=1,ke)                                                   
	write (41,5000)(yu(k),k=1,ke)                                                   

	write (41,5000)(pf(k),k=1,npf)                                                   
	write (41,5000)(tcam(k),k=1,ncam)                                                   

	do k=1,npf                                                        
	   write (41,5000)(fluxarr(kk,k),kk=1,nwnh)                                     
	end do                                                                 

	do k=1,ncam                                                        
	      write (41,5000)(vesarr(kk,k),kk=1,nwnh)
	end do                                                                 


	close (41)

5000    format (6(1pe14.7))


	return
	end






                                                                        


	subroutine new_lim(i_lim)
	include 'double.inc'
        include 'parf0'
        include 'parf1'
        include 'parf2'
        include 'parf7'

	common
     *	/n_m/n,m,mp
	common
     *  /ge1/pi
     *  /ge5/kpr
	common
     *  /pol4/ UM,VM,UK(ntet),VK(ntet)
	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nr),y(nz),dx,dy
     *  /eq2/ke,xu(mu_l),yu(mu_l)
     *  /eq2e/kex,xue(mu),yue(mu)
     *  /eq7/tetq(ntet),htq(ntet)
	common
     *	/fluxc2/delta0,pom(ntet)
	common
     *  /keys7/i_c

	parameter ( k_sep=1000 )
	common /c_tsp1/r_sep(k_sep),z_sep(k_sep)
	common /c_tsp2/n_sep

	dimension  pom_1(ntet),xu_help(mu),yu_help(mu)
	
	character *20 apr

      i_en=i_en+1
      if(i_en.eq.1)then

      ke_help=kex
      
      do i=1,ke
      xu_help(i)=xu(i)
      yu_help(i)=yu(i)
      end do
            
      end if
      


      if(i_lim.eq.1)then

c----------------------

      ke=kex
      do i=1,ke
      xu(i)=xue(i)
      yu(i)=yue(i)
      end do
      
c------------------------      

      else
      
      ke=ke_help
      
      do i=1,ke
      xu(i)=xu_help(i)
      yu(i)=yu_help(i)
      end do
            
      end if
      

      return
      end
      
