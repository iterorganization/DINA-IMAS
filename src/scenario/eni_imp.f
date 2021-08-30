      SUBROUTINE ENIT(N_xx)
	include 'double.inc'
	include 'new_com.inc'

      call ENIT_c(N_xx,
     *       ro_bar,alf_bar,key_lh,coef_kessel_1,tt_h,
     *       key_h_to_l,w_imp,w_imp2,w_imp3,w_imp4,w_imp5,pcch,
     *       p_n0,pn0_tot)

c      print*,'from enet w_imp2,w_imp3,w_imp4,w_imp5',
c     *  w_imp2,w_imp3,w_imp4,w_imp5


	return
	end


      SUBROUTINE ENIT_c(N,
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
	dimension z_imp1(npo),z_imp2(npo),z_imp3(npo)
	dimension z2_imp1(npo),z2_imp2(npo),z2_imp3(npo),talfa2(npo)
	dimension z_imp4(npo),z_imp5(npo)
	dimension z2_imp4(npo),z2_imp5(npo)

      common	
     *  /c_imas3/w_imp_pr(npo),w_imp_pr2(npo)
     *  /c_imas5/q_imp1(npo),q_imp2(npo),q_imp3(npo),
     *  q_imp4(npo),q_imp5(npo)
     
 	
c-------------
	
	character*10 apr
c  ===
c   here the noclassical parameters are calculated
	flog1(pnx,tx)=23.4-1.15*13.*alog10(pnx)+3.45*alog10(tx)
	flog2(pnx,tx)=25.3-1.15*13.*alog10(pnx)+2.3*alog10(tx)
	fk1(z)=2.94333-0.75*z+0.106667*z**2
	fa1(z)=1.20333-0.21*z+2.66667e-2*z**2
	fb1(z)=1.8-0.869999*z+0.14*z**2
	fc1(z)=1.64333-0.669999*z+9.66665e-2*z**2
c
	fk2(z)=4.91334-0.850001*z+0.126667*z**2
	fa2(z)=0.64-8.00003e-2*z+0.01*z**2
	fb2(z)=1.05667-0.535*z+8.83333e-2*z**2
	fc2(z)=0.96-0.41*z+5.99999e-2*z**2
c
	fk3(z)=2.23333-0.47*z+6.66667e-2*z**2
	fa3(z)=0.85-0.195*z+0.025*z**2
	fb3(z)=0.42-0.115*z+0.015*z**2
	fc3(z)=0.77-0.125*z+0.015*z**2
c
	fkmn(fk0,fa0,fb0,fc0,ve0,epi)=fk0/(1.+fa0*sqrt(ve0)+
     *  fb0*ve0)/(1.+fc0*ve0*epi**1.5)
c=======

!      tego=100.d0
      
      N2=N-1
      QE0(1)=0.
      QQ0(1)=0.
      DEL(1)=0.
	apr='te0'
c        print 71,apr,(te0(i),i=1,n)
	apr='tq0'
c        print 71,apr,(tq0(i),i=1,n)
	apr='pne'
c        print 71,apr,(pne(i),i=1,n)
	apr='pd0'
c        print 71,apr,(pd0(i),i=1,n)
	apr='pt0'
c        print 71,apr,(pt0(i),i=1,n)
	apr='ph0'
c        print 71,apr,(ph0(i),i=1,n)
	apr='tq0'
c        print 71,apr,(tq0(i),i=1,n)
	apr='zeff'
c        print 71,apr,(zeff(i),i=1,n)
	apr='q'
c        print 71,apr,(q(i),i=1,n)
	i=0.8*n
       zhib1=zhib*(0.3+ai(i)**2)
c ---->  Auxiliary heating power calculated (only in 17 point is deposited)

      i_en=i_en+1
      if(i_en.eq.1)then
         open (unit=41, file='heat_profile.dat',form='formatted')
         read (41,*)
         read (41,*)w_heat1,w_heat2
         read (41,*)
         read (41,*)coef_n0,tay_lo_xx

c	 print *,'w_heat1 w_heat2',w_heat1,w_heat2
         close (41)
      end if

c      pause 'from eni_st.f'

	summ=0.
	do i=2,n
c           if(ttb.ge.70000.)then
           if(ttb.ge.tt_h)then
              summ=summ+(1.-ai(i)**1.5)**2.*2.*pi*vi(i)*ha(i)
ccc	summ=summ+(1.-ai(i)**2)*2.*pi*vi(i)*ha(i)
c!!!!!!!!!!!	if(ai(i).le.w_heat)summ=summ+2.*pi*vi(i)*ha(i)
           else
              if(ai(i).ge.w_heat1.and.ai(i).le.w_heat2)
     *          summ=summ+2.*pi*vi(i)*ha(i)
           end if
	end do
	aemoe=emoe/summ
	aemoq=emoq/summ
c

 !!!     goto 4
      
  
!!!      call pn0_read()

      n0_xx=1.e-15
      
      
      pi_tot=0. 
      vv=0.
	do i=1,n
	pi_tot=pi_tot+(pd0(i)+pt0(i))*2.*pi*vi(i)*ha(i)
	vv=vv+2.*pi*vi(i)*ha(i)
	end do
	pi_tot=pi_tot/vv

!       n0_xx=pi_tot*coef_n0
       n0_xx=p_n0
       
      if(kpr.eq.1)print*,'n0_xx pi_tot ',n0_xx,pi_tot

      pn0_tot=0. 
      vv=0.
	do i=1,n
!	pn0(i)=a(i)**10.
	pn0(i)=a(i)**coef_n0
!	pn0(i)=1.
	pn0_tot=pn0_tot+pn0(i)*2.*pi*vi(i)*ha(i)
	vv=vv+2.*pi*vi(i)*ha(i)
	end do
	pn0_tot=pn0_tot/vv
	
	alf1=n0_xx/pn0_tot
	
      if(kpr.eq.1)print*,'coef_n0 vv',coef_n0,vv*1.e-6
	
	pn0_tot=0.
	do i=1,n
	pn0(i)=pn0(i)*alf1
	pn0_tot=pn0_tot+pn0(i)*2.*pi*vi(i)*ha(i)
	end do
	pn0_tot=pn0_tot/vv

      if(kpr.eq.1)print*,'n0_xx pn0_tot',n0_xx,pn0_tot

4     continue

      vv=0.
      pn0_tot=0.
	do i=1,n
	pn0_tot=pn0_tot+pn0(i)*2.*pi*vi(i)*ha(i)
	vv=vv+2.*pi*vi(i)*ha(i)
	end do
	pn0_tot=pn0_tot/vv

      if(kpr.eq.1)print*,' pn0_tot vv',pn0_tot,vv

	do i=2,n
              QDE0(I)=0.
              QDQ0(I)=0.
ccc              QDE0(I)=aEMOE*(1.-ai(I)**2)
ccc              QDQ0(I)=aEMOQ*(1.-ai(i)**2)
c*** Kessel's case
c           if(ttb.ge.70000.)then
           if(ttb.ge.tt_h)then
              QDE0(I)=aEMOE*(1.-ai(I)**1.5)**2.0
              QDQ0(I)=aEMOQ*(1.-ai(i)**1.5)**2.0
c!!!!!!!!!!!!           if(ai(i).le.w_heat)then
              else
                 if(ai(i).ge.w_heat1.and.ai(i).le.w_heat2)then
                    QDE0(I)=aEMOE
                    QDQ0(I)=aEMOQ
                 end if
              end if
c	if(ai(i).le.0.8)n_f=i
	end do
C ================ Bohm/gyroBohm model for L-mode ====================^M
C^M
        
      PNOR=6.25E8
      if(kpr.eq.1)print*,'!!!tt=',ttb
      if(kpr.eq.1)print*,'emoe emoq',emoe/pnor,emoq/pnor

      if(i_en.eq.1) then
                 open (unit=41,file='bohm_gbohm.dat',form='formatted')
                read (41,*)
                read (41,*) k_Bohm
                read (41,*)
                close(41)
        end if

 !       kpr = 1
C^M

   
	do i=1,n

!        if(ntay.gt.next+1)then
        if(ntay.ge.0)then
      
        n_e_xx=pne(i)
        tn_xx=tq0(i)
        
        
!         print *,' ooo-n_e_xx n0_xx ==',n_e_xx,n0_xx
       
         call put_param_test2(pn0(i),n_e_xx,tn_xx,tay_lo_xx)

           te_zrad(1)=te0(i)*1.e-3

           call zrad(nz_imp,2,1,te_zrad,RES)
           z=res(1)
           call zrad(nz_imp,3,1,te_zrad,RES)
           zsq=res(1)

           z_imp1(i)=z
           z2_imp1(i)=zsq
           
           call zrad(nz_imp1,2,1,te_zrad,RES)
           z1=res(1)
           call zrad(nz_imp1,3,1,te_zrad,RES)
           z1sq=res(1)

           z_imp2(i)=z1
           z2_imp2(i)=z1sq

           call zrad(nz_imp2,2,1,te_zrad,RES)
           z2=res(1)
           call zrad(nz_imp2,3,1,te_zrad,RES)
           z2sq=res(1)

           z_imp3(i)=z2
           z2_imp3(i)=z2sq

           call zrad(nz_imp3,2,1,te_zrad,RES)
           z3=res(1)
           call zrad(nz_imp3,3,1,te_zrad,RES)
           z3sq=res(1)

           z_imp4(i)=z3
           z2_imp4(i)=z3sq

           call zrad(nz_imp4,2,1,te_zrad,RES)
           z4=res(1)
           call zrad(nz_imp4,3,1,te_zrad,RES)
           z4sq=res(1)

           z_imp4(i)=z4
           z2_imp4(i)=z4sq
     
        coef_imp=pnal(i)/pne(i)
              
        pne1=pd0(i)+pt0(i)


!      	pd0(i)=0.5d0*pne(i)*(1.d0-coef_imp*z-coef_imp1*z-
!     *  coef_imp2*z2)
     
!        pt0(i)=pd0(i)

      	pne(i)=-(pd0(i)+pt0(i))/ (coef_imp*z+coef_imp1*z1+
     *  coef_imp2*z2+coef_imp3*z3+coef_imp4*z4-1.d0)
     
        zeff(i)=(1.d0-coef_imp*z-coef_imp1*z1-
     *  coef_imp2*z2-coef_imp3*z3-coef_imp4*z4)
     *  +(coef_imp*zsq+coef_imp1*z1sq+
     *  coef_imp2*z2sq+coef_imp3*z3sq+coef_imp4*z4sq)


        if(i.eq.2)then
        if(kpr.eq.1)print *,' i coef_imp pnal pne  ',
     *  i,coef_imp,pnal(i),pne(i)
        if(kpr.eq.1)print *,' zeff pd0 pt0  ',
     *  zeff(i),pd0(i),pt0(i)

        end if


        if(i.eq.2)then
        if(kpr.eq.1)print *,' coef_imp1 coef_imp2 ',coef_imp1,coef_imp2
        if(kpr.eq.1)print *,' coef_imp3 coef_imp4 ',coef_imp3,coef_imp4
        end if

        if(i.eq.2)then
        if(kpr.eq.1)print *,' z1 z2 ',z1,z2
        if(kpr.eq.1)print *,' z1sq z2sq ',z1sq,z2sq
        end if


!      zeff(i)=2.
              
c*** q_imp calculation       
!           te_zrad(1)=te0(i)*1.e-3
           call zrad(nz_imp,1,1,te_zrad,RES)
c*** [W/m3]*6.25/1e4 >>>>> [DINA units] 

           q_imp1(i)=res(1)*pne(i)**2*coef_imp*1.e6*6.25e-4

        if(te0(I).le.3.)then
!            q_imp1(i)=0.d0
        end if

           q_imp(i)=q_imp1(i)
           
           call zrad(nz_imp1,1,1,te_zrad,RES)
           q_imp2(i)=res(1)*pne(i)**2*coef_imp1*1.e6*6.25e-4
       if(i.le.n-1)then
	 if(kpr.eq.-1)write(6,'(" te res pne coef_imp1 q_imp2 ",
     *  6(1pe13.6))'),te_zrad(1),res(1),pne(i),coef_imp1,q_imp2(i)
       end if
      
            if(te0(I).le.3.)then
!            q_imp2(i)=0.d0
            end if

           q_imp(i)=q_imp(i)+q_imp2(i)
           

           call zrad(nz_imp2,1,1,te_zrad,RES)
           q_imp3(i)=res(1)*pne(i)**2*coef_imp2*1.e6*6.25e-4
        if(te0(I).le.3.)then
!            q_imp3(i)=0.d0
        end if
           q_imp(i)=q_imp(i)+q_imp3(i)

           call zrad(nz_imp3,1,1,te_zrad,RES)
           q_imp4(i)=res(1)*pne(i)**2*coef_imp3*1.e6*6.25e-4
        if(te0(I).le.3.)then
!            q_imp4(i)=0.d0
        end if
           q_imp(i)=q_imp(i)+q_imp4(i)

           call zrad(nz_imp4,1,1,te_zrad,RES)
           q_imp5(i)=res(1)*pne(i)**2*coef_imp4*1.e6*6.25e-4
        if(te0(I).le.3.)then
!            q_imp5(i)=0.d0
        end if
           q_imp(i)=q_imp(i)+q_imp5(i)

      end if

      talfa2(i)=talfa*1.d0/(1.d0-0.8*ai(i)**2)
	end do

      tay_p=10.*tay
      
      call filter_imp_time_c(ttb,tay,q_imp,n,tay_p,kpr)
      call filter_imp1_time_c(ttb,tay,q_imp1,n,tay_p,kpr)
      call filter_imp2_time_c(ttb,tay,q_imp2,n,tay_p,kpr)
      call filter_imp3_time_c(ttb,tay,q_imp3,n,tay_p,kpr)
      call filter_imp4_time_c(ttb,tay,q_imp4,n,tay_p,kpr)
      call filter_imp5_time_c(ttb,tay,q_imp5,n,tay_p,kpr)

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
      
      w_imp1=w_imp1+q_imp1(i)*2.*pi*vi(i)*ha(i)
      w_imp2=w_imp2+q_imp2(i)*2.*pi*vi(i)*ha(i)
      w_imp3=w_imp3+q_imp3(i)*2.*pi*vi(i)*ha(i)
      w_imp4=w_imp4+q_imp4(i)*2.*pi*vi(i)*ha(i)
      w_imp5=w_imp5+q_imp5(i)*2.*pi*vi(i)*ha(i)


      w_imp_pr(i)=q_imp1(i)+q_imp2(i)+q_imp3(i)+q_imp4(i)+q_imp5(i)
      w_imp_pr2(i)=q_imp2(i)
      w_imp_pr(i)=w_imp_pr(i)*2.*pi*vi(i)*ha(i)/pnor
      w_imp_pr2(i)=w_imp_pr2(i)*2.*pi*vi(i)*ha(i)/pnor
      

!      q_imp(i)=10.

	end do

      w_imp1=w_imp1/pnor
      w_imp2=w_imp2/pnor
      w_imp3=w_imp3/pnor
      w_imp4=w_imp4/pnor
      w_imp5=w_imp5/pnor

      w_imp=w_imp1+w_imp2+w_imp3+w_imp4+w_imp5

	 if(kpr.eq.1)write(6,'(" w_imp1+w_imp2+w_imp3+w_imp4+w_imp5 ",
     *  6(1pe13.6))'),w_imp1,w_imp2,w_imp3,w_imp4,w_imp5



!      print*,'from eni'
c      print *,' w_imp1 w_imp2 w_imp3',w_imp1,w_imp2,w_imp3
c      print *,' w_imp4 w_imp5',w_imp4,w_imp5

c      print*,'w_imp=',w_imp
c      read(*,*)

        if (k_Bohm .eq. 1) then
                call bohm_gb()
C^M
                if(kpr.eq.1) then
                        apr =' array -he_bgb- for Bohm/gyroBohm ' 
                        print 71,apr,(he_bgb(i), i = 1,n)
                        apr =' array -xi_bgb- for Bohm/gyroBohm ' 
                        print 71,apr,(xi_bgb(i), i = 1,n)
                end if
C^M
        end if


	apr='zeff'
!        print 71,apr,(zeff(i),i=1,n)

	apr='pnal'
!        print 71,apr,(pnal(i),i=1,n)

	apr='talfa2'
!        print 71,apr,(talfa2(i),i=1,n)

	apr='pne'
!        print 71,apr,(pne(i),i=1,n)

	apr='pd0'
!        print 71,apr,(pd0(i),i=1,n)

	apr='pt0'
!        print 71,apr,(pt0(i),i=1,n)

	apr='z_imp1'
!        print 71,apr,(z_imp1(i),i=1,n)
	apr='z2_imp1'
!        print 71,apr,(z2_imp1(i),i=1,n)
	apr='z_imp2'
!        print 71,apr,(z_imp2(i),i=1,n)
	apr='z2_imp2'
!        print 71,apr,(z2_imp2(i),i=1,n)

	apr='z_imp3'
!        print 71,apr,(z_imp3(i),i=1,n)
	apr='z2_imp3'
!        print 71,apr,(z2_imp3(i),i=1,n)

	apr='q_imp1'
!        print 71,apr,(q_imp1(i),i=1,n)
	apr='q_imp2'
!        print 71,apr,(q_imp2(i),i=1,n)
	apr='q_imp3'
!        print 71,apr,(q_imp3(i),i=1,n)



c----------
	do i=2,n
	pbe(i)=pne(i)*te0(i)
	pbi(i)=(pd0(i)+pt0(i)+ph0(i))*tq0(i)
	end do
	pbe(1)=pbe(2)
	pbi(1)=pbi(2)
      DO 1 I=2,N
	dpbe=(pbe(i)-pbe(i-1))/(pbe(i)+pbe(i-1)*0.5*ha(i))
	dpbi=(pbi(i)-pbi(i-1))/(pbi(i)+pbi(i-1)*0.5*ha(i))
	dtbe=(te0(i)-te0(i-1))/(te0(i)+te0(i-1)*0.5*ha(i))
	dtbi=(tq0(i)-tq0(i-1))/(tq0(i)+tq0(i-1)*0.5*ha(i))
cccc	zeff(i)=(pd0(i)+pt0(i)+zar**2*ppr(i)+4.*pnal(i))/pne(i)
      PG=0.5*(PNE(I)+PNE(I-1))
      TGE=0.5*(TE0(I)+TE0(I-1))
      if(tge.le.0.)tge=1.
      if(pg.le.0.)pg=1.
	if(tgE.le.50.)qlog=flog1(pg,tgE)
	if(tgE.gt.50.)qlog=flog2(pg,tgE)
c------------
	qlog=16.
c--------------
c
C       ej=-0.267*rs*1.48*sqrt(eu/rs*ai(i))/psi(i)*1.e-3
C       ajb(i)=ej*(tgE*(pne(i)-pne(i-1))/ha(i)+0.285*pg*(te0(i)-te0(i-1))
C     */ha(i)-0.175*pg*(tq0(i)-tq0(i-1))/ha(i))

c
c
      POT=(2.*PD0(I)+3.*PT0(I)+1.*PH0(I))/PNE(I)
      TGI=0.5*(TQ0(I)+TQ0(I-1))
c--- V_ii term ....
c      VII=7.2E6/(SQRT(POT)*ABS(TGI)**1.5)*PG*zeff(i)**4*qlog/15.
      VII=7.2E6/(SQRT(POT)*ABS(TGI)**1.5)*PG*qlog/15.
c---V-ei term ....
c	vei=vii*sqrt(1836.)*(tgi/tgE)**1.5/zeff(i)**2
	vei=vii*sqrt(1836.d0)*(tgi/tgE)**1.5
c---V-ee term ....
	vee=vei/zeff(i)**2
c---
c  inverse aspect EPI ...
        EPI_0=AI(I)*eu/rs
c
	epi_m=a_m(i)/r_m(i)
      EPI=epi_m
c  W_i frequency ....
c      WI=9.57E3*BT*zeff(i)/POT*1.E3
      WI=9.57E3*BT/POT*1.E3
c  W_e frequency ....
      WE=1.76e7*BT*1.E3
c  V_i ion velocity ...
      VTI=SQRT(1.9d0*ABS(TGI)/POT)*1.E6
c  v_e electrons velocity ...
	vte=sqrt(1836.d0*tgE/tgi)*vti
c  V_i/W_i
      RI=VTI/WI
c
	bp0=-psi(i)/(2.*pi*rs)*gra1(i)
ccc      DI=RI**2*Q(I)**2/EPI**1.5*VII
	Q_I=epi*bt/bp0
c	print *,' q_i q(i)',q_i,q(i)
      DI=RI**2*Q_I**2/EPI**1.5*VII
c
      VI0=SQRT(2.d0)*Q(I)*RS*VII/(VTI*EPI**1.5)
c
c  V_e/W_e
      RE=VTE/WE
c
      DE=RE**2*Q(I)**2/EPI**1.5*VEE
c
c****   ve0=sqrt(2.)*q(i)*rs*vei/(vte*epi**1.5)
	ve0=sqrt(2.d0)*q(i)*rs*vee/(vte*epi**1.5)
c
	a1e=dpbe-2.5*dtbe+tgi/tgE/zeff(i)*(dpbi-1.17/(
     *1.+ve0**2*epi**2)*dtbi)
	bp0=-psi(i)/(2.*pi*rs)*gra1(i)
	bp0_d=epi*bt/q(i)

c	print *,' i epi_0 epi_m',i,epi_0,epi_m
c	print *,' i bp0 bp0_d=bp_0(i)=',i,bp0,bp0_d,bp_0(i)
c
	z=zeff(i)
	fk0=fk1(z)
	fa0=fa1(z)
	fb0=fb1(z)
	fc0=fc1(z)
	kpe=0
	if(ve0.lt.0.)kpe=1
	if(kpe.eq.0)go to 700
	if(kpr.eq.1)print *,'rs epi eu',rs,epi,eu
	if(kpr.eq.1)print*,'vei',vei,'vte',vte,'ve0',ve0,'epi',epi
	if(kpr.eq.1)print*,'vii',vii,'pg',pg,'glog',qlog
700     continue
	fk13=fkmn(fk0,fa0,fb0,fc0,ve0,epi)
c
	fk0=fk2(z)
	fa0=fa2(z)
	fb0=fb2(z)
	fc0=fc2(z)
	fk23=fkmn(fk0,fa0,fb0,fc0,ve0,epi)
c
	fk0=fk3(z)
	fa0=fa3(z)
	fb0=fb3(z)
	fc0=fc3(z)
	fk33=fkmn(fk0,fa0,fb0,fc0,ve0,epi)
c
	dup=fk33*sqrt(epi)
c ----> here neoclassical conductiviy is calculated. ## dup is correction #
c       sigk(i)=1.-dup
c-----------------------------------------------------------
	ft=1.-(1.-epi)**2/(sqrt(1.d0-epi**2)*(1.+1.46*sqrt(epi)))
	enu=0.6913*qlog*rs*q(i)*pg/(tge**2*epi*sqrt(epi))
	cr=0.56/zeff(i)*(3.-zeff(i))/(3.+zeff(i))
	xsi=0.58+0.2*zeff(i)
	ale=3.4/zeff(i)*(1.13+zeff(i))/(2.67+zeff(i))
	sigk(i)=0.5*ale*(1.-ft/(1.+xsi*enu))
     *  *(1.-cr/(1.+xsi*enu))
c       sigk(i)=1.-1.31*1.48*sqrt(eu/rs*ai(i))
c
c*** sigk(i)=0 is Spitser!!!
c!!!!!        sigk(i)=0.
c
c-----> bootstreap current density
	ajb(i)=-0.16e-3*pg*tge*sqrt(epi)/bp0*(fk13*a1e+fk23*
     *dtbe)

c===================
c  pressure and derivatives ...
	p_e=0.5*(pbe(i)+pbe(i-1))
	p_i=0.5*(pbi(i)+pbi(i-1))
	p_ed=(pbe(i)-pbe(i-1))/(psi(i)*ha(i))
	p_id=(pbi(i)-pbi(i-1))/(psi(i)*ha(i))
c temperature and derivatives ....
	t_e=0.5*(te0(i)+te0(i-1))
	t_i=0.5*(tq0(i)+tq0(i-1))
	t_ed=(te0(i)-te0(i-1))/(psi(i)*ha(i))
	t_id=(tq0(i)-tq0(i-1))/(psi(i)*ha(i))
c density
	d_e=0.5*(pne(i)+pne(i-1))
	d_i=d_e
c
	xft=ft/(1.-ft)
	dxft=1.414*zeff(i)+zeff(i)**2+xft*(0.754+2.657*zeff(i)+
     *  2.*zeff(i)**2)+xft**2*(0.348+1.243*zeff(i)+zeff(i)**2)
	alft=-1.172/(1.+0.462*xft)
	pl31=(0.745+2.21*zeff(i)+zeff(i)**2+xft*(0.348+1.243*zeff(i)+
     *  zeff(i)**2))/dxft
	pl32=(0.884+2.074*zeff(i))/dxft
	a1e=p_ed/p_e
	a1i=p_id/p_i
	a2e=t_ed/t_e
	a2i=t_id/t_i
	cinv=1./(zeff(i)*t_e/t_i)
c  F---f(i)*rs*1.e-3
	pl310=pl31*(f(i)*rs*1.e-3)*p_e*xft
	pl320=-pl32*(f(i)*rs*1.e-3)*p_e*xft
c
	a13=0.027*zeff(i)**2-0.211*zeff(i)+1.204
	a23=0.01*zeff(i)**2-0.008*zeff(i)+0.64
	b13=0.14*zeff(i)**2-0.87*zeff(i)+1.8
	b23=0.088*zeff(i)**2-0.535*zeff(i)+1.057
	c13=0.097*zeff(i)**2-0.67*zeff(i)+1.643
	c23=0.06*zeff(i)**2-0.41*zeff(i)+0.96
c
	ve0h=ve0*epi**1.5
	vi0h=vi0*epi**1.5
c
	f1=(1.+a13*sqrt(ve0)+b13*ve0)*(1.+c13*ve0h)
	pl31=pl310/f1
	f2=(1.+a23*sqrt(ve0)+b23*ve0)*(1.+c23*ve0h)
	pl32=(pl320+2.5*pl310)/f2-2.5*pl31
	fa=(1.+vi0h**2)*(1.+ve0h**2)
	alfi=( (alft+0.35*sqrt(vi0))/(1.+0.7*sqrt(vi0))+
     *  2.1*vi0h**2)/fa
c
	bstrap=(pl31*( a1e+cinv*(a1i+alfi*a2i) )+pl32*a2e)
c= = = = =
	ajbn(i)=pl310*(a1e+cinv*(a1i+alft*a2i))+pl320*a2e
c  p-- 1.6 psi-- 1.*pi*1.e5 ...
	ajbn(i)=ajbn(i)*(1.6*2.*pi*1.e+5)
	bstrap=bstrap*(1.6*2.*pi*1.e+5)
c  [ a/m**2*Tl] --> [kA/cm**2*kG] 1.e-3/1.e+4*10. --
	ajbn(i)=ajbn(i)*(1.e-7*10.)
	bstrap=bstrap*(1.e-7*10.)
c
	ajbn(i)=ajbn(i)/bt
	bstrap=bstrap/bt
	ajbn(1)=0.
	ajbn(2)=0.5*ajbn(3)
cc        print *,'i ajb ajbn bstrap',i,ajb(i),ajbn(i),bstrap
	ajb(i)=ajbn(i)
	ajb(2)=ajbn(2)
c
c
c=========================
c
c
c
c
c neoclassical ions ....
      PKI_old=0.66*(1./(1.+1.03*SQRT(VI0)+0.31*VI0)+1.77*EPI**1.5*
     *VI0/(1.+0.74*EPI**1.5*VI0))
c----
      PKIS=(0.66+1.88*sqrt(epi)-1.54*epi)*bsq(i)
      PKI=0.66*( pkis/0.66/(1.+1.03*SQRT(VI0)+0.31*VI0)+1.77*EPI**1.5*
     *VI0*fasp(i)/(1.+0.74*EPI**1.5*VI0))
c----->  neoclassical ion heat conductivity DXQ
      DXQ(I)=1.5*zeff(i)*PKI*DI*1.E-3*GRA2(I)
c  in m2/s----++++
      x_i(I)=0.1*PKI*DI*1.E-3
c      print *,' i epi pki_o pki  x_i =',i,epi,pki_old,pki,x_i(i)
c
c  anomalous factor anom_i for ions...
      DXQ(i)=anom_i*DXQ(i)
      x_i(i)=anom_i*x_i(i)
c
c
      PKE=0.66*(1./(1.+1.03*SQRT(VE0)+0.31*VE0)+1.77*EPI**3*
     *VE0/(1.+0.74*EPI**1.5*VE0))
c----->  neoclassical electrons ...
      if(key_t11.eq.1)then
      DXE(I)=PKE*DE*1.E-3*GRA2(I)
c  in m2/s----++++
      x_e(I)=0.1*PKE*DE*1.E-3
      end if
c
c
c----->  TAY_ei exchange term
      DEL(I)=700.*PG**2*zeff(i)**2/POT/ABS(TGE)**1.5
c
c
c-----> joul heating term QDH
c        QDH(I)=QDG(I)/ABS(TGE)**1.5/sigk(i)
         QDH(I)=QDG(I)
c
c
c----> breamstruggling power QTOR
      QTOR(I)=1.E-3*PG**2*SQRT(ABS(TGE))*ZEFF(i)**2
c
c
	xt=710.*eu/(rs*sqrt(tgE))
	fi=2.e-8*tgE**1.5*sqrt(bt/(eu*pne(i)))*sqrt(1.+xt)
c-----> cyclotron power qce
	qce(i)=1.5*0.265e-5*bt*bT*tgE*fi
C*****************
      TETI=TQ0(I)/93800.
      Sech=2.56*TQ0(I)**(-2./3.)*
     *(1.+7.*TETI**(3./4.))/(1.+242.*TETI**
     *(13./4.))**0.5*EXP(-200./TQ0(I)**(1./3.))
c------> alfa particle source SAL
      SAL(I)=SEch*PD0(I)*PT0(I)
	pnal(i)=(sal(i)+pnaln(i)/tay)/(1./tay+1./talfa2(i))
c
c----->  neutron power QNET
      QNET(I)=14.6E6*SAL(I)
c
      ZA1=4./POT**(2./3.)
      Z1=(DD*2.+DT*3.+DH*1.)/POT**(2./3.)
      ENA1=14.8*TE0(I)*ZA1
      EN1=14.8*TE0(I)*Z1
      uA=ENA1/3.5E6
      u=EN1/Eee
      uAS=SQRT(uA)
      uS=SQRT(u)
      AAl=uA*(0.6+1./3.*aLOG((1.-uAS+uA)/(1.+uAS)**2)+1.1547*
     *ATAN((2.-uAS)/SQRT(3.d0)/uAS))
      Al=u*(0.6+1./3.*alOG((1.-uS+u)/(1.+uS)**2)+1.1547*
     *ATAN((2.-uS)/SQRT(3.d0)/uS))
c
c-----> retardation of Alfa particles is calculated
	ts=6.27e-2/qlog*tge**1.5/pg
	pin(i)=(pin0(i)+sal(i)*tay)/(1.+2.*tay/ts)
	q11(i)=3.5e6/ts*2.*pin(i)
	pal(i)=2./3.*q11(i)*ts
c-------> alfa particles power transfer to electrons QAE
cccc       QAE(I)=(1.-AAl)*q11(I)
c
c-------> alfa particles power transfer to ions QAQ
cccc       QAQ(I)=AAl*q11(I)
c
       QAE(I)=3.5E6*(1.-AAl)*SAL(I)
       QAQ(I)=3.5E6*AAl*SAL(I)
c---> power transfer from neutral beam to electrons QPE
ccc      QpE(I)=Eee*(1.-Al)*SB(I)
      QpE(I)=(1.-Al)*qbeam(I)
c----> power transfer from neutral beam to ions QPQ
ccc      QpQ(I)=Eee*Al*SB(I)
      QpQ(I)=Al*qbeam(I)
c
c---> electrons energy source
	nal=1
c	print *,' nal==',nal
        QE0(I)=ndh*QDH(I)-QTOR(I)+QpE(I)*NIJ+
     *  QAE(I)*NAL+QDE0(I)*NDOP-qce(i)
c---> ions energy source
      QQ0(I)=QpQ(I)*NIJ +QAQ(I)*NAL+QDQ0(I)*NDOP
      
      pow_e=pow_e+(ndh*QDH(I)+QpE(I)*NIJ+
     *  QAE(I)*NAL+QDE0(I)*NDOP)*2.*pi*vi(i)*ha(i)/pnor
     
      pow_i=pow_i+(QpQ(I)*NIJ +QAQ(I)*NAL+QDQ0(I)*NDOP)*
     *  2.*pi*vi(i)*ha(i)/pnor
   
      plos_e=plos_e-(QTOR(I)-qce(i))*2.*pi*vi(i)*ha(i)/pnor

      
c******************************************
c   here tego is only parameter
c-----> parabolic profile in heat conductivity
c       if(i.ge.n/3)higo=zhib/tego*(0.1+ai(i)**2)*eu*eu

      pow=2.
      higo=zhib/tego*(0.3+ai(i)**pow)*eu*eu

c-----> heat coductivity is constant
!!!       if(i.lt.0.8*n)higo=zhib1/tego*eu*eu


c        higo=zhib/tego*eu*eu


c**********************************************************
	xig=higo

	if(key_t11.eq.0)then
	x_e(i)=0.1*xig
	dxe(i)=xig*gra2(i)
	end if
c
c---------  RADIAL DEPENDENT T-11 SCALING for X_e..
c       te11=3.5e-5*(ai(i)*eu/rs)**0.25*q(n)*pcch*rs**3/sqrt(tec)
c
	x11=0.5*1.e4*sqrt(tge/pot)*((ai(i)*eu/rs)**1.75)/(q(i)*pg*rs)

        x11=x11*anom_e
c
c  in m2/s
	if(key_t11.eq.1)then
c	x_e(i)=0.1*x11+3.*x_e(i)
c	dxe(i)=x11*gra2(i)+3.*dxe(i)
	x_e(i)=0.1*x11
	dxe(i)=x11*gra2(i)
	end if
c        print *,'i dxe dxq',i,dxe(i),dxq(i)
c
c---------
c-----> duffusivity is xii=dxe*0.2 to use real transport ...
	if(kcchp.eq.0)XII(I)=DXE(I)
c-----> duffusivity is DXe*1.e-5 to use give profiles
	if(kcchp.eq.1)XII(I)=DXE(I)*1.e-1
c	if(kcchp.eq.1)XII(I)=DXE(I)
c----->ion heat conductivity is equal to electron heat conductivity
cc      dxq(i)=dxe(i)
c----->ion h cond is equal to elec +2* neocl.
c       dxq(i)=dxe(i)+2.*dxq(i)

c-------------

c!!!        dxq(i)=2.*dxe(i)

c=====================================================
        if (k_Bohm .eq. 1) then

                dxe(i) = 10. * he_bgb(i) * gra2(i)       
! in cm^2/ms^M
C
                dxq(i) = 10. * xi_bgb(i) * gra2(i) + dxq(i)
! in \  cm^2/ms^M
ccc         dxq(i) = 10. * xi_bgb(i) * gra2(i)
             else 
                dxq(i)=2.*dxe(i)
        end if
C
C =====================================================================^M
C                               The     end of Bohm/gyroBohm patch ^M
C =====================================================================^M



c-----------------

    1 CONTINUE
c       here cold neutals included CALL NETR
c       if(noit.eq.0)

!!!      CALL p_loss()
      
	do i=2,n
c       if(te0(i).ge.20.)qu=7.3e5*dexp(-0.094*te0(i))/16.
c       if(te0(i).lt.20.)qu=1.e2*dexp(0.35*te0(i))/16.
c electron ionization ligt wie (cold neutrals)
	wie(i)=0.
c change-exange on  ions (cold neutrals)
	wcx(i)=0.
c---> impurity ligh qpr (here oxigen)
c       qpr(i)=qu*ppr(i)*pne(i)
c       qe0(i)=qe0(i)-qpr(i)

!        if(ntay.gt.next+1)then

      

c           q_imp=0.

        qe0(i)=qe0(i)-q_imp(i)
  

!      From p_loss!!!

        qe0(i)=qe0(i)-qpr(i)

        plos_e=plos_e-(q_imp(i)-qpr(i))*2.*pi*vi(i)*ha(i)/pnor

c       qe0(i)=qe0(i)-wie(i)
c       qq0(i)=qq0(i)-wcx(i)
       
c        print*,'qtor q_imp',qtor(i),q_imp(i)
c        read(*,*)
!      end if


c      print*,'alf_bar ro_bar',alf_bar,ro_bar
c      read(*,*)

	if(ai(i).ge.ro_bar)then
       dxe(i)=alf_bar*dxe(i)
       dxq(i)=alf_bar*dxq(i)
	end if
	
       dxe(i)=dabs(dxe(i))
       dxq(i)=dabs(dxq(i))

	end do

   71 FORMAT(20X,A6/,(6(1pE10.3)))

      zeff(1)=zeff(2)
      
      pow_tot=pow_e+pow_i    
      	 if(kpr.eq.1)write(6,'(" pow_e pow_i pow_tot plos_e  ",
     *  6(1pe13.6))'),pow_e,pow_i,pow_tot,plos_e

      print *,'  zhib xigo =',zhib,higo
      print *,'  higo tego=',higo,tego

	apr='w_imp'
      if(kpr.eq.1)print 71,apr,(w_imp_pr(i),i=1,n)
	apr='w_be'
      if(kpr.eq.1)print 71,apr,(w_imp_pr2(i),i=1,n)
      
	apr='pn0'
      if(kpr.eq.1)print 71,apr,(pn0(i),i=1,n)
	apr='qe0'
      if(kpr.eq.1)print 71,apr,(qe0(i),i=1,n)
	apr='dxe'
      if(kpr.eq.1)print 71,apr,(dxe(i),i=1,n)
	apr='dxq'
      if(kpr.eq.1)print 71,apr,(dxq(i),i=1,n)
      
	if(kpr.eq.1)print *,'nz_imp coef_imp==',
     * nz_imp,coef_imp
	if(kpr.eq.1)print *,'nz_imp1 coef_imp1==',
     * nz_imp1,coef_imp1
	if(kpr.eq.1)print *,'nz_imp2 coef_imp2==',
     * nz_imp2,coef_imp2

	if(ntay.eq.0)return

c        print*,'key_t11 key_lh',key_t11,key_lh

c        print*,'ntay key_t11 key_lh key_h_to_l',
c     *    ntay,key_t11,key_lh,key_h_to_l    
c        read (*,*)

c&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	if(key_t11.eq.0)return
        if(key_lh.eq.0.or.key_h_to_l.eq.1)return
c&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

      PNOR=6.25E8
 

	ptot=0.
	p_los=0.
	p_lossn=0.

	do i=2,n
	vol(i)=vol(i-1)+vi(i)*ha(i)

	forme(i)=forme(i-1)+qe0(i)*2.*pi*vi(i)*ha(i)/pnor*1.e6
	formi(i)=formi(i-1)+qq0(i)*2.*pi*vi(i)*ha(i)/pnor*1.e6

!!!	ptot=ptot+2.*pi*vi(i)*ha(i)/pnor*(qe0(i)+qq0(i))
	ptot=ptot+2.*pi*vi(i)*ha(i)/pnor*1.e6*(qe0(i)+qq0(i)+
ccc     &       qtor(i)+qce(i)+q_imp(i))
     &       qtor(i)+qce(i)+q_imp(n))
