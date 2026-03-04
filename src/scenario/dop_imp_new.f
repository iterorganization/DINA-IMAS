        SUBROUTINE DOPP()

	include 'double.inc'
	include 'new_com.inc'

        call DOPP_c(
     *       pf_volts,tcam,ncam,bz_pl,zeff_a,zeff_b,tec,
     *       r_cur,z_cur,gaps,ksepa,u_1,u_kd,int_2000,int_2005,
     *       surface,zvconverter,zvresist,u_ffw,pf_turns,r_lh,
     *       elong_sep,b_cs,ulivel,coef_imp,nz_imp,volume,
     *       z_tok,zvel_tok,bpmax,pmag,psi_pf,s_plasma,t_end,
     *       key_h_to_l,psipl_av,psiext_av,vs_start,fdd,tt_dw,
     *       tt_emo,p_sep_tot,
     *       coef_imp1,nz_imp1,coef_imp2,nz_imp2,
     *       coef_imp3,nz_imp3,coef_imp4,nz_imp4,
     *       pion,palf,w_imp,
     *       dist1,dist2)

	return
	end


        SUBROUTINE DOPP_c(
     *       pf_volts,tcam,ncam,bz_pl,zeff_a,zeff_b,tec,
     *       r_cur,z_cur,gaps,ksepa,u_1,u_kd,int_2000,int_2005,
     *       surface,zvconverter,zvresist,u_ffw,pf_turns,r_lh,
     *       elong_sep,b_cs,ulivel,coef_imp,nz_imp,volume,
     *       z_tok,zvel_tok,bpmax,pmag,psi_pf,s_plasma,t_end,
     *       key_h_to_l,psipl_av,psiext_av,vs_start,fdd,tt_dw,
     *       tt_emo,p_sep_tot,
     *       coef_imp1,nz_imp1,coef_imp2,nz_imp2,
     *       coef_imp3,nz_imp3,coef_imp4,nz_imp4,
     *       pion,palf,w_imp,
     *       dist1,dist2)
     
c-------------------------------------------------
c  calculate energy confinement time and if(kpr.eq.1)print all values
c-------------------------------------------------------
	include 'double.inc'
c       implicit real*8 (a-h,o-z)
c
      include 'parf0'
      include 'parf1'
      include 'parf3'
      include 'parf8'


      dimension tcam(*),gaps(*)
      dimension pf_volts(*)
      dimension u_1(*),u_kd(*)
      dimension zvconverter(*),zvresist(*)
      dimension u_ffw(*),pf_turns(*),b_cs(*)
      dimension res(3),te_zrad(3)

      real res,te_zrad
      
      
      dimension bpmax(*)
      dimension dNB_xx(24)

c
        common
     *  /abcdx/x(kf_c),x0(kf_c),gaps0(kf_c),d_gaps(kf_c)
	common
     *  /con6/ind_r(2),ind_z(2)
     *  /con7/anom_zeff,time_anom
	common
     *  /time1e/pf_ex(kf)
	common
     *  /fluxc13/volt_sec(kf)
     *  /fluxc14/vs_pf,vs_pl,vs_tot
     *  /fluxc17/f_index



        common /temp_al/cal
	common
     *	/ge1e/rs0,tpl
	common
     *	/n_m/n,m,mp
	common
     */igr/ygr(iy,ny),tgr(ny),igr
	common
     *	/ng_igr/ng
	common
     *  /eq11/psval(npo),psval0(npo)

	common
     *	/keys4/k_ener,k_uv
     *  /keys5/next
     *  /keys9/i_d3d,i_iter,i_smal
     *  /keys11/i_ramp
     *  /keys12/i_v

        common /vic_g7_ref/g7_ref
     *	/efit0/kefit

        common
     *  /c_ramp2/rsep2,zsep2,psep2
     *  /cont21/n_ga,n_int
     *  /vic_008/rsep2_gr,zsep2_gr,rsep2_l,zsep2_l,
     *           rsep2_r,zsep2_r
     *  /vic_014/dt_term_h
     *  /vic_vs1_vs3/Curr_vs3,U_vs3,Curr_vs1,U_vs1
     *  /c_br4/wdh,p_oh
     *  /vic_016/tt_rampup
     *  /vic_017/w_fusion
     *  /vic_018/r_lh_new
c************************************************
     *  /maksim_01/tqc,emag
     *  /c_ener5/tene,ptot_dop
 
	character *10 mgr(iy),mt(iy)
	character *70 apr
	character *12 yy(iy)
	character *50 tmp
c
c
	dimension pmas(npo)
