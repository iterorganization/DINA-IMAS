	subroutine get_dens_zimp(kkk,ppr0,ppr,n_x)

         implicit real *8 (a-h,o-z) 
         include 'parf0'
	  
         include 'par_imp.inc'
         include 'new_imp.inc'

	 dimension ppr(*),ppr0(*)

	
      do j_x=2,n_x
        ppr(j_x)=den_imp(1,kkk,j_x)
        ppr0(j_x)=den0_imp(1,kkk,j_x)
      end do

	ppr(1)=ppr(2)
	ppr0(1)=ppr0(2)

	return
	end

	subroutine get_dens_zimp2(kkk,ppr0,ppr2,n_x)

         implicit real *8 (a-h,o-z) 
         include 'parf0'
	  
         include 'par_imp.inc'
         include 'new_imp.inc'

	 dimension ppr2(*),ppr0(*)

	
      do j_x=2,n_x
        ppr2(j_x)=den_imp(2,kkk,j_x)
        ppr0(j_x)=den0_imp(1,kkk,j_x)
      end do

	ppr2(1)=ppr2(2)
	ppr0(1)=ppr0(2)

	return
	end
	subroutine put_dens_zimp(kkk,ppr,n_x)

         implicit real *8 (a-h,o-z) 
         include 'parf0'
	  
         include 'par_imp.inc'
         include 'new_imp.inc'

	 dimension ppr(*)

      do j_x=1,n_x
        den_imp(1,kkk,j_x)=ppr(j_x)
      end do

	return
	end
	subroutine put_dens_zimp2(kkk,ppr2,n_x)

         implicit real *8 (a-h,o-z) 
         include 'parf0'
	  
         include 'par_imp.inc'
         include 'new_imp.inc'

	 dimension ppr2(*)

      do j_x=1,n_x
        den_imp(2,kkk,j_x)=ppr2(j_x)
      end do

	return
	end
	subroutine put_neut_zimp_c(ppr,n_x)

         implicit real *8 (a-h,o-z) 
         include 'parf0'
	  
         include 'par_imp.inc'
         include 'new_imp.inc'

	 dimension ppr(*)
	character*20 apr

      do j_x=1,n_x
        den_imp_n(1,j_x)=ppr(j_x)
      end do

      apr='ppr**------'
!      print 71,apr,(ppr(i),i=1,n_x)
   71 FORMAT(20X,A6/,(6(1pE10.3)))


	return
	end
      subroutine n0_prog()
	include 'double.inc'
	include 'new_com.inc'
	include 'par_imp.inc'                                                  
	include 'new_imp.inc'                                                  

	call n0_prog_c(
     * prog_n0,tt,kpr)

	return
	end
      subroutine n0_prog_c(
     * prog_n0,tt,kpr)

	include 'double.inc'
 	include 'parf_mike' 

	dimension t_t(ntime),pn_d_t(ntime)
	character *12 apr

	kpr=1
	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='n0.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 
           
           if(kpr.eq.1)print *,' tay tt n_t===',tay,tt,n_t 
           
           do i=1,n_t 
              read (41,*)t_t(i),pn_d_t(i)
!!!              t_t(i)=t_t(i)*1000. 
           if(kpr.eq.1)print *,' i t_t n_d_t==',i,t_t(i),pn_d_t(i)
           end do 
           
           apr='-t_t-' 
           if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 

           apr='-n_d_t-' 
           if(kpr.eq.1)print 71,apr,(pn_d_t(i),i=1,n_t) 


           close (unit=41) 


        end if