c!!!!abs!!!
        ptot=abs(ptot)
c!!!!abs!!!

	p_los=p_los+2.*pi*vi(i)*ha(i)/pnor*q_imp(i)

	p_lossn=p_lossn+2.*pi*vi(i)*ha(i)/pnor*qpr(n)

	end do


	if(kpr.eq.1)print *,' p_los p_lossn==',
     * p_los,p_lossn

	apr='vol'
c        print 71,apr,(vol(i),i=1,n)
	apr='forme'
c        print 71,apr,(forme(i),i=1,n)
	apr='formi'
c        print 71,apr,(formi(i),i=1,n)

	apr='vi'
c        print 71,apr,(vi(i),i=1,n)

	apr='pfi'
c        print 71,apr,(pfi(i),i=1,n)

	apr='r_m'
c        print 71,apr,(r_m(i),i=1,n)

	apr='gra2'
c      print 71,apr,(gra2(i),i=1,n)

c	print *,'ptot,pi==',ptot,pi

	do i=2,n

	forme_xx=0.5*(forme(i)+forme(i-1))/forme(n)
	formi_xx=0.5*(formi(i)+formi(i-1))/formi(n)

	vprime=2.*pi*vi(i)*1.e-6/(pfi(i)*1.e-5)

	gps=(pfi(i)*1.e-5)**2*(gra2(i)*1.e4)

	arad=sqrt (0.5*( vol(i)/r_m(i)+vol(i-1)/r_m(i-1) )/pi )*1.e-2

