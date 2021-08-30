!> In subroutine dina_0 as a result of call dina2 and then call equil2 or 
!> call equil according to tt_kavin value the DINA modeling of one time step is
!> being produced

	subroutine dina_0(time_8,tt_8,tay_8,key_mat,vec_mat,
     *	p_input_1,p_input_2,p_input_3,
     *	output_1,output_2,output_3,output_4,ng)


	include 'double.inc'
!	include 'new_com.inc'

      common
     *  /ge5/kpr

	real *8 time_8, tay_8
	real *8 tt_8 

	real *8 vec_mat(*)
		
	dimension key_mat(*) 

	real *8 p_input_1(*),p_input_2(*),p_input_3(*)

	real *8 output_1(*)
	real *8 output_2(*)
	real *8 output_3(*)
	real *8 output_4(*)


	real *8 a_print(200)
	
      parameter (kint=500)
      
      dimension c_input1(kint),c_input2(kint)
      dimension c_output1(kint),c_output2(kint),c_output3(kint)

	character *25 apr


c =================================================================

c	print *,' ok1 '

c =================================================================

	i_en0=i_en0+1    

      ng=i_en0

!      kpr=key_mat(4)

 !     kpr=0

      if(kpr.eq.1)print *,' kpr===',kpr
      

      do i=1,6
!	a_print(i)=key_mat(i)
      end do
      
	n_pr=6
	apr='  key'
	num=6
!	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)
                                                                        


      n_input1=2
      do i=1,n_input1
          c_input1(i)=p_input_1(i)
      end do

      do i=1,n_input1
!	a_print(i)=c_input1(i)
      end do
      
	n_pr=n_input1
	apr='  c_input1'
	num=10
!	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)

!      n_input2=15
      n_input2=38
      
     
      do i=1,n_input2
        c_input2(i)=p_input_2(i)
      end do

      do i=1,n_input2
!	a_print(i)=c_input2(i)
      end do
      
	n_pr=n_input2
	apr='  c_input2'
	num=10
!	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)


  !      c_input1(1)=tpl

 !       goto 5

      n_output3=32

      do i=1,n_output3
!	a_print(i)=c_output3(i)
      end do
      
	n_pr=n_output3
	apr='  output3'
	num=10
!	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)



	  call dina2(
!-----------------------------------  inputs---
     *  c_input1,c_input2,
!------------------------------------outputs
     *  c_output1,c_output2,c_output3)

c ============ outputs ==============================================


5     continue


      n_output1=15
      do i=1,n_output1
		output_1(i)=c_output1(i)
        end do

      do i=1,n_output1
!	a_print(i)=output_1(i)
      end do
      
	n_pr=n_output1
	apr='  output1'
	num=10
!	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)

      npf=15
      n_gaps=6
      ncam=100
      
      n_output2=n_gaps+npf+ncam
      
      n_output3=32
      
	a_print(1)=n_gaps
	a_print(2)=npf
	a_print(3)=ncam
      
	n_pr=3
	apr='  n_ga npf ncam '
	num=10
	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)
              
        do i=1,n_output2
        output_2(i)=c_output2(i)
        end do

      do i=1,n_output2
!	a_print(i)=output_2(i)
      end do
      
	n_pr=n_output2
	apr='  output2'
	num=10
!	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)

        do i=1,n_output3
 !       output_3(i)=c_output3(i)
        end do

      do i=1,n_output3
!	a_print(i)=c_output3(i)
      end do
      
	n_pr=n_output3
	apr='  output3'
	num=10
!	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)





      return
      end

      
!> dina_outp is a subroutine to collect the output data to write them after that 
!> to IDSs in dina_imas subroutine
      
	subroutine dina_outp(n_xx,
     * tpl_xx,uli_xx,v_xx,parea_xx,psi_ax_xx,rmag_xx,zmag_xx,
     * q_ax_xx,q_95_xx,rs0_xx,bt0_xx,wen2_xx,tt_xx,
     * a_xx,psi_1D_xx,te0_xx,tq0_xx,pne_xx,tok1_xx,q_xx,
     * x_xx,y_xx,psi_xx,psi_bnd_xx,psi_sep_xx,curr_d_xx,
     * ksepa_xx,rmajor_xx,rminor_xx,elong_xx,tri_xx,gaps_xx,dsep_xx,
     * pd0_xx,pt0_xx,sigma_xx,ajb_xx,aj0_xx,ajae_xx,zeff_xx,press_xx,qe0_xx,qq0_xx,
     * betap_xx,betat_xx,tec_xx,tqc_xx,pec_xx,pic_xx,palf_xx,zeff0_xx,vloop_xx,
     * tene_xx,teit_98_xx,wfus_xx,emag_xx,
     * vchopper_xx,pf_xx,tcam_xx,
     * fpol_xx,pptab_xx,fptab_xx,phi_xx,
     * n_bnd_xx,xbound_xx,ybound_xx,n_sep_xx,x_sep_xx,y_sep_xx, n_sep2_xx,x_sep2_xx,y_sep2_xx,
     * bprobe_xx,psloop_xx,
     * surface_1d_xx,volume_1d_xx,area_1d_xx,
     * psi_sep2_xx)


	include 'double.inc'
	include 'new_com.inc'

        common /c_imas_curr_d/curr_d(nr,nz)
!     *  /c_ramp2/rsep2,zsep2,psep2
!     *  /vic_008/rsep2_gr,zsep2_gr,rsep2_l,zsep2_l,
!     *           rsep2_r,zsep2_r
!     *  /cont21/n_ga,n_int
!     *  /cont20/x_gaps(kf_c),y_gaps(kf_c),gaps(kf_c),n_gaps
     

	dimension a_xx(*),psi_1D_xx(*),te0_xx(*),tq0_xx(*),pne_xx(*),tok1_xx(*),
     *  q_xx(*),x_xx(*),y_xx(*)
	dimension pd0_xx(*),pt0_xx(*),sigma_xx(*),ajb_xx(*),ajae_xx(*),
     *  aj0_xx(*),qe0_xx(*),qq0_xx(*)
        dimension xbound_xx(*),ybound_xx(*),x_sep_xx(*),y_sep_xx(*),x_sep2_xx(*),y_sep2_xx(*) 
     
	dimension psi_xx(nr,nz),curr_d_xx(nr,nz)
        dimension gaps_xx(*)
        dimension vchopper_xx(*),pf_xx(*),tcam_xx(*)
        dimension fpol_xx(*),pptab_xx(*),fptab_xx(*),phi_xx(*)
        dimension press_xx(*),zeff_xx(*)
        dimension bprobe_xx(*),psloop_xx(*)
        dimension surface_1d_xx(*),volume_1d_xx(*),area_1d_xx(*)
        
        include 'imas_interface.inc'
        
           
        
        n_xx=n

!	pi=3.14159
	
	tpl_xx = tpl_dir*tpl*1000.d0
	
!	print *,' n_xx tpl_xx=',n_xx,tpl_xx
	