71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

        do i=2,n_t
           if((tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
              t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )

              prog_n_d=pn_d_t(i-1)+t_coef*
     *             (pn_d_t(i)-pn_d_t(i-1))
c
	 end if

	 end do

	prog_n0=prog_n_d*10.d0

      if(kpr.eq.1)print *,'  prog_n0',prog_n0

!	if(ntay.ge.3)call wave_run()

        
	return
	end




      SUBROUTINE ENIT_outp(N_xx)
	include 'double.inc'
	include 'new_com.inc'

      call ENIT_outp_c(N_xx,
     *       ro_bar,alf_bar,key_lh,coef_kessel_1,tt_h,
     *       key_h_to_l,w_imp,w_imp2,w_imp3,w_imp4,w_imp5,pcch,
     *       p_n0,pn0_tot)

c      print*,'from enet w_imp2,w_imp3,w_imp4,w_imp5',
c     *  w_imp2,w_imp3,w_imp4,w_imp5


	return
	end


      SUBROUTINE ENIT_outp_c(N,
     *       ro_bar,alf_bar,key_lh,coef_kessel_1,tt_h,
     *       key_h_to_l,w_imp,w_imp2,w_imp3,w_imp4,w_imp5,pcch,
     *       p_n0,pn0_tot)

c--------------------------------------------
c   sources for energy equation and heat conductivities
c--------------------------------------------------
	include 'double.inc'
c        implicit real*8 (a-h,o-z)
	include 'parf0'
c
	common
     *  /mid2/vi(npo),spo(npo)
     *  /mid3/GRA1(npo),GRA2(npo)
     *  /mid6/bp_0(npo),a_m(npo),r_m(npo)
     *  /mid7/bsq(npo),bsqi(npo),fasp(npo)
	common
     *  /dfm2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)
     *  /dfm3/dfmax(npo),dfmax0(npo)
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)
     *  /dfm7/BT,UIND
     *  /dfm8/ajb(npo),sigk(npo)
     *  /dfm8e/ajbn(npo)
	common
     *  /ge1/PI
     *  /ge2/ntay,tay,ttb
     *  /ge3/AI(npo),AA0(npo),HA2(npo),a(npo),ha(npo)
     *  /ge5/kpr
     *  /ge6/zeff(npo),qpr(npo),ppr(npo),pr0,prg,zar
     *  /ge7/eu,rs,zact,elong
c
	COMMON
     *  /en1/PNE(npo),PD0(npo),PT0(npo),PH0(npo),PDN(npo),
     *  PTN(npo),PHN(npo)
     *  /en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),WE0(npo),WQ0(npo)
     *  /en9/QE0(npo),QQ0(npo),QDG(npo)
     *  /en10/GGE(npo),GGEN(npo),DXE(npo),DXQ(npo),WU(npo),
     *  UG(npo),VG(npo)
     *  /en11/un(4),zn(2),ll,ken,ken1,ken2,noit
     *  /en12/pnal(npo),pnaln(npo),zalfa,talfa
     *  /en14/EMOE,EMOQ,NDOP,QDE0(npo),QDQ0(npo)
     *  /en15/QNET(npo)
     *  /en16/QTOR(npo),QDH(npo),QpE(npo),QpQ(npo)
     *  /en16e/qbeam(npo)
	common
     *  /en17/QAE(npo),QAQ(npo),SAL(npo),NAL
     *  /en18/pin(npo),pin0(npo),q11(npo),pal(npo)
     *  /en19/DD,DT,DH,SIN0,SINK,ALPY,Sss,Ppp,Eee
     *  /en20/PJ(npo),SB(npo)
     *  /en21/qce(npo)
     *  /en22/XII(npo)
     *  /en23/kk,tn0,pna,wie(npo),wcx(npo),tn(npo),pn(npo),pn0(npo)
     *  /en24/qen1,qen2,sumn,wen1,wen2
     *  /en25/zhib,tego
     *  /en26/del(npo)
     *  /en27/nij
     *  /en32/x_e(npo),x_i(npo)
     *  /en33/anom_e,anom_i,key_t11,kcchp
	common
     *  /keys5/next
     *  /keys8/ndh

        common
     *  /bohm/he_bgb(npo),xi_bgb(npo)

        common /vic_imp/coef_imp,nz_imp
        common /vic_imp1/coef_imp1,nz_imp1
        common /vic_imp2/coef_imp2,nz_imp2
        common /vic_imp3/coef_imp3,nz_imp3
        common /vic_imp4/coef_imp4,nz_imp4

        dimension res(3),te_zrad(3)
        real res,te_zrad

        real*8 n0_xx,n_e_xx,tay_lo_xx,tn_xx,alf_n_xx


