      SUBROUTINE TP_neut_imp()
      include 'double.inc'
      include 'new_com.inc'
      include 'par_imp.inc'
      include 'new_imp.inc'
	
      call TP_neut_imp_c(n,
     *  difx_imp,ai,vn,tay,kpr,den_neut_imp,ha,ha2,ggt,ggtn,
     *  den0_neut_imp,f_a,ntay,vt0_imp,prog_n0_imp,sd0,
     *  pn0_av_imp,gra1,gra2)
	
	return
	end


      SUBROUTINE TP_neut_imp_c(n,
     *  difx_imp,ai,vi,tay,kpr,den_neut_imp,ha,ha2,ggt,ggtn,
     *  den0_neut_imp,f_a,ntay,vt0_imp,prog_n0_imp,sd0,
     *  pn0_av_imp,gra1,gra2)
c----------------------------------------------
c  neutrals diffusion
c-----------------------------------
      include 'double.inc'
	include 'parf0'
      dimension A(npo),B(npo),C(npo),fz(npo),HG(npo),
     *DH1(npo),dh2(npo),TETA(npo),VI1(npo),GK(npo),FD(npo),
     *FT(npo),FH(npo),
     *PD(npo),PT(npo),PH(npo),WD(npo),WT(npo),
     *WH(npo),U(npo),B0(npo),Z(npo),vu(npo),aiu(npo),ug(npo),
     *vg(npo),gg(npo)

      dimension difx_imp(*),ai(*),vi(*),sd0(*),
     * den_neut_imp(*),ha(*),ha2(*),ggt(*),ggtn(*),den0_neut_imp(*),
     * f_a(*),gra1(*),gra2(*)

c
        
      character *20 apr

c	print *,' ntay tay==',ntay,tay


	p_hi=6.d0

	ntran=0

      N2=N-1

      ALFA=1.

      i=1
      dh1(i)=0.5
      dh2(i)=0.

      do i=2,n2

         dh1(i)=ha(i)/(ha(i)+ha(i+1))
         dh2(i)=ha(i+1)/(ha(i)+ha(i+1))
      end do
      
      ha2(1)=0.5*ha(2)

      DO 1 I=1,N

	aiu(i)=ai(i)
	vu(i)=vi(i)
	gg(i)=vi(i)

      fz(I)=1.d0

       VG(I)=0.
       HG(I)=0.

      TETA(I)=1.d0/HA2(I)
    1 CONTINUE

      DO 8 I=1,N
      GGT(I)=Vu(I)
    8 CONTINUE


      apr=' ai**'
c      if(kpr.eq.1)PRINT 71,apr,(ai(I),I=1,N)

      apr=' vi**'
c      if(kpr.eq.1)PRINT 71,apr,(vi(I),I=1,N)

      apr=' ha**'
c      if(kpr.eq.1)PRINT 71,apr,(ha(I),I=1,N)

      apr=' ha2**'
c      if(kpr.eq.1)PRINT 71,apr,(ha2(I),I=1,N)

!!!      IF(NTAY.EQ.0)GO TO 99

    2 CONTINUE

!!!      CALL OITER(N)


      apr=' difx**'
c      if(kpr.eq.1)PRINT 71,apr,(difx(I),I=1,N)


      ALFA=1.
      BETA=1.

      beta1=0.

      A(1)=0.
      i=1

      b(I)=ug(i+1)/(2.*ha2(i))*beta1*(dh1(i)+dh2(i))
      c(I)=ug(i+1)/(2.*ha2(i))*beta1*(dh1(i)+dh2(i))

      B(I)=B(I)+ ALFA*(dh2(i)*fz(I)*GG(I)+dh1(i)*
     *fz(I+1)*GG(I+1))/TAY

      b(I)=b(i)-(f_a(I)*Vu(I)*dh2(i)+f_a(I+1)*Vu(I+1)*
     *dh1(i))
c
      c(i)=c(i)+hg(i+1)/ha(i+1)*vg(i+1)*dh1(i)
      b(i)=b(i)-hg(i)/ha(i+1)*vg(i+1)*dh1(i)

c
      DO I=2,N2
      A(I)=-UG(I)/(2.*ha2(i))*beta1*(dh1(i)+dh2(i))
      b(I)=(ug(i+1)-UG(I))/(2.*ha2(i))*beta1*(dh1(i)+dh2(i))
      c(I)=UG(I+1)/(2.*ha2(i))*beta1*(dh1(i)+dh2(i))
      B(I)=B(I)+ ALFA*(dh2(i)*fz(I)*GG(I)+dh1(i)*fz(I+1)*
     *GG(I+1))/TAY

      b(I)=b(i)-(f_a(I)*Vu(I)*dh2(i)+f_a(I+1)*Vu(I+1)*
     *dh1(i))

c
      a(i)=a(i)-hg(i-1)/ha(i)*vg(i)*dh2(i)
      c(i)=c(i)+hg(i+1)/ha(i+1)*vg(i+1)*dh1(i)
      b(i)=b(i)+hg(i)/ha(i)*vg(i)*dh2(i)-hg(i)/
     *ha(i+1)*vg(i+1)*dh1(i)
c
      end do

c  NEW additions...



      DO 4 I=2,N
c	dif(i)=100.
    4 GK(I)=-DIFx_imp(I)*VI(I)/HA(I)

      apr=' gk**'
      if(kpr.eq.1)PRINT 71,apr,(gk(I),I=1,N)

      apr=' ggt**'
      if(kpr.eq.1)PRINT 71,apr,(ggt(I),I=1,N)
      apr=' ggtn**'
      if(kpr.eq.1)PRINT 71,apr,(ggtn(I),I=1,N)

      apr=' f_a**'
      if(kpr.eq.1)PRINT 71,apr,(f_a(I),I=1,N)

      apr=' den0_neut_imp**'
      if(kpr.eq.1)PRINT 71,apr,(den0_neut_imp(I),I=1,N)

      apr=' phn**'
c      if(kpr.eq.1)PRINT 71,apr,(phn(I),I=1,N)



      DO 14 I=1,N2
      PKO=ALFA/TAY*(GGT(I)*dh2(i)+GGT(I+1)*dh1(i))
      FH(I)=PKO*den0_neut_imp(I) 

   14 CONTINUE

   71 FORMAT(20X,A6/,(6(1pE12.5)))

!!!      GO TO  99
c      IF(NTAY.EQ.0)GO TO  99
	keps=0

	lh=3

c---------------------

	prog_n0_imp=5.d1
	g_vt0_imp=1.e3*prog_n0_imp

	g_vt0=g_vt0_imp*gra1(n)

	uh=0.d0
	zh=-g_vt0*vi(n)*gra2(n)/gra1(n)

	print *,' g_vt0 g_vt0_imp',g_vt0,g_vt0_imp
	
	print *,' zh',zh


!	lh=1
	
	den_neut_imp(N)=prog_n0_imp
      PH(N)=den_neut_imp(N)

      CALL PROGP(N,A,B,C,TETA,GK,U,B0,PH,Z,WH,FH,
     *ZH,UH,EPS0,LH)

	do i=1,n
      den_neut_imp(I)=PH(I)
	end do

      apr=' den_neut_imp**'
      if(kpr.eq.1)PRINT 71,apr,(den_neut_imp(I),I=1,N)

	pn0_av=0.d0
	vv=0.d0

	do i=2,n
      pn0_av=pn0_av+0.5*(den_neut_imp(I)+den_neut_imp(I-1))*
     * vi(I)*ha(i)
      vv=vv+vi(I)*ha(i)
	end do
	pn0_av=pn0_av/vv
	pn0_av_imp=pn0_av

	bal=wh(n)-(uh*ph(n)+zh)

	print *,' bal_imp ==pn0_av_imp',bal,pn0_av_imp

