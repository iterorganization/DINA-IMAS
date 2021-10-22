      subroutine dens_prog()
      include 'double.inc'
	include 'new_com.inc'

	call dens_prog_c(
     *  ntay)


	return
	end



	subroutine dens_prog_c(
     *  ntay)

        include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *  /mid2/vi(npo),spo(npo)
	common
     *  /en1/PNE(npo),PD0(npo),PT0(npo),PH0(npo),PDN(npo),
     *  PTN(npo),PHN(npo)
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
     *  /ge5/kpr
     *  /ge8/pcch
     *  /ge8e/pcchp
     *  /en33/anom_e,anom_i,key_t11,kcchp
	character *12 apr
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

	ppch=0.
	vv=0.
	do i=2,n
      VV=VV+VI(I)*HA(I)
      p_ion=0.5*(Pd0(I)+Pd0(I-1))
      p_ion=p_ion+0.5*(Pt0(I)+Pt0(I-1))
!      PPch=PPch+0.5*(PNE(I)+PNE(I-1))*VI(I)*HA(I)
      PPch=PPch+p_ion*VI(I)*HA(I)
	end do
        PCch=PPch/VV
	if(kpr.eq.1)print *,'===1 pcchp pcch=kcchp===',pcchp,pcch,kcchp

!!!	if(ntay.lt.2)pcchp=pcch


	if(kcchp.eq.1)then
	al1=pcchp/pcch
	if(kpr.eq.1)print *,'===1 pcchp pcch=al1===',pcchp,pcch,al1
	do i=1,n
!	   pne(i)=pne(i)*al1
         pd0(i)=pd0(i)*al1
         pt0(i)=pt0(i)*al1
	   pne(i)=pd0(i)+pt0(i)
        end do
	end if

	return
	end
	subroutine den_read()
	include 'double.inc'
	include 'new_com.inc'

	call den_read_c(
     *  tt,pcchp,ntay,tay)
	
	return
	end

	subroutine den_read_c(
     *  tt,pcchp,ntay,tay)

	include 'double.inc'
 	include 'parf_mike' 

        common
     *  /ge5/kpr

	dimension t_t(ntime),den_t(ntime)


	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
!           open (unit=41,file='dens.dat',form='formatted') 
           read (1,*) 
           read (1,*)n_t 
           read (1,*) 

 	 if(kpr.eq.1)print *,' tay tt n_t===',tay,tt,n_t 

           do i=1,n_t 
              read (1,*)t_t(i),den_t(i)
              t_t(i)=t_t(i)*1000. 
           end do 
           
           apr='-t_t-' 
           if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 

           apr='-den_t-' 
           if(kpr.eq.1)print 71,apr,(den_t(i),i=1,n_t) 

        !   close (unit=41) 
        end if

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

	   if(ntay.le.2)then
c*vic!!!	      den_t(1)=pcchp
!!!	      t_t(1)=tt-tay
	   end if


           apr='-den_t22' 
           if(kpr.eq.1)print 71,apr,(den_t(i),i=1,n_t) 


      do i=2,n_t
      if( (tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
	 t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )

	 den=den_t(i-1)+t_coef*(den_t(i)-den_t(i-1))
c
	 end if

	 end do

!	   if(ntay.gt.2)pcchp=den

	pcchp=den

c	if(kpr.eq.1)print *,' from den_read  pcchp den ntay',pcchp,den,ntay
c	pause 'from den_read'


       return 
       end 
      SUBROUTINE OITER(N)
      include 'double.inc'
c------------------------------------
c   diffusion coeficient and particles sources
c----------------------------------------------
c       implicit real*8 (a-h,o-z)
	include 'parf0'
      COMMON
     *  /en1/PNE(npo),PD0(npo),PT0(npo),PH0(npo),PDN(npo),
     *  PTN(npo),PHN(npo)
     *  /en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),WE0(npo),WQ0(npo)
     *  /en5/SD0(npo),ST0(npo),SH0(npo)
     *  /en6/VI(npo)
     *  /en22/XII(npo)
     *  /en4/WD0(npo),WT0(npo),WH0(npo),VD(npo),DIF(npo),
     *  GGT(npo),GGTN(npo)
     *  /en17/QAE(npo),QAQ(npo),SAL(npo),NAL
     *  /en27/nij

        common
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)
     *  /mid3/GRA1(npo),GRA2(npo)
        common
     *  /ge1/PI
     *  /ge3/AI(npo),AA0(npo),HA2(npo),a(npo),ha(npo)
     *  /ge5/kpr
     *  /ge7/eu,rs,zact,elong

        common /c_src/src
        common /c_src1/dif_coef
        parameter (kint=200)
        common /c_src2/sd0_p(kint),sd0_n(kint)
        common /c_src3/src_pel,src_puff



	src=0.
	src_pel=0.
	src_puff=0.
	
      pot=1.
      DO 1 I=2,N

      PG=0.5*(PNE(I)+PNE(I-1))
      TGE=0.5*(TE0(I)+TE0(I-1))

      x11=1.e4*sqrt(tge/pot)*((ai(i)*eu/rs)**1.75)/(q(i)*pg*rs)

     	xii(i)=x11*gra2(i)*dif_coef

 	sd0(i)=sd0(i)-sal(i)
	st0(i)=st0(i)-sal(i)
	src=src+(sd0(i)+st0(i))*vi(i)*ha(i)*2.d0*pi
	
	src_pel=src_pel+(sd0_p(i)*1.d-3)*vi(i)*ha(i)*2.d0*pi
	src_puff=src_puff+(sd0_n(i)*1.d-3)*vi(i)*ha(i)*2.d0*pi
	
      DIF(I)=0.4*XII(I)
      
!      print *,' i dif=',i,dif(i)
      
    1 CONTINUE

      src_tot=src_pel+src_puff
	if(kpr.eq.1)print *,' pne1 pne2======',pne(1),pne(2)
	if(kpr.eq.1)print *,' dif_coef source======',dif_coef,src
	if(kpr.eq.1)print *,' src_pel src_puff',src_pel,src_puff
	if(kpr.eq.1)print *,' eu rs======',eu,rs
	if(kpr.eq.1)print *,' src_tot src',src_tot,src
	
!	stop
	
ccc	pause
   71 FORMAT(20X,A6/,(8E10.3))
      RETURN
      END
      SUBROUTINE FITER(N)
      include 'double.inc'
c------------------------------------------
c  inward pinch velocity
c--------------------------------------------
c       implicit real*8 (a-h,o-z)
	include 'parf0'
      COMMON
     *  /ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
     *  /ge5/kpr
     *  /ge7/eu,rs,zact,elong
	common
     *  /en1/PNE(npo),PD0(npo),PT0(npo),PH0(npo),PDN(npo),
     *  PTN(npo),PHN(npo)
     *  /en4/WD0(npo),WT0(npo),WH0(npo),VD(npo),DIF(npo),
     *  GGT(npo),GGTN(npo)
     *  /en13/KPIN,VPIN,ALP1,POT,SKOR
	common
     *  /mid3/GRA1(npo),GRA2(npo)
c
	if(kpr.eq.1)print *,' alp1 kpin eu================',
     *  alp1,kpin,eu

      DO 1 I=2,N
      VP=ALP1*DIF(i)/(GRA2(I)*EU)*AI(I)
      VD(I)=-VP*GRA1(I)*KPIN
      IF(I.EQ.N)VPIN=VP*1.E3
    1 CONTINUE
c      SKOR=POT/(SPOV*(PDN(N)+PTN(N)+PHN(N)))*GRA1(N)
c      VD(N)=VD(N)-SKOR
      RETURN
      END
      SUBROUTINE TP(N)
      include 'double.inc'
c----------------------------------------------
c  particles transport
c-----------------------------------
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
     *  /en33/anom_e,anom_i,key_t11,kcchp
c
	common
     *  /ge2/NTAY,TAY,TTB
     *  /ge3/AI(npo),A0(npo),HA2(npo),a1(npo),ha(npo)
     *  /ge4/EPS1,EPS2,EPS0
     *  /ge5/kpr
	common
     *  /dfm3/dfmax(npo),dfmax0(npo)
        
        character *20 apr

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

      IF(NTAY.EQ.0)GO TO 99
      NN=0
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

c--------------------------------------------
        kd2=0
        df=0.
	fmax=dfmax(n)
	fmax0=sqrt(dfmax0(n))
	FMAX1=sqrt(FMAX)

	if(kpr.eq.1)print *,' ntay fmax1 fmax0=',ntay,fmax1,fmax0
	if(ntay.gt.2)then
c	if(ntay.gt.9999)then
	kd2=2
	df=-(fmax1-fmax0)/(fmax1*tay)
	end if
c--------------
c	if(kcchp.eq.1)kd2=0
c------------
c----------------------------------------
      DO I=2,N
         UG(I)=VD(I)*Vu(I)
      end do

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
      c(i)=c(i)+hg(i+1)/ha(i+1)*vg(i+1)*dh1(i)
      b(i)=b(i)-hg(i)/ha(i+1)*vg(i+1)*dh1(i)

c
      DO I=2,N2
      A(I)=-UG(I)/(2.*ha2(i))*beta1*(dh1(i)+dh2(i))
      b(I)=(ug(i+1)-UG(I))/(2.*ha2(i))*beta1*(dh1(i)+dh2(i))
      c(I)=UG(I+1)/(2.*ha2(i))*beta1*(dh1(i)+dh2(i))
      B(I)=B(I)+ ALFA*(dh2(i)*fz(I)*GG(I)+dh1(i)*fz(I+1)*
     *GG(I+1))/TAY
c
      a(i)=a(i)-hg(i-1)/ha(i)*vg(i)*dh2(i)
      c(i)=c(i)+hg(i+1)/ha(i+1)*vg(i+1)*dh1(i)
      b(i)=b(i)+hg(i)/ha(i)*vg(i)*dh2(i)-hg(i)/
     *ha(i+1)*vg(i+1)*dh1(i)
c
      end do

c  NEW additions...

      i_new=1
      if(i_new.eq.1)then

      DO  I=1,N
c         VG(I)=0.5*kd2*a1(i)*df
         VG(I)=0.5*kd2*ai(i)*df
         hg(i)=vi1(i)
      end do

      apr='vg'
c      PRINT 71,apr,(vg(i),i=1,n)

      apr='hg'
c      PRINT 71,apr,(hg(i),i=1,n)

      apr='vi'
c      PRINT 71,apr,(vi(i),i=1,n)

      i=1
      c(i)=c(i)+hg(i+1)/ha(i+1)*vg(i+1)*dh1(i)
      b(i)=b(i)-hg(i)/ha(i+1)*vg(i+1)*dh1(i)

      DO I=2,N2
c
      a(i)=a(i)-hg(i-1)/ha(i)*vg(i)*dh2(i)
      c(i)=c(i)+hg(i+1)/ha(i+1)*vg(i+1)*dh1(i)
      b(i)=b(i)+hg(i)/ha(i)*vg(i)*dh2(i)-hg(i)/
     *ha(i+1)*vg(i+1)*dh1(i)
c
      end do

      DO  I=1,N
         if(i.ne.n)hg(I)=( dh1(i)*ug(I+1)+dh2(i)*ug(I) )
         vg(i)=beta
      end do

      ateta=1.
      call inter_h0(hg,a1,n-1,ateta,val)
      hg(n)=val

      apr='- hg'
c      PRINT 71,apr,(hg(i),i=1,n)
      apr='- vg'
c      PRINT 71,apr,(vg(i),i=1,n)

      i=1
c
      c(i)=c(i)+hg(i+1)/ha(i+1)*vg(i)*dh1(i)
      b(i)=b(i)-hg(i)/ha(i+1)*vg(i)*dh1(i)

c
      DO I=2,N1
c
	a(i)=a(i)-hg(i-1)/ha(i)*vg(i)*dh2(i)
	c(i)=c(i)+hg(i+1)/ha(i+1)*vg(i)*dh1(i)

	b(i)=b(i)+hg(i)/ha(i)*vg(i)*dh2(i)-hg(i)/
     *ha(i+1)*vg(i)*dh1(i)
c
	end do

        end if

c  END NEW additions...


        ktp=1

      DO 4 I=2,N
    4 GK(I)=-DIF(I)*VI(I)/HA(I)

      IF(KTP.EQ.1)UT=-VD(N)*VI(N)/
     *(1.-VD(N)*VI(N)/(2.*GK(N)))

      UD=UT
      UH=UT

      DO 14 I=1,N2
      PKO=ALFA/TAY*(GGTN(I)*dh2(i)+GGTN(I+1)*dh1(i))
      FD(I)=SD0(I)*Vu(I)*dh2(i)+SD0(I+1)*Vu(I+1)*
     *dh1(i)+PKO*PDN(I)
      FT(I)=ST0(I)*Vu(I)*dh2(i)+ST0(I+1)*Vu(I+1)*
     *dh1(i)+PKO*PTN(I)
      FH(I)=SH0(I)*Vu(I)*dh2(i)+SH0(I+1)*Vu(I+1)*
     *dh1(i)+PKO*PHN(I)
   14 CONTINUE
   71 FORMAT(20X,A6/,(6(1pE12.5)))

      IF(NTAY.EQ.0)GO TO  99
	keps=0
      IF(ID.NE.0) then
      PD(N)=PD0(N)

      apr=' a**'
c      PRINT 71,apr,(a(I),I=1,N)
      apr=' b**'
c      PRINT 71,apr,(b(I),I=1,N)
      apr=' c**'
c      PRINT 71,apr,(c(I),I=1,N)
      apr=' fd**'
      if(kpr.eq.1)PRINT 71,apr,(fd(I),I=1,N)
      apr=' teta**'
c      PRINT 71,apr,(teta(I),I=1,N)

      CALL PROGP(N,A,B,C,TETA,GK,U,B0,PD,Z,WD,FD,
     *ZD,UD,EPS0,LD)

      apr=' pd**'
      if(kpr.eq.1)PRINT 71,apr,(pd(I),I=1,N)

        if(kpr.eq.1)print *,' pd1 pd2=',pd(1),pd(2)
c      stop

	do i=1,n
      IF(abs(PD(I)-PD0(I)).GT.EPS1*abs(PD0(I))) keps=1
      PD0(I)=PD(I)
      WD0(I)=WD(I)
	end do
	end if
c
      IF(IT.NE.0) then
      PT(N)=PT0(N)
      CALL PROGP(N,A,B,C,TETA,GK,U,B0,PT,Z,WT,FT,
     *ZT,UT,EPS0,LT)
      apr=' pt**'
c      PRINT 71,apr,(pt(I),I=1,N)

        if(kpr.eq.1)print *,' pt1 pt2=',pt(1),pt(2)

	do i=1,n
      IF(abs(PT(I)-PT0(I)).GT.EPS1*abs(PT0(I))) keps=1
      PT0(I)=PT(I)
      WT0(I)=WT(I)
	end do
	end if
