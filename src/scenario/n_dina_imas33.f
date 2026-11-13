!> In subroutine dina_0 as a result of call dina2 and then call equil2 or 
!> call equil according to tt_kavin value the DINA modeling of one time step is
!> being produced
      subroutine dina_0()


	   real *8 a_print(200)
	
      integer, parameter :: kint = 200
      ! dynamic inputs and outputs groups
      real*8 :: c_input_1(kint) = (/ (0,i=1,kint) /)
      real*8 :: c_input_2(kint) = (/ (0,i=1,kint) /)
   
      real*8 :: c_output_1(kint) = (/ (0,i=1,kint) /)
      real*8 :: c_output_2(kint) = (/ (0,i=1,kint) /)
      real*8 :: c_output_3(kint) = (/ (0,i=1,kint) /)

	   character *25 apr


	   call dina2(
!     *  c_input1,c_input2,
!     *  c_output1,c_output2,c_output3)

     *  c_input_1,c_input_2,
     *  c_output_1,c_output_2,c_output_3)

      return
      end subroutine

      
!> dina_outp is a subroutine to collect the output data to write them after that 
!> to IDSs in dina_imas subroutine 
	subroutine dina_outp_tr(n_xx, tpl_xx, tt_xx,
     * a_xx,psi_tr_xx,q_xx,
     * sigma_xx,tok1_xx,ajb_xx,aj0_xx,ajae_xx,
     * surface_1d_xx,volume_1d_xx,area_1d_xx,
     * te0_xx,tq0_xx,press_xx,zeff_xx,
     * qe0_xx,qq0_xx,
     * pne_xx,pd0_xx,pt0_xx,
     * psi_ax_xx, psi_bnd_xx,
     * ksepa_xx,key_lh_xx,
     * betap_xx,betat_xx,
     * tene_xx,teit_98_xx)


	include 'double.inc'
	include 'new_com.inc'
     

	dimension a_xx(*),psi_tr_xx(*),tok1_xx(*),q_xx(*)
        dimension sigma_xx(*),ajb_xx(*),ajae_xx(*),aj0_xx(*)
        dimension te0_xx(*),tq0_xx(*),qe0_xx(*),qq0_xx(*)
	dimension pne_xx(*),pd0_xx(*),pt0_xx(*)
        dimension press_xx(*),zeff_xx(*)
        dimension surface_1d_xx(*),volume_1d_xx(*),area_1d_xx(*)
        
        dimension f_temp(npo)
        
        include 'imas_interface.inc'

       	character *20 apr
        
        print *,' Output kpr n==',kpr,n   
        
        n_xx=n
	
	tpl_xx = tpl_dir*tpl*1000.d0
	