c
   99 CONTINUE


      apr=' ph**'
      if(kpr.eq.1)PRINT 71,apr,(ph(I),I=1,N)

	

      RETURN
      END

         subroutine source_neut()

         include 'double.inc'
         include 'new_com.inc'
         include 'par_imp.inc'
         include 'new_imp.inc'

         call source_neut_c(
     *   n,nij,
     *   te0,tq0,pne,pd0,pt0,
     *   den_neut0,den_neut1,sd0,f_a)

         return
         end


         subroutine source_neut_c(
     *   n,nij,
     *   te0,tq0,pne,pd0,pt0,
     *   den_neut0,den_neut1,sd0,f_a)

         include 'double.inc'

         dimension te0(*),tq0(*),pne(*),
     *   pd0(*),pt0(*),sd0(*),f_a(*)

         dimension  den_neut1(*),den_neut0(*)

	common /c_imp_out2/qlos_e,qlos_imp,qloss_ion

       dimension denz(2),
     * rin_zog(2),rre_zog(2),rcx_zog(2)

	  dimension sd0_h(400)

         character * 20 apr

      nij=1

      Ry=0.0136

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))

	  f_a(1)=0.d0

         do i=1,n

               te=te0(i)
               ti=tq0(i)

               den_e= pne(i)
               den_i=(pd0(i)+pt0(i))

	t_e=te*1.d-3
	t_i=ti*1.d-3

      S_iT=2.d-0*sqrt(T_e/Ry)*dexp(-Ry/T_e)/(6.d0+T_e/Ry)
      S_cx=1.d-0*T_i**0.327d0

	
c		write(6,'(" i te ti den_e ",
c     *  i4,6(1pe11.4))'),
c     *  i,te,ti,den_e

	te_inp=T_e*1.e3
	tn_inp=T_i*1.e3
	den_n=den_neut0(i)

	nz_inp=1
       call rates_zog(te_inp,tn_inp,nz_inp,
     *  rin_zog,rre_zog,rcx_zog)


c	write(6,'(" i s_ion c_ion rin=",
c     *  i4,6(1pe11.4))'),
c     *  i,s_ion,c_ion,rin_zog(1)



c		write(6,'(" i c_ion S_iT rin_zog c_ex S_cx ",
c     *  i4,6(1pe11.4))'),
c     *  i,c_ion,S_iT,rin_zog(1),c_ex,S_cx

	c_ion=S_iT
	c_ex=S_cx


c		print*,'i  j  c_ion*den_e= c_ex*den_i =',i,j,c_ion*den_e,
c     *	c_ex*den_i

              sd0(i)=c_ion*(den_neut0(i)+
     *   		den_neut1(i))*1.d3

!              f_a(i)=(-c_ex*(den_neut0(i)+
!     *   		den_neut1(i)) )*1.d3

c		write(6,'(" i c_ion  c_ex s_dif v0 f_a p_lambda ",
c     *  i4,6(1pe11.4))'),
c     *  i,c_ion*den_e,c_ex*den_i,s_dif,v0*1.e6,f_a(i),p_lambda

           end do

           apr=' && f_a'
c           print 71,apr,(f_a(i),i=1,n)


	do i=2,n
	sd0_h(i)=0.5d0*(sd0(i)+sd0(i-1))
	end do

	do i=2,n
	sd0(i)=sd0_h(i)
	end do
	
           apr=' && sd0'
           print 71,apr,(sd0(i),i=1,n)


	return
	end

         subroutine source_neut_t()

         include 'double.inc'
         include 'new_com.inc'
         include 'par_imp.inc'
         include 'new_imp.inc'

         call source_neut_t_c(
     *   n,nij,
     *   te0,tq0,pne,pd0,pt0,
     *   den_neut0,den_neut1,sd0,st0,f_a,a_neut)

         return
         end


         subroutine source_neut_t_c(
     *   n,nij,
     *   te0,tq0,pne,pd0,pt0,
     *   den_neut0,den_neut1,sd0,st0,f_a,a_neut)

         include 'double.inc'

         dimension te0(*),tq0(*),pne(*),
     *   pd0(*),pt0(*),sd0(*),st0(*),f_a(*)

         dimension  den_neut1(*),den_neut0(*),a_neut(*)

	common /c_imp_out2/qlos_e,qlos_imp,qloss_ion

       dimension denz(2),
     * rin_zog(2),rre_zog(2),rcx_zog(2)

	  dimension sd0_h(400)

         character * 20 apr

      nij=1

      Ry=0.0136

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))

	  f_a(1)=0.d0

         do i=1,n

               te=te0(i)
               ti=tq0(i)

               den_e= pne(i)
               den_i=(pd0(i)+pt0(i))

	t_e=te*1.d-3
	t_i=ti*1.d-3

      S_iT=2.d-0*sqrt(T_e/Ry)*dexp(-Ry/T_e)/(6.d0+T_e/Ry)
      S_cx=1.d-0*T_i**0.327d0

	
c		write(6,'(" i te ti den_e ",
c     *  i4,6(1pe11.4))'),
c     *  i,te,ti,den_e

	te_inp=T_e*1.e3
	tn_inp=T_i*1.e3
	den_n=den_neut0(i)

	nz_inp=1
       call rates_zog(te_inp,tn_inp,nz_inp,
     *  rin_zog,rre_zog,rcx_zog)


c	write(6,'(" i s_ion c_ion rin=",
c     *  i4,6(1pe11.4))'),
c     *  i,s_ion,c_ion,rin_zog(1)



c		write(6,'(" i c_ion S_iT rin_zog c_ex S_cx ",
c     *  i4,6(1pe11.4))'),
c     *  i,c_ion,S_iT,rin_zog(1),c_ex,S_cx

	c_ion=S_iT
	c_ex=S_cx


c		print*,'i  j  c_ion*den_e= c_ex*den_i =',i,j,c_ion*den_e,
c     *	c_ex*den_i

              st0(i)=c_ion*(den_neut0(i)+
     *   		den_neut1(i))*1.d3

              a_neut(i)=den_neut0(i)+
     *   		den_neut1(i)


!              f_a(i)=(-c_ex*(den_neut0(i)+
!     *   		den_neut1(i)) )*1.d3

c		write(6,'(" i c_ion  c_ex s_dif v0 f_a p_lambda ",
c     *  i4,6(1pe11.4))'),
c     *  i,c_ion*den_e,c_ex*den_i,s_dif,v0*1.e6,f_a(i),p_lambda

           end do

           apr=' && sd0'
!           print 71,apr,(sd0(i),i=1,n)
           apr=' && f_a'
c           print 71,apr,(f_a(i),i=1,n)


	do i=2,n
	sd0_h(i)=0.5d0*(st0(i)+st0(i-1))
	end do

	do i=2,n