!	return
	
	uli_xx=uli
	v_xx=volume
	parea_xx=surface
	
	rmag_xx=rmag/100.d0
	zmag_xx=zmag/100.d0
	q_ax_xx=q(2)
        q_95_xx=q_95

	wen2_xx=0.d0 ! wr_imas
	tt_xx=tt/1000.d0

        rs0_xx = rs0/100.d0
        bt0_xx = bt0_dir*bt0/10.d0
	
        betap_xx = betj
        betat_xx = bett
        tec_xx = tec
        tqc_xx = tqc
        pec_xx = pcch*1.d19
	pic_xx = pion*1.d19
	palf_xx = palf*1.d19
	zeff0_xx = zeff_a
	vloop_xx = vloop
	tene_xx = tene*1.d-3

        print *,' tene_xx tene==',tene_xx,tene

	teit_98_xx = teit_98*1.d-3
	wfus_xx = w_fusion*1.d6
	emag_xx = emag*1.d6

        rmajor_xx = rout/100.d0
        rminor_xx = eu/100.d0
        elong_xx = elong
        tri_xx = tri
      
      
        psi_ax_xx = tpl_dir*pmag*1.d-5*2.*pi
        psi_bnd_xx = tpl_dir*pbound*1.d-5*2.*pi
        psi_sep_xx = tpl_dir*psep*1.d-5*2.*pi
        psi_sep2_xx = tpl_dir*psep2*1.d-5*2.*pi
        
        ksepa_xx = ksepa 
        
        n_bnd_xx = jbound
        do i=1,jbound
           xbound_xx(i) = xbound(i)*1.d-2
           ybound_xx(i) = ybound(i)*1.d-2
        end do
        
        n_sep_xx = n_sep
        do i=1,n_sep
           x_sep_xx(i) = x_sep(i)*1.d-2
           y_sep_xx(i) = y_sep(i)*1.d-2
        end do
        
        n_sep2_xx = n_sep2
        do i=1,n_sep2
           x_sep2_xx(i) = x_sep2(i)*1.d-2
           y_sep2_xx(i) = y_sep2(i)*1.d-2
        end do
        
        do i=1,n_ga
          gaps_xx(i) = gaps(i)*1.d-2
        enddo
        dsep_xx = gaps(n_ga+1)*1.d-2
        
        
        bprobe_xx(1:kprobe) = tpl_dir*bprobe(1:kprobe) ! *1.d-1
        psloop_xx(1:kloop) = tpl_dir*psloop(1:kloop)*2.*pi ! *1.d-5
c=================================================

	do i=1,n
	   a_xx(i)=a(i)

	   te0_xx(i)=te0(i)
	   tq0_xx(i)=tq0(i)
	   
	   pne_xx(i)=pne(i)*1.d19   
           pd0_xx(i)=pd0(i)*1.d19
           pt0_xx(i)=pt0(i)*1.d19
           
           !sigma_xx(i)=sigma_dina(i)
           sigma_xx(i)=sigk(i)
           
           qe0_xx(i)=qe0(i)
           qq0_xx(i)=qq0(i)
	   

	   zeff_xx(i)=zeff(i)
   
!	   pptab_xx(i)=pptab(i)
!	   fptab_xx(i)=fptab(i)

           psi_1D_xx(i) = tpl_dir*psval(i)*1.d-5*2.*pi
           phi_xx(i) = bt0_dir*dfmax(i)*1.d-5


	   surface_1d_xx(i) = s_surf(i)*2.d0*pi*1.d-4

	end do
	
	
	
	do i=1,n
	
	   psix_xx=(psval(i)-pmag)/(pbound-pmag) 
	   !psix_xx=sqrt(psix_xx)
	   psix_xx=sqrt(ai(i))
	
	   !call feeti(n,ppx,pptab_xx(i),a,psix_xx)
           !call feeti(n,pffx,fptab_xx(i),a,psix_xx)          
           !call feeti(n,p,press_xx(i),a,psix_xx)
           
           !call feeti(n,f,fpol_xx(i),ai,psix_xx)
           !call feeti(n,q,q_xx(i),ai,psix_xx)
          
          
           ! Defined on a-grid?
           pptab_xx(i) = ppx(i)
           fptab_xx(i) = pffx(i)
           press_xx(i) = p(i)
           

        enddo
        
        ! Defined on ai-grid, to get it on a-grid
        !fpol_xx(i) = f(i)
        !q_xx(i) = q(i)
        
        ai(n+1)=1.d0
        teta_xx=1.d0
        call inter_h0(q,ai,n,teta_xx,val)
        q(n+1)=val
        f(n+1)=bt0
           
           
        fpol_xx(1) = f(1)
        fpol_xx(n) = f(n)
        q_xx(1) = q(1)
        q_xx(n) = q(n)
        do i=2,n-1             
           call feeti(n+1,f,fpol_xx(i),ai,a(i))
           call feeti(n+1,q,q_xx(i),ai,a(i))          
        enddo
        
        
        do i=1,n  
           pptab_xx(i) = -tpl_dir*pptab_xx(i) * 1.d10/(rs0*8.d0*pi**2)
           fptab_xx(i) = -tpl_dir*fptab_xx(i) * rs0/(40.d0*pi)       
           fpol_xx(i) = bt0_dir*(rs0/100.d0)*fpol_xx(i)/10.d0
           press_xx(i) = 1.602176634d0*press_xx(i)/(200.d0*1.d-6)         
           q_xx(i)=q_xx(i)
                   
	enddo
	
	
	volume_1d_xx(1) = 2.d0*pi*vi(1)*ha(1)*1.d-6
	area_1d_xx(1) = spo(1)*ha(1)*1.d-4
	do i=2,n
	   volume_1d_xx(i) = volume_1d_xx(i-1) + 2.d0*pi*vi(i)*ha(i)*1.d-6
           area_1d_xx(i) = area_1d_xx(i-1) + spo(i)*ha(i)*1.d-4          
	enddo
	
	
	do i=1,n

	   tok1_xx(i) = tpl_dir*tok1(i)*1.d7 ! Toroidal current density
	   ajb_xx(i) = tpl_dir*ajb(i)*1.d7 ! Bootstrap current density
	   aj0_xx(i) = tpl_dir*aj0(i)*1.d7 ! j_parallel
	   ajae_xx(i) = tpl_dir*ajae(i)*1.d7 ! source of j_parallel
	      
           
           

	end do

c=================================================

	do i=1,nr
	   x_xx(i)=x(i)/100.d0
	end do

	do i=1,nz
	   y_xx(i)=y(i)/100.d0
	end do


        tok_1=0.
        tok_2=0.
        tok_3=0.
        do i=1,nr
           do j=1,nz
                kk=(i-1)*nz+j
                u_h(kk)=0.
              psi_xx(i,j) = tpl_dir*psi(i,j)*1.d-5*2.*pi
              curr_d_xx(i,j) = tpl_dir*curr_d(i,j)*1.d7
              u_h(kk)=curr_d(i,j)/(coef+1.d-13)
              tok_1=tok_1+curr_d_xx(i,j)*dx*dy*1.e-4
              tok_2=tok_2+curr_d(i,j)*dx*dy
              tok_3=tok_3+u_h(kk)*dx*dy*coef
           end do
        end do

        print *,'tpl tok_1 tok_2 tok_3==',
        
     *  tpl,-tok_1*1.e-3,tok_2,tok_3


        call psi_pl_test(u_h,pspl)
        
        do i=1,nr
          do j=1,nz
                kk=(i-1)*nz+j
                u_h(kk)=0.
          end do
        end do
          
!         call psi_pl_test(u_h,psext)

	
	do i=1,npf
	   vchopper_xx(i) = tpl_dir*vchopper(i)*pf_turns(i)
	   pf_xx(i) = tpl_dir*1.d3*pf(i)/pf_turns(i)
	enddo
	
	do i=1,ncam
	   tcam_xx(i) = tpl_dir*1.d3*tcam(i)
	enddo

		
	
	if(kpr.eq.1)print *,' tt t_vde=',tt,t_vde

      if(tt.gt.t_vde)then
	print *,' tt t_vde=',tt,t_vde
      stop      
      end if
      


      return
      end

      
! dina_wr_output is aimed to additional output parameters      
!        subroutine dina_wr_output(Pohm, Wdop, w_alfa, wtor, w_Be, w_W, w_Ar, w_Ne, w_imp, w_rad, w_heat)
        subroutine dina_wr_output(wr_imas_in)  
        include 'double.inc'
       
        
        common/maksim_03/wr,wr_imas       
        dimension wr(150), wr_imas(150)
        
        dimension wr_imas_in(150)
        
        !real*8 :: wr_imas(150)
        
        wr_imas_in = wr_imas
        