c
	common
     */pf1/npf,pf(kf),pf0(kf)
      COMMON
     */en1/PNE(npo),PD0(npo),PT0(npo),PH0(npo),
     *PDN(npo),PTN(npo),PHN(npo)
     */en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),
     *WE0(npo),WQ0(npo)
     */en4/WD0(npo),WT0(npo),WH0(npo),VD(npo),DIF(npo),
     *GGT(npo),GGTN(npo)
     */en5/SD0(npo),ST0(npo),SH0(npo)
     */en6/VN(npo)
     */en7/UD,ZD,UT,ZT,UH,ZH,LT,LD,LH,ID,IT,IH ,KTP,NNT
     */en9/QE0(npo),QQ0(npo),QDG(npo)
     */en10/GGE(npo),GGEN(npo),DXE(npo),DXQ(npo),WU(npo),
     *UG(npo),VG(npo)
     */en11/UN(4),ZN(2),LL,KEN,KEN1,KEN2,NNE
	common
     */en12/pnal(npo),pnaln(npo),zalfa,talfa
     */en13/KPIN,VPIN,ALP1,pot,skor
     */en14/EMOE,EMOQ,NDOP,QDE0(npo),QDQ0(npo)
     */en15/QNET(npo)
     */en16/QTOR(npo),QDH(npo),QpE(npo),QpQ(npo)
     */en17/QAE(npo),QAQ(npo),SAL(npo),NAL
     */en19/DD,DT,DH,SIN0,SINK,ALPY,Sss,Ppp,Eee
     */en21/qce(npo)
     */en22/XII(npo)
     */en23/kk,tn0,pna,wie(npo),wcx(npo),tn(npo),
     *pn(npo),pn0(npo)
     */en25/zhib,teoh
     */en27/NIJ
     */en28/wen1,wen2
     */en29/d_zvel
     */en31/dpsi_ax
     */en33/anom_e,anom_i,key_t11,kcchp
	common
     */ves9/tokc,tokc0
     */ves11/tokcup,tokcdw
	common
     *  /loop3/vloop,psf1a,psf1a0
     *  /loop7/vloop1,vlooppf,vloop18,vloopv,vloope,vlooppl
c
      COMMON
     */ge1/PI
     */ge2/NTAY,TAY,TT
     */ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
     */ge4/EPS1,EPS2,EPS0
     *  /ge5/kpr
     */ge6/zeff(npo),qpr(npo),ppr(npo),pr0,prg,zar
     */ge7/eu,rs,zact,eksk
     */ge8/pcch
	common
     */mid1/C1(npo),C2(npo),C3(npo)
     */mid2/VI(npo),spo(npo)
     */mid3/GRA1(npo),GRA2(npo)
     */mid5/d1,d2
	common
     */pol4/UM,VM,UK(ntet),VK(ntet)
	common
     */dfm1/UDM,ZDM,LM,SIG0
     */dfm2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)
     *  /dfm3/dfmax(npo),dfmax0(npo)
     */dfm4/Q(npo),ANU(npo),P(npo),F(npo),
     *PP(npo),PFF(npo)
     */dfm5/PT01,PT02
     */dfm7/BT,UIND
     */dfm11/c20(npo),tok1(npo),tok2(npo)
     */dfm12/betpj,dlint,bett,bet2,betpc,tk,tkp,tkf
     */dfm13/tokel,tokfi,tokbut
     *  /dfm13e/tokuv
     *  /dfm14/tokae,ajae(npo),ajae0(npo),enae
     */dfm15/uli
     */dfm17/betpi,betp2
	common
     *  /eq15/pll,zsep,rsep,zsepup,rsepup,zsepdw,rsepdw
     *  /eq23/xleft,xright
     *  /eq24/psi_ax0,psi_ax
     *  /eq25/rps(ntet),zps(ntet)
	common
     *  /cont1/vchopper(kf),veps
     *  /cont4/zpp,rpp,wvspip,zxp,elp,shepep,gapinp,dfzp,dfzp0
     *  /cont7/zp,gapin
     *  /cont11/pr1,sdiv,dfzx,dfz,dfr
     *  /cont12/zmax,zmin
     *  /cont13/zmag,zvel,delrs,delzmag
     *  /cont13e/zmag0,rmag,rmag0,rvel
     *  /cont14/p_pl,p_ves,p_pf,p_mes
     *  /cont15/p_pas
	common /pas10/c_p1,c_p2
     *  /curs1/	t_ps,t_bs,t_dia,t_beam
	common
     *  /halo4/expfg,avalb,w_h,del_r,al0
     *  /halo4e/w_h0,delaval0,pshalo0,te_h0
     *  /halo5/q_vde,q_95,del_f,i_halo
     *  /halo5e/pshalo
     *  /halo6/thalo,thalo0