c	 write(6,'(" i forme_xx,formi_xx,vprime,gps,arad ",
c     *  i4,1x,6(1pe13.6))'),
c     *  i,forme_xx,formi_xx,
c     &     vprime,gps,arad

	      call coppi(i,
     &     x_ee,x_ii,ptot,forme_xx,formi_xx,
     &     vprime,gps,arad)

	x_e(i)=x_ee
	dxe(i)=10.*x_ee*gra2(i)

	x_i(i)=x_ii
	dxq(i)=10.*x_ii*gra2(i)

c---------------------

c!!!        coef_kessel=2.
        coef_kessel=2.5
ccc	dxe(i)=2.5*dxe(i)
ccc	dxq(i)=2.5*dxq(i)
cccccc        if(key_lh.eq.1)coef_kessel=1.1
c        if(key_lh.eq.1)coef_kessel=1.1
ccccc        if(key_lh.eq.1)coef_kessel=1.16

        if(key_lh.eq.1)coef_kessel=coef_kessel_1
ccc        if(key_lh.eq.1)coef_kessel=1.
	dxe(i)=coef_kessel*dxe(i)
	dxq(i)=coef_kessel*dxq(i)

c************ core!!!!!!!
ccccc        coef_core=1.4
ccccccc        coef_core=1.45
        coef_core=1.55
        if(key_lh.eq.1)then
	if(ai(i).le.0.925)then
           dxe(i)=coef_core*dxe(i)
           dxq(i)=coef_core*dxq(i)
	end if
	end if


	end do