!	print *,' n_xx tpl_xx=',n_xx,tpl_xx

	tt_xx=tt/1000.d0
	!tt_xx=(tt-tay)/1000.d0
	
        betap_xx = betj
        betat_xx = bett

	tene_xx = tene*1.d-3
        teit_98_xx = teit_98*1.d-3
        
        key_lh_xx = key_lh
      
        print *,' dina_output_tr key_lh key_lh_xx =', key_lh, key_lh_xx
        
        psi_ax_xx = tpl_dir*pmag*1.d-5*2.*pi
        psi_bnd_xx = tpl_dir*pbound*1.d-5*2.*pi
        
        ksepa_xx = ksepa 
        
        
        
        ai(n+1)=1.d0
        teta_xx=1.d0

        call inter_h0(sigk,ai,n,teta_xx,val)
        sigk(n+1)=val
        sigk(1)=sigk(2)
        do i=2,n-1             
           call linear(n,sigk,f_temp(i),ai,a(i))
        enddo
        f_temp(1) = sigk(1)
        f_temp(n) = sigk(n+1)

      apr='--f_sigk-' 
      if(kpr.eq.1)print 71,apr,(f_temp(i),i=1,n) 
      
      do i=1,n
      sigk(i)=f_temp(i)
      end do
      
        call inter_h0(qe0,ai,n,teta_xx,val)
        qe0(n+1)=val
        qe0(1)=qe0(2)
        do i=2,n-1             
           call linear(n,qe0,f_temp(i),ai,a(i))
        enddo
        f_temp(1) = qe0(1)
        f_temp(n) = qe0(n+1)

      apr='--f_qe0-' 
      if(kpr.eq.1)print 71,apr,(f_temp(i),i=1,n) 

      do i=1,n
      qe0(i)=f_temp(i)
      end do


        call inter_h0(qq0,ai,n,teta_xx,val)
        qq0(n+1)=val
        qq0(1)=qq0(2)
        do i=2,n-1             
           call linear(n,qq0,f_temp(i),ai,a(i))
        enddo
        f_temp(1) = qq0(1)
        f_temp(n) = qq0(n+1)

      apr='--f_qq0-' 
      if(kpr.eq.1)print 71,apr,(f_temp(i),i=1,n) 

      do i=1,n
      qq0(i)=f_temp(i)
      end do


   71 FORMAT(20X,A20/,(6(1pE10.3)))


	do i=1,n
	   a_xx(i)=a(i)

	   te0_xx(i)=te0(i)
	   tq0_xx(i)=tq0(i)
	   
	   pne_xx(i)=pne(i)*1.d19
           pd0_xx(i)=pd0(i)*1.d19
           pt0_xx(i)=pt0(i)*1.d19
           
           !sigma_xx(i)=sigma_dina(i)
           sigma_xx(i)=1480.d0*sigk(i)*te0(i)**1.5d0
           
           psi_tr_xx(i) = tpl_dir*dm0(i)*1.d-5
          
           qe0_xx(i)=qe0(i)*1.6d3
           qq0_xx(i)=qq0(i)*1.6d3
	   

	   zeff_xx(i)=zeff(i)

	   surface_1d_xx(i) = s_surf(i)*1.d-4

	end do
	
        ai(n+1)=1.d0
        teta_xx=1.d0
        
        call inter_h0(tok1,ai,n,teta_xx,val)
        tok1(n+1)=val
        tok1(1)=tok1(2)
        do i=2,n-1             
           call linear(n,tok1,f_temp(i),ai,a(i))
        enddo
        f_temp(1) = tok1(1)
        f_temp(n) = tok1(n+1)

      apr='--f_tok1-' 
      if(kpr.eq.1)print 71,apr,(f_temp(i),i=1,n) 

      apr='f_pne-' 
      if(kpr.eq.1)print 71,apr,(pne(i),i=1,n) 

      do i=1,n
      tok1(i)=f_temp(i)
      end do

        call inter_h0(ajb,ai,n,teta_xx,val)
        ajb(n+1)=val
        ajb(1)=ajb(2)
        do i=2,n-1             
           call linear(n,ajb,f_temp(i),ai,a(i))
        enddo
        f_temp(1) = ajb(1)
        f_temp(n) = ajb(n+1)

      apr='--f_ajb-' 
      if(kpr.eq.1)print 71,apr,(f_temp(i),i=1,n) 

      do i=1,n
      ajb(i)=f_temp(i)
      end do

        call inter_h0(aj0,ai,n,teta_xx,val)
        aj0(n+1)=val
        aj0(1)=aj0(2)
        do i=2,n-1             
           call linear(n,aj0,f_temp(i),ai,a(i))
        enddo
        f_temp(1) = aj0(1)
        f_temp(n) = aj0(n+1)

      apr='--f_aj0-' 
      if(kpr.eq.1)print 71,apr,(f_temp(i),i=1,n) 

      do i=1,n
      aj0(i)=f_temp(i)
      end do

        call inter_h0(ajae,ai,n,teta_xx,val)
        ajae(n+1)=val
        ajae(1)=ajae(2)
        do i=2,n-1             
           call linear(n,ajae,f_temp(i),ai,a(i))
        enddo
        f_temp(1) = ajae(1)
        f_temp(n) = ajae(n+1)

      apr='--f_ajae-' 
      if(kpr.eq.1)print 71,apr,(f_temp(i),i=1,n) 

      do i=1,n
      ajae(i)=f_temp(i)
      end do

	
	do i=1,n

	   tok1_xx(i) = tpl_dir*tok1(i)*1.d7 ! Toroidal current density
	   ajb_xx(i) = tpl_dir*ajb(i)*1.d7 ! Bootstrap current density
	   aj0_xx(i) = tpl_dir*aj0(i)*1.d7 ! Current density by NBI CD
	   ajae_xx(i) = tpl_dir*ajae(i)*1.d7 ! Current density by ECRH CD

	end do


	
	do i=1,n
        
           press_xx(i) = p(i)
           
        enddo
        
        ! Defined on ai-grid, to get it on a-grid
        !fpol_xx(i) = f(i)
        !q_xx(i) = q(i)
        
        ai(n+1)=1.d0
        teta_xx=1.d0
        call inter_h0(q,ai,n,teta_xx,val)
        q(n+1)=val
           
           
        q_xx(1) = q(1)
        q_xx(n) = q(n)
        do i=2,n-1
           call linear(n,q,q_xx(i),ai,a(i))
        enddo

      apr='--q-' 
      if(kpr.eq.1)print 71,apr,(q_xx(i),i=1,n) 
      
      	
	volume_1d_xx(1) = 2.d0*pi*vi(1)*ha(1)*1.d-6
	area_1d_xx(1) = spo(1)*ha(1)*1.d-4
	do i=2,n
	   volume_1d_xx(i) = volume_1d_xx(i-1) + 2.d0*pi*vi(i)*ha(i)*1.d-6
           area_1d_xx(i) = area_1d_xx(i-1) + spo(i)*ha(i)*1.d-4          
	enddo
		
	
	if(kpr.eq.1)print *,' tt t_vde=',tt,t_vde

      if(tt.gt.t_vde)then
	print *,' tt t_vde=',tt,t_vde
      stop      
      end if
      

      return
      end




!> dina_outp_eq is a subroutine to collect the output data
!> describing equilibrium
	subroutine dina_outp_eq(n_xx,tpl_xx,tt_xx,
     * rs0_xx,bt0_xx,
     * vchopper_xx,pf_xx,tcam_xx,
     * x_xx,y_xx,psi_xx,curr_d_xx,
     * a_xx,psi_eq_xx,phi_xx,
     * fpol_xx,pptab_xx,fptab_xx,
     * tok1_xx,q_xx,press_xx,
     * surface_1d_xx,volume_1d_xx,area_1d_xx,
     * bprobe_xx,psloop_xx,
     * psi_ax_xx, psi_bnd_xx, psi_sep_xx, psi_sep2_xx,
     * ksepa_xx,
     * n_bnd_xx,xbound_xx,ybound_xx,
     * n_sep_xx,x_sep_xx,y_sep_xx,
     * n_sep2_xx,x_sep2_xx,y_sep2_xx,
     * n_ga_xx,gaps_xx,
     * betap_xx,betat_xx)


	include 'double.inc'
	include 'new_com.inc'

        common /c_imas_curr_d/curr_d(nr,nz)