c

	common /c_temp1/v_neout
	common /c_temp3/zhib_dif
	common /c_temp4/wdrp
!     *  /c_temp5/YTe,YTi,YGsep,Yne,YGsol
!     *  /c_temp6/YPsol,Ycnim,YSeng,Yqpk,Yndt

     *  /c_temp5/YMU,YPsol,YPalp,YSeng,YdNdt,YAim,Ycnim,YPedPi,
     .	YGdt,YGpuf,YGpel,YGhe,YGsol,YGsep,
     .	Ypn,Yqpk,Yndt,YnHe,Yne,YTe,YTi,
     .	yGELM,yGLFS

	common /c_temp6/wdr_d,wdr_t,WEL,wio
      common /c_teit_98/teit_98
        common /maksim_02/qtep,gfus,gamma
        common /maksim_06/r_lh_coef

	character *70 apr2

4010    format(6e12.3)



      i_en=i_en+1
      if(i_en.eq.1)then
!         open (unit=41, file='scale.dat',form='formatted')
         scale=1.
	 if(kpr.eq.1)print *,'scale',scale
!         close (41)
         
      zhib=0.45
!      zhib=0.15
	 if(kpr.eq.1)print *,'scale zhib',scale,zhib
         
         
      end if


      wdr_d=WD0(N)*2.*PI
      wdr_t=WT0(N)*2.*PI

ccccc      WDR=(WD0(N)+WT0(N)+WH0(N))*2.5
	wdre=0.
	wdrq=0.
	do i=2,n
        WDRE=WDRE+ken2*(pne(i)*TE0(i)-pne(i-1)*TE0(i-1))*vg(i)
        WDRQ=WDRQ+ken2*(pne(i)*TQ0(i)-pne(i-1)*TQ0(i-1))*vg(i)
	end do

	wdr=2.5*ug(n)
      WDRE=WDRE+WDR*0.5*(TE0(N-1)+TE0(N))
      WDRQ=WDRE+WDR*0.5*(TQ0(N-1)+TQ0(N))


      WELT=2.*PI*WE0(N)/VN(N)*VI(N)
      WIOT=2.*PI*WQ0(N)/VN(N)*VI(N)
      WELP=2.*PI*WDRE/VN(N)*VI(N)
      WIOP=2.*PI*WDRQ/VN(N)*VI(N)
      WEL=WELT+WELP
      WIO=WIOT+WIOP
      WEN2=0.
c-------
      WEN_e=0.
      WEN_i=0.
c------
      QEN2=0.
      PNOR=6.25E8
      WAE=0.
      WAQ=0.
      WPE=0.
      WPQ=0.
      WTOR=0.
      WDH=0.
      WDE=0.
      WDQ=0.
      WNET=0.
      PPch=0.
	pion=0.

	palf=0.

      VV=0.
	wtec=0.
	wtqc=0.
      TEC=0.
      TQC=0.
      PHH=0.
      WEE=0.
      WQW=0.
      PRIM=0.
	wion=0.
	wper=0.
	pist=0.
	QC=0.

	zeff_avr=0.

      DO 11 I=2,N

      DQD=PI*VI(I)*HA(I)

!	if(i.eq.n)
!     *DQD=PI*VI(I)*HA(I)*0.5
 
      PHH=PHH+DQD*(PH0(I)+PH0(I-1))
      QC=QC+DQD*2.*QCE(I)
      WAE=WAE+DQD*2.*QAE(I)
      WAQ=WAQ+DQD*2.*QAQ(I)
      WPE=WPE+DQD*2.*QpE(I)
      WPQ=WPQ+DQD*2.*QpQ(I)
      WTOR=WTOR+DQD*2.*QTOR(I)
      PRIM=PRIM+DQD*2.*QPR(I)
      WION=WION+DQD*2.*WIE(I)
      WPER=WPER+DQD*2.*WCX(I)
      WDH=WDH+DQD*2.*QDH(I)
      WDE=WDE+DQD*2.*QDE0(I)
      WDQ=WDQ+DQD*2.*QDQ0(I)
      WNET=WNET+DQD*2.*QNET(I)
      WEN2=WEN2+DQD*(TE0(I)+TQ0(I)+TE0(I-1)+TQ0(I-1))*
     *1.5*0.5*(PNE(I)+PNE(I-1))
c--------
      WEN_e=WEN_e+DQD*( TE0(I)+TE0(I-1) )*
     *1.5*0.5*(PNE(I)+PNE(I-1))
      WEN_i=WEN_i+DQD*(TQ0(I)+TQ0(I-1))*
     *1.5*0.5*(PNE(I)+PNE(I-1))
