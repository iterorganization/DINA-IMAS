        SUBROUTINE BTA(n,m,rs0)
c-----------------------------------------
c  beta value and poloidal beta
c-------------------------------------------
	include 'double.inc'
c	implicit real*8 (a-h,o-z)
	include 'parf0'
      COMMON
     *  /dfm2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)
     *  /dfm4/ Q(npo),ANU(npo),P(npo),F(npo),
     *  PP(npo),PFF(npo)
     *  /dfm5/PT01,PT02
     *  /dfm7/bt0,uind
     *  /dfm12/betj,dlint,bett,bet2,betpc,tk,tkp,tkf
     *	/dfm15/uli
        COMMON
     *  /pol3/ A(npo),TET(ntet),HA(npo),HT(ntet)
	common
     *  /eq4/xpl(npo,ntet),ypl(npo,ntet)
     *  /eq13/bpbound
	common
     *  /ge1/PI
     *	/ge1e/rs00,tpl
     *  /ge5/kpr
     *  /ge7/eu,rout,zout,elong
	common
     *  /mid6/bp_0(npo),a_m(npo),r_m(npo)
     *  /mid7/bsq(npo),bsqi(npo),fasp(npo)
     *  /en28/wen1,wen2
     *  /v_epol/epol
c*** Victor's common for dopp *****
        common
     *	/v_surface/s,v

C
	m1=m-1
	n1=n-1
c   p =p(i)*1.e6/(4.*pi)  in sgsu whre p(i) in equilibrium
	pcoef=1.e6/(4.*pi)
      S=0.
      V=0.
      P0C=0.
      P1C=0.
      P2C=0.
      F0C=0.
      F1C=0.
      TKP=0.
      TKF=0.
	EPOL=0.
	ETOR=0.
	dli=0.
	dt_p=0.
	dt_v=0.
	dtor=0.
	dlint=0.
	bz2_av=0.
	bz_av=0.
      DO 30 I=2,N
	bpbound1=0.
      SI=0.
      VI=0.
      DBSI=0.
      DBVI=0.
      k_b=0
      dl_b=0.
      DO 40 J=2,M1
      k_b=k_b+1
c
      U1=xpl(i,j)
      V1=ypl(i,j)
      U2=xpl(i-1,j)
      V2=ypl(i-1,j)
      U3=xpl(i-1,j-1)
      V3=ypl(i-1,j-1)
      U4=xpl(i,j-1)
      V4=ypl(i,j-1)
c
      UA=U1-U2+U4-U3
      UT=U1-U4+U2-U3
      VA=V1-V2+V4-V3
      VT=V1-V4+V2-V3
      DS=0.25*(UA*VT-VA*UT)
      UC=0.25*(U1+U2+U3+U4)
c
      si=si+ds
      vi=vi+ds*uc
      DBSI=DBSI+DS/UC**2
      DBVI=DBVI+DS/UC
c
      GG=UC*DS
      G22=0.25*(UT*UT+VT*VT)
      BPj=SQRT(G22)/(2.*PI*GG)
c   bpol in gaus
      bpol=-BPj*PSi(i)*HA(i)*1.e3
      dl_b=dl_b+sqrt(g22)
	bpbound1=bpbound1+bpol*sqrt(g22)
	epol=epol+bpol**2*DS*UC/(8.*pi)

c        if(epol.lt.0.)then
c        if(kpr.eq.1)print *,' i j DS UC epol',i,j,ds,uc,epol
c	call n_diag_d3d()
c        end if


	dli=dli+bpol**2*ds
	dlint=dlint+bpol**2*ds*uc
	bz2_av=bz2_av+(f(i)*rs0/uc)**2*ds
	bz_av=bz_av+(f(i)*rs0/uc)*ds
40	continue
c	BPBOUND1=BPBOUND1/(M1-2+1)
c
c
      S=S+SI
      V=V+VI
      PC=0.5*(P(I)+P(I-1))