!     *  /c_ramp2/rsep2,zsep2,psep2
!     *  /vic_008/rsep2_gr,zsep2_gr,rsep2_l,zsep2_l,
!     *           rsep2_r,zsep2_r
!     *  /cont21/n_ga,n_int
!     *  /cont20/x_gaps(kf_c),y_gaps(kf_c),gaps(kf_c),n_gaps
        
        dimension vchopper_xx(*),pf_xx(*),tcam_xx(*)
        dimension x_xx(*),y_xx(*)
        dimension psi_xx(nr,nz),curr_d_xx(nr,nz)
        
	dimension a_xx(*),psi_eq_xx(*),phi_xx(*)
        dimension fpol_xx(*),pptab_xx(*),fptab_xx(*)
        dimension tok1_xx(*),q_xx(*),press_xx(*)
        dimension surface_1d_xx(*),volume_1d_xx(*),area_1d_xx(*)
        dimension bprobe_xx(*),psloop_xx(*)
        dimension xbound_xx(*),ybound_xx(*)
        dimension x_sep_xx(*),y_sep_xx(*),x_sep2_xx(*),y_sep2_xx(*)
        dimension gaps_xx(*)
        
        
        dimension sigk_xx(npo), te0_xx(npo)
        dimension volume_1d_xx0(npo), area_1d_xx0(npo)

        dimension x_cont(npo,ntet), y_cont(npo,ntet)
        common /c_tt_kavin/tt_kavin_c
        
        include 'imas_interface.inc'

       	character *20 apr
        
        print *,' Output kpr n==',kpr,n   
        
        n_xx=n
	
	tpl_xx = tpl_dir*tpl*1000.d0
	
!	print *,' n_xx tpl_xx=',n_xx,tpl_xx

	tt_xx=tt/1000.d0
	!tt_xx=(tt-tay)/1000.d0

        rs0_xx = rs0/100.d0
        bt0_xx = bt0_dir*bt0/10.d0

        betap_xx = betj
        betat_xx = bett

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
        
        n_ga_xx = n_ga
        do i=1,n_ga
          gaps_xx(i) = gaps(i)*1.d-2
        enddo
        
        
        bprobe_xx(1:kprobe) = tpl_dir*bprobe(1:kprobe) ! *1.d-1
        psloop_xx(1:kloop) = tpl_dir*psloop(1:kloop)*2.*pi ! *1.d-5
        
        
	volume_1d_xx0(1) = vi(1)*ha(1)
	area_1d_xx0(1) = spo(1)*ha(1)
	do i=2,n
	   volume_1d_xx0(i) = volume_1d_xx0(i-1) + vi(i)*ha(i)
           area_1d_xx0(i) = area_1d_xx0(i-1) + spo(i)*ha(i)
	enddo
        
        
        ! Transformation to the psi grid
        
        ai(n+1)=1.d0
        teta_xx=1.d0
        
        call inter_h0(tok1,ai,n,teta_xx,val)
        tok1(n+1)=val
        tok1(1)=tok1(2)
        
        call inter_h0(q,ai,n,teta_xx,val)
        q(n+1)=val
        
        f(n+1)=bt0
        
        
        n1 = n+1
	do i=1,n
	   psiax_xx = dm0(1)
           psibnd_xx = dm0(n)
           
           psix = psiax_xx + (psibnd_xx - psiax_xx)*(a(i)**2)
        
!	   psix_xx=(psval(i)-pmag)/(pbound-pmag)
	   !aval = sqrt(psix_xx)
 !          psix = psval(i)*2.*pi
        
           call linear2(n,a,aval,dm0,psix)
           
           a_xx(i) = aval
           
           call linear2(n,dfmax,phi_xx(i),a,aval)
           call linear2(n,te0,te0_xx(i),a,aval)
           call linear2(n,p,press_xx(i),a,aval)
           call linear2(n,s_surf,surface_1d_xx(i),a,aval)
           call linear2(n,volume_1d_xx0,volume_1d_xx(i),a,aval)
           call linear2(n,area_1d_xx0,area_1d_xx(i),a,aval)
           
           !On the half-integral grid
           call linear2(n1,f,fpol_xx(i),ai,aval)
           call linear2(n1,q,q_xx(i),ai,aval)
           call linear2(n1,tok1,tok1_xx(i),ai,aval)
           
           
           psi_eq_xx(i) = psval(i)
          ! Originally on the psval grid
!            pptab_xx(i)=pptab(i)
!            fptab_xx(i)=fptab(i)
           pptab_xx(i) = ppx(i)
           fptab_xx(i) = pffx(i)
           
           !press_xx(i) = p(i)
           
        enddo
        
        sigk_xx(1) = sigk(1)
        sigk_xx(n) = sigk(n+1)
        
        tok1_xx(1) = tok1(1)
        tok1_xx(n) = tok1(n+1)
        
        fpol_xx(1) = f(1)
        fpol_xx(n) = f(n)
        
        q_xx(1) = q(1)
        q_xx(n) = q(n)
        
        ! Units transformation
        do i=1,n
        
	   tok1_xx(i) = tpl_dir*tok1_xx(i)*1.d7 ! Toroidal current density
           
           psi_eq_xx(i) = tpl_dir*psi_eq_xx(i)*1.d-5*2.*pi
           
           phi_xx(i) = bt0_dir*phi_xx(i)*1.d-5
           
           
           pptab_xx(i) = -tpl_dir*pptab_xx(i) * 1.d10/(rs0*8.d0*pi**2)
           fptab_xx(i) = -tpl_dir*fptab_xx(i) * rs0/(40.d0*pi)
           fpol_xx(i) = bt0_dir*(rs0/100.d0)*fpol_xx(i)/10.d0
