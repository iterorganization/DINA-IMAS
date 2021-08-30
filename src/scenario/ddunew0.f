       SUBROUTINE DIFMF_1()
	include 'double.inc'
       include 'new_com.inc'


      call difmf_1_c(n,
     *rs0,next,sigma_jetto,sigma_dina,k_ener,k_uv)

      return
      end



      SUBROUTINE DIFMF_1_c(n,
     *rs0,next,sigma_jetto,sigma_dina,k_ener,k_uv)

c$$$            SUBROUTINE DIFMF_1(N)

cc----------------------------------------
c   magnetic field diffusion
c--------------------------------------------
	include 'double.inc'
c       implicit real*8 (a-h,o-z)
	include 'parf0'
      COMMON
     *  /DFM1/UDM,ZDM,L3,SIG0
     *  /DFM2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)
     *  /dfm3/dfmax(npo),dfmax0(npo)
     *  /DFM4/Q(npo),ANU(npo),P(npo),Fx(npo),
     *  PP(npo),PFF(npo)
     *  /dfm7/bt,uind
     *  /dfm8/ajb(npo),sigk(npo)
     *  /dfm9/aj0(npo)
     *  /dfm10/ajf(npo),aje1(npo),aje(npo)
     *  /dfm11/c20(npo),tok1(npo),tok2(npo)
     *  /dfm13/tokel,tokfi,tokbut
     *  /dfm13e/tokuv
     *  /dfm14/tokae,ajae(npo),ajae0(npo),enae
	common
     *  /en2/TE0(npo),TQ0(npo),TEN(npo),
     *  TQN(npo),WE0(npo),WQ0(npo)
	common
     *  /mid1/C1(npo),C2(npo),C3(npo)
     *  /mid2/vi(npo),spo(npo)
	common
     *  /ge1/pi
     *  /ge2/NTAY,TAY,TT
     *  /ge3/AI(npo),A0(npo),HA2(npo),a1(npo),ha(npo)
     *  /ge4/EPS1,EPS2,EPS0
     *  /ge5/kpr
     *  /ge6/zeff(npo),qpr(npo),ppr(npo),pr0,prg,zar
     *  /en9e/volt(npo)
     *  /sig/sig

	common
     *	/efit6/tpl_p
        common                                                          
     *  /c_con9/key_sig_coef
c
	dimension UG(npo),VG(npo),HG(npo),GG(npo),
     *  WDM0(npo),FDM0(npo),A(npo),B(npo),C(npo),
     *  TETA(npo),GK(npo),
     *  U(npo),B0(npo),Z(npo),DM(npo),WDM(npo),SIG(npo),
     *  AGK(npo),FDM(npo),DH1(npo),dh2(npo),fz(npo)
c
	dimension fji(npo),tsig(npo),f(npo),fbut(npo),
     *  fuv(npo),fae(npo),tsig_0(npo),dfma(npo)
c
	character *50 mps

      dimension sigma_jetto(*),sigma_dina(*),sigk_jetto(npo)
      dimension sigk_jetto1(npo),aj0_help(npo),b_corr(npo)
      
        dimension dm_help(npo),df_help(npo),cur_tor(npo)


	character *30 apr                                                      
	dimension a_print(200)

c
        sig0_new=9./(4.*pi*sig0)*1.e4

        if(kpr.eq.1)print *,' n rs0 next==',n,rs0,next

        if(kpr.eq.1)print *,' sig0_new==',sig0_new

        if(kpr.eq.1)print *,' key_sig_coef coef_sigk==',
     *  key_sig_coef,coef_sigk
      

        if(key_sig_coef.eq.1)then
c********
	  open (unit=40,file='coef_sigk.dat',form='formatted') 
          read (40,*) 
          read (40,*)coef_sigk
	  close (40)

        if(kpr.eq.1)print *,' key_sig_coef coef_sigk==',
     *  key_sig_coef,coef_sigk


      end if
            
      
	do i=1,n
	dm_help(i)=dmn(i)
	end do

        i_old=1

	ptor=0.

        if(ntay.gt.next.and.i_old.eq.1)ptor=1

!        ptor=0.
      
        if(ntay.gt.next.and.i_old.eq.0)then

c!!        if(ntay.gt.2)then

	do i=2,n

c           df_temp=0.5*(dfmax(i)+dfmax0(i))
           df_temp=dfmax(i)

           if(df_temp.le.dfmax0(n))then

c	call feet_p(n,pffz,pffx(i),aiz,a(i))

c              call feeti(n,dm_help,dmn(i),dfmax0,df_temp)

              call linear(n,dm_help,dmn(i),dfmax0,df_temp)
        
           else

              dmn(i)=dm_help(n)

           end if

	end do


	mps='dm_help'
c        if(kpr.eq.1)print 71,mps,(dm_help(i),i=1,n)

	mps='dfmax0'
c        if(kpr.eq.1)print 71,mps,(dfmax0(i),i=1,n)
	mps='dfmax'
c        if(kpr.eq.1)print 71,mps,(dfmax(i),i=1,n)

        end if



c
	do i=2,n
	f(i)=fx(i)
	pfi(i)=2.*pi*rs0*c3(I)*fx(i)

