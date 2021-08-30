      SUBROUTINE TP(N)
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
     *  /en33/anom_e,anom_i,key_t11,kcchp
c
	common
     *  /ge2/NTAY,TAY,TTB
     *  /ge3/AI(npo),A0(npo),HA2(npo),a1(npo),ha(npo)
     *  /ge4/EPS1,EPS2,EPS0
     *  /ge5/kpr
	common
     *  /dfm3/dfmax(npo),dfmax0(npo)
     	character*30 apr


	ntran=0
      N2=N-1
      ALFA=1.
	i=2
	dh1(i)=2.*ha(i)/(2.*ha(i)+ha(i+1))
	dh2(i)=ha(i+1)/(2.*ha(i)+ha(i+1))
	do i=3,n2
	dh1(i)=ha(i)/(ha(i)+ha(i+1))
	dh2(i)=ha(i+1)/(ha(i)+ha(i+1))
	end do
      DO 1 I=2,N
	aiu(i)=ai(i)
	vu(i)=vi(i)
	gg(i)=vi(i)
      fz(I)=1.
       VG(I)=0.
       HG(I)=0.
      TETA(I)=1./HA2(I)
    1 CONTINUE
	vu(2)=0.
	aiu(2)=0.
	gg(2)=0.
      IF(NTAY.EQ.0)GO TO 99
      NN=0
      DO 51 I=2,N2
   51 VI1(I)=Vu(I)*dh2(i)+Vu(I+1)*dh1(i)
	VI1(N)=2.*VI1(N2)-Vu(N)
    2 CONTINUE
        CALL OITER(N)
        CALL FITER(N)
        
           apr=' -- sd0 '
           print 71,apr,(sd0(i),i=1,n)
           apr=' -- st0 '
           print 71,apr,(st0(i),i=1,n)
           
c--------------------------------------------
        kd2=0
        df=0.
	fmax=dfmax(n)
	fmax0=sqrt(dfmax0(n))
	FMAX1=sqrt(FMAX)
	if(ntay.gt.2)then
	kd2=2
	df=-(fmax1-fmax0)/(fmax1*tay)
	end if
c--------------
c	if(kcchp.eq.1)kd2=0
c------------
c----------------------------------------
      DO 3 I=2,N
    3 UG(I)=(VD(I)+0.5*kd2*aiu(i)*df)*Vu(I)
      ALFA=1.
      BETA=1.
c
      DO I=3,N2
      A(I)=-UG(I)/(2.*ha2(i))*beta*(dh1(i)+dh2(i))
      b(I)=(ug(i+1)-UG(I))/(2.*ha2(i))*beta*(dh1(i)+dh2(i))
      c(I)=UG(I+1)/(2.*ha2(i))*beta*(dh1(i)+dh2(i))
      B(I)=B(I)+ ALFA*(dh2(i)*fz(I)*GG(I)+dh1(i)*fz(I+1)*
     *GG(I+1))/TAY
c
	a(i)=a(i)-hg(i-1)/ha(i)*vg(i)*dh2(i)
	c(i)=c(i)+hg(i+1)/ha(i+1)*vg(i+1)*dh1(i)
	b(i)=b(i)+hg(i)/ha(i)*vg(i)*dh2(i)-hg(i)/
     *ha(i+1)*vg(i+1)*dh1(i)
c
	end do
      A(2)=0.
	i=2
      b(I)=ug(i+1)/(2.*ha2(i))*beta*(dh1(i)+dh2(i))
      c(I)=ug(i+1)/(2.*ha2(i))*beta*(dh1(i)+dh2(i))
      B(I)=B(I)+ ALFA*(dh2(i)*fz(I)*GG(I)+dh1(i)*
     *fz(I+1)*GG(I+1))/TAY
c
	c(i)=c(i)+hg(i+1)/ha(i+1)*vg(i+1)*dh1(i)
	b(i)=b(i)-hg(i)/ha(i+1)*vg(i+1)*dh1(i)
c
      DO 4 I=2,N
    4 GK(I)=-DIF(I)*VI(I)/HA(I)
      IF(KTP.EQ.1)UT=-VD(N)*VI(N)/
     *(1.-VD(N)*VI(N)/(2.*GK(N)))
      UD=UT
      UH=UT
      DO 14 I=2,N2
      PKO=ALFA/TAY*(GGTN(I)*dh2(i)+GGTN(I+1)*dh1(i))
      FD(I)=SD0(I)*Vu(I)*dh2(i)+SD0(I+1)*Vu(I+1)*
     *dh1(i)+PKO*PDN(I)
      FT(I)=ST0(I)*Vu(I)*dh2(i)+ST0(I+1)*Vu(I+1)*
     *dh1(i)+PKO*PTN(I)
      FH(I)=SH0(I)*Vu(I)*dh2(i)+SH0(I+1)*Vu(I+1)*
     *dh1(i)+PKO*PHN(I)
   14 CONTINUE
   71 FORMAT(20X,A6/,(8E10.3))
      IF(NTAY.EQ.0)GO TO  99
	keps=0
      IF(ID.NE.0) then
      PD(N)=PD0(N)
      CALL PROGP(N,A,B,C,TETA,GK,U,B0,PD,Z,WD,FD,
     *ZD,UD,EPS0,LD)
	do i=2,n
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
	do i=2,n
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
	do i=2,n
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
	
	print *,' nn keps',nn,keps
	
           apr=' -- pd0 '
           print 71,apr,(pd0(i),i=1,n)
           apr=' -- pt0 '
           print 71,apr,(pt0(i),i=1,n)