c
      IF(IH.NE.0) then
      PH(N)=PH0(N)
      CALL PROGP(N,A,B,C,TETA,GK,U,B0,PH,Z,WH,FH,
     *ZH,UH,EPS0,LH)
	do i=1,n
      IF(abs(PH(I)-PH0(I)).GT.EPS1*abs(PH0(I))) keps=1
      PH0(I)=PH(I)
      WH0(I)=WH(I)
	end do
	end if
c
	ntran=ntran+1
	nn=nn+1
c
	if(keps.eq.1) GO TO 2
c
   99 CONTINUE

      DO 8 I=1,N
      GGT(I)=Vu(I)
    8 CONTINUE

      apr=' pd**'
c      PRINT 71,apr,(pd(I),I=1,N)

      apr=' pt**'
c      PRINT 71,apr,(pt(I),I=1,N)



      RETURN
      END
      SUBROUTINE ENERGY(N)
      include 'double.inc'
c------------------------------------------------
c  energy balance (electrons and ions)
c------------------------------------------------
c       implicit real*8 (a-h,o-z)
	include 'parf0'
	parameter(nu=npo)
	COMMON
     *  /en1/PNE(npo),PD0(npo),PT0(npo),PH0(npo),PDN(npo),
     *  PTN(npo),PHN(npo)
     *  /en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),
     *  WE0(npo),WQ0(npo)
     *  /en3/ AA(nu,4),BB(nu,4),CC(nu,4),
     *  TT1(nu,4),ALF(nu,4),
     *  UU(nu,4),TT(nu,2),ZZ(nu,2),WW(nu,2),FF(nu,2)
     *  /en4/WD0(npo),WT0(npo),WH0(npo),VD(npo),DIF(npo),
     *  GGT(npo),GGTN(npo)
     *  /en6/VI(npo)
     *  /en7/UD,ZD,UT,ZT,UH,ZH,LD,LT,LH,ID,IT,IH,KTP,Ntr
     *  /en9/QE0(npo),QQ0(npo),QDG(npo)
     *  /en10/GGE(npo),GGEN(npo),DXE(npo),DXQ(npo),
     *  WU(npo),UG(npo),VG(npo)
     *  /en11/UN(4),ZN(2),LL,KEN,KEN1,KEN2,NN
     *  /en12/pnal(npo),pnaln(npo),zalfa,talfa
     *  /en13/kpin,vpin,alp1,pot,skor
     *  /en26/del(npo)
     *  /en33/anom_e,anom_i,key_t11,kcchp
	common
     *  /ge2/NTAY,TAY,TTB
     *  /ge3/AI(npo),A0(npo),HA2(npo),a1(npo),ha(npo)
     *  /ge4/EPS1,EPS2,EPS0
     *  /ge5/kpr
     *  /ge6/zeff(npo),qpr(npo),ppr(npo),pr0,prg,zar
	common
     *  /dfm3/dfmax(npo),dfmax0(npo)
c
      dimension VI1(npo),VI2(npo),VI3(npo),fz(npo),
     *dh1(npo),dh2(npo),
     *GG(npo),FE(npo),FQ(npo),HG(npo),A(npo),B(npo),
     *C(npo)
c
      dimension TETA(npo),GK(npo),FD(npo),FT(npo),FH(npo),
     *PD(npo),PT(npo),PH(npo),WD(npo),WT(npo),
     *WH(npo),U(npo),B0(npo),Z(npo),a5(npo),b5(npo),
     *c5(npo),vu(npo)
c
	dimension tee(npo)
c
	character *20 mfe,mfq,mte,mtq,apr
c
	fmax=dfmax(n)
	fmax0=sqrt(dfmax0(n))
	FMAX1=sqrt(FMAX)
	kd2=0
	df=0.

	if(kpr.eq.1)print *,' ntay fmax1 fmax0=',ntay,fmax1,fmax0

	if(ntay.gt.2)then
c	if(ntay.gt.9999)then

	kd2=2
	df=-(fmax1-fmax0)/(fmax1*tay)
	end if
c
	NN=0
	ntr=0
       N1=N-1

      PAW1=5./3.
      PAW2=2./3.

c      PAW1=1.
c      PAW2=0.


      ALFA=1.5
      FKO=1.
	i=1
      VI1(i)=0.
      VI2(i)=0.
      VI3(i)=0.
      fz(i)=0.
      UG(i)=0.
      VG(i)=0.
      GG(i)=0.
	tee(i)=te0(i)
	vu(i)=0.

	i=1
	dh1(i)=0.5
	dh2(i)=0.
        
        ha2(1)=0.5*ha(2)

	do i=2,n1
	dh1(i)=ha(i)/(ha(i)+ha(i+1))
	dh2(i)=ha(i+1)/(ha(i)+ha(i+1))
	end do

      DO 1 I=2,N
	vu(i)=vi(i)
	tee(i)=te0(i)
      VI1(I)=VI(I)**PAW1
      VI2(I)=VI(I)**PAW2
    1 fz(I)=1./VI2(I)

      DO 2 I=1,N1
         FES=FKO*(fz(I)*GGEN(I)*dh2(i)+fz(I+1)*
     *GGEN(I+1)*dh1(i))*ALFA/TAY
         FE(I)=FES*TEN(I)
    2 FQ(I)=FES*TQN(I)
c--------------------------

      CALL ENIT(n)

      
      do i=1,n
c         del(i)=0.
      end do


ccc      if(kcchp.eq.0)CALL TP(N)



 1000 CONTINUE
c--------------------------

      pnal(1)=pnal(2)

	do i=1,n

           pn_1=1.*pd0(i)+1.*pt0(i)+2.*pnal(i)
           pn_2=1.*pd0(i)+1.*pt0(i)+4.*pnal(i)
	   ppr(i)=(zeff(i)*pn_1-pn_2)/(6.**2-zeff(i)*6.)
           pne(i)=pn_1+ppr(i)*6.

      pne(i)=pd0(i)+pt0(i)
	ppr(i)=0.



	end do

        MTE='pnal'
c        PRINT 71,MTE,(pnal(i),i=1,n)
        MTE='pne'
c        PRINT 71,MTE,(pne(i),i=1,n)
        MTE='ppr'
c        PRINT 71,MTE,(ppr(i),i=1,n)

      DO 50 I=1,N
c calculate pne...
cccc      PNE(I)=PD0(I)+PT0(I)+PH0(I)+zar*ppr(i)+zalfa*pnal(i)
c      PNE(I)=PD0(I)+PT0(I)+ph0(i)
   50 WU(I)=WD0(I)+WT0(I)+WH0(I)

      DO 3 I=2,N
      PP=0.5*(pd0(i)+pd0(i-1)+pt0(i)+pt0(i-1)+ph0(i)+ph0(i-1))

      if(kcchp.eq.0)then
         UG(I)=WU(I)+VD(I)*PP*VI(I)
      else
         UG(I)=0.
      end if

      GG(I)=VI1(I)*PP
      VG(I)=-UG(I)/PP*KEN2
      hg(i)=pne(i)
    3 CONTINUE

      hg(1)=pne(1)

      IF(NTAY.EQ.0)GO TO 99

      ALFA=1.5
      BETA=2.5

c      call can_prof(ug,vu)

c
      DO I=2,N1
      A(I)=-UG(I)/(2.*ha2(i))*beta*(dh1(i)+dh2(i))
      b(I)=(ug(i+1)-UG(I))/(2.*ha2(i))*beta*
     *(dh1(i)+dh2(i))
      c(I)=UG(I+1)/(2.*ha2(i))*beta*(dh1(i)+dh2(i))
      B(I)=B(I)+ ALFA*(dh2(i)*fz(I)*GG(I)+dh1(i)*
     *fz(I+1)*GG(I+1))/TAY
c
	a(i)=a(i)-hg(i-1)/ha(i)*vg(i)*dh2(i)
	c(i)=c(i)+hg(i+1)/ha(i+1)*vg(i+1)*dh1(i)
	b(i)=b(i)+hg(i)/ha(i)*vg(i)*dh2(i)-hg(i)/
     *ha(i+1)*vg(i+1)*dh1(i)
c
	end do

	i=1
      A(i)=0.
      b(I)=ug(i+1)/(2.*ha2(i))*beta*(dh1(i)+dh2(i))
      c(I)=ug(i+1)/(2.*ha2(i))*beta*(dh1(i)+dh2(i))
      B(I)=B(I)+ ALFA*(dh2(i)*fz(I)*GG(I)+dh1(i)*
     *fz(I+1)*GG(I+1))/TAY
c
	c(i)=c(i)+hg(i+1)/ha(i+1)*vg(i+1)*dh1(i)
	b(i)=b(i)-hg(i)/ha(i+1)*vg(i+1)*dh1(i)
c
   71 FORMAT(20X,A6/,(6(1pE10.3)))
c
c  NEW additions...

      i_new=1
      if(i_new.eq.1)then

      DO  I=1,N
         if(i.ne.n)hg(I)=(dh1(i)*vi1(I+1)+dh2(i)*vi1(I))*pne(i)

c         if(i.ne.n)vg(i)=alfa*0.5*kd2*a1(i)*df*
c     * (dh1(i)*fz(I+1)+dh2(i)*fz(I))

         vg(i)=alfa*0.5*kd2*ai(i)*df*fz(I)

      end do

      ateta=1.
      call inter_h0(hg,a1,n-1,ateta,val)
      hg(n)=val

c      ateta=1.
c      call inter_h0(vg,a1,n-1,ateta,val)
c      vg(n)=val

      apr='hg'
c      PRINT 71,apr,(hg(i),i=1,n)
      apr='vg'
c      PRINT 71,apr,(vg(i),i=1,n)

      i=1
c
      c(i)=c(i)+hg(i+1)/ha(i+1)*vg(i+1)*dh1(i)
      b(i)=b(i)-hg(i)/ha(i+1)*vg(i+1)*dh1(i)

c
      DO I=2,N1
c
	a(i)=a(i)-hg(i-1)/ha(i)*vg(i)*dh2(i)

	c(i)=c(i)+hg(i+1)/ha(i+1)*vg(i+1)*dh1(i)

	b(i)=b(i)+hg(i)/ha(i)*vg(i)*dh2(i)-hg(i)/
     *ha(i+1)*vg(i+1)*dh1(i)
c
	end do


      DO  I=1,N
         if(i.ne.n)hg(I)=( dh1(i)*ug(I+1)+dh2(i)*ug(I) )
         vg(i)=beta
      end do

      ateta=1.
      call inter_h0(hg,a1,n-1,ateta,val)
      hg(n)=val

      apr='* hg'
c      PRINT 71,apr,(hg(i),i=1,n)

      i=1
c
      c(i)=c(i)+hg(i+1)/ha(i+1)*vg(i+1)*dh1(i)
      b(i)=b(i)-hg(i)/ha(i+1)*vg(i+1)*dh1(i)

c
      DO I=2,N1
c
	a(i)=a(i)-hg(i-1)/ha(i)*vg(i)*dh2(i)
	c(i)=c(i)+hg(i+1)/ha(i+1)*vg(i+1)*dh1(i)

	b(i)=b(i)+hg(i)/ha(i)*vg(i)*dh2(i)-hg(i)/
     *ha(i+1)*vg(i+1)*dh1(i)
c
	end do

        end if

c  END NEW additions...
c
      DO 21 I=1,N1
      AA(I,1)=A(I)
      AA(I,2)=0.
      AA(I,3)=0.
      AA(I,4)=A(I)
      CC(I,1)=C(I)
      CC(I,2)=0.
      CC(I,3)=0.
      CC(I,4)=C(I)
      DELS=DEL(I)*Vu(I)*dh2(i)+DEL(I+1)*Vu(I+1)*dh1(i)
      BB(I,1)=B(I)+DELS
      BB(I,4)=BB(I,1)
      BB(I,2)=-DELS
      BB(I,3)=-DELS
      PG=0.5*(PNE(I)+PNE(I+1))*Vu(I+1)
      ALF(I+1,1)=-DXE(I+1)/HA(I+1)*PG
      ALF(I+1,4)=-DXQ(I+1)/HA(I+1)*PG
      ALF(I+1,2)=0.
      ALF(I+1,3)=0.
      TT1(I,1)=1./HA2(I)
      TT1(I,4)=TT1(I,1)
      TT1(I,2)=0.
      TT1(I,3)=0.
      FF(I,1)=FE(I)+QE0(I)*Vu(I)*dh2(i)+QE0(I+1)*
     *Vu(I+1)*dh1(i)
      FF(I,2)=FQ(I)+QQ0(I)*Vu(I)*dh2(i)+QQ0(I+1)*
     *Vu(I+1)*dh1(i)
   21 CONTINUE

  
        apr='* vu'
      if(kpr.eq.1)PRINT 71,apr,(vu(i),i=1,n)
        apr='* a'
      if(kpr.eq.1)PRINT 71,apr,(a(i),i=1,n)
        apr='* b'
      if(kpr.eq.1)PRINT 71,apr,(b(i),i=1,n)
        apr='* c'
      if(kpr.eq.1)PRINT 71,apr,(c(i),i=1,n)

      MFE='FE'
      MFQ='FQ'
      if(kpr.eq.1)PRINT 71,MFE,(FF(I,1),I=1,N)
      if(kpr.eq.1)PRINT 71,MFQ,(FF(I,2),I=1,N)
      TT(N,1)=TE0(N)
      TT(N,2)=TQ0(N)

      CALL PROGPM(N,ZN,UN,LL,4,2)
c
      DO 6 I=1,N
      IF(abs(TT(I,1)-TE0(I)).GT.EPS1*abs(TE0(I)))GO TO 7
      IF(abs(TT(I,2)-TQ0(I)).GT.EPS1*abs(TQ0(I)))GO TO 7
    6 CONTINUE
      GO TO 98
    7 CONTINUE

      DO 16 I=1,N

c!!!      TE0(I)=TT(I,1)*0.75+tee(i)*0.25

      TE0(I)=TT(I,1)
      TQ0(I)=TT(I,2)
	tee(i)=tt(i,1)
   16 CONTINUE
      MTE='TE0'
      if(kpr.eq.1)PRINT 71,MTE,(TE0(i),i=1,n)
      MTE='PNE'
      if(kpr.eq.1)PRINT 71,MTE,(pne(i),i=1,n)

c      print*,' **nn  **     ***',nn
      MTQ='TQ0'
c      PRINT 71,MTQ,(TQ0(i),i=1,n)
      NN=NN+1
      IF(NN.GT.100)print*,' **nn gt 100 **     ***'
      IF(NN.GT.200)print*,' **nn gt 200 **'
	if(nn.gt.200)stop
      GO TO 1000
   98 CONTINUE
      DO 5 I=1,N
      TE0(I)=TT(I,1)
      TQ0(I)=TT(I,2)
      WE0(I)=WW(I,1)
      WQ0(I)=WW(I,2)
    5 CONTINUE
      WE0(1)=0.
      WQ0(1)=0.
   99 CONTINUE
      DO 8 I=1,N
      GGE(I)=GG(I)
    8 CONTINUE

      MTE='TE0'