c
c	x_e(1)=x_e(2)
c	x_i(1)=x_i(2)
c	do i=2,nf
c       x_e(i)=x_e(nf)
c        dxe(i)=x_e(i)*10.*gra2(i)
c	end do
c

      call anom_e_read()

	do i=2,n
	  dxe(i)=dxe(i)*anom_e
	  dxq(i)=dxq(i)*anom_e

	end do

	apr='++dxe'
      if(kpr.eq.1)print 71,apr,(dxe(i),i=1,n)
	apr='++dxq'
      if(kpr.eq.1)print 71,apr,(dxq(i),i=1,n)

	do i=2,n

       dxe(i)=dabs(dxe(i))
       dxq(i)=dabs(dxq(i))

	end do


	apr='ajb'
c        print 71,apr,(ajb(i),i=1,n)
	apr='dxe'
!        print 71,apr,(dxe(i),i=1,n)
	apr='dxq'
!        print 71,apr,(dxq(i),i=1,n)
	apr='Qe0'
c        print 71,apr,(qe0(i),i=1,n)


	apr='x_e'
c        print 71,apr,(x_e(i),i=1,n)


	apr='Qq0'
c        print 71,apr,(qq0(i),i=1,n)
      RETURN
      END
c

c.......................................................................
c.....coppi/tang profile consistency model
c         REF: S.C.Jardin, M.G.Bell,N.Pomphrey, Nucl Fusion 33 p371(1993)
      subroutine coppi(i_xx,
     &     chiemks_xx,chiimks_xx,ptot_xx,forme_xx,formi_xx,
     &     vprime_xx,gps_xx,arad_xx)
      include 'double.inc'
      include 'new_com.inc'
      
      call coppi_c(i_xx,
     &     chiemks_xx,chiimks_xx,ptot_xx,forme_xx,formi_xx,
     &     vprime_xx,gps_xx,arad_xx,
     &     n,pne,rmag,dfmax,q_95,rs0,bt0,zeff,key_lh)

      return
      end

      subroutine coppi_c(i_xx,
     &     chiemks_xx,chiimks_xx,ptot_xx,forme_xx,formi_xx,
     &     vprime_xx,gps_xx,arad_xx,
     &     n,pne,rmag,dfmax,q_95,rs0,bt0,zeff,key_lh)
	include 'double.inc'

        dimension pne(*),dfmax(*),zeff(*)