!	sd0(i)=sd0_h(i)
	st0(i)=sd0_h(i)
	end do


	return
	end



      SUBROUTINE TP_neut()
         include 'double.inc'
         include 'new_com.inc'
         include 'par_imp.inc'
         include 'new_imp.inc'


        call dif_c_neut()
        do i=1,n
        sd0(i)=0.
        end do
        
	   call TP_neut0()
	    call dif_h_neut()
	   call TP_neut1()
	   
        do i=1,n
        pn0(i)=den_neut0(i)+den_neut1(i)
        end do
         

        return
        end

         subroutine dif_c_neut_imp()

         include 'double.inc'
         include 'new_com.inc'
         include 'par_imp.inc'
         include 'new_imp.inc'

         call dif_c_neut_c_imp(
     *   n,nij,
     *   te0,tq0,pne,pd0,pt0,pdn,
     *   difx_imp,f_a,den_neut_imp,gra2,vt0_imp,n_imp)

         return
         end


         subroutine dif_c_neut_c_imp(
     *   n,nij,
     *   te0,tq0,pne,pd0,pt0,pdn,
     *   difx_imp,f_a,den_neut_imp,gra2,vt0_imp,n_imp)

         include 'double.inc'

         dimension te0(*),tq0(*),pne(*),
     *   pd0(*),pt0(*),gra2(*),pdn(*)

         dimension  difx_imp(*),f_a(*),den_neut_imp(*),n_imp(*)

	  common /c_imp_out2/qlos_e,qlos_imp,qloss_ion

       dimension denz(101),
     * rin_zog(101),rre_zog(101),rcx_zog(101)
	 
	dimension dif_h(400)

         character * 20 apr

	   a_coef=1.602/1.67
	   c_ion_h=1.d0
	   c_rec_h=1.d0
	   c_ex_h=1.d0
	   c_difx_neut=1.d0
	   p_hi=2.d0

	   a_imp=12.

         Ry=0.0136

	   alfa_rus=0.1d0

	   nij=1

       !!!!n_e*S_iz*1.e7
	
	i_test=0

	t_dif=3.d-3

!!!	t_dif=1.d-1

         do i=1,n

               te=te0(i)
               ti=tq0(i)

               den_e= pne(i)
               den_i=(pd0(i)+pt0(i))

	if(i_test.eq.1)then
	te=10.
	ti=10.

	den_e=0.5
	den_i=0.5
	end if

c	  t_dif=ti

	t_e=te*1.d-3
	t_i=ti*1.d-3

      S_iT=2.d-0*sqrt(T_e/Ry)*dexp(-Ry/T_e)/(6.d0+T_e/Ry)
      S_cx=1.d-0*T_i**0.327d0
	c_ion=S_iT

	
c		write(6,'(" i te ti den_e ",
c     *  i4,6(1pe11.4))'),
c     *  i,te,ti,den_e

	te_inp=T_e*1.e3
	tn_inp=T_i*1.e3
!	den_n=den_neut0(i)

	nz_inp=n_imp(1)
!	nz_inp=1
       call rates_zog(te_inp,tn_inp,nz_inp,
     *  rin_zog,rre_zog,rcx_zog)


c	write(6,'(" i  c_ion rin=",
c     *  i4,6(1pe11.4))'),
c     *  i,c_ion,rin_zog(1)


c		write(6,'(" i c_ion S_iT rin_zog c_ex S_cx ",
c     *  i4,6(1pe11.4))'),
c     *  i,c_ion,S_iT,rin_zog(1),c_ex,S_cx

	c_ion=rin_zog(1)
	c_ex=rcx_zog(1)

      c_elas=5.e-3
      s_dif=c_ion*den_e+c_elas*den_i

c		print*,'i  j  c_ion*den_e= c_ex*den_i =',i,j,c_ion*den_e,
c     *	c_ex*den_i

              f_a(i)=-(c_ion*den_e)*1.d3
              
			difx_imp(i)=c_difx_neut*a_coef/s_dif*1.d3

              difx_imp(i)=difx_imp(i)*tq0(i)/p_hi/a_imp
!!!              difx_imp(i)=difx_imp(i)*t_dif/p_hi

	v0=sqrt(t_dif/p_hi)
	p_lambda=v0/(s_dif) !  in cm

c		write(6,'(" i c_ion  c_ex s_dif v0 f_a p_lambda ",
c     *  i4,6(1pe11.4))'),
c     *  i,c_ion*den_e,c_ex*den_i,s_dif,v0*1.e6,f_a(i),p_lambda

           end do

           apr=' && f_a '
!           print 71,apr,(f_a(i),i=1,n)
           apr=' && sd0 '
!           print 71,apr,(sd0(i),i=1,n)


	do i=2,n
	  dif_h(i)=0.5d0*(difx_imp(i)+difx_imp(i-1))*gra2(i)
	end do
	  dif_h(1)=dif_h(2)

	do i=1,n
	  difx_imp(i)=dif_h(i)
	end do

       apr=' && difx_imp '
       print 71,apr,(difx_imp(j),j=1,n)



71	FORMAT(5X,A10/,(2x,6(1PE11.3)))

        return
        end
         subroutine dif_c_neut()

         include 'double.inc'
         include 'new_com.inc'
         include 'par_imp.inc'
         include 'new_imp.inc'

         call dif_c_neut_c(
     *   n,nij,
     *   te0,tq0,pne,pd0,pt0,pdn,
     *   difx,f_a,den_neut0,sd0,gra2,vt0,tay_sol,p_lambda0)

         return
         end


         subroutine dif_c_neut_c(
     *   n,nij,
     *   te0,tq0,pne,pd0,pt0,pdn,
     *   difx,f_a,den_neut0,sd0,gra2,vt0,tay_sol,p_lambda0)

         include 'double.inc'

         dimension te0(*),tq0(*),pne(*),
     *   pd0(*),pt0(*),sd0(*),gra2(*),pdn(*)

         dimension  difx(*),f_a(*),den_neut0(*),tay_sol(*),p_lambda0(*)

	  common /c_imp_out2/qlos_e,qlos_imp,qloss_ion

       dimension denz(2),
     * rin_zog(2),rre_zog(2),rcx_zog(2)
	 
	dimension dif_h(400)

         character * 20 apr

	   a_coef=1.602/1.67
	   c_ion_h=1.d0
	   c_rec_h=1.d0
	   c_ex_h=1.d0
	   c_difx_neut=1.d0
	   p_hi=2.d0

         Ry=0.0136

	   alfa_rus=0.1d0

	   nij=1

       !!!!n_e*S_iz*1.e7
	
	i_test=0

	t_dif=3.d-3

!!!	t_dif=1.d-1

         do i=1,n

               te=te0(i)
               ti=tq0(i)

               den_e= pne(i)
               den_i=(pd0(i)+pt0(i))

	if(i_test.eq.1)then
	te=10.
	ti=10.

	den_e=0.5
	den_i=0.5
	end if

c	  t_dif=ti

	t_e=te*1.d-3
	t_i=ti*1.d-3

      S_iT=2.d-0*sqrt(T_e/Ry)*dexp(-Ry/T_e)/(6.d0+T_e/Ry)
      S_cx=1.d-0*T_i**0.327d0

	