c       f(i)=0.5*(fx(i)+fx(i-1))
	end do

	mps='dmn'
        if(kpr.eq.1)print 71,mps,(dmn(i),i=1,n)
	mps='dm0'
        if(kpr.eq.1)print 71,mps,(dm0(i),i=1,n)
        
         DO  I=2,N
        psi(i)=(dm0(i)-dm0(i-1))/ha(i)
        Q(I)=-PFI(I)/PSI(I)
        if(abs(sigk(i)).le.1.e-3)sigk(i)=1./zeff(i)
        end do
        
        	mps='q'
        if(kpr.eq.1)print 71,mps,(q(i),i=1,n)

      if(k_ener.eq.0)then

	mps='sigma_jetto'
        if(kpr.eq.1)print 71,mps,(sigma_jetto(i),i=1,n)
      
ccccc      ov_zeff=1./zeff(1)
        coef_sigm=1.
ccc        if(tt.gt.50.e3)coef_sigm=1.5

      ov_zeff=1./zeff(1)*coef_sigm
      if(kpr.eq.1)print *,' ov_zeff=',ov_zeff
      
      sigk(1)=ov_zeff      

	mps='sigk'
!      if(kpr.eq.1)print 71,mps,(sigk(i),i=1,n)
 

      TXX=TE0(1)
      sigk_jetto(1)=sigma_jetto(1)/(txx**1.5)
      
      if(kpr.eq.1)print *,' txx sigk_jetto(1)=',txx,sigk_jetto(1)
	do i=2,n
      TXX=0.5*(TE0(I)+TE0(I-1))
      sigk_jetto(i)=sigma_jetto(i)/(txx**1.5)
	sigma_dina(i)=1.2d4/9.*(txx**1.5)*sigk(i)
      end do      

	mps='1 sigma_dina'
      if(kpr.eq.1)print 71,mps,(sigma_dina(i),i=1,n)

	mps='sigk_jetto'
      if(kpr.eq.1)print 71,mps,(sigk_jetto(i),i=1,n)
      
	do i=2,n
	sigk_jetto(i)=sigk_jetto(i)/sigk_jetto(1)*ov_zeff
      end do      
      
      sigk_jetto(1)=ov_zeff

	mps='sigk_jetto'
      if(kpr.eq.1)print 71,mps,(sigk_jetto(i),i=1,n)

	do i=1,n
	sigma_dina(i)=sigma_jetto(i)*sigk(i)/sigk_jetto(i)
      end do      

	mps='sigma_dina'
      if(kpr.eq.1)print 71,mps,(sigma_dina(i),i=1,n)

      end if ! k_ener=0

c
c
	ajb(2)=0.5*ajb(3)
c        if(kpr.eq.1)print *,'*** bt=',bt
c
	kuv=k_uv
      kbu=1
	kae=1

ccc	if(ntay.lt.999999)kbu=0
	if(ntay.lt.4)kbu=0

	if(ntay.lt.4)kuv=0
	if(ntay.lt.4)kae=0


        if(kpr.eq.1)print *,'kuv kbu=',kuv,kbu


      if(k_ener.eq.0)then
      
        TXX=TE0(1)
        sigk_jetto1(1)=sigma_jetto(1)*1.2566e-7*sig0/txx**1.5

      end if      ! k_ener=0


      N2=N-1
	do i=2,n
      TXX=0.5*(TE0(I)+TE0(I-1))
c
c	if(ntay.lt.15)txx=10.+(100.-10.)*(1.-a1(i))
c
        if(abs(sigk(i)).le.1.e-3)sigk(i)=1./zeff(i)

	sigk(i)=1./zeff(i)

c       sigk(i)=1.


!        sigk(i)=sigk(i)
c********
        


c	sigk(i)=1./zeff(i)
c       sigk(i)=1.

      if(k_ener.eq.0)then

        sigk_jetto1(i)=sigma_jetto(i)*1.2566e-7*sig0/(txx**1.5)

      if(ai(i).le.1.95)then
!	tsig(i)=txx**1.5*sigk_jetto(i)
         tsig(i)=txx**1.5*sigk_jetto1(i)
	else

	tsig(i)=txx**1.5*sigk_jetto(i)*1.e-7

	end if

ccc To set up sigk_jetto one needs to make comment of next line

c!!!!!!!!!!	if(tt.gt.150.e3)tsig(i)=txx**1.5*sigk(i)


      end if  ! k_ener=0

      if(k_ener.eq.1)then
	if(i.eq.-n)then 
	if(txx.gt.10.d0)txx=10.d0
	aj0(n)=0.
	ajb(n)=0.
	end if
	
	tsig(i)=txx**1.5*sigk(i)/(1.+coef_sigk*ai(i))
      end if  ! k_ener=1

	end do
	mps='sigm'
       if(kpr.eq.1)print 71,mps,(sigk(i),i=1,n)
	mps='tsig'
       if(kpr.eq.1)print 71,mps,(tsig(i),i=1,n)