c   btor in gaus
      FC=( f(i)*rs0*1.e3 )**2
	etor=etor+fc*dbvi/(8.*pi)
	dt_p=dt_p+( f(i)-0. )*rs0*dbvi
	dt_v=dt_v+( f(n) )*rs0*dbvi
	dtor=dtor+( f(i)-f(n) )*rs0*dbvi
      PPC=-PP(I)/RS0
      PFFC=-PFF(I)*0.5*RS0
      P0C=P0C+PC*VI
      F0C=F0C+FC*DBVI
      P1C=P1C+PC*SI
      F1C=F1C+FC*DBSI
      P2C=P2C+PC*SI
      TKP=TKP+PPC*VI
      TKF=TKF+PFFC*DBVI
	BPBOUND1=BPBOUND1/dl_b
	bp_0(i)=bpbound1
   30 CONTINUE
	bz2_av=bz2_av/s
	bz_av=bz_av/s
	if(kpr.eq.1)
     *   print *,' b_p(a)= bz2_av=bz_av',bpbound1*1.e-3,bz2_av,bz_av
	bpbound=bpbound1*1.e-3
      TKP=TKP*10./(4.*PI)
      TKF=TKF*10/(4.*PI)
      TK=TKP+TKF
C
      P1C=P1C/S
      F1C=F1C/S
      BET1=pcoef*(8.*pi)*P1C/F1C
      P0C=P0C/V
      F0C=F0C/V
	dlint=dlint/v
      BET2=pcoef*(8.*pi)*P0C/F0C
      BETPc=TKP/TK
      BETPI=pcoef*P2C/(TK*1.E3)**2*200.
	if(kpr.eq.1)print *,'TKP TKF [kA]',TKP,TKF
	if(kpr.eq.1)print *,'TK=TKP+TKF[kA]=',TK, 'kA'
c----
	r_avr=v/s
        bt=bt0*rs0/r_avr

c-----------
      BETt=pcoef*(8.*pi)*P0C/(bt*1.e3)**2
ccc      BETj=pcoef*(8.*pi)*P0C/(bpbound*1.e3)**2
      BETj=pcoef*(8.*pi)*P0C/bpbound1**2
	if(kpr.eq.1)print *,'BETt(<S>;<V>)',BET1,BET2
	if(kpr.eq.1)print *,'BETt(bt0)   BETp(bpbound)',bett,betj
	if(kpr.eq.1)print *,'TKP/(TKP+TKF) BETp(TK**2)',BETPC,BETPI
c  internal inductance li*I**2/2.=epol*1.e-7   I is plasma c.[A]
c----
ccc	uli=2.*epol*100./(tk*1.e3)**2/r_avr

!!!	uli=2.*epol*100./(tpl*1.e3)**2/r_avr
	uli=2.*epol*100./(tpl*1.e3)**2/r_m(n)

	dli=dli*200./(tk*1.e3)**2/(8.*pi)
	dlint1=dlint/bpbound1**2
	dlint=dlint/(bpbound*1.e3)**2
	dtor=dtor*1.e-5
	V=V*2.*PI*1.E-6
	S=S*1.E-4
	if(kpr.eq.1)print *,'V[m3]; S[m2]',V,S
c   dtor is diamagnetic flux in V*s
	if(kpr.eq.1)print *,'<Hp**2>s/Hp**2(by TK)=',dli
	if(kpr.eq.1)print *,'li=2*Ep/tk**2=',uli
	if(kpr.eq.1)print *,'li=<Hp**2>v/bp**2=',dlint
	if(kpr.eq.1)print *,'<Hp**2>v/bp1**2=',dlint1
	if(kpr.eq.1)print *,'Delta tor flux=',dtor,' V*s'
	if(kpr.eq.1)print *,'dt_p dt_v=',dt_p,dt_v
	ETOR=2.*pi*ETOR*1E-7*1.E-6
	EPOL=2.*pi*EPOL*1.E-7*1.E-6
C*****************************
      RETURN
      END
	SUBROUTINE MIDC(N,M,rs0)
c--------------------------------------
c     calculation of average coefficients after equilibrium for
c               transport
c---------------------------------------------
	include 'double.inc'