c		write(6,'(" i te ti den_e ",
c     *  i4,6(1pe11.4))'),
c     *  i,te,ti,den_e

	te_inp=T_e*1.e3
	tn_inp=T_i*1.e3
	den_n=den_neut0(i)

	nz_inp=1
       call rates_zog(te_inp,tn_inp,nz_inp,
     *  rin_zog,rre_zog,rcx_zog)


c	write(6,'(" i s_ion c_ion rin=",
c     *  i4,6(1pe11.4))'),
c     *  i,s_ion,c_ion,rin_zog(1)



c		write(6,'(" i c_ion S_iT rin_zog c_ex S_cx ",
c     *  i4,6(1pe11.4))'),
c     *  i,c_ion,S_iT,rin_zog(1),c_ex,S_cx

	c_ion=S_iT
	c_ex=S_cx

      s_ex=3.6d-1*sqrt(ti*1.d-3)
!!!	c_ex=s_ex

        s_dif=c_ion*den_e+c_ex*den_i


c		print*,'i  j  c_ion*den_e= c_ex*den_i =',i,j,c_ion*den_e,
c     *	c_ex*den_i

              f_a(i)=-(c_ion*den_e+c_ex*den_i)*1.d3

!!1              sd0(i)=pdn(i)/tay_sol(i)
              sd0(i)=0.d0

              difx(i)=c_difx_neut*a_coef/s_dif*1.d3

!!!              difx(i)=difx(i)*tq0(i)/p_hi
              difx(i)=difx(i)*t_dif/p_hi

	v0=sqrt(t_dif/p_hi)
	p_lambda0(i)=v0/(s_dif) !  in cm

!		write(6,'(" i v0, s_dif t_dif p_lambda0(i)",
!     *  i4,6(1pe11.4))'),
!     *  i,v0,s_dif,t_dif,p_lambda0(i)

c		write(6,'(" i c_ion  c_ex s_dif v0 f_a p_lambda ",
c     *  i4,6(1pe11.4))'),
c     *  i,c_ion*den_e,c_ex*den_i,s_dif,v0*1.e6,f_a(i),p_lambda

           end do

           apr=' && f_a '
!           print 71,apr,(f_a(i),i=1,n)
           apr=' && sd0 '
!           print 71,apr,(sd0(i),i=1,n)

           apr=' && difx '
!           print 71,apr,(difx(j),j=1,n)

	do i=2,n
	  dif_h(i)=0.5d0*(difx(i)+difx(i-1))*gra2(i)
	end do

	do i=2,n
	  difx(i)=dif_h(i)
	end do



71	FORMAT(5X,A10/,(2x,6(1PE11.3)))

        return
        end
         subroutine dif_h_neut()

         include 'double.inc'
         include 'new_com.inc'
         include 'par_imp.inc'
         include 'new_imp.inc'

         call dif_h_neut_c(
     *   n,nij,
     *   te0,tq0,pne,pd0,pt0,
     *   difx,f_a,den_neut1,den_neut0,sdenx,gra2,vt1,gra1,p_lambda1)

         return
         end


         subroutine dif_h_neut_c(
     *   n,nij,
     *   te0,tq0,pne,pd0,pt0,
     *   difx,f_a,den_neut1,den_neut0,sdenx,gra2,vt1,gra1,p_lambda1)

         include 'double.inc'
         include 'parf0'

         dimension te0(*),tq0(*),pne(*),
     *   pd0(*),pt0(*),sdenx(*),den_neut0(*),gra2(*),gra1(*)

         dimension  difx(*),f_a(*),den_neut1(*),p_lambda1(*)

       dimension denz(2),
     * rin_zog(2),rre_zog(2),rcx_zog(2)

	  dimension dif_h(npo),ss_1(npo),s_dif(npo)

         character * 20 apr

	   a_coef=1.602/1.67
	   c_ion_h=1.d0
	   c_rec_h=1.d0
	   c_ex_h=1.d0
	   c_difx_neut=1.d0
	   p_hi=2.d0

         Ry=0.0136

	   alfa_rus=0.1d0

	   nij=1

       !!!!n_e*S_iz*1.e7

         do i=1,n

               te=te0(i)
               ti=tq0(i)

               den_e= pne(i)
               den_i= (pd0(i)+pt0(i))

	t_e=te*1.d-3
	t_i=ti*1.d-3

      S_iT=2.d-0*sqrt(T_e/Ry)*dexp(-Ry/T_e)/(6.d0+T_e/Ry)
      S_cx=1.d-0*T_i**0.327d0

      s_ex=3.6d-1*sqrt(ti*1.d-3)


	
c		write(6,'(" i te ti den_e ",
c     *  i4,6(1pe11.4))'),
c     *  i,te,ti,den_e



	n_states=2

	te_inp=T_e*1.e3
	tn_inp=T_i*1.e3
	nz_inp=n_states-1

	den_n=den_neut1(i)

	denz(1)=den_n
	denz(2)=den_i

        call en_loss_zog(te_inp,tn_inp,nz_inp,
     *  den_e,den_n,denz,
     *  qlos_e,qloss_ion,qloss_rad,qloss_rec,qloss_ch)

	qlos_e=qlos_e*alfa_rus
	qloss_ion=qloss_ion*alfa_rus
	qloss_rad=qloss_rad*alfa_rus
	qloss_rec=qloss_rec*alfa_rus
	qloss_ch=qloss_ch*alfa_rus

c      Erg/mksec/cm**3=(1.e-7*1.e6*1.e6)=1.e5 Wt/M**3=0.1 Mwt/m**3


	q_bal=qloss_ion+qloss_rad-qloss_rec

c	write(6,'(" i qlos_e,q_bal",
c     *  i4,6(1pe12.5))'),
c     *  i,qlos_e,q_bal


c	write(6,'(" i qloss_ion,qloss_rad,qloss_rec,qloss_ch",
c     *  i4,6(1pe12.5))'),
c     *  i,qloss_ion,qloss_rad,qloss_rec,qloss_ch


	nz_inp=1
       call rates_zog(te_inp,tn_inp,nz_inp,
     *  rin_zog,rre_zog,rcx_zog)

	c_ion=S_iT

	c_ex=S_cx

c		write(6,'(" i  S_cx rcx_zog s_ex",
c     *  i4,6(1pe11.4))'),
c     *  i,S_cx,rcx_zog(2),s_ex


        s_dif(i)=c_ion*den_e+c_ex*den_i

	 ss_1(i)=c_ex*1.d3

	 sdenx(i)=c_ex*den_i*den_neut0(i)*1.d3

c		print*,'i  j  c_ion*den_e= c_ex*den_i =',i,j,c_ion*den_e,
c     *	c_ex*den_i

              f_a(i)=-c_ion*den_e*1.d3

              difx(i)=c_difx_neut*a_coef/s_dif(i)*1.d3

!!!              difx(i)=difx(i)*tq0(i)/p_hi
              difx(i)=difx(i)*ti/p_hi

!!!	p_lambda1(i)=ti/p_hi/(s_dif(i)) !  in cm

	vt1=sqrt(ti/p_hi)  ! in cm/mksec

	p_lambda1(i)=vt1/(s_dif(i)) !  in cm

!		write(6,'(" i vt1, s_dif ti p_lambda1(i)",
!     *  i4,6(1pe11.4))'),
!     *  i,vt1,s_dif(i),ti,p_lambda1(i)