c____________________________________________
      ALFA=1.
      BETA=0.
	i=2
      VG(i)=0.
      UG(i)=0.
      HG(i)=1.
      GG(i)=1.
      SIG(i)=0.
      fz(i)=0.
	fji(i)=0.
      TETA(i)=1./HA2(i)
	i=2
	dh1(i)=2.*ha(i)/(2.*ha(i)+ha(i+1))
	dh2(i)=ha(i+1)/(2.*ha(i)+ha(i+1))
	do i=3,n2
	dh1(i)=ha(i)/(ha(i)+ha(i+1))
	dh2(i)=ha(i+1)/(ha(i)+ha(i+1))
	end do
      DO 1 I=3,N
cccc    c_fi=9.e3/(1.2*tsig(i)*pfi(i))*2.*pi*vi(i)*bt/sigk(i)
      SIG(I)=SIG0/tsig(i)/C3(I)*f(i)
      GK(I)=-C2(I)/f(i)
      GG(I)=1.
      UG(I)=0.
      HG(I)=1.
      fz(I)=1./SIG(I)
      TETA(I)=1./HA2(I)
	fji(i)=(kuv*aj0(i)+kbu*ajb(i)+kae*ajae(i))*9.e3/
     *(sig0_new*tsig(i)*pfi(i))
c###     **2.*pi*vi(i)*bt/sigk(i)

     **2.*pi*spo(i)*rs0*f(i)



	dfma(i)=-ptor*(dfmax(i)-dfmax0(I))/tay



      VG(I)=1./pfi(i)*fz(I)
    1 CONTINUE
c
      DO I=3,N2
      A(I)=-UG(I)/(2.*ha2(i))*beta*(dh1(i)+dh2(i))
      b(I)=(ug(i+1)-UG(I))/(2.*ha2(i))*beta*
     *(dh1(i)+dh2(i))
      c(I)=UG(I+1)/(2.*ha2(i))*beta*(dh1(i)+dh2(i))
      B(I)=B(I)+ ALFA*(dh2(i)*fz(I)*GG(I)+dh1(i)*
     *fz(I+1)*GG(I+1))/TAY
c
	a(i)=a(i)-hg(i-1)/ha(i)*vg(i)*dh2(i)*dfma(i)
	c(i)=c(i)+hg(i+1)/ha(i+1)*vg(i+1)*dh1(i)*dfma(i)
	b(i)=b(i)+hg(i)/ha(i)*vg(i)*dh2(i)*dfma(i)-hg(i)/
     *ha(i+1)*vg(i+1)*dh1(i)*dfma(i)
c
	end do
      A(2)=0.
	i=2
      b(I)=ug(i+1)/(2.*ha2(i))*beta*(dh1(i)+dh2(i))
      c(I)=ug(i+1)/(2.*ha2(i))*beta*(dh1(i)+dh2(i))
      B(I)=B(I)+ ALFA*(dh2(i)*fz(I)*GG(I)+dh1(i)*
     *fz(I+1)*GG(I+1))/TAY
c
	c(i)=c(i)+hg(i+1)/ha(i+1)*vg(i+1)*dh1(i)*dfma(i)
	b(i)=b(i)-hg(i)/ha(i+1)*vg(i+1)*dh1(i)*dfma(i)
c
      DO 9 I=3,N
      AGK(I)=GK(I)/HA(I)
    9 CONTINUE
	do i=2,n2
      FDM(I)=ALFA*(fz(I)*GG(I)*dh2(i)+fz(I+1)*
     *GG(I+1)*dh1(i))/TAY*dmn(I)+
     *fz(i)*fji(i)*dh2(i)+fz(i+1)*fji(i+1)*dh1(i)
c      FDM(I)=fdm(i)-ktor1*(fz(I)*GG(I)*dh2(i)/q(i)+fz(I+1)*
c     *GG(I+1)*dh1(i)/q(i+1))/TAY*(dfmax(i)-dfmax0(i))
	end do
   71 FORMAT(5X,A60/,(6(1pE11.3)))
      DM(N)=dm0(n)
    2 CONTINUE
c       if(kpr.eq.1)print *,'l3 udm zdm',l3,udm,zdm
      CALL PROGP(N,A,B,C,TETA,AGK,U,B0,DM,Z,WDM,FDM,
     *ZDM,UDM,EPS0,L3)
      DO 5 I=2,N
      dm0(I)=DM(I)
      WDM0(I)=WDM(I)
    5 CONTINUE
c
	do i=3,n-1
	f_r=a(i)*dm0(i-1)+b(i)*dm0(i)+c(i)*dm0(i+1)+
     *	(wdm0(i+1)-wdm0(i))/ha2(i)
c	if(kpr.eq.1)print *,' i f_r fdm(i)',i,f_r,fdm(i)
	end do
c

      DO 88 I=3,N
        psi(i)=WDM0(I)/GK(I)
	dm(i)=(dm0(i)-dm0(i-1))/ha(i)
   88 Q(I)=-PFI(I)/PSI(I)
	do i=2,n-1
	aje(i)=+ALFA*(fz(I)*GG(I)*dh2(i)+fz(I+1)*
     *GG(I+1)*dh1(i))/TAY*( dm0(i)-dmn(I) )
c
	ajf(i)=	( dm0(i+1)-dm0(i) )/ha(i+1)*vg(i+1)*dh1(i)*dfma(i)+
     *	( dm0(i)-dm0(i-1) )/ha(i)*vg(i)*dh2(i)*dfma(i)