c      PRINT 71,MTE,(TE0(i),i=1,n)
      MTE='PNE'
c      PRINT 71,MTE,(pne(i),i=1,n)

      RETURN
      END

      SUBROUTINE PROGP(N,A,B,C,TT1,ALF,U,B0,T,
     *Z,W,F,ZN,UN,EPS0,LL)
c-------------------------------------------------
c calculate tridiagonal matrix in particle transport
c----------------------------------------------
       implicit real*8 (a-h,o-z)
      DIMENSION A(N),B(N),C(N),TT1(N),ALF(N),
     *U(N),B0(N),T(N),Z(N),W(N),F(N)
      U(1)=0.
      Z(1)=0. 
      D1=0.
      N2=N-1
      DO 1 I=1,N2
      R1=A(I)+B(I)+C(I)
      E1=C(I)/ALF(I+1)+TT1(I)
      IF(abs(E1).GT.EPS0)GOTO 5
      PRINT 6,E1
    6 FORMAT(20X,'E1 MALO PROGP **',E10.3)
	stop
    5 CONTINUE
      IF(I.NE.1)D1=A(I)/ALF(I)+TT1(I)
      G1=D1*U(I)-R1
      BB=1./(E1+G1/ALF(I+1))
      U(I+1)=BB*G1
      Z(I+1)=BB*(F(I)+D1*Z(I))
    1 CONTINUE
      IF(LL.NE.3)GO TO 9
      T(N)=(ZN-Z(N))/(U(N)-UN)
    9 CONTINUE
      W(N)=U(N)*T(N)+Z(N)
      DO 101 K=2,N
      I=N-K+2
      T(I-1)=T(I)-W(I)/alf(i)
  101 W(I-1)=U(I-1)*T(I-1)+Z(I-1)
      RETURN
      END

      SUBROUTINE PROGPM(N,ZN,UN,LL,M,M1)
c------------------------------------------
c  tridiagonal matrix in energy
c------------------------------------------
       implicit real*8 (a-h,o-z)
	include 'parf0'
	PARAMETER(nu=npo)
	common 
     *  /en3/ A(nu,4),B(nu,4),C(nu,4),
     *  TT1(nu,4),ALF(nu,4),
     *  U(nu,4),T(nu,2),Z(nu,2),W(nu,2),F(nu,2)
c
	DIMENSION ALM1(4),ALG(4),ALG1(4),UU(4),AA(4),
     *  CC(4),RR(4),DD(4),EE(4),SUM(4),sum2(4),GG(4),
     *  GG1(4),SS(2),TT(2),WW(2),
     *  VV(4),VV1(4),FF(2),ZZ(2)
c
	DIMENSION ZN(2),UN(4)
c
      DO 11 J=1,4
      U(1,J)=0.
   11 ALG1(J)=0.
      ZZ(1)=0. 
      ZZ(2)=0.
      N2=N-1

      DO 1 I=1,N2
      DO 13 J=1,4
      RR(J)=A(I,J)+B(I,J)+C(I,J)
      CC(J)=C(I,J)
      AA(J)=A(I,J)
      ALG(J)=ALF(I+1,J)
      ALM1(J)=ALG1(J)
      UU(J)=U(I,J)
   13 CONTINUE
      DO 16  J=1,2
      FF(J)=F(I,J)
      ZZ(J)=Z(I,J)
   16 CONTINUE
      CALL OBR(ALG1,ALG)
      DO 14 J=1,4
   14 ALF(I+1,J)=ALG1(J)
      CALL YMH(DD,AA,ALM1)
      CALL YMH(EE,CC,ALG1)
      DO 15 J=1,4
      EE(J)=EE(J)+TT1(I,J)
   15 DD(J)=DD(J)+TT1(I,J)
      CALL YMH(SUM2,dd,UU)
	do j=1,4
	sum(j)=sum2(j)-rr(j)
	end do
      CALL YMH(SUM2,sum,alg1)
      DO 18  J=1,4
   18 VV(J)=Ee(J)+SUM2(J)
      CALL  OBR(VV1,VV)
      CALL YMHB(SS,dd,zz)
      DO 21 J=1,2
21    ss(J)=SS(J)+ff(J)
      CALL YMHB(zz,vv1,ss)
      CALL YMH(uu,vv1,SUM)
	do j=1,4
	u(i+1,j)=uu(j)
	end do
	do j=1,2
	z(i+1,j)=zz(j)
	end do
    1 CONTINUE

      IF(LL.NE.3)GO  TO 9
      DO 28 J=1,4
	uu(j)=u(n,j)
   28 GG(J)=UN(J)-UU(J)
      CALL OBR(GG1,GG)
      DO 29 J=1,2
   29 ZZ(J)=Z(N,J)-ZN(J)
      CALL YMHB(TT,GG1,ZZ)
      DO 30 J=1,2
  30  T(N,J)=TT(J)
    9 CONTINUE
	do j=1,4
	uu(j)=u(n,j)
	end do
	do j=1,2
	tt(j)=t(n,j)
	end do
	call YMHB(ss,uu,tt)
	do j=1,2
	w(n,j)=ss(j)+z(n,j)
	end do
      DO 101 K=2,N
      I=N-K+2
	do j=1,2
	ww(j)=w(i,j)
	end do
      DO 32 J=1,4
      ALG1(J)=ALF(I,J)
   32 UU(J)=U(I,J)
      CALL YMHB(SS,alg1,ww)
	do j=1,2
	zz(j)=z(i-1,j)
	tt(j)=t(i,j)-ss(j)
	end do
	do j=1,4
	uu(j)=u(i-1,j)
	end do
	call ymHB(ss,uu,tt)
      DO 34 J=1,2
	ww(j)=ss(j)+zz(j)
	t(i-1,j)=tt(j)
   34 W(I-1,J)=ww(J)
  101 CONTINUE
      RETURN
      END
      SUBROUTINE YMH(A,C,D)
       implicit real*8 (a-h,o-z)
      DIMENSION A(4),C(4),D(4)
      A(1)=C(1)*D(1)+C(2)*D(3)
      A(2)=C(1)*D(2)+C(2)*D(4)
      A(3)=C(3)*D(1)+C(4)*D(3)
      A(4)=C(3)*D(2)+C(4)*D(4)
      RETURN
      END
      SUBROUTINE YMHB(C,A,B)
       implicit real*8 (a-h,o-z)
      DIMENSION C(2),A(4),B(2)
      C(1)=A(1)*B(1)+A(2)*B(2)
      C(2)=A(3)*B(1)+A(4)*B(2)
      RETURN
      END
      SUBROUTINE OBR(B,A)
       implicit real*8 (a-h,o-z)
      DIMENSION A(4),B(4)
	data eps/1.e-18/
      DEL=A(1)*A(4)-A(2)*A(3)
      IF(abs(DEL).GT.EPS)GO TO 1
      PRINT 2,DEL
	stop
    2 FORMAT(20X,'EI MALO MATRIX',E10.3)
    1 B(1)=A(4)/DEL
      B(2)=-A(2)/DEL
      B(3)=-A(3)/DEL
      B(4)=A(1)/DEL
      RETURN
      END

	subroutine proga(y,a,b,c,f,alfa,beta,n,
     *  i_ax,x1,x2,x3)

	implicit real * 8 (a-h,o-z)
	dimension y(n),a(n),b(n),c(n),f(n),alfa(n),beta(n)



	n1=n-1

        n2=2
c------------------------
	do i0=n2,n1
	i=n1-i0+n2
	d1=1./(b(i)+c(i)*alfa(i+1))
	alfa(i)=-a(i)*d1
	beta(i)=(f(i)-c(i)*beta(i+1))*d1
	end do
c

        if(i_ax.eq.1)then

        det=(x1+alfa(2)*x2)

        if(dabs(det).le.1.d-14)then
           print *,' det le 1.e-14',det
           stop
        end if

        y(1)=(x3-x2*beta(2))/det
        
        end if

	do i=n2,n
	y(i)=alfa(i)*y(i-1)+beta(i)
	end do

	return
	end

	subroutine time_step_tran()
       implicit real*8 (a-h,o-z)
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *  /DFM2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)
     *  /dfm3/dfmax(npo),dfmax0(npo)
	common
     *  /en1/PNE(npo),PD0(npo),PT0(npo),PH0(npo),PDN(npo),
     *  PTN(npo),PHN(npo)
     *  /en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),WE0(npo),
     *  WQ0(npo)
     *  /en4/WD0(npo),WT0(npo),WH0(npo),VD(npo),DIF(npo),
     *  GGT(npo),GGTN(npo)
     *  /en5/SD0(npo),ST0(npo),SH0(npo)
     *  /en10/GGE(npo),GGEN(npo),DXE(npo),DXQ(npo),WU(npo),
     *  UG(npo),VG(npo)
	common
     *  /en12/pnal(npo),pnaln(npo),zalfa,talfa
     *  /en18/pin(npo),pin0(npo),q11(npo),pal(npo)
     *	/en28/wen1,wen2
     *  /eq15/pll,zsep,rsep,zmax,rmax,zmin,rmin
     *  /eq15e/pll0,tpl0,udd
	common
     *  /dfm14/tokae,ajae(npo),ajae0(npo),enae
c
	common
     *	/ge1e/rs0,tpl
	common
     *  /mid2/vi(npo),spo(npo)
     *  /mid2_0/vi0(npo),pfi0(npo)



	character *12 apr
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

	apr='-te0-'
!	if(kpr.eq.1)print 71,apr,(te0(i),i=1,n)
	apr='-tq0-'
!	if(kpr.eq.1)print 71,apr,(tq0(i),i=1,n)
	apr='-pne-'
!	if(kpr.eq.1)print 71,apr,(pne(i),i=1,n)
	apr='-ggt-'
c	print 71,apr,(ggt(i),i=1,n)

c	te0(n-2)=te0(n)
c	te0(n-1)=te0(n)

c-
c----------------------------
	do i=1,n
	DMN(I)=DM0(I)
	dfmax0(i)=dfmax(i)
      GGTN(I)=GGT(I)
      PDN(I)=PD0(I)
      PTN(I)=PT0(I)
      GGEN(I)=GGE(I)
      TEN(I)=TE0(I)
	TQN(I)=TQ0(I)
c---
	vi0(i)=vi(i)
	pfi0(i)=pfi(i)
c---
	ajae0(i)=ajae(i)
	pin0(i)=pin(i)
	pnaln(i)=pnal(i)
	sd0(i)=0.
	st0(i)=0.
	sh0(i)=0.
	end do

	pll0=pll
	tpl0=tpl

	wen1=wen2
	zmag0=zmag
	rmag0=rmag
	fmax0=fmax
	epol0=epol

	return
	end

      SUBROUTINE ONE2D()
c-------------------------------------
c   initial values and profiles
c-----------------------------------
	implicit real*8 (a-h,o-z)
	include 'parf0'
	common
     *	/n_m/n,m,mp
      COMMON
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
	common
     *	/pol1/ro(npo,ntet),aj(npo,ntet)
     *	/pol3/Ax(npo),TET(ntet),HAx(npo),HT(ntet)
	character *12 apr

c
c
      AI(1)=0.
      HA(1)=0.
      N1=N-1
      M1=M-1
      A0(1)=0.
      A(1)=0.
      A0(2)=0.
      DO 11 I=2,N

	xx=i-1.d0
	a(i)=xx/(n-1.d0)

c	xx=i-1.
c	a(i)=xx/(n-1.)

	a0(i)=a(i)
c	a(i)=(1.-dexp(-alf*a(i)))/(1.-dexp(-alf))
c     	a(i)=a(i)**(1.5-0.5*a(i))*(1.-dexp(-alf*a(i)))/(1.-dexp(-alf))
c	a(i)=a(i)**(1.5-0.5*a(i))
c	a(i)=(i-1.)/(n2-1)*0.995
c      A(I)=SQRT(A(I))
	ha(i)=a(i)-a(i-1)
   11 CONTINUE

c	alf=0.95d0
	alf=1.d0


	do i=2,n
	if(i.ge.n/2)ha(i)=ha(i-1)*alf
	end do
c	do i0=2,n
c	i=n-i0+2
c	if(i.le.n/3)ha(i-1)=ha(i)*alf
c	end do

	sum=0.
	do i=2,n
	sum=sum+ha(i)
	end do
	al1=1./sum
	do i=2,n
	ha(i)=ha(i)*al1
	a(i)=a(i-1)+ha(i)
	end do
c
      A(N)=1.
	apr='a(i)'
	if(kpr.eq.1)print 71,apr,(a(i),i=1,n)
c
      DO 1 I=2,N
	a0(i)=a(i-1)
      HA(I)=A(I)-A(I-1)
    1 CONTINUE
	apr='ha'
	if(kpr.eq.1)print 71,apr,(ha(i),i=1,n)
      DO 31 I=2,N
      AI(I)=0.5*(A(I)+A(I-1))
	ha2(i-1)=ai(i)-ai(i-1)
31	continue
      HA2(N)=a(n)-ai(n)
	apr='ai'
	if(kpr.eq.1)print 71,apr,(ai(i),i=1,n)
	apr='ha2'
	if(kpr.eq.1)print 71,apr,(ha2(i),i=1,n)
	do i=1,n
	ax(i)=a(i)
	hax(i)=ha(i)
	end do
	apr='hax'
	if(kpr.eq.1)print 71,apr,(hax(i),i=1,n)
c
c   initial ro(i,j)
	do i=1,n
	do j=1,m
	ro(i,j)=a(i)
	end do
	end do
c
c==========================
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))
101	continue
      RETURN
      END

	subroutine feet_lin(n,PSI,aval,x,xp)
c	subroutine feet_lin(psi,x,n,aval,xp)                                   
      	include 'double.inc'
                                                                  
	dimension psi(*),x(*)                                                  

        common                                                          
     *  /ge5/kpr                                                        
                                                                        
	xzer(x1,x2,v1,v2) = (x1*v2-x2*v1)/(v2-v1+1.d-15)                       
                                                                        
	do i=1,n-1                                                             
                                                                        
	u1=psi(i)-aval                                                         
	u2=psi(i+1)-aval                                                       
                                                                        
	if(u2*u1.le.0.d0) then                                                   
                                                                        
	   xp = xzer(x(i+1),x(i),u2,u1)                                        
                                                                        
	end if                                                                 
	                                                                       
	end do                                                                 
                                                                        
                                                                        
	return                                                                 
	end                                                                    





c
	subroutine feeti(n,PSI,aval,x,xp)
       implicit real*8 (a-h,o-z)
	DIMENSION psi(n),x(n)

        common /c_feet1/yq