!           press_xx(i) = 1.602176634d0*press_xx(i)/(200.d0*1.d-6)
           press_xx(i) = 1.d-2*press_xx(i)/(4.d0*pi*1.d-7)
           q_xx(i) = q_xx(i)
           
           surface_1d_xx(i) = surface_1d_xx(i)*1.d-4
	   volume_1d_xx(i) = 2.d0*pi*volume_1d_xx(i)*1.d-6
           area_1d_xx(i) = area_1d_xx(i)*1.d-4
        
	enddo
	

c=================================================
        
c profiles_1d from the 2D equilibrium (map_kav is valid only after tt_kavin)
        if (tt .gt. tt_kavin_c) then
          call get_flux_contours(x_cont, y_cont)
          call eq_profiles_1d(n, m, npo, x_cont, y_cont,
     *      psi_eq_xx, pptab_xx, fptab_xx,
     *      press_xx, fpol_xx, q_xx, phi_xx, a_xx, q_axis_eq, q_95_eq)
          wr_imas(18) = q_axis_eq
          wr_imas(17) = q_95_eq
        end if

	do i=1,npf
	   vchopper_xx(i) = tpl_dir*vchopper(i)*pf_turns(i)
	   pf_xx(i) = tpl_dir*1.d3*pf(i)/pf_turns(i)
	enddo
	
	do i=1,ncam
	   tcam_xx(i) = tpl_dir*1.d3*tcam(i)
	enddo
        
        
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
       
        common /maksim_03/ wr(150),wr_imas(150)
        
        dimension wr_imas_in(150)

        wr_imas_in = wr_imas
 
        return
        end
      

        
        subroutine get_contr_signals(vchopper_xx)

         include 'double.inc'
         include 'new_com.inc'
         include 'imas_interface.inc'
   
         dimension vchopper_xx(*)
   
         do i=1,npf
            vchopper(i) = tpl_dir*vchopper_xx(i)/pf_turns(i)
         end do
   
   
         if(kpr.eq.1)print*,'END of reading contr_signals'
   
         return
         end
         
         
      
!> dina_input is the subroutine to collect the initial kinetic profiles before enter 
!> to DINA to write them after that to DINA from IDSs in dina_imas subroutine

	subroutine dina_input(n_xx,a_xx,te0_xx,tq0_xx,pne_xx,
     * pd0_xx,pt0_xx,sigma_xx,ajb_xx,aj0_xx,qe0_xx,qq0_xx)

	include 'double.inc'
        
        dimension a_xx(*)
	dimension te0_xx(*),tq0_xx(*),pne_xx(*)
	dimension pd0_xx(*),pt0_xx(*),sigma_xx(*),ajb_xx(*),
     *  aj0_xx(*),qe0_xx(*),qq0_xx(*)
        

	include 'parf0'
     
        dimension sigk_xx(npo)
        
        common /c_input1/te0(npo),tq0(npo),pne(npo),
     *  pd0(npo),pt0(npo),sigk(npo),ajb(npo),
     *  aj0(npo),qe0(npo),qq0(npo)

      common
     *	/n_m/n,m,mp
     *  /ge5/kpr
     */ge2/NTAY,TAY,TT
      COMMON                                                            
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)                     


      dimension f_temp(npo)
      
        include 'imas_interface.inc'
     
     
	character *20 apr