!     * /c_br4/wdh,p_oh
        
        !wr_imas = wr
        
        !Pohm = wr(65)
        !wdop = wr(66)
        !w_alfa = wr(67)      
        !wtor = wr(84)
        
        !w_Be = wr(86)
        !w_W = wr(87)
        !w_Ar = wr(88)
        !w_Ne = wr(89)
        !w_imp = wr(90)
        !w_rad = wr(91)
        !w_heat = wr(71)
 
 
        return
        end
      
      
      
!> dina_input is the subroutine to collect the initial kinetic profiles before enter 
!> to DINA to write them after that to DINA from IDSs in dina_imas subroutine

	subroutine dina_input(te0_xx,tq0_xx,pne_xx,
     * pd0_xx,pt0_xx,sigk_xx,ajb_xx,aj0_xx,qe0_xx,qq0_xx)

	include 'double.inc'

	dimension te0_xx(*),tq0_xx(*),pne_xx(*)
	dimension pd0_xx(*),pt0_xx(*),sigk_xx(*),ajb_xx(*),
     *  aj0_xx(*),qe0_xx(*),qq0_xx(*)

	include 'parf0'
     
        common /c_input1/te0(npo),tq0(npo),pne(npo),
     *  pd0(npo),pt0(npo),sigk(npo),ajb(npo),
     *  aj0(npo),qe0(npo),qq0(npo)

	common
     *	/n_m/n,m,mp
     */ge2/NTAY,TAY,TT

        include 'imas_interface.inc'
     
     
	character *20 apr

c=================================================

      i_en=i_en+1

      tt_1=tt_1+tay
      
      t_ret=1.e5
      
      print *,' CALL dina_input tt_1 tay t_ret=',tt_1,tay,t_ret
      
      if(tt_1.le.t_ret)return

	do i=1,n
	   te0(i)=te0_xx(i)
	   tq0(i)=tq0_xx(i)
	   pne(i)=pne_xx(i)*1.d-19
	end do

      apr='--te0-' 
      if(kpr.eq.1)print 71,apr,(te0(i),i=1,n) 
      apr='--tq0-' 
      if(kpr.eq.1)print 71,apr,(tq0(i),i=1,n) 
      apr='--pne-' 
      if(kpr.eq.1)print 71,apr,(pne(i),i=1,n) 

   71 FORMAT(20X,A20/,(6(1pE10.3)))
	
	do i=1,n
	   pd0(i)=pd0_xx(i)*1.d-19
	   pt0(i)=pt0_xx(i)*1.d-19
	   sigk(i)=sigk_xx(i)
	   ajb(i)=tpl_dir*ajb_xx(i)*1.d-7
	   aj0(i)=tpl_dir*aj0_xx(i)*1.d-7
	   qe0(i)=qe0_xx(i)
	   qq0(i)=qq0_xx(i)
	end do

      apr='--pd0-' 
      if(kpr.eq.1)print 71,apr,(pd0(i),i=1,n) 
      apr='--qe0-' 
      if(kpr.eq.1)print 71,apr,(qe0(i),i=1,n) 
      apr='--ajb-' 
      if(kpr.eq.1)print 71,apr,(ajb(i),i=1,n) 

      return
      end


!> dina_v96_in is the subroutine to write Green Functions from IDSs to DINA in DINA units

        subroutine  dina_v96_in(

     *  ncam_mat,npf_mat,kloop_mat,kprobe_mat,

     *  gridrange,

     *  kf_mat,mu_mat,

     *  fluxarr_mat,vesarr_mat,

     *  pslgreen_mat,bprgreen_mat,

     *	pfind_mat,pmj_mat,pfc_mat,

     *  pfres_mat,rcam_mat,        

     *  xu_mat,yu_mat,ke_mat,key_mat,

     *  pfgreen_mat,vesgreen_mat,

     *  pfprobe_mat,vesprobe_mat,ngrid2)

      	include 'double.inc'

	include 'parf2'

                                         
        real*8 fluxarr_mat(ngrid2,*),vesarr_mat(ngrid2,*),  

     *	pslgreen_mat(ngrid2,*),bprgreen_mat(ngrid2,*),       

     *	pfind_mat(kf_mat,*),pmj_mat(mu_mat,*),                           

     *  pfc_mat(mu_mat,*),                                              

     *  pfres_mat(*),rcam_mat(*),                                       

     *  xu_mat(*),yu_mat(*),

     *  pfgreen_mat(kloop_mat,*),vesgreen_mat(kloop_mat,*),

     *  pfprobe_mat(kprobe_mat,*),vesprobe_mat(kprobe_mat,*),
     
     * gridrange(*)

	real *8 z_l,z_r,r_l,r_r                                                


	include 'parf1'                                                        
                                                                     
	include 'parf2e'                                                       
                                                                        

	include 'parf4'                                                        

                                                                        

	include 'parf7'                                                        

                                                                        

c	implicit real *8 (a-h,o-z)                                            

                                                                        

       	common                                                          

     *  /ves1/psp(mu),psp0(mu),tcam(mu),tcam0(mu)                       

     *  /ves2/ncam,rc(mu),zc(mu)                                        

     *  /ves3/b(mu,mu),pmj(mu,mu)                                       

     *  /ves4/rcam(mu)                                                  

     *  /ves5/pfc(mu,kf)                                                

                                                                        

	common                                                                 

     *  /eq1/psip(nr,nz),pspl(nwnh),x(nr),y(nz),dx,dy                   

     *  /eq1e/psext(nwnh),re(nre),ze(nze),dr,dz                         

     *  /eq3/FLUXARR(nwnh,kf)                                           

     *  /eq10/vesarr(nwnh,mu)                                           

                                                                        

                                                                        

	common                                                                 

     *  /pf1/npf,pf(kf),pf0(kf)                                         

     *  /pf8/pfind(kf,kf),pfres(kf),a1(kf,kf),e1(kf),e2(kf)             

                                                                        

	common                                                                 

     *	/loop1/kloop,rl(nloop),zl(nloop),psloop(nloop)                   

     *  /loop2/pfgreen(nloop,kf),vesgreen(nloop,mu)                     

     *	/loop5/pslgreen(nwnh,nloop)                                      

                                                                        

	common                                                                 

     *	/probe1/kprobe,bprobe(nprobe)                                    

     *  /probe2/pfprobe(nprobe,kf),vesprobe(nprobe,mu)                  

     *	/probe4/bprgreen(nwnh,nprobe)                                    

                                                                        

	common                                                                 

     *  /eq2/ke,xu(mu_l),yu(mu_l)                                       



	common

     *	/c_add0/i_en0

     *	/c_add2/i_en2

     *	/c_add3/i_en3

     *	/c_add7/i_en4


	real*8 pf_mat(kf),tcam_mat(mu)  
	dimension a_print(100)
	character *20 apr



        i_en0=0

        i_en2=0

        i_en3=0

        i_en4=0

                                                                
      z_l=gridrange(1)
      z_r=gridrange(2)
      r_l=gridrange(3)
      r_r=gridrange(4)

      z0=z_l*100.d0    
	zk=z_r*100.d0
                                                                       
	r0=r_l*100.d0
	rk=r_r*100.d0
                                                                       
	dz=(zk-z0)/(nze-1.)                                              

	dr=(rk-r0)/(nre-1.)                                                    

c----                                                                   

	do i=1,nre                                                             

	re(i)=r0+(i-1)*dr                                                      

	end do                                                                 

                                                                        

	do j=1,nze                                                             

	ze(j)=z0+(j-1)*dz                                                      

	end do                                                                 

                                                                        

	dx=dr                                                                  

	dy=dz                                                                  

                                                                        

!        write(41,*)' nre nze ',nre,nze                                  

                                                                        

!        write (41,*)' dx dy ',dx,dy                                     

                                                                        

                                                                        

	do i=1,nr                                                              

	x(i)=re(i)                                                             

!        write(41,*)' i x ',i,x(i)                                       

	end do                                                                 

                                                                        

	do i=1,nz                                                              

	   y(i)=ze(i)                                                          