c
	volt(i)=-(aje(i)+ajf(i))/100./
     *  ( fz(I)*GG(I)*dh2(i)+fz(I+1)*GG(I+1)*dh1(i) )
c
	c_fi=9.e3/(sig0_new*tsig(i)*pfi(i))*2.*pi*spo(i)*rs0*
     *  f(i)
	c_fi1=9.e3/(sig0_new*tsig(i+1)*pfi(i+1))*2.*pi*spo(i+1)*
     *  rs0*f(i)
c--
	fbut(i)=fz(i)*ajb(i)*c_fi*dh2(i)+fz(i+1)*ajb(i+1)*c_fi1*dh1(i)
	fuv(i)=fz(i)*aj0(i)*c_fi*dh2(i)+fz(i+1)*aj0(i+1)*c_fi1*dh1(i)
	fae(i)=fz(i)*ajae(i)*c_fi*dh2(i)+fz(i+1)*ajae(i+1)*c_fi1*dh1(i)
c
	w_r=(wdm0(i+1)-wdm0(i))/ha2(i)
	f_r=(kbu*fbut(i)+kuv*fuv(i)+kae*fae(i))-aje(i)-ajf(i)
c	if(kpr.eq.1)print *,' i w_r f_r volt(i)',i,w_r,f_r,volt(i)
c
	end do
 	ateta=1.
        call inter_h0(volt,a1,n-1,ateta,val)
	volt(n)=val
c	pause
	tokel=0.
	tokfi=0.
	tokbut=0.
	tokuv=0.
	tokae=0.
	enae=0.
	do i=2,n-1
	tokbut=tokbut+fbut(i)*ha2(i)
	tokuv=tokuv+fuv(i)*ha2(i)
	tokae=tokae+fae(i)*ha2(i)
	tokel=tokel+aje(i)*ha2(i)
	enae=enae+fae(i)*ha2(I)/spo(i)*2.*pi*spo(i)*rs0
	tokfi=tokfi+ajf(i)*ha2(I)
	end do
        tok_b=0.
        do i=2,n
        tok_b=tok_b+ajb(i)*spo(i)*ha(i)
        end do

	coef=10./(4.*pi)

        tok_b2=tok_b*coef

        tok_ae=0.
        do i=2,n
        tok_ae=tok_ae+ajae(i)*spo(i)*ha(i)
        end do

        tok_ae2=tok_ae*coef

c
	tokbut=tokbut*coef*f(n)
	tokuv=tokuv*coef*f(n)
	tokae=tokae*coef*f(n)
	enae=enae*coef*f(n)*3.2e-8*10.
c
	tokel=tokel*coef*f(n)
	tokfi=tokfi*coef*f(n)
	tok=-tokel-ptor*tokfi+kbu*tokbut+kuv*tokuv+kae*tokae
c
        if(kpr.eq.1)
     *	print *,'tokel tokfi bt',tokel,tokfi,bt,' kA (difmf)'
        if(kpr.eq.1)
     *	print *,'tokbut tok_b tokuv',kbu*tokbut,tok_b,kuv*tokuv,
     *   ' kA (difmf)'
	if(kpr.eq.1)
     *	print *,'tok  tokae tokae2 ',tok,tokae,tok_ae2,' kA (difmf)'
c

     	a_print(1)=tokel
	a_print(2)=tokfi
	a_print(3)=tok
	a_print(4)=tokbut

	n_pr=4

	apr='tokel tokfi tok tokbut'

	num=30

!	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)

	psi(2)=0.5*dh1(2)*psi(3)
	dm0(1)=dm0(2)-psi(2)*ha(2)
c	q(2)=q(3)
	q(2)=-pfi(2)/psi(2)
        
        c20(1)=0.

        do i=2,n
           c20(i)=-c2(i)*psi(i)
        end do

        

	do i=3,n-1
           aje(i)=coef*( c20(i)*dh2(i)+c20(I+1)*dh1(i) )
        end do

        aje(1)=0.

        i=2

 	ateta=a1(2)
        n_1=3
        call inter_h0(c20,ai,n_1,ateta,val)

        aje(i)=coef*val

	do i=2,n-1
          tok2(i)=(aje(i)-aje(i-1))/(spo(i)*ha(i))
        end do

        i=3
        tok2(i)=coef*wdm0(3)*f(3)/(ha(2)+0.5*ha(3))/(spo(i)*dh1(2))
        
        tok2(1)=tok2(2)

c***************************************
	mps='volt'
	if(kpr.eq.1)print 71,mps,(volt(i),i=1,n)
	q(1)=q(2)
	do i=2,n
	dm(i)=-(dfmax(i)-dfmax0(i))/tay*1.e-2
	end do
	mps='V in i`s magnetic surface by dfi/dt,V (difmf)'
c	if(kpr.eq.1)print 71,mps,(dm(i),i=1,n)
	do i=2,n
	dm(i)=-(dm0(i)-dmn(i))/tay*1.e-2
	end do
	mps='V dpsi/dt,V (difmf)'
	if(kpr.eq.1)print 71,mps,(dm(i),i=1,n)
	mps='psi*'
c	if(kpr.eq.1)print 71,mps,(psi(i),i=1,n)
	mps='psi-'