c       implicit real*8 (a-h,o-z)
	include 'parf0'
      COMMON
     *  /mid1/C1(npo),C2(npo),C3(npo)
     *  /mid2/VI(npo),s(npo)
     *  /mid3/GRA1(npo),GRA2(npo)
     *  /mid4/xpp(npo),xpff(npo),ba(npo)
     *  /mid5/d1,d2
     *  /mid6/bp_0(npo),a_m(npo),r_m(npo)
     *  /mid7/bsq(npo),bsqi(npo),fasp(npo)
	common
     *  /ge1/PI
     *  /ge3/ai(npo),a0(npo),ha2(npo),a(npo),ha(npo)
     *  /ge5/kpr
	common
     *  /eq4/xpl(npo,ntet),ypl(npo,ntet)
     *  /eq15/pll,zsep,rsep,zsepup,rsepup,zsepdw,rsepdw
	common
     *  /dfm2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)
     *  /dfm3/dfmax(npo),dfmax0(npo)
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)
     *  /dfm5/PT01,PT02
     *  /dfm11/c20(npo),tok1(npo),tok2(npo)
	common
     *  /pol4/ UM,VM,UK(ntet),VK(ntet)
	common
     *  /ge7/eu,rs,zout,eksk
	common
     *	/efit4/coef
        common /maksim_04/s_surf(npo)
        common /maksim_05/s_bound

        dimension tok_b(ntet),r_b(ntet),z_b(ntet)

c----------------------------------------------------------
      M1=M-1
71      format(20x,a6/,(8(1pe10.3)))
c
	DKOF=10./(4.*PI)
	d1=0.
	d2=0.
	b0=f(2)*rs0/um
c
      DO 30 i=2,N
	d1j=0.
      VI(I)=0.
      c1(i)=0.
      C2(I)=0.
      C3(I)=0.
      GRA1(I)=0.
      GRA2(I)=0.
      S(I)=0.
	bav=0.
	bpbound1=0.
      dl_b=0.
      
      s_surf(i)=0.
      
      xmin=1.e5
      xmax=-1.e5
	bsq(i)=0.
	bsqi(i)=0.


      DO 40 J=2,M1
c
      U1=xpl(i,j)
      xmin=amin1(xmin,u1)
      xmax=amax1(xmax,u1)
      V1=ypl(i,j)
      U2=xpl(i-1,j)
      V2=ypl(i-1,j)
      U3=xpl(i-1,j-1)
      V3=ypl(i-1,j-1)
      U4=xpl(i,j-1)
      V4=ypl(i,j-1)
c
      UA=U1-U2+U4-U3
      UT=U1-U4+U2-U3
      UT_1=U1-U4
      UT_2=U2-U3
c-------------------------
      VA=V1-V2+V4-V3
      VT=V1-V4+V2-V3
      VT_1=V1-V4
      VT_2=V2-V3
      DS=0.25*(UA*VT-VA*UT)
      UC=0.25*(U1+U2+U3+U4)
      VC=0.25*(V1+V2+V3+V4)
c
      GG=UC*DS
      S(I)=S(I)+DS
      VI(I)=VI(I)+UC*DS
c   another  determination of g22
c      G22=0.5*(UT_1*UT_1+UT_2*UT_2+VT_1*VT_1+VT_2*VT_2)
      G22=0.25*(UT*UT+VT*VT)
c======================================
      BP_j=SQRT(G22)/(2.*PI*GG)
      BP_j=-BP_j*psi(i)*ha(i)
	bsq(i)=bsq(i)+b0**2/( bp_j**2+(f(i)*rs0/uc)**2 )*ds*uc
	bsqi(i)=bsqi(i)+( bp_j**2+(f(i)*rs0/uc)**2 )/b0**2*ds*uc
	bav=bav+sqrt (bp_j**2+(f(i)*rs0/uc)**2)*ds
c   bpol in kGgaus
      bpol=BP_j
      dl_b=dl_b+sqrt(g22)
      
      s_surf(i)=s_surf(i)+2.d0*PI*sqrt(g22)*UC
      
ccc	bpbound1=bpbound1+bpol*sqrt(g22)
	bpbound1=bpbound1+bpol*sqrt(g22)*uc/rs

        if(i.eq.n)then
           tok_b(j)=bpol*sqrt(g22)*coef
           r_b(j)=uc
           z_b(j)=vc
        end if