c 	print *,' n==',n

c	 write(6,'(" i forme_xx,formi_xx,vprime,gps,arad ",
c     *  i4,1x,6(1pe13.6))'),
c     *  i_xx,forme_xx,formi_xx,
c     &     vprime_xx,gps_xx,arad_xx

c	 write(6,'(" i ptot_xx,pne,rmag,dfmax,q_95 ",
c     *  i4,1x,6(1pe13.6))'),
c     *  i_xx,ptot_xx,pne(i_xx),rmag,dfmax(i_xx),q_95

c	 write(6,'(" i rs0,bt0,zeff ",
c     *  i4,1x,6(1pe13.6))'),
c     *  i_xx,rs0,bt0,zeff(i_xx)


        alphar=1.        

        a121=0.08
        a122=0.42
        a123=0.5
c        a123=-0.5
c        a123=-1.5
c        a123=-3.5
        a126=1.0

        a3003=-1.e-5
        a3011=1.
        if(key_lh.eq.1)then
c           a3003=0.25
           a3003=0.1
           a3011=0.925
ccc           a3011=0.85
           alphar=0.5        
        end if
        a3004=1.
        a3005=1.
        a3006=-1.e-5

c      DESCRIPTION OF RETURNED QUANTITIES:
c
c
c     chiemks   - electron thermal conductivity in m**2/sec
c     chiimks   - ion      thermal conductivity in m**2/sec
c     chiaux    - relative size of auxialliary heated part (diagnostic)
c     chiohm    - relative size of ohmic heated part (diagnostic)
c
c     DESCRIPTION OF INPUT QUANTITIES:
c
c     ane0      - central electron density (1/m**3)
c     anel       - electron density at this surface (1/m**3)
c     xmag      - magnetic axis location (m)
c     tflux     - toroidal flux (Wb)
c     tfluxb    - toroidal flux at plasma/vacuum boundary (Wb)
c     ptot      - total input power to plasma, ohmic+auxialliary (Watts)
c     forme     - normalized heating power (including Ohmic heating) to
c     formi       electrons (forme) and ions(formi) inside surface tflux
c                 [see P(tflux)/P(tfluxb) in eq 26 of Ref]
c     vprime    - differential volume wrt toroidal flux (m**3/Wb)
c     gps       - [grad(tflux)]**2  [Wb/m]**2
c     q_95       - safety factor at the 95% flux surface
c     arad      - approximate minor radius, sqrt[volume/(2*pi**2*R)]
c     gzero     - R times the vacuum toroidal field (T-m)
c     zeff      - effective charge state at this surface
c     alphar    - outer density exponent, n = n0*[(1-fedge)*(1-rhob)a +fedge]
c     a121      - transport multiplier for auxialliary heated part (0.08)
c     a122      - transport multiplier for ohmic part (0.42)
c     a123      - constant added to q95 (0.5)
c     a126      - ratio of chi-i to chi-e (1.0)
c                - if negative, then abs[a126] is chi-i in m**2/sec
c….a3003...coefficient in H-mode pedestal modeling, Chi multiplier
c….a3011...coefficient in H-mode pedestal modeling, pedestal location
c….a3004…coefficient for ITB modeling, inner location
c….a3005…coefficient for ITB modeling, outer location
c….a3006…coefficient for ITB modeling, Chi multiplier (set to 0.0)
c
        data pi/3.1415926535/
        q95pct = q_95
        if(q95pct.gt.6.0) q95pct=6.0
        if(q95pct.lt.2.0) q95pct=2.0
        alphaq = (q95pct + a123)
        if(alphaq .lt. 2.0) alphaq = 2.0
        rps = 1.e-4
        formfs = forme_xx
        formis = formi_xx
        if(formfs.gt.1.0) formfs = 1.0
       if(formfs.lt.rps) formfs = rps
       if(formis.gt.1.0) formis = 1.0
       if(formis.lt.rps) formis = rps