!		write(6,'(" i c_ion  c_ex s_dif vt1 ",
!     *  i4,6(1pe11.4))'),
!     *  i,c_ion*den_e,c_ex*den_i,s_dif(i),vt1


c	difx(i)=1.d-2
c	f_a(i)=-0.d0

           end do

           apr=' && sdenx '
           print 71,apr,(sdenx(i),i=1,n)

           apr=' && s_dif '
           print 71,apr,(s_dif(i),i=1,n)

            apr=' && ss_1 '
           print 71,apr,(ss_1(i),i=1,n)

           apr=' && f_a_h '
           print 71,apr,(f_a(i),i=1,n)

           apr=' && p_lambda1 '
           print 71,apr,(p_lambda1(i),i=1,n)

 
           apr=' && difx_h '
!           print 71,apr,(difx(j),j=1,n)


	do i=2,n
	  dif_h(i)=0.5d0*(difx(i)+difx(i-1))*gra2(i)
	end do

	do i=2,n
	  difx(i)=dif_h(i)
	end do

	print *,' vt1 ==',vt1


71	FORMAT(5X,A10/,(2x,6(1PE11.3)))

        return
        end
	
	

      SUBROUTINE TP_neut0()
      include 'double.inc'
      include 'new_com.inc'
      include 'par_imp.inc'
      include 'new_imp.inc'
	
      call TP_neut0_c(n,
     *  difx,ai,vn,tay,kpr,den_neut0,ha,ha2,ggt,ggtn,
     *  den0_neut0,f_a,ntay,vt0,prog_n0,sd0,
     *  pn0_av,gra1,gra2)
	
	return
	end


      SUBROUTINE TP_neut0_c(n,
     *  difx,ai,vi,tay,kpr,den_neut0,ha,ha2,ggt,ggtn,
     *  den0_neut0,f_a,ntay,vt0,prog_n0,sd0,
     *  pn0_av,gra1,gra2)
c----------------------------------------------
c  neutrals diffusion
c-----------------------------------
      include 'double.inc'
	include 'parf0'
      dimension A(npo),B(npo),C(npo),fz(npo),HG(npo),
     *DH1(npo),dh2(npo),TETA(npo),VI1(npo),GK(npo),FD(npo),
     *FT(npo),FH(npo),
     *PD(npo),PT(npo),PH(npo),WD(npo),WT(npo),
     *WH(npo),U(npo),B0(npo),Z(npo),vu(npo),aiu(npo),ug(npo),
     *vg(npo),gg(npo)

      dimension difx(*),ai(*),vi(*),sd0(*),
     * den_neut0(*),ha(*),ha2(*),ggt(*),ggtn(*),den0_neut0(*),f_a(*),
     *  gra1(*),gra2(*)
c
        
      character *20 apr

c	print *,' ntay tay==',ntay,tay


	p_hi=2.d0

	ntran=0

      N2=N-1

      ALFA=1.

      i=1
      dh1(i)=0.5
      dh2(i)=0.

      do i=2,n2

         dh1(i)=ha(i)/(ha(i)+ha(i+1))
         dh2(i)=ha(i+1)/(ha(i)+ha(i+1))
      end do
      
      ha2(1)=0.5*ha(2)

      DO 1 I=1,N

	aiu(i)=ai(i)
	vu(i)=vi(i)
	gg(i)=vi(i)

      fz(I)=1.d0

       VG(I)=0.
       HG(I)=0.

      TETA(I)=1.d0/HA2(I)
    1 CONTINUE

      DO 8 I=1,N
      GGT(I)=Vu(I)
    8 CONTINUE


      apr=' ai**'
c      if(kpr.eq.1)PRINT 71,apr,(ai(I),I=1,N)

      apr=' vi**'
c      if(kpr.eq.1)PRINT 71,apr,(vi(I),I=1,N)

      apr=' ha**'
c      if(kpr.eq.1)PRINT 71,apr,(ha(I),I=1,N)

      apr=' ha2**'
c      if(kpr.eq.1)PRINT 71,apr,(ha2(I),I=1,N)

!!!      IF(NTAY.EQ.0)GO TO 99

    2 CONTINUE

!!!      CALL OITER(N)


      apr=' difx**'
c      if(kpr.eq.1)PRINT 71,apr,(difx(I),I=1,N)


      ALFA=1.
      BETA=1.

      beta1=0.

      A(1)=0.
      i=1

      b(I)=ug(i+1)/(2.*ha2(i))*beta1*(dh1(i)+dh2(i))
      c(I)=ug(i+1)/(2.*ha2(i))*beta1*(dh1(i)+dh2(i))

      B(I)=B(I)+ ALFA*(dh2(i)*fz(I)*GG(I)+dh1(i)*
     *fz(I+1)*GG(I+1))/TAY

      b(I)=b(i)-(f_a(I)*Vu(I)*dh2(i)+f_a(I+1)*Vu(I+1)*
     *dh1(i))
c
      c(i)=c(i)+hg(i+1)/ha(i+1)*vg(i+1)*dh1(i)
      b(i)=b(i)-hg(i)/ha(i+1)*vg(i+1)*dh1(i)

c
      DO I=2,N2
      A(I)=-UG(I)/(2.*ha2(i))*beta1*(dh1(i)+dh2(i))
      b(I)=(ug(i+1)-UG(I))/(2.*ha2(i))*beta1*(dh1(i)+dh2(i))
      c(I)=UG(I+1)/(2.*ha2(i))*beta1*(dh1(i)+dh2(i))
      B(I)=B(I)+ ALFA*(dh2(i)*fz(I)*GG(I)+dh1(i)*fz(I+1)*
     *GG(I+1))/TAY

      b(I)=b(i)-(f_a(I)*Vu(I)*dh2(i)+f_a(I+1)*Vu(I+1)*
     *dh1(i))

c
      a(i)=a(i)-hg(i-1)/ha(i)*vg(i)*dh2(i)
      c(i)=c(i)+hg(i+1)/ha(i+1)*vg(i+1)*dh1(i)
      b(i)=b(i)+hg(i)/ha(i)*vg(i)*dh2(i)-hg(i)/
     *ha(i+1)*vg(i+1)*dh1(i)
c
      end do

c  NEW additions...



      DO 4 I=2,N
c	dif(i)=100.
    4 GK(I)=-DIFx(I)*VI(I)/HA(I)

      apr=' gk**'
      if(kpr.eq.1)PRINT 71,apr,(gk(I),I=1,N)

      apr=' ggt**'
      if(kpr.eq.1)PRINT 71,apr,(ggt(I),I=1,N)
      apr=' ggtn**'
      if(kpr.eq.1)PRINT 71,apr,(ggtn(I),I=1,N)

      apr=' f_a**'
!      if(kpr.eq.1)PRINT 71,apr,(f_a(I),I=1,N)

      apr=' ph0**'
c      if(kpr.eq.1)PRINT 71,apr,(ph0(I),I=1,N)

      apr=' phn**'
c      if(kpr.eq.1)PRINT 71,apr,(phn(I),I=1,N)
 
      apr=' sd0**'
      PRINT 71,apr,(sd0(I),I=1,N)

      apr=' de0_neut0**'
      if(kpr.eq.1)PRINT 71,apr,(den0_neut0(I),I=1,N)


      DO 14 I=1,N2