c	if(kpr.eq.1)print 71,mps,(dm(i),i=1,n)
	mps='ajb, kA/cm**2 (difmf)'
        if(kpr.eq.1)print 71,mps,(ajb(i),i=1,n)
	mps='aj0, kA/cm**2 (difmf)'
        if(kpr.eq.1)print 71,mps,(aj0(i),i=1,n)
	mps='tok2, kA/cm**2 (difmf)'
c        if(kpr.eq.1)print 71,mps,(tok2(i),i=1,n)

c	mps='ajae, kA/cm**2 (difmf)'
c	if(kpr.eq.1)print 71,mps,(ajae(i),i=1,n)
	mps='q***'
	if(kpr.eq.1)print 71,mps,(q(i),i=1,n)
c
	do i=2,n
	dmn(i)=dm_help(i)
	end do

	do i=1,n
	df_help(i)=dfmax(i)
	end do

      RETURN
      END
c
      SUBROUTINE DIFMF_3(n_xx)
     	include 'double.inc'
      include 'new_com.inc'                                             

      call difmf_3_c(n_xx,
     *pi,tay,tpl,um,rs0,ha,ha2,c2,c3,spo,vi,
     *psi8,dm0,dmn,pfi,dfmax,dfmax0,f,q,te0,zeff,
     *ntay,next,
     *pll,pll0,tpl0,udd,
     *ajb,aj0,volt,sigk,k_uv,

     *tokel,tokbut,

     * aj0_ech,aj_cd,
     * p_turb,sigma_ext,a,kpr,volt_pol)





      return
      end



      SUBROUTINE DIFMF_3_c(n,
     *pi,tay,tpl,um,rs0,ha,ha2,c2,c3,spo,vi,
     *psi,dm0,dmn,pfi,dfmax,dfmax0,f,q,te0,zeff,
     *ntay,next,
     *pll,pll0,tpl0,udd,
     *ajb,aj0,volt,sigk,k_uv,

     *tokel,tokbut,

     * aj0_ech,aj_cd,
     * p_turb,sigma_ext,poa,kpr,volt_pol)

c     * aj0_b,aj0_uv,aj0_lh,aj0_ech,
c     * aj0_ech1,aj0_ech2,aj0_ech3,poa)

     	include 'double.inc'


c      dimension aj0_b(*),aj0_uv(*),aj0_lh(*),
c     *aj0_ech(*),aj0_ech1(*),aj0_ech2(*),aj0_ech3(*)

      dimension ha(*),ha2(*),c2(*),c3(*),spo(*),vi(*),psi(*),dm0(*),
     * dmn(*),pfi(*),dfmax(*),dfmax0(*),f(*),q(*),te0(*),zeff(*),
     * ajb(*),aj0(*),volt(*),sigk(*),poa(*)

      dimension aj0_ech(*),aj_cd(*),sigma_ext(*),volt_pol(*)

      include 'parf0'

      real *8 dh1(npo),dh2(npo),teta(npo),a(npo),b(npo),c(npo),
     *alfa1(npo),alfa2(npo),alfa3(npo),gk(npo),alf(npo),bet(npo),
     *fm(npo),fdm(npo),
     *fi_dot(npo),sig0(npo),y(npo)

      dimension dm_help(npo),aj0_help(npo),fj(npo),tok2(npo),
     *b_temp(npo),fbut(npo),fuv(npo),aje(npo),ajf(npo)

      common /c_te_av/te_av
      common /c_s_plas/s_plas,alfa2_avr

      common /c_s_plas1/alf_b,bet_b,x1_b,dm_b

      real *8 x1,x2,x3

	dimension a_print(200)
	character*30 apr

      sig_coef=1.2d0*2.d0/9.d0*1.d-7

      tay_s=tay*1.e-3

      coef_i=4.d0*pi/10.d0

      n_pol=0

      c_beam=1.

      if(ntay.gt.1)then
         kbu=1
         kuv=1
         kae=0
      else
         kbu=0
         kuv=0
         ktor1=0
         kae=0
      end if


	kbu=0


      n1=n-1

c      ajb(2)=0.5*ajb(3)
      
c      ajb(1)=ajb(2)

            te_av=0.d0

      do i=1,n

         dm_help(i)=dmn(i)


c--------------------------        

        aj0(i)=aj0_ech(i)+aj_cd(i)

c------------------------

        aj0_help(i)=kbu*ajb(i)+kuv*aj0(i)

 !       aj0_help(i)=0.

      te_av=te_av+te0(i)/n


      end do


c      aj0_help(2)=aj0_help(3)
c      aj0_help(1)=aj0_help(2)

      i_old=1
	p_turb=1.d0

c      if(ntay.gt.0.and.i_old.eq.1)n_pol=1
      if(ntay.gt.1.and.i_old.eq.1)n_pol=1

 !     n_pol=0
c      kbu=0



      if(ntay.gt.1.and.i_old.eq.0)then

	n_pol=0

      do i=2,n

c     df_temp=0.5*(dfmax(i)+dfmax0(i))
           df_temp=dfmax(i)

           if(df_temp.le.dfmax0(n))then

c	call feet_p(n,pffz,pffx(i),aiz,a(i))