c=================================================

      i_en=i_en+1

      tt_1=tt_1+tay
      
      t_ret=1.e5
      
      print *,' CALL dina_input tt tt_1 tay t_ret=',tt,tt_1,tay,t_ret
      
      
      
	   do i=1,n_xx
           if (te0_xx(i).gt.0.d0) then
             sigk_xx(i)=sigma_xx(i)/(1480.d0*te0_xx(i)**1.5d0)
           else 
             sigk_xx(i) = 0.d0
           endif
      enddo
      
      
      
       do i=1,n
       
       psix=a(i)
       call linear2(n_xx,te0_xx,te0(i),a_xx,psix)
       call linear2(n_xx,tq0_xx,tq0(i),a_xx,psix)

       call linear2(n_xx,pne_xx,pne(i),a_xx,psix)
       call linear2(n_xx,pd0_xx,pd0(i),a_xx,psix)
       call linear2(n_xx,pt0_xx,pt0(i),a_xx,psix)

       psix=ai(i)

       call linear2(n_xx,sigk_xx,sigk(i),a_xx,psix)
       call linear2(n_xx,ajb_xx,ajb(i),a_xx,psix)
       call linear2(n_xx,aj0_xx,aj0(i),a_xx,psix)

       call linear2(n_xx,qe0_xx,qe0(i),a_xx,psix)
       call linear2(n_xx,qq0_xx,qq0(i),a_xx,psix)

       end do
      
      
       sigk(1) = sigk_xx(1)
       ajb(1) = ajb_xx(1)
       aj0(1) = aj0_xx(1)
      
	do i=1,n
        
	   te0(i)=te0(i)
	   tq0(i)=tq0(i)
	   pne(i)=pne(i)*1.d-19
	   pd0(i)=pd0(i)*1.d-19
	   pt0(i)=pt0(i)*1.d-19
	   qe0(i)=qe0(i)
	   qq0(i)=qq0(i)
           
	end do
        
        
      apr='--te0-' 
      if(kpr.eq.1)print 71,apr,(te0(i),i=1,n) 
      apr='--tq0-' 
      if(kpr.eq.1)print 71,apr,(tq0(i),i=1,n) 
      apr='--pne-' 
      if(kpr.eq.1)print 71,apr,(pne(i),i=1,n) 
      apr='--sigk-' 
      if(kpr.eq.1)print 71,apr,(sigk(i),i=1,n) 

   71 FORMAT(20X,A20/,(6(1pE10.3)))
	
	
	
	do i=1,n
        
	   ajb(i)=tpl_dir*ajb(i)*1.d-7
	   aj0(i)=tpl_dir*aj0(i)*1.d-7
           
	end do

      apr='--pd0-' 
      if(kpr.eq.1)print 71,apr,(pd0(i),i=1,n) 
      apr='--pt0-' 
      if(kpr.eq.1)print 71,apr,(pt0(i),i=1,n) 
      apr='--qe0-' 
      if(kpr.eq.1)print 71,apr,(qe0(i),i=1,n) 
      apr='--ajb-' 
      if(kpr.eq.1)print 71,apr,(ajb(i),i=1,n) 
      apr='--aj0-' 
      if(kpr.eq.1)print 71,apr,(aj0(i),i=1,n) 


      return
      end
        
        
        
	subroutine dina_remap(n_xx,te0_xx,tq0_xx,pne_xx,
     * pd0_xx,pt0_xx,sigma_xx,ajb_xx,aj0_xx,qe0_xx,qq0_xx,a_xx,ai_xx)

	include 'double.inc'
	include 'parf0'

	dimension te0_xx(*),tq0_xx(*),pne_xx(*)
	dimension pd0_xx(*),pt0_xx(*),sigma_xx(*),ajb_xx(*),
     *  aj0_xx(*),qe0_xx(*),qq0_xx(*),a_xx(*),ai_xx(*)
     
        common /c_input1/te0(npo),tq0(npo),pne(npo),
     *  pd0(npo),pt0(npo),sigk(npo),ajb(npo),
     *  aj0(npo),qe0(npo),qq0(npo)

	common
     *	/n_m/n,m,mp
     *  /ge5/kpr
      COMMON                                                            
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)                     

     
	character *20 apr

      if(kpr.eq.1)print *,' dina_remap  n n_xx=',n,n_xx
      
      if(n_xx.eq.-1000)return
      
c=================================================

      apr='--a_xx-' 
      if(kpr.eq.1)print 71,apr,(a_xx(i),i=1,n_xx) 
      apr='--ai_xx-' 
      if(kpr.eq.1)print 71,apr,(ai_xx(i),i=1,n_xx) 


       do i=2,n-1
       psix=a(i) 
       call linear(n_xx,te0_xx,te0(i),a_xx,psix)
       call linear(n_xx,tq0_xx,tq0(i),a_xx,psix)

       call linear(n_xx,pne_xx,pne(i),a_xx,psix)
       call linear(n_xx,pd0_xx,pd0(i),a_xx,psix)
       call linear(n_xx,pt0_xx,pt0(i),a_xx,psix)

       psix=ai(i) 

       call linear(n_xx,sigma_xx,sigk(i),ai_xx,psix)
       call linear(n_xx,ajb_xx,ajb(i),ai_xx,psix)
       call linear(n_xx,aj0_xx,aj0(i),ai_xx,psix)

       call linear(n_xx,qe0_xx,qe0(i),ai_xx,psix)
       call linear(n_xx,qq0_xx,qq0(i),ai_xx,psix)


       end do
      
!      te0(1)=te0_xx(1)
!      tq0(1)=tq0_xx(1)