!!!      PKO=ALFA/TAY*(GGTN(I)*dh2(i)+GGTN(I+1)*dh1(i))
      PKO=ALFA/TAY*(GGT(I)*dh2(i)+GGT(I+1)*dh1(i))

      FH(I)=PKO*den0_neut0(I) 

      FH(i)=FH(i)+SD0(I)*Vu(I)*dh2(i)+SD0(I+1)*Vu(I+1)*
     *dh1(i)

   14 CONTINUE
   71 FORMAT(20X,A6/,(6(1pE12.5)))

!!!      GO TO  99
c      IF(NTAY.EQ.0)GO TO  99
	keps=0

	lh=3

	vt0=1.e2*gra1(n)

c	uh=vt0
!	zh=-vt0*0.1
	uh=0.d0
	zh=-vt0*vi(n)*gra2(n)/gra1(n)*prog_n0

	print *,' vt0 prog_n0',vt0,prog_n0


!	lh=1
	
	den_neut0(N)=prog_n0

      PH(N)=den_neut0(N)
      CALL PROGP(N,A,B,C,TETA,GK,U,B0,PH,Z,WH,FH,
     *ZH,UH,EPS0,LH)

	do i=1,n
      den_neut0(I)=PH(I)
	end do

	pn0_av=0.d0
	vv=0.d0

	do i=2,n
      pn0_av=pn0_av+0.5*(den_neut0(I)+den_neut0(I-1))*vi(I)*ha(i)
      vv=vv+vi(I)*ha(i)
	end do
	pn0_av=pn0_av/vv

	bal=wh(n)-(uh*ph(n)+zh)

	print *,' bal ==pn0_av',bal,pn0_av

c
   99 CONTINUE


      apr=' ph**'
      if(kpr.eq.1)PRINT 71,apr,(ph(I),I=1,N)

	

      RETURN
      END

      SUBROUTINE TP_neut1()
      include 'double.inc'
      include 'new_com.inc'
      include 'par_imp.inc'
      include 'new_imp.inc'
	
      call TP_neut1_c(n,
     *  difx,ai,vn,tay,kpr,den_neut1,ha,ha2,ggt,ggtn,
     *  den0_neut1,f_a,ntay,sdenx,vt1,
     *  pn1_av,gra1,gra2)
	
	return
	end


      SUBROUTINE TP_neut1_c(n,
     *  difx,ai,vi,tay,kpr,den_neut1,ha,ha2,ggt,ggtn,
     *  den0_neut1,f_a,ntay,sdenx,vt1,
     *  pn1_av,gra1,gra2)
c----------------------------------------------
c  neutrals diffusion
c-----------------------------------
      include 'double.inc'
	include 'parf0'
      dimension A(npo),B(npo),C(npo),fz(npo),HG(npo),
     *DH1(npo),dh2(npo),TETA(npo),VI1(npo),GK(npo),FD(npo),
     *FT(npo),FH(npo),
     *PD(npo),PT(npo),PH(npo),WD(npo),WT(npo),
     *WH(npo),U(npo),B0(npo),Z(npo),vu(npo),aiu(npo),ug(npo),
     *vg(npo),gg(npo)

      dimension difx(*),ai(*),vi(*),sdenx(*),
     * den_neut1(*),ha(*),ha2(*),ggt(*),ggtn(*),den0_neut1(*),f_a(*),
     *  gra1(*),gra2(*)
c
        
      character *20 apr

c	print *,' ntay tay==',ntay,tay


	p_hi=2.d0

	ntran=0

      N2=N-1

      ALFA=1.

      i=1
      dh1(i)=0.5
      dh2(i)=0.

      do i=2,n2
         dh1(i)=ha(i)/(ha(i)+ha(i+1))
         dh2(i)=ha(i+1)/(ha(i)+ha(i+1))
      end do
      
      ha2(1)=0.5*ha(2)

      DO 1 I=1,N
	aiu(i)=ai(i)
	vu(i)=vi(i)
	gg(i)=vi(i)
      fz(I)=1.d0

       VG(I)=0.
       HG(I)=0.

      TETA(I)=1.d0/HA2(I)
    1 CONTINUE

      DO 8 I=1,N
      GGT(I)=Vu(I)
    8 CONTINUE


      apr=' ai**'
c      if(kpr.eq.1)PRINT 71,apr,(ai(I),I=1,N)

      apr=' vi**'
c      if(kpr.eq.1)PRINT 71,apr,(vi(I),I=1,N)

      apr=' ha**'
c      if(kpr.eq.1)PRINT 71,apr,(ha(I),I=1,N)

      apr=' ha2**'
c      if(kpr.eq.1)PRINT 71,apr,(ha2(I),I=1,N)

!!!      IF(NTAY.EQ.0)GO TO 99

    2 CONTINUE

!!!      CALL OITER(N)


      apr=' difx**'
!      if(kpr.eq.1)PRINT 71,apr,(difx(I),I=1,N)


      ALFA=1.
      BETA=1.

      beta1=0.

      A(1)=0.
      i=1

      b(I)=ug(i+1)/(2.*ha2(i))*beta1*(dh1(i)+dh2(i))
      c(I)=ug(i+1)/(2.*ha2(i))*beta1*(dh1(i)+dh2(i))

      B(I)=B(I)+ ALFA*(dh2(i)*fz(I)*GG(I)+dh1(i)*
     *fz(I+1)*GG(I+1))/TAY

      b(I)=b(i)-(f_a(I)*Vu(I)*dh2(i)+f_a(I+1)*Vu(I+1)*
     *dh1(i))
c
      c(i)=c(i)+hg(i+1)/ha(i+1)*vg(i+1)*dh1(i)
      b(i)=b(i)-hg(i)/ha(i+1)*vg(i+1)*dh1(i)

c

      DO I=2,N2
      A(I)=-UG(I)/(2.*ha2(i))*beta1*(dh1(i)+dh2(i))
      b(I)=(ug(i+1)-UG(I))/(2.*ha2(i))*beta1*(dh1(i)+dh2(i))
      c(I)=UG(I+1)/(2.*ha2(i))*beta1*(dh1(i)+dh2(i))
      B(I)=B(I)+ ALFA*(dh2(i)*fz(I)*GG(I)+dh1(i)*fz(I+1)*
     *GG(I+1))/TAY

      b(I)=b(i)-(f_a(I)*Vu(I)*dh2(i)+f_a(I+1)*Vu(I+1)*
     *dh1(i))

c
      a(i)=a(i)-hg(i-1)/ha(i)*vg(i)*dh2(i)
      c(i)=c(i)+hg(i+1)/ha(i+1)*vg(i+1)*dh1(i)
      b(i)=b(i)+hg(i)/ha(i)*vg(i)*dh2(i)-hg(i)/
     *ha(i+1)*vg(i+1)*dh1(i)
c
      end do

c  NEW additions...



      DO 4 I=2,N
c	dif(i)=100.
    4 GK(I)=-DIFx(I)*VI(I)/HA(I)

      apr=' gk**'
c      if(kpr.eq.1)PRINT 71,apr,(gk(I),I=1,N)

      apr=' ggt**'
c      if(kpr.eq.1)PRINT 71,apr,(ggt(I),I=1,N)
      apr=' ggtn**'
c      if(kpr.eq.1)PRINT 71,apr,(ggtn(I),I=1,N)

      apr=' f_a**'