c========================================
	c1(i)=c1(i)+sqrt(g22)
      C2(I)=C2(I)+G22/(UC*DS)
      C3(I)=C3(I)+DS/UC
      GRA2(I)=GRA2(I)+UC/DS*G22
      GRA1(I)=GRA1(I)+UC*SQRT(G22)
	d1j=d1j+ds/uc
c
   40 CONTINUE
c======================
	bsq(i)=bsq(i)/vi(i)
	bsqi(i)=bsqi(i)/vi(i)
	bsqi(i)=1./bsqi(i)
      a_m(i)=0.5*(xmax-xmin)
      r_m(i)=0.5*(xmax+xmin)
      epi=a_m(i)/r_m(i)
	fasp(i)=0.5/sqrt(epi)*(bsq(i)-bsqi(i))
c
c	if(kpr.eq.1)
c     *print *,' i bsq(i) bsqi(i) fasp(i)',i,bsq(i),bsqi(i),fasp(i)
c
	BPBOUND1=BPBOUND1/dl_b
	bp_0(i)=bpbound1
	bav=bav/s(I)
	ba(i)=bav
c==========================
	d1=d1+d1j
	d2=d2+d1j*f(i)*rs0
      S(I)=S(I)/HA(I)
      VI(I)=VI(I)/HA(I)
      C2(I)=C2(I)*HA(I)/(2.*PI)
      GRA2(I)=GRA2(I)*HA(I)/VI(I)
      GRA1(I)=GRA1(I)/VI(I)
      C3(I)=c3(i)/(ha(i)*2.*PI)
   30 CONTINUE
   
        s_bound=s_surf(n)
   
	ba(1)=ba(2)

	r_m(1)=xpl(1,1)

c----------------------------------------------------------
        tok_p=0.
        do j=2,m1
           tok_p=tok_p+tok_b(j)
        end do
        fpl=0.
        k=0
        do j=2,m1
           k=k+1
           fpl=fpl+fpl_p(uk(j),vk(j),tok_b,r_b,z_b,m1)
        end do
         fpl=fpl/(tok_p*k)
         pll_e=fpl
        if(kpr.eq.1)print *,' pll pll_e tok_p=====',pll,pll_e,tok_p
c        read (*,*)
      RETURN
      END

      function fpl_p(r,z,tok_b,r_b,z_b,m1)
	include 'double.inc'
      include 'parf0'
        dimension tok_b(ntet),r_b(ntet),z_b(ntet)
        fpl=0.
        do j=2,m1
           fpl=fpl+tok_b(j)*fp( r,r_b(j),z,z_b(j) )
        end do
        fpl_p=fpl
        return
        end


	SUBROUTINE TOKK(N,RS0)
	include 'double.inc'
c       implicit real*8 (a-h,o-z)
	include 'parf0'
      COMMON
     *  /mid1/C1(npo),C2(npo),C3(npo)
     *  /mid2/VI(npo),s(npo)
     *  /mid4/xpp(npo),xpff(npo),scur(npo)
	common
     *  /ge1/PI
     *  /ge3/ai(npo),a0(npo),ha2(npo),a(npo),ha(npo)
     *  /ge5/kpr
	common
     *  /DFM2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)
     *  /dfm5/PT01,PT02
     *  /dfm8/ajb(npo),sigk(npo)
     *  /dfm11/c20(npo),tok1(npo),tok2(npo)
	common
     *  /en2/TE0(npo),TQ0(npo),TEN(npo),
     *  TQN(npo),WE0(npo),WQ0(npo)
     *  /en9/QE0(npo),QQ0(npo),QDG(npo)
     *  /en9e/volt(npo)
	common/temp/n_p
c
	CHARACTER *70 APR
	dimension aak(npo),bbk(npo),cck(npo),ohm(npo)

c----------------------------------------------------------
c	if(kpr.eq.1)print *,' -- n pi',n,pi
	DKOF=10./(4.*PI)
	c20(1)=0.
	do i=1,n-1
	c20(i+1)=-c2(i+1)*psi(i+1)
	end do
	call interp(c20,ai,aak,bbk,cck,n)
	do i=2,n
	tok1(i)=dkof*( 2.*aak(i)*ai(i)+bbk(i) )/s(i)
	end do