c
   99 CONTINUE
      DO 8 I=2,N
      GGT(I)=Vu(I)
    8 CONTINUE
	pd0(1)=pd0(2)
	pt0(1)=pt0(2)
	ph0(1)=ph0(2)
      RETURN
      END
      SUBROUTINE ENERGY(N)
c------------------------------------------------
c  energy balance (electrons and ions)
c------------------------------------------------
	include 'double.inc'
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
	dimension tee(npo),qe0_help(npo),qe0_c(npo)
	
c
	character *4 mfe,mfq,mte,mtq
c

c      print*,'!!! ntay=',ntay
      MTE='TE0'
c      PRINT 71,MTE,(TE0(i),i=1,n)
c      pause 'from zu0'

	fmax=dfmax(n)
	fmax0=sqrt(dfmax0(n))
	FMAX1=sqrt(FMAX)
	kd2=0
	df=0.
	if(ntay.gt.2)then
	kd2=2
	df=-(fmax1-fmax0)/(fmax1*tay)
	end if
c
	NN=0
	ntr=0
       N1=N-1
      PAW1=5./3.
      PAW2=2./3.
      ALFA=1.5
      FKO=1.
	i=2
      VI1(i)=0.
      VI2(i)=0.
      VI3(i)=0.
      fz(i)=0.
      UG(i)=0.
      VG(i)=0.
      GG(i)=0.
	tee(i)=te0(i)
	vu(i)=0.
	i=2
	dh1(i)=2.*ha(i)/(2.*ha(i)+ha(i+1))
	dh2(i)=ha(i+1)/(2.*ha(i)+ha(i+1))
	do i=3,n1
	dh1(i)=ha(i)/(ha(i)+ha(i+1))
	dh2(i)=ha(i+1)/(ha(i)+ha(i+1))
	end do
      DO 1 I=3,N
	vu(i)=vi(i)
	tee(i)=te0(i)
      VI1(I)=VI(I)**PAW1
      VI2(I)=VI(I)**PAW2
    1 fz(I)=1./VI2(I)


      

      DO 2 I=2,N1
      FES=FKO*(fz(I)*GGEN(I)*dh2(i)+fz(I+1)*
     *GGEN(I+1)*dh1(i))*ALFA/TAY
      FE(I)=FES*TEN(I)
    2 FQ(I)=FES*TQN(I)
c--------------------------


      CALL ENIT(N)
      if(kcchp.eq.0)CALL TP(N)
ccc      CALL TP(N)

      do i=1,n
!       qe0_c(i)=0.25*qe0(i)+0.75*qe0_help(i)
       qe0_c(i)=qe0(i)
      end do

      tay_p=10.*tay
      
!      call filter_ppx_time_c(ttb,tay,qe0_c,n,tay_p,kpr)


 1000 CONTINUE

c--------------------------
      DO 50 I=2,N
c calculate pne...
cccc      PNE(I)=PD0(I)+PT0(I)+PH0(I)+zar*ppr(i)+zalfa*pnal(i)
!      PNE(I)=PD0(I)+PT0(I)+ph0(i)

   50 WU(I)=WD0(I)+WT0(I)+WH0(I)

      DO 3 I=3,N
      PP=0.5*(pd0(i)+pd0(i-1)+pt0(i)+pt0(i-1)+ph0(i)+ph0(i-1))
      UG(I)=WU(I)+(0.5*kd2*ai(i)*df+VD(I))*PP*VI(I)
      GG(I)=VI1(I)*PP
      VG(I)=-UG(I)/PP*KEN2
      hg(i)=pne(i)
    3 CONTINUE
	hg(2)=pne(2)
      IF(NTAY.EQ.0)GO TO 99
      ALFA=1.5
      BETA=2.5

c
      DO I=3,N1
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
      A(2)=0.
	i=2
      b(I)=ug(i+1)/(2.*ha2(i))*beta*(dh1(i)+dh2(i))
      c(I)=ug(i+1)/(2.*ha2(i))*beta*(dh1(i)+dh2(i))
      B(I)=B(I)+ ALFA*(dh2(i)*fz(I)*GG(I)+dh1(i)*
     *fz(I+1)*GG(I+1))/TAY
c
	c(i)=c(i)+hg(i+1)/ha(i+1)*vg(i+1)*dh1(i)
	b(i)=b(i)-hg(i)/ha(i+1)*vg(i+1)*dh1(i)
c
   71 FORMAT(20X,A6/,(8(1pE10.3)))