!        write(41,*)' i y ',i,y(i)                                       

	end do                                                                 

                                                                        

c---------------------------------                                      

	ncam=ncam_mat                                                          

	npf=npf_mat                                                            

                                                                        

	kloop=kloop_mat                                                        

	kprobe=kprobe_mat                                                      

                                                                        

	ke=ke_mat                                                              

	a_print(1)=ncam

	a_print(2)=npf

	a_print(3)=kloop

	a_print(4)=kprobe

	a_print(5)=ke

	a_print(6)=nwnh

	n_pr=6

	apr='  tran_to'

	num=6

c	call out42(n_pr,a_print,num,apr)
                                                                        

!       write(41,*)' ncam npf kloop kprobe ke',ncam,npf,kloop,kprobe,ke  

                                                                        

                                                                        

	do k=1,ke                                                              

	   xu(k)=xu_mat(k)*100.                                                

	   yu(k)=yu_mat(k)*100.                                                

!        write(41,*)' k xu yu ',k,xu(k),yu(k)                            

	end do                                                                 

                                                                        

	apr='  xu'
c	call out42(n_pr,a_print,num,apr)
                                                                        

	do k=1,ncam                                                            

	   rcam(k)=rcam_mat(k)                                                 

	   do kk=1,ncam                                                        

	      pmj(k,kk)=pmj_mat(k,kk)*1.e8                                     

	   end do                                                              

!        write(41,*)' k rcam pmj ',k,rcam(k),pmj(k,k)                    

	end do                                                                 

                                                                        
	apr='  pmj '
c	call out42(n_pr,a_print,num,apr)

                                                                        

	do k=1,ncam                                                            

	   do kk=1,npf                                                         

	      pfc(k,kk)=pfc_mat(k,kk)*1.e8                                     

	   end do                                                              

!        write(41,*)' k pfc ',k,pfc(k,1),pfc(k,2),pfc(k,3)               

	end do                                                                 


	apr='  pfc'
c	call out42(n_pr,a_print,num,apr)
                                                                        

	do k=1,npf                                                             

	      pfres(k)=pfres_mat(k)                                            

	   do kk=1,npf                                                         

	      pfind(k,kk)=pfind_mat(k,kk)*1.e8                                 

	   end do                                                              

!        write(41,*)' k pfres pfind ',k,pfres(k),pfind(k,k)              

	end do                                                                 

                                                                        
	apr='  pfind'
c	call out42(n_pr,a_print,num,apr)

                                                                        

                                                                        

	do k=1,ncam                                                            

	   do kk=1,nwnh                                                        

	      vesarr(kk,k)=vesarr_mat(kk,k)*1.e8                               

	   end do                                                              

!        write(41,*)' k vesarr ',k,vesarr(1,k),vesarr(2,k),vesarr(3,k)   

	end do                                                                 

	apr='  vesarr'
c	call out42(n_pr,a_print,num,apr)



	do k=1,npf                                                             

	   do kk=1,nwnh                                                        

	      fluxarr(kk,k)=fluxarr_mat(kk,k)*1.e8                        

	   end do                                                              

!        write(41,*)'k fluxarr',k,fluxarr(1,k),                          

!     *  fluxarr(2,k),fluxarr(3,k)                                       

	end do                                                                 

	apr='  fluxarr'
c	call out42(n_pr,a_print,num,apr)


	if(kloop.gt.0)then                                                     

	   do k=1,kloop                                                        

	      do kk=1,nwnh                                                     

		 pslgreen(kk,k)=pslgreen_mat(kk,k)*1.e8

	      end do
	   end do 

	apr='  pslgreen '
c	call out42(n_pr,a_print,num,apr)

	   do k=1,kloop                                                        
	      do kk=1,npf

		 pfgreen(k,kk)=pfgreen_mat(k,kk)*1.e8 

	      end do                                                           
	   end do                                                              

	apr='  pfgreen '
c	call out42(n_pr,a_print,num,apr)

	   do k=1,kloop                                                        
	      do kk=1,ncam

		 vesgreen(k,kk)=vesgreen_mat(k,kk)*1.e8 

	      end do                                                           

	   end do                                                              
	apr='  vesgreen '
c	call out42(n_pr,a_print,num,apr)

	end if                                                                 

                                                                        

	if(kprobe.gt.0)then                                                    
	a_print(4)=kprobe
	apr='  kprobe '
c	call out42(n_pr,a_print,num,apr)

	   do k=1,kprobe                                                       

	apr='  k '
	a_print(1)=k
	n_pr=1
c	call out42(n_pr,a_print,num,apr)
	      do kk=1,nwnh                                                     

		 bprgreen(kk,k)=bprgreen_mat(kk,k)*1.e4

	      end do
	   end do                                                              
	apr='  bprgreen '
c	call out42(n_pr,a_print,num,apr)

	   do k=1,kprobe                                                       
	      do kk=1,npf

		 pfprobe(k,kk)=pfprobe_mat(k,kk)*1.e4

	      end do                                                           
	   end do                                                              
	apr='  pfprobe '
c	call out42(n_pr,a_print,num,apr)

	   do k=1,kprobe                                                       
	      do kk=1,ncam

		 vesprobe(k,kk)=vesprobe_mat(k,kk)*1.e4

	      end do                                                           
	   end do                                                              

	apr='  vesprobe '
c	call out42(n_pr,a_print,num,apr)

	end if                                                                 

        RETURN                                                          

        END                                                             
      subroutine solpsza()
	include 'double.inc'

      include 'parf0'

	common
     *	/n_m/n,m,mp

	common 
     *  /c_temp4/wdrp
!     *  /c_temp5/YTe,YTi,YGsep,Yne,YGsol
!     *  /c_temp6/YPsol,Ycnim,YSeng,Yqpk,Yndt
     *  /c_temp5/YMU,YPsol,YPalp,YSeng,YdNdt,YAim,Ycnim,YPedPi,
     .	YGdt,YGpuf,YGpel,YGhe,YGsol,YGsep,
     .	Ypn,Yqpk,Yndt,YnHe,Yne,YTe,YTi,
     .	yGELM,yGLFS



     */en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),
     *WE0(npo),WQ0(npo)


        common
     *	/v_surface/s,v

	common /c_temp6/wdr_d,wdr_t,WEL,wio

     			YMU=0.8d0
!            YPsol=10.d0
            YPalp=0.d0
            YSeng=57.d0
            YAim=20.d0
            Ycnim=0.02d0
            YPedPi=1.d0


!            WDRp=(WD0(N)+WT0(N)+WH0(N))*2.*PI

     			YGsol=wdrp*1.d3
     			
     			if(kpr.eq.1)print *,' YGsol YPsol=',YGsol,YPsol
     			if(kpr.eq.1)print *,' wdr_d,wdr_t=',wdr_d,wdr_t
     			if(kpr.eq.1)print *,' WEL,wio=',WEL,wio
     			if(kpr.eq.1)print *,' Sp=',s
     			
     			yGELM=0.d0
     			yGLFS=0.d0