c
	n1=n-1
c
c
	do i=1,n1
	if( (xp-x(i+1))*(xp-x(i)).gt.0.)go to 11
c
	if( (i-1)*(i-n1).lt.0) then
	call fit(1,x(i-1),x(i),x(i+1),x(i+2),psi(i-1),
     *  psi(i),psi(i+1),psi(i+2),xp,aval,yq)
	return
	end if
c
	if( i.eq.1) then
	call fit(1,x(i),x(i+1),x(i+2),x(i+3),psi(i),
     *  psi(i+1),psi(i+2),psi(i+3),xp,aval,yq)
	aval=aval
	yq=yq
	return
	end if
c
	if( i.eq.n1) then
	call fit(1,x(i-2),x(i-1),x(i),x(i+1),psi(i-2),
     *  psi(i-1),psi(i),psi(i+1),xp,aval,yq)
	aval=aval
	yq=yq
	end if
11	continue
	end do
	return
	end
	subroutine feet_p(n,PSI,aval,x,xp)
       implicit real*8 (a-h,o-z)
	DIMENSION psi(n),x(n)
c
	n1=n-1

	do i=1,n1
	if( (xp-x(i+1))*(xp-x(i)).gt.0.)go to 11
c
	if(i.ne.1) then
	call fit_p(psi,x,n,i,xp,aval)
	return
	end if
c
	if( i.eq.1) then
	call fit_p(psi,x,n,i+1,xp,aval)
	return
	end if
11	continue

	end do
	return
	end
	subroutine fit_p(f,ai,n,i,x,y)
c---------------------------------------------
c  quadratic polinomial interpolation for array
c  from transport to equilibrium
c-----------------------------------------------
       implicit real*8 (a-h,o-z)

	dimension f(n),ai(n)

	data err /1.e-14/

	delt=ai(i+1)**2*ai(i)+ai(i)**2*ai(i-1)+
     *  ai(i-1)**2*ai(i+1)-
     *  ai(i-1)**2*ai(i)-ai(i)**2*ai(i+1)-ai(i+1)**2*ai(i-1)

	if(abs(delt).lt.err)then
	  if(kpr.eq.1)print *,' i ai',i,ai(i-1),ai(i),ai(i+1)

 	call linear(n,f,y,ai,x)

	return
	end if


	aak=(f(i+1)*ai(i)+f(i)*ai(i-1)+f(i-1)*ai(i+1)-
     *  f(i-1)*ai(i)-f(i)*ai(i+1)-f(i+1)*ai(i-1))/delt

	bbk=(ai(i+1)**2*f(i)+ai(i)**2*f(i-1)+ai(i-1)**2
     *  *f(i+1)-
     *  ai(i-1)**2*f(i)-ai(i)**2*f(i+1)-ai(i+1)**2
     *  *f(i-1))/delt

	cck=f(i)-aak*ai(i)**2-bbk*ai(i)

	y=aak*x*x+bbk*x+cck

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


      
     	open(unit=2,file='for002.dat',form='formatted')
        if(kpr.eq.1)print *,' begin for002 reading'

	read (2,*)
	read (2,*)n,m,next
	read (2,*)
	read (2,*)tt2,tay,t_end,rs0,psend
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
	   print*,'tt2 teg0=',tt2,tego

	   print *,' end for002 reading'
	end if



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


	return
	end
        subroutine read_data()
       implicit real*8 (a-h,o-z)

	include 'parf0'
	common
     *	/n_m/n,m,mp
     *  /n_polar1/n_polar
	common
     *	/i_graph/i_graph
	common
     *	/ge1e/rs0,tpl
     *  /ge2/NTAY,TAY,TT
     *  /ge2e/t_end
     *  /ge4/EPS1,EPS2,EPS0
     *  /ge6e/zeff_a,zeff_b
	common
     *  /DFM1/UDM,ZDM,L3,SIG0
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

	common /keys4/k_ener,k_uv

     	open(unit=2,file='for002.dat',form='formatted')
c	read (*,*)

	read (2,*)
	read (2,*)n,m,next
	read (2,*)
	read (2,*)tt,tay,t_end,rs0,psend
	read (2,*)
	read (2,*)i_graph
	read (2,*)
	read (2,*)alfa0,beta,alfa1
	read (2,*)
	read (2,*)iread,kzero,iwtite,kefit
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
	read (2,*)n_polar
	read (2,*)
        read (2,*)ngra
	read (2,*)
        read (2,*)k_ion

	ndop=0
	pnor=6.25e8
	emoe=emoe*pnor
	emoq=emoq*pnor


	close(2)

c!!!	mp=(m-2)/2+2
	mp=m

c	print *,' n m mp',n,m,mp
c	read (*,*)

	return
	end



        SUBROUTINE ENIT(n_xx)
   	include 'double.inc'

	include 'new_com.inc'

        call enit_c(
     *  n,k_ion,pow_el,pow_ion,q_e,q_i,
     *  i_lh,i_ech,r_lh,k_rlw,rs0,s_beam,
     *  QNET_B,SAL_B,
     *  eee2,sb2,s_beam2,ro_bar,alf_bar,kpr,tokbut,volt,tok1)

        return
        end

        SUBROUTINE ENIT_c(
     *  n,k_ion,pow_el,pow_ion,q_e,q_ion,
     *  i_lh,i_ech,r_lh,k_rlw,rs0,s_beam,
     *  QNET_B,SAL_B,
     *  eee2,sb2,s_beam2,ro_bar,alf_bar,kpr,tokbut,volt,tok1)

	include 'double.inc'


c--------------------------------------------
c   sources for energy equation and heat conductivities
c--------------------------------------------------
c        implicit real*8 (a-h,o-z)
	include 'parf0'

        dimension s_beam(*),QNET_B(*),SAL_B(*),sb2(*),
     *  s_beam2(*),volt(*),tok1(*)


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
     *  /en25/zhib,teoh
     *  /en26/del(npo)
     *  /en27/nij
     *  /en32/x_e(npo),x_i(npo)
     *  /en33/anom_e,anom_i,key_t11,kcchp

        common /c_feet1/yq
c
	dimension pbe(npo),pbi(npo)

	dimension a_pol(npo),q_pol(npo),shir(npo),help1(npo),
     *  help2(npo),help3(npo),ajb_s(npo)


	character*10 apr
c  ===
c   here the noclassical parameters are calculated
	flog1(pnx,tx)=23.4-1.15*13.*dlog10(pnx)+3.45*dlog10(tx)
	flog2(pnx,tx)=25.3-1.15*13.*dlog10(pnx)+2.3*dlog10(tx)
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
      N2=N-1
      QE0(1)=0.
      QQ0(1)=0.
      DEL(1)=0.

      q_e=0.
      q_ion=0.

      p_av_h=0.
      p0_av_h=0.
      s_av_h=0.
      vv=0.

	alf_bar=1.d0
	ro_bar=1.d0

      PNOR=6.25E8

      

	if(kpr.eq.1)print *,' key_t11 anom_e anom_i===',
     * key_t11,anom_e,anom_i

	if(kpr.eq.1)print *,' alf_bar ro_bar===',alf_bar,ro_bar

        PNOR=6.25E8
c----------
	do i=2,n
	QDG(I)=(1.e-6*pnor)*(TOK1(I)*1.e3)*abs(volt(I))*
     *  spo(i)/(2.*pi*vi(i))
	qdg(i)=abs(qdg(i))
	end do

	summ=0.
	do i=2,n
	summ=summ+(1.-ai(i)**2)*2.*pi*vi(i)*ha(i)
	end do
	aemoe=emoe/summ
	aemoq=emoq/summ
c
	do i=2,n
!           QDE0(I)=aEMOE*(1.-ai(I)**2)
!           QDQ0(I)=aEMOQ*(1.-ai(i)**2)
c	if(ai(i).le.0.8)n_f=i
	end do

      tego=teoh
      
	if(kpr.eq.1)print *,' rs bt',rs,bt

	if(kpr.eq.1)print *,' pi zhib',pi,zhib
	if(kpr.eq.1)print *,' tego eu',tego,eu
	if(kpr.eq.1)print *,' zalfa',zalfa
	if(kpr.eq.1)print *,' emoe emoq',emoe,emoq

c	read (*,*)


      i_en=i_en+1
      if(i_en.eq.1)coef_nc=1.

	i=n/3
	if(kpr.eq.1)then
	apr='gra1'
        print 71,apr,(gra1(i),i=1,n)
	apr='gra2'
        print 71,apr,(gra2(i),i=1,n)
	apr='spo'
        print 71,apr,(spo(i),i=1,n)
	apr='QDG'
        print 71,apr,(QDG(i),i=1,n)
	apr='a_m'
        print 71,apr,(a_m(i),i=1,n)
	apr='r_m'
        print 71,apr,(r_m(i),i=1,n)
	apr='te0'
        print 71,apr,(te0(i),i=1,n)
	apr='tq0'
        print 71,apr,(tq0(i),i=1,n)
	apr='pne'
      if(kpr.eq.1)  print 71,apr,(pne(i),i=1,n)
	apr='pd0'
        print 71,apr,(pd0(i),i=1,n)
	apr='pt0'
        print 71,apr,(pt0(i),i=1,n)
	apr='qdq0'
        print 71,apr,(qdq0(i),i=1,n)
	apr='qde0'
        print 71,apr,(qde0(i),i=1,n)
	apr='tq0'
c        print 71,apr,(tq0(i),i=1,n)
	apr='zeff'
        print 71,apr,(zeff(i),i=1,n)
	apr='q'
        if(kpr.eq.1)print 71,apr,(q(i),i=1,n)

      end if
      
c       zhib1=zhib*(0.1+ai(i)**2)
c ---->  Auxiliary heating power calculated (only in 17 point is deposited)

        tok_b=0.
        tok_bo=0.
        tok_b1=0.
        tok_b2=0.
        tok_bs=0.
        s_plas=0.

!        if(ntay.lt.2)tego=teoh

!        call aux_prof()

!        call lh_heat()

!        call ech_heat()


	xe_av=0.



c----------
	do i=1,n
	pbe(i)=pne(i)*te0(i)
	pbi(i)=(pd0(i)+pt0(i)+ph0(i))*tq0(i)
	end do

c	pbe(1)=pbe(2)
c	pbi(1)=pbi(2)

        DO 1 I=2,N
	dpne=(pne(i)-pne(i-1))/( (pne(i)+pne(i-1))*0.5*ha(i) )
	dpbe=(pbe(i)-pbe(i-1))/( (pbe(i)+pbe(i-1))*0.5*ha(i) )
	dpbi=(pbi(i)-pbi(i-1))/( (pbi(i)+pbi(i-1))*0.5*ha(i) )
	dtbe=(te0(i)-te0(i-1))/( (te0(i)+te0(i-1))*0.5*ha(i) )
	dtbi=(tq0(i)-tq0(i-1))/( (tq0(i)+tq0(i-1))*0.5*ha(i) )

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
	d_i=0.5*(pd0(i)+pd0(i-1)+pt0(i)+pt0(i-1)+ph0(i)+ph0(i-1))
	d_ed=(pne(i)-pne(i-1))/(psi(i)*ha(i))
	d_id=d_ed

	help2(i)=dtbe
	help3(i)=dpne


	dqb=(q(i)-q(i-1))/( (q(i)+q(i-1))*0.5*ha(i) )

	shir(i)=dqb*ai(i)

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
      POT=(4.*pnal(i)+2.*PD0(I)+3.*PT0(I)+1.*PH0(I))/PNE(I)
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
!        EPI_0=AI(I)*eu/rs
c
	epi_m=a_m(i)/r_m(i)

	help1(i)=epi_m

      EPI=epi_m
c      print *,' i epi',i,epi
c  W_i frequency ....
c      WI=9.57E3*BT*zeff(i)/POT*1.E3
      WI=9.57E3*BT/POT*1.E3
c  W_e frequency ....
      WE=1.76e7*BT*1.E3
c  V_i ion velocity ...
      VTI=SQRT(1.9*ABS(TGI)/POT)*1.E6
c  v_e electrons velocity ...
	vte=sqrt(1836.*tgE/tgi)*vti
c  V_i/W_i
      RI=VTI/WI
c
	bp0=-psi(i)/(2.*pi*rs)*gra1(i)