c---------
      QEN2=QEN2+1.0*DQD*2*(QE0(I)+QQ0(I))

      TQC=TQC+PI*(TQ0(I)+TQ0(I-1))*VI(I)*HA(I)
      TEC=TEC+PI*(TE0(I)+TE0(I-1))*VI(I)*HA(I)

ccc	wtec=wtec+dqd*(te0(i)+te0(i-1))*0.5*(pne(i)+pne(i-1))
ccc	wtqc=wtqc+dqd*(tq0(i)+tq0(i-1))*0.5*(pne(i)+pne(i-1))

      PPch=PPch+PI*(PNE(I)+PNE(I-1))*VI(I)*HA(I)
	pion=pion+dqd*(pd0(i)+pd0(i-1)+pt0(i)+pt0(i-1)
     *+ph0(i)+ph0(i-1))

	palf=palf+dqd*(pnal(i)+pnal(i-1))
	
	zeff_avr=zeff_avr+zeff(i)*2.*PI*VI(I)*HA(I)

	pist=pist+dqd*2.*(sd0(i)+st0(i)+sh0(i))
   11 VV=VV+VI(I)*HA(I)
      IF(NTAY.EQ.0)QEN1=QEN2
      VV=2.*PI*VV

c	tec=wtec/ppch
c	tqc=wtqc/ppch

      TQC=TQC/VV
      TEC=TEC/VV

      PCch=PPch/VV
      pion=pion/VV
      palf=palf/VV
      zeff_avr=zeff_avr/VV

      WNET=WNET/PNOR
      SUMN=SUMN+TAY*WNET*1.E-3
      WEN2=WEN2/PNOR
c-----
      WEN_e=WEN_e/PNOR
      WEN_i=WEN_i/PNOR
c----
      QEN2=QEN2/PNOR


       WAE=WAE/PNOR
	qc=qc/pnor
      WAQ=WAQ/PNOR
      WPE=WPE/PNOR
      WPQ=WPQ/PNOR
      WTOR=WTOR/PNOR
      WDH=WDH/PNOR
      PRIM=PRIM/PNOR
      WION=WION/PNOR
      WPER=WPER/PNOR
      WDE=WDE/PNOR
      WDQ=WDQ/PNOR
	ptot=(wae+waq+wde+wdq+wpe+wpq)

	ptot_ion=(waq+wdq+wpq)

	ptot=ptot+abs(wdh)

c        print*,'ptot wdh',ptot,wdh
c        read(*,*)

	if(abs(ptot).lt.1.e-5)ptot=1.e-5
      WW1=1.5*0.5*(TE0(N)+TE0(N-1))*UG(N)
      WW2=1.5*0.5*(TE0(N)+TE0(N-1))*UG(N)
      WEL=WEL/PNOR
      WIO=WIO/PNOR
      WELT=WELT/PNOR
      WIOT=WIOT/PNOR
      WELP=WELP/PNOR
      WIOP=WIOP/PNOR
c--------------------------
c*** [wen2] is in kJ >>>>>>>>> [qen2] is in MW
c here balance of heat---(wen2-wen1)/tay=qen2-wel-wio
	wb_l=(wen2-wen1)/tay
	wb_r=qen2-wel-wio

        if(kpr.eq.1)print*,'!!!ntay wen2',ntay,wen2

	if(kpr.eq.1)print *,' welt welp wiot wiop==',
     *  welt,welp,wiot,wiop
	if(kpr.eq.1)print *,' wen2 wen1 tay=======',wen2,wen1,tay
	if(kpr.eq.1)print *,' qen2 wel wio=======1)',qen2,wel,wio
	if(kpr.eq.1)print *,' wb_l wb_r ken2=======',wb_l,wb_r,ken2
	if(kpr.eq.1)print *,' anom_zeff prim=======',anom_zeff,prim

	if(kpr.eq.1)print *,' palf pion ',palf,pion

!      if(ntay.gt.next)zeff_a=zeff_avr
      zeff_a=zeff_avr
	if(kpr.eq.1)print *,' zeff_a zeff_avr',zeff_a,zeff_avr


c*** Power across separatrix with thermoconductivity + dQ/dt, MW
c!!!!!!!        p_sep=qen2-(wen2-wen1)/tay
        p_sep=qen2
        p_sep_tot=p_sep-(wen2-wen1)/tay

c*** Here in MW ***
	wsum=wnet+wel+wio+wtor+qc+prim
	wl=wtor+qc+prim
	wa=wae+waq
	wtp=wel+wio
	if(kpr.eq.1)print *,' Q_el  Q_ion  Q_lin',wel,
     *	wio,wl

        if(kpr.eq.1)print*,'wae waq',wae,waq


        WEN1=WEN2