c
       ane0=pne(1)*1.e19
       anel=pne(i_xx)*1.e19
       xmag=rmag*1.e-2
       tfluxb=dfmax(n)*1.e-5
       tflux=dfmax(i_xx)*1.e-5
       gzero=bt0*0.1*rs0*1.e-2

c	 write(6,'(" i ane0 anel tfluxb tflux gzero arad",
c     *  i4,1x,6(1pe13.6))'),
c     *  i_xx,ane0,anel,tfluxb,tflux,gzero,arad_xx

       
       befoe = 8*pi**2*formfs*(ane0/(anel*vprime_xx))
     &      *xmag*tfluxb*exp(.667*alphaq*tflux/tfluxb)
c
       befoi = 8*pi**2*formis*(ane0/(anel*vprime_xx))
     &      *xmag*tfluxb*exp(.667*alphaq*tflux/tfluxb)
c     
       chiaux = a121*(7.5e8)*(ptot_xx/ane0)**0.6
     &      /((gzero*q95pct)**(0.8)*arad_xx**0.2)
       chiohm = a122*1.25e20/ane0*arad_xx*gzero**0.3*zeff(i_xx)**0.2
     &      *(1.0+0.25*alphar)/(xmag**2.2*q95pct**1.6)
c
       chi0 = sqrt(chiohm**2 + chiaux**2)
       chiauxs = chiaux
       chiohms = chiohm

      if(kpr.eq.1)then

	 write(6,'(" chi0 chiauxs chiohms befoe befoi",
     *  6(1pe13.6))'),
     *  chi0,chiauxs,chiohms,befoe,befoi
     
       end if
       