c NO CORRECTION ( Polevoy's) 
       DI=RI**2*Q(I)**2/EPI**1.5*VII

	Q_I=epi*bt/bp0

c NEW CORRECTION ( Rustam's)      
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
	ft=1.-(1.-epi)**2/(sqrt(1.-epi**2)*(1.+1.46*sqrt(epi)))
	enu=0.6913*qlog*rs*q(i)*pg/(tge**2*epi*sqrt(epi))
	cr=0.56/zeff(i)*(3.-zeff(i))/(3.+zeff(i))

	xsi=0.58+0.2*zeff(i)
	ale=3.4/zeff(i)*(1.13+zeff(i))/(2.67+zeff(i))
        

	sigk(i)=0.5*ale*(1.-ft/(1.+xsi*enu))
     *  *(1.-cr/(1.+xsi*enu))

c        print *,' i correc sigk',i,0.5*ale,sigk(i)


c       sigk(i)=1.-1.31*1.48*sqrt(eu/rs*ai(i))
c
c
c-----> bootstreap current density

	ajb(i)=-0.16e-3*pg*tge*sqrt(epi)/bp0*(fk13*a1e+fk23*
     *dtbe)


c===================
c
	xft=ft/(1.-ft)
	dxft=1.414*zeff(i)+zeff(i)**2+xft*(0.754+2.657*zeff(i)+
     *  2.*zeff(i)**2)+xft**2*(0.348+1.243*zeff(i)+zeff(i)**2)
	alft=-1.172/(1.+0.462*xft)
	pl31=(0.745+2.21*zeff(i)+zeff(i)**2+xft*(0.348+1.243*zeff(i)+
     *  zeff(i)**2))/dxft

        pl31_hh=pl31

	pl32=(0.884+2.074*zeff(i))/dxft
	a1e=p_ed/p_e
	a1i=p_id/p_i
	a2e=t_ed/t_e
	a2i=t_id/t_i

c!!! OLD	cinv=1./(zeff(i)*t_e/t_i)

c###	cinv=1./(zeff(i)*t_e/t_i)

	cinv=p_i/p_e

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
c!!!	ajbn(1)=0.

c!!!!!	ajbn(2)=0.5*ajbn(3)

c        if(i.ge.n-3)print *,'i ajb ajbn bstrap',
c     *  i,ajb(i),ajbn(i),bstrap



      pzion=zeff(i)

      pR=r_m(i)*0.01
c      pft=1.-ft
      pft=ft

c R_pe=p_e/p
      r_pe=p_e/(p_e+p_i)


      pl31_h=pl31

c      call BSCOEFF(pft,q(i),pR,epi,te0(i),pne(i),tq0(i),
c     * pne(i),zeff(i),pzion, 
c     * pl31,pl32,pl34,palfa)

      call BSCOEFF(pft,q(i),pR,epi,t_e,d_e,t_i,
     * d_i,zeff(i),pzion, 
     * pl31,pl32,pl34,palfa,signeo)

      sigk(i)=signeo

	i_prinit=0
	if(i_print.eq.1)then
      print *,' i,pft,q(i),pR,epi,t_e,d_e,t_i,
     * d_i,zeff(i),pzion,
     * pl31,pl32,pl34,palfa,signeo'

      print *,i,pft,q(i),pR,epi,t_e,d_e,t_i,
     * d_i,zeff(i),pzion, 
     * pl31,pl32,pl34,palfa,signeo

	end if




c      print *,' i pl31,pl31_h pl31_hh',
c     *pl31,pl31_h,pl31_hh

c      print *,' i pl31,pl32,pl34,palfa ',
c     *pl31,pl32,pl34,palfa

c      print *,' i sigk',i,sigk(i)

        
        c_boot=2.*pi*1.6*0.01
c        c_boot=5.*1.6*0.01

      ajb_te=c_boot*(f(i)*rs*0.01/bt)*(p_e+p_i)*
     * r_pe*(pl31+pl32)*t_ed/t_e

      ajb_n=c_boot*(f(i)*rs*0.01/bt)*(p_e+p_i)*pl31*d_ed/d_e

      ajb_te=c_boot*(f(i)*rs*0.01/bt)*(p_e+p_i)*
     * r_pe*(pl31+pl32)*t_ed/t_e

c      print *,' t_e t_i bt d_e',t_e,t_i,bt,d_e
c      print *,' f p_e p_i r_pe pl31 pl32',f(i),p_e,p_i,r_pe,pl31,pl32
      
      ajb_ti=c_boot*(f(i)*rs*0.01/bt)*(p_e+p_i)*
     *(1.-r_pe)*(1.+pl34/pl31*palfa)*pl31*t_id/t_i 



      ajb_sa=c_boot*(f(i)*rs*0.01/bt)*(p_e+p_i)*(pl31*d_ed/d_e+
     * r_pe*(pl31+pl32)*t_ed/t_e+
     *(1.-r_pe)*(1.+pl34/pl31*palfa)*pl31*t_id/t_i )

c      print *,' i c_boot f rs bt ',
c     * i,c_boot,f(i),rs,bt

c      print *,' i ajb_n ajb_te ajb_ti ',
c     * i,ajb_n,ajb_te,ajb_ti


c      print *,' i ajb_sa ajb ajbn bstrap',
c     * i,ajb_sa,ajb(i),ajbn(i),bstrap



      tok_bs=tok_bs+ajb_sa*spo(i)*ha(i)

      s_plas=s_plas+spo(i)*ha(i)

      tok_b=tok_b+ajb(i)*spo(i)*ha(i)
      tok_b1=tok_b1+ajbn(i)*spo(i)*ha(i)
      tok_b2=tok_b2+bstrap*spo(i)*ha(i)


      ajb_s(i)=ajb_sa

!!!      ajb(i)=ajbn(i)

!      ajb(i)=ajb_sa*bt

      ajb(i)=ajb_sa


c      ajb(i)=ajbn(i)

      tok_bo=tok_bo+ajb(i)*spo(i)*ha(i)

c
c      if(ajb(i).le.0.)ajb(i)=0.

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

c      print *,' i ft fasp epi_0 epi ',i,ft,fasp(i),epi_0,epi


      PKI=0.66*( pkis/0.66/(1.+1.03*SQRT(VI0)+0.31*VI0)+1.77*EPI**1.5*
     *VI0*fasp(i)/(1.+0.74*EPI**1.5*VI0))

c  Correction to Neoclassival Thermal Conductivity due to impurity...
c  alf_imp=(N_I/ni)(Z_I**2/Zi**2)

	zar_i=zalfa

	alf_imp=(zeff(i)-1.)/(zar_i**2-zar_i)*zar_i**2

cFormula (18) Chang-Hinton
	h_p=1.+1.33*alf_imp*(1.+0.60*alf_imp)/(1.+1.79*alf_imp)
	vi0_imp=vi0*(1.+1.54*alf_imp)

c Formula (13) Chang-Hinton
      PKIS_imp=( 0.66*(1.+1.54*alf_imp)+(1.88*sqrt(epi)-1.54*epi)*
     * (1.+3.75*alf_imp) )*bsq(i)

cFormula (18) Chang-Hinton
	pki_imp=0.66*(pkis_imp/0.66/(1.+1.03*sqrt(vi0_imp)+0.31*vi0_imp)+
     *  0.74**2/0.31*vi0_imp*EPI**1.5*fasp(i)*h_p
     *  /(1.+0.74*vi0_imp*EPI**1.5))

c----->  neoclassical ion heat conductivity DXQ

      DXQ_old=1.5*zeff(i)*PKI_OLD*DI*1.E-3*GRA2(I)

      DXQ_i=1.5*zeff(i)*PKI*DI*1.E-3*GRA2(I)

      DXQ(I)=1.5*PKI_imp*DI*1.E-3*GRA2(I)

c  in m2/s----++++

      x_i_I=0.1*dxq_i/gra2(i)

      x_i(I)=0.1*dxq(i)/gra2(i)


c  in m2/s----++++
      x_e_i=0.1*PKE*DE*1.E-3

 	if(i_test.eq.1)print *,' i x_i x_old q ',i,x_i(i),x_i_i,q(i)

ccc        print *,'i x_i x_old zeff zar_i !!!!!!!!!',i,x_i(i),x_i_i,
ccc     *  zeff(i),zar_i

c         print *,'i pkis*ZEFF pkis_imp ',i,pkis*zeff(i),pkis_imp


c	print *,'ve0  pki pki_imp alf_imp ',ve0,pki,
c     *  pki_imp,q_i,alf_imp

c*** TEST TEST TEST **************
	if(i.ge.n-3)then
c	print*,'##### te ne Zeff Zimp HI_new HI_old'
c	print*,te0(i),pne(i),zeff(i),zar_i,x_i(i),x_i_i
	end if 
c*********************************


c
c  anomalous factor anom_i for ions...
      DXQ(i)=anom_i*DXQ(i)
      x_i(i)=anom_i*x_i(i)
c
c
      PKE=0.66*(1./(1.+1.03*SQRT(VE0)+0.31*VE0)+1.77*EPI**3*
     *VE0/(1.+0.74*EPI**1.5*VE0))
c----->  neoclassical electrons ...
c###      if(key_t11.eq.1)then
      DXE(I)=PKE*DE*1.E-3*GRA2(I)
c  in m2/s----++++
      x_e(I)=0.1*PKE*DE*1.E-3
c####      end if
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
	qce(i)=0.265e-5*bt*bT*tgE*fi
C*****************
      TETI=TQ0(I)/93800.
      Sech=2.56*TQ0(I)**(-2./3.)*
     *(1.+7.*TETI**(3./4.))/(1.+242.*TETI**
     *(13./4.))**0.5*EXP(-200./TQ0(I)**(1./3.))
c------> alfa particle source SAL
      SAL(I)=SEch*PD0(I)*PT0(I)

c------> alfa particle source due to BEAM-Target interactions..

      s_al=(s_beam(i)+s_beam2(i))*pt0(i)

!      print *,' i sal  s_al =',i,sal(i), s_al

      sal_b(i)=s_al

c      print *,' i sal s_al sb',i,sal(i),s_al,sb(i)

        sal(i)=sal(i)+s_al

	pnal(i)=(sal(i)+pnaln(i)/tay)/(1./tay+1./talfa)
c	pnal(i)=sal(i)*tay+pnaln(i)

!      print *,' i pnal sal talfa =',i,pnal(i),sal(i),talfa

        s_av_h=s_av_h+sal(i)*tay*vi(i)*ha(i)
        p_av_h=p_av_h+pnal(i)*vi(i)*ha(i)
        p0_av_h=p0_av_h+pnaln(i)*vi(i)*ha(i)
        vv=vv+vi(i)*ha(i)
c
c----->  neutron power QNET

      QNET(I)=14.6E6*SAL(I)
      QNET_B(I)=14.6E6*SAL_B(I)
c
      ZA1=4./POT**(2./3.)
      ENA1=14.8*TE0(I)*ZA1
      uA=ENA1/3.5E6
      uAS=SQRT(uA)
      AAl=uA*(0.6+1./3.*dlog((1.-uAS+uA)/(1.+uAS)**2)+1.1547*
     *ATAN((2.-uAS)/SQRT(3.d0)/uAS))
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

        alfa_loss=0.7

       QAE(I)=3.5E6*(1.-AAl)*SAL(I)*alfa_loss
       QAQ(I)=3.5E6*AAl*SAL(I)*alfa_loss

c---> power transfer from neutral beam to electrons QPE

      Z1=(DD*2.+DT*3.+DH*1.)/POT**(2./3.)
      EN1=14.8*TE0(I)*Z1
      u=EN1/Eee
      uS=SQRT(u)
      Al=u*(0.6+1./3.*dlog((1.-uS+u)/(1.+uS)**2)+1.1547*
     *ATAN((2.-uS)/SQRT(3.d0)/uS))

      QpE(I)=Eee*(1.-Al)*SB(I)

c????      QpE(I)=(1.-Al)*qbeam(I)
c----> power transfer from neutral beam to ions QPQ
      QpQ(I)=Eee*Al*SB(I)
c????????      QpQ(I)=Al*qbeam(I)

      if(abs(eee2).gt.1.e-5)then
      u=EN1/Eee2
      uS=SQRT(u)
      Al=u*(0.6+1./3.*dlog((1.-uS+u)/(1.+uS)**2)+1.1547*
     *ATAN((2.-uS)/SQRT(3.d0)/uS))

      QpE(I)=qpe(i)+Eee2*(1.-Al)*SB2(I)
      QpQ(I)=qpq(i)+Eee2*Al*SB2(I)

      end if


c
c---> electrons energy source
	nal=1
c	print *,' nal==',nal

      QE0(I)=QDH(I)-QTOR(I)+QpE(I)+QAE(I)+QDE0(I)
c---> ions energy source
      QQ0(I)=QpQ(I) +QAQ(I)+QDQ0(I)

c******************************************

c   here tego is only parameter
c-----> parabolic profile in heat conductivity
c       if(i.ge.n/3)higo=zhib/tego*(0.1+ai(i)**2)*eu*eu

c        higo=zhib/tego*(0.3+ai(i)**2)*eu*eu
        higo=zhib/tego*(0.1+ai(i)**2)*eu*eu

	if(ai(i).gt.ro_bar)higo=higo*alf_bar

c	if(i_ech.eq.3)higo=zhib/tego*ai(i)*eu*eu


c-----> heat coductivity is constant
c       if(i.lt.n/3)higo=zhib1/tego*eu*eu

c	if(i_ech.eq.2)then
c       higo=zhib/tego*eu*eu
c	end if

c-----> SS ITER case

	if(k_ion.eq.4)then
	gamma=10.
	in1=.5*n

        if(i_ech.eq.3)in1=0.6*n

	in2=.9*n


C OLD	if(i.lt.in1.or.i.ge.in2)gamma=0.

c_OLD	higo=zhib/tego*(0.3+ai(i)**2)*eu*eu*gamma+zhib*dxq(i)/gra2(i)

	if(i.lt.in1)then
            coef_nc=0.5
            coef_nc=1.
c           coef_nc=3./q(i)
c            higo=zhib/tego*(0.1+ai(i)**2)*eu*eu
            higo=higo*coef_nc
c           higo=coef_nc*dxq(i)/gra2(i)*zhib
c           higo=coef_nc*dxq(i)/gra2(i)
	end if

	if(i.ge.in2)then
           coef_nc=4.
           higo=coef_nc*higo
c           higo=coef_nc*dxq(i)/gra2(i)*zhib
	end if
	end if

c**********************************************************
	xig=higo
c
c---------  RADIAL DEPENDENT T-11 SCALING for X_e..
c       te11=3.5e-5*(ai(i)*eu/rs)**0.25*q(n)*pcch*rs**3/sqrt(tec)
c

c!!!	x11=1.e4*sqrt(tge/pot)*((ai(i)*eu/rs)**1.75)/(q(i)*pg*rs)

	i02=0.2*n
	if(i.ge.i02)then 
         x11=1.e4*sqrt(tge/pot)*((ai(i)*eu/rs)**1.75)/(q(i)*pg*rs)
         x11_1=sqrt(tge/pot)
         x11_2=(ai(i)*eu/rs)**1.75
         x11_3=(q(i)*pg*rs)
	else
         x11=1.e4*sqrt(tge/pot)*((ai(i02)*eu/rs)**1.75)/(q(i)*pg*rs)
         x11_1=sqrt(tge/pot)
         x11_2=(ai(i02)*eu/rs)**1.75
         x11_3=(q(i)*pg*rs)
	end if

      
!      print *,' i x11 tge ai rs =',i,x11,tge,ai(i),rs
!      print *,' i02 x11_1 x11_2 x11_3 =',i02,x11_1,x11_2,x11_3
      

        x11=x11*anom_e
	if(k_rlw.eq.1)then
c***** Radial dependent RLW scaling for X_e (m2/s) *******
c ***  Another >>> MKSA units     
c       X_e=2*(ai(i)*eu/rs)*(1.+zeff)/rs0)**0.5*abs((dtbe+2.*dpbe)*
c		q*ai(i)/shir)*sqrt(te/ti)/bt

	if(abs(shir(i)).lt.1.e-10)shir(i)=1.e-10

	c_an=0.4

	if(ai(i).le.0.5)then 
 	 	havis=0.2/ai(i)
	else
 	 	havis=0.2/ai(i)+(ai(i)-0.5)
	end if

c###	c_an=zhib*havis
	c_an=c_an*havis


        val=abs( shir(i)/( q(i)*ai(i) ) )+eu/100.

	x_e(i)=c_an*( epi_m*(1.+zeff(i))/(rs0*0.01) )**0.5*
c-----     *          abs(( dtbe+2.*dpne)*q(i)*ai(i)/shir(i) )*
     *          abs(dtbe+2.*dpne)/val*
     *   sqrt(tge/tgi)/(bt*0.1)	  

c	print *,' i x_e dtbe dpne q tge',i,x_e(i),dtbe,dpne,q(i),tge

	xig=x_e(i)*10.+dxe(i)/gra2(i)

	xe_av=xe_av+xig

c	xig=dxe(i)/gra2(i)
	end if

c
c  in m2/s
	if(key_t11.eq.1)then

      
	x_e(i)=0.1*x11+3.*x_e(i)
	dxe(i)=x11*gra2(i)+3.*dxe(i)
        else
	x_e(i)=0.1*xig
	dxe(i)=xig*gra2(i)
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
       if(k_ion.eq.1)dxq(i)=dxe(i)
c----->ion h cond is equal to elec +2* neocl.
       if(k_ion.eq.3)dxq(i)=dxe(i)+2.*dxq(i)
c----->ion heat conductivity is equal to 2*electrons
       if(k_ion.eq.2)dxq(i)=2.*dxe(i)
c----->ion heat conductivity is equal to electron heat conductivity
       if(k_ion.eq.4)dxq(i)=dxe(i)

      q_e=q_e+dxe(i)*pg*(te0(i)-te0(i-1))*2.*pi*vi(i)*1.5
      q_ion=q_ion+dxq(i)*pg*(tq0(i)-tq0(i-1))*2.*pi*vi(I)*1.5


c
    1 CONTINUE

	sigk(1)=sigk(2)

	do i=1,n
c	ajb(i)=0.
	end do

	i_boot=0

	if(i_boot.eq.1)then

	open (unit=41,file='j_boot.dat')
	read (41,*)n_boot
	read (41,*)(ajb(i),i=1,n_boot)
	close (41)

c---------------

	tok_bo=0.d0
	do i=1,n
	ajb(i)=10.*ajb(i)*1.d-7
      tok_bo=tok_bo+ajb(i)*spo(i)*ha(i)
	end do

	end if

	apr='sigk'
      if(kpr.eq.1)  print 71,apr,(sigk(i),i=1,n)

	apr='dxq'
      if(kpr.eq.1)  print 71,apr,(dxq(i),i=1,n)

	apr='ajb_s'
      if(kpr.eq.1)print 71,apr,(ajb_s(i),i=1,n)

	apr='ajbn'
      if(kpr.eq.1)print 71,apr,(ajbn(i),i=1,n)

	apr='ajb'
      if(kpr.eq.1)print 71,apr,(ajb(i),i=1,n)
	
	if(kpr.eq.1)print *,' tok_bo===',tok_bo


c	read (*,*)

c       here cold neutals included CALL NETR
c       if(noit.eq.0)
c     * CALL NETR(PNA,TN0,WIE,WCX,TN,PN,PN0,N,KK)
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
c       qe0(i)=qe0(i)-wie(i)
c       qq0(i)=qq0(i)-wcx(i)
	end do
   71 FORMAT(20X,A6/,(6(1pE10.3)))
c   increased heat conductivity
	do i=n-3,n
c       dxe(i)=(1.+ai(i)*1.e2)*dxe(i)
c       dxq(i)=(1.+ai(i)*1.e2)*dxe(i)
	end do
c
	do i=2,n
	   if(ai(i).gt.0.3)then
	      nf=i
	      go to 5
	      end if
	end do
 5      continue

 	if(k_rlw.eq.1)then
	xe_av=xe_av/(n-2.)*0.1
	tay_ee=(eu*0.01)**2/xe_av*1.e3
	if(kpr.eq.1)print *,' xe_av tay_ee==',xe_av,tay_ee
	end if


c
c	x_e(1)=x_e(2)
c	x_i(1)=x_i(2)
c	do i=2,nf
c       x_e(i)=x_e(nf)
c        dxe(i)=x_e(i)*10.*gra2(i)
c	end do
c

	if(kpr.eq.1)print*,'!!!!! ntay=',ntay
	apr='del'
c        print 71,apr,(del(i),i=1,n)
	apr='dxe'
      if(kpr.eq.1)print 71,apr,(dxe(i),i=1,n)
	apr='dxq'
c        print 71,apr,(dxq(i),i=1,n)
	apr='Qe0'
c        print 71,apr,(qe0(i),i=1,n)
	apr='Qq0'
c        print 71,apr,(qq0(i),i=1,n)

        q_e=-q_e/pnor
        q_ion=-q_ion/pnor

c        print *,' q_e q_ion==',q_e,q_ion


      if(kpr.eq.1)print*,'from eni_st'
	apr='Qdh'
c        print 71,apr,(qdh(i),i=1,n)
	apr='Qpe'
c        print 71,apr,(qpe(i),i=1,n)
	apr='Qpq'
c        print 71,apr,(qpq(i),i=1,n)
	apr='Qae'
c        print 71,apr,(qae(i),i=1,n)
	apr='Qaq'
c        print 71,apr,(qaq(i),i=1,n)
	apr='Qde0'
c        print 71,apr,(qde0(i),i=1,n)

        if(kpr.eq.1)print *,' tok_bs tok_b tok_b1 tok_b2 ',tok_bs,tok_b,
     *  tok_b1,tok_b2

	tokbut=tok_bs

        s_av_h=s_av_h/vv
        p_av_h=p_av_h/vv
        p0_av_h=p0_av_h/vv

        if(kpr.eq.1)print *,' i_ech tok_bo ==',
     *  i_ech,tok_bo

c        if(kpr.eq.1)print *,' s_av_h p_av_h p0_av_h ==',
c     *  s_av_h,p_av_h,p0_av_h


	i_deb=0
	if(i_deb.eq.1)then

	if(kpr.eq.1)print*,'!!!!! ntay=',ntay
	apr='del'
c        print 71,apr,(del(i),i=1,n)
	apr='dxe'
c        print 71,apr,(dxe(i),i=1,n)
	apr='dxq'
c        print 71,apr,(dxq(i),i=1,n)
	apr='Qe0'
c        print 71,apr,(qe0(i),i=1,n)
	apr='Qq0'
c        print 71,apr,(qq0(i),i=1,n)

	apr='epi_m'
        if(kpr.eq.1)print 71,apr,(help1(i),i=1,n)
	apr='dt_de'
        if(kpr.eq.1)print 71,apr,(help2(i),i=1,n)
	apr='dn_de'
        if(kpr.eq.1)print 71,apr,(help3(i),i=1,n)
	apr='x_e'
        if(kpr.eq.1)print 71,apr,(x_e(i),i=1,n)
	apr='t_e'
        if(kpr.eq.1)print 71,apr,(te0(i),i=1,n)
	apr='t_i'
        if(kpr.eq.1)print 71,apr,(tq0(i),i=1,n)
	apr='q'
        if(kpr.eq.1)print 71,apr,(q(i),i=1,n)
	apr='po'
        if(kpr.eq.1)print 71,apr,(ai(i),i=1,n)
	apr='zeff'
        if(kpr.eq.1)print 71,apr,(zeff(i),i=1,n)

	apr='shir'
        if(kpr.eq.1)print 71,apr,(shir(i),i=1,n)

        if(kpr.eq.1)print *,' rs0 bt==',rs0*0.01,bt*0.1

        q_e=-q_e/pnor
        q_ion=-q_ion/pnor

c        print *,' q_e q_ion==',q_e,q_ion



      if(kpr.eq.1)print*,'from eni_st'



5000    format (6(1pe14.6))
      open (unit=41,file='hi.dat',form='formatted')
      write (41,*)'x_i_nc [m2/s]	x_e [m2/s]'  
      write(41,*)'tt [ms]=',ttb
      do i=1,n
         write (41,5000)x_i(i),x_e(i)
      end do
      
      close (41)

      end if


	if(i_test.eq.1)stop

      RETURN
      END


      subroutine aux_prof()
	include 'double.inc'
      include 'new_com.inc'

      call aux_prof_c(
     *  pi,n,ai,ha,vi,pow_el,pow_ion,
     *  qde0,qdq0,emoe,emoq,kpr)

      return
      end


      subroutine aux_prof_c(
     *  pi,n,ai,ha,vi,pow_el,pow_ion,
     *  qde0,qdq0,emoe,emoq,kpr)

	include 'double.inc'

      dimension qde0(*),qdq0(*),ai(*),ha(*),vi(*)
      character*20 apr

      if(kpr.eq.1)print *,' n pi pow_el pow_ion',n,pi,pow_el,pow_ion

      i_en=i_en+1

      if(i_en.eq.1)then
         open (unit=41,file='aux_prof.dat',form='formatted')
         read (41,*)
         read (41,*)ro_aux_el,del_aux_el,pow_el
         read (41,*)
         read (41,*)ro_aux_io,del_aux_io,pow_ion
         close (41)
         
       if(kpr.eq.1)print *,' ro_aux_eldel_aux_el',ro_aux_el,del_aux_el
       if(kpr.eq.1)print *,' ro_aux_iodel_aux_io',ro_aux_io,del_aux_io
      if(kpr.eq.1)print *,'  pow_el pow_ion',pow_el,pow_ion

      end if

	apr='vi'
c        print 71,apr,(vi(i),i=1,n)
	apr='ai'
c        print 71,apr,(ai(i),i=1,n)
	apr='ha'
c        print 71,apr,(ha(i),i=1,n)

	apr='qde0'
c        print 71,apr,(qde0(i),i=1,n)
	apr='qdq0'
c        print 71,apr,(qdq0(i),i=1,n)

	summ=0.
	do i=2,n
           qde0(i)=0.
           if(abs(ro_aux_el-ai(i)).le.del_aux_el)then
              qde0(i)=abs(1.-abs(ai(i)-ro_aux_el)/
     *  del_aux_el)**pow_el*2.*pi*
     *  vi(i)*ha(i)
              summ=summ+qde0(i)
           end if
        end do

        sum1=summ
	aemoe=emoe/summ
c
	summ=0.
	do i=2,n
           qdq0(i)=0.
           if(abs(ro_aux_io-ai(i)).le.del_aux_io)then
              qdq0(i)=abs(1.-abs(ai(i)-ro_aux_io)/
     *  del_aux_io)**pow_ion*2.*pi*
     *  vi(i)*ha(i)
              summ=summ+qdq0(i)
           end if
	end do

        sum2=summ
	aemoq=emoq/summ

        PNOR=6.25E8
        e_tot=(emoe+emoq)/pnor
        if(kpr.eq.1)print *,' emoe emoq e_tot',emoe/pnor,emoq/pnor,e_tot
        if(kpr.eq.1)print *,' aemoe aemoq ',aemoe,aemoq
c        read (*,*)
c
        p_aux=0.
	do i=2,n

         qde0(i)=qde0(i)/(2.*pi*vi(i)*ha(i))
         qdq0(i)=qdq0(i)/(2.*pi*vi(i)*ha(i))

         QDE0(I)=aEMOE*qde0(i)

         QDQ0(I)=aEMOQ*qdq0(i)

         p_aux=p_aux+(qde0(i)+qdq0(i))*2.*pi*vi(i)*ha(i)


	end do
        p_aux1=aemoe*sum1/pnor
        p_aux2=aemoq*sum2/pnor

      if(kpr.eq.1)print *,'P_AUX=p_aux1 p_aux2',p_aux/pnor,p_aux1,p_aux2

        if(i_en.eq.1)then

	apr='qde0'
        if(kpr.eq.1)print 71,apr,(qde0(i),i=1,n)
	apr='qdq0'
        if(kpr.eq.1)print 71,apr,(qdq0(i),i=1,n)

        end if

   71 FORMAT(20X,A6/,(6(1pE10.3)))

        return
        end

      subroutine aux_prof_o()
	include 'double.inc'
      include 'new_com.inc'

      call aux_prof_o_c(
     *  pi,n,ai,ha,vi,pow_el,pow_ion,
     *  qde0,qdq0,emoe,emoq)

      return
      end


      subroutine aux_prof_o_c(
     *  pi,n,ai,ha,vi,pow_el,pow_ion,
     *  qde0,qdq0,emoe,emoq)

	include 'double.inc'

      dimension qde0(*),qdq0(*),ai(*),ha(*),vi(*)
      character*20 apr

      if(kpr.eq.1)print *,' n pi pow_el pow_ion',n,pi,pow_el,pow_ion

      i_en=i_en+1

      if(i_en.eq.1)then
         open (unit=41,file='aux_prof.dat',form='formatted')
         read (41,*)
         read (41,*)ro_aux_el,del_aux_el
         read (41,*)
         read (41,*)ro_aux_io,del_aux_io
         close (41)
         
      if(kpr.eq.1)print *,' ro_aux_el  del_aux_el',ro_aux_el,del_aux_el
      if(kpr.eq.1)print *,' ro_aux_io  del_aux_io',ro_aux_io,del_aux_io

      end if

	apr='vi'
c        print 71,apr,(vi(i),i=1,n)
	apr='ai'
c        print 71,apr,(ai(i),i=1,n)
	apr='ha'
c        print 71,apr,(ha(i),i=1,n)

	apr='qde0'
c        print 71,apr,(qde0(i),i=1,n)
	apr='qdq0'
c        print 71,apr,(qdq0(i),i=1,n)

	summ=0.
	do i=2,n
           qde0(i)=0.
           if(abs(ro_aux_el-ai(i)).le.del_aux_el)then
c I changed              qde0(i)=abs(1.-abs(ai(i)-ro_aux_el))**pow_el*2.*pi*
              qde0(i)=abs(1.-(ai(i)/ai(n))**2)**pow_el*2.*pi*
     *  vi(i)*ha(i)
              summ=summ+qde0(i)
           end if
           end do

        sum1=summ
	aemoe=emoe/summ
c
	summ=0.
	do i=2,n
           qdq0(i)=0.
           if(abs(ro_aux_io-ai(i)).le.del_aux_io)then
c I changed              qdq0(i)=abs(1.-abs(ai(i)-ro_aux_io))**pow_ion*2.*pi*
              qdq0(i)=abs(1.-(ai(i)/ai(n))**2)**pow_ion*2.*pi*
     *  vi(i)*ha(i)
              summ=summ+qdq0(i)
           end if
	end do

        sum2=summ
	aemoq=emoq/summ

        PNOR=6.25E8
        e_tot=(emoe+emoq)/pnor
        if(kpr.eq.1)print *,' emoe emoq e_tot',emoe/pnor,emoq/pnor,e_tot
        if(kpr.eq.1)print *,' aemoe aemoq ',aemoe,aemoq
c        read (*,*)
c
        p_aux=0.
	do i=2,n

         qde0(i)=qde0(i)/(2.*pi*vi(i)*ha(i))
         qdq0(i)=qdq0(i)/(2.*pi*vi(i)*ha(i))

         QDE0(I)=aEMOE*qde0(i)

         QDQ0(I)=aEMOQ*qdq0(i)

         p_aux=p_aux+(qde0(i)+qdq0(i))*2.*pi*vi(i)*ha(i)


	end do
        p_aux1=aemoe*sum1/pnor
        p_aux2=aemoq*sum2/pnor

      if(kpr.eq.1)print *,'P_AUX=p_aux1 p_aux2',p_aux/pnor,p_aux1,p_aux2

        if(i_en.eq.1)then

	apr='qde0'
        if(kpr.eq.1)print 71,apr,(qde0(i),i=1,n)
	apr='qdq0'
        if(kpr.eq.1)print 71,apr,(qdq0(i),i=1,n)

        end if

   71 FORMAT(20X,A6/,(6(1pE10.3)))

        return
        end



      subroutine ech_heat()
	include 'double.inc'
      include 'new_com.inc'

      call ech_heat_c(n,
     *  qde0,sb_ech,kpr)

      return
      end


      subroutine ech_heat_c(n,
     *  qde0,sb_ech,kpr)
	include 'double.inc'

      dimension qde0(*),sb_ech(*)

      character*20 apr

      do i=2,n
         qde0(i)=qde0(i)+sb_ech(i)
      end do

      apr='sb_ech'
c      if(kpr.eq.1)print 71,apr,(sb_ech(i),i=1,n)

      apr='qde0'
c      if(kpr.eq.1)print 71,apr,(qde0(i),i=1,n)

   71 FORMAT(20X,A6/,(6(1pE10.3)))
      
      return
      end
      subroutine ech_heat3()
	include 'double.inc'
      include 'new_com.inc'

      call ech_heat3_c(n,
     *  qde0,sb_ech3)

      return
      end


      subroutine ech_heat3_c(n,
     *  qde0,sb_ech3)
	include 'double.inc'

      dimension qde0(*),sb_ech3(*)

      character*20 apr

      do i=2,n
         qde0(i)=qde0(i)+sb_ech3(i)
      end do

      apr='sb_ech3'
c      if(kpr.eq.1)print 71,apr,(sb_ech3(i),i=1,n)

      apr='qde0'
c      if(kpr.eq.1)print 71,apr,(qde0(i),i=1,n)

   71 FORMAT(20X,A6/,(6(1pE10.3)))
      
      return
      end
      subroutine lh_heat()
	include 'double.inc'
      include 'new_com.inc'

      call lh_heat_c(n,
     *  qde0,sb_lh,kpr)

      return
      end


      subroutine lh_heat_c(n,
     *  qde0,sb_lh,kpr)
	include 'double.inc'

      dimension qde0(*),sb_lh(*)

      character*20 apr

      do i=2,n
         qde0(i)=qde0(i)+sb_lh(i)
      end do

      apr='sb_lh'
c      if(kpr.eq.1)print 71,apr,(sb_lh(i),i=1,n)

      apr='qde0'
c      if(kpr.eq.1)print 71,apr,(qde0(i),i=1,n)

   71 FORMAT(20X,A6/,(6(1pE10.3)))
      
      return
      end


      subroutine ech1_heat()
	include 'double.inc'
      include 'new_com.inc'

      call ech1_heat_c(n,
     *  qde0,sb_ech1)

      return
      end


      subroutine ech1_heat_c(n,
     *  qde0,sb_ech1)
	include 'double.inc'

      dimension qde0(*),sb_ech1(*)

      character*20 apr

      do i=2,n
         qde0(i)=qde0(i)+sb_ech1(i)
      end do

      apr='sb_ech1'
c      if(kpr.eq.1)print 71,apr,(sb_ech1(i),i=1,n)

      apr='qde0'
c      print 71,apr,(qde0(i),i=1,n)

   71 FORMAT(20X,A6/,(6(1pE10.3)))
      
      return
      end
      subroutine ech2_heat()
	include 'double.inc'
      include 'new_com.inc'

      call ech2_heat_c(n,
     *  qde0,sb_ech2)

      return
      end


      subroutine ech2_heat_c(n,
     *  qde0,sb_ech2)
	include 'double.inc'

      dimension qde0(*),sb_ech2(*)

      character*20 apr

      do i=2,n
         qde0(i)=qde0(i)+sb_ech2(i)
      end do

      apr='sb_ech2'
c      if(kpr.eq.1)print 71,apr,(sb_ech2(i),i=1,n)

      apr='qde0'
c      print 71,apr,(qde0(i),i=1,n)

   71 FORMAT(20X,A6/,(6(1pE10.3)))
      
      return
      end

      subroutine imp_rad()
	include 'double.inc'
      include 'new_com.inc'

      call imp_rad_c(n,
     *  te0,qpr,pow_imp,vi,a,ha,pi,ptot,wel,wio,pne,coef_prim)

      return
      end


      subroutine imp_rad_c(n,
     *  te0,qpr,pow_imp,vi,a,ha,pi,ptot,wel,wio,pne,coef_prim)
	include 'double.inc'

      dimension te0(*),qpr(*),vi(*),a(*),ha(*),pne(*)
      
      character*20 apr
      
	al(Y)=Y
	
      

c	pow_imp=ptot*2.

	pow_imp=0.
	coef=1.
	ww=wel+wio
ccc	if((wel+wio).gt.95.)pow_imp=wel+wio-85.*coef

c	gam=3.
	
c      q_pr=0.
c      do i=2,n

c         qpr(i)=1./exp(1.-a(i))

c         if(a(i).ge.0.9)qpr(i)=(a(i)**gam-0.9**gam)/(1.-0.9**gam)
c	qpr(i)=1.

c	 q_pr=q_pr+qpr(i)*2.*pi*vi(i)*ha(i)
c      end do

c      al1=pow_imp/q_pr

        PNOR=6.25E8


c*** Simulation of Cooling_rate by N_impurity in MW/cm3
c*** N_impurity is expected N_imp=Ne*0.2
c*** al*10**(-7)*Ne*10**13*N_imp*10**13*10**(-6) >>>>> MW/cm3

c*** Simulation of Cooling_rate by N_impurity in MW/cm3
c*** N_impurity is expected N_imp=Ne*0.2
c*** al*10**(-7)*Ne*10**13*N_imp*10**13*10**(-6) >>>>> MW/cm3

	coef_prim=0.
	if(ww.gt.95..and.k_pr.eq.0)then
	tt_0=tt
	k_pr=1
	end if

	if(k_pr.eq.1)then
	coef_prim0=coef_prim
	coef_prim=(0.05*((ww-95.)/100.)+coef_prim0)/2.
	if(coef_prim.lt.0.)coef_prim=0.

	end if

	do i=2,n
	p_prim=pne(i)*coef_prim
	te=te0(i)/1.e3
	al2=al(te)
	qpr(i)=al(te)*pne(i)*p_prim*1.e13*pnor
c        print *,' i te pne qpr al2',i,te,pne(i),qpr(i),al2
	end do		

c*** qpr is in our units

	q_pr=0.
      do i=2,n
ccccc         qpr(i)=qpr(i)*al1*pnor
	 q_pr=q_pr+qpr(i)*2.*pi*vi(i)*ha(i)/pnor
      end do

c*** Now q_pr in MW

      apr='te0'
c      print 71,apr,(te0(i),i=1,n)
      apr='pne'
c      print 71,apr,(pne(i),i=1,n)



      if(kpr.eq.1)print *,' ptot q_pr pow_imp ==',ptot,q_pr,pow_imp
      if(kpr.eq.1)print *,'wel wio ww==',wel,wio,ww
      if(kpr.eq.1)print*,'q_pr=',q_pr
c      pause 'from imp_rad'

      apr='qpr'
c      print 71,apr,(qpr(i),i=1,n)

   71 FORMAT(20X,A6/,(6(1pE10.3)))
      
      return
      end

c***********************************
	function al(te)
	include 'double.inc'

	dimension a1(6),a2(6),a3(6),a4(6),a(4,6)
	data a1 /-2.053043e01, -2.834287e0, 1.506902e01,
     *            3.517177e01, 2.400122e01, 5.072723e0/

	data a2 /-1.965204e01, -1.172763e-01, 7.83322e0,
     *           -6.351577e0, -3.058849e01, -1.528534e01/

	data a3 /-1.974883e01, 2.964839e0, -8.829391e0,
     *            9.791004e0, -4.960018e0, 9.820032e-01/

	data a4 /-2.117935e01, 5.191481e0, -7.439717e0,
     *            4.969023e0, -1.55318e0, 1.877047e-01/

	i_en=i_en+1
	if(i_en.eq.1)then
		do i=1,4
		   do j=1,6
		      if(i.eq.1)a(i,j)=a1(j)	
		      if(i.eq.2)a(i,j)=a2(j)	
		      if(i.eq.3)a(i,j)=a3(j)	
		      if(i.eq.4)a(i,j)=a4(j)
		   end do
		end do
	end if


	if(te.lt.0.05)then
           al=0.
           return
        end if


c*** Here Te must be in keV

	if(te.ge.0.03.and.te.lt.0.2)i=1
	if(te.ge.0.2.and.te.lt.2.)i=2
	if(te.ge.2..and.te.lt.20.)i=3
	if(te.ge.20.)i=4

	x=dlog10(te)

	al=a(i,1)+x*(a(i,2)+x*(a(i,3)+x*(a(i,4)+x*(a(i,5)+x*a(i,6)))))

	al=10.**al

	return
	end
	
      SUBROUTINE BSCOEFF(pft,pq,pR,peps,pte,pne,pti,pni,pzeff,pzion, 
     * pl31,pl32,pl34,palfa,signeo)

	include 'double.inc'

c     * pl31_0,pl32_0,palfa_0,pl31,pl32,pl34,palfa)
!
!     WARNING: in MKSA
!
!     Compute Bootstrap coefficients using formulas from 
! O. Sauter et al, Phys. Plasmas 7 (1999) 2834.
!
!     Assumes to compute on a single flux surface with:
! Inputs:
!     pft   : trapped fraction
!     pq    : safety factor
!     pR    : Geometrical center of given flux surface in [m]
!     peps  : Inverse aspect ratio of given flux surface
!     pte   : Electron temperature [eV]
!     pne   : Electron density [1/m**3]*1.e-19
!     pti   : Ion temperature [eV]
!     pni   : Main ion density [1/m**3]*1.e-19
!     pzeff : Effective charge (used for Z in electronic terms)
!     pzion : Main ion charge
! Outputs:

!     pl31_0  : L31 coefficient assuming nuestar=0
!     pl32_0  : L32 coefficient assuming nuestar=0
!     palfa_0 : Alfa coefficient assuming nuestar=0

!     pl31    : L31 coefficient
!     pl32    : L32 coefficient
!     pl34    : L34 coefficient (L34 for nuestar=0 is identical to L31_0)
!     palfa   : Alfa coefficient
!
!


      include 'double_eni_ae1.inc'

!-----------------------------------------------------------------------
!     
!     basic parameters
!
      zlnlam_e = 17.
      IF (pne.gt.0. .AND. pte.gt.0.) THEN
         zlnlam_e = 31.3 - dlog(sqrt(1.e19*pne)/pte)
      ENDIF

      zlnlam_i = 17.
      IF (pni.gt.0. .AND. pti.gt.0.) THEN
         zlnlam_i = 30. - dlog(pzion**3.*sqrt(1.e19*pni)/
     *  ABS(pti)**1.5)
      ENDIF

c      print *,' zlnlam_e zlnlam_i=',zlnlam_e,zlnlam_i

      znuestar = 6.921E+1 * pq*pR*pne*pzeff*zlnlam_e 
     */ (pte*pte*peps**1.5)
      
c      print *,' znuestar pq pr pne pzeff ',znuestar,pq,pr,pne,pzeff
c      print *,' pte peps',pte,peps

      znuistar = 4.900E+1 * pq*pR*pni*pzion**4*zlnlam_i 
     */ (pti*pti*peps**1.5)