c$
        tene=1.
        tene_e=1.
        tene_i=1.
        if(k_ener.eq.1)	then
           tene=wen2/(welt+wiot+1.e-8)
           tene_e=wen_e/(welt+1.e-8)
c	tene_e=400.
           tene_i=wen_i/(wiot+1.e-8)


        end if

c#
c------
	if(kpr.eq.1)print *,' *** tene tene_e tene_i ',tene,tene_e,tene_i

      if(tene.gt.10.e3)then
      tene=10.e3
	if(kpr.eq.1)print *,' *** tene tene_e tene_i ',tene,tene_e,tene_i
      end if

c----------------------------------------------------
c	talfa=0.2*dabs(tene)
	talfa=3.0*dabs(tene)
c==========================================================================
c-- teKA=0.067*I^0.85*P^-0.5*R_0^0.85*a^0.3*k^0.25*n_20^0.1*B_0^0.3*A_i^0.5
	pot=0.5*(2.+3.)
c    pot=0.5*(mD+mT)
	duh1=0.001**0.85*0.01**0.85*0.01**0.3*0.1**0.1*0.1**0.3*1.e3
	alfa1=0.067*duh1*tpl**0.85*rs**0.85*eu**0.3*eksk**0.25*pcch**0.1*
     *  bt**0.3*pot**0.5
c---------> KEY ''all'' teka
	teka=alfa1**2/wen2
ccc        teka=alfa1/sqrt(qen2+1.e-8)

	duh2=0.001**0.85*0.01**1.2*0.01**0.3*0.1**0.1*0.1**0.2*1.e3
	alfa2=0.048*duh2*tpl**0.85*rs**1.2*eu**0.3*eksk**0.5*pcch**0.1*
     *  bt**0.2*pot**0.5
c-----> ITER scaling teit

	teit=alfa2**2/wen2

c!!!	teit=alfa2**2/wen_e

	teit_l=alfa2/sqrt(ptot)
c       teit=alfa1/sqrt(qen2+1.e-8)
c
	duh3=0.001**1.24*0.01**1.65*0.01**(-0.49)*
     *  0.1**0.26*0.1**(-0.09)*1.e3
	alfa3=0.055*duh3*tpl**1.24*rs**1.65*eu**(-0.49)*
     *  eksk**0.28*pcch**0.26*
     *  bt**(-0.09)*(pot/1.5)**0.5
c----> key-goldtstone scaling L-mode tekg
c       tekg=alfa3/qen2**0.58
	tekg=(alfa3/wen2**0.58)**(1./0.42)
c
	duh4=0.001*0.01**1.75*0.01**(-0.37)*1.e3
	alfa4=0.037*duh4*tpl*rs**1.75*eu**(-0.37)*eksk**0.5*(pot/1.5)**0.5
c------>  Goldstone scaling L-mode
c       tego=alfa4/sqrt(qen2)
	tego=alfa4**2/wen2
c---->  Lackner-Gottardi Scaling For Low Aspect Ratios
	epi=eu/rs
	delta=sqrt(2.*epi/(1.+epi))
	telg=0.21*(tpl*1.e-3)**(4./5.)*(pcch*0.1/ptot)**(3./5.)*
     *  q(n)**(2./5.)*(rs*1.e-2)*(eu*1.e-2)**(6./5.)*eksk**(7./5.)/
     *  ( delta**(8./5.)*(1.+epi)**(4./5.)*(1.+eksk**2)**(4./5.) )
c anomalous factor anom_e for electrons ...
	telg=telg*1.e+3
c==========================================================================
	te11=3.5e-5*(eu/rs)**0.25*q(n)*pcch*rs**3/sqrt(tec)
	if(kpr.eq.1)print *,' ** telg ptot anom_e anom_i**',telg,ptot,anom_e,anom_i


c---->  ITER (Scaling L-mode,95) tay95=0.023*Ip**0.96*R**1.89*a**(-0.06)*
c   n_e**0.4*B_t0**0.03*k**0.64*A_i**0.2*P**(-0.73)
  	
  	  p_sep_a=abs(p_sep)
  	  
        if(ntay.lt.3)then
        p_sep_a=1.d0
        end if

        if(ntay.gt.30)then
        teit_95=0.023*(tpl*1.e-3)**(0.96)*(rs*1.e-2)**(1.83)*
     *  (eu/rs)**(-0.06)*(pcch)**(0.4)*(bt*0.1)**(0.03)*
     *  eksk**(0.64)*pot**(0.2)/(p_sep_a)**0.73*1000.
c!!!!!     *  eksk**(0.64)*pot**(0.2)/(wen2)**0.73*1000.