c
	dimension pbe(npo),pbi(npo),vol(npo),forme(npo),formi(npo)
	
	dimension q_imp(npo) 
	
	   common	
     *  /c_imas3/w_imp_pr(npo),w_imp_pr2(npo)
     *  /c_imas5/q_imp1(npo),q_imp2(npo),q_imp3(npo),
     *  q_imp4(npo),q_imp5(npo)

	dimension z_imp1(npo),z_imp2(npo),z_imp3(npo)
	dimension z2_imp1(npo),z2_imp2(npo),z2_imp3(npo),talfa2(npo)
	dimension z_imp4(npo),z_imp5(npo)
	dimension z2_imp4(npo),z2_imp5(npo)

 	
c-------------
	
	character*10 apr
c  ===

      
      N2=N-1
        
      PNOR=6.25E8

      w_imp1=0.
      w_imp2=0.
      w_imp3=0.
      w_imp4=0.
      w_imp5=0.
   
   
      pow_e=0.
      pow_i=0.
   
      plos_e=0.
      plos_i=0.
   
	do i=1,n

        if(te0(I).le.2.1)then
            q_imp1(i)=0.d0
        end if

           q_imp(i)=q_imp1(i)
           
            if(te0(I).le.2.1)then
            q_imp2(i)=0.d0
            end if

           q_imp(i)=q_imp(i)+q_imp2(i)

        if(te0(I).le.2.1)then
            q_imp3(i)=0.d0
        end if
           q_imp(i)=q_imp(i)+q_imp3(i)

        if(te0(I).le.2.1)then
            q_imp4(i)=0.d0
        end if
           q_imp(i)=q_imp(i)+q_imp4(i)

        if(te0(I).le.2.1)then
            q_imp5(i)=0.d0
        end if
           q_imp(i)=q_imp(i)+q_imp5(i)

      w_imp1=w_imp1+q_imp1(i)*2.*pi*vi(i)*ha(i)
      w_imp2=w_imp2+q_imp2(i)*2.*pi*vi(i)*ha(i)
      w_imp3=w_imp3+q_imp3(i)*2.*pi*vi(i)*ha(i)
      w_imp4=w_imp4+q_imp4(i)*2.*pi*vi(i)*ha(i)
      w_imp5=w_imp5+q_imp5(i)*2.*pi*vi(i)*ha(i)


      w_imp_pr(i)=q_imp1(i)+q_imp2(i)+q_imp3(i)+q_imp4(i)+q_imp5(i)
      w_imp_pr2(i)=q_imp2(i)
      w_imp_pr(i)=w_imp_pr(i)*2.*pi*vi(i)*ha(i)/pnor
      w_imp_pr2(i)=w_imp_pr2(i)*2.*pi*vi(i)*ha(i)/pnor

	end do

      w_imp1=w_imp1/pnor
      w_imp2=w_imp2/pnor
      w_imp3=w_imp3/pnor
      w_imp4=w_imp4/pnor
      w_imp5=w_imp5/pnor

      w_imp=w_imp1+w_imp2+w_imp3+w_imp4+w_imp5

	 if(kpr.eq.1)write(6,'(" w_imp1+w_imp2+w_imp3+w_imp4+w_imp5 ",
     *  6(1pe13.6))'),w_imp1,w_imp2,w_imp3,w_imp4,w_imp5