c      print *,' znuestar=',znuestar
c      print *,' znuistar=',znuistar


!     finite nustar
      call neobscoeff(pl31,pl32,pl34,palfa,pft,pzeff,znuestar,znuistar)

      call sigmaneo(signeo,sigsptz,znuestar,pft,pne,pte,pzeff,
     * pq,pR,peps)

c      print *,' signeo sigsptz =',signeo,sigsptz

     

!
      return
      end


!
!      MODULE neobscoeffmod
!
! Compute neoclassical bootstrap current coefficients for given 
! collisionalities using formula in Ref.1:
!             O. Sauter et al, Phys. Plasmas 6 (1999) 2834.
! Inputs:
!    ft: trapped fraction ft (Note, one can use formula in 
! YR Lin-Liu et al, Phys. Plasmas 2 (1995) 1666.)
! Optionals:
!    Zeff : effective charge (default = 2. if omitted)
!    nuestar : local electron collisionality (Eq. 18b of Ref. 1 
! or 0. for comparison) (0. if omitted)
!    nuistar : local ion collisionality (Eq. 18c of Ref. 1 or 0. 
! for comparison) (0. if omitted)
!    Nin : number of input values (if not given assumes dim. of input 
! arrays for vectors or 1 for scalars)
!
! Outputs:
!    L31, L32, L34, alfa : as defined in Ref.1, Eqs. (14-17)
!
! examples of calls:
!
! call neobscoeff(L31, L32, L34, alfa, ft, Zeff)
! call neobscoeff(L31, L32, L34, alfa, ft, Zeff, nuestar, nuistar)
! call neobscoeff(L31, L32, L34, alfa, ft, Zeff, Nin)
! call neobscoeff(L31, L32, L34, alfa, ft, NUESTAR=nuestar,NIN=Nin)
!
! To use this module in a routine, include the follwing statement 
! at the beginning of the routine:
! USE neobscoeffmod
!
      

      SUBROUTINE neobscoeff(L31, L32, L34, ALFA, ft, 
     *  Zeff, nuestar, nuistar)
	include 'double.inc'


! CASE: all are scalar input variables (nin not used)
!       Note: if called with arg as ft(i), it is a scalar 
! and goes through this routine


      include 'double_eni_ae2.inc'
!

      ZZ = zeff
      znuestar = nuestar
      znuistar = nuistar

c      print *,' ft zz znuestar znuistar',ft,zz,znuestar,znuistar
!
      zsqnuest = sqrt(znuestar)
!
!  effective trapped fractions
!
      zsqnuest = sqrt(znuestar)

      zft31eff = ft / (1.+(1.-0.1*ft)*zsqnuest 
     * + 0.5*(1.-ft)*znuestar/ZZ)

      zft32ee_eff = ft / (1. + 0.26*(1.-ft)*zsqnuest 
     * + 0.18*(1.-0.37*ft)*znuestar/sqrt(ZZ))

      zft32ei_eff = ft / (1. + (1.+0.6*ft)*zsqnuest 
     * + 0.85*(1.-0.37*ft)*znuestar*(1.+ZZ))

      zft34eff = ft / (1.+(1.-0.1*ft)*zsqnuest 
     * + 0.5*(1.-0.5*ft)*znuestar/ZZ)

      zalfa0 = - 1.17*(1.-ft) / (1.-0.22*ft-0.19*ft**2)
!
!coefficients
!
      zeffp1 = ZZ+1.

      L31 = zft31eff * ( (1.+1.4/zeffp1) 
     * - zft31eff* (1.9/zeffp1 - zft31eff * (0.3/zeffp1 + 
     * 0.2/zeffp1 * zft31eff)))