c
c
c.....reduce electron and ion transport near plasma edge for H-mode
       fhmode = 1.
       if(tflux .ge. tfluxb*a3011 .and. a3003 .gt. 0.) fhmode = a3003
c
c...reduce electron and ion confinement over a region for ITBs
       fitb=1.
       if(tflux .ge. a3004*tfluxb .and. tflux .le. a3005*tfluxb
     &      .and. a3006 .gt. 0.) then
          fitb=1. + a3006*(1.-(tflux/(a3005*tfluxb)))**2
       endif

       if(kpr.eq.1)then

	 write(6,'(" fhmode fitb",
     *  6(1pe13.6))'),
     *  fhmode,fitb
     
        end if
        
c
c
c......no convection,  factor of abs(acoef(126)) less ion conduction
       coef1 = 0.
       coef2 = -befoe*chi0 *fhmode*fitb
       if(a126.gt.0) then
       coef3 = -abs(a126)*befoi*chi0 *fhmode*fitb
       else
c
c....change made 11/4/97....scj
       coef3 = amin1(a126*gps_xx , coef2)
       endif
c

c	 write(6,'(" coef1 coef2 coef3 gps_xx",
c     *  6(1pe13.6))'),
c     *  coef1, coef2, coef3,gps_xx


c.....electron thermal conductivity in m**2/sec
       if(abs(gps_xx).gt.1.e-10) then
       chiemks_xx = -coef2/gps_xx
       chiimks_xx = -coef3/gps_xx
       endif

       if(kpr.eq.1)then


	 write(6,'(" chiemks chiimks",
     *  6(1pe13.6))'),
     *  chiemks_xx, chiimks_xx
     
        end if
        
c
       return
       end



	subroutine p_loss()
		include 'double.inc'
	include 'new_com.inc'

	call p_loss_c(
     *  tt,qpr,
     *  pi,n,ai,ha,vi,te0,
     *  kpr)
	
	return
	end

	subroutine p_loss_c(
     *  tt,qpr,
     *  pi,n,ai,ha,vi,te0,
     *  kpr)

    	include 'double.inc'
	include 'parf0'

      dimension qpr(*),ai(*),ha(*),vi(*),te0(*)

	dimension a_print(100)
	character *30 apr
 	include 'parf_mike' 

	dimension t_t(ntime),power_ech_t(ntime)

	i_sh=i_sh+1



!      goto 5
      
            
      
	if(i_sh.eq.1)then