!     YMU, 	[a.u.], 0.2<mu<1 in SOLPS mu=1 corresponds to attachment - =0.8 - comment by Victor 
!	YPsol, 	[MW] power to SOL 
!	YPalp,	[MW] power in alpha particle -----comment by victor from Pacher 
! 	YSeng, 	[m3/s] pumping speed - =57 - comment by Victor
! 	YAIM,	[a.u.] sort of imp. in atomic units - =20 for Neon - comment by Victor
!	Ycnim,	nim/ne fraction of impurity at sep.
!	YPedPi, [a.u.]	Pe/Pi=1 by Polevoi - comment by Victor
!	YGsol,	[10^19/s] sink of DT to the SOL by diffusion
!	YGELM,  [10^19/s] sink of DT to the SOL with ELMs =0 still now - comment by Victor
!	yGLFS,	[10^19/s] sink of DT to the SOL from LFS pellet drift (ideal) =0 - comment by Victor

	call solpsz2(
     .			YMU,YPsol,YPalp,YSeng,YdNdt,YAim,Ycnim,YPedPi,
     .			YGdt,YGpuf,YGpel,YGhe,YGsol,YGsep,
     .			Ypn,Yqpk,Yndt,YnHe,Yne,YTe,YTi
     .		,yGELM,yGLFS)


     			if(kpr.eq.1)print *,' YTe,YTi=',YTe,YTi
     			if(kpr.eq.1)print *,' YGsep,Yne ,Yndt=',YGsep,Yne,Yndt

      te0(n)=YTe*1.d3
      tq0(n)=YTi*1.d3

	return
	end



      subroutine solpsza_old(yfluxd_xx,yfluxt_xx,yfluxe_xx,
     *  yfluxi_xx,ysbound_xx)

	include 'double.inc'

      include 'parf0'

	common
     *	/n_m/n,m,mp
      common
     *  /ge5/kpr

	common 
     *  /c_temp4/wdrp
!     *  /c_temp5/YTe,YTi,YGsep,Yne,YGsol
!     *  /c_temp6/YPsol,Ycnim,YSeng,Yqpk,Yndt
     *  /c_temp5/YMU,YPsol,YPalp,YSeng,YdNdt,YAim,Ycnim,YPedPi,
     .	YGdt,YGpuf,YGpel,YGhe,YGsol,YGsep,
     .	Ypn,Yqpk,Yndt,YnHe,Yne,YTe,YTi,
     .	yGELM,yGLFS


     */en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),
     *WE0(npo),WQ0(npo)

        common
     *	/v_surface/s,v

	common /c_temp6/wdr_d,wdr_t,WEL,wio


     			YMU=0.8d0
!            YPsol=10.d0
            YPalp=0.d0
            YSeng=57.d0
            YAim=20.d0
            Ycnim=0.02d0
            YPedPi=1.d0

	   wdrp=wdr_d+wdr_t

!            WDRp=(WD0(N)+WT0(N)+WH0(N))*2.*PI
     			YGsol=wdrp*1.d3

    			yGELM=0.d0
     			yGLFS=0.d0

     			YMU_xx=YMU
            YPalp_xx=YPalp
            YSeng_xx=YSeng
            YAim_xx=YAim
            Ycnim_xx=Ycnim
            YPedPi_xx=YPedPi
     			YGsol_xx=YGsol
     			
     			if(kpr.eq.1)print *,' YGsol YPsol=',YGsol,YPsol
     			if(kpr.eq.1)print *,' wdr_d,wdr_t=',wdr_d,wdr_t
     			if(kpr.eq.1)print *,' WEL,wio=',WEL,wio
     			if(kpr.eq.1)print *,' Sp=',s

            yfluxd_xx=wdr_d
            yfluxt_xx=wdr_t
            yfluxe_xx=WEL
            yfluxi_xx=wio
            ysbound_xx=s

  			
     			yGELM_xx=yGELM
     			yGLFS_xx=yGLFS

!     YMU, 	[a.u.], 0.2<mu<1 in SOLPS mu=1 corresponds to attachment - =0.8 - comment by Victor 
!	YPsol, 	[MW] power to SOL 
!	YPalp,	[MW] power in alpha particle -----comment by victor from Pacher 
! 	YSeng, 	[m3/s] pumping speed - =57 - comment by Victor
! 	YAIM,	[a.u.] sort of imp. in atomic units - =20 for Neon - comment by Victor
!	Ycnim,	nim/ne fraction of impurity at sep.
!	YPedPi, [a.u.]	Pe/Pi=1 by Polevoi - comment by Victor
!	YGsol,	[10^19/s] sink of DT to the SOL by diffusion
!	YGELM,  [10^19/s] sink of DT to the SOL with ELMs =0 still now - comment by Victor
!	yGLFS,	[10^19/s] sink of DT to the SOL from LFS pellet drift (ideal) =0 - comment by Victor

	call solpsz2(
     .			YMU,YPsol,YPalp,YSeng,YdNdt,YAim,Ycnim,YPedPi,
     .			YGdt,YGpuf,YGpel,YGhe,YGsol,YGsep,
     .			Ypn,Yqpk,Yndt,YnHe,Yne,YTe,YTi
     .		,yGELM,yGLFS)

      
     			if(kpr.eq.1)print *,' YTe,YTi=',YTe,YTi
     			if(kpr.eq.1)print *,' YGsep,Yne=',YGsep,Yne

      te0(n)=YTe*1.d3
      tq0(n)=YTi*1.d3

	return
	end



      subroutine solpsza_example(yfluxd_xx,yfluxt_xx,yfluxe_xx,
     *  yfluxi_xx,ysbound_xx)

	include 'double.inc'

      include 'parf0'

	common
     *	/n_m/n,m,mp
      common
     *  /ge5/kpr

	common 
     *  /c_temp4/wdrp
!     *  /c_temp5/YTe,YTi,YGsep,Yne,YGsol
!     *  /c_temp6/YPsol,Ycnim,YSeng,Yqpk,Yndt
     *  /c_temp5/YMU,YPsol,YPalp,YSeng,YdNdt,YAim,Ycnim,YPedPi,
     .	YGdt,YGpuf,YGpel,YGhe,YGsol,YGsep,
     .	Ypn,Yqpk,Yndt,YnHe,Yne,YTe,YTi,
     .	yGELM,yGLFS


     */en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),
     *WE0(npo),WQ0(npo)

!        common
!     *	/v_surface/s,v

	common /c_temp6/wdr_d,wdr_t,WEL,wio
	common /c_temp7/s_bound


     			YMU=0.8d0
!            YPsol=10.d0
            YPalp=0.d0
            YSeng=57.d0
            YAim=20.d0
            Ycnim=0.02d0
            YPedPi=1.d0

!            WDRp=(WD0(N)+WT0(N)+WH0(N))*2.*PI
     			YGsol=wdrp*1.d3

    			yGELM=0.d0
     			yGLFS=0.d0

     			YMU_xx=YMU
            YPalp_xx=YPalp
            YSeng_xx=YSeng
            YAim_xx=YAim
            Ycnim_xx=Ycnim
            YPedPi_xx=YPedPi
     			YGsol_xx=YGsol
     			
     			if(kpr.eq.1)print *,' YGsol YPsol=',YGsol,YPsol
     			if(kpr.eq.1)print *,' wdr_d,wdr_t=',wdr_d,wdr_t
     			if(kpr.eq.1)print *,' WEL,wio=',WEL,wio
     			if(kpr.eq.1)print *,' Sp=',s_bound

            yfluxd_xx=wdr_d
            yfluxt_xx=wdr_t
            yfluxe_xx=WEL
            yfluxi_xx=wio
            if(s_bound.gt.10.d0)then
            else
            s_bound=10.d0
            end if
            ysbound_xx=s_bound
            

  			
     			yGELM_xx=yGELM
     			yGLFS_xx=yGLFS

!     YMU, 	[a.u.], 0.2<mu<1 in SOLPS mu=1 corresponds to attachment - =0.8 - comment by Victor 
!	YPsol, 	[MW] power to SOL 
!	YPalp,	[MW] power in alpha particle -----comment by victor from Pacher 
! 	YSeng, 	[m3/s] pumping speed - =57 - comment by Victor
! 	YAIM,	[a.u.] sort of imp. in atomic units - =20 for Neon - comment by Victor
!	Ycnim,	nim/ne fraction of impurity at sep.
!	YPedPi, [a.u.]	Pe/Pi=1 by Polevoi - comment by Victor
!	YGsol,	[10^19/s] sink of DT to the SOL by diffusion
!	YGELM,  [10^19/s] sink of DT to the SOL with ELMs =0 still now - comment by Victor
!	yGLFS,	[10^19/s] sink of DT to the SOL from LFS pellet drift (ideal) =0 - comment by Victor