c----------
	do i=2,n

        if(te0(I).le.2.1)then
            QDH(I)=0.d0
            QTOR(I)=0.d0
            QDE0(I)=0.d0
            qce(I)=0.d0
        end if

        QE0(I)=QDH(I)-QTOR(I)+QDE0(I)-qce(i)
      
      pow_e=pow_e+(ndh*QDH(I)+QpE(I)*NIJ+
     *  QAE(I)*NAL+QDE0(I)*NDOP)*2.*pi*vi(i)*ha(i)/pnor
     
   
      plos_e=plos_e-(QTOR(I)+qce(i))*2.*pi*vi(i)*ha(i)/pnor

        qe0(i)=qe0(i)-q_imp(i)
  
        plos_e=plos_e-(q_imp(i)+qpr(i))*2.*pi*vi(i)*ha(i)/pnor

	end do

   71 FORMAT(20X,A6/,(6(1pE10.3)))

      pow_tot=pow_e+pow_i    
      	 if(kpr.eq.1)write(6,'(" pow_e  pow_tot plos_e  ",
     *  6(1pe13.6))'),pow_e,pow_tot,plos_e

	apr='w_imp'
      if(kpr.eq.1)print 71,apr,(w_imp_pr(i),i=1,n)
	apr='w_be'
      if(kpr.eq.1)print 71,apr,(w_imp_pr2(i),i=1,n)
      
	apr='qe0'
      if(kpr.eq.1)print 71,apr,(qe0(i),i=1,n)
 

      RETURN
      END



      
     	subroutine filter_ppx_time(tay_p_xx)
 	include 'double.inc'
	include 'new_com.inc'
      
	call filter_ppx_time_c(tt,tay,ppx,n,tay_p_xx,kpr)
	return
	end

      subroutine filter_ppx_time_c(tt,tay,ppx,n,tay_p,kpr)
	include 'double.inc'
 	include 'parf0' 
 	include 'parf_mike' 

	dimension t_t(ntime),ppx_t(npo,ntime)

	dimension ppx(*)

	character *12 apr
	
	nw=tay_p/tay

      if(nw.lt.2)return

	if(kpr.eq.1)print *,' tay_p tay nw=',tay_p,tay,nw
	apr='ppx'
      if(kpr.eq.1)print 71,apr,(ppx(i),i=1,n) 

	if(time.lt.tt-0.5*tay)then
c  saving for the next time_step...
	   do j=2,nw
	   do i=1,n
	      ppx_t(i,j-1) = ppx_t(i,j)
	   end do
!	   t_t(j-1) = t_t(j)
	   end do
	end if

	time=tt

      j=nw
!	t_t(j)=tt
	do i=1,n
	   ppx_t(i,j)=ppx(i)
	end do

      i_en=i_en+1
	if(i_en.eq.1)then
	   do j=1,nw
	   do i=1,n
	      ppx_t(i,j) = ppx(i)
	   end do
	   end do
        end if
      
	   do i=1,n
         ppx_avr=0.
	   do j=1,nw
	      ppx_avr=ppx_avr+ppx_t(i,j)
	   end do
           ppx(i)=ppx_avr/float(nw)
	   end do

	apr='qe0_c'
      if(kpr.eq.1)print 71,apr,(ppx(i),i=1,n) 

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))
      
      
      return 
      end 


      subroutine filter_imp_time_c(tt,tay,ppx,n,tay_p,kpr)
	include 'double.inc'
 	include 'parf0' 
 	include 'parf_mike' 

	dimension t_t(ntime),ppx_t(npo,ntime)

	dimension ppx(*)

	character *12 apr
	
	nw=tay_p/tay

      if(nw.lt.2)return

	if(kpr.eq.1)print *,' tay_p tay nw=',tay_p,tay,nw
	apr='ppx'
      if(kpr.eq.1)print 71,apr,(ppx(i),i=1,n) 

	if(time.lt.tt-0.5*tay)then
c  saving for the next time_step...
	   do j=2,nw
	   do i=1,n
	      ppx_t(i,j-1) = ppx_t(i,j)
	   end do
!	   t_t(j-1) = t_t(j)
	   end do
	end if

	time=tt

      j=nw