c      if(kpr.eq.1)PRINT 71,apr,(f_a(I),I=1,N)

      apr=' ph0**'
c      if(kpr.eq.1)PRINT 71,apr,(ph0(I),I=1,N)

      apr=' phn**'
c      if(kpr.eq.1)PRINT 71,apr,(phn(I),I=1,N)



      DO 14 I=1,N2
!!!      PKO=ALFA/TAY*(GGTN(I)*dh2(i)+GGTN(I+1)*dh1(i))
      PKO=ALFA/TAY*(GGT(I)*dh2(i)+GGT(I+1)*dh1(i))

      FH(I)=(sdenx(I)*Vu(I)*dh2(i)+sdenx(I+1)*Vu(I+1)*
     *dh1(i))+PKO*den0_neut1(I)

   14 CONTINUE
   71 FORMAT(20X,A6/,(6(1pE12.5)))

!!!      GO TO  99
c      IF(NTAY.EQ.0)GO TO  99
	keps=0

	lh=3

!!!	vt0=1.e3

	uh=vt1*vi(n)*gra2(n)/gra1(n)
	zh=0.d0

	print *,' vt1 uh',vt1,uh


      PH(N)=den_neut1(N) 

      CALL PROGP(N,A,B,C,TETA,GK,U,B0,PH,Z,WH,FH,
     *ZH,UH,EPS0,LH)

	do i=1,n
      den_neut1(I)=PH(I)
	end do

	f_av1=0.d0	
	f_av2=0.d0

	do i=1,n2


	r_1=teta(i)*(wh(i+1)-wh(i))
	r_2=b(i)*den_neut1(I)
	r_3=fh(i)

	r_4=r_1+r_2

c	 write(6,'("  i r_1 r_2 r_3 r_4 ", i4,4(1pe13.6))'),
c     *  i,r_1,r_2,r_3,r_4

!!!      PKO=ALFA/TAY*(GGTN(I)*dh2(i)+GGTN(I+1)*dh1(i))
      PKO=ALFA/TAY*(GGT(I)*dh2(i)+GGT(I+1)*dh1(i))

	rr_3=(sdenx(I)*Vu(I)*dh2(i)+sdenx(I+1)*Vu(I+1)*
     *dh1(i))+PKO*den0_neut1(I)

      f_av1=f_av1+rr_3/teta(i)

!!1	f_av2=f_av2+PKO*den_neut1(I)-f_a(I)*pko*tay
	f_av2=f_av2+b(i)*den_neut1(I)/teta(i)

!	 write(6,'("  i r_1 rr_3 r_3  ", i4,4(1pe13.6))'),
!     *  i,r_1,rr_3/teta(i),r_3/teta(i)


	end do

	del=f_av1-f_av2
	bal=del-wh(n)

!	print *,' --del w_h bal==',del,wh(n),bal


	pn1_av=0.d0
	vv=0.d0
	f_av1=0.d0
	f_av2=0.d0
	d_pn=0.d0

	do i=1,n2
      f_av1=f_av1+0.5*
     * (sdenx(I)*vi(I)+sdenx(I+1)*vi(I+1))*ha2(i)
      f_av2=f_av2+0.5*den_neut1(I)*
     * (f_a(i)*vi(I)+f_a(i+1)*vi(I+1))*ha2(i)
	d_pn=d_pn+(den_neut1(I)-den0_neut1(I))/tay*
     *  0.5*(vi(I)+vi(i+1))*ha2(i)

	end do

	del1=f_av1+f_av2
	del=del1-d_pn
	bal=del-wh(n)

	 write(6,'(" && f_av1 f_av2 w_h bal===   ", 4(1pe13.6))'),
     *  f_av1,f_av2,wh(n),bal




	pn1_av=0.d0
	vv=0.d0

	do i=2,n
      pn1_av=pn1_av+0.5*(den_neut1(I)+den_neut1(I-1))*vi(I)*ha(i)
      vv=vv+vi(I)*ha(i)
	end do

	pn1_av=pn1_av/vv

	bal=wh(n)-(uh*ph(n)+zh)

	 write(6,'(" vt1 bal_h pn1_av===   ", 4(1pe13.6))'),
     *  vt1,bal,pn1_av


c
   99 CONTINUE


      apr=' den1_neut**'
      if(kpr.eq.1)PRINT 71,apr,(ph(I),I=1,N)

	

      RETURN
      END




        subroutine in_neut_1d()

        include 'double.inc'
        include 'new_com.inc'
 
        include 'par_imp.inc'
        include 'new_imp.inc'
 
        call in_neut_1d_c(
     *  den_neut0,den_neut1,n)

        return
        end

        subroutine in_neut_1d_c(
     *  den_neut0,den_neut1,n)

        include 'double.inc'

        dimension
     *  den_neut0(*),den_neut1(*)

        character * 20 apr


         do i=1,n_
             den_neut0(i)=1.d-5
             den_neut1(i)=1.d-8
		end do

 

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))

        return
        end

        subroutine neut_time_step_1d()
        include 'double.inc'

!        include 'parf0'
        include 'new_com.inc'
        include 'par_imp.inc'
        include 'new_imp.inc'

        call neut_time_step_1d_c_(
     *  den_neut0,den0_neut0,den_neut1,den0_neut1,
     *  den_neut_imp,den0_neut_imp,n)

        return
        end

        subroutine neut_time_step_1d_c_(
     *  den_neut0,den0_neut0,den_neut1,den0_neut1,
     *  den_neut_imp,den0_neut_imp,n)

        include 'double.inc'

        dimension
     *  den_neut0(*),den0_neut0(*),
     *  den_neut1(*),den0_neut1(*),
     *  den_neut_imp(*),den0_neut_imp(*)

        character * 20 apr

c	n_rad=n

c		print *,'n_rad==== ',n_rad

           do i=1,n
              den0_neut0(i)=den_neut0(i)
              den0_neut1(i)=den_neut1(i)
              den0_neut_imp(i)=den_neut_imp(i)
           end do
 

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))

        return
        end




      subroutine wave_run_neut()
      include 'double.inc'
	include 'new_com.inc'

	call wave_run_neut_c(
     *       a,n,eu,ro_f,tay,tt,
     *  te0,tq0,pd0,pne,q,vi,ha)

	return
	end

	subroutine wave_run_neut_c(
     *       a,n,eu,ro_f,tay,tt,
     *  te0,tq0,pd0,pne,q,vi,ha)

      include 'double.inc'

      dimension a(*),te0(*),tq0(*),pd0(*),pne(*),q(*),vi(*),ha(*)
      character *30 apr

	common /c_tay_run/tt_run

      i_sh1=i_sh1+1

      if(i_sh1.eq.1)then
         open (unit=41,file='te_speed.dat',form='formatted')
         read (41,*)
         read (41,*)v_te,pn_te,q_ax,time_next,time_inj,time_beg

      if(kpr.eq.1)print *,'v_te pn_te,qax time_next time_inj t_beg ',
     *  v_te,pn_te,q_ax,time_next,time_inj,time_beg
	
         close (41)

	endif


	if(tt.lt.time_beg)return

	 write(6,'("  tt_inj tt   tt_next   ", 
     * 4(1pe13.6))'),
     *  tt_inj,tt,tt_next

	if(tt.gt.tt_inj.and.tt.le.tt_next)return

	if(tt.gt.tt_next)i_sh=0

	 write(6,'("  i_sh tt_inj tt  tt_next   ", i4,4(1pe13.6))'),
     *  i_sh,tt_inj,tt,tt_next

      i_sh=i_sh+1
      if(i_sh.eq.1)then
	tt_next=tt+time_next
	tt_inj=tt+time_inj
	tt_run=tt+1.d0
	end if


         
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

	return
	end
      SUBROUTINE TP_imp_zimp(N)