c
c
      DO 21 I=2,N1
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
      FF(I,1)=FE(I)+QE0_c(I)*Vu(I)*dh2(i)+QE0_c(I+1)*
     *Vu(I+1)*dh1(i)
      FF(I,2)=FQ(I)+QQ0(I)*Vu(I)*dh2(i)+QQ0(I+1)*
     *Vu(I+1)*dh1(i)
   21 CONTINUE
      MFE='FE'
      MFQ='FQ'
C     PRINT 71,MFE,(FF(I,1),I=1,N)
C     PRINT 71,MFQ,(FF(I,2),I=1,N)
      TT(N,1)=TE0(N)
      TT(N,2)=TQ0(N)
      CALL PROGPM(N,ZN,UN,LL,4,2)
c
      DO 6 I=2,N

c        if(TT(i,1).lt.10.)TT(i,1)=10.
c        if(TT(i,2).lt.10.)Tt(i,2)=10.


        if(TT(i,1).lt.0.5)TT(i,1)=0.5
        if(TT(i,2).lt.0.5)Tt(i,2)=0.5


      IF(abs(TT(I,1)-TE0(I)).GT.EPS1*abs(TE0(I)))GO TO 7
      IF(abs(TT(I,2)-TQ0(I)).GT.EPS1*abs(TQ0(I)))GO TO 7
    6 CONTINUE
      GO TO 98
    7 CONTINUE
      DO 16 I=2,N
      TE0(I)=TT(I,1)*0.75+tee(i)*0.25
      TQ0(I)=TT(I,2)
	tee(i)=tt(i,1)
   16 CONTINUE
c      print*,'ntay=',ntay

      NN=NN+1
      IF(NN.GT.100.and.kpr.eq.1)print*,' **nn gt 100 **     ***'
!      IF(NN.GT.200.and.kpr.eq.1)print*,' **nn gt 200 **'
	if(nn.gt.100)goto 98
      GO TO 1000
   98 CONTINUE
      DO 5 I=2,N
      TE0(I)=TT(I,1)
      TQ0(I)=TT(I,2)
      WE0(I)=WW(I,1)
      WQ0(I)=WW(I,2)
    5 CONTINUE
      WE0(1)=0.
      WQ0(1)=0.
   99 CONTINUE
      DO 8 I=2,N
      GGE(I)=GG(I)
    8 CONTINUE
	te0(1)=te0(2)
	tq0(1)=tq0(2)
	pne(1)=pne(2)

      IF(kpr.eq.1)print*,' nn EPS1 **',nn,eps1

	
      MTE='TE0'
      PRINT 71,MTE,(TE0(i),i=1,n)
      MTE='QE0'
      PRINT 71,MTE,(QE0(i),i=1,n)
      MTE='PNE'
!      PRINT 71,MTE,(pne(i),i=1,n)
      MTQ='TQ0'
!      PRINT 71,MTQ,(TQ0(i),i=1,n)
      MTE='QQ0'
!      PRINT 71,MTE,(QQ0(i),i=1,n)

!      call ENIT_outp(N)

      do i=1,n
      qe0_help(i)=qe0(i)
      end do
      
 !     call filter_ppx_time_c(ttb,tay,te0,n,tay_p,kpr)
  
	
      RETURN
      END
      SUBROUTINE OITER(N)
c------------------------------------
c   diffusion coeficient and particles sources
c----------------------------------------------
	include 'double.inc'
c       implicit real*8 (a-h,o-z)
	include 'parf0'
        common
     *  /ge5/kpr
      COMMON
     *  /en5/SD0(npo),ST0(npo),SH0(npo)
     *  /en22/XII(npo)
     *  /en4/WD0(npo),WT0(npo),WH0(npo),VD(npo),DIF(npo),
     *  GGT(npo),GGTN(npo)
     *  /en17/QAE(npo),QAQ(npo),SAL(npo),NAL
     *  /en20/PJ(npo),SB(npo)
	src=0.
      DIF(2)=0.
	sd0(2)=-sal(2)+sb(2)+sd0(2)
	st0(2)=-sal(2)+sb(2)+st0(2)
      DO 1 I=3,N
	sd0(i)=-sal(i)+sb(i)+sd0(i)
	st0(i)=-sal(i)+sb(i)+st0(i)
	src=src+sd0(i)+st0(i)
        DIF(I)=0.4*XII(I)
    1 CONTINUE
	print *,' source============================',src
ccc	pause
   71 FORMAT(20X,A6/,(8E10.3))
      RETURN
      END
      SUBROUTINE FITER(N)
c------------------------------------------
c  inward pinch velocity
c--------------------------------------------
	include 'double.inc'
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
      if(kpr.eq.1)print *,' alp1 kpin================',alp1,kpin
      VD(2)=0.
      DO 1 I=3,N
      VP=ALP1*DIF(i)/(GRA2(I)*EU)*AI(I)
      VD(I)=-VP*GRA1(I)*KPIN
      IF(I.EQ.N)VPIN=VP*1.E3
    1 CONTINUE
c      SKOR=POT/(SPOV*(PDN(N)+PTN(N)+PHN(N)))*GRA1(N)
c      VD(N)=VD(N)-SKOR
      RETURN
      END
c