!	call solpsz2(
!     .			YMU,YPsol,YPalp,YSeng,YdNdt,YAim,Ycnim,YPedPi,
!     .			YGdt,YGpuf,YGpel,YGhe,YGsol,YGsep,
!     .			Ypn,Yqpk,Yndt,YnHe,Yne,YTe,YTi
!     .		,yGELM,yGLFS)

      
     			if(kpr.eq.1)print *,' YTe,YTi=',YTe,YTi
     			if(kpr.eq.1)print *,' YGsep,Yne=',YGsep,Yne
  	      if(kpr.eq.1)print *,' ysbound=',ysbound_xx


	return
	end
      subroutine solpsza_example_in(YTe_xx,YTi_xx)

	include 'double.inc'

      include 'parf0'

	common
     *	/n_m/n,m,mp
      common
     *  /ge5/kpr

	common 
     *  /c_temp5/YMU,YPsol,YPalp,YSeng,YdNdt,YAim,Ycnim,YPedPi,
     .	YGdt,YGpuf,YGpel,YGhe,YGsol,YGsep,
     .	Ypn,Yqpk,Yndt,YnHe,Yne,YTe,YTi,
     .	yGELM,yGLFS

        YTe=YTe_xx*1.d-3
        YTi=YTi_xx*1.d-3
      
   	if(kpr.eq.1)print *,' YTe,YTi In =',YTe_xx,YTi_xx

	return
	end
      subroutine solpszb()

	include 'double.inc'

      include 'parf0'

	common
     *	/n_m/n,m,mp
      common
     *  /ge5/kpr

	common 
     *  /c_temp5/YMU,YPsol,YPalp,YSeng,YdNdt,YAim,Ycnim,YPedPi,
     .	YGdt,YGpuf,YGpel,YGhe,YGsol,YGsep,
     .	Ypn,Yqpk,Yndt,YnHe,Yne,YTe,YTi,
     .	yGELM,yGLFS


     */en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),
     *WE0(npo),WQ0(npo)


      te0(n)=YTe*1.d3
      tq0(n)=YTi*1.d3
     
   	if(kpr.eq.1)print *,' YTe,YTi B=',YTe,YTi

	return
	end

!> dina_data_read is the main subroutine to read the input
!! dina_data.dat and general_data.dat files

  	subroutine dina_data_read()
	include 'double.inc'