c      print *,' l31 zft31eff zeffp1',l31,zft31eff,zeffp1

      L32 = (0.05+0.62*ZZ)/ZZ/(1.+0.44*ZZ)*(zft32ee_eff-
     *  zft32ee_eff**4) 
     * +  zft32ee_eff**2*(1.-1.2*zft32ee_eff+0.2*zft32ee_eff**2) 
     * /(1.+0.22*ZZ) 
     * - (0.56+1.93*ZZ)/ZZ/(1.+0.44*ZZ)*(zft32ei_eff-zft32ei_eff**4) 
     * +  zft32ei_eff**2*(1.-0.55*zft32ei_eff-0.45*zft32ei_eff**2) 
     * * 4.95/(1.+2.48*ZZ)

c  This lines were added in June 2003 in CRPP by RRK

     * + 1.2/ (1.+0.5*ZZ) * (zft32ee_eff**4-zft32ei_eff**4)


      L34 = zft34eff * ( (1.+1.4/zeffp1) 
     *  - zft34eff* (1.9/zeffp1 - zft34eff * (0.3/zeffp1 + 
     *  0.2/zeffp1 * zft34eff)))

      zsqnui = sqrt(znuistar)

      znui2ft6 = znuistar**2 * ft**6

      ALFA = ((zalfa0 + 0.25*(1.-ft**2)*zsqnui) 
     * / (1.+0.5*zsqnui) - 0.315*znui2ft6) 
     * / (1. + 0.15*znui2ft6)
!
      return
      END 

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  ! MODULE sigmaneomod
  !
  ! Compute neoclassical conductivity using formula in Ref.1: 
  !O. Sauter et al, Phys. Plasmas 6 (1999) 2834.
  !
  ! Outputs:
  !    signeo : neoclassical conductivity at each value of the input parameters
  !    sigsptz: Spitzer conductivity
  !    nuestar: electron collisionality (default set to 0.01 if q, R, eps 
  !not given)
  !
  ! Inputs:
  !  Required:
  !    ft()   : trapped fraction (Note, can use formula in 
  ! Lin-Liu et al, Phys. Plasmas 2 (1995) 1666.)
  !    ne()   : local electron density
  !    Te()   : Local electron temperature
  !  Optionals:
  !    Zeff() : effective charge (default is 2.)
  !    q()    : Local safety factor (if q, R or eps is not given, 
  ! nuestar set to 0.01)
  !    R()    : geometrical center of local flux surface (si q for def)
  !    eps()  : local inverse aspect ratio (a/R) (si q for def)
  !    Nin    : number of input values (default to size(ft) if 
  ! args are arrays but nin omitted)
  !
  ! Note: q, R and eps are used to compute nue* according to 
  !Eqs.(18b and 18d) of Ref.1
  !
  ! examples of calls:
  !
  ! call sigmaneo(signeo,sigsptz,nuestar,ft,ne,te) 
  ! (defaults : zeff=1.5, nuestar=0.01)
  ! call sigmaneo(signeo,sigsptz,nuestar,ft,ne,te,zeff) 
  ! (default for nuestar=0.01)
  ! call sigmaneo(signeo,sigsptz,nuestar,ft,ne,te,zeff,q,R,eps)
  ! call sigmaneo(signeo,sigsptz,nuestar,ft,ne,te,NIN=nin) 
  ! (defaults : zeff=1.5, nuestar=0.01)
  !
  !
      SUBROUTINE sigmaneo(signeo,sigsptz,nuestar,ft,ne,te,zeff,q,R,eps)
	include 'double.inc'

    ! CASE: all are scalar input variables (or ft(i) in argument, 
    !as is interpreted as scalar)
    ! te in [eV], ne in [m**-3], R in [m]

      include 'double_eni_ae3.inc'
!
      z_zeff = 2.0
      z_zeff = zeff
!
      zNZ = 0.58 + 0.74 / (0.76 + z_zeff)
      zlnL = 17.

      IF (ne.gt.0. .and. te.gt.0.) THEN
         zlnL = 31.3 - dlog(sqrt(1.e19*ne)/te)
      ENDIF

      sigsptz = 1.9012E+04 * ABS(te)**1.5 / (z_zeff * zNZ * zlnL)
!

      nuestar = 6.921E+1 * q * R * ne * z_zeff * zlnL / 
     * (te*te * eps**1.5)

!

      zft33eff = ft / 
     * (1.+(0.55-0.1*ft)*sqrt(nuestar) 
     * + 0.45*(1.-ft)*nuestar/z_zeff**1.5)

c      signeo = sigsptz * (1. - zft33eff*(1.+0.36/z_zeff 
c     * - zft33eff*(0.59/z_zeff - 0.23/z_zeff*zft33eff)))

c______ Popravka neoklassicheskay

      signeo = 1. * (1. - zft33eff*(1.+0.36/z_zeff 
     * - zft33eff*(0.59/z_zeff - 0.23/z_zeff*zft33eff))) /z_zeff
!
      return
      END 





	subroutine inter_axis(f,ai,n_n,teta,val) 
	include 'double.inc'
	dimension f(*),ai(*)                                                  

	c=ai(3)*ai(3)/(ai(2)*ai(2)) 
	val=(f(3)-f(2)*c)/(1.d0-c)
	                                              
	return                                                                 
	end                                                                    
	subroutine inter_h1(f,aii,n,teta,val)
       implicit real*8 (a-h,o-z)
	dimension f(n),aii(n)
	include 'parf0'
	dimension aak(npo),bbk(npo),cck(npo)
	real *8 ai(npo),delt
	i=n-1
	ai(i-1)=aii(i-1)
	ai(i)=aii(i)
	ai(i+1)=aii(i+1)
c       print *,'i n npo',i,n,npo
c       print*,'ai(i-1) ai(i) ai(i+1)',ai(i-1),ai(i),ai(i+1)
	delt=ai(i+1)**2*ai(i)+ai(i)**2*ai(i-1)+
     *  ai(i-1)**2*ai(i+1)-
     *  ai(i-1)**2*ai(i)-ai(i)**2*ai(i+1)-ai(i+1)**2*ai(i-1)
c
c       if(abs(delt).lt.1.e-7)then
c       print*,'delt=',delt
c       print*,'ai(i-1) ai(i) ai(i+1)',ai(i-1),ai(i),ai(i+1)
c       print*,'?????????????????????????????????????'
c
	aak(i)=(f(i+1)*ai(i)+f(i)*ai(i-1)+f(i-1)*ai(i+1)-
     *  f(i-1)*ai(i)-f(i)*ai(i+1)-f(i+1)*ai(i-1))/delt
	bbk(i)=(ai(i+1)**2*f(i)+ai(i)**2*f(i-1)+ai(i-1)**2
     *  *f(i+1)-
     *  ai(i-1)**2*f(i)-ai(i)**2*f(i+1)-ai(i+1)**2
     *  *f(i-1))/delt
	cck(i)=f(i)-aak(i)*ai(i)**2-bbk(i)*ai(i)
c        val=aak(i)*teta*teta+bbk(i)*teta+cck(I)
	val=2.*aak(i)*teta+bbk(i)
	return
	end
	subroutine inter_h0(f,aii,n,teta,val)
       implicit real*8 (a-h,o-z)
	dimension f(n),aii(n)
	include 'parf0'
	dimension aak(npo),bbk(npo),cck(npo)
	real *8 ai(npo),delt
	i=n-1
	ai(i-1)=aii(i-1)
	ai(i)=aii(i)
	ai(i+1)=aii(i+1)
c       print *,'i n npo',i,n,npo
c       print*,'ai(i-1) ai(i) ai(i+1)',ai(i-1),ai(i),ai(i+1)
	delt=ai(i+1)**2*ai(i)+ai(i)**2*ai(i-1)+
     *  ai(i-1)**2*ai(i+1)-
     *  ai(i-1)**2*ai(i)-ai(i)**2*ai(i+1)-ai(i+1)**2*ai(i-1)
c
c       if(abs(delt).lt.1.e-7)then
c       print*,'delt=',delt
c       print*,'ai(i-1) ai(i) ai(i+1)',ai(i-1),ai(i),ai(i+1)
c       print*,'?????????????????????????????????????'
c
	aak(i)=(f(i+1)*ai(i)+f(i)*ai(i-1)+f(i-1)*ai(i+1)-
     *  f(i-1)*ai(i)-f(i)*ai(i+1)-f(i+1)*ai(i-1))/delt
	bbk(i)=(ai(i+1)**2*f(i)+ai(i)**2*f(i-1)+ai(i-1)**2
     *  *f(i+1)-
     *  ai(i-1)**2*f(i)-ai(i)**2*f(i+1)-ai(i+1)**2
     *  *f(i-1))/delt
	cck(i)=f(i)-aak(i)*ai(i)**2-bbk(i)*ai(i)
	val=aak(i)*teta*teta+bbk(i)*teta+cck(I)
c        val=2.*aak(i)*teta+bbk(i)
	return
	end
      subroutine fit(k,x1,x2,x3,x4,y1,y2,y3,y4,x,y,yp)
       implicit real *8 (a-h,o-z)
c --------------------------------------------
c set k=1 to find y,yp and k=2 to find x,yp
c --------------------------------------------
      iturn=0
      c1=y1/((x1-x2)*(x1-x3)*(x1-x4))
      c2=y2/((x2-x1)*(x2-x3)*(x2-x4))
      c3=y3/((x3-x1)*(x3-x2)*(x3-x4))
      c4=y4/((x4-x1)*(x4-x2)*(x4-x3))
      if(k.eq.2) go to 2
	iter=0
   1  continue
	iter=iter+1
	if(iter.gt.100000)then
	print *,'iterations to much',iter
	stop
	end if
c
      d1=x-x1
      d2=x-x2
      d3=x-x3
      d4=x-x4
      d12=d1*d2
      d13=d1*d3
      d14=d1*d4
      d23=d2*d3
      d24=d2*d4
      d34=d3*d4
      f=(c1*d23+c2*d13+c3*d12)*d4+c4*d12*d3
      yp=c1*(d23+d24+d34)+c2*(d13+d14+d34)
     +  +c3*(d12+d14+d24)+c4*(d12+d13+d23)
      if(k.eq.2) go to 3
      y=f
      return
    2 if(y.ge.dmin1(y1,y2,y3,y4).and.y.le.dmax1(y1,y2,y3,y4)) go to 4
   21 continue
      write(59,11)x1,x2,x3,x4,y1,y2,y3,y4,y
      x=0.
      write(59,500)
  500 format('error in sub fit at label 21')
c      call abort(4hfit1,8)
      return
  11  format(' fit',9e14.5)
   4  crit=(abs(y1)+abs(y2)+abs(y3)+abs(y4))*1.e-05
      i=0
      xa=x1
      xb=x2
      ya=y1
      yb=y2
      if((x-xa)*(x-xb).lt.0.) go to 10
      xa=x2
      xb=x3
      ya=y2
      yb=y3
      if((x-xa)*(x-xb).lt.0.) go to 10
      xa=x3
      xb=x4
      ya=y3
      yb=y4
      if((x-xa)*(x-xb).lt.0.) go to 10
  12  xa=x2
      ya=y2
      xb=x3
      yb=y3
      x=(xa+xb)/2.
      if((y-ya)*(y-yb).lt.0.) go to 1
      xa=x1
      ya=y1
      xb=x2
      yb=y2
      x=(xa+xb)/2.
      if((y-ya)*(y-yb).lt.0.) go to 1
      xa=x3
      ya=y3
      xb=x4
      yb=y4
      x=(xa+xb)/2.
      if((y-ya)*(y-yb).lt.0.) go to 1
      if(y.ne.y1) go to 13
      x=x1
      go to 1
   13 if(y.ne.y2) go to 14
      x=x2
      go to 1
   14 if(y.ne.y3) go to 15
      x=x3
      go to 1
   15 if(y.ne.y4) go to 16
      x=x4
      go to 1
   16 continue
      write(59,11)x,y
      go to 21
3     if(abs(f-y).lt.crit) iturn=1
      if(i.eq.1) go to 7
      dydx=(yb-ya)/(xb-xa)
      if(abs(yp-dydx).lt..2*abs(yp)) go to 7
      if((f-y)*(ya-y).lt.0.) go to 5
      xa=x
      ya=f
      go to 6
   5  xb=x
      yb=f
   6  x=(xa+xb)/2.
      i=1
      go to 1
    7 if((f-y)*(ya-y).lt.0.) go to 8
      xa=x
      ya=f
      go to 9
   8  xb=x
      yb=f
   9  dydx=(yb-ya)/(xb-xa)
      if(abs(yp-dydx).lt..2*abs(yp))dydx=yp
      x=x-(f-y)/dydx
      if(iturn.eq.1) return
      i=0
      go to 1
   10 if((y-ya)*(y-yb).lt.0.) go to 1
      go to 12
      end
      subroutine cubic(p1,p2,p3,p4,p,a,b,c,d)
       implicit real *8 (a-h,o-z)
      data  zero/1.e-6/
      p1p2=p1-p2
      k12=sign(1.5d0,p1p2)
      if(abs(p1p2).lt.zero) go to 1
      p2p3=p2-p3
      k23=sign(1.5d0,p2p3)
      if(abs(p2p3).lt.zero) go to 2
      p1p3=p1-p3
      if(abs(p1p3).lt.zero) go to 1
      p1p4=p1-p4
      if (abs(p1p4).lt.zero) go to 3
      p2p4=p2-p4
      if (abs(p2p4).lt.zero) go to 4
      p3p4=p3-p4
      k34=sign(1.5d0,p3p4)
      if(abs(p3p4).lt.zero) go to 4
      if (iabs(k12+k23+k34).eq.3)  go to 5
      if (iabs(k23+k34).eq.2) go to 1
      if (iabs(k12+k23).eq.2) go to 4
5     pp1=p-p1
      pp2=p-p2
      pp3=p-p3
      pp4=p-p4
      a=pp2*pp3*pp4/(p1p2*p1p3*p1p4)
      b=-pp1*pp3*pp4/(p1p2*p2p3*p2p4)
      c=pp1*pp2*pp4/(p1p3*p2p3*p3p4)
      d=-pp1*pp2*pp3/(p1p4*p2p4*p3p4)
      return
1     a=0.
c      call parab(p2,p3,p4,p,b,c,d)
      return
2     a=0.
      b=1.
      c=0.
      d=0.
      return
3     if (iabs(k12+k23).eq.2) go to 4
      go to 1
4     d=0.
c      call parab(p1,p2,p3,p,a,b,c)
      return
      end

 	subroutine linear(n,PSI,aval,x,xp)
	implicit real*8 (a-h,o-z)

	dimension  psi(n),x(n)
c
	n1=n-1
c
	do i=1,n1
	if( (xp-x(i+1))*(xp-x(i)).gt.0.d0)go to 11
c
	aval=psi(i)+(xp-x(i))*(psi(i+1)-psi(i))/(x(i+1)-x(i))

11	continue
	end do
	return
	end