!	t_t(j)=tt
	do i=1,n
	   ppx_t(i,j)=ppx(i)
	end do

      i_en=i_en+1
	if(i_en.eq.1)then
	   do j=1,nw
	   do i=1,n
	      ppx_t(i,j) = ppx(i)
	   end do
	   end do
        end if
      
	   do i=1,n
         ppx_avr=0.
	   do j=1,nw
	      ppx_avr=ppx_avr+ppx_t(i,j)
	   end do
           ppx(i)=ppx_avr/float(nw)
	   end do

	apr='imp'
      if(kpr.eq.1)print 71,apr,(ppx(i),i=1,n) 

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))
      
      
      return 
      end 
      subroutine filter_imp1_time_c(tt,tay,ppx,n,tay_p,kpr)
	include 'double.inc'
 	include 'parf0' 
 	include 'parf_mike' 

	dimension t_t(ntime),ppx_t(npo,ntime)

	dimension ppx(*)

	character *12 apr
	
	nw=tay_p/tay

      if(nw.lt.2)return

	if(kpr.eq.1)print *,' tay_p tay nw=',tay_p,tay,nw
	apr='ppx'
      if(kpr.eq.1)print 71,apr,(ppx(i),i=1,n) 

	if(time.lt.tt-0.5*tay)then
c  saving for the next time_step...
	   do j=2,nw
	   do i=1,n
	      ppx_t(i,j-1) = ppx_t(i,j)
	   end do
!	   t_t(j-1) = t_t(j)
	   end do
	end if

	time=tt

      j=nw
!	t_t(j)=tt
	do i=1,n
	   ppx_t(i,j)=ppx(i)
	end do

      i_en=i_en+1
	if(i_en.eq.1)then
	   do j=1,nw
	   do i=1,n
	      ppx_t(i,j) = ppx(i)
	   end do
	   end do
        end if
      
	   do i=1,n
         ppx_avr=0.
	   do j=1,nw
	      ppx_avr=ppx_avr+ppx_t(i,j)
	   end do
           ppx(i)=ppx_avr/float(nw)
	   end do

	apr='imp1'
      if(kpr.eq.1)print 71,apr,(ppx(i),i=1,n) 

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))
      
      
      return 
      end 
      subroutine filter_imp2_time_c(tt,tay,ppx,n,tay_p,kpr)
	include 'double.inc'
 	include 'parf0' 
 	include 'parf_mike' 

	dimension t_t(ntime),ppx_t(npo,ntime)

	dimension ppx(*)

	character *12 apr
	
	nw=tay_p/tay

      if(nw.lt.2)return

	if(kpr.eq.1)print *,' tay_p tay nw=',tay_p,tay,nw
	apr='ppx'
      if(kpr.eq.1)print 71,apr,(ppx(i),i=1,n) 

	if(time.lt.tt-0.5*tay)then
c  saving for the next time_step...
	   do j=2,nw
	   do i=1,n
	      ppx_t(i,j-1) = ppx_t(i,j)
	   end do
!	   t_t(j-1) = t_t(j)
	   end do
	end if

	time=tt

      j=nw
!	t_t(j)=tt
	do i=1,n
	   ppx_t(i,j)=ppx(i)
	end do

      i_en=i_en+1
	if(i_en.eq.1)then
	   do j=1,nw
	   do i=1,n
	      ppx_t(i,j) = ppx(i)
	   end do
	   end do
        end if
      
	   do i=1,n
         ppx_avr=0.
	   do j=1,nw
	      ppx_avr=ppx_avr+ppx_t(i,j)
	   end do
           ppx(i)=ppx_avr/float(nw)
	   end do

	apr='imp2'
      if(kpr.eq.1)print 71,apr,(ppx(i),i=1,n) 

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))
      
      
      return 
      end 
      subroutine filter_imp3_time_c(tt,tay,ppx,n,tay_p,kpr)
	include 'double.inc'
 	include 'parf0' 
 	include 'parf_mike' 

	dimension t_t(ntime),ppx_t(npo,ntime)

	dimension ppx(*)

	character *12 apr
	
	nw=tay_p/tay

      if(nw.lt.2)return

	if(kpr.eq.1)print *,' tay_p tay nw=',tay_p,tay,nw
	apr='ppx'
      if(kpr.eq.1)print 71,apr,(ppx(i),i=1,n) 

	if(time.lt.tt-0.5*tay)then