c!!!!!        TEIT_95=TEIT_95**(1./(1.-0.73))
        end if

c----> ITER (Scaling H-mode,98) tay98=0.0562*Ip**0.93*B_t0**0.15*
c     P**(-0.69)*n_e**0.41*A_i**0.19*R**1.97*eps**0.58*k_a**0.78
cccc      k_a=S/(pi*a**2)

        if(ntay.gt.30)then
        eksk_a=surface/(pi*eu*eu)*1.e4
        if(kpr.eq.1)print*,'eksk_a=',eksk_a
        teit_98=0.0562*(tpl*1.e-3)**(0.93)*(bt*0.1)**(0.15)*
     *  (pcch)**(0.41)*pot**(0.19)*(rs*1.e-2)**(1.97)*
c!!!!!     *  (rs/eu)**(0.58)*(eksk_a)**0.78/(wen2)**0.69*1000.     
     *  (eu/rs)**(0.58)*(eksk_a)**0.78/(p_sep_a)**0.69*1000.     

c!!!!!        TEIT_98=TEIT_98**(1./(1.-0.69))
        end if

c-----> P_LH power threshold  P_LH=2.84*A_i**(-1)*B_t0**0.82*
c       (0.1*n_e)**0.58*R*eu**0.81, MW

        p_lh=2.84/pot*(bt*0.1)**(0.82)*(0.1*pcch)**0.58*
     *  (rs*1.e-2)*(eu*1.e-2)**0.81
        r_lh=p_sep_a/p_lh
        

c------>  NEO-Alcator teoh
c!!!	teoh=7.e-6*pcch*rs*rs*eu*q(n)
c	teoh=50.

c*** neo-Alcator in October 1999 in Naka !!!
        pe_crit=0.65*pot**0.5*(bt*0.1)/(q(n)*rs*1.e-2)*10.
        teoh=0.07*(rs*1.e-2)**2.*(eu*1.e-2)
     *       *(pe_crit/10.)*q(n)*eksk**0.5*1000.

c*** JET Ohmic scalling >>>>>>> June 2000 in Naka !!!
	gamma=(pcch/10.)*pi*eu**2*1.e-4/(tpl/1.e3)
        teoh=0.14*eksk*(eu*rs*1.e-4)*(bt*0.1)**1.1*gamma/
     *       (1.+0.64*(bt*0.1)*eksk**2*gamma**2)*1000.


           if(kpr.eq.1)print*,'rs eu q(n) eksk',rs,eu,q(n),eksk
           if(kpr.eq.1)print*,'tt pcch pe_crit',tt,pcch,pe_crit
           if(kpr.eq.1)print*,'qen2 wen2 wen1',qen2,wen2,wen1

        if(kpr.eq.1)print*,'p_sep p_lh',p_sep,p_lh
        if(kpr.eq.1)print*,'p_sep_a',p_sep_a
        if(kpr.eq.1)print*,'teit_98 teit_95 teoh',teit_98,teit_95,teoh
c        pause 'from dop_port'

c****************************************
c	tepr=teoh
c        if(tt.gt.100.e3)tepr=teit_95
c        if(tt.gt.100.e3.and.r_lh.gt.1)tepr=teit_98
c**************************************       
	tepr=teoh
c!!!!!        if(tt.gt.100.e3*scale)then
c*** If Paux=wde+wdq > 3 MW L-H scaling is used
        if((wde+wdq).gt.3.)then
c#####           teit=teit_95
           tepr=amin1(teit_95,teoh)
c#####           if(r_lh.gt.1)teit=teit_98
           if(r_lh.gt.r_lh_coef)tepr=teit_98
c*** f_t is correction function for teoh !
           tt3=tt*1.e-3
           f_t=19.-0.18*tt3
           if(f_t.lt.1.e-5)f_t=0.
c*** teit_95 and teit_98 are not 0 if ntay > 30 !!!
c#####           if(ntay.gt.31)tepr=(f_t/teoh**2+1./teit**2)**(-0.5)
		if(ntay.le.30)tepr=teoh
        end if



		if(key_t11.eq.2.or.key_t11.eq.3)then

		if(r_lh_new.ge.r_lh_coef.and.tt.gt.tt_rampup)then
		k_r_lh_new=1
		end if

		if(k_r_lh_new.eq.1)then
		tepr=teit_98
		else
!		tepr=teit_95
        tepr=0.5d0*teit_98
        end if

        p_aux=(wde+wdq)

		if(k_r_lh_new.eq.1.and.p_aux.le.1.d0)then