c              call feeti(n,dm_help,dmn(i),dfmax0,df_temp)

              call linear(n,dm_help,dmn(i),dfmax0,df_temp)
        
           else

              dmn(i)=dm_help(n)

           end if

	end do  !  do i=2,n
        
        end if  !      if(ntay.gt.next.and.i_old.eq.0)
 

        sigk(1)=sigk(2)

c 	ateta=0.

c        call inter_h0(sigk,a1,,ateta,val)
c	sigk(1)=val

        apr='sigk'
c        print 71,apr,(sigk(i),i=1,n)

	dh1(1)=0.5d0
      dh2(1)=0.5d0

      do i=2,n1
         dh1(i)=ha(i)/(ha(i)+ha(i+1))
         dh2(i)=ha(i+1)/(ha(i)+ha(i+1))
         TETA(i)=2./(HA(i)+ha(i+1))
      end do

      i_test=0

      if(i_test.eq.1.and.ntay.gt.3)then

      a_bar0=0.5
      a_bar1=0.6

c      n_te=2

      do i=1,n
         if(poa(i).gt.a_bar1)then 
            te0(i)=te0(n)
         end if
         if(poa(i).le.a_bar0)then 
            te0(i)=te0(1)
         end if
         if( (poa(i)-a_bar0)*(poa(i)-a_bar1).lt.0.)then
            te0(i)=te0(n)+(te0(1)-te0(n))/
     *  (a_bar0-a_bar1)*(poa(i)-a_bar1)
         end if

      end do

      end if




	if(kpr.eq.3)then
	do i=1,6
	a_print(i)=sigk(i)
	end do	
	n_pr=6
	apr='sigk'
	num=25
c	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)
	end if

        do i=1,n

           if(abs(sigk(i)).le.1.e-3)sigk(i)=1.d0/zeff(i)

c
c	print *,' i sigk zeff=',i,sigk(i),zeff(i)

c  Temporarily...


!          sigk(i)=1.d0/zeff(i)
!          sigk(i)=1.d0

        end do



	if(kpr.eq.3)then
	do i=1,6
	a_print(i)=sigk(i)
	end do	
	n_pr=6
	apr='sigk'
	num=25
c	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)

	do i=1,6
	a_print(i)=zeff(i)
	end do	
	n_pr=6
	apr='zeff'
	num=25
c	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)


	end if



        do i=1,n-1

           TXX=TE0(I)

           txx=txx*p_turb

          sig0(i)=sig_coef*txx**1.5*(dh1(i)*sigk(i+1)+
     *  dh2(i)*sigk(i))

        end do



	do i=1,n	
!	if(dabs(sigma_ext(i)).gt.1.e-5)sig0(i)=
!     *   sig_coef*sigma_ext(i)     
	end do

c        apr='f**'
c        print 71,apr,(f(i),i=1,n)

c      do i=2,n
c         f(i)=pfi(i)/(2.*pi*c3(i)*rs0)
c      end do

        apr='f--'
c        print 71,apr,(f(i),i=1,n)

        apr='dfmax'
c        print 71,apr,(dfmax(i),i=1,n)
        apr='dfmax0'
c        print 71,apr,(dfmax0(i),i=1,n)

        apr='dmn'
c        print 71,apr,(dmn(i),i=1,n)

        apr='dm_help'
c        print 71,apr,(dm_help(i),i=1,n)

        apr='q--'
c        print 71,apr,(q(i),i=1,n)

      apr='dh1'
c      print 71,apr,(dh1(i),i=1,n)
      apr='dh2'
c      print 71,apr,(dh2(i),i=1,n)

      apr='teta'
c      print 71,apr,(teta(i),i=1,n)

      apr='sig0'
c      print 71,apr,(sig0(i),i=1,n)

      apr='zeff'
c      print 71,apr,(zeff(i),i=1,n)

      apr='te0'
c      print 71,apr,(te0(i),i=1,n)

      do i=1,n
         fi_dot(i)=n_pol*(dfmax(i)-dfmax0(i))/tay_s
      end do

      apr='fi_dot'
c      print 71,apr,(fi_dot(i),i=1,n)

      do i=1,n
         alfa1(i)=sig0(i)
      end do

      alfa2_avr=0.d0
      
      do i=2,n

         alfa3(i)=1.d0/(f(i)**2*rs0)

         alfa2(i)=pfi(i)*alfa3(i)

         alfa2_avr=alfa2_avr+alfa2(i)/n
         
         gk(i)=-c2(i)/f(i)

         fj(i)=coef_i*aj0_help(i)*spo(i)*f(i)*rs0

      end do

      apr='alfa1'
c      print 71,apr,(alfa1(i),i=1,n)

      apr='alfa2'
c      print 71,apr,(alfa2(i),i=1,n)

      apr='alfa3'
c      print 71,apr,(alfa3(i),i=1,n)

      do i=2,n1

         a(i)=(1-ktor1)*fi_dot(i)*alfa1(i)*dh2(i)*alfa3(i)/ha(i)+
     *  teta(i)*gk(i)/ha(i)

         c(i)=-(1-ktor1)*fi_dot(i)*alfa1(i)*dh1(i)*
     *  alfa3(i+1)/ha(i+1)+
     *  teta(i)*gk(i+1)/ha(i+1)

         b(i)=

     *  -(1-ktor1)*fi_dot(i)*alfa1(i)*dh2(i)*alfa3(i)/ha(i)
     *  -teta(i)*gk(i)/ha(i)

     *  +(1-ktor1)*fi_dot(i)*alfa1(i)*dh1(i)*alfa3(i+1)/ha(i+1)
     *  -teta(i)*gk(i+1)/ha(i+1)

         xx=alfa1(i)*( dh2(i)*alfa2(i)+dh1(i)*alfa2(i+1) )

         xx_r=( dh2(i)*alfa2(i)+dh1(i)*alfa2(i+1) )

         b(i)=b(i)+xx/tay_s

         b_temp(i)=xx/tay_s