c  saving for the next time_step...
	   do j=2,nw
	   do i=1,n
	      ppx_t(i,j-1) = ppx_t(i,j)
	   end do
!	   t_t(j-1) = t_t(j)
	   end do
	end if

	time=tt

      j=nw
!	t_t(j)=tt
	do i=1,n
	   ppx_t(i,j)=ppx(i)
	end do

      i_en=i_en+1
	if(i_en.eq.1)then
	   do j=1,nw
	   do i=1,n
	      ppx_t(i,j) = ppx(i)
	   end do
	   end do
        end if
      
	   do i=1,n
         ppx_avr=0.
	   do j=1,nw
	      ppx_avr=ppx_avr+ppx_t(i,j)
	   end do
           ppx(i)=ppx_avr/float(nw)
	   end do

	apr='imp3'
      if(kpr.eq.1)print 71,apr,(ppx(i),i=1,n) 

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))
      
      
      return 
      end 
      subroutine filter_imp4_time_c(tt,tay,ppx,n,tay_p,kpr)
	include 'double.inc'
 	include 'parf0' 
 	include 'parf_mike' 

	dimension t_t(ntime),ppx_t(npo,ntime)

	dimension ppx(*)

	character *12 apr
	
	nw=tay_p/tay

      if(nw.lt.2)return

	if(kpr.eq.1)print *,' tay_p tay nw=',tay_p,tay,nw
	apr='ppx'
      if(kpr.eq.1)print 71,apr,(ppx(i),i=1,n) 

	if(time.lt.tt-0.5*tay)then
c  saving for the next time_step...
	   do j=2,nw
	   do i=1,n
	      ppx_t(i,j-1) = ppx_t(i,j)
	   end do
!	   t_t(j-1) = t_t(j)
	   end do
	end if

	time=tt

      j=nw
!	t_t(j)=tt
	do i=1,n
	   ppx_t(i,j)=ppx(i)
	end do

      i_en=i_en+1
	if(i_en.eq.1)then
	   do j=1,nw
	   do i=1,n
	      ppx_t(i,j) = ppx(i)
	   end do
	   end do
        end if
      
	   do i=1,n
         ppx_avr=0.
	   do j=1,nw
	      ppx_avr=ppx_avr+ppx_t(i,j)
	   end do
           ppx(i)=ppx_avr/float(nw)
	   end do

	apr='imp4'
      if(kpr.eq.1)print 71,apr,(ppx(i),i=1,n) 

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))
      
      
      return 
      end 
      subroutine filter_imp5_time_c(tt,tay,ppx,n,tay_p,kpr)
	include 'double.inc'
 	include 'parf0' 
 	include 'parf_mike' 

	dimension t_t(ntime),ppx_t(npo,ntime)

	dimension ppx(*)

	character *12 apr
	
	nw=tay_p/tay

      if(nw.lt.2)return

	if(kpr.eq.1)print *,' tay_p tay nw=',tay_p,tay,nw
	apr='ppx'
      if(kpr.eq.1)print 71,apr,(ppx(i),i=1,n) 

	if(time.lt.tt-0.5*tay)then
c  saving for the next time_step...
	   do j=2,nw
	   do i=1,n
	      ppx_t(i,j-1) = ppx_t(i,j)
	   end do
!	   t_t(j-1) = t_t(j)
	   end do
	end if

	time=tt

      j=nw
!	t_t(j)=tt
	do i=1,n
	   ppx_t(i,j)=ppx(i)
	end do

      i_en=i_en+1
	if(i_en.eq.1)then
	   do j=1,nw
	   do i=1,n
	      ppx_t(i,j) = ppx(i)
	   end do
	   end do
        end if
      
	   do i=1,n
         ppx_avr=0.
	   do j=1,nw
	      ppx_avr=ppx_avr+ppx_t(i,j)
	   end do
           ppx(i)=ppx_avr/float(nw)
	   end do

	apr='imp5'
      if(kpr.eq.1)print 71,apr,(ppx(i),i=1,n) 

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))
      
      
      return 
      end 