!		tepr=teit_95
        tepr=0.5d0*teit_98
        end if


        print*,' r_lh_new k_r_lh_new p_aux',
     *  r_lh_new,k_r_lh_new,p_aux

        print*,' teit_98 teit_95 tepr',
     *  teit_98,teit_95,tepr

        end if

  		if(ntay.le.30)tepr=teoh
      
c!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        if(kpr.eq.1)print*,'ntay tt',tt,ntay
        if(kpr.eq.1)print*,'ppch',ppch
        if(kpr.eq.1)print*,'p_sep p_lh',p_sep,p_lh
        if(kpr.eq.1)print*,'p_sep_a ptot_ion',p_sep_a,ptot_ion

        if(kpr.eq.1)print*,'teoh r_lh teit_95 teit_98 tepr'
        if(kpr.eq.1)print*,teoh,r_lh,teit_95,teit_98,tepr
c        pause 'from dop_port'
c!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

ccc	tepr=te11
c
c        tepr=telg
c
c        if(i_iter.eq.1)tepr=teit_l

c
c----        tepr=teka
c
c        tepr=tego
c


c!!!!!!        tepr=teit_95

c        tepr=teit

	tepr=tepr/anom_e
        
        
	if(kpr.eq.1)print *,' ** teit teit_l teit_95 teoh**',
     *  teit,teit_l,teit_95,teoh

c!       if(tepr.gt.teoh)tepr=teoh

c-----
	if(ntay.lt.1)tepr=teoh

        if(tene.le.0)then
           tene=tepr
           tene_e=tepr
        end if


        zhib0=zhib

        if(ntay.gt.1.and.k_ener.eq.1.and.key_t11.eq.0)then
c!!!        zhib=zhib*(0.5+0.5*tene/tepr)

c        zhib=zhib*(0.5+0.5*tene_e/tepr)
        zhib=zhib*(0.5+0.5*tene/tepr)

c###        zhib=zhib*tene_e/tepr

        zhib=0.5*(zhib0+zhib)
        end if

        if(ntay.gt.1.and.k_ener.eq.1.and.key_t11.eq.2)then
c!!!        zhib=zhib*(0.5+0.5*tene/tepr)

c        zhib=zhib*(0.5+0.5*tene_e/tepr)
        zhib=zhib*(0.5+0.5*tene/tepr)

c###        zhib=zhib*tene_e/tepr

        zhib=0.5*(zhib0+zhib)
        end if
        
        if(ntay.gt.1.and.k_ener.eq.1.and.key_t11.eq.3)then
c!!!        zhib=zhib*(0.5+0.5*tene/tepr)

c        zhib=zhib*(0.5+0.5*tene_e/tepr)
        zhib=zhib*(0.5+0.5*tene/tepr)

c###        zhib=zhib*tene_e/tepr

        zhib=0.5*(zhib0+zhib)
        end if




        print *,' ntay k_ener key_t11==',ntay, k_ener, key_t11
        print *,' tene tepr zhib zhib0 ==',tene,tepr,zhib,zhib0


        if(kpr.eq.1)print *,' i_en zhib ==',i_en,zhib

        if(kpr.eq.1)print *,' te_ax ti_ax  ==',te0(1),tq0(1)
        if(kpr.eq.1)print *,' p_dop p_oh ==',ptot-wdh,wdh


         if(i_98_dat.eq.1)then

         if(i_en.eq.1)then
         open (unit=1,file='tau98.dat',form='formatted')
          apr2='tt[s]	tau_e tau_95 tau_98'
          write (1,*)apr2
         end if
         if(i_en.gt.1)then
         open (unit=1,file='tau98.dat',access='append',form='formatted')
         end if
         
         
      write (1,*)tt*1.e-3,tene,teit_95,teit_98
      close(1)
   


      end if
      



55      continue
        wznam=(Wde+Wdq+Wpe+wpq+wdh)
c	wznam=(Wde+Wdq+Wpe+wpq+1.e-5)
c       if(kpr.eq.1)print *,'wdh wznam',wdh,wznam
c       if(dabs(wznam).lt.1.e-10)return
c        QTEP=Wsum/wznam
ccc        QTEP=Wsum/ptot
ccc        wsum=wnet+wel+wio+wtor+qc+prim
ccc        ptot=(wae+waq+wde+wdq+wpe+wpq)
        QTEP=(wnet+wae+waq)/(wde+wdq+1.e-5)
	hii=dxq(10)*1.e3/gra2(10)
	hie=dxe(10)*1.e3/gra2(10)
	UACT=WDH/TPL*1.E3
!	if(ntay.eq.0.and.kefit.eq.2)vs=0.
c************************************
	if(ntay.le.1)vs=vs_start