c       tok1(2)=dkof*c20(2)/(0.5*s(2)*ha(2))
	tok1(1)=tok1(2)
c
	tok=0.
	do i=2,n
	tok=tok+tok1(i)*s(i)*ha(i)
	end do
	tok=tok-0.5*tok1(n)*s(n)*ha(n)
c       pt02=dkof*c20(n)
	pt02=tok
cc      do i=n_p+1,n
cc      tok1(i)=(c20(i)-c20(i-1))*2./(ha(i)*s(i)+ha(i-1)*s(i-1))
cc      end do
c
c	if(kpr.eq.1)print *,' before -- n pi',n,pi
	DO 33 I=2,N
	PFF(I)=-2.*s(i)/(c3(i)*2.*pi*rs0)*
     *  (TOK1(I)/dkof+PP(I)*VI(I)/(RS0*S(I)))
c        TOK2(I)=-dkof*( PP(I)*VI(I)/(RS0*S(I)) +
c     *  0.5*PFF(I)*RS0*2.*PI*c3(i)/S(I))
   33   CONTINUE
c	if(kpr.eq.1)print *,' after  -- n pi',n,pi
c
	APR=' array TOK1=-c2(i)*psi`(i),kA/cm2 (tokk)'
	if(kpr.eq.1)print 71,APR,(TOK1(I),I=1,N)
	if(kpr.eq.1)print * ,'I through TOK1=',
     *  tok,'kA','  PT02=',pt02,'kA'
c
	QDG0=9./(1.2*16.)*1.E2
	QDG0=QDG0*1.E6
c
        PNOR=6.25E8
c----------
	do i=2,n
c	QDG(I)=QDG0*TOK1(I)*TOK1(I)
c	QDG(I)=QDG0*0.5*(1.-a(i))
	QDG(I)=(1.e-6*pnor)*(TOK1(I)*1.e3)*abs(volt(I))*
     *  s(i)/(2.*pi*vi(i))
	qdg(i)=abs(qdg(i))
ccc	ohm(I)=QDG0*TOK1(I)*TOK1(I)/(te0(i)**1.5*sigk(i))
ccc	qdg(i)=ohm(i)
ccc	if(kpr.eq.1)print *,' i qdg(i) ohm(i)',i,qdg(i),ohm(i)
	end do
ccc	pause
c	if(kpr.eq.1)print *,
c     *  'PT01=tpl(tpl=-c2*psi(n_p)`from main)=',pt01,'kA(tokk)'
c
71      format(10x,a70/,(6(1pe11.3)))
      RETURN
      END
	subroutine interp(f,ai,aak,bbk,cck,n)
c---------------------------------------------
c  quadratic polinomial interpolation for array
c  from transport to equilibrium
c-----------------------------------------------
	include 'double.inc'
c       implicit real*8 (a-h,o-z)
	dimension f(n),ai(n),aak(n),bbk(n),cck(n)
	n1=n-1
	do i=2,n1
	delt=ai(i+1)**2*ai(i)+ai(i)**2*ai(i-1)+
     *  ai(i-1)**2*ai(i+1)-
     *  ai(i-1)**2*ai(i)-ai(i)**2*ai(i+1)-ai(i+1)**2*ai(i-1)
	aak(i)=(f(i+1)*ai(i)+f(i)*ai(i-1)+f(i-1)*ai(i+1)-
     *  f(i-1)*ai(i)-f(i)*ai(i+1)-f(i+1)*ai(i-1))/delt
	bbk(i)=(ai(i+1)**2*f(i)+ai(i)**2*f(i-1)+ai(i-1)**2
     *  *f(i+1)-
     *  ai(i-1)**2*f(i)-ai(i)**2*f(i+1)-ai(i+1)**2
     *  *f(i-1))/delt
	cck(i)=f(i)-aak(i)*ai(i)**2-bbk(i)*ai(i)
	end do
	aak(n)=aak(n-1)
	bbk(n)=bbk(n-1)
	cck(n)=cck(n-1)
	return
	end




c