!      te0(n)=te0_xx(n_xx)
!      tq0(n)=tq0_xx(n_xx)
      
	do i=2,n-1
	   te0_xx(i)=te0(i)
	   tq0_xx(i)=tq0(i)

	   pne_xx(i)=pne(i)
	   pd0_xx(i)=pd0(i)
	   pt0_xx(i)=pt0(i)
	   
	   qe0_xx(i)=qe0(i)
	   qq0_xx(i)=qq0(i)

         sigma_xx(i)=sigk(i)
           
	   ajb_xx(i)=ajb(i)
	   aj0_xx(i)=aj0(i)

	end do

      apr='--te0-' 
      if(kpr.eq.1)print 71,apr,(te0_xx(i),i=1,n) 
      apr='--tq0-' 
      if(kpr.eq.1)print 71,apr,(tq0_xx(i),i=1,n) 
      apr='--sigma-' 
      if(kpr.eq.1)print 71,apr,(sigma_xx(i),i=1,n) 
      apr='--pne-' 
      if(kpr.eq.1)print 71,apr,(pne_xx(i),i=1,n) 
      apr='--aj0-' 
      if(kpr.eq.1)print 71,apr,(aj0_xx(i),i=1,n) 

   71 FORMAT(20X,A20/,(6(1pE10.3)))
	
	do i=1,n
	end do

      apr='--pd0-' 
 !     if(kpr.eq.1)print 71,apr,(pd0(i),i=1,n) 
      apr='--qe0-' 
 !     if(kpr.eq.1)print 71,apr,(qe0(i),i=1,n) 
      apr='--ajb-' 
 !     if(kpr.eq.1)print 71,apr,(ajb(i),i=1,n) 

      return
      end

	subroutine dina_map(n_xx,te0_xx,tq0_xx,pne_xx,
     * pd0_xx,pt0_xx,sigma_xx,ajb_xx,aj0_xx,qe0_xx,qq0_xx,a_xx,ai_xx)

	include 'double.inc'
	include 'parf0'

	dimension te0_xx(*),tq0_xx(*),pne_xx(*)
	dimension pd0_xx(*),pt0_xx(*),sigma_xx(*),ajb_xx(*),
     *  aj0_xx(*),qe0_xx(*),qq0_xx(*),a_xx(*),ai_xx(*)
     
        common /c_input1/te0(npo),tq0(npo),pne(npo),
     *  pd0(npo),pt0(npo),sigk(npo),ajb(npo),
     *  aj0(npo),qe0(npo),qq0(npo)

	common
     *	/n_m/n,m,mp
     *  /ge5/kpr
      COMMON                                                            
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)                     

     
	character *20 apr

      if(kpr.eq.1)print *,' dina_map  n n_xx=',n,n_xx
      if(n_xx.eq.-1000)then
      n_xx=n
      do i=1,n_xx
      a_xx(i)=a(i)
      ai_xx(i)=ai(i)
      end do
      if(kpr.eq.1)print *,' dina_map  n n_xx=',n,n_xx
      end if
      

      
c=================================================
      
      apr='--a_xx-' 
      if(kpr.eq.1)print 71,apr,(a_xx(i),i=1,n_xx) 
      apr='--ai_xx-' 
      if(kpr.eq.1)print 71,apr,(ai_xx(i),i=1,n_xx) 

       do i=2,n_xx-1

       psix=a_xx(i) 

       call linear(n,te0_xx,te0(i),a,psix)
       call linear(n,tq0_xx,tq0(i),a,psix)

       call linear(n,pne_xx,pne(i),a,psix)
       call linear(n,pd0_xx,pd0(i),a,psix)
       call linear(n,pt0_xx,pt0(i),a,psix)

       psix=ai_xx(i) 

       call linear(n,sigma_xx,sigk(i),ai,psix)
       call linear(n,ajb_xx,ajb(i),ai,psix)
       call linear(n,aj0_xx,aj0(i),ai,psix)

       call linear(n_xx,qe0_xx,qe0(i),ai,psix)
       call linear(n_xx,qq0_xx,qq0(i),ai,psix)


       end do
      
!      te0(1)=te0_xx(1)
!      tq0(1)=tq0_xx(1)

!      te0(n)=te0_xx(n_xx)
!      tq0(n)=tq0_xx(n_xx)
      
	do i=2,n_xx-1
	   te0_xx(i)=te0(i)
	   tq0_xx(i)=tq0(i)

	   pne_xx(i)=pne(i)
	   pd0_xx(i)=pd0(i)
	   pt0_xx(i)=pt0(i)
	   
	   qe0_xx(i)=qe0(i)
	   qq0_xx(i)=qq0(i)

         sigma_xx(i)=sigk(i)
           
	   ajb_xx(i)=ajb(i)
	   aj0_xx(i)=aj0(i)
	   
	end do

      apr='--te0-' 
      if(kpr.eq.1)print 71,apr,(te0_xx(i),i=1,n_xx) 
      apr='--tq0-' 
      if(kpr.eq.1)print 71,apr,(tq0_xx(i),i=1,n_xx) 
      apr='--sigma-' 
      if(kpr.eq.1)print 71,apr,(sigma_xx(i),i=1,n_xx) 

   71 FORMAT(20X,A20/,(6(1pE10.3)))
	
	do i=1,n
	end do

      apr='--pd0-' 
 !     if(kpr.eq.1)print 71,apr,(pd0(i),i=1,n) 
      apr='--qe0-' 
 !     if(kpr.eq.1)print 71,apr,(qe0(i),i=1,n) 
      apr='--ajb-' 
 !     if(kpr.eq.1)print 71,apr,(ajb(i),i=1,n) 

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

                                                                        

        write(6,*)' nre nze ',nre,nze                                  
        write(6,*)' nr nz ',nr,nz                                  
        write (6,*)' dx dy ',dx,dy                                     

                                                                        

                                                                        

	do i=1,nr                                                              

	x(i)=re(i)                                                             

!        write(6,*)' i x ',i,x(i)                                       

	end do                                                                 

                                                                        

	do i=1,nz                                                              

	   y(i)=ze(i)                                                          