c  Right Hand Side== 4*pi/10*<J>*f*spo*rs0
         
         fdm(i)=( dh2(i)*fj(i)*alfa3(i)+
     *   dh1(i)*fj(i+1)*alfa3(i+1) )

         right=ktor1*fi_dot(i)*alfa1(i)*dh2(i)*alfa3(i)/ha(i)*
     *   (dm0(i)-dm0(i-1))+
     *   ktor1*fi_dot(i)*alfa1(i)*dh1(i)*alfa3(i+1)/ha(i+1)*
     *   (dm0(i+1)-dm0(i))

         fm(i)=dmn(i)*xx/tay_s+fdm(i)+right


      end do

      apr='dmn'
c      print 71,apr,(dmn(i),i=1,n)

      apr='a'
c      print 71,apr,(a(i),i=1,n)

      apr='b_temp'
c      print 71,apr,(b_temp(i),i=1,n)

      apr='b'
c      print 71,apr,(b(i),i=1,n)

c      stop

      apr='c'
c      print 71,apr,(c(i),i=1,n)

      apr='fm'
c      print 71,apr,(fm(i),i=1,n)


      apr='q'
c      print 71,apr,(q(i),i=1,3)



c  coefficients for axis


c  condition is x1*dm0(1)+x2*dm0(2)=x3      

c      print *,'um spo(2) ha(2) ==',um,spo(2),ha(2)

      i_ax=1
      al_cur=1.

      x1=sig0(1)/(tay_s*um)+al_cur*c2(2)/(0.25*spo(2)*ha(2)**2)
      x2=-al_cur*c2(2)/(0.25*spo(2)*ha(2)**2)

      x3=dmn(1)*sig0(1)/(tay_s*um)+coef_i*aj0_help(2)

c  NO AUXILIARY      x3=dmn(1)*sig0(1)/(tay_s*um)

      cur_ax=10.d0/(4.d0*pi)*x2*(dm0(2)-dm0(1))
      
c      print *,' cur_ax x1 x2 x3==',cur_ax,x1,x2,x3a

c      print *,' cur_aux ==',(aj0_help(i),i=2,5)

      c_coef=0.5d0

c      x1=c_coef*alfa1(1)*alfa2(2)/tay_s*(0.5*ha(2)**2)-gk(2)

c      x2=gk(2)

c      x3=( dmn(1)*c_coef*alfa1(1)*alfa2(2)/tay_s+c_coef*
c     * fj(2)*alfa3(2) )*(0.5*ha(2)**2)


c      CALL TOKK(N,RS0)

c      stop

      
      alf(1)=-x2/x1

      bet(1)=x3/x1


c  coefficients for boundary



c  condition is dm0(n-1)=alf(n-1)*dm0(n)+bet(n-1)

      if(ntay.le.next)then
      
      alf(n-1)=1.

      bet(n-1)=4.*pi/10.*tpl*ha(n)/c2(n)

c      print *,' i_ax alf bet ==',i_ax,alf(n-1),bet(n-1)
      
      else

c  condition is dm0(n-1)=alf(n-1)*dm0(n)+bet(n-1)

      x1=pll*10.d0*c2(n)/(4.d0*pi*ha(n))   

c      print *,' pll pll0 tpl0 x1 ==',pll,pll0,tpl0,x1

      alf(n-1)=(1.d0+x1)/x1

      bet(n-1)=(-dm_help(n)+udd*tay*100.d0+pll0*tpl0)/x1

      alf_b= alf(n-1)
      bet_b= bet(n-1)
      x1_b=  x1
      dm_b=  dm_help(n)



c      print *,' ntay udd alf bet ==',ntay,udd,alf(n-1),bet(n-1)
      
      end if

      do i=1,n
         y(i)=dm0(i)
      end do

c      call proga(y,a,b,c,fm,alf,bet,n,
c     *  i_ax,x1,x2,x3)


      i_b=3

      call progb(y,a,b,c,fm,alf,bet,n,
     *  i_b,x1,x2,x3)


      do i=1,n
         dm0(i)=y(i)
      end do

c  condition is dm0(n-1)=alf(n-1)*dm0(n)+bet(n-1)
      
      x_r=alf(n-1)*dm0(n)+bet(n-1)
      x_l=dm0(n-1)

c      print *,' x_l x_r==',x_l,x_r

      do i=2,n
         psi(i)=(y(i)-y(i-1))/ha(i)
         q(i)=-pfi(i)/psi(i)
!!!         q(i)=abs(q(i))
      end do


      q(1)=q(2)


	if(kpr.eq.3)then
	do i=1,6
	a_print(i)=q(i)
	end do	
	n_pr=6
	apr='q'
	num=25