c----------------------------------------------
c  particles transport
c-----------------------------------
	include 'double.inc'
c       implicit real*8 (a-h,o-z)
	include 'parf0'
      dimension A(npo),B(npo),C(npo),fz(npo),HG(npo),
     *DH1(npo),dh2(npo),TETA(npo),VI1(npo),GK(npo),FD(npo),
     *FT(npo),FH(npo),
     *PD(npo),PT(npo),PH(npo),WD(npo),WT(npo),
     *WH(npo),U(npo),B0(npo),Z(npo),vu(npo),aiu(npo),ug(npo),
     *vg(npo),gg(npo)
c
	COMMON
     *  /en1/PNE(npo),PD0(npo),PT0(npo),PH0(npo),PDN(npo),
     *  PTN(npo),PHN(npo)
     *  /en4/WD0(npo),WT0(npo),WH0(npo),VD(npo),DIF(npo),
     *  GGT(npo),GGTN(npo)
     *  /en5/SD0(npo),ST0(npo),SH0(npo)
     *  /en6/VI(npo)
     *  /en7/UD,ZD,UT,ZT,UH,ZH,LD,LT,LH,ID,IT,IH,KTP,NN
     *  /en8/ntran
     *  /en12/pnal(npo),pnaln(npo),zalfa,talfa
     *  /en33/anom_e,anom_i,key_t11,kcchp
c
	common
     *   /ge1/pi
     *  /ge2/NTAY,TAY,TTB
     *  /ge3/AI(npo),A0(npo),HA2(npo),a1(npo),ha(npo)
     *  /ge4/EPS1,EPS2,EPS0
     *  /ge5/kpr                                                        
     *  /ge6/zeff(npo),qpr(npo),ppr(npo),pr0,prg,zar
     *  /ge6a/ppr0(npo)
	common
     *  /dfm3/dfmax(npo),dfmax0(npo)
      COMMON
     *  /mid3/GRA1(npo),GRA2(npo)

	 dimension d_imp(npo),d_imp0(npo)
        
        character *20 apr

	i_en=i_en+1

	ntran=0
      N2=N-1
      ALFA=1.

      i=1
      dh1(i)=0.5
      dh2(i)=0.

      do i=2,n2
         dh1(i)=ha(i)/(ha(i)+ha(i+1))
         dh2(i)=ha(i+1)/(ha(i)+ha(i+1))
      end do
      
      ha2(1)=0.5*ha(2)

      DO 1 I=1,N
	aiu(i)=ai(i)
	vu(i)=vi(i)
	gg(i)=vi(i)
      fz(I)=1.
       VG(I)=0.
       HG(I)=0.
      TETA(I)=1./HA2(I)
    1 CONTINUE

      DO 8 I=1,N
      GGT(I)=Vu(I)
    8 CONTINUE

	if(i_en.eq.1)then
      DO  I=1,N
      GGTN(I)=GGT(I)
	end do
	end if

      DO 51 I=1,N2
   51 VI1(I)=Vu(I)*dh2(i)+Vu(I+1)*dh1(i)

      ateta=1.
      call inter_h0(vi1,a1,n-1,ateta,val)
      vi1(n)=val

c###	VI1(N)=2.*VI1(N2)-Vu(N)

c      do i=1,n
c         vi1(i)=1.
c      end do



    2 CONTINUE

        CALL OITER(N)
        CALL FITER(N)

	do i=1,n

!	dif(i)=dif(i)*1.e3
	dif(i)=dif(i)*2.e4

	end do



c----------------------------------------
      DO I=2,N
         UG(I)=VD(I)*Vu(I)
      end do

      apr=' dif*'
      PRINT 71,apr,(dif(I),I=1,N)


      apr=' vd*'
      PRINT 71,apr,(vd(I),I=1,N)

      ALFA=1.
      BETA=1.

      beta1=0.

      A(1)=0.

      i=1

      b(I)=ug(i+1)/(2.*ha2(i))*beta1*(dh1(i)+dh2(i))
      c(I)=ug(i+1)/(2.*ha2(i))*beta1*(dh1(i)+dh2(i))

      B(I)=B(I)+ ALFA*(dh2(i)*fz(I)*GG(I)+dh1(i)*
     *fz(I+1)*GG(I+1))/TAY
c

c
      DO I=2,N2
      A(I)=-UG(I)/(2.*ha2(i))*beta1*(dh1(i)+dh2(i))
      b(I)=(ug(i+1)-UG(I))/(2.*ha2(i))*beta1*(dh1(i)+dh2(i))
      c(I)=UG(I+1)/(2.*ha2(i))*beta1*(dh1(i)+dh2(i))
      B(I)=B(I)+ ALFA*(dh2(i)*fz(I)*GG(I)+dh1(i)*fz(I+1)*
     *GG(I+1))/TAY
c
c
      end do


      ktp=1
	lppr=3


      DO 4 I=2,N
    4 GK(I)=-DIF(I)*VI(I)/HA(I)

      IF(KTP.EQ.1)UT=-VD(N)*VI(N)/
     *(1.-VD(N)*VI(N)/(2.*GK(N)))


	vt0_imp=-1.e0
	Ud=-vt0_imp*VI(N)
	zd=0.d0

   71 FORMAT(20X,A20/,(6(1pE12.5)))

c
      nz_imp=zar


	do kkk=1,nz_imp

	call get_dens_zimp(kkk,d_imp0,d_imp,n)

      DO 14 I=1,N2

      PKO=ALFA/TAY*(GGTN(I)*dh2(i)+GGTN(I+1)*dh1(i))

      FH(I)=PKO*d_imp0(I)

   14 CONTINUE

      CALL PROGP(N,A,B,C,TETA,GK,U,B0,d_imp,Z,WD,FH,
     *ZD,UD,EPS0,lppr)

	if(d_imp(n).lt.0.d0)d_imp(n)=0.d0
c


	p_imp=0.
	p_imp0=0.
	vol=0.
	do i=1,n
	vol=vol+vi(i)*ha(i)*2.*pi
	p_imp0=p_imp0+d_imp0(i)*vi(i)*ha(i)*2.*pi
	p_imp=p_imp+d_imp(i)*vi(i)*ha(i)*2.*pi
	end do

      apr=' d_imp0**'
      PRINT 71,apr,(d_imp0(I),I=1,N)

      apr=' d_imp**'
      PRINT 71,apr,(d_imp(I),I=1,N)

	print *,' p_imp= p_imp0= vol',p_imp,p_imp0,vol

	call put_dens_zimp(kkk,d_imp,n)

	end do


      RETURN
      END
	subroutine put_neut_imp(n_x)

      include 'double.inc'
      include 'new_com.inc'
      include 'par_imp.inc'
      include 'new_imp.inc'

	call put_neut_zimp_c(den_neut_imp,n_x)

	return
	end