!        write(6,*)' i y ',i,y(i)                                       

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
        
        
        
       subroutine dina_input0(tt_xx,
     *  pf_xx,tcam_xx, rs0_xx,bt0_xx)
        
      include 'double.inc'
      include 'new_com.inc'
      
      dimension pf_xx(*),tcam_xx(*)
      
      include 'imas_interface.inc'
      
      common /c_for002_kav/tay_c,rs0_c,bt0_c,key_t11_c
      common /c_scr_data_c1/pf_c1(kf)
      
      character *8 apr
      
      ! Force printing
      kpr=1
      
      
      if (bt0_xx.gt.0.d0) then
      bt0_dir = 1.d0
      else
      bt0_dir = -1.d0
      endif
      
      if(kpr.eq.1)print *,' tpl_dir, bt0_dir ==', tpl_dir, bt0_dir
      
      rs0 = rs0_xx*100.d0
      bt0 = bt0_dir*bt0_xx*10.d0
      if(kpr.eq.1)print *,' - rs0 bt0 ==',rs0,bt0
      
      rs0_c = rs0
      bt0_c = bt0
      
      tokc=0.
      do i=1,ncam
        tcam(i) = tcam_xx(i)*1.d-3*tpl_dir
        tokc=tokc+tcam(i)
      enddo
      
      if(kpr.eq.1)print *,' -- tokc tt==',tokc,tt
      
      do i=1,npf
         pf(i) = pf_xx(i)*tpl_dir*1.d-3*pf_turns(i)
      enddo
      
 	apr='pf'
	if(kpr.eq.1)print 71,apr,(pf(j),j=1,npf)
 71	format(20x,a6/,(6(1x,1pe10.3)))
        
	do i=1,npf
	  pf0(i)=pf(i)
          pf_c1(i)=pf(i)
	end do
      
      
      return
      end
      
      
      
! Initializing input
       subroutine dina_input2(tt_xx,tpl_xx,rmag_xx,zmag_xx,
     *  n_eq_xx,pptab_xx,fptab_xx,psi_xx,
     *  n_tr_xx,a_tr_xx,psi_tr_xx)
     
      include 'double.inc'
      include 'new_com.inc'
      
                  
      dimension pptab_xx(*),fptab_xx(*),psi_xx(*)
      dimension a_tr_xx(*),psi_tr_xx(*)
     
      
      character *10 apr      
      
      include 'imas_interface.inc'
      
      
        arg=1.d0
        pi=4.d0*atan(ARG)
        
        
      print *,'dina_input2 n,n_eq_xx,n_tr_xx',n,n_eq_xx,n_tr_xx
      
      nutab = n
      tt = tt_xx*1.d3
      tpl = tpl_xx*1.d-3*tpl_dir
      rmag = rmag_xx*1.d2
      zmag = zmag_xx*1.d2
      
      if (( (psi_xx(1)-psi_xx(n_eq_xx))*tpl_dir ).gt.0.d0) then
      psiax_xx = psi_xx(1)
      psibound_xx = psi_xx(n_eq_xx)
      else
      psiax_xx = psi_xx(n_eq_xx)
      psibound_xx = psi_xx(1)
      endif
      
      print*, 'psiax_xx, psibound_xx', psiax_xx, psibound_xx
      
      
      
       do i=1,n
       
         pstab(i) = a(i)
         
         psix = psiax_xx + (psibound_xx - psiax_xx)*(a(i)**2)
         
         print*, 'i, psi_xx, psi = ', i, psi_xx(i), psix
         
!       pptab(i) = pptab_xx(i)
!       fptab(i) = fptab_xx(i)
       call linear2(n_eq_xx,pptab_xx,pptab(i),psi_xx,psix)
       call linear2(n_eq_xx,fptab_xx,fptab(i),psi_xx,psix)
       
!       dmn(i) = psi_tr_xx(i)
!       call linear2(n_eq_xx,psi_xx,dmn(i),a_xx,a(i))
       call linear2(n_tr_xx,psi_tr_xx,dmn(i),a_tr_xx,a(i))

       end do
      
      
      coef_ppx = 1.d10/(rs0*8.d0*pi**2)
      coef_pffx = rs0/(40.d0*pi)

      if(kpr.eq.1)print *,' - rs0 pi==',rs0,pi

      if(kpr.eq.1)print *,' - coef_ppx coef_pffx==',coef_ppx,coef_pffx
     
   
 	apr='a_tr_xx'
	if(kpr.eq.1)print 71,apr,(a_tr_xx(j),j=1,n_tr_xx)
 	apr='a'
	if(kpr.eq.1)print 71,apr,(a(j),j=1,nutab)
        
 	apr='pptab_xx'
	if(kpr.eq.1)print 71,apr,(pptab_xx(j),j=1,n_eq_xx)
 	apr='pptab'
	if(kpr.eq.1)print 71,apr,(pptab(j),j=1,nutab)
        
 	apr='fptab_xx'
	if(kpr.eq.1)print 71,apr,(fptab_xx(j),j=1,n_eq_xx)
 	apr='fptab'
	if(kpr.eq.1)print 71,apr,(fptab(j),j=1,nutab)
        
 	apr='psi_xx'
	if(kpr.eq.1)print 71,apr,(psi_xx(j),j=1,n_eq_xx)
 	apr='dmn'
	if(kpr.eq.1)print 71,apr,(dmn(j),j=1,nutab)
     
 
      do i=1,nutab
        
!        pptab(i) = pptab_xx(i)*tpl_dir 
!        fptab(i) = fptab_xx(i)*tpl_dir 
        
        pptab(i) = -tpl_dir*pptab(i) / coef_ppx
        fptab(i) = -tpl_dir*fptab(i) / coef_pffx
        
        dmn(i) = tpl_dir*dmn(i)*1.d5 
      end do      

      print *,' nutab',nutab
      print *,' rmag zmag',rmag,zmag




 71	format(20x,a8/,(6(1x,1pe10.3)))
      
      
      
      do i=1,n
        ppx(i)=pptab(i)
        pffx(i)=fptab(i)
      end do      
      
      
      return
      end