c************************************
c        print*,'ntay vs_start vs kefit',
c     *  ntay,vs_start,vs,kefit
c        read(*,*)

	if(ntay.gt.2)vs=vs+uact*tay*1.e-3
        CAL=ptot/(WTOR+qc+WEL+WIO)
c$
	udd_dif=-(dm0(n)-dmn(n))/(tay*100.)
        vsur=udd_dif
c#
71 	FORMAT(20X,A6/,(12(1pE10.3)))
72 	FORMAT(5X,A60/,(1x,6(1pE11.3)))


        call w_filter(qen2)

        TENE_G=WEN2/ptot

!	if(ntay.lt.next) return

         

c***** We are calculating Nimp to obtain zeff_a we need
         nz_imp=2
!         nz_imp1=4
!         nz_imp2=74
!         nz_imp3=18
!         nz_imp4=10
        
        te_zrad(1)=tec*1.e-3

        call zrad(nz_imp,1,1,te_zrad,RES)
c*** [A]*10^-38*(MW*m3)*10^(19+19) >>> MW/m3
ccc *** Here "pcch*Nz" in fact 
        w_imp1=res(1)*pcch**2*coef_imp

        call zrad(nz_imp1,1,1,te_zrad,RES)
        w_imp2=res(1)*pcch**2*coef_imp1
        call zrad(nz_imp2,1,1,te_zrad,RES)
        w_imp3=res(1)*pcch**2*coef_imp2
        call zrad(nz_imp3,1,1,te_zrad,RES)
        w_imp4=res(1)*pcch**2*coef_imp3
        call zrad(nz_imp4,1,1,te_zrad,RES)
        w_imp5=res(1)*pcch**2*coef_imp4

        w_imp_help=w_imp1+w_imp2+w_imp3+w_imp4+w_imp5

ccc        w_imp=0.
c*** q_imp is a line losses in DINA units
c*** [W/m3]*6.25/1e4 >>>>> [DINA units] 
        q_imp1=w_imp1*1.e6*6.25e-4/pnor*vv
        q_imp2=w_imp2*1.e6*6.25e-4/pnor*vv
        q_imp3=w_imp3*1.e6*6.25e-4/pnor*vv
        q_imp4=w_imp4*1.e6*6.25e-4/pnor*vv
        q_imp5=w_imp5*1.e6*6.25e-4/pnor*vv
        
c*** >>>>> MW
c        print*,'vv in cm3',vv
c*** [w_imp]=MW
!        w_imp=w_imp*vv*1.e-6
!        w_imp=q_imp

       if(kpr.eq.1)print*,'  q_imp1 q_imp2 q_imp3',
     *  q_imp1,q_imp2,q_imp3
       if(kpr.eq.1)print*,'  q_imp4 q_imp5',
     *  q_imp4,q_imp5

       if(kpr.eq.1)print*,' coef_imp coef_imp1 coef_imp2 w_imp',
     *  coef_imp,coef_imp1,coef_imp2,w_imp
       if(kpr.eq.1)print*,' coef_imp3 coef_imp4',
     *  coef_imp3,coef_imp4
     
c        read(*,*)


ccc!!!!!!!       if(ksepa.eq.1)then 
        call  min_dist(dist_min_xx,Rdist_min_xx,Zdist_min_xx)
        call min_dist_pfw(dNB_xx)
c!!!!!!!!!        end if

	igr=1
	tgr(igr)=tt
	if(kpr.eq.1)print *,' IGR   TT ------------------------',tt
c
ccc	include 'dop_smal.inc'
c	include 'dop_tsp.inc'
c	tmp='na_smal'
c	include 'dop_ramp.inc'

      YPsol=p_sep_a

      if(i_en.ge.1)then
	if(kpr.eq.1)print *,' i_en   dop_vs_pfw_1.inc ',i_en
	
	include 'dop_vs_pfw_1.inc'
	end if
	

!	include 'dop_vs2.inc'

ccc	include 'aaa.inc'
	tmp='na_ramp'

c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if(key_help.eq.0)key_h_to_l=0
c        if(tt.gt.tt_emo.and.p_sum/p_hl.le.1)then
c           key_help=1
c           key_h_to_l=1
c        end if

        if(ntay.gt.5.and.tt.gt.tt_dw+dt_term_h)then
           key_help=1
           key_h_to_l=1
        end if

c        print*,'from dop ntay=',ntay
c        print*,'key_help key_h_to_l',key_help,key_h_to_l
c        read(*,*)

c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		if(i_en.eq.1)then
	open (unit=41, file=tmp,form='formatted')
	write (41,*)ng
	do i=1,ng
	write (41,*)yy(i)
	end do
	close (41)
	end if

      RETURN
      END