c	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)
	end if


      apr='dm0'
c      print 71,apr,(dm0(i),i=1,n)

      apr='psi'
c      print 71,apr,(psi(i),i=1,n)

      apr='q'
c      print 71,apr,(q(i),i=1,n)

      tpl_dif=-c2(n)*psi(n)*10./(4.*pi)



   71 FORMAT(5X,A40/,(6(1pE11.3)))

c     CALL TOKK(N,RS0)

c     stop

      coef=10./(4.*pi)

      do i=2,n
	d_pl=-(dm0(i)-dmn(i))/(tay*100.)
	d_mn=-(dm0(i-1)-dmn(i-1))/(tay*100.)

	f_pl=-(dfmax(i)-dfmax0(i))/(tay*100.)
	f_mn=-(dfmax(i-1)-dfmax0(i-1))/(tay*100.)

        volt(i)=0.5*(d_pl+d_mn)+n_pol*0.5*(f_pl+f_mn)/q(i)
        
        tok2(i)=-(dm0(i)-dmn(i))/tay_s*sig0(i)*spo(i)/vi(i)*coef


      end do


      do i=1,n
        volt_pol(i)=(dm0(i)-dmn(i))/(100.d0*tay)
      end do

      volt(1)=volt(2)

      do i=2,n-1
         xx=alfa1(i)*( dh2(i)*alfa2(i)+dh1(i)*alfa2(i+1) )
         aje(i)=xx/tay_s*(dm0(i)-dmn(i))
c
         ajf(i)=-fi_dot(i)*alfa1(i)*( dh1(i)*alfa3(i+1)*
     *  ( dm0(i+1)-dm0(i) )/ha(i+1)+
     *  dh2(i)*alfa3(i)*( dm0(i)-dm0(i-1) )/ha(i) )

c
         fj_mn=coef_i*ajb(i)*spo(i)*f(i)*rs0
         fj_pl=coef_i*ajb(i+1)*spo(i+1)*f(i+1)*rs0
         
         fbut(i)=( dh2(i)*fj_mn*alfa3(i)+
     *   dh1(i)*fj_pl*alfa3(i+1) )

         fj_mn=coef_i*aj0(i)*spo(i)*f(i)*rs0
         fj_pl=coef_i*aj0(i+1)*spo(i+1)*f(i+1)*rs0
         fuv(i)=( dh2(i)*fj_mn*alfa3(i)+
     *   dh1(i)*fj_pl*alfa3(i+1) )

      end do


c	pause

      tokel=0.
      tokfi=0.

      tokbut=0.
      tokuv=0.

      i=n
      tok_t=coef*gk(i)*(dm0(i)-dm0(i-1))/ha(i)
      tok_t=tok_t*f(n)

      do i=2,n-1

         tokel=tokel+aje(i)*coef/teta(i)*f(n)
         tokfi=tokfi+ajf(i)*coef/teta(i)*f(n)

         tokbut=tokbut+fbut(i)*coef/teta(i)*f(n)
         tokuv=tokuv+fuv(i)*coef/teta(i)*f(n)

      end do

      tok_b=0.
      s_plas=0.
      do i=2,n
         tok_b=tok_b+ajb(i)*spo(i)*ha(i)
         s_plas=s_plas+spo(i)*ha(i)
      end do

      tok=-tokel-tokfi+kbu*tokbut+kuv*tokuv
c
c      print *,'tokel tokfi bt',tokel,tokfi,bt,' kA (difmf)'
c      print *,'tokbut tok_b tokuv',tokbut,tok_b,tokuv,' kA (difmf)'
c      print *,'s_plas tok tok_t  ',s_plas,tok,tok_t,' kA (difmf)'

c--------------------------


    	a_print(1)=tokel
     	a_print(2)=tokfi
      tokel=tokel+tokfi
	a_print(3)=tok
	a_print(4)=pll
	a_print(5)=pll0

	n_pr=5

	apr='tokel tokfi tok pll pll0'

	num=30

!	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)

      apr='volt'
c      print 71,apr,(volt(i),i=1,n)

      apr='tok2'
c      print 71,apr,(tok2(i),i=1,n)

      apr='aj0'
c      print 71,apr,(aj0(i),i=1,n)

      apr='ajb'
c      print 71,apr,(ajb(i),i=1,n)

      apr='aj0_b'
c      print 71,apr,(aj0_b(i),i=1,n)

      apr='aj0_help'
c      print 71,apr,(aj0_help(i),i=1,n)

      apr='aj0_b'
c      print 71,apr,(aj0_b(i),i=1,n)

c
	do i=1,n
	dmn(i)=dm_help(i)
	end do

        udd_dif=-(dm0(n)-dmn(n))/(tay*100.)
        udd_pl=-(pll*tpl-pll0*tpl0)/(tay*100.)

c	if(next.eq.9999)udd=udd_dif-udd_pl

        udd_tot=-(pll*tpl_dif-pll0*tpl0)/(tay*100.)+udd

c        print *,' UDD_DIF UDD_TOT',udd_dif,udd_tot

c        print *,'  udd tpl_dif==',udd,tpl_dif

	do i=1,n
	a_print(i)=dm0(i)
	end do	
	n_pr=n
	apr='dm0'
	num=25
c	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)



      return
      end