!> Linear interpolation
!> Supports any monotonic grids (including descending) and values outside of the grid
 	subroutine linear2(n,PSI,aval,x,xp)
        include 'double.inc'
c	implicit real *8 (a-h,o-z)
	dimension  psi(n),x(n)
c
	n1=n-1
c
	do i=1,n1
	if( (xp-x(i+1))*(xp-x(i)).le.0.d0) then
	aval=psi(i)+(xp-x(i))*(psi(i+1)-psi(i))/(x(i+1)-x(i))
        return
        end if
	end do
        
        if (xp.ge.x(n).and.x(1).le.x(n)) aval = psi(n)
        if (xp.le.x(n).and.x(1).ge.x(n)) aval = psi(n)
        if (xp.le.x(1).and.x(1).le.x(n)) aval = psi(1)
        if (xp.ge.x(1).and.x(1).ge.x(n)) aval = psi(1)
        
	return
	end

      subroutine get_flux_contours(r_cont, z_cont)
      include 'double.inc'
      include 'new_com.inc'
      dimension r_cont(npo,ntet), z_cont(npo,ntet)
      dimension x_save(npo,ntet), y_save(npo,ntet)

      x_save = x_map
      y_save = y_map
      k_save = k_map
      call map_kav()
      r_cont = x_map
      z_cont = y_map
      x_map = x_save
      y_map = y_save
      k_map = k_save

      return
      end

!> eq_profiles_1d computes pressure, f, q, phi, rho_tor_norm on the psi grid
!> from dpressure_dpsi, f_df_dpsi and the flux-surface contours, so that
!> profiles_1d is consistent with the 2D equilibrium.
!> p and F2 are integrated inward from the boundary values pressure(n), f(n);
!> phi = int F/R dA (int dA/R = |oint ln(R) dZ|), q = dphi/dpsi.
!> psi in Wb; r_cont, z_cont in cm, surface 1 = axis, surface n = boundary.
      subroutine eq_profiles_1d(n, n_rays, ld, r_cont, z_cont,
     *  psi, dpressure_dpsi, f_df_dpsi,
     *  pressure, f, q, phi, rho_tor_norm, q_axis, q_95)
      include 'double.inc'
      include 'parf0'
      dimension r_cont(ld,*), z_cont(ld,*)
      dimension psi(n), dpressure_dpsi(n), f_df_dpsi(n)
      dimension pressure(n), f(n), q(n), phi(n), rho_tor_norm(n)
      dimension f2(npo), sda(npo), tflux(npo)

      if (n .lt. 4) return
      cm = 1.d-2
      psin95 = 0.95d0

c     p and F from p', FF', boundary inward
      f2(n) = f(n)**2
      do i = n-1, 1, -1
        dpsi = psi(i) - psi(i+1)
        pressure(i) = pressure(i+1)
     *              + 0.5d0*(dpressure_dpsi(i) + dpressure_dpsi(i+1))*dpsi
        f2(i) = f2(i+1) + (f_df_dpsi(i) + f_df_dpsi(i+1))*dpsi
      end do
      f_sign = sign(1.d0, f(n))
      do i = 1, n
        f(i) = f_sign*dsqrt(dmax1(f2(i), 0.d0))
      end do

c     int dA/R inside each surface
      sda(1) = 0.d0
      do i = 2, n
        sum = 0.d0
        do j = 1, n_rays
          jn = j + 1
          if (jn .gt. n_rays) jn = 1
          r1 = r_cont(i, j)*cm
          r2 = r_cont(i, jn)*cm
          z1 = z_cont(i, j)*cm
          z2 = z_cont(i, jn)*cm
          sum = sum + 0.5d0*(dlog(r1) + dlog(r2))*(z2 - z1)
        end do
        sda(i) = dabs(sum)
      end do

c     toroidal flux and q
      tflux(1) = 0.d0
      do i = 2, n
        tflux(i) = tflux(i-1)
     *           + 0.5d0*(dabs(f(i)) + dabs(f(i-1)))*(sda(i) - sda(i-1))
      end do

      q_sign = sign(1.d0, q(n))
      do i = 2, n-1
        q(i) = (tflux(i+1) - tflux(i-1))/dabs(psi(i+1) - psi(i-1))
      end do
      q(1) = q(2) - (q(3) - q(2))*(psi(2) - psi(1))/(psi(3) - psi(2))
      q(n) = q(n-1) + (q(n-1) - q(n-2))
     *              *(psi(n) - psi(n-1))/(psi(n-1) - psi(n-2))

      q_axis = q(1)
      q_95 = q(n)
      do i = 2, n
        psin1 = (psi(i-1) - psi(1))/(psi(n) - psi(1))
        psin2 = (psi(i)   - psi(1))/(psi(n) - psi(1))
        if (psin1 .le. psin95 .and. psin2 .ge. psin95) then
          q_95 = q(i-1) + (q(i) - q(i-1))*(psin95 - psin1)/(psin2 - psin1)
        end if
      end do
      do i = 1, n
        q(i) = q_sign*q(i)
      end do
      q_axis = q_sign*q_axis
      q_95 = q_sign*q_95

      phi_sign = sign(1.d0, phi(n))
      do i = 1, n
        phi(i) = phi_sign*tflux(i)
        rho_tor_norm(i) = dsqrt(tflux(i)/tflux(n))
      end do

      return
      end