c-----------------------------------------
c	implicit real*8 (a-h,o-z)
	include 'parf1'
 	include 'parf_mike' 
        common
     *  /ge5/kpr

      common /c_tokamak_config1/
     * npf_c,
     * npf_res_c,
     * ncam_c,
     * kloop_c,
     * kprobe_c,kpb_c,
     * ke_c

      common /c_tokamak_config2/
     * nr_c(mu),nz_c(mu),nt_c(mu),n_pf_num_c(mu),
     * R_c_c(mu),Z_c_c(mu),dr_c(mu),dz_c(mu),alpha_c(mu),beta_c(mu),
     * pfres_c(mu),
     * ndl_ves_c(mu),ndh_ves_c(mu),nt_ves_c(mu),n_ves_num_c(mu),
     * Rc_c(mu),Zc_c(mu),dl_c(mu),hl_c(mu),alpha_ves_c(mu),
     * beta_ves_c(mu),
     * rcam_c(mu),
     * Rl_c(mu),Zl_c(mu),
     * R_prob_c(mu),Z_prob_c(mu),anglep_c(mu),smp_c(mu),
     * xu_c(mu),yu_c(mu),
     * r00_c,rk_c,
     * z00_c,zk_c


      common /c_k_jetto/ih_imas_c
      common /c_time_eq/time_eq_c

      common /c_jetto_ids/pulse_c,run_c
      
      common /c_kpr/kpr_c

      common /c_for002_kav/tay_c,rs0_c,bt0_c,key_t11_c

      common /c_gaps_data_ramp/x_gaps_c(mu),y_gaps_c(mu),n_ga_c

      common /c_tran_times/tt_dina_c

      common /c_pfres/t_t_c1(ntime),pf_t_c1(kf,ntime),n_t_c1,npf_c1


      common /c_ech_c2/t_t_c2(ntime),udd_sol_t_c2(ntime),n_t_c2

      common /c_nd_c3/t_t_c3(ntime),pn_d_t_c3(ntime),n_t_c3


      common /c_gamma_z_c4/t_t_c4(ntime),pn_d_t_c4(ntime),
     *  n_t_c4,nz_imp_c4

      common /c_gamma_z2_c5/t_t_c5(ntime),pn_d_t_c5(ntime),
     *  n_t_c5,nz_imp2_c5

      common /c_init_c6/p_c6,T_e_c6,T_i_c6,gam_c6,g_gain_c6


      common /c_emo_c7/t_t_c7(ntime),emoe_t_c7(ntime),emoq_t_c7(ntime),
     *  n_t_c7

      common /c_dens_c8/t_t_c8(ntime),den_t_c8(ntime),n_t_c8

      common /c_gamma_z1_c9/t_t_c9(ntime),pn_d_t_c9(ntime),
     *  n_t_c9,nz_imp1_c9

      common /c_gamma_z3_c10/t_t_c10(ntime),pn_d_t_c10(ntime),
     *  n_t_c10,nz_imp3_c10

      common /c_gamma_z4_c11/t_t_c11(ntime),pn_d_t_c11(ntime),
     *  n_t_c11,nz_imp4_c11



      common /c_bohm_gbohm_c12/k_Bohm_c12
      common /c_tay_simul_c13/tay_simul_c13
      common /c_dw_c14/tay_dw_c14
      common /c_pcchp_end_c15/pcchp_end_c15
      common /c_ext_c16/k_ener_ext_c16,k_dens_ext_c16,k_ajb_ext_c16


      
      kpr=1
      
     	open(unit=49,file='dina_data.dat',
!!!     	open(unit=41,file='tokamak_config.dat',
     *  form='formatted')
	if(kpr.eq.1)print *,' opened file tokamak_config.dat'
	read(49,*)
	if(kpr.eq.1)print *,' 1'
	read(49,*)npf_c
	if(kpr.eq.1)print *,'npf ',npf_c
	do I=1,npf_c
	read(49,*)
	read(49,*)nr_c(i),nz_c(i),nt_c(i),n_pf_num_c(i)
c
	if(kpr.eq.1)PRINT*,'i Nr Nz nt pf_num',i,Nr_c(I),nz_c(i),
     *  nt_c(i),n_pf_num_c(i)
	read(49,*)R_c_c(I),Z_c_c(I),dr_c(i),dz_c(i),alpha_c(i),beta_c(i)
	if(kpr.eq.1)print *,'r_c z_c dr dz alpha beta ',
     * r_c_c(i),z_c_c(i),dr_c(i),dz_c(i),alpha_c(i),beta_c(i)
	END DO


	read(49,*)
	if(kpr.eq.1)print *,' res_pf'
	read(49,*)npf_res_c
	if(kpr.eq.1)print *,'npf_res ',npf_res_c
	do I=1,npf_res_c
	read(49,*)pfres_c(i)
	if(kpr.eq.1)print *,' i pfres(i)',i,pfres_c(i)
      end do
      
	read(49,*)
	if(kpr.eq.1)print *,' Vessel'
	read(49,*)ncam_c
	if(kpr.eq.1)print *,'ncam ',ncam_c
	do I=1,ncam_c
	read(49,*)
	read(49,*)ndl_ves_c(i),ndh_ves_c(i),nt_ves_c(i),n_ves_num_c(i)
c
	if(kpr.eq.1)PRINT*,'i N M nt ves_n',i,Ndl_ves_c(I),
     *  ndh_ves_c(i),nt_ves_c(i),n_ves_num_c(i)
	read(49,*)Rc_c(I),Zc_c(I),dl_c(i),hl_c(i),alpha_ves_c(i),beta_ves_c(i)
	if(kpr.eq.1)print *,'r_c z_c dr dz alpha beta ',
     * rc_c(i),zc_c(i),dl_c(i),hl_c(i),alpha_ves_c(i),beta_ves_c(i)
	END DO


	read(49,*)
	if(kpr.eq.1)print *,' res_ves'
	read(49,*)ncam_c
	if(kpr.eq.1)print *,'ncam ',ncam_c
	do I=1,ncam_c
	read(49,*)rcam_c(i)
	if(kpr.eq.1)print *,' i rcam(i)',i,rcam_c(i)
      end do


	read(49,*)
	if(kpr.eq.1)print *,' Flux loops'
	read(49,*)kloop_c
	if(kpr.eq.1)print *,'kloop ',kloop_c
	do I=1,kloop_c

	read(49,*)Rl_c(I),Zl_c(I)
	if(kpr.eq.1)print *,'r_l z_l ',rl_c(i),zl_c(i)
	END DO


	read(49,*)
	if(kpr.eq.1)print *,' Probe'
	read(49,*)kprobe_c,kpb_c
	if(kpr.eq.1)print *,'kprobe,kpb ',kprobe_c,kpb_c
	do I=1,kprobe_c
	read(49,*)R_prob_c(I),Z_prob_c(I),anglep_c(i),smp_c(i)
	if(kpr.eq.1)print *,'r_pr z_pr alpha smp ',
     * R_prob_c(I),Z_prob_c(I),anglep_c(i),smp_c(i)
	END DO

	read(49,*)
	if(kpr.eq.1)print *,' limiter'
	read(49,*)ke_c
	if(kpr.eq.1)print *,'ke ',ke_c
	do I=1,ke_c

	read(49,*)xu_c(I),yu_c(I)
	if(kpr.eq.1)print *,'xu yu ',xu_c(I),yu_c(I)
	END DO

      read(49,*)    
	read(49,*)r00_c,rk_c
      read(49,*)z00_c,zk_c
	if(kpr.eq.1)print *,'r00,rk ',r00_c,rk_c
	if(kpr.eq.1)print *,'z00,zk ',z00_c,zk_c


      return
      

! 		 open (unit=41,file='k_jetto.dat',form='formatted') 
       read (49,*) 
       read (49,*)ih_imas_c
          
! 		 open (unit=40,file='time_eq.dat',form='formatted') 
        read (49,*) 
        read (49,*)time_eq_c
          
!        open(unit=2,file='jetto_ids.dat',form='formatted',action='read')
        read(49,*)
        read(49,*) pulse_c
        read(49,*)
        read(49,*) run_c

!        open (unit=1,file='kpr.dat',form='formatted')

        read (49,*)
        read (49,*)kpr_c

!     	open(unit=2,file='for002_kav',form='formatted')

	read (49,*)
	read (49,*)tay_c,rs0_c,key_t11_c,bt0_c

!	open(unit=40,status='old',file='gaps_data_ramp',form='formatted')
	read (49,*)
	read (49,*)n_ga_c
	read (49,*)
	read (49,*)(x_gaps_c(i),i=1,n_ga_c)
	read (49,*)
	read (49,*)(y_gaps_c(i),i=1,n_ga_c)

!        open (unit=1,file='tran_times.dat',form='formatted')
        read (49,*)
        read (49,*)tt_dina_c

!           open (unit=41,file='pfres.dat',form='formatted') 
           read (49,*) 
           read (49,*)n_t_c1 

           read (49,*) 

          npf_c1=npf_res_c
           do i=1,n_t_c1 
              read (49,*)t_t_c1(i),(pf_t_c1(k,i),k=1,npf_c1)
           end do 

!           open (unit=41,file='ech.dat',form='formatted') 
           read (49,*) 
           read (49,*)n_t_c2 
           read (49,*) 


           do i=1,n_t_c2 
              read (49,*)t_t_c2(i),udd_sol_t_c2(i)
           end do 

!           open (unit=41,file='n_d.dat',form='formatted') 
           read (49,*) 
           read (49,*)n_t_c3 
           read (49,*) 
           
           
           do i=1,n_t_c3 
              read (49,*)t_t_c3(i),pn_d_t_c3(i)
           end do 

!           open (unit=41,file='gamma_z.dat',form='formatted') 
           read (49,*) 
           read (49,*)n_t_c4,nz_imp_c4 
           read (49,*) 
           
           do i=1,n_t_c4 
              read (49,*)t_t_c4(i),pn_d_t_c4(i)
           end do 

!           open (unit=41,file='gamma_z2.dat',form='formatted') 
           read (49,*) 
           read (49,*)n_t_c5,nz_imp2_c5 
           read (49,*) 
           
           do i=1,n_t_c5 
              read (49,*)t_t_c5(i),pn_d_t_c5(i)
           end do 

!	open (unit=41,file='init.dat',form='formatted')
        read (49,*)p_c6
        read (49,*)T_e_c6
        read (49,*)T_i_c6
        read (49,*)gam_c6
        read (49,*)g_gain_c6

!           open (unit=41,file='emo.dat',form='formatted') 
           read (49,*) 
           read (49,*)n_t_c7 
           
           read (49,*) 
           do i=1,n_t_c7 
              read (49,*)t_t_c7(i),emoe_t_c7(i),emoq_t_c7(i)
           end do 

!           open (unit=41,file='dens.dat',form='formatted') 
           read (49,*) 
           read (49,*)n_t_c8 
           read (49,*) 

           do i=1,n_t_c8 
              read (49,*)t_t_c8(i),den_t_c8(i)
           end do 



!           open (unit=41,file='gamma_z1.dat',form='formatted') 
           read (49,*) 
           read (49,*)n_t_c9,nz_imp1_c9 
           read (49,*) 
           
           do i=1,n_t_c9 
              read (49,*)t_t_c9(i),pn_d_t_c9(i)
           end do 
           
!           open (unit=41,file='gamma_z3.dat',form='formatted') 
           read (49,*) 
           read (49,*)n_t_c10,nz_imp3_c10 
           read (49,*) 
           
           do i=1,n_t_c10 
              read (49,*)t_t_c10(i),pn_d_t_c10(i)
           end do 
!           open (unit=41,file='gamma_z4.dat',form='formatted') 
           read (49,*) 
           read (49,*)n_t_c11,nz_imp4_c11 
           read (49,*) 
           
           do i=1,n_t_c11 
              read (49,*)t_t_c11(i),pn_d_t_c11(i)
           end do 

!                 open (unit=41,file='bohm_gbohm.dat',form='formatted')
                read (49,*)
                read (49,*) k_Bohm_c12
!           open (unit=41,file='tay_simul.dat',form='formatted') 
           read (49,*) 
           read (49,*)tay_simul_c13

!          open (unit=40,file='dw.dat',form='formatted') 
          read (49,*) 
!          read (40,*)tt_dw,tay_dw
          read (49,*)tay_dw_c14

!           open (unit=40,file='pcchp_end.dat',form='formatted') 
        read (49,*)
        read (49,*)pcchp_end_c15

          read (49,*) 
          read (49,*)k_ener_ext_c16, k_dens_ext_c16,k_ajb_ext_c16

	close(49)

2	FORMAT(/,2(2x,1PE10.3))


71 	format (20x,a6/,(6(1pe10.3)))
      RETURN
      END
	subroutine general_data_read()
c------------------------------------
c  read PF coil currents
c----------------------------------
	include 'double.inc'
c	implicit real*8 (a-h,o-z)
	include 'parf1'
        COMMON
     *  /pf1/npf,pf(kf),pf0(kf)
        common
     *  /ge5/kpr
	CHARACTER*120 fshot,tmp
	dimension a(190)

      common /c_scr_data_c1/pf_c1(kf)
      
      common /c_tt_kavin2_c1/tt_rampup_c1,dt_end_sim_c1,
     * dtpl_term_l_c1,cIp_end_c1,CS1_eob_c1,rms_noise_c1



      return
      
cc

      kpr_help=kpr
      kpr=1
      npf_2=13
      
	if(kpr.eq.1)PRINT*,'Open scr_data from TOK'
!      open (unit=39,file='scr_data.dat',form='formatted')
      open (unit=39,file='general_data.dat',form='formatted')

      read (39,*)
      read (39,*)nn
      read (39,*)
      read (39,*)(a(i),i=1,npf_2)
c
	do i=1,11
      pf(i)=a(2+i)*1.e3
	pf0(i)=pf(i)

      pf_c1(i)=pf(i)


	end do
c
      if(kpr.eq.1)print *,' nn npf=npf_2',nn,npf,npf_2
      
	if(kpr.eq.1)PRINT*,'CURRENTS'
	if(kpr.eq.1)PRINT 7,(Pf(i),i=1,11)
	if(kpr.eq.1)PRINT 7,(Pf_c1(i),i=1,11)
7 	format (20(1p,E14.6))
!	close(40)

      kpr=kpr_help

	if(kpr.eq.1)PRINT*,'a'
	if(kpr.eq.1)PRINT 7,(a(i),i=1,npf_2)
      do ii=2,nn
      if(kpr.eq.1)print *,' ii=',ii
      read (39,*)(a(i),i=1,npf_2)
	if(kpr.eq.1)PRINT 7,(a(i),i=1,npf_2)
      end do

5000    format (8(1pe14.6))
      
c 


!          open (unit=40,file='tt_kavin2.dat',form='formatted') 
          read (39,*) 
          read (39,*)tt_rampup
          read (39,*) 
          read (39,*)dt_end_sim,dtpl_term_l,cIp_end
          
          tt_rampup_c1=tt_rampup
          dt_end_sim_c1=dt_end_sim
          dtpl_term_l_c1=dtpl_term_l
          cIp_end_c1=cIp_end

          dtpl_term_h=0
          
          read (39,*) 
          read (39,*)CS1_eob,rms_noise


          CS1_eob_c1=CS1_eob
          rms_noise_c1=rms_noise


	  close (39)

      
!      stop
      
c
71 	format (20x,a6/,(8(1pe10.3)))
C
	RETURN
	END
	
	
	        subroutine psi_pl_test(f_x,pspl_x)
        include 'double.inc'

        dimension f_x(*),pspl_x(*)

        include 'new_com.inc'

        call psi_pl_test_c(al1_x,f_x,errm_x,
     *  dx,dy,x,y,coef,pspl_x)

        return
        end

        subroutine psi_pl_test_c(al1,u_h,errm,
     *  dx,dy,x,y,coef,pspl)
        include 'double.inc'

        dimension x(*),y(*),u_h(*),pspl(*)
        
        include 'parf0'
        include 'parf2'

        real *8  a_fur(nr),b_fur(nr),c_fur(nr),f_fur(nr,nz),x_fur(nr),
     *  y_fur(nz)

c-----------------------------------

        real *8  a_r(nr),b_r(nr),c_r(nr)
        real *8  a_z(nz),b_z(nz),c_z(nz)

        real * 8 a_s(nn,mm),b_s(nn,mm),c_s(nn,mm),d_s(nn,mm),
     *  f_s(nn,mm),e_s(nn,mm),u_s(nn,mm),f_help(nn,mm),t_help(nn,mm)

        real *8 right,rleft,delr,delz,dlr2,dlz2,rw

        common
     *  /c_bound4/i_bound
     *  /ge5/kpr

        CHARACTER *70 APR
71      FORMAT(20X,A8/,(6(1X,1PE10.3)))


        delr=dx
        delz=dy

        dlr2=delr**2
        dlz2=delz**2

        do i=1,nr
           x_fur(i)=x(i)
        end do

        do i=1,nz
           y_fur(i)=y(i)
        end do

c---------------------------------------        
        i_fur=1
        i_solver=0
c-----------------------------------------------
        i_sym=0

c TEMPORARILY


        i_solver=0
        i_sym=1



        if(i_sym.eq.1)then
c----------------------------------------------------

        do i=2,nr-1

        rw=x(i)   

        a_r(i)=-2.*rw/( dlr2*(x_fur(i)+x_fur(i-1)) )

        b_r(i)=-2.*rw/( dlr2 )*( -1./( x_fur(i)+x_fur(i+1) )-1./
     *   ( x_fur(i)+x_fur(i-1)) )

        c_r(i)=-2.*rw/( dlr2*(x_fur(i)+x_fur(i+1)) )
        
        a_fur(i)=-a_r(i)
        c_fur(i)=-c_r(i)
        b_fur(i)= b_r(i)

        end do

        else

        do i=2,nr-1

        rw=x(i)

        a_r(i)=-1.*( 1./dlr2+1./(rw*delr*2.) )
        b_r(i)=-1.*( -2./dlr2 )
        c_r(i)=-1.*( 1./dlr2-1./(rw*delr*2.) )


        a_fur(i)=-a_r(i)
        c_fur(i)=-c_r(i)
        b_fur(i)= b_r(i)

        end do

        end if

        do i=1,nz
        a_z(i)=-1.*(1./dlz2)
        b_z(i)=-1.*(-2./dlz2)
        c_z(i)=-1.*(1./dlz2)
        end do

c------------------------------
c  definition for sore ....
C       EQUATION A(i,j)*U(i+1,j)+B(i,j)*U(i-1,j)+
C        C(i,j)*U(i,j+1)+D(i,j)*U(i,j-1)+E(i,j)*U(i,j)=F(i,j)
c--------------------------------
c       j_r=a_r(i)*p_pl(i-1,j)+b_r(i)*p_pl(i,j)+c_r(i)*p_pl(i+1,j)
c       j_z=a_z(i)*p_pl(i,j-1)+b_z(i)*p_pl(i,j)+c_z(i)*p_pl(i,j+1)
c       j_tor=j_r+j_z
c---------------------------------

        do i=1,nr
        do j=1,nz
c   a_s(i,j)*u(i+1,j) :
        a_s(i,j)=c_r(i)
c   b_s(i,j)*u(i-1,j) :
        b_s(i,j)=a_r(i)
c   c_s(i,j)*u(i,j+1) :
        c_s(i,j)=c_z(j)
c   d_s(i,j)*u(i,j-1) :
        d_s(i,j)=a_z(j)
c   e_s(i,j)*u(i,j) :
        e_s(i,j)=(b_r(i)+b_z(j))
        end do
        end do

c----------------------------
        n1=nr-1
        m1=nz-1

        coef1=coef*dx*dy


        tok_pl=0.
        DO I=1,nr
           DO J=1,nz
              kk=(i-1)*nz+j
              tok_pl=tok_pl+u_h(kk)*coef1
           end do
        end do

        if(kpr.eq.1)print *,' tok_pl BEFORE',tok_pl


        DO I=1,nr
           DO J=1,nz
              kk=(i-1)*nz+j

              u_s(i,j)=pspl(kk)

              t_help(i,j)=u_s(i,j)

              f_s(i,j)=u_h(kk)*x(i)

              f_fur(i,j)=-f_s(i,j)
           END DO
        END DO

        errm=0.
        DO I=2,n1
           DO J=2,m1

              rleft=a_s(i,j)*u_s(i+1,j)+b_s(i,j)*u_s(i-1,j)+
     *  c_s(i,j)*u_s(i,j+1)+d_s(i,j)*u_s(i,j-1)+e_s(i,j)*u_s(i,j)

           right=f_s(i,j)
           kk=(i-1)*nz+j

           err=abs(rleft-right)
           if(err.gt.errm)then
              errm=err
              f_s_max=f_s(i,j)
              imax=i
              jmax=j
           end if
              
        END DO
        END DO

        if(kpr.eq.1)print *,' imax jmax NEV f_s',imax,jmax,errm,f_s_max



        return
        end