c-------
           open (unit=41,file='p_loss.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 

 	 if(kpr.eq.1)print *,' p_loss  tt n_t===',power_ech,tt,n_t 

           do i=1,n_t 
              read (41,*)t_t(i),power_ech_t(i)
              t_t(i)=t_t(i)*1000. 
           end do 
           
           apr='-t_t-' 
           if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 

           apr='-p_loss_t-' 
           if(kpr.eq.1)print 71,apr,(power_ech_t(i),i=1,n_t) 

        	call get_data_in_time(pcch,tene,wdop,
     *      p_sum,p_loss)

         do i=1,3
         power_ech_t(i)=p_loss
         end do

           apr='++p_loss_t-' 
           if(kpr.eq.1)print 71,apr,(power_ech_t(i),i=1,n_t) 
         
           close (unit=41) 
        end if

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

      do i=2,n_t
      if( (tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
	 t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )

	 power_ech=power_ech_t(i-1)+t_coef*(power_ech_t(i)-
     *  power_ech_t(i-1))
c
	 end if

	 end do
	 
5     continue
	 

!      power_ech=3.2708e0
      
	if(kpr.eq.1)print *,' from p_loss ',power_ech

      PNOR=6.25E8

c  Electrons cooling....

	summ=0.
	do i=2,n
!	     qpr(i)=1.
	     qpr(i)=te0(i)
c	     qpr(i)=1.-ai(i)**2
           summ=summ+qpr(i)*2.*pi*vi(i)*ha(i)
      end do
	summ_e=summ/pnor

	al1=power_ech/summ_e

	do i=2,n
           qpr(i)=qpr(i)*al1
      end do

	summ=0.
	do i=2,n
           summ=summ+qpr(i)*2.*pi*vi(i)*ha(i)
      end do
	summ_e=summ/pnor
      
      
	if(kpr.eq.1)print *,' p_loss==',summ_e

       return 
       end 



      subroutine anom_e_read()
	include 'double.inc'
	include 'new_com.inc'

	call anom_e_read_c(
     *       anom_e,tt,kpr)

	return
	end
      subroutine anom_e_read_c(
     *       anom_e,tt,kpr)

	include 'double.inc'
 	include 'parf_mike' 

	dimension t_t(ntime),pn_d_t(ntime)
	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='anom_e.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 
           
           if(kpr.eq.1)print *,' tay tt n_t===',tay,tt,n_t 
           
           do i=1,n_t 
              read (41,*)t_t(i),pn_d_t(i)
             t_t(i)=t_t(i)*1000. 
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

              anom_e=pn_d_t(i-1)+t_coef*
     *             (pn_d_t(i)-pn_d_t(i-1))
c
	 end if

	 end do

      if(kpr.eq.1)print *,' tt anom_e==',tt,anom_e
c	stop

        
	return
	end



      subroutine gamma_z1_read()
	include 'double.inc'
	include 'new_com.inc'

 
	call gamma_z1_read_c(
     *       coef_imp1,tt,kpr,nz_imp1)

        return
        end
      subroutine gamma_z1_read_c(
     *       gamma_z1,tt,kpr,nz_imp1)

	include 'double.inc'
 	include 'parf_mike' 


	dimension t_t(ntime),pn_d_t(ntime)
	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='gamma_z1.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t,nz_imp1 
           read (41,*) 
           
           if(kpr.eq.1)print *,' tay tt n_t nz_imp1===',
     *  tay,tt,n_t,nz_imp1 
           
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

              gamma_z1=pn_d_t(i-1)+t_coef*
     *             (pn_d_t(i)-pn_d_t(i-1))
c
	 end if

	 end do

      if(kpr.eq.1)print *,' tt gamma_z1 ==',tt,gamma_z1
c	stop

        
	return
	end

      subroutine gamma_z2_read()
	include 'double.inc'
	include 'new_com.inc'
      include 'br_com.inc'

        include 'par_imp.inc'
        include 'new_imp.inc'

	call gamma_z2_read_c(
     *       coef_imp2,tt,kpr,nz_imp2)
     
       gamma_z2=coef_imp2
       n_imp(2)=nz_imp2

           if(kpr.eq.1)print *,' --n_imp2 nz_imp2===',
     *  n_imp(2),nz_imp2

	return
	end
      subroutine gamma_z2_read_c(
     *       gamma_z2,tt,kpr,nz_imp2)

	include 'double.inc'
 	include 'parf_mike' 

	dimension t_t(ntime),pn_d_t(ntime)
	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='gamma_z2.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t,nz_imp2 
           read (41,*) 
           
           if(kpr.eq.1)print *,' tay tt n_t nz_imp2===',
     *  tay,tt,n_t,nz_imp2
           
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

              gamma_z2=pn_d_t(i-1)+t_coef*
     *             (pn_d_t(i)-pn_d_t(i-1))
c
	 end if

	 end do

      if(kpr.eq.1)print *,' tt gamma_z2==',tt,gamma_z2
c	stop

        
	return
	end

      subroutine gamma_z3_read()
	include 'double.inc'
	include 'new_com.inc'

	call gamma_z3_read_c(
     *       coef_imp3,tt,kpr,nz_imp3)

	return
	end
      subroutine gamma_z3_read_c(
     *       gamma_z3,tt,kpr,nz_imp3)

	include 'double.inc'
 	include 'parf_mike' 

	dimension t_t(ntime),pn_d_t(ntime)
	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='gamma_z3.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t,nz_imp3 
           read (41,*) 
           
           if(kpr.eq.1)print *,' tay tt n_t nz_imp3===',
     *  tay,tt,n_t,nz_imp3
           
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

              gamma_z3=pn_d_t(i-1)+t_coef*
     *             (pn_d_t(i)-pn_d_t(i-1))
c
	 end if

	 end do

      if(kpr.eq.1)print *,' tt gamma_z3==',tt,gamma_z3
c	stop

        
	return
	end
      subroutine gamma_z4_read()
	include 'double.inc'
	include 'new_com.inc'

	call gamma_z4_read_c(
     *       coef_imp4,tt,kpr,nz_imp4)

	return
	end
      subroutine gamma_z4_read_c(
     *       gamma_z4,tt,kpr,nz_imp4)

	include 'double.inc'
 	include 'parf_mike' 

	dimension t_t(ntime),pn_d_t(ntime)
	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='gamma_z4.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t,nz_imp4 
           read (41,*) 
           
           if(kpr.eq.1)print *,' tay tt n_t  nz_imp4===',
     *  tay,tt,n_t,nz_imp4
           
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

              gamma_z4=pn_d_t(i-1)+t_coef*
     *             (pn_d_t(i)-pn_d_t(i-1))
c
	 end if

	 end do

      if(kpr.eq.1)print *,' tt gamma_z4==',tt,gamma_z4
c	stop

        
	return
	end

      subroutine gamma_z5_read()
	include 'double.inc'
	include 'new_com.inc'

       print *,' coef_imp4 tt kpr===',coef_imp4,tt,kpr 

       
	call gamma_z5_read_c(
     *       coef_imp4,tt,kpr)



	return
	end
      subroutine gamma_z5_read_c(
     *       gamma_z4,tt,kpr)

	include 'double.inc'
 	include 'parf_mike' 

	dimension t_t(ntime),pn_d_t(ntime)
	character *12 apr

       print *,' 1 coef_imp4 tt kpr===',coef_imp4,tt,kpr 


	i_sh=i_sh+1

       print *,' 2 coef_imp4 tt kpr i_sh===',coef_imp4,tt,kpr,i_sh 

	if(i_sh.le.5)then
c-------
           open (unit=41,file='gamma_z4.dat',form='formatted') 
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

       print *,' -- coef_imp4 tt kpr===',coef_imp4,tt,kpr 
      
      	return

      
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))


        i_coef=0
        do i=2,n_t
           if((tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
              t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )
              
              i_coef=i
              
              gamma_z4=pn_d_t(i-1)+t_coef*
     *             (pn_d_t(i)-pn_d_t(i-1))
c
	 end if

	 end do

      if(kpr.eq.1)print *,' i_coef n_t===',i_coef,n_t 

      if(kpr.eq.1)print *,' tt t_coef gamma_z4==',tt,t_coef,gamma_z4
c	stop

        
	return
	end
      subroutine gamma_z6_read()
	include 'double.inc'
	include 'new_com.inc'

       print *,' 100 coef_imp4 tt kpr===',coef_imp4,tt,kpr 

       
	call gamma_z6_read_c(
     *       coef_imp4,tt,kpr)



	return
	end

      subroutine gamma_z6_read_c(
     *       gamma_z4,tt,kpr)

	include 'double.inc'
 	include 'parf_mike' 

	dimension t_t(ntime),pn_d_t(ntime)
	character *12 apr

       print *,' 100 coef_imp4 tt kpr===',coef_imp4,tt,kpr 


	i_sh=i_sh+1

       print *,' 100 coef_imp4 tt kpr i_sh===',coef_imp4,tt,kpr,i_sh 
	return
	end



      subroutine pn0_read()
	include 'double.inc'
	include 'new_com.inc'

	call pn0_read_c(
     *       p_n0,tt,kpr)

	return
	end
      subroutine pn0_read_c(
     *       p_n0,tt,kpr)

	include 'double.inc'
 	include 'parf_mike' 

	dimension t_t(ntime),pn_d_t(ntime)
	character *12 apr

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
             t_t(i)=t_t(i)*1000. 
           if(kpr.eq.1)print *,' i t_t n_d_t==',i,t_t(i),pn_d_t(i)
           end do 
           
           apr='-t_t-' 
           if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 

           apr='-n0_t-' 
           if(kpr.eq.1)print 71,apr,(pn_d_t(i),i=1,n_t) 


           close (unit=41) 
        end if


71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

        do i=2,n_t
           if((tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
              t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )

              p_n0=pn_d_t(i-1)+t_coef*
     *             (pn_d_t(i)-pn_d_t(i-1))
c
	 end if

	 end do

      if(kpr.eq.1)print *,' tt p_n0==',tt,p_n0
c	stop

        
	return
	end
