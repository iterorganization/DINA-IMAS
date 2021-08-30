

      subroutine en_01()
      include 'double.inc'
      include 'new_com.inc'
      include 'br_com.inc'

      call en_01_c(n_rad,
     * tay,kpr,n_e,n_e0,n_d,n_d0,n0,n00,T_e,T_e0,T_i,T_i0,
     * pi,a_min,R_maj,tt,n_i,n_i0,
     * I_p,I_p0,p_oh,p_cx,p_ioniz,p_rad,q_ech,z_eff,v_v0,v_p,
     * sel,v_n,p_lambda,r_pl0,v_v00,tay_ee,
     * tpl,eu,rmag,alf_n,tay_lo,v_p0,anom_e,g_v,
     * vloop,uact,betj,k_dm0,g_v0,q(n))


c----------------------
c----------------------
c----------------------

      return
      end
      subroutine en_01_c(n,
     * tay_old,kpr,n_e,n_e0,n_d,n_d0,n0,n00,T_e,T_e0,T_i,T_i0,
     * pi,a,R,tt,n_i,n_i0,
     * I_p,I_p0,p_oh,p_cx,p_ioniz,p_rad,q_ech,z_eff,v_v0,v_p,
     * sel,v_n,p_lambda,r_pl,v_v00,tay_ee,
     * tpl,eu,rmag,alf_n,tay_lo,v_p0,anom_e,g_v,
     * vloop,uact,betj,k_dm0,g_v0,q_b)

      include 'double.inc'

      include 'parf0'

      include 'double_break1.inc'


      include 'parf3'

      common
     *	/igr/ygr(iy,ny),tgr(ny),igr
      common
     *	/ng_igr/ng

	common /c_imp_out2/qlos_e,qlos_imp,qloss_ion

	common /c_neut1/p_n0
	common /c_neut2/pn_prog

       dimension denz(2),
     * rin_zog(2),rre_zog(2),rcx_zog(2)


      dimension sel(*)

	character *12 yy(iy)
	character *50 tmp


!       Only one dimension remains...

	n=1


      tay=tay_old*1.e-3

      time=time+tay*1.e3

      alfa=1.5*1.6e-2

	alfa_rus=0.1d0

c      alfa=1.5

c  Plasma volume...



c      U=100.
      i_en=i_en+1
      if(i_en.eq.1)then


c	print *,' file in.dat is reading'

	open (unit=41,file='in.dat',form='formatted')
        read (41,*)U
        read (41,*)tay_ee
        read (41,*)tay_ei
        read (41,*)alf_n
        read (41,*)p
        read (41,*)R
        read (41,*)a
        read (41,*)R_ves
        read (41,*)a_ves
        read (41,*)e_ves
        read (41,*)Z
        read (41,*)psi_n
        read (41,*)I_p
        read (41,*)T_e
        read (41,*)T_i
        read (41,*)gam
        read (41,*)elong
        read (41,*)Bt
        read (41,*)i_temp
        read (41,*)alfa_loss
        read (41,*)g_gain
        read (41,*)tay_lo


	t_a=tay_ei
	 

        close (41)

      i_new=0
      if(i_new.eq.1)then
	open (unit=41,file='init.dat',form='formatted')
        read (41,*)p
        read (41,*)T_e
        read (41,*)T_i
        read (41,*)gam
        read (41,*)g_gain
        close (41)
      end if
      



	r=rmag*1.e-2
	a=eu*1.e-2



      end if


c	print *,' elong BT=',elong,bt
c	print *,' G_v psi_n=',G_v,psi_n
	if(kpr.eq.1)print *,' anom_e alfa_loss=',anom_e,alfa_loss

c	read (*,*)


c      R=1.

c      a=0.2

	r=rmag*1.e-2
	a=eu*1.e-2

	call r_filter(r)
	call a_filter(a)

	if(kpr.eq.1)print *,' r a =',r,a
	if(kpr.eq.1)print *,' tpl elong=',tpl,elong


      V_p=2.*pi*R*pi*a**2*elong

 


c      G_v=0.

c      psi_n=1.
!!      psi_n=0.5

c  Vessel volume...

c      R_ves=1.
c      a_ves=0.5
c      e_ves=3.


c------------------------------------

      V_v=2.*pi*R_ves*pi*a_ves**2*e_ves

c	print *,' r a elong ==',r,a,elong

	if(kpr.eq.1)print *,' v_p v_v ==',v_p,v_v

c-----------------------------------

      P_rad_z=0.

c      print *,' a R V_p V_v v_v0',a,R,V_p,V_v,v_v0

c      p=20.e-3   !pressure in Pa

      E=U/(2.*pi*R)


      I_r=0.

c     equations...

c     T_e
c
c     3/2*d(n_e*T_e)/dt=P_oh+P_ecrh-P_del-P_ioniz-P_rad-3/2*n_e*T_e/tay_ee
c
c     T_i
c
c     3/2*d(n_i*T_i)/dt=P_del-P_cx-3/2*N_i*T_i/tay_ei
c
c     P_oh=(I_p-I_r)**2*R_pl/V_p
c
c     R_pl=sig*2*R/a**2
c
c     sig=1.65e-3*Zeff*ln(L)/T_e**1.5+2.7*n0/n_e
c
c     P_ech=Q_ech/V_p
c
c     P_del=0.24*(T_e-T_i)/T_e**1.5*n_e*n_d*(1/A_d+Z**2*gamma_z/A_z)*Ln(L)
c
c     P_rad=P_rad_d+P_rad_z
c
c     P_ioniz=1.6e18*V_n/V_p*n0*n_e*S_iz*W_d
c     W_d=0.03 KeV
c
c     S_iz=S_ip+S_iT
c     S_ip=4.6e-17*E/p*dexp(-93.77*p/E)
c     S_iT=2e-14*sqrt(T_e/Ry)*dexp(-Ry/T_e)/(6.+T_e/Ry)
c

c
c     P_cx=2.4e18*n0*n_d*V_n/V_p*(T_i-T0)*S_cx
c     S_cx=1.e-13*T_i**0.327
c
c
c     V_p=2*pi**2*a**2*R
cc
c
c     Ry=0.0136KeV
c
c     T0=2.59e-5KeV
c
c     Ln(L)=16.1+ln(T_e/sqrt(n_e)/Zeff) T_e > 0.05KeV
c
c     Ln(L)=17.6+ln(T_e**1.5/sqrt(n_e)/Zeff) T_e < 0.05KeV
c
c     gamma_Z=n_Z/n_d
c
c     n_i=n_d*(1.+gamma_Z)
c
c     n_e=n_d*(1+Z*gamma_Z)
c     
c     Zeff=(1+Z**2*gamma_Z)/(1.+Z*gamma_Z)
c
c     particle balance
c
c     V_p*d(n_d)/dt=n0*n_e*S_iz*V_n-n_d*V_p/tay_p
c
c     (V_v+V_n-V_p)*d(n0)/dt=psi_n*n_d*V_p/tay_p-n0*n_e*S_iz*V_n+G_v*V_v
c
c     G_v  gas puff velocity
c
c     psi_n recycling coeff
c
c     V_v vessel volume
c

c     

      if(i_en.eq.1)then


      V_n=V_p
      V_v0=(V_v+V_n-V_p)


c     following reading necessary only once
c	call readmc_y
c        call readehr1_y 

       L_p=4.*pi*R*(dlog(8.*R/a)-1.5)/10.

	 pll0=L_p

c       pll*tpl*1.e-5  V*S== pll*I_p*1.e3*1.e-5=pll*I_p*1.e-2

c      gamma_Z=1.e-2

c      Z=6.

!!!      Zeff=(1.+Z**2*gamma_Z)/(1.+Z*gamma_Z)

      Z_eff=1.

      W_d=0.03 

      Ry=0.0136

c  temporarily...
ccc      W_d=Ry 


      n0=4.8*p

	n0_in=n0

	p_n0=n0


c      gam=1.e-3


      n_e=gam*n0

      n_d=n_e

      n_i=n_d

	i_min=0
	if(i_min.eq.1)then
	call dens_01_min()
	end if

c      print *,' n_i n_e n_d ',n_i,n_e,n_d

c      print *,' T_i T_e  ',T_i,T_e

      n_tot0_in=n_d*V_p+n0*V_v0
	v_v0_in=v_v0

c  From previous time step
         
      
	call time_step_00()

	return

      end if

	if(i_min.eq.1)then
	call dens_01_min()
	end if

	pll0=L_p

      L_p=4.*pi*R*(dlog(8.*R/a)-1.5)/10.
	zeff=z_eff

c      print *,' Zeff sel ',Zeff,sel(1)*1.d-4*16.d0


!!!	return


c  Given n_d....

!!!      n_i=n_d   !( From Outside)

!!!      n_e=n_d   !( From Outside)

c      print *,' time n_i n_e n_d ',time,n_i,n_e,n_d
c      print *,' T_e T_i ',T_e,T_i

      if( T_e .gt. 0.05d0 )then
         qlog=16.1d0+dlog(T_e/sqrt(n_e)/Zeff) 
      else
         qlog=17.6d0+dlog(T_e**1.5d0/sqrt(n_e)/Zeff) 
      end if
      
c      qlog=10.

      A_d=2.d0

!      delta=0.245d0/A_d*qlog*zeff

      delta=0.245d0/A_d*qlog

c	call print2(' delta zeff==',delta,zeff)

c      delta=0.24/A_d*qlog
c      delta=0.
   
      p_cur=n0/4.8d0

      S_ip=4.6d-17*E/p_cur*dexp(-93.77d0*p_cur/E)

      p_torr=p_cur/133.3d0

      tay_ion1=43.d0*(E/p_torr)*510.d0*p_torr*Dexp(-1.25d4*p_torr/E)

      tay_ion=1.d0/tay_ion1

      tay_ion_o=1.d0/(S_ip*1.d20*n0)

      v_de=43.d0*E/p_torr

      alf=510.d0*p_torr*Dexp(-1.25d4*p_torr/E)

      tay_i=1.d0/(v_de*alf)

      tay_br=dlog(0.1d0/1.d-4)*tay_i

c      print *,' v_de alf tay_i tay_br',v_de,alf,tay_i,tay_br

      S_iT=2.d-0*sqrt(T_e/Ry)*dexp(-Ry/T_e)/(6.d0+T_e/Ry)

      S_iz1=S_ip+S_iT
      S_iz=S_iT

c      print *,' qlog U p_torr ',qlog,U,p_torr
 
c      print *,' S_ip S_iT S_iz ',
c     *  S_ip,S_iT,S_iz
c      print *,' tay_ion1 tay_ion_o',
c     *  tay_ion,tay_ion_o

      S_cx=1.d-0*T_i**0.327d0

c      print *,' T_i ',t_i


c*** That is 300K
      T0=2.59d-5
	a_d=2.d0

	v0=4.38e5*sqrt(t0/a_d)

c             NEW modifications for v_n --------
c       ------ ---- ----

c      x=2*lambda_i/a,  lambda_i= v0/( n_e*S_iz)



c-------------------------------------


	tay_iz=1.d0/(n_e*S_iz*1.e7)

	p_lambda=v0/(n_e*S_iz*1.e7)

      if(kpr.eq.1)print *,' v0  p_lambda',v0,p_lambda

	x=2.d0*p_lambda/a

c	x_coef=100.

c	x=x*x_coef

c	print *,' p_lambda v0 t0',p_lambda,v0,t0
c	print *,' tay_iz x ',tay_iz,x

	

	if(x.le.1.d0)then
      V_n=V_p*x
	end if

!!!      G_v=0.

!!!      psi_n=1.

      V_v0=(V_v+V_n-V_p)

c--------------------------------------------------	


      P_cx=2.4d5*n0*n_d*V_n/V_p*(T_i-T0)*S_cx


c      print *,' S_cx P_cx L_p',S_cx,P_cx,L_p

!!!      sig=1.65e-3*Zeff*qlog/T_e**1.5+2.7*n0/n_e
	
!!!	fi1=1.723*(1.13+Zeff)/(2.67+Zeff)
	 
      sig=1.65d-3*Zeff*qlog/T_e**1.5d0

      sig=SIG*1.25

      R_pl=sig*2*R/a**2

      R_1=L_p/tay

      I_p=(pll0/tay*I_p0+U)/(L_p/tay+R_pl)



	I_p=tpl*1.e-3

	if(i_min.eq.1)then
	call tay_e_ip(tay_ee,tpl200,tt)
	end if

!!!	tay_lo=tay_ee*1.d6

	u_res=I_p*R_pl

	U=(I_p*L_p-pll0*I_p0)/tay+u_res

	vloop=u
	uact=u_res


!!!      I_p=(pll0/tay*I_p0+U)/(L_p/tay+R_pl)



c      print *,' sig R_1 R_pl I_p',sig,R_1,R_pl,I_p


	pi_11=u/r_pl



c      print*,'u pi_11 =',u,pi_11
c      read(*,*)


      P_oh=(I_p-I_r)**2*R_pl/V_p

c	P_oh=0.d0

      P_ech=Q_ech/V_p


c     tay_ee     Bohm   3.e-3*a**2*Bt/Te	[s, m, T, keV]


	tay_ee1=3.e-3*a**2*Bt/T_e

c ITER-98 L-mode confinement scaling [6] is

c     tay_ee =0.023*IP**0.96*Bt**0.073*ne**0.4*Ai**0.2*R**1.83*e**-0.06*k**0.64/Qabs**0.73 
c	  [s,MA,T,1019 m-3,AMU,m,MW].

	eps=a/R

	Qabs=dabs(P_oh*V_p+q_ech)

	tay_ee2=0.023*I_p**0.96*Bt**0.073*(n_e*10.)**0.4*a_d**0.2*
     *  R**1.83*eps**(-0.06)*elong**0.64/Qabs**0.73


c	 print *,' tay1 tay2 ',tay_ee1,tay_ee2


	if(i_min.eq.-10)then
      tay_ee=dmax1(tay_ee1,tay_ee2)
      end if

	if(i_min.eq.0)then
!      tay_ee=dmax1(tay_ee1,tay_ee2)

       q_10=10.d0
!      q_10=3.d0

      d_q=1.d-1
!      d_q=2.d0


      if(q_b.gt.q_10+d_q)tay_ee=tay_ee1
      if(q_b.lt.q_10-d_q)tay_ee=tay_ee2
      if(q_b.lt.1.d0)tay_ee=tay_ee1


      if(q_b.ge.q_10-d_q.and.q_b.le.q_10+d_q)then 
!!!      fbq=5.5d0-0.5d0*q_b

!!!    f2(q) = (q0 + dq – q)/2/dq ;
      fbq=(q_10+d_q-q_b)/2.d0/d_q

      tay_ee=(1.d0-fbq)/tay_ee1+fbq/tay_ee2
      tay_ee=1.d0/tay_ee
      end if
      
!     	call print4(' q_b tay_e t_b t_L ==',
!     * q_b,tay_ee,tay_ee1,tay_ee2)

      
!!!	tay_ee=tay_ee*( I_p/1.5d0 )**0.25
	end if

      if(kpr.eq.1)	write(6,'(" q_b,tay_ee,tay_ee1,tay_ee2",
     *  6(1pe12.5))'),
     *  q_b,tay_ee,tay_ee1,tay_ee2


 !!!     if(tay_ee.gt.0.07)tay_ee=0.07


	p_pl =1.6d-2*(n_e*T_e + n_i*T_i)

	Bp = I_p/(5.d0*a)

	Bstr=.002d0 
		
	p_Bp = 0.4d0*(Bp**2+Bstr**2)

	Beta_pol = p_pl/p_Bp

	betj=Beta_pol

!!!	tay_par=0.1d0*I_p**2/betj

	tay_par=0.1d0*I_p**2

	tay_ee=tay_ee*anom_e

	tay_ei=tay_ee


c	 print *,' tay_ee tay_ei ',tay_ee,tay_ei

	tay_p=tay_ee

!!!	tay_p=1.d-3


c	tay_p=tay_ee*2.5d0


c  Particle.....
c     V_p*d(n_d)/dt=n0*n_e*S_iz*V_n-n_d*V_p/tay_p
c
c     (V_v+V_n-V_p)*d(n0)/dt=psi_n*n_d*V_p/tay_p-n0*n_e*S_iz*V_n+G_v*V_v
c
c     G_v  gas puff velocity
c
c     psi_n recycling coeff


c      print*,'psi_n n00=',psi_n,n00


	 call n_dd_read()
	  pn_prog=n_d

	g_vx=g_gain*v_v

	if(k_dm0.eq.1)then
!!!	tay_p=0.1*tay_p
	g_v=g_vx
	else
	g_v=0.d0
	end if

      a11=V_p/tay+V_p/tay_p
      a12=-n_e*S_iz*1.e7*V_n
      a21=-psi_n*V_p/tay_p+g_v*(1.d0+t_a/tay)
      a22=V_v0/tay+n_e*S_iz*1.e7*V_n

      f1=V_p0*n_d0/tay 
      f2=V_v00/tay*n00+g_v*(pn_prog+t_a/tay*n_d0)

      call mat_prep(a11,a12,a21,a22,f1,f2,x1,x2)

      p_dx=x1

	if(i_min.eq.1)then
	call dens_01_min()
	end if

	if(i_min.eq.0)then
	n_d=x1
      n0=x2
	p_n0=n0
	end if


	if(i_min.eq.0.and.n0.lt.1.d-9)then
      n0=1.d-9
	n_d=(f1-a12*n0)/a11
	end if


c	call n_i_filter(n_d)


!!!	g_vx=g_gain*v_v*(n_d-pn_prog)

	g_vx=g_gain*v_v*( (n_d-pn_prog)+t_a*(n_d-n_d0)/tay )

c-------------------
	g_vvx=g_gain*v_v*t_a*(n_d-n_d0)/tay 

	if(k_dm0.eq.1)then
	g_v=g_vx
	call n0_filter(n0)
	p_n0=n0
	call n_i_filter(n_d)
	else
	g_v=0.d0
	end if

	if(kpr.eq.1)print *,' k_dm0 g_v =',k_dm0,g_v

	pk_dm0=k_dm0
!	call print4(' g_v g_vvx n_d n_prog ==',g_v,g_vvx,n_d,pn_prog)

c	stop

      pn_tot_0=n_d0*V_p+n00*V_v00
      n_tot=n_d*V_p+n0*V_v0

c	call print2(' n_tot n_tot_0 ==',n_tot,pn_tot_0)

      if(kpr.eq.1)print *,' -n_d0 n00 ',n_d0,n00

      if(kpr.eq.1)print *,' -n_tot n_tot_0 ',n_tot,pn_tot_0
      if(kpr.eq.1)print *,' -v_p V_v00  ',v_p,V_v00
      if(kpr.eq.1)print *,' -v_v0_in n0_in  ',V_v0_in,n_tot0_in
 

      n_i=n_d 

	n_i0=n_d0

c      print *,' n_d n0 ',n_d,n0

      P_rad_d=5.3d-3*n_e*n_d*T_e**0.5d0

      p_ch_1=2.4d5*n0*n_d*V_n/V_p*S_cx


      P_ioniz=1.6d5*V_n/V_p*n0*n_e*S_iz*W_d

      P_rad=P_rad_d+P_rad_z

      f1_left=V_p/tay*(n_d-n_d0)
      f2_left=V_v0/tay*(n0-n00)

      f1_right=n0*n_e*S_iz*1.e7*V_n-n_d*V_p/tay_p
      f2_right=-n0*n_e*S_iz*1.e7*V_n+n_d*V_p/tay_p


c      print *,' f1_left f1_right',f1_left,f1_right
c      print *,' f2_left f2_right',f2_left,f2_right

      s_2=-n_d*tay_p
      s_3=-n0*n_e*S_iz*1.d7

c      print *,' s_0 s1_ s_2 s_3 ',s_0,s_1,s_2,s_3


	n_states=2

	te_inp=T_e*1.e3
	tn_inp=T_i*1.e3
	nz_inp=n_states-1
	den_e=n_e*10.

	den_n=n0*10.
	denz(1)=den_n
	denz(2)=n_d*10.



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

      c_ion=svie(te_inp,den_e)
      c_rec=svr(te_inp,den_e)

	c_ex=rcx_o(tn_inp,nz_inp)
	c_ex_zog=rcx_zo(tn_inp,nz_inp)

      s_ion= S_iz
	 s_cxc=S_cx

c	write(6,'(" i s_ion c_ion rin=",
c     *  i4,6(1pe11.4))'),
c     *  i,s_ion,c_ion,rin_zog(1)


	 e_ion=13.6*den_e*den_n*alfa_rus*16.d0

c	write(6,'(" es_ion ec_ion erin=",
c     *  6(1pe11.4))'),
c     *  s_ion*e_ion,c_ion*e_ion,rin_zog(1)*e_ion



c	write(6,'(" i  c_rec rre=",
c     *  i4,6(1pe11.4))'),
c     *  i,c_rec,rre_zog(2)



c	write(6,'(" i  s_cxc,rcx c_ex c_zog=",
c     *  i4,6(1pe11.4))'),
c     *  i,s_cxc,rcx_zog(2),c_ex,c_ex_zog

	p_i_c=c_ion*e_ion


c   Energy....

!!!	qlos_imp=sel(1)*1.d-4*16.d0

	n_imp_tot=2

	qlos_imp=0.d0
	do i=1,n_imp_tot
	qlos_imp=qlos_imp+sel(i)*1.d-1
	end do


c      delta=0.
c	tay_ee=1.d-3

!!!	p_oh=0

!!!	qlos_imp=0.d0

c*** Mineev's case
      f1_1=-P_ioniz-P_rad-qlos_imp*alfa_loss

c      print *,' f1_1 qlos_e ',f1_1,-qlos_e

c*** Zogolev's case
c!!!	f1_1=-qlos_e-qlos_imp

c      print*,P_ioniz+P_rad,qlos_e
c      read(*,*)


c	f1_1=-qloss_ion
	
	int=0

11	continue	

!!!	t_e=0.5d0*(t_e+t_e0)

	del_11=delta*n_e*n_i/T_e**1.5d0*v_p
	del_12=delta/T_e**1.5d0*v_p

	del_13=T_e**1.5d0
	del_14=n_e*n_i

      a11=alfa*n_e/tay+delta*n_e*n_i/T_e**1.5d0+alfa*n_e/tay_ee

!!!      a11=a11+alfa*n_e/tay_par

      a11=a11-f1_1/T_e

c--------------------------------------------------------------------

      a12=-delta*n_e*n_d/T_e**1.5d0

      a21=a12

c     p_ch_1=0.

      a22=alfa*n_i/tay+delta*n_e*n_i/T_e**1.5d0+alfa*n_i/tay_ei+p_ch_1

c!!!      f1=P_oh+P_ech-P_ioniz-P_rad+alfa*n_e0*T_e0/tay


c	a11=a11*V_p
c	a12=a12*V_p
c	a21=a21*V_p
c	a22=a22*V_p


c      f1=(P_oh+P_ech)*v_p+v_p0*alfa*n_e0*T_e0/tay
      f1=P_oh+P_ech+alfa*n_e0*T_e0/tay


	if(kpr.eq.1)then
	write(6,'(" p_ech p_oh qlos_imp i_p",
     *  6(1pe12.5))'),
     *  p_ech,p_oh,qlos_imp,I_p
	end if

c       f2=v_p*p_ch_1*T0+alfa*v_p0*n_i0*T_i0/tay 
       f2=p_ch_1*T0+alfa*n_i0*T_i0/tay

!!!	if(i_temp.eq.1.and.i_en.gt.2)then
	if(i_temp.eq.1.and.i_en.gt.0)then

      call mat_prep(a11,a12,a21,a22,f1,f2,x1,x2)

c      print *,' x1 x2 ',x1,x2

      f1_c=a11*x1+a12*x2
      f2_c=a21*x1+a22*x2

c      print *,' f1_c f1 ',f1_c,f1
c      print *,' f2_c f2 ',f2_c,f2
      
!!!      T_e=0.5d0*(x1+t_e0)
      T_e=x1
!!!      T_i=0.5d0*(x2+t_i0)
      T_i=x2

	end if

	int=int+1



c	call print4(' te ti n_i0 i_en ==',t_e,t_i,n_i0,dfloat(i_en))
c	call print4(' n_i p_ch_1 tay_ei v_p0 ==',n_i,p_ch_1,tay_ei,v_p0)
c	call print4(' a21 a22 del_12 del_11 ==',a21,a22,del_12,del_11)
c	call print3('  del_13 del_14 int ==',del_13,del_14,dfloat(int))

c	if(int.le.3)go to 11

c      print *,' T_e0 T_i0 P_ech',T_e0,T_i0,P_ech
c       print *,' T_e T_i P_oh',T_e,T_i,P_oh
c      print *,' n_e n_i ',n_e,n_i
c      print *,' n_e0 n_i0 ',n_e0,n_i0


!!!!!!!!      n0=(n_tot0-n_d*V_p)/V_v0
      pn_tot_0=n_d0*V_p+n00*V_v0

      n_tot=n_d*V_p+n0*V_v0

c      print *,' n_tot n_tot_0 ',n_tot,pn_tot_0

      f1_left=alfa/tay*(n_e*T_e-n_e0*T_e0)
      f2_left=alfa/tay*(n_i*T_i-n_i0*T_i0)

      f1_right=-delta*n_e*n_i/T_e**1.5*(T_e-T_i)-alfa*n_e/tay_ee*T_e
      f1_right=f1_right+P_oh+P_ech-P_ioniz-P_rad

      f2_right=delta*n_e*n_i/T_e**1.5*(T_e-T_i)-alfa*n_i/tay_ei*T_i
      f2_right=f2_right-p_ch_1*(T_i-T0)

c      print *,' f1_left f1_right',f1_left,f1_right
c      print *,' f2_left f2_right',f2_left,f2_right


c      stop


      return
      end



      subroutine en_00()
      include 'double.inc'
      include 'new_com.inc'
      include 'br_com.inc'

      call en_00_c(n_rad,
     * tay,kpr,n_e,n_e0,n_d,n_d0,n0,n00,T_e,T_e0,T_i,T_i0,
     * pi,a_min,R_maj,tt,n_i,n_i0,
     * I_p,I_p0,p_oh,p_cx,p_ioniz,p_rad,q_ech,z_eff,v_v0,v_p,
     * sel,v_n,p_lambda,r_pl0,v_v00,tay_ee,
     * tpl,eu,rmag,alf_n,tay_lo,v_p0)


c----------------------
c----------------------
c----------------------

      return
      end
      subroutine en_00_c(n,
     * tay_old,kpr,n_e,n_e0,n_d,n_d0,n0,n00,T_e,T_e0,T_i,T_i0,
     * pi,a,R,tt,n_i,n_i0,
     * I_p,I_p0,p_oh,p_cx,p_ioniz,p_rad,q_ech,z_eff,v_v0,v_p,
     * sel,v_n,p_lambda,r_pl,v_v00,tay_ee,
     * tpl,eu,rmag,alf_n,tay_lo,v_p0)

      include 'double.inc'

      include 'parf0'

      include 'double_break1.inc'


      include 'parf3'

      common
     *	/igr/ygr(iy,ny),tgr(ny),igr
      common
     *	/ng_igr/ng

	common /c_imp_out2/qlos_e,qlos_imp,qloss_ion


       dimension denz(2),
     * rin_zog(2),rre_zog(2),rcx_zog(2)


      dimension sel(*)

	character *12 yy(iy)
	character *50 tmp


!       Only one dimension remains...

	n=1


      tay=tay_old*1.e-3

      time=time+tay*1.e3

      alfa=1.5*1.6e-2

	alfa_rus=0.1d0

c      alfa=1.5

c  Plasma volume...



c      U=100.
      i_en=i_en+1
      if(i_en.eq.1)then


c	print *,' file in.dat is reading'

	open (unit=41,file='in.dat',form='formatted')
        read (41,*)U
        read (41,*)tay_ee
        read (41,*)tay_ei
        read (41,*)alf_n
        read (41,*)p
        read (41,*)R
        read (41,*)a
        read (41,*)R_ves
        read (41,*)a_ves
        read (41,*)e_ves
        read (41,*)Z
        read (41,*)psi_n
        read (41,*)I_p
        read (41,*)T_e
        read (41,*)T_i
        read (41,*)gam
        read (41,*)elong
        read (41,*)Bt
        read (41,*)i_temp
        read (41,*)alfa_loss
        read (41,*)g_v
        read (41,*)tay_lo


	  

        close (41)




      end if


c	print *,' elong BT=',elong,bt
c	print *,' G_v psi_n=',G_v,psi_n
	if(kpr.eq.1)print *,' i_temp alfa_loss=',i_temp,alfa_loss

c	read (*,*)


c      R=1.

c      a=0.2

	r=rmag*1.e-2
	a=eu*1.e-2

	if(kpr.eq.1)print *,' r a=',r,a
	if(kpr.eq.1)print *,' tpl elong=',tpl,elong


      V_p=2.*pi*R*pi*a**2*elong


 


c      G_v=0.

c      psi_n=1.
!!      psi_n=0.5

c  Vessel volume...

c      R_ves=1.
c      a_ves=0.5
c      e_ves=3.


c------------------------------------

      V_v=2.*pi*R_ves*pi*a_ves**2*e_ves

c	print *,' r a elong ==',r,a,elong

	if(kpr.eq.1)print *,' v_p v_v ==',v_p,v_v

c-----------------------------------

      P_rad_z=0.

c      print *,' a R V_p V_v v_v0',a,R,V_p,V_v,v_v0

c      p=20.e-3   !pressure in Pa

      E=U/(2.*pi*R)


      I_r=0.

c     equations...

c     T_e
c
c     3/2*d(n_e*T_e)/dt=P_oh+P_ecrh-P_del-P_ioniz-P_rad-3/2*n_e*T_e/tay_ee
c
c     T_i
c
c     3/2*d(n_i*T_i)/dt=P_del-P_cx-3/2*N_i*T_i/tay_ei
c
c     P_oh=(I_p-I_r)**2*R_pl/V_p
c
c     R_pl=sig*2*R/a**2
c
c     sig=1.65e-3*Zeff*ln(L)/T_e**1.5+2.7*n0/n_e
c
c     P_ech=Q_ech/V_p
c
c     P_del=0.24*(T_e-T_i)/T_e**1.5*n_e*n_d*(1/A_d+Z**2*gamma_z/A_z)*Ln(L)
c
c     P_rad=P_rad_d+P_rad_z
c
c     P_ioniz=1.6e18*V_n/V_p*n0*n_e*S_iz*W_d
c     W_d=0.03 KeV
c
c     S_iz=S_ip+S_iT
c     S_ip=4.6e-17*E/p*dexp(-93.77*p/E)
c     S_iT=2e-14*sqrt(T_e/Ry)*dexp(-Ry/T_e)/(6.+T_e/Ry)
c

c
c     P_cx=2.4e18*n0*n_d*V_n/V_p*(T_i-T0)*S_cx
c     S_cx=1.e-13*T_i**0.327
c
c
c     V_p=2*pi**2*a**2*R
cc
c
c     Ry=0.0136KeV
c
c     T0=2.59e-5KeV
c
c     Ln(L)=16.1+ln(T_e/sqrt(n_e)/Zeff) T_e > 0.05KeV
c
c     Ln(L)=17.6+ln(T_e**1.5/sqrt(n_e)/Zeff) T_e < 0.05KeV
c
c     gamma_Z=n_Z/n_d
c
c     n_i=n_d*(1.+gamma_Z)
c
c     n_e=n_d*(1+Z*gamma_Z)
c     
c     Zeff=(1+Z**2*gamma_Z)/(1.+Z*gamma_Z)
c
c     particle balance
c
c     V_p*d(n_d)/dt=n0*n_e*S_iz*V_n-n_d*V_p/tay_p
c
c     (V_v+V_n-V_p)*d(n0)/dt=psi_n*n_d*V_p/tay_p-n0*n_e*S_iz*V_n+G_v*V_v
c
c     G_v  gas puff velocity
c
c     psi_n recycling coeff
c
c     V_v vessel volume
c

c     

      if(i_en.eq.1)then


      V_n=V_p
      V_v0=(V_v+V_n-V_p)


c     following reading necessary only once
c	call readmc_y
c        call readehr1_y 

       L_p=4.*pi*R*(dlog(8.*R/a)-1.5)/10.

	 pll0=L_p

c       pll*tpl*1.e-5  V*S== pll*I_p*1.e3*1.e-5=pll*I_p*1.e-2

c      gamma_Z=1.e-2

c      Z=6.

!!!      Zeff=(1.+Z**2*gamma_Z)/(1.+Z*gamma_Z)

      Z_eff=1.

      W_d=0.03 

      Ry=0.0136

c  temporarily...
ccc      W_d=Ry 


      n0=4.8*p

	n0_in=n0


c      gam=1.e-3


      n_e=gam*n0

      n_d=n_e

      n_i=n_d

c      print *,' n_i n_e n_d ',n_i,n_e,n_d

c      print *,' T_i T_e  ',T_i,T_e

      n_tot0_in=n_d*V_p+n0*V_v0
	v_v0_in=v_v0

c  From previous time step
         
      
	call time_step_00()

	return

      end if


	pll0=L_p

      L_p=4.*pi*R*(dlog(8.*R/a)-1.5)/10.
	zeff=z_eff

c      print *,' Zeff sel ',Zeff,sel(1)*1.d-4*16.d0


!!!	return


c  Given n_d....

!!!      n_i=n_d   !( From Outside)

!!!      n_e=n_d   !( From Outside)

c      print *,' time n_i n_e n_d ',time,n_i,n_e,n_d
c      print *,' T_e T_i ',T_e,T_i

      if( T_e .gt. 0.05d0 )then
         qlog=16.1d0+dlog(T_e/sqrt(n_e)/Zeff) 
      else
         qlog=17.6d0+dlog(T_e**1.5d0/sqrt(n_e)/Zeff) 
      end if
      
c      qlog=10.

      A_d=2.d0

      delta=0.245d0/A_d*qlog*Zeff


c      delta=0.24/A_d*qlog
c      delta=0.
   
      p_cur=n0/4.8d0

      S_ip=4.6d-17*E/p_cur*dexp(-93.77d0*p_cur/E)

      p_torr=p_cur/133.3d0

      tay_ion1=43.d0*(E/p_torr)*510.d0*p_torr*Dexp(-1.25d4*p_torr/E)

      tay_ion=1.d0/tay_ion1

      tay_ion_o=1.d0/(S_ip*1.d20*n0)

      v_de=43.d0*E/p_torr

      alf=510.d0*p_torr*Dexp(-1.25d4*p_torr/E)

      tay_i=1.d0/(v_de*alf)

      tay_br=dlog(0.1d0/1.d-4)*tay_i

c      print *,' v_de alf tay_i tay_br',v_de,alf,tay_i,tay_br

      S_iT=2.d-0*sqrt(T_e/Ry)*dexp(-Ry/T_e)/(6.d0+T_e/Ry)

      S_iz1=S_ip+S_iT
      S_iz=S_iT

c      print *,' qlog U p_torr ',qlog,U,p_torr
 
c      print *,' S_ip S_iT S_iz ',
c     *  S_ip,S_iT,S_iz
c      print *,' tay_ion1 tay_ion_o',
c     *  tay_ion,tay_ion_o

      S_cx=1.d-0*T_i**0.327d0

c      print *,' T_i ',t_i


c*** That is 300K
      T0=2.59d-5
	a_d=2.d0

	v0=4.38e5*sqrt(t0/a_d)

c             NEW modifications for v_n --------
c       ------ ---- ----

c      x=2*lambda_i/a,  lambda_i= v0/( n_e*S_iz)



c-------------------------------------


	tay_iz=1.d0/(n_e*S_iz*1.e7)

	p_lambda=v0/(n_e*S_iz*1.e7)


	x=2.d0*p_lambda/a

c	x_coef=100.

c	x=x*x_coef

c	print *,' p_lambda v0 t0',p_lambda,v0,t0
c	print *,' tay_iz x ',tay_iz,x

	

	if(x.le.1.d0)then
      V_n=V_p*x
	end if

!!!      G_v=0.

!!!      psi_n=1.

      V_v0=(V_v+V_n-V_p)

c--------------------------------------------------	


      P_cx=2.4d5*n0*n_d*V_n/V_p*(T_i-T0)*S_cx


c      print *,' S_cx P_cx L_p',S_cx,P_cx,L_p

!!!      sig=1.65e-3*Zeff*qlog/T_e**1.5+2.7*n0/n_e
      sig=1.65d-3*Zeff*qlog/T_e**1.5d0

      R_pl=sig*2*R/a**2

      R_1=L_p/tay

      I_p=(pll0/tay*I_p0+U)/(L_p/tay+R_pl)


	I_p=tpl*1.e-3

c      print *,' sig R_1 R_pl I_p',sig,R_1,R_pl,I_p


	pi_11=u/r_pl



c      print*,'u pi_11 =',u,pi_11
c      read(*,*)


      P_oh=(I_p-I_r)**2*R_pl/V_p

c	P_oh=0.d0

      P_ech=Q_ech/V_p


c     tay_ee     Bohm   3.e-3*a**2*Bt/Te	[s, m, T, keV]


	tay_ee1=3.e-3*a**2*Bt/T_e

c ITER-98 L-mode confinement scaling [6] is

c     tay_ee =0.023*IP**0.96*Bt**0.073*ne**0.4*Ai**0.2*R**1.83*e**-0.06*k**0.64/Qabs**0.73 
c	  [s,MA,T,1019 m-3,AMU,m,MW].

	eps=a/R

	Qabs=dabs(P_oh*V_p+q_ech)

	tay_ee2=0.023*I_p**0.96*Bt**0.073*(n_e*10.)**0.4*a_d**0.2*
     *  R**1.83*eps**(-0.06)*elong**0.64/Qabs**0.73


c	 print *,' tay1 tay2 ',tay_ee1,tay_ee2


      tay_ee=dmax1(tay_ee1,tay_ee2)

	tay_ei=tay_ee


c	 print *,' tay_ee tay_ei ',tay_ee,tay_ei

!!!	tay_p=tay_ee

	tay_p=0.03d0


c  Particle.....
c     V_p*d(n_d)/dt=n0*n_e*S_iz*V_n-n_d*V_p/tay_p
c
c     (V_v+V_n-V_p)*d(n0)/dt=psi_n*n_d*V_p/tay_p-n0*n_e*S_iz*V_n+G_v*V_v
c
c     G_v  gas puff velocity
c
c     psi_n recycling coeff


c      print*,'psi_n n00=',psi_n,n00



      a11=V_p/tay+V_p/tay_p

      a12=-n_e*S_iz*1.e7*V_n

      a21=-psi_n*V_p/tay_p

      a22=V_v0/tay+n_e*S_iz*1.e7*V_n


c      f1=V_p*n_d0/tay+n_e*S_ip*p_torr*1.e20*V_n
c      f2=V_v0/tay*n00+G_v*V_v-n_e*S_ip*p_torr*1.e20*V_n

      f1=V_p0*n_d0/tay
      f2=V_v00/tay*n00+G_v*V_v

      s_0=S_ip*p_torr*1.e7
      s_1=n_e*S_ip*p_torr*1.e7

      call mat_prep(a11,a12,a21,a22,f1,f2,x1,x2)

c      print *,' x1 x2  ',x1,x2

      f1_c=a11*x1+a12*x2
      f2_c=a21*x1+a22*x2

c      print *,' f1_c f1 ',f1_c,f1
c      print *,' f2_c f2 ',f2_c,f2
      
      n_d=x1
      n0=x2


      pn_tot_0=n_d0*V_p+n00*V_v00
      n_tot=n_d*V_p+n0*V_v0

      if(kpr.eq.1)print *,' -n_d0 n00 ',n_d0,n00

      if(kpr.eq.1)print *,' -n_tot n_tot_0 ',n_tot,pn_tot_0
      if(kpr.eq.1)print *,' -v_p V_v00  ',v_p,V_v00
      if(kpr.eq.1)print *,' -v_v0_in n0_in  ',V_v0_in,n_tot0_in
 

      n_i=n_d 

	n_i0=n_d0

c      print *,' n_d n0 ',n_d,n0

      P_rad_d=5.3d-3*n_e*n_d*T_e**0.5d0

      p_ch_1=2.4d5*n0*n_d*V_n/V_p*S_cx


      P_ioniz=1.6d5*V_n/V_p*n0*n_e*S_iz*W_d

      P_rad=P_rad_d+P_rad_z

      f1_left=V_p/tay*(n_d-n_d0)
      f2_left=V_v0/tay*(n0-n00)

      f1_right=n0*n_e*S_iz*1.e7*V_n-n_d*V_p/tay_p
      f2_right=-n0*n_e*S_iz*1.e7*V_n+n_d*V_p/tay_p


c      print *,' f1_left f1_right',f1_left,f1_right
c      print *,' f2_left f2_right',f2_left,f2_right

      s_2=-n_d*tay_p
      s_3=-n0*n_e*S_iz*1.d7

c      print *,' s_0 s1_ s_2 s_3 ',s_0,s_1,s_2,s_3


	n_states=2

	te_inp=T_e*1.e3
	tn_inp=T_i*1.e3
	nz_inp=n_states-1
	den_e=n_e*10.

	den_n=n0*10.
	denz(1)=den_n
	denz(2)=n_d*10.



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

      c_ion=svie(te_inp,den_e)
      c_rec=svr(te_inp,den_e)

	c_ex=rcx_o(tn_inp,nz_inp)
	c_ex_zog=rcx_zo(tn_inp,nz_inp)

      s_ion= S_iz
	 s_cxc=S_cx

c	write(6,'(" i s_ion c_ion rin=",
c     *  i4,6(1pe11.4))'),
c     *  i,s_ion,c_ion,rin_zog(1)


	 e_ion=13.6*den_e*den_n*alfa_rus*16.d0

c	write(6,'(" es_ion ec_ion erin=",
c     *  6(1pe11.4))'),
c     *  s_ion*e_ion,c_ion*e_ion,rin_zog(1)*e_ion



c	write(6,'(" i  c_rec rre=",
c     *  i4,6(1pe11.4))'),
c     *  i,c_rec,rre_zog(2)



c	write(6,'(" i  s_cxc,rcx c_ex c_zog=",
c     *  i4,6(1pe11.4))'),
c     *  i,s_cxc,rcx_zog(2),c_ex,c_ex_zog

	p_i_c=c_ion*e_ion


c   Energy....

!!!	qlos_imp=sel(1)*1.d-4*16.d0

	n_imp_tot=2

	qlos_imp=0.d0
	do i=1,n_imp_tot
	qlos_imp=qlos_imp+sel(i)*1.d-1
	end do


c      delta=0.
c	tay_ee=1.d-3

!!!	p_oh=0

!!!	qlos_imp=0.d0

c*** Mineev's case
      f1_1=-P_ioniz-P_rad-qlos_imp*alfa_loss

c      print *,' f1_1 qlos_e ',f1_1,-qlos_e

c*** Zogolev's case
c!!!	f1_1=-qlos_e-qlos_imp

c      print*,P_ioniz+P_rad,qlos_e
c      read(*,*)


c	f1_1=-qloss_ion

	call print2(' delta zeff==',delta,zeff)

      a11=alfa*n_e/tay+delta*n_e*n_i/T_e**1.5d0+alfa*n_e/tay_ee

      a11=a11-f1_1/T_e

c--------------------------------------------------------------------

      a12=-delta*n_e*n_d/T_e**1.5d0

      a21=a12

c     p_ch_1=0.

      a22=alfa*n_i/tay+delta*n_e*n_i/T_e**1.5d0+alfa*n_i/tay_ei+p_ch_1

c!!!      f1=P_oh+P_ech-P_ioniz-P_rad+alfa*n_e0*T_e0/tay

      f1=P_oh+P_ech+alfa*n_e0*T_e0/tay

c	print *,' p_ech p_oh qlos_imp==',p_ech,p_oh,qlos_imp


c      print *,' P_oh p_i_c=',P_oh,p_i_c

c      print *,' P_ioniz  P_rad=',P_ioniz,P_rad

      sel_h1 = elos_h_i(t_e*1.d3,n_e*10.d0)*(n0*10.)*alfa_rus*16.

      sel_h2 = elos_h_r(t_e*1.d3,n_e*10.d0)*(n_i*10.)*alfa_rus*16.

c      print *,' sel_h1 sel_h2 =',sel_h1,sel_h2








c      f1=+1.5*n_e0*T_e0/tay+P_oh

       f2=p_ch_1*T0+alfa*n_i0*T_i0/tay

c      f2=1.5*n_i0*T_i0/tay
	if(i_temp.eq.1)then

      call mat_prep(a11,a12,a21,a22,f1,f2,x1,x2)

c      print *,' x1 x2 ',x1,x2

      f1_c=a11*x1+a12*x2
      f2_c=a21*x1+a22*x2

c      print *,' f1_c f1 ',f1_c,f1
c      print *,' f2_c f2 ',f2_c,f2
      
      T_e=x1
      T_i=x2

	end if

c      print *,' T_e0 T_i0 P_ech',T_e0,T_i0,P_ech
c       print *,' T_e T_i P_oh',T_e,T_i,P_oh
c      print *,' n_e n_i ',n_e,n_i
c      print *,' n_e0 n_i0 ',n_e0,n_i0


!!!!!!!!      n0=(n_tot0-n_d*V_p)/V_v0
      pn_tot_0=n_d0*V_p+n00*V_v0

      n_tot=n_d*V_p+n0*V_v0

c      print *,' n_tot n_tot_0 ',n_tot,pn_tot_0

      f1_left=alfa/tay*(n_e*T_e-n_e0*T_e0)
      f2_left=alfa/tay*(n_i*T_i-n_i0*T_i0)

      f1_right=-delta*n_e*n_i/T_e**1.5*(T_e-T_i)-alfa*n_e/tay_ee*T_e
      f1_right=f1_right+P_oh+P_ech-P_ioniz-P_rad

      f2_right=delta*n_e*n_i/T_e**1.5*(T_e-T_i)-alfa*n_i/tay_ei*T_i
      f2_right=f2_right-p_ch_1*(T_i-T0)

c      print *,' f1_left f1_right',f1_left,f1_right
c      print *,' f2_left f2_right',f2_left,f2_right


c      stop


      return
      end



        subroutine in_neut_0d()

        include 'double.inc'
 
        include 'new_com.inc'
        include 'br_com.inc'

        include 'par_imp.inc'
        include 'new_imp.inc'
 
        call in_neut_0d_c(
     *  n0,den_neut,
     *  n_i,den,n_rad)

        return
        end

        subroutine in_neut_0d_c(
     *  n0,den_neut,
     *  n_i,den,n_rad)

        include 'double.inc'

        dimension
     *  den_neut(*),den(*)

        character * 20 apr

      include 'double_break1.inc'

	n_rad=1

	if(kpr.eq.1)print *,'n_rad==== ',n_rad

c	read (*,*)

           do i=1,n_rad
                 den_neut(i)=n0
                 den(i)=n_i*10.d0
        apr=' den_neut '
c       print 71,apr,den_neut(i)
        apr=' den '
c       print 71,apr,den(i)
		end do

 

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))

        return
        end

        subroutine in_imp_0d()

        include 'double.inc'

        include 'new_com.inc'
        include 'br_com.inc'


!        include 'parf0'
        include 'par_imp.inc'
        include 'new_imp.inc'


c	   print *,' n_e n_i v_v0==',n_e,n_i,v_v0


        call in_imp_0d_c(
     *  n_imp,n_imp_tot,
     *  den_imp,
     *  den_imp_n,den_imp_tot,dens_imp_neut,
     *  z_imp,v_v0,v_p,z_eff,n_rad,n0,kpr)


	return
	end


        subroutine in_imp_0d_c(
     *  n_imp,n_imp_tot,
     *  den_imp,
     *  den_imp_n,den_imp_tot,dens_imp_neut,
     *  z_imp,v_v0,v_p,z_eff,n_rad,dens_n0,kpr)

        include 'double.inc'
        include 'par_imp.inc'

	  parameter (nip=nimp)

        dimension
     *  den_imp(nip,nip,*),den_imp_n(nip,*)

        dimension z_imp(*),n_imp(*),den_imp_tot(*)

        character * 30 apr

	dimension dens_imp_neut(*)


c        Impurity initialization file....

c Be and Oxigen
!        n_imp(1)=4
!        n_imp(2)=8

c Carbon and Oxigen
!        n_imp(1)=6
!        n_imp(2)=8

c Carbon and Wolfram
c        n_imp(1)=6
c        n_imp(2)=74


	  n_imp_tot=2

c Carbon only
c        n_imp(1)=6
c	  n_imp_tot=1

c        Li
c        n_imp(1)=3
c	  n_imp_tot=1

	if(kpr.eq.1)then
        print *,' n_imp_tot from in_imp_0d',n_imp_tot
        print *,' n_imp',(n_imp(j),j=1,n_imp_tot)
	print *,'nip nimp= ',nip,nimp
	print *,' v_v0= v_p= z_eff',v_v0,v_p,z_eff


c	n_rad=n

	print *,'n_rad==== ',n_rad
	end if


!  Intital impurity neutrals density.(1.e19)
c	dens_imp_neut(1)=3.d-3
!	dens_imp_neut(1)=2.d-3
!	dens_imp_neut(2)=1.d-3


!  Intital impurity density...(1.e19)
c	dens_imp_dens=2.d-6

	dens_imp_dens=0.
		
        do i=1,n_rad
        do j=1,n_imp_tot


           den_imp_n(j,i)=dens_imp_neut(j)

	     den_imp_tot(j)=dens_imp_neut(j)*v_v0

        do k=1,nip
           z_imp(k)=dfloat(k)
           den_imp(j,k,i)=dens_imp_dens
        end do
        end do
        end do

c        print*,'n_rad n_imp_tot nip',n_rad,n_imp_tot,nip

c        print *,' z_imp',(z_imp(j),j=1,nip)

	if(kpr.eq.1)then

        print*,'n0 dens_imp_neut',dens_n0,dens_imp_neut(1)

c	read(*,*)

        k=1

		
        do i=1,n_rad
        do j=1,n_imp_tot
           apr=' den_inp '
           print 71,apr,(den_imp(j,k,i),k=1,n_imp(j))
        end do
        end do
 
        do i=1,n_rad
        apr=' den_imp_n '
        print 71,apr,(den_imp_n(j,i),j=1,n_imp_tot)
	  end do
		

        apr=' den_imp_tot '
        print 71,apr,(den_imp_tot(j),j=1,n_imp_tot)

	end if

c	read (*,*)

71	FORMAT(5X,A30/,(2x,6(1PE11.3)))

        return
        end


        subroutine into_impu()

        include 'double.inc'
 
        include 'new_com.inc'
        include 'br_com.inc'

        include 'par_imp.inc'
        include 'new_imp.inc'
 
        call into_impu_c(
     *  n0,den_neut,
     *  n_d,den,T_e0,T_i0,
     *  T_e,T_i,tempe,tempi,n_rad,kpr)

        return
        end

        subroutine into_impu_c(
     *  n0,den_neut,
     *  n_d,den,T_e0,T_i0,
     *  T_e,T_i,tempe,tempi,n_rad,kpr)

        include 'double.inc'

        dimension
     *  den_neut(*),den(*),tempe(*),tempi(*)

        character * 20 apr

      include 'double_break1.inc'


c	n_rad=n

		if(kpr.eq.1)print *,'n_rad==== ',n_rad

           do i=1,n_rad
              den_neut(i)=n0*10.d0
              den(i)=n_d*10.d0
              tempe(i)=T_e*1.d3
              tempi(i)=T_i*1.d3

        apr=' den_neut '
       if(kpr.eq.1)print 71,apr,den_neut(i)
        apr=' den '
       if(kpr.eq.1)print 71,apr,den(i)
       apr=' tempe '
       if(kpr.eq.1)print 71,apr,tempe(i)
       apr=' tempi '
       if(kpr.eq.1)print 71,apr,tempi(i)

		end do

 

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))

        return
        end








        subroutine into_imp()

        include 'double.inc'
 
        include 'new_com.inc'
        include 'br_com.inc'

        include 'par_imp.inc'
        include 'new_imp.inc'
 
        call into_imp_c(
     *  n0,den_neut,
     *  n_d,den,T_e0,T_i0,
     *  T_e,T_i,te0,tq0,n_rad,kpr)

        return
        end

        subroutine into_imp_c(
     *  n0,den_neut,
     *  n_d,den,T_e0,T_i0,
     *  T_e,T_i,te0,tq0,n_rad,kpr)

        include 'double.inc'

        dimension
     *  den_neut(*),den(*),te0(*),tq0(*)

        character * 20 apr

      include 'double_break1.inc'


c	n_rad=n

		if(kpr.eq.1)print *,'n_rad==== ',n_rad

           do i=1,n_rad
              den_neut(i)=n0*10.d0
              den(i)=n_d*10.d0
			te0(i)=0.5d0*(T_e+T_e0)*1.d3
			tq0(i)=0.5d0*(T_i+T_i0)*1.d3
        apr=' den_neut '
       if(kpr.eq.1)print 71,apr,den_neut(i)
        apr=' den '
       if(kpr.eq.1)print 71,apr,den(i)
        apr=' te0 '
       if(kpr.eq.1)print 71,apr,te0(i)
        apr=' tq0 '
       if(kpr.eq.1)print 71,apr,tq0(i)
		end do

 

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))

        return
        end






        subroutine into_imp_kav()

        include 'double.inc'
 
        include 'new_com.inc'
        include 'br_com.inc'

        include 'par_imp.inc'
        include 'new_imp.inc'
 
        call into_imp_kav_c(
     *  n0,den_neut,
     *  n_d,den,pd0,pt0,pne,p,
     *  T_e,T_i,te0,tq0,a,n,
     *  te_a,ti_a,pw_e,kpr,
     *  pi,vi,ha,
     *  T_e0,T_i0,
     *  z_eff,zeff,g_v,n_e)

        return
        end

        subroutine into_imp_kav_c(
     *  n0,den_neut,
     *  n_d,den,pd0,pt0,pne,p,
     *  T_e,T_i,te0,tq0,a,n,
     *  te_a,ti_a,pw_e,kpr,
     *  pi,vi,ha,
     *  T_e0,T_i0,
     *  z_eff,zeff,g_v,n_e)

        include 'double.inc'

        dimension
     *  den_neut(*),den(*),te0(*),tq0(*),
     *  a(*),pd0(*),pt0(*),pne(*),p(*),vi(*),ha(*),zeff(*)

        character * 30 apr
	dimension a_print(200)

      include 'double_break1.inc'


c	n_rad=n


	te_b=1.d0
	ti_b=1.d0

	te_b=0.5d0
	ti_b=0.5d0

c--------------------

	te_a=0.5d0*(t_e+t_e0)*1.e3
	ti_a=0.5d0*(t_i+t_i0)*1.e3


      if(te_a.lt.te_b)te_a=te_b
      if(ti_a.lt.ti_b)ti_a=ti_b

c-----------------------------

c	te_b=0.2d0*0.5d0*(t_e+t_e0)*1.e3
c	ti_b=0.2d0*0.5d0*(t_i+t_i0)*1.e3

c	te_a=5.d0*te_b
c	ti_a=5.d0*ti_b


	pw_e=2.d0

	a_print(1)=te_a
	a_print(2)=ti_a
	a_print(3)=pw_e


	n_pr=3
	apr='**te_a ti_a pw_e '
	num=25
	if(kpr.eq.1.or.kpr.eq.-3)call out42(n_pr,a_print,num,apr)


	a_print(1)=t_e
	a_print(2)=t_e0
	a_print(3)=t_i
	a_print(4)=t_i0

	n_pr=4
	apr='**te te0  ti ti0'
	num=25
	if(kpr.eq.1.or.kpr.eq.-3)call out42(n_pr,a_print,num,apr)


c	call pau()

           do i=1,n

              den_neut(i)=n0*10.d0
              den(i)=n_d*10.d0

			pne(i)=n_e*10.d0

!			pne(i)=den(i)
			pd0(i)=den(i)
!			pt0(i)=0.5d0*den(i)

			zeff(i)=z_eff

		end do

	do i=1,n                                                               
	psix=a(i)                                                              
	te0(i)=te_b+(1.-psix**pw_e)*(te_a-te_b)
	tq0(i)=ti_b+(1.-psix**pw_e)*(ti_a-ti_b)
	end do


	tec=0.d0
	tqc=0.d0
	vv=0.d0

	pion_d=0.
	pion_t=0.
           
		 do i=2,n
	      TQC=TQC+PI*(TQ0(I)+TQ0(I-1))*VI(I)*HA(I)      
		  TEC=TEC+PI*(TE0(I)+TE0(I-1))*VI(I)*HA(I)                          
             VV=VV+VI(I)*HA(I)                      
      DQD=PI*VI(I)*HA(I)                                                
	pion_d=pion_d+dqd*(pd0(i)+pd0(i-1))
	pion_t=pion_t+dqd*(pt0(i)+pt0(i-1))
		end do

      VV=2.*PI*VV                                                       
                                                                        
      TQC=TQC/VV                                                        
      TEC=TEC/VV                                                        

      pion_d=pion_d/VV
      pion_t=pion_t/VV

	if(kpr.eq.1)print *,' ++ pion_d ==pion_t=====',pion_d,pion_t


	int=0

1	continue

	tec1=tec


	al1=t_e*1.d3/tec
	al2=t_i*1.d3/tqc

	te_a=te_a*(0.75d0*al1+0.25d0)
	ti_a=ti_a*(0.75d0*al2+0.25d0)

      if(te_a.lt.te_b)te_a=te_b
      if(ti_a.lt.ti_b)ti_a=ti_b


	do i=1,n                                                               
	psix=a(i)                                                              
	te0(i)=te_b+(1.-psix**pw_e)*(te_a-te_b)
	tq0(i)=ti_b+(1.-psix**pw_e)*(ti_a-ti_b)
	end do

	tec=0.d0
	tqc=0.d0
	vv=0.d0
           
		 do i=2,n
	      TQC=TQC+PI*(TQ0(I)+TQ0(I-1))*VI(I)*HA(I) 
		  TEC=TEC+PI*(TE0(I)+TE0(I-1))*VI(I)*HA(I)                          
             VV=VV+VI(I)*HA(I)                        
		end do

      VV=2.*PI*VV                                                       
                                                                        
      TQC=TQC/VV                                                        
      TEC=TEC/VV                                                        
  

	err=dabs( (tec1-tec)/tec )

	int=int+1


	a_print(1)=tec
	a_print(2)=tec1
	a_print(3)=T_e
	a_print(4)=te_a
	a_print(5)=al1
	a_print(6)=err
	a_print(7)=int


	n_pr=7
	apr='**tec tec1 t_e te_a al1 err int'
	num=25
c	call out42(n_pr,a_print,num,apr)

	if(int.gt.50)then 
	call out42(n_pr,a_print,num,apr)
	call pau()
	end if

	if(err.gt.1.d-4.and.int.le.50)go to 1


	a_print(1)=n0
	a_print(2)=n_d
	a_print(3)=T_e
	a_print(4)=te0(1)
	a_print(5)=T_i
!	a_print(6)=tq0(1)
	a_print(6)=g_v


	n_pr=6
	apr='**n0 n_d t_e te0 t_i g_v '
	num=30
	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)


	a_print(1)=n
	a_print(2)=err
	a_print(3)=int


	n_pr=3
	apr='** n err int'
	num=30
c	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)


	do i=1,n
c	tq0(I)=te0(i)
	p(i)=(te0(i)+tq0(I))*(pd0(i)+pt0(I))*200.*1.e-6
	end do


        apr=' den_neut '
c       print 71,apr,den_neut(i)
        apr=' den '
c       print 71,apr,den(i)
        apr=' te0 '
c       print 71,apr,te0(i)
        apr=' tq0 '
c       print 71,apr,tq0(i)

	do i=1,n	
	a_print(i)=te0(i)
	end do

	n_pr=n
	apr='**te0-'
	num=25
c	call out42(n_pr,a_print,num,apr)
 
	do i=1,n	
	a_print(i)=tq0(i)
	end do

	n_pr=n
	apr='**tq0-'
	num=25
c	call out42(n_pr,a_print,num,apr)
 
	do i=1,10	
	a_print(i)=pne(i)
	end do

	n_pr=10
	apr='**pne-'
	num=25
c	call out42(n_pr,a_print,num,apr)
 


71	FORMAT(5X,A10/,(2x,6(1PE11.3)))

        return
        end


      subroutine dopp_00()
      include 'double.inc'
      include 'new_com.inc'
      include 'br_com.inc'

        include 'par_imp.inc'
        include 'new_imp.inc'

	character *30 apr                                                      
	dimension a_print(200)
	


	a_print(1)=c2(n)
	a_print(2)=psi8(n)
	n_pr=2
	apr=' ** c2 psi8  **'

	num=15
	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)


      call dopp_00_c(
     * tay,kpr,n_e,n_e0,n_d,n_d0,n0,n00,T_e,T_e0,T_i,T_i0,
     * pi,a_min,R_maj,tt,
     * I_p,p_oh,p_cx,p_ioniz,p_rad,q_ech,z_eff,v_p,
     * n_imp_tot,v_n,p_lambda,r_pl0,v_v0,tay_ee,sel,q_rad,q,
     * tay_lo,ratio_imp,ratio_imp2,anom_e,rmag,eu,g_v,
     * vloop,uact,betj,zmag,udd,tpl,elong,c2,n,rout,zout)


      return
      end
      subroutine dopp_00_c(
     * tay_old,kpr,n_e,n_e0,n_d,n_d0,n0,n00,T_e,T_e0,T_i,T_i0,
     * pi,a,R,tt,
     * I_p,p_oh,p_cx,p_ioniz,p_rad,q_ech,z_eff,v_p,
     * n_imp_tot,v_n,p_lambda,r_pl,v_v0,tay_ee,sel,q_rad,q,
     * tay_lo,ratio_imp,ratio_imp2,anom_e,rmag,eu,g_v,
     * vloop,uact,betj,zmag,udd,tpl,elong,c2,n,rout,zout)

      include 'double.inc'

      include 'parf0'

      include 'double_break1.inc'


      include 'parf3'



      common
     *	/igr1/ygr(iy,ny),tgr(ny),igr
      common
     *	/ng_igr1/ng

	common /c_imp_out1/den_imp_neut(10)
	common /c_neut2/pn_prog

	common /c_imp_out2/qlos_e,qlos_imp,qloss_ion

      common /c_te_av/te_av
      common /c_s_plas/s_plas,alfa2_avr
      common /c_s_plas1/alf_b,bet_b,x1_b,dm_b

      common /c_ch/q_ch(10)
      common /c_ion/q_ion(10)
      common /c_zrad/q_zrad(10)
     *  /c_imas4/pn0_tot

	character *12 yy(iy)
	character *50 tmp

	dimension dens_imp(npo),sel(*),q_rad(*),q(*),c2(*)

	character *30 apr                                                      
	dimension a_print(200)

	i_en=i_en+1

      if(kpr.eq.1)print *,'  P_cx  sel(1)*0.1 ==',sel(1)*0.1
c      print*,'den_imp_neut=',(den_imp_neut(j),j=1,n_imp_tot)
c      read(*,*)


	a_print(1)=c2(n)
	a_print(2)=q(n)
	a_print(3)=n
	n_pr=3
	apr=' ** c2 q n  **'

	num=15
	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)


	call imp_outp(dens_imp)

!	igr=igr+1
	
	igr=1
	

	if(igr.gt.ny)then
	
	call print2(' igr ny==',
     *  dfloat(igr),dfloat(ny))

	call pau()

	end if

	tgr(igr)=tt
	if(kpr.eq.1)then
	print *,' IGR   TT ------------------------',igr,tt
	print *,' den_imp_neut-----',den_imp_neut(1),den_imp_neut(2)
	end if

      pn0_tot=n0*10.*1.

      include 'dop_br_0.inc'
!!!      include 'dop_br_2.inc'


	tmp='na_br'

	if(i_en.eq.1)then
	open (unit=41, file=tmp,form='formatted')
	write (41,*)ng
	do i=1,ng
	write (41,*)yy(i)
	end do
	close (41)
	end if

c       print*,'n0 n_e I_p',n0,n_e,I_p
c       read(*,*)

	call get_data_in_time(pcch,tene,wdop,
     *  p_sum,p_loss)

	if(kpr.eq.1)print *,' -++p_loss= ',p_loss

	return
	end




      subroutine time_step_00()
      include 'double.inc'
      include 'new_com.inc'
      include 'br_com.inc'

      call time_step_00_c(
     * kpr,n_e,n_e0,n_d,n_d0,n0,n00,T_e,T_e0,T_i,T_i0,
     * I_p,I_p0,n_i,n_i0,v_v0,v_v00,v_p0,v_p,g_v,g_v0)


      return
      end
      subroutine time_step_00_c(
     * kpr,n_e,n_e0,n_d,n_d0,n0,n00,T_e,T_e0,T_i,T_i0,
     * I_p,I_p0,n_i,n_i0,v_v0,v_v00,v_p0,v_p,g_v,g_v0)

      include 'double.inc'

      include 'parf0'

      include 'double_break1.inc'

	common /c_neut1/p_n0

      I_p0=I_p

      T_i0=T_i

      T_e0=T_e

 !!1     n00=n0
      n00=p_n0
       
      n_d0=n_d

      n_e0=n_e

      n_i0=n_i

	v_v00=v_v0

	v_p0=v_p

	g_v0=g_v

	return
	end




        subroutine imp_time_step()
        include 'double.inc'


!!        include 'parf0'

        include 'new_com.inc'

        include 'par_imp.inc'
        include 'new_imp.inc'

        call imp_time_step_c_(
     *  n_imp,n_imp_tot,
     *  den_imp,den0_imp,
     *  den_imp_n,den0_imp_n,n_rad)

        return
        end

        subroutine imp_time_step_c_(
     *  n_imp,n_imp_tot,
     *  den_imp,den0_imp,
     *  den_imp_n,den0_imp_n,n_rad)


        include 'double.inc'

        include 'par_imp.inc'
	  parameter (nip=nimp)

        dimension
     *  den_imp(nip,nip,*),den0_imp(nip,nip,*),
     *  den_imp_n(nip,*),den0_imp_n(nip,*),n_imp(*)

        character * 20 apr

c	n_rad=n

c	print *,'n_rad==== ',n_rad

	do i=1,n_rad

       do j=1,n_imp_tot
        do k=1,n_imp(j)
		 den0_imp(j,k,i)=den_imp(j,k,i)
        end do
       end do

           do j=1,n_imp_tot
                 den0_imp_n(j,i)=den_imp_n(j,i)
           end do

       end do

       do j=1,n_imp_tot
        do k=1,n_imp(j)
        apr='den_imp '
c        print 71,apr,(den_imp(j,k,i),i=1,n_rad)
  	 end do
  	 end do



        apr='den0_imp_n '
c        print 71,apr,(den0_imp_n(i,j),j=1,nz)

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))

        return
        end

        subroutine neut_time_step()
        include 'double.inc'

!        include 'parf0'
        include 'new_com.inc'
        include 'par_imp.inc'
        include 'new_imp.inc'

        call neut_time_step_c_(
     *  den_neut,den0_neut,n_rad)

        return
        end

        subroutine neut_time_step_c_(
     *  den_neut,den0_neut,n_rad)

        include 'double.inc'

        dimension
     *  den_neut(*),den0_neut(*)

        character * 20 apr

c	n_rad=n

c		print *,'n_rad==== ',n_rad

           do i=1,n_rad
              den0_neut(i)=den_neut(i)
           end do
 

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))

        return
        end




        subroutine en_loss()

        include 'double.inc'

        include 'new_com.inc'
        include 'par_imp.inc'
        include 'new_imp.inc'


        call en_loss_c(
     *  tay,n_imp_tot,
     *  den,tempe,tempi,sel,
     *  den_imp,den_imp_n,n_imp,z_imp,
     *  den_neut,q_rad,n_rad,kpr)

        return
        end

        subroutine en_loss_c(
     *  tay,n_imp_tot,
     *  den,tempe,tempi,sel,
     *  den_imp,den_imp_n,n_imp,z_imp,
     *  den_neut,q_rad,n_rad,kpr)

        include 'double.inc'

        include 'par_imp.inc'
	  parameter (nip=nimp)
 
        dimension z_imp(*),n_imp(*)

        dimension
     *  den(*),tempe(*),tempi(*),sel(*),q_rad(*)

	dimension
     *  den_imp(nip,nip,*),den_imp_n(nip,*),
     *  denz(nip),radz(nip)

	dimension
     *  den_neut(*)

      common /c_ch/q_ch(10)
      common /c_ion/q_ion(10)
      common /c_zrad/q_zrad(10)
      
	 real te_rad(1),xz(1),res(1)


	c_ion_h=1.
	c_rec_h=1.

	c_coef=1.

        alfa1=3./2.

c	 n_rad=n

	if(kpr.eq.1)print *,'n_rad n_imp_tot==== ',n_rad,n_imp_tot

       do i=1,n_rad
		do j=1,n_imp_tot
c electron energy loss on impurities
c carbon
	n_states=n_imp(j)+1      ! number of charge states
	jnuc=n_imp(j)

c       print *,' jnuc n_states =',jnuc,n_states

c       print *,' zimp',(z_imp(k), k=1,n_imp)

	s_h1=0.
	s_h2=0.
	s_ij=0.
	

 
	te=tempe(i)
c  Neutrals Temperature .. tn=ti?
      tn=tempi(i)

        den_e=den(i)
        den_i=den_e

        den_n=den_neut(i)
	
        do k=1,n_imp(j)
           d_imp=den_imp(j,k,i)
           den_e=den_e+z_imp(k)*d_imp
!         if(kpr.eq.1)print *,' j k d_imp=',j,k,d_imp
        end do

	denz(1)=den_imp_n(j,i)

	den_im=denz(1)
	do k=2,n_states
           denz(k)=den_imp(j,k-1,i)
	den_im=den_im+denz(k)
	end do

	te_inp=te
	tn_inp=tn
	nz_inp=n_states-1

        call en_loss_zog(te_inp,tn_inp,nz_inp,
     *  den_e,den_n,denz,
     *  qlos_e,qloss_ion,qloss_rad,qloss_rec,qloss_ch)

	q_bal=qloss_ion+qloss_rad-qloss_rec

	write(6,'(" i qlos_e,q_bal",
     *  i4,6(1pe11.4))'),
     *  i,qlos_e,q_bal


	write(6,'(" i q_ion,q_rad,q_rec,q_ch",
     *  i4,6(1pe11.4))'),
     *  i,qloss_ion,qloss_rad,qloss_rec,qloss_ch


c----------------------------------

      i_test=0
      if(i_test.eq.1)then

         nz_imp=18

         tec=1.        
        te_rad(1)=tec*1.e-3
        
        i1=1
        call zrad(nz_imp,2,1,te_rad,RES)

  	  print *,' i1 nz_imp te Z',i1,nz_imp,te_rad(1),res(1)

        stop
        
        end if


	i1=1
	k=1
	te_rad(1)=te_inp*1.d-3

!      call ZRAD(nz_inp,k,i1,te_rad, Xz)
      call ZRAD_test(nz_inp,k,i1,te_rad, Xz)

	q_im=xz(1)*den_e*den_im

      call ZRAD(nz_inp,k,i1,te_rad, Xz)

	q_im2=xz(1)*den_e*den_im

	if(kpr.eq.-3)then
	call print3('qlos_e qloss_rad te_inp ==',
     *  qlos_e,qloss_rad,te_inp)
	end if
	if(kpr.eq.1)then
	write(6,'(" qlos_e qloss_rad te_inp ==",
     *  6(1pe11.4))'),
     *  qlos_e,qloss_rad,te_inp
	end if

	xx_z=xz(1)*10.
	
	if(kpr.eq.-3)then
	call print4('xz den_e den_im q_im==',
     *  xx_z,den_e,den_im,q_im*10.d0)
	end if

	if(kpr.eq.1)then
	write(6,'(" xz den_e den_n den_im q_im ",
     *  6(1pe11.4))'),
     *  xx_z,den_e,den_n,den_im,q_im*10.d0
	end if
	
      q_zrad(j)=q_im*10.d0
      
      q_zrad(j+2)=q_im2*10.d0
      
c-----------------------------


c        call radmc_y(n_states,jnuc,te,den_e,denz,radz,el_los_i)

c	write(6,'(" i j n_states jnuc te den_e el_los_i",
c     *  4i4,6(1pe12.5))'),
c     *  i,j,n_states,jnuc,
c     *  te,den_e,el_los_i


c        print *,' '

c      sel_ij=el_los_i*c_coef

c	sel_h1 = c_coef*elos_h_i(te,den_e)*denz(1)
c	den_e1=den_e

c	sel_h2 = c_coef*elos_h_r(te,den_e)*den_i
c	den_e2=den_e


!!!      sel(i)=sel_ij

	q_rad(j)=qloss_rad

	sel(j)=qlos_e

	sel(j)=sel(j)*c_coef

      q_ch(j)=qloss_ch*c_coef
      q_rad(j)=q_rad(j)*c_coef
      q_ion(j)=qloss_ion*c_coef
      
      
        do k=1,n_imp(j)
           d_imp=den_imp(j,k,i)
         if(kpr.eq.-1)print *,' j k d_imp=',j,k,d_imp
        end do


c	s_ij=s_ij+sel_ij
c	s_h1=s_h1+sel_h1
c	s_h2=s_h2+sel_h2

c--  1.5*(te*ne0-te0*ne0)/tay=sel

c    te=(sel*tay/1.5+te0*ne0)/ne0


c	write(6,'(" sel_ij sel_h1 sel_h2",
c     *  6(1pe11.4))'),
c     *  sel_ij,sel_h1,sel_h2

c	print *,' sel_ij sel_h1 sel_h2',sel_ij,sel_h1,sel_h2

c	print *,' den_e den_i den_n',den_e,den_i,den_n
c	print *,' den_e1 den_e2 ',den_e1,den_e2

        end do
        end do

        if(kpr.eq.1)print *,'sel1 sel2 ',
     *  sel(1),sel(2)
        if(kpr.eq.1)print *,'q_zrad1 q_zrad2 ',
     *  q_zrad(1),q_zrad(2)

        if(kpr.eq.1)print *,'-q_zrad1 -q_zrad2 ',
     *  q_zrad(3),q_zrad(4)

        if(kpr.eq.1)print *,'q_ch1 q_ch2 ',
     *  q_ch(1),q_ch(2)
        if(kpr.eq.1)print *,'q_ion1 q_ion2 ',
     *  q_ion(1),q_ion(2)
        if(kpr.eq.1)print *,'q_rad1 q_rad2 ',
     *  q_rad(1),q_rad(2)

        return
        end

      subroutine zeff_read()
	include 'double.inc'
	include 'new_com.inc'

	call zeff_read_c(
     *       zeff_a,zeff_b,tt,kpr)

	return
	end
      subroutine zeff_read_c(
     *       zeff_a,zeff_b,tt,kpr)

	include 'double.inc'
 	include 'parf_mike' 


	dimension t_t(ntime),zeff_a_t(ntime),zeff_b_t(ntime)
	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='zeff.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 
           
           if(kpr.eq.1)print *,' tay tt n_t===',tay,tt,n_t 
           
           do i=1,n_t 
              read (41,*)t_t(i),zeff_a_t(i),zeff_b_t(i)
              t_t(i)=t_t(i)*1000. 
           end do 
           
           apr='-t_t-' 
           if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 

           apr='-zeff_a_t-' 
           if(kpr.eq.1)print 71,apr,(zeff_a_t(i),i=1,n_t) 

           apr='-zeff_b_t-' 
           if(kpr.eq.1)print 71,apr,(zeff_b_t(i),i=1,n_t) 

           close (unit=41) 
        end if

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

        do i=2,n_t
           if((tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
              t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )

              zeff_a=zeff_a_t(i-1)+t_coef*
     *             (zeff_a_t(i)-zeff_a_t(i-1))
              zeff_b=zeff_b_t(i-1)+t_coef*
     *             (zeff_b_t(i)-zeff_b_t(i-1))
c
	 end if

	 end do
        
	return
	end

      subroutine n_d_read()
	include 'double.inc'
	include 'new_com.inc'
      include 'br_com.inc'

	call n_d_read_c(
     *       n_d,tt,kpr)

	return
	end
      subroutine n_d_read_c(
     *       n_d,tt,kpr)

	include 'double.inc'
 	include 'parf_mike' 

      include 'double_break1.inc'

	dimension t_t(ntime),pn_d_t(ntime)
	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='n_d.dat',form='formatted') 
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

              n_d=pn_d_t(i-1)+t_coef*
     *             (pn_d_t(i)-pn_d_t(i-1))
c
	 end if

	 end do

      if(kpr.eq.1)print *,' tt n_d==',tt,n_d
c	stop

        
	return
	end



      subroutine gamma_z_read()
	include 'double.inc'
	include 'new_com.inc'
      include 'br_com.inc'

        include 'par_imp.inc'
        include 'new_imp.inc'

	call gamma_z_read_c(
     *       gamma_z,tt,kpr,nz_imp)
     
        coef_imp1=gamma_z
        n_imp(1)=nz_imp

	return
	end
      subroutine gamma_z_read_c(
     *       gamma_z,tt,kpr,nz_imp)

	include 'double.inc'
 	include 'parf_mike' 

      include 'double_break1.inc'

	dimension t_t(ntime),pn_d_t(ntime)
	
	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='gamma_z.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t,nz_imp 
           read (41,*) 
           
           if(kpr.eq.1)print *,' tay tt n_t nz_imp===',
     *  tay,tt,n_t,nz_imp
           
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

              gamma_z=pn_d_t(i-1)+t_coef*
     *             (pn_d_t(i)-pn_d_t(i-1))
c
	 end if

	 end do

      if(kpr.eq.1)print *,' tt gamma_z==',tt,gamma_z
c	stop

        
	return
	end



        subroutine to_0d()

        include 'double.inc'

        include 'new_com.inc'
        include 'par_imp.inc'
        include 'new_imp.inc'
        include 'br_com.inc'

        call to_0d_c(
     *  n_imp_tot,
     *  den,den_imp,n_imp,z_imp,
     *  n_e,n_i,z_eff,kpr,n_rad,tay_lo,zeff_a)

        return
        end

        subroutine to_0d_c(
     *  n_imp_tot,
     *  den,den_imp,n_imp,z_imp,
     *  n_e,n_i,z_eff,kpr,n_rad,tay_lo,zeff_a)

        include 'double.inc'

        include 'par_imp.inc'
	  parameter (nip=nimp)
 
        dimension z_imp(*),n_imp(*)

        dimension
     *  den(*)

	dimension
     *  den_imp(nip,nip,*)

      include 'double_break1.inc'

c	kpr=1

!	call zeff_read()
c	 n_rad=n

c	print *,'n_rad==== ',n_rad


	zeff_p=3.5d0
	zeff_p=zeff_a

	if(n_rad.gt.1)then
	call print1(' n_rad ==',dfloat(n_rad))
	end if

       do i=1,n_rad

        den_e=den(i)
        den_i=den_e
	  z_eff=den_i*1.d0


	do j=1,n_imp_tot
	
        do k=1,n_imp(j)
           d_imp=den_imp(j,k,i)
           den_e=den_e+z_imp(k)*d_imp
           z_eff=z_eff+z_imp(k)**2*d_imp
	     den_i=den_i+d_imp
        end do
	 

      end do




	  z_eff=z_eff/den_e

!	call print4(' z_eff den_i den_e n_imp(1)==',z_eff,den_i,den_e,
!     * dfloat(n_imp(1)))

     
	  tay_lo_in=tay_lo

!!!	call print3(' den den_e z_eff==',den(1),den_e,z_eff)

c	  tay_lo=tay_lo*zeff_p/z_eff

c	if(tay_lo.gt.5.d5)tay_lo=5.d5
c	if(tay_lo.lt.1.d4)tay_lo=1.d4

	  n_e=den_e*0.1d0
	  n_i=den_i*0.1d0


	if(kpr.eq.1)write(6,'("  tay_lo z_eff zeff_p",
     *  6(1pe14.7))'),
     *  tay_lo,z_eff,zeff_p
	   

        end do

        return
        end



         subroutine den_imp_bal()

         include 'double.inc'

         include 'new_com.inc'
         include 'br_com.inc'

         include 'par_imp.inc'
         include 'new_imp.inc'

         call den_imp_bal_c(
     *   n_imp_tot,n_imp,
     *   den_imp,den_imp_n,
     *   den_imp_tot,v_v0,v_p,kpr,n_rad)

         return
         end


         subroutine den_imp_bal_c(
     *   n_imp_tot,n_imp,
     *   den_imp,den_imp_n,
     *   den_imp_tot,v_v0,v_p,kpr,n_rad)

         include 'double.inc'

         include 'par_imp.inc'
 
         dimension  den_imp(nimp,nimp,*),n_imp(*)

         dimension  den_imp_n(nimp,*),den_imp_tot(*)

c	print *,'DEN_IMP_BAL kpr==== ',kpr
	

 	den_im_sum=0.d0

c	n_rad=n

c	print *,'n_rad==== ',n_rad


	do j_x=1,n_rad

	do jj=1,n_imp_tot

        n=n_imp(jj)

        do i=1,n

           d_imp=den_imp(jj,i,j_x)

	   den_im_sum=den_im_sum+d_imp

        end do

	if(kpr.eq.1)print *,' den_imp_n den_im_sum=',
     *  den_imp_n(jj,j_x),den_im_sum

c	if(kpr.eq.1)print *,' v_v0 v_p=',v_v0,v_p


!!!	den_imp_n(jj,j_x)=(den_imp_tot(jj)-den_im_sum*v_p)/v_v0
!!!!	den_imp_n(jj,j_x)=(den_imp_n(jj,j_x)-den_im_sum)

c!!!!!!	if(den_imp_n(jj,j_x).le.1.d-6)den_imp_n(jj,j_x)=1.d-6


  	end do
  	end do




        return
        end


        subroutine den_imp_0d()

        include 'double.inc'

         include 'par_imp.inc'
!        include 'parf0'
        include 'new_com.inc'
         include 'new_imp.inc'

        call den_imp_0d_c(
     *  n_imp,n_imp_tot,
     *  den_imp,den0_imp,n_rad)

        return
        end

        subroutine den_imp_0d_c(
     *  n_imp,n_imp_tot,
     *  den_imp,den0_imp,n_rad)


        include 'double.inc'

        include 'par_imp.inc'
        include 'parf0'

	  parameter (nip=nimp)



        dimension
     *  den_imp(nip,nip,*),den0_imp(nip,nip,*),n_imp(*)


        character * 20 apr


c	n_rad=n

c		print *,'n_rad==== ',n_rad

	i_test=0
	if(i_test.eq.1)then
	call kin_imp_min()
	call kin_imp_test(1)
	call kin_imp_test2(1)
	
	return
	end if


	do i=1,n_rad


c        print *,' i to kin_imp ',i
              call kin_imp(i)

c	call kin_imp_test(1)
c	call kin_imp_test2(1)

	do j=1,n_imp_tot

c        print *,' k i *** ',k,i
        apr=' den0_imp '
c        print 71,apr,(den0_imp(j,k,i),k=1,n_imp(j))
        apr=' den_imp '
c        print 71,apr,(den_imp(j,k,i),k=1,n_imp(j))

	  end do
	  end do




71	FORMAT(5X,A10/,(2x,6(1PE11.3)))

        return
        end

        subroutine en_loss_zog(te_inp,tn_inp,nz_inp,
     *  den_e,den_n,denz,
     *  qloss_e,qloss_ion,qloss_rad,qloss_rec,qloss_ch)

	include 'double.inc'

	dimension denz(*)



c      IMPLICIT NONE

      integer NA,ms,ms1

            parameter (NA=151)
            parameter (ms=75)
            parameter (ms1=100)

c                      ms>max(Nz)

      real Eion(ms1), Si(ms1), Sr(ms1), Sq(ms1)

      real  *8 Sion(NA,ms), Srec(NA,ms), Qlos(NA,ms), Qrad(NA,ms)

      real  *8 Scx(NA,ms) 

      real TE10(NA), TE(NA)

	real *8 alf_inp,YRA_inp


c	Nz_inp=10

	coef=1.d-13*1.d6

	coef1=1.d8

	coef_o=16.d0/(coef*coef1)
!     coef_o=1.6

	alf_inp=0.0
	YRA_inp=0.0

	na2=1

	te(1)=te_inp*1.e-3

c	print *,' te10 te=',te10(1),te(1)

	te10(1)=dlog10(te_inp*1.d-3)

	tn=tn_inp*1.d-3





c           c_ion=rin(te,jz)
c            c_rec=rre(te,jz)
c            c_ex=rcx(tn,jz)

        call  ATSV_rates(
c        call  ATSVTEST(
     *  Eion, Si, Sr, Sq,
     *  Sion,Srec,Qlos,Qrad,Scx,
     *  te10,te,tn,
     *  Nz_inp,alf_inp,YRA_inp,
     *  na2)


c	print *,' eion=',eion(1)

	den_imp=0.d0
	do i=1,nz_inp+1
	den_imp=den_imp+denz(i)
	end do

	qloss_e=0.d0
	qloss_ion=0.d0
	qloss_rad=0.d0
	qloss_rec=0.d0
	qloss_ch=0.d0

	qloss_e1=0.d0



	do i=1,nz_inp+1
	qloss_e=qloss_e+Qlos(1,i)*denz(i)*den_e
c	qloss_e1=qloss_e1+Qlos(1,i)
	qloss_rad=qloss_rad+Qrad(1,i)*denz(i)*den_e

	yy=denz(i)/(den_imp+1.d-8)

	if(kpr.eq.1)then
	write(6,'("  ##  i  yy radf ",
     *  i4,6(1pe12.5))'),
     *  i,yy,Qlos(1,i)
	end if

	end do

	do i=1,nz_inp
	qloss_ion=qloss_ion+sion(1,i)*eion(i)*denz(i)*den_e
	end do

	do i=2,nz_inp+1

	qloss_ch=qloss_ch+scx(1,i)*eion(i-1)*den_n*denz(i)

	qloss_rec=qloss_rec+srec(1,i)*eion(i-1)*denz(i)*den_e

	end do

	qloss_e=qloss_e*coef_o
	qloss_rad=qloss_rad*coef_o
	qloss_ion=qloss_ion*coef_o
	qloss_rec=qloss_rec*coef_o
	qloss_ch=qloss_ch*coef_o

c      erg/mksec/cm**3


c	call print1(' qloss_e1==',qloss_e1*0.16)

	return
	end







        subroutine rates_zog(te_inp,tn_inp,nz_inp,
     *  rin,rre,rcx)

	include 'double.inc'


	 dimension rin(*),rre(*),rcx(*)

c      IMPLICIT NONE

      integer NA,ms,ms1

            parameter (NA=151)
            parameter (ms=75)
            parameter (ms1=100)

c                      ms>max(Nz)

      real Eion(ms1), Si(ms1), Sr(ms1), Sq(ms1)

      real  *8 Sion(NA,ms), Srec(NA,ms), Qlos(NA,ms), Qrad(NA,ms)

      real  *8 Scx(NA,ms) 

      real TE10(NA), TE(NA)

	real *8 alf_inp,YRA_inp


c	Nz_inp=10

	coef=1.d-13*1.d6

	coef1=1.d8

	coef_o=1.d0/(coef*coef1)

c	print *,' coef_o==',coef_o
c	coef_o=coef_o*10.


	alf_inp=0.0
	YRA_inp=0.0

	na2=1

	te(1)=te_inp*1.e-3
	te10(1)=dlog10(te_inp*1.d-3)

	tn=tn_inp*1.d-3


c	print *,' te10 te=',te10(1),te(1)


c           c_ion=rin(te,jz)
c            c_rec=rre(te,jz)
c            c_ex=rcx(tn,jz)

        call  ATSV_rates(
c        call  ATSVTEST(
     *  Eion, Si, Sr, Sq,
     *  Sion,Srec,Qlos,Qrad,Scx,
     *  te10,te,tn,
     *  Nz_inp,alf_inp,YRA_inp,
     *  na2)

	do i=1,nz_inp+1
	rin(i)=sion(1,i)*coef_o
	rre(i)=srec(1,i)*coef_o
	
c	print *,' i I R==',i,rin(i),rre(i)


	rcx(i)=scx(1,i)*coef_o
	end do

c      1.e13*cm**3/mksec
c	print *,' coef_o==',coef_o


	end




	subroutine rate_coefs(te,ti,nz,c_ion,c_rec,c_ex)
      include 'double.inc'

	dimension c_ion(*),c_rec(*),c_ex(*)

        tn=ti

c	print *,' te ti tn nz==',te,ti,tn,nz
c	read (*,*)


	coef=1.d-13*1.d6

	do i=1,nz+1

            j=i
            jz=j-1
            c_ion(i)=rin(te,jz)*coef
            c_rec(i)=rre(te,jz)*coef

            c_ex(i)=rcx(tn,jz)*coef

		 p=2.d0
	     c_xx=svcx(tn,p)
c           c_rec_o=rre_o(te,jz)*coef
 

c	  write(6,'("  i  c_ex c_xx",
c     *  i4,6(1pe12.5))'),
c     *  i,c_ex(i),c_xx


         end do  ! i loop

	   return
	end



         subroutine kin_imp(j_x)

         include 'double.inc'

         include 'new_com.inc'
         include 'br_com.inc'

         include 'par_imp.inc'
         include 'new_imp.inc'

         call kin_imp_c(j_x,
     *   n_imp_tot,n_imp,
     *   den_imp,den0_imp,
     *   den_imp_n,den0_imp_n,den_neut,
     *   tempe,tempi,den,tay,
     *   z_imp,dens_imp_neut,alf_n,tay_lo,v_n,v_p,kpr,
     *   ratio_imp,ratio_imp2,gamma_z,gamma_z2)

         return
         end


         subroutine kin_imp_c(j_x,
     *   n_imp_tot,n_imp,
     *   den_imp,den0_imp,
     *   den_imp_n,den0_imp_n,den_neut,
     *   tempe,tempi,den,tay,
     *   z_imp,dens_imp_neut,alf_n,tay_lo,v_n,v_p,kpr,
     *   ratio_imp,ratio_imp2,gamma_z,gamma_z2)

         include 'double.inc'

         include 'par_imp.inc'
         include 'parf0'

         dimension tempe(*),tempi(*),den(*)

         dimension  den_imp(nimp,nimp,*),den0_imp(nimp,nimp,*)

         dimension  den_imp_n(nimp,*),den0_imp_n(nimp,*),den_neut(*)

         dimension z_imp(*),n_imp(*)

         include 'parrc1.inc'
c Local arrays
         dimension a_imp(njp,njp),f_imp(njp),
     *   d_imp(njp),d_imp0(njp),den_temp(njp)

         dimension tay_h(njp),f_h(njp),den_im(njp)

        dimension rin_zog(njp),rre_zog(njp),rcx_zog(njp)

	dimension dens_imp_neut(*),tay_loss(njp),
     *  f_imp1(njp),f_imp2(njp),d_imp1(njp),d_imp2(njp)

 	   tay_help=tay*1.d+3  !  In Microsecons

	i_test=0
	if(i_test.eq.1)then
	
	do kk=1,500
	
	te=kk
	tn=1.

	write(6,'("  T_e ",
     *  6(1pe12.5))'),
     *  te

      n=n_imp(1)
	nz_inp=n
       call rates_zog(te,tn,nz_inp,
     *  rin_zog,rre_zog,rcx_zog)

       do i=1,n+1

	write(6,'("  ##  i  I R ",
     *  i4,6(1pe12.5))'),
     *  i,rin_zog(i)*1.d-6,rre_zog(i)*1.d-6

      end do
	end do
	stop

	end if





	
!!!	gamma_z2=1.d-5


c	read (*,*)

	alf_c=1.d0

!!!	call tay_ee_calc(tay_los)

! 	   tay_loss=5.d3  !  In Microsecons
c 	   tay_loss=10.d3  !  In Microsecons

c	tay_lo=2000.d3  ! 2000 msec
		
c	print *,' tay_loss==',tay_loss

c         kpr=1


!!!	tay_lo=tay_los

       te=tempe(j_x)

c	 te=500.

	 d_avr=0.02

	if(den_im_sum_1.lt.0.001)alf_feed=1.d0
	if(den_im_sum_1.lt.d_avr-0.001.and.alf_feed.lt.1.e2)alf_feed=
     *  alf_feed*2.

	if(den_im_sum_1.gt.d_avr+0.01.and.alf_feed.gt.1.e-2)alf_feed=
     *  alf_feed*0.5


	if(kpr.eq.1)print *,' d_n alf_feed=',dens_imp_neut(1),
     *  alf_feed


!!!	dens_imp_neut(1)=dens_imp_neut(1)*alf_feed

	if(kpr.eq.1)print *,' d_n den_im_sum_1=',dens_imp_neut(1),
     *  den_im_sum_1

c  Neutrals Density ... den_n=1 temporarily

      den_n=den_neut(j_x)*alf_n

c	call n0_filter(den_n)

c	den_n=0.d0

c  Ions Density ... den_i

       den_i=den(j_x)

c	call n_i_filter(den_i)



!!!       call w_filter(den_i)

c  Neutral Impurity  Density ... den_im=1 temporarily

	do jj=1,n_imp_tot

	den_imp_n(jj,j_x)=dens_imp_neut(jj)

c	print *,' jj den_imp_n=',jj,den_imp_n(jj,j_x)

c	if(den_imp_n(jj,j_x).le.1.d-9)den_imp_n(jj,j_x)=1.d-9
	end do


c
	do jj=1,n_imp_tot
         den_im(jj)=den_imp_n(jj,j_x)*alf_c
	end do


c  Neutrals Temperature .. tn=ti?

         tn=tempi(j_x)

         ti=tn
c	if(kpr.eq.1)write(6,'(" n_imp_tot j_x te  tn",
c     *  2i4,6(1pe12.5))'),
c     *  n_imp_tot,j_x,te,tn


	if(kpr.eq.1)write(6,'(" den_n den_i den_im ",
     *  6(1pe12.5))'),
     *  den_n,den_i,(den_im(jj),jj=1,n_imp_tot)

c         n_imp=6

      den_e=den_i

c      Begin calculation for each impurity jj=1:n_imp_tot

!      print *,' n_imp===',(n_imp(jj),jj=1,n_imp_tot)

	do jj=1,n_imp_tot


         n=n_imp(jj)

C  i=1,6 are Carbon Charge states  jj=1

C  i=1,8 are Oxigen Charge states  jj=2


       do i=1,n+1
	    tay_h(i)=tay_help
!		tay_loss(i)=1.d3*z_imp(i)**2*alf1
!		tay_loss(i)=1.d3*z_imp(i)**3*alf1
		tay_loss(i)=tay_lo

c	if(jj.eq.2.and.i.eq.n)tay_loss(i)=0.1d-0*tay_lo/z_imp(i)

c	tay_loss(i)=1.d-1*tay_loss(i)
c	if(i.eq.6)tay_loss(i)=tay_loss(i)*100.d0


	 end do

         do i=1,n
            d_imp(i)=den_imp(jj,i,j_x)
            d_imp0(i)=den0_imp(jj,i,j_x)

c            print *,' i z_imp',i,z_imp(i)

            den_e=den_e+z_imp(i)*d_imp(i)

         end do


c	te=1.
c	tn=1.

      do i=1,n+1
	jz=i-1

c            rin_zog(i)=rin(te,jz)
c            rre_zog(i)=rre(te,jz)
c            rcx_zog(i)=rcx(tn,jz)

c	write(6,'("  n i c_ion c_rec c_ex ",
c     *  2i4,6(1pe12.5))'),
c     *  n,i,rin_zog(i),rre_zog(i),rcx_zog(i)

      end do

	nz_inp=n
       call rates_zog(te,tn,nz_inp,
     *  rin_zog,rre_zog,rcx_zog)


!!!	rin_zog(3)=rin_zog(3)*0.5

       do i=1,n+1

	 s_ex=3.6d-1*(i-1)*sqrt(ti*1.d-3)

c	write(6,'("  ## n i  c_ex s_ex",
c     *  2i4,6(1pe12.5))'),
c     *  n,i,rcx_zog(i),s_ex

!!!	rcx_zog(i)=s_ex

c            rre_zog(i)=0.
c            rcx_zog(i)=0.




      end do


	i_int=0

1	continue
c	stop

c	read (*,*)

         do j=1,n
            do i=1,n
               a_imp(i,j)=0.
            end do
         end do


         do i=1,n
            a_imp(i,i)=1.d0/tay_h(i)

c   Impurity loss term
            a_imp(i,i)=a_imp(i,i)+1.d0/tay_loss(i)

            f_imp(i)=d_imp0(i)/tay_h(i)

            if(i.gt.1)then
               jz=i

c               c_ion=rin(te,jz-1)
c               c_rec=rre(te,jz)

               c_ion=rin_zog(jz-1+1)
               c_rec=rre_zog(jz+1)


c               den_temp(i)=den_temp(i-1)*c_ion/c_rec
            else
               jz=0
!               c_ion=rin(te,jz)
               c_ion=rin_zog(jz+1)

c               den_temp(i)=den_im(jj)*c_ion
            end if


c	if(kpr.eq.1)write(6,'("  den_temp(i) den_im c_ion",
c     *  6(1pe14.7))'),
c     *  den_temp(i),den_im,c_ion

c	if(kpr.eq.1)write(6,'(" i a_imp f_imp den_temp den_e te",
c     *  i4,6(1pe14.7))'),
c     *  i,a_imp(i,i),f_imp(i),den_temp(i),den_e,te

         end do


         do i=1,n

            if(i.ne.1)then
               j=i-1
               jz=j
!               c_ion=rin(te,jz)
               c_ion=rin_zog(jz+1)

               a_imp(i,j)=a_imp(i,j)-c_ion*den_e


c	if(kpr.eq.1)write(6,'(" i j c_ion a_imp",
c     *  2i4,6(1pe12.5))'),
c     *  i,j,c_ion,a_imp(i,j)

             else
               j=i-1
               jz=j
!               c_ion=rin(te,jz)
               c_ion=rin_zog(jz+1)

               f_imp(i)=f_imp(i)+c_ion*den_im(jj)*den_e
               f_imp2(i)=c_ion*den_e

	c_ion_11=c_ion*den_im(jj)*den_e

c	if(kpr.eq.1)write(6,'("  i j c_ion f_imp den_im den_e ",
c     *  2i4,6(1pe12.5))'),
c     *  i,j,c_ion,f_imp(i),den_im,den_e
            end if

            j=i
            jz=j
            if(i.ne.n)then
c            c_ion=rin(te,jz)
c            c_rec=rre(te,jz)
c            c_ex=rcx(tn,jz)

            c_ion=rin_zog(jz+1)
            c_rec=rre_zog(jz+1)
            c_ex=rcx_zog(jz+1)

            a_imp(i,j)=a_imp(i,j)+(c_ion+c_rec)*den_e+c_ex*den_n

c	if(kpr.eq.1)write(6,'("  i j c_ion c_rec c_ex a_imp",
c     *  2i4,6(1pe12.5))'),
c     *  i,j,c_ion,c_rec,c_ex,a_imp(i,j)


            else

c            c_rec=rre(te,jz)
c            c_ex=rcx(tn,jz)

            c_rec=rre_zog(jz+1)
            c_ex=rcx_zog(jz+1)

            a_imp(i,j)=a_imp(i,j)+c_rec*den_e+c_ex*den_n
c	if(kpr.eq.1)write(6,'("  i j c_ion c_rec c_ex a_imp",
c     *  2i4,6(1pe12.5))'),
c     *  i,j,c_ion,c_rec,c_ex,a_imp(i,j)

            end if

            if(i.ne.n)then
            j=i+1
            jz=j
c            c_rec=rre(te,jz)
c            c_ex=rcx(tn,jz)

            c_rec=rre_zog(jz+1)
            c_ex=rcx_zog(jz+1)


            a_imp(i,j)=a_imp(i,j)-c_rec*den_e-c_ex*den_n

c 	if(kpr.eq.1)write(6,'("  i j c_ion c_rec c_ex a_imp",
c     *  2i4,6(1pe12.5))'),
c     *  i,j,c_ion,c_rec,c_ex,a_imp(i,j)
           end if

         end do  ! i loop

         call mat_prim(a_imp,f_imp,n)

         isol=0
         call solve_prim(isol,d_imp)


        do i=1,n
	  
	  f_imp1(i)=f_imp(i)-f_imp2(i)*den_im(jj)

	f_h(i)=0.d0
	  do k=1,n
	f_h(i)=f_h(i)+a_imp(i,k)*d_imp(k)
		end do
		
c	  write(6,'(" i f_h f_imp",
c     *  i4,6(1pe12.5))'),
c     *  i,f_h(i),f_imp(i)


        end do


         call f_prim(f_imp1,n)

         isol=1
         call solve_prim(isol,d_imp1)

         call f_prim(f_imp2,n)

         isol=1
         call solve_prim(isol,d_imp2)


        do i=1,n

	f_h(i)=0.d0
	  do k=1,n
	f_h(i)=f_h(i)+a_imp(i,k)*(d_imp1(k)+d_imp2(k)*den_im(jj))
		end do

	if(kpr.eq.-1)then		
	  write(6,'(" -- i f_h f_imp",
     *  i4,6(1pe12.5))'),
     *  i,f_h(i),f_imp(i)
	end if


        end do
c 

	  sum1=0.d0
	  sum2=0.d0

      do k=1,n
	  sum1=sum1+d_imp1(k)
	  sum2=sum2+d_imp2(k)
	end do

	if(jj.eq.1)gamma_zz=gamma_z
	if(jj.eq.2)gamma_zz=gamma_z2

	sum3=gamma_zz*den_e
!!!	sum3=gamma_zz*den_i


	sum33=sum1+sum2*den_im(jj)
	
	dens_neut_new=(sum3-sum1)/(1.d0+sum2)

	if(kpr.eq.1)then			
	  write(6,'(" sum1 sum2 sum3 sum33",
     *  6(1pe12.5))'),
     *  sum1,sum2,sum3,sum33

	  write(6,'(" dens_neut_new den_im(jj)",
     *  6(1pe12.5))'),
     *  dens_neut_new,den_im(jj)
	end if

	if(dens_neut_new.lt.1.d-14)dens_neut_new=0.d0

	dens_imp_neut(jj)=dens_neut_new
	den_im(jj)=dens_neut_new

      do i=1,n
	  d_imp(i)=(d_imp1(i)+d_imp2(i)*den_im(jj))
	end do

      sum1=0.d0
      do k=1,n
	  sum1=sum1+d_imp(k)
	end do

	sum33=(sum1+den_im(jj))/den_e
!!!	sum33=(sum1+den_im(jj))/den_i

	if(jj.eq.1)ratio_imp=sum33
	if(jj.eq.2)ratio_imp2=sum33

	if(kpr.eq.1)write(6,'(" r_imp r_imp2 g_z g_z2 ",
     *  6(1pe12.5))'),
     *  ratio_imp,ratio_imp2,gamma_z,gamma_z2

	if(kpr.eq.-3)write(1,'(" r_imp r_imp2 g_z g_z2 ",
     *  6(1pe12.5))'),
     *  ratio_imp,ratio_imp2,gamma_z,gamma_z2



c	stop

	den_im_sum=0.d0
	den_im_sum0=0.d0

        do i=1,n
        den_imp(jj,i,j_x)=d_imp(i)


	   den_im_sum=den_im_sum+d_imp(i)
	   den_im_sum0=den_im_sum0+d_imp0(i)



c	if(kpr.eq.1)write(6,'(" i d_imp d_imp0 sum0",
c     *  i4,6(1pe12.5))'),
c     *  i,d_imp(i),d_imp0(i),den_im_sum0

        end do

      do i=1,n
	if(kpr.eq.-1)then
	write(6,'("  jj i tay_l d_imp  yy ",
     *  2i4,6(1pe12.5))'),
     *  jj,i,tay_loss(i),d_imp(i),d_imp(i)/(den_im_sum+1.d-8)
	end if
      end do


c  Equations for impurity neutrals


	if(jj.eq.1)den_im_sum_1=den_im_sum


  	end do


	jj=1
	i_en=i_en+1
	
	if(i_en.eq.1)then
	den_imp_tot=den_im(jj)

	den_imp_tot=1.d-3

	end if

	if(kpr.eq.1)print *,' den_im den_im_sum=',den_im(jj),den_im_sum

c	if(kpr.eq.1)print *,'  n_imp_tot den_imp_tot==',
c     *  n_imp_tot,den_imp_tot



c	pause 'her'



        return
        end



      subroutine  ATSV_rates(
     *  Eion, Si, Sr, Sq,
     *  Sion,Srec,Qlos,Qrad,Scx,
     *  te10,te,tn,
     *  Nz_inp,alf_inp,YRA_inp,
     *  N)



c       IMPLICIT NONE

	integer Nz_inp

	real *8 alf_inp,YRA_inp,tn

      integer NA,ms

            parameter (NA=151)
            parameter (ms=75)
c                      ms>max(Nz)

      real Eion(*), Si(*), Sr(*), Sq(*)
!      real Eion(ms), Si(ms), Sr(ms), Sq(ms)
c      real  *8 Sion(N,*), Srec(N,*), Qlos(N,*), Qrad(N,*),Scx(N,*)

      real  *8 Sion(NA,ms), Srec(NA,ms), Qlos(NA,ms), Qrad(NA,ms)

      real  *8 Scx(NA,ms) 



      real TE10(*), TE(*)


      real  *8 Sion1(na,ms), Srec1(na,ms),Scx1(na,ms)

	real  *8 c_ion(NA),c_rec(NA),c_ex(NA)



      real Ds(ms)  ,DSi(ms),DSr(ms),DSq(ms)

      real DSion(NA,ms),DSrec(NA,ms),DQlos(NA,ms),DQrad(NA,ms)
      real DScx(NA,ms),   YY(NA,ms)
      real ZM(NA), PM(NA)
      real CE0(NA), YJRA(NA)
      real Zcom(NA,3),Pcom(NA,5),DZcom(NA,2),DPcom(NA,2)
            real*8 C,Y,Z, Ql,Qr,Qcx, C1,Z1,Ql1,Y1
      real Tmin,Tmax,T10min,T10max,DT10, AMz,alf,TI,Tev10,Erec,YRA
      real ZSVCX,amd
      integer N, Nz,IY, j,k,k1,ICOL,kpr

	real *8 t_e,t_i, cc1, cc2

c	common /ge5/kpr

c-0------------------------------------------------- 

	real*8  a_print(1000)                                               

	character *30 apr

	integer n_pr,num

	a_print(1)=Nz_inp
	a_print(2)=alf_inp
	a_print(3)=YRA_inp

	n_pr=3
	apr='!Nz_inp alf_inp YRA_inp= '
	num=16

c	if(kpr.eq.1)call out42(n_pr,a_print,num,apr)


	a_print(1)=te(1)
	a_print(2)=te10(1)
	a_print(3)=tn

	n_pr=3
	apr='!te te10 tn= '
	num=16

c	if(kpr.eq.1)call out42(n_pr,a_print,num,apr)




c	call pau()


!	kpr=0

      if(kpr.eq.1)write(*,*) 

      if(N.gt.NA) N=NA           

c-1------------------------------------------------- 
    1 continue  
            call SPNUL
!      call INIT(0)

	Nz=Nz_inp

      if(kpr.eq.1)write(*,*) 'Please enter chemical element number'
            if(kpr.eq.1)write(*,*) Nz,'=Nz=?  (if Nz<2  - stop)'


!!!!            read(*,*) Nz
!!!      if(Nz.lt.2) stop

      IY=Nz+1

	if(kpr.eq.1)print *,' IY=',IY

            call ATSV(Nz,0,0,IY,0. ,  Eion,Ds)



	a_print(1)=Nz
	a_print(2)=IY

	n_pr=2
	apr='After ATSV   Nz  IY= '
	num=20

	if(kpr.eq.1)call out42(n_pr,a_print,num,apr)


	if(kpr.eq.1)print *,' After ATSV ='


      if(kpr.eq.1)write(*,*) 'Set of Eion(k) ionization potential in eV'
      if(kpr.eq.1)write(*,*) '          for element number Nz=',Nz
      if(kpr.eq.1)write(*,*) (Eion(k),k=1,IY)
      if(kpr.eq.1)write(*,*) 'Press ENTER to continue'
!!!            read(*,*)            
            AMz=2*Nz
      if(kpr.eq.1)write(*,*)
     * 'Please enter factor of hydrogen atoms to electrons'
            if(kpr.eq.1)write(*,*) alf,'=alf=?  (alf=n0/ne)'

	alf=alf_inp

!!!                  read(*,*) alf
      if(kpr.eq.1)write(*,*)
     * 'Please enter factor of  current of RA-electrons'
      if(kpr.eq.1)write(*,*) YRA,'=YRA=?  (YRA=J[MA/m^2]/ne[10^19/m^3)'

	 YRA= YRA_inp

!!!                  read(*,*) YRA
            do j=1,N
      CE0(j) =alf
      YJRA(j)=YRA
            enddo
            if(kpr.eq.1)write(*,*) 'Press ENTER to continue'
!!!      read(*,*)
      if(kpr.eq.1)write(*,*)' '
      if(kpr.eq.1)write(*,*)'-- Output Set of Graphics  y(x) ---------'
      if(kpr.eq.1)write(*,*)'--Press ENTER to go to next screen or step'
      if(kpr.eq.1)write(*,*)' '
      if(kpr.eq.1)write(*,*)'-x = lg(Te): [Te] = keV ; -3 < x < 2------'
      if(kpr.eq.1)write(*,*)'-y(x) = lg(Ik), lg(Rk), lg(Qk), lg(Q),<Z> '
      if(kpr.eq.1)write(*,*)' '
      if(kpr.eq.1)write(*,*)' Ik, Rk -Ioniz and Recombin rate of k-ion'
      if(kpr.eq.1)write(*,*)'     Qk - Cooling factor of ions'    
      if(kpr.eq.1)write(*,*)'     Q  - Total cooling factor '    
      if(kpr.eq.1)write(*,*)' <Z> - Average charge of impurity element '    
      if(kpr.eq.1)write(*,*)' '
      if(kpr.eq.1)write(*,*)'-[Ik, Rk, SVcx_k] = 10^-14 m^3/s --------'
      if(kpr.eq.1)write(*,*)'--------- [Qk, Q] = 10^-38 MW*m^3/s------'
c
!!!           read(*,*) 
		 
      if(kpr.eq.1)write(*,*)'----Calculate rate coefficients-'
		            
c------Calculate rate coefficients
             do j=1,N

          Tev10=TE10(j)+3.
      call ATSV(Nz,1,0,IY,Tev10, Si,DSi)
      call ATSV(Nz,2,0,IY,Tev10, Sr,DSr)
      call ATSV(Nz,3,0,IY,Tev10, Sq,DSq)

            Erec=0.

       do k=1,IY
       Sion(j,k) = Si(k)
       Srec(j,k) = Sr(k)

c      total energy loss including radiation and ionization

       Qlos(j,k) = Sq(k)


            C = 10.**Sq(k) + Erec*10.**Sr(k)-Eion(k)*10.**Si(k) 

           Cc1 = 10.**Sq(k) 
           Cc2 = Eion(k)*10.**Si(k) 



       Qrad(j,k) = dlog10(C)



      if(cc1.lt.cc2)then
      

      write(6,'(" iy nz Tev10 TE10(j)", 2i4,8(1pe11.4))'),
     *  iy,nz,Tev10,TE10(j)
      
      write(6,'(" j k Sq Eion Si cc1 cc2", 2i4,8(1pe11.4))'),
     *  j,k,Sq(k),Eion(k),Si(k),cc1,cc2
      write(6,'(" j k Sq Sr Eion Si Erec c qrad", 2i4,8(1pe11.4))'),
     *  j,k,Sq(k),Sr(k),Eion(k),Si(k),Erec,c,Qrad(j,k)
      
      stop
            
      end if
      
!      print *,' xyu'

       eee=eion(k)*10.**Si(k)
	eee_r=Erec*10.**Sr(k)

c      write(6,'(" j k qlos qrad e_ion  Erec ", 2i4,6(1pe11.4))'),
c     *  j,k,10.**qlos(j,k),10.**qrad(j,k),eee,eee_r


      DSion(j,k) = DSi(k)
      DSrec(j,k) = DSr(k)
      DQlos(j,k) = DSq(k)
      DQrad(j,k) = ( 10.d0**Sq(k)*DSq(k) +
     + Erec*10.d0**Sr(k)*DSr(k) - Eion(k)*10.d0**Si(k)*DSi(k) )/C
            Erec=Eion(k)
                  enddo
            enddo


      if(kpr.eq.1)write(*,*)'end of Calculation of rate coefficients-'




       do j=1,N

            Ql = 0.d0
            Qr = 0.d0
            Qcx= 0.d0
            Z  = 0.d0
            C  = 0.d0
c       calculation of relative concentration of inpurity Y...
            Y = 1.d0

            C1 = 0.d0
            Z1 = 0.d0
           Ql1 = 0.d0

           Y1= 0.d0

!!!          TI=TE(j)

          TI=tn

       do k=1,IY

       k1=k-1

c------ Calculate CX-rate SVcx_k via X and its derivation:
c--- Scx(j,k) = SVcx_k, [SVcx_k] = 10^-14 m^3/s
c-- DScx(j,k) = d_lg(SVcx_k)/d_X

		  AMd=2.  !  atomic mass of deuterium
!	  AMd=1.  !  atomic mass of hydrarium


c	print *,' amd amz=',amd,amz
c	stop


      Scx(j,k) = 1.e-5*ZSVCX( float(k1),TI,AMz,AMd)

!!!        print *,' k1 ZSVCX(=',k1,ZSVCX( float(k1),TI,AMz,AMd)
        
      DScx(j,k) = ZSVCX(-float(k1),TI,AMz,AMd)
c
      Srec(j,k) =      10.d0**Srec(j,k)
      Sion(j,k) =      10.d0**Sion(j,k)
      Qlos(j,k) = 10.d0**Qlos(j,k)
      Qrad(j,k) = 10.d0**Qrad(j,k)

      if(k.ne.1) then
       DSrec(j,k) = Srec(j,k)*DSrec(j,k) + alf*Scx(j,k)*DScx(j,k)


c---- Add CX-rate with factor 'alf=N0/Ne' to Recombination rate
c  ---------  for the case of stationar solution....
        Srec(j,k) = Srec(j,k) + alf*Scx(j,k)

       DSrec(j,k) = DSrec(j,k)/Srec(j,k)

c- Calculate relative concentration of ions in different charge stats

      Y  = Y*Sion(j,k1)/Srec(j,k)

      Qcx = Qcx + Y*alf*Scx(j,k) *Eion(k1)

      Y1 = Y1 + DSion(j,k1) - DSrec(j,k)

      endif

!	print *,' j k Y=',j,k,Y

      Qr  =  Qr + Y*Qrad(j,k)
      Ql  =  Ql + Y*Qlos(j,k)

       Z  =  Z  + Y*k1
       C  =  C  + Y 

      Ql1 = Ql1 + Y*Qlos(j,k)*( Y1 + DQlos(j,k) )
      Z1  =  Z1 + Y*Y1*k1
      C1  =  C1 + Y*Y1 


!!!      if(k.ne.1) Scx(j,k) = dlog10( Scx(j,k) )


cccccccccccccccc      if(k.ne.1) Scx(j,k) = alog10( Scx(j,k) )


c---- Story lg(Y) of relative concentration of ions  
        YY(j,k) = dlog10( max(Y,1.d-38) )


         enddo  !  of k....
c
            Zcom(j,3)=Z/C
           DZcom(j,1)=alog(10.)*( Z1 - Z*C1/C)/C
           DPcom(j,1)=       (Ql1/Ql -   C1/C)
      Pcom(j,3)=dlog10( Ql/C )
      Pcom(j,4)=dlog10( Qr/C )
      Pcom(j,5)=dlog10( (Qr+Qcx)/C )
            if(j .ne. 1)  then
      DZcom(j,2)=( Zcom(j,3) - Zcom(j-1,3) )/DT10
      DPcom(j,2)=( Pcom(j,3) - Pcom(j-1,3) )/DT10
            endif
                  C = dlog10(C)
      do k=1,IY
		YY(j,k) = YY(j,k) - C
		if( YY(j,k) .gt.   0.)  YY(j,k) =   0.
		if( YY(j,k) .lt. -10.)  YY(j,k) = -10.
      enddo
     
        enddo
                  DZcom(1,2) = DZcom(2,2)
                  DPcom(1,2) = DPcom(2,2)



	return


2000	continue


	do i=1,nz
	a_print(i)=Eion(i)
	end do

	n_pr=nz
	apr='!Eion= '
	num=16

c	call out42(n_pr,a_print,num,apr)


	do i=1,nz
	a_print(i)=Si(i)
	end do

	n_pr=nz
	apr='!Si= '
	num=16

c	call out42(n_pr,a_print,num,apr)

	do i=1,nz
	a_print(i)=Sr(i)
	end do

	n_pr=nz
	apr='!Sr= '
	num=16

c	call out42(n_pr,a_print,num,apr)


	do i=1,nz
	a_print(i)=Sq(i)
	end do

	n_pr=nz
	apr='!Sq= '
	num=16

c	call out42(n_pr,a_print,num,apr)


	do i=1,n
	a_print(i)=te10(i)
	end do

	n_pr=n
	apr='!te10= '
	num=16

c	call out42(n_pr,a_print,num,apr)


	do i=1,n
	a_print(i)=te(i)
	end do

	n_pr=n
	apr='!te= '
	num=16

c	call out42(n_pr,a_print,num,apr)



	do j=1,nz

	do i=1,n
	a_print(i)=Sion(i,j)
	end do

	n_pr=n
	apr='!Sion= '
	num=16

c	call out42(n_pr,a_print,num,apr)


	if(nz.eq.6)then

	do i=1,n
	a_print(i)=Sion1(i,j)
	end do

	n_pr=n
	apr='!Sion1= '
	num=16

c	call out42(n_pr,a_print,num,apr)

	end if


	end do



	do j=1,nz

	do i=1,n
	a_print(i)=Srec(i,j)
	end do

	n_pr=n
	apr='!Srec= '
	num=16

c	call out42(n_pr,a_print,num,apr)

	if(nz.eq.6)then

	do i=1,n
	a_print(i)=Srec1(i,j)
	end do

	n_pr=n
	apr='!Srec1= '
	num=16

c	call out42(n_pr,a_print,num,apr)

	end if

	end do

	do j=1,nz


	do i=1,n
	a_print(i)=Scx(i,j)
	end do

	n_pr=n
	apr='!Scx= '
	num=16

c	call out42(n_pr,a_print,num,apr)
	if(nz.eq.6)then

	do i=1,n
	a_print(i)=Scx1(i,j)
	end do

	n_pr=n
	apr='!Scx1= '
	num=16

c	call out42(n_pr,a_print,num,apr)


		end if

	end do



	do j=1,nz

	do i=1,n
	a_print(i)=Qlos(i,j)
	end do

	n_pr=n
	apr='!Qlos= '
	num=16

c	call out42(n_pr,a_print,num,apr)

	end do
	do j=1,nz

	do i=1,n
	a_print(i)=Qrad(i,j)
	end do

	n_pr=n
	apr='!Qrad= '
	num=16

c	call out42(n_pr,a_print,num,apr)

	end do


	return
      end            
c


	subroutine tay_ee_calc(tay)
      include 'double.inc'
      include 'br_com.inc'

c*** That is for tay_loss calculation in mikrosec!!!!!
c*** tay_ee in sec!!!
	tay=tay_ee*1.d6

	return
	end


         subroutine f_prim(f_s,n)

         include 'double.inc'
         include 'param.inc'
         include 'com_mat.inc'

         dimension f_s(*)

      do i=1,n
         right(i)=f_s(i)
      end do

c      write(6,*) 'mat_prim : neq,nnz',neq,nnz

      return
      end

         subroutine mat_prim(a_t,f_s,n)

         include 'double.inc'
         include 'param.inc'
         include 'com_mat.inc'

         dimension a_t(njp,njp),f_s(*)

c   initialization of arrays ia(il),ja(im),a(im)
c
c   il - number of the matrix  line  (equation number)
c   im - number of an element in the array a(im)
c   ia(il) - number of the first nonzero element in the line  il
c   ja(im) - column number of a(im)

c------------------------

c      write(6,*) ' n==',n


      im=0

      do k=1,n
         il=k
         ia(il)=im+1

         if(k.ne.1)then
         im=im+1
         ja(im)=k-1
         a(im)=a_t(k,k-1)
         end if

         im=im+1
         ja(im)=k
         a(im)=a_t(k,k)

         if(k.ne.n)then
         im=im+1
         ja(im)=k+1
         a(im)=a_t(k,k+1)
         end if

      end do

      nnz=im
      neq=il

      il=il+1
      ia(il)=im+1

      do i=1,neq
         right(i)=f_s(i)
      end do

c      write(6,*) 'mat_prim : neq,nnz',neq,nnz

      return
      end
         subroutine solve_prim(isol,wdm)

         include'double.inc'
         include'param.inc'
         include'com_mat.inc'


         common /comwrc/ rsp,p,ip

         real*8 zw(neqp),rsp(nspp),wdm(*)

         integer pp(neqp),p(neqp),ip(neqp),isp(nspp),path,flag,esp

         equivalence (rsp(1),isp(1))

c        equivalence (right(1),zw(1))

           path=3

         if(isol.ne.0) go to 20

c         call odrvd(neq,ia,ja,a,p,ip,nspp,isp,1,flag)

c        SUBROUTINE  ODRVD
c     *     (N, IA,JA,A, P,IP, NSP,ISP, PATH, FLAG)

         path=1

         call PDRVD
     *        (Neq, IA,JA,A, P,IP, NSPp,ISP, PATH, FLAG)

           do i=1,neqp
              pp(i)=p(i)
           end do

c          do 10 i=1,neqp
c            ip(i)=i
c             p(i)=i
c10        continue

c           write(6,*) 'odrv flag=',flag


 20        continue

c         call sdrvd(neq,p,ip,ia,ja,a,right,zw,nspp,
c     *              isp,rsp,esp,path,flag)

c        SUBROUTINE SDRVD
c     *     (N, P,IP, IA,JA,A, B, Z, NSP,ISP,RSP,ESP, PATH, FLAG)


         call CDRVD
     *     (Neq, p,pp,Ip, IA,JA,A, right, Zw, NSPp,ISP,
     *  RSP,ESP, PATH, FLAG)

         if(esp.lt.0)then
            print *,' esp LT 0 , increase memory nspp=nspp+',esp
            stop
         end if


c           do 860 i=1,neq
c          write(6,*) 'zw(i) i',i,zw(i)
c860       continue
c
c           write(6,*) 'sdrv: flag,esp',flag,esp
cc
c           call nev(zw)

c raspakovka reshenia

           do  i=1,neq
              wdm(i)=zw(i)
           end do

         return
         end


         subroutine imp_outp(dens_imp_xx)

         include 'double.inc'

         include 'new_com.inc'
         include 'br_com.inc'

         include 'par_imp.inc'
         include 'new_imp.inc'

	   dimension dens_imp_xx(*)

         call imp_outp_c(dens_imp_xx,
     *   n_imp_tot,n_imp,
     *   den_imp,n_rad)

         return
         end


         subroutine imp_outp_c(dens_imp_xx,
     *   n_imp_tot,n_imp,
     *   den_imp,n_rad)

         include 'double.inc'

         include 'par_imp.inc'
 
         dimension  den_imp(nimp,nimp,*),n_imp(*)

         dimension  dens_imp_xx(*)
      
        common
     *  /ge5/kpr

c	n_rad=n

!		print *,'n_rad==== ',n_rad


	do j_x=1,n_rad

	kk=0
	do jj=1,n_imp_tot

        n=n_imp(jj)

      do i=1,n

	kk=kk+1
      dens_imp_xx(kk)=den_imp(jj,i,j_x)

 !     if(kpr.eq.1)print *,' kk dens_imp',kk,dens_imp_xx(kk)
      
!     	 call print4(' jj kk d1 d2  ==',
!     *  dfloat(jj),dfloat(kk),dens_imp_xx(kk),den_imp(jj,i,j_x))


      end do

  	end do
  	end do


        return
        end




        subroutine ech_calc()

        include 'double.inc'

        include 'new_com.inc'
        include 'br_com.inc'


!        include 'parf0'
        include 'par_imp.inc'
        include 'new_imp.inc'


c	   print *,' n_e n_i v_v0==',n_e,n_i,v_v0


        call ech_calc_c(
     *  q_ech,tt,kpr)

        return
        end

        subroutine ech_calc_c(
     *  q_ech,tt,kpr)

      include 'double.inc'
 	include 'parf_mike' 

	dimension t_t(ntime),udd_sol_t(ntime)
      character * 30 apr


	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='ech.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 


           do i=1,n_t 
              read (41,*)t_t(i),udd_sol_t(i)
              t_t(i)=t_t(i)*1000. 
           end do 
           
           apr='-t_t-' 
      if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 

           apr='-ech_t-' 
      if(kpr.eq.1)print 71,apr,(udd_sol_t(i),i=1,n_t) 

           close (unit=41) 
        end if



      do i=2,n_t
      if( (tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
	 t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )

	 udd_sol=udd_sol_t(i-1)+t_coef*(udd_sol_t(i)-
     *  udd_sol_t(i-1))
c
	 end if

	 end do


	q_ech=udd_sol

	if(kpr.eq.1)print *,' tt= q_ech',tt,q_ech



71	FORMAT(5X,A30/,(2x,6(1PE11.3)))

        return
        end





        subroutine temp_calc()

        include 'double.inc'

        include 'new_com.inc'
        include 'br_com.inc'


!        include 'parf0'
        include 'par_imp.inc'
        include 'new_imp.inc'


c	   print *,' n_e n_i v_v0==',n_e,n_i,v_v0


        call temp_calc_c(
     *  t_e,t_i,tt)

        return
        end

        subroutine temp_calc_c(
     *  t_e,t_i,tt)

      include 'double.inc'
 	include 'parf_mike' 

	dimension t_t(ntime),udd_sol_t(ntime)
      character * 30 apr


	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='temp.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 


           do i=1,n_t 
              read (41,*)t_t(i),udd_sol_t(i)
              t_t(i)=t_t(i)*1000. 
           end do 
           
           apr='-t_t-' 
      print 71,apr,(t_t(i),i=1,n_t) 

           apr='-T_e_t-' 
      print 71,apr,(udd_sol_t(i),i=1,n_t) 

           close (unit=41) 
        end if



      do i=2,n_t
      if( (tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
	 t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )

	 udd_sol=udd_sol_t(i-1)+t_coef*(udd_sol_t(i)-
     *  udd_sol_t(i-1))
c
	 end if

	 end do


	t_e=udd_sol
	t_i=t_e

	print *,' tt= t_e',tt,t_e



71	FORMAT(5X,A30/,(2x,6(1PE11.3)))

        return
        end





	subroutine shape_data_read()
	include 'double.inc'
	include 'new_com.inc'

	call shape_data_read_c(
     *  tt,tpl,rmag,eu,kpr)
	
	return
	end

	subroutine shape_data_read_c(
     *  tt,tpl,rmag,eu,kpr)

	include 'double.inc'
 	include 'parf_mike' 


	dimension t_t(ntime),tpl_t(ntime),rmag_t(ntime),eu_t(ntime),
     * den_t(ntime),pow_t(ntime)


	character *12 apr

!!!	kpr=3

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='shape_data.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 

c	n_t=n_t-1


 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 

            read (41,*)(t_t(i),i=1,n_t)
           do i=1,n_t 
c              t_t(i)=t_t(i)*1000. 
           end do 
           apr='-t_t-' 
           if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 

	
           read (41,*)

              read (41,*)(tpl_t(i),i=1,n_t)

           apr='-tpl_t-' 
           if(kpr.eq.1)print 71,apr,(tpl_t(i),i=1,n_t) 
           read (41,*)

              read (41,*)(rmag_t(i),i=1,n_t)

           apr='-rmag_t-' 
           if(kpr.eq.1)print 71,apr,(rmag_t(i),i=1,n_t) 

           read (41,*)

              read (41,*)(eu_t(i),i=1,n_t)
           
           apr='-eu_t-' 
           if(kpr.eq.1)print 71,apr,(eu_t(i),i=1,n_t) 
           read (41,*)

             read (41,*)(den_t(i),i=1,n_t)


           do i=1,n_t 
              den_t(i)=den_t(i)*1.d-19 
           end do 
           apr='-den_t-' 
           if(kpr.eq.1)print 71,apr,(den_t(i),i=1,n_t) 

           close (unit=41) 
        end if
c	read (*,*)

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))


	i_int=0

      do i=2,n_t
      if( (tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
	 t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )

	 tpl=tpl_t(i-1)+t_coef*(tpl_t(i)-tpl_t(i-1))

	 rmag=rmag_t(i-1)+t_coef*(rmag_t(i)-rmag_t(i-1))

	 eu=eu_t(i-1)+t_coef*(eu_t(i)-eu_t(i-1))

	 den=den_t(i-1)+t_coef*(den_t(i)-den_t(i-1)) 

	i_int=i
c
	 end if

	 end do

	tpl=tpl*1.d-3
	rmag=rmag*1.d2
	eu=eu*1.d2

	if(kpr.eq.1)print *,' tt tpl rmag eu  ',tt,tpl,rmag,eu
	if(kpr.eq.1)print *,' i_int t_t(i) t_t(i) ',i_int,t_t(i_int-1),
     * t_t(i_int)

c	stop

       return 
       end 








        subroutine imp_neut_calc()

        include 'double.inc'

        include 'new_com.inc'
        include 'br_com.inc'


!        include 'parf0'
        include 'par_imp.inc'
        include 'new_imp.inc'


c	   print *,' n_e n_i v_v0==',n_e,n_i,v_v0


        call imp_neut_calc_c(
     *  n_imp_tot,tt,n_d,
     *  dens_imp_neut,kpr,t_e)

        return
        end

        subroutine imp_neut_calc_c(
     *  n_imp_tot,tt,n_d,
     *  dens_imp_neut,kpr,t_e)

      include 'double.inc'
	dimension dens_imp_neut(*)
      character * 30 apr
 	include 'parf_mike' 

      include 'double_break1.inc'

	dimension t_t(ntime),udd_sol_t(ntime)


!	n_imp_tot=1
	n_imp_tot=2


	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='dens_imp_neut.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t,t_bar
           read (41,*) 


           do i=1,n_t 
              read (41,*)t_t(i),udd_sol_t(i)
              t_t(i)=t_t(i)*1000. 
           end do 
           
           apr='-t_t-' 
      if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 

           apr='-dens_t-' 
      if(kpr.eq.1)print 71,apr,(udd_sol_t(i),i=1,n_t) 

           close (unit=41) 
        end if



      do i=2,n_t
      if( (tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
	 t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )

	 udd_sol=udd_sol_t(i-1)+t_coef*(udd_sol_t(i)-
     *  udd_sol_t(i-1))
c
	 end if

	 end do


!  Intital impurity neutrals density.(1.e19)

!	dens_imp_neut(1)=udd_sol

	if(t_e.gt.t_bar+1.d-3)then 
	alf_c=1.d0
	end if
	if(t_e.le.t_bar-1.d-3)then 
	alf_c=0.d0
	end if

	alf_c=1.d0


!!!	dens_imp_neut(1)=udd_sol*(n_d*10.d0)*alf_c
	dens_imp_neut(1)=udd_sol*alf_c

	if(kpr.eq.1)print *,'t_e alf_c=',t_e,alf_c


	if(kpr.eq.1)print *,' tt t_bar=',tt,t_bar

        apr=' dens_imp_neut'
        if(kpr.eq.1)print 71,apr,(dens_imp_neut(j),j=1,1)

c	read (*,*)


71	FORMAT(5X,A30/,(2x,6(1PE11.3)))

        return
        end


        subroutine imp_neut_calc2()

        include 'double.inc'

        include 'new_com.inc'
        include 'br_com.inc'


!        include 'parf0'
        include 'par_imp.inc'
        include 'new_imp.inc'


c	   print *,' n_e n_i v_v0==',n_e,n_i,v_v0


        call imp_neut_calc2_c(
     *  n_imp_tot,tt,n_d,
     *  dens_imp_neut,kpr,t_e)

        return
        end

        subroutine imp_neut_calc2_c(
     *  n_imp_tot,tt,n_d,
     *  dens_imp_neut,kpr,t_e)

      include 'double.inc'
	dimension dens_imp_neut(*)
      character * 30 apr
 	include 'parf_mike' 

      include 'double_break1.inc'

	dimension t_t(ntime),udd_sol_t(ntime)


!	n_imp_tot=1
	n_imp_tot=2


	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='dens_imp_neut2.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t,t_bar
           read (41,*) 


           do i=1,n_t 
              read (41,*)t_t(i),udd_sol_t(i)
              t_t(i)=t_t(i)*1000. 
           end do 
           
           apr='-t_t-' 
      if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 

           apr='-dens_t-' 
      if(kpr.eq.1)print 71,apr,(udd_sol_t(i),i=1,n_t) 

           close (unit=41) 
        end if



      do i=2,n_t
      if( (tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
	 t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )

	 udd_sol=udd_sol_t(i-1)+t_coef*(udd_sol_t(i)-
     *  udd_sol_t(i-1))
c
	 end if

	 end do


!  Intital impurity neutrals density.(1.e19)

!	dens_imp_neut(1)=udd_sol


	if(t_e.gt.t_bar+1.d-3)then 
	alf_c=1.d0
	end if
	if(t_e.le.t_bar-1.d-3)then 
	alf_c=0.d0
	end if

	alf_c=1.d0


!!!	dens_imp_neut(2)=udd_sol*(n_d*10.d0)*alf_c
	dens_imp_neut(2)=udd_sol*alf_c

	if(kpr.eq.1)print *,'t_e alf_c=',t_e,alf_c


	if(kpr.eq.1)print *,' tt t_bar=',tt,t_bar

       apr=' dens_imp_neut'
        if(kpr.eq.1)print 71,apr,(dens_imp_neut(j),j=1,1)
c	read (*,*)


71	FORMAT(5X,A30/,(2x,6(1PE11.3)))

        return
        end

      subroutine dopp_1()
      include 'double.inc'
      include 'new_com.inc'

      call dopp_1_c(
     * kpr,rmag,zmag,elong,eu,betj,uli,q,n)


      return
      end
      subroutine dopp_1_c(
     * kpr,rmag,zmag,elong,eu,betj,uli,q,n)

      include 'double.inc'
      include 'parf0'
      include 'parf3'

      common
     *	/igr/ygr(iy,ny),tgr(ny),igr
      common
     *	/ng_igr/ng

	character *12 yy(iy)
	character *50 tmp

	dimension q(*)

      include 'dop_br_1.inc'


	return
	end




        subroutine kin_imp_min()

        include 'double.inc'

        include 'new_com.inc'
        include 'par_imp.inc'
        include 'new_imp.inc'

        call kin_imp_min_c(
     *  tt,n_imp_tot,
     *  den,tempe,tempi,sel,
     *  den_imp,dens_imp_neut,n_imp,z_imp,
     *  den_neut,q_rad,n_rad,kpr)

        return
        end

        subroutine kin_imp_min_c(
     *  tt,n_imp_tot,
     *  den,tempe,tempi,sel,
     *  den_imp,dens_imp_neut,n_imp,z_imp,
     *  den_neut,q_rad,n_rad,kpr)

        include 'double.inc'

 	  include 'parf_mike' 
        include 'par_imp.inc'
	  parameter (nip=nimp)
 
        dimension z_imp(*),n_imp(*)

        dimension
     *  den(*),tempe(*),tempi(*),sel(*),q_rad(*)

	dimension
     *  den_imp(nip,nip,*),dens_imp_neut(*),
     *  denz(nip),radz(nip)

c---------------------

	dimension
     *  den_neut(*)

	dimension t_t(ntime),d_impp_t(7,ntime),den_impu(6),
     *  tempe_t(ntime),tempi_t(ntime)

	character *12 apr

       i=1
	 j=1

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='imp_min.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 
           
           if(kpr.eq.1)print *,' tay tt n_t===',tay,tt,n_t 
           
           do i=1,n_t 
              read (41,*)t_t(i),(d_impp_t(k,i),k=1,7)
              t_t(i)=t_t(i)*1000. 
           end do 
           
           apr='-t_t-' 
           if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 

           apr='-d_impp_t-' 
           if(kpr.eq.1)print 71,apr,((d_impp_t(k,i),k=1,7),i=1,n_t) 


           close (unit=41) 


           open (unit=41,file='temp_min.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 
           
           if(kpr.eq.1)print *,' tay tt n_t===',tay,tt,n_t 
           
           do i=1,n_t 
              read (41,*)t_t(i),tempe_t(i),tempi_t(i)
              t_t(i)=t_t(i)*1000. 
           end do 
           
           apr='-t_t-' 
           if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 

           apr='-tempe_t-' 
           if(kpr.eq.1)print 71,apr,(tempe_t(i),i=1,n_t) 

           apr='-tempi_t-' 
           if(kpr.eq.1)print 71,apr,(tempi_t(i),i=1,n_t) 


           close (unit=41) 




        end if

71	FORMAT(20X,A8/,(7(1X,1PE10.3)))


!!!	tt=754.

        do i=2,n_t
           if((tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
              t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )

          d_imp=d_impp_t(1,i-1)+t_coef*
     *    (d_impp_t(1,i)-d_impp_t(1,i-1))

c          den_imp_n(1,1)=d_imp*10.d0
          dens_imp_neut(1)=d_imp*10.d0
          tempe(1)=tempe_t(i-1)+t_coef*
     *    (tempe_t(i)-tempe_t(i-1))

          tempi(1)=tempi_t(i-1)+t_coef*
     *    (tempi_t(i)-tempi_t(i-1))


	  tempe(1)=tempe(1)*1.d3
	  tempi(1)=tempi(1)*1.d3


c--------------------------------

        do kk=1,n_imp(j)
	  k=kk+1
          d_imp=d_impp_t(k,i-1)+t_coef*
     *    (d_impp_t(k,i)-d_impp_t(k,i-1))

          den_imp(j,kk,1)=d_imp*10.d0
          den_impu(kk)=d_imp*10.d0

c	write(6,'(" kk den_imp",
c     *  i4,6(1pe11.4))'),
c     *  k,den_imp(j,kk,1)


        end do


c
	 end if

	 end do

	call print4('tt te ti d0 ==',tt,tempe(1),tempi(1),
     *  dens_imp_neut(1))

	kk=6
	call printa('den_imp ==',den_impu,kk)
	

c	write(6,'(" sel_ij sel_h1 sel_h2",
c     *  6(1pe11.4))'),
c     *  sel_ij,sel_h1,sel_h2

c	stop

	return
	end





      subroutine en_01_min()
      include 'double.inc'
      include 'new_com.inc'
      include 'br_com.inc'

      call en_01_min_c(n_rad,
     * tay,kpr,n_e,n_e0,n_d,n_d0,n0,n00,T_e,T_e0,T_i,T_i0,
     * pi,a_min,R_maj,tt,n_i,n_i0,
     * I_p,I_p0,p_oh,p_cx,p_ioniz,p_rad,q_ech,z_eff,v_v0,v_p,
     * sel,v_n,p_lambda,r_pl0,v_v00,tay_ee,
     * tpl,eu,rmag,alf_n,tay_lo,v_p0,anom_e,g_v,
     * vloop,uact,betj,k_dm0)


c----------------------
c----------------------
c----------------------

      return
      end
      subroutine en_01_min_c(n,
     * tay_old,kpr,n_e,n_e0,n_d,n_d0,n0,n00,T_e,T_e0,T_i,T_i0,
     * pi,a,R,tt,n_i,n_i0,
     * I_p,I_p0,p_oh,p_cx,p_ioniz,p_rad,q_ech,z_eff,v_v0,v_p,
     * sel,v_n,p_lambda,r_pl,v_v00,tay_ee,
     * tpl,eu,rmag,alf_n,tay_lo,v_p0,anom_e,g_v,
     * vloop,uact,betj,k_dm0)

      include 'double.inc'

      include 'parf0'

      include 'double_break1.inc'


      dimension sel(*)

      include 'parf3'

 	  include 'parf_mike' 
	dimension t_t(ntime),d_nd_t(ntime),d_n0_t(ntime),d_ne_t(ntime),
     *  tempe_t(ntime),tempi_t(ntime)

	character *12 apr


	return


	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='dens_min.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 
           
           if(kpr.eq.1)print *,' tay tt n_t===',tay,tt,n_t 
           
           do i=1,n_t 
              read (41,*)t_t(i),d_ne_t(i),d_nd_t(i),d_n0_t(i)
              t_t(i)=t_t(i)*1000. 
           end do 
           
           apr='-t_t-' 
           if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 



           close (unit=41) 


           open (unit=41,file='temp_min.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 
           
           if(kpr.eq.1)print *,' tay tt n_t===',tay,tt,n_t 
           
           do i=1,n_t 
              read (41,*)t_t(i),tempe_t(i),tempi_t(i)
              t_t(i)=t_t(i)*1000. 
           end do 
           
           apr='-t_t-' 
           if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 

           apr='-tempe_t-' 
           if(kpr.eq.1)print 71,apr,(tempe_t(i),i=1,n_t) 

           apr='-tempi_t-' 
           if(kpr.eq.1)print 71,apr,(tempi_t(i),i=1,n_t) 


           close (unit=41) 




        end if

71	FORMAT(20X,A8/,(7(1X,1PE10.3)))

        do i=2,n_t
           if((tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
              t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )

          n_d=d_nd_t(i-1)+t_coef*
     *    (d_nd_t(i)-d_nd_t(i-1))

          n_e=d_ne_t(i-1)+t_coef*
     *    (d_ne_t(i)-d_ne_t(i-1))

          n0=d_n0_t(i-1)+t_coef*
     *    (d_n0_t(i)-d_n0_t(i-1))


          T_e=tempe_t(i-1)+t_coef*
     *    (tempe_t(i)-tempe_t(i-1))

          T_i=tempi_t(i-1)+t_coef*
     *    (tempi_t(i)-tempi_t(i-1))



	end if
	end do


!!	call print2(' tt n_e ==',tt,n_e)
!!	call print4(' te ti n_d n0 ==',t_e,t_i,n_d,n0)


      return
      end


      subroutine dens_01_min()
      include 'double.inc'
      include 'new_com.inc'
      include 'br_com.inc'

      call dens_01_min_c(n_rad,
     * tay,kpr,n_e,n_e0,n_d,n_d0,n0,n00,T_e,T_e0,T_i,T_i0,
     * pi,a_min,R_maj,tt,n_i,n_i0,
     * I_p,I_p0,p_oh,p_cx,p_ioniz,p_rad,q_ech,z_eff,v_v0,v_p,
     * sel,v_n,p_lambda,r_pl0,v_v00,tay_ee,
     * tpl,eu,rmag,alf_n,tay_lo,v_p0,anom_e,g_v,
     * vloop,uact,betj,k_dm0)


c----------------------
c----------------------
c----------------------

      return
      end
      subroutine dens_01_min_c(n,
     * tay_old,kpr,n_e,n_e0,n_d,n_d0,n0,n00,T_e,T_e0,T_i,T_i0,
     * pi,a,R,tt,n_i,n_i0,
     * I_p,I_p0,p_oh,p_cx,p_ioniz,p_rad,q_ech,z_eff,v_v0,v_p,
     * sel,v_n,p_lambda,r_pl,v_v00,tay_ee,
     * tpl,eu,rmag,alf_n,tay_lo,v_p0,anom_e,g_v,
     * vloop,uact,betj,k_dm0)

      include 'double.inc'

      include 'parf0'

      include 'double_break1.inc'


      dimension sel(*)

      include 'parf3'

 	  include 'parf_mike' 
	dimension t_t(ntime),d_nd_t(ntime),d_n0_t(ntime),d_ne_t(ntime),
     *  tempe_t(ntime),tempi_t(ntime)

	character *12 apr


	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='dens_min.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 
           
           if(kpr.eq.1)print *,' tay tt n_t===',tay,tt,n_t 
           
           do i=1,n_t 
              read (41,*)t_t(i),d_ne_t(i),d_nd_t(i),d_n0_t(i)
              t_t(i)=t_t(i)*1000. 
           end do 
           
           apr='-t_t-' 
           if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 



           close (unit=41) 



        end if

71	FORMAT(20X,A8/,(7(1X,1PE10.3)))

        do i=2,n_t
           if((tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
              t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )

          n_d=d_nd_t(i-1)+t_coef*
     *    (d_nd_t(i)-d_nd_t(i-1))

          n_e=d_ne_t(i-1)+t_coef*
     *    (d_ne_t(i)-d_ne_t(i-1))

          n0=d_n0_t(i-1)+t_coef*
     *    (d_n0_t(i)-d_n0_t(i-1))



	end if
	end do


!!!	call print4(' tt n_e n_d n0==',tt,n_e,n_d,n0)


      return
      end



      subroutine tay_e_ip(tay_ee,tpl,tt)

      include 'double.inc'

      include 'parf0'

      include 'parf_mike' 
	dimension t_t(ntime),taye_t(ntime),tpl_t(ntime)

	character *12 apr


	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='taye_min.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 
           
           if(kpr.eq.1)print *,' tay tt n_t===',tay,tt,n_t 
           
           do i=1,n_t 
              read (41,*)t_t(i),taye_t(i),tpl_t(i)
              t_t(i)=t_t(i)*1000. 
           end do 
           
           apr='-t_t-' 
           if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 



           close (unit=41) 



        end if

71	FORMAT(20X,A8/,(7(1X,1PE10.3)))

        do i=2,n_t
           if((tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
              t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )

          tay_ee=taye_t(i-1)+t_coef*
     *    (taye_t(i)-taye_t(i-1))

          tpl=tpl_t(i-1)+t_coef*
     *    (tpl_t(i)-tpl_t(i-1))


	end if
	end do


!!!	call print3(' tt tay_ee tpl==',tt,tay_ee,tpl)


      return
      end


         subroutine kin_imp_test(j_x)

         include 'double.inc'

         include 'new_com.inc'
         include 'br_com.inc'

         include 'par_imp.inc'
         include 'new_imp.inc'

         call kin_imp_test_c(j_x,
     *   n_imp_tot,n_imp,
     *   den_imp,den0_imp,
     *   den_imp_n,den0_imp_n,den_neut,
     *   tempe,tempi,den,tay,
     *   z_imp,dens_imp_neut,alf_n,tay_lo,v_n,v_p,kpr,
     *   ratio_imp,ratio_imp2,gamma_z,gamma_z2)

         return
         end


         subroutine kin_imp_test_c(j_x,
     *   n_imp_tot,n_imp,
     *   den_imp,den0_imp,
     *   den_imp_n,den0_imp_n,den_neut,
     *   tempe,tempi,den,tay,
     *   z_imp,dens_imp_neut,alf_n,tay_lo,v_n,v_p,kpr,
     *   ratio_imp,ratio_imp2,gamma_z,gamma_z2)

         include 'double.inc'

         include 'par_imp.inc'
         include 'parf0'

         dimension tempe(*),tempi(*),den(*)

         dimension  den_imp(nimp,nimp,*),den0_imp(nimp,nimp,*)

         dimension  den_imp_n(nimp,*),den0_imp_n(nimp,*),den_neut(*)

         dimension z_imp(*),n_imp(*)

         include 'parrc1.inc'
c Local arrays
         dimension a_imp(njp,njp),f_imp(njp),
     *   d_imp(njp),d_imp0(njp),den_temp(njp)

         dimension tay_h(njp),f_h(njp),den_im(njp)

        dimension rin_zog(njp),rre_zog(njp),rcx_zog(njp)

	dimension dens_imp_neut(*),tay_loss(njp),
     *  f_imp1(njp),f_imp2(njp),d_imp1(njp),d_imp2(njp),
     *  wion(7),wrec(7)

 	   tay_help=tay*1.d+3  !  In Microsecons

c	tay_lo=0.2*1.d6

       te=tempe(j_x)

c  Neutrals Density ... den_n=1 temporarily

         den_n=den_neut(j_x)*alf_n


c	den_n=0.d0

c  Ions Density ... den_i

         den_i=den(j_x)

!!!       call w_filter(den_i)

c  Neutral Impurity  Density ... den_im=1 temporarily

	jj=1

	den_imp_n(jj,j_x)=dens_imp_neut(jj)

      den_im(jj)=den_imp_n(jj,j_x)


c  Neutrals Temperature .. tn=ti?

         tn=tempi(j_x)

         ti=tn
c	if(kpr.eq.1)write(6,'(" n_imp_tot j_x te  tn",
c     *  2i4,6(1pe12.5))'),
c     *  n_imp_tot,j_x,te,tn


c	if(kpr.eq.1)write(6,'(" den_n den_i den_im ",
c     *  6(1pe12.5))'),
c     *  den_n,den_i,den_im

c         n_imp=6

      den_e=den_i

c      Begin calculation for each impurity jj=1:n_imp_tot


         n=n_imp(jj)

C  i=1,6 are Carbon Charge states  jj=1

C  i=1,8 are Oxigen Charge states  jj=2


       do i=1,n+1
	    tay_h(i)=tay_help
!		tay_loss(i)=1.d3*z_imp(i)**2*alf1
!		tay_loss(i)=1.d3*z_imp(i)**3*alf1
		tay_loss(i)=tay_lo

c	if(jj.eq.2.and.i.eq.n)tay_loss(i)=0.1d-0*tay_lo/z_imp(i)

c	tay_loss(i)=1.d-1*tay_loss(i)
c	if(i.eq.6)tay_loss(i)=tay_loss(i)*100.d0


	 end do

         do i=1,n
            d_imp(i)=den_imp(jj,i,j_x)
            d_imp0(i)=den0_imp(jj,i,j_x)

c            print *,' i z_imp',i,z_imp(i)

            den_e=den_e+z_imp(i)*d_imp(i)

         end do


c	te=1.
c	tn=1.

	nz_inp=n
       call rates_zog(te,tn,nz_inp,
     *  rin_zog,rre_zog,rcx_zog)

!!!      call test1_c(te,wion,wrec)

      do i=1,n+1
	jz=i-1

c            rin_zog(i)=rin(te,jz)
c            rre_zog(i)=rre(te,jz)
c            rcx_zog(i)=rcx(tn,jz)


!	write(6,'("  n i c_ion wion c_rec  wrec ",
!     *  2i4,6(1pe12.5))'),
!     *  n,i,rin_zog(i),wion(i)*1.d6,rre_zog(i),wrec(i)*1.d6

!	 rin_zog(i)=wion(i)*1.d6
!	 rre_zog(i)=wrec(i)*1.d6

      end do



!!!	rin_zog(3)=rin_zog(3)*0.5

       do i=1,n+1

	 s_ex=3.6d-1*(i-1)*sqrt(ti*1.d-3)

c	write(6,'("  ## n i  c_ex s_ex",
c     *  2i4,6(1pe12.5))'),
c     *  n,i,rcx_zog(i),s_ex

	rcx_zog(i)=s_ex

c            rre_zog(i)=0.
c            rcx_zog(i)=0.




      end do


	i_int=0

1	continue
c	stop

c	read (*,*)

         do j=1,n
            do i=1,n
               a_imp(i,j)=0.
            end do
         end do


         do i=1,n
            a_imp(i,i)=1.d0/tay_h(i)

c   Impurity loss term
            a_imp(i,i)=a_imp(i,i)+1.d0/tay_loss(i)

            f_imp(i)=d_imp0(i)/tay_h(i)

            if(i.gt.1)then
               jz=i

c               c_ion=rin(te,jz-1)
c               c_rec=rre(te,jz)

               c_ion=rin_zog(jz-1+1)
               c_rec=rre_zog(jz+1)


c               den_temp(i)=den_temp(i-1)*c_ion/c_rec
            else
               jz=0
!               c_ion=rin(te,jz)
               c_ion=rin_zog(jz+1)

c               den_temp(i)=den_im(jj)*c_ion
            end if


c	if(kpr.eq.1)write(6,'("  den_temp(i) den_im c_ion",
c     *  6(1pe14.7))'),
c     *  den_temp(i),den_im,c_ion

c	if(kpr.eq.1)write(6,'(" i a_imp f_imp den_temp den_e te",
c     *  i4,6(1pe14.7))'),
c     *  i,a_imp(i,i),f_imp(i),den_temp(i),den_e,te

         end do


         do i=1,n

            if(i.ne.1)then
               j=i-1
               jz=j
!               c_ion=rin(te,jz)
               c_ion=rin_zog(jz+1)

               a_imp(i,j)=a_imp(i,j)-c_ion*den_e


c	if(kpr.eq.1)write(6,'(" i j c_ion a_imp",
c     *  2i4,6(1pe12.5))'),
c     *  i,j,c_ion,a_imp(i,j)

             else
               j=i-1
               jz=j
!               c_ion=rin(te,jz)
               c_ion=rin_zog(jz+1)

               f_imp(i)=f_imp(i)+c_ion*den_im(jj)*den_e

c	if(kpr.eq.1)write(6,'("  i j c_ion f_imp den_im den_e ",
c     *  2i4,6(1pe12.5))'),
c     *  i,j,c_ion,f_imp(i),den_im,den_e
            end if

            j=i
            jz=j
            if(i.ne.n)then
c            c_ion=rin(te,jz)
c            c_rec=rre(te,jz)
c            c_ex=rcx(tn,jz)

            c_ion=rin_zog(jz+1)
            c_rec=rre_zog(jz+1)
            c_ex=rcx_zog(jz+1)

            a_imp(i,j)=a_imp(i,j)+(c_ion+c_rec)*den_e+c_ex*den_n

c	if(kpr.eq.1)write(6,'("  i j c_ion c_rec c_ex a_imp",
c     *  2i4,6(1pe12.5))'),
c     *  i,j,c_ion,c_rec,c_ex,a_imp(i,j)


            else

c            c_rec=rre(te,jz)
c            c_ex=rcx(tn,jz)

            c_rec=rre_zog(jz+1)
            c_ex=rcx_zog(jz+1)

            a_imp(i,j)=a_imp(i,j)+c_rec*den_e+c_ex*den_n
c	if(kpr.eq.1)write(6,'("  i j c_ion c_rec c_ex a_imp",
c     *  2i4,6(1pe12.5))'),
c     *  i,j,c_ion,c_rec,c_ex,a_imp(i,j)

            end if

            if(i.ne.n)then
            j=i+1
            jz=j
c            c_rec=rre(te,jz)
c            c_ex=rcx(tn,jz)

            c_rec=rre_zog(jz+1)
            c_ex=rcx_zog(jz+1)


            a_imp(i,j)=a_imp(i,j)-c_rec*den_e-c_ex*den_n

c 	if(kpr.eq.1)write(6,'("  i j c_ion c_rec c_ex a_imp",
c     *  2i4,6(1pe12.5))'),
c     *  i,j,c_ion,c_rec,c_ex,a_imp(i,j)
           end if

         end do  ! i loop

	call print3(' d_im0 den_n den_e==',den_im(1),den_n,den_e)

        do i=1,n
	  	f_h(i)=0.d0
	  do k=1,n
	    f_h(i)=f_h(i)+a_imp(i,k)*d_imp(k)
	  end do

	call print4(' f_h f_imp d_i di_0==',
     *  f_h(i),f_imp(i),d_imp(i),d_imp0(i))
			
c	  write(6,'(" i f_h f_imp",
c     *  i4,6(1pe12.5))'),
c     *  i,f_h(i),f_imp(i)


        end do

        return
        end


         subroutine kin_imp_test2(j_x)

         include 'double.inc'

         include 'new_com.inc'
         include 'br_com.inc'

         include 'par_imp.inc'
         include 'new_imp.inc'

         call kin_imp_test2_c(j_x,
     *   n_imp_tot,n_imp,
     *   den_imp,den0_imp,
     *   den_imp_n,den0_imp_n,den_neut,
     *   tempe,tempi,den,tay,
     *   z_imp,dens_imp_neut,alf_n,tay_lo,v_n,v_p,kpr,
     *   ratio_imp,ratio_imp2,gamma_z,gamma_z2)

         return
         end


         subroutine kin_imp_test2_c(j_x,
     *   n_imp_tot,n_imp,
     *   den_imp,den0_imp,
     *   den_imp_n,den0_imp_n,den_neut,
     *   tempe,tempi,den,tay,
     *   z_imp,dens_imp_neut,alf_n,tay_lo,v_n,v_p,kpr,
     *   ratio_imp,ratio_imp2,gamma_z,gamma_z2)

         include 'double.inc'

         include 'par_imp.inc'
         include 'parf0'

         dimension tempe(*),tempi(*),den(*)

         dimension  den_imp(nimp,nimp,*),den0_imp(nimp,nimp,*)

         dimension  den_imp_n(nimp,*),den0_imp_n(nimp,*),den_neut(*)

         dimension z_imp(*),n_imp(*)

         include 'parrc1.inc'
c Local arrays
         dimension a_imp(njp,njp),f_imp(njp),
     *   d_imp(njp),d_imp0(njp),den_temp(njp)

         dimension tay_h(njp),f_h(njp),den_im(njp)

        dimension rin_zog(njp),rre_zog(njp),rcx_zog(njp)

	dimension dens_imp_neut(*),tay_loss(njp),
     *  f_imp1(njp),f_imp2(njp),d_imp1(njp),d_imp2(njp),
     *  wion(7),wrec(7)

 	   tay_help=tay*1.d+3  !  In Microsecons


c	tay_lo=0.2*1.d6

       te=tempe(j_x)

c  Neutrals Density ... den_n=1 temporarily

         den_n=den_neut(j_x)*alf_n


c	den_n=0.d0

c  Ions Density ... den_i

         den_i=den(j_x)

!!!       call w_filter(den_i)

c  Neutral Impurity  Density ... den_im=1 temporarily

	jj=1

	den_imp_n(jj,j_x)=dens_imp_neut(jj)

      den_im(jj)=den_imp_n(jj,j_x)


c  Neutrals Temperature .. tn=ti?

         tn=tempi(j_x)

         ti=tn
c	if(kpr.eq.1)write(6,'(" n_imp_tot j_x te  tn",
c     *  2i4,6(1pe12.5))'),
c     *  n_imp_tot,j_x,te,tn


c	if(kpr.eq.1)write(6,'(" den_n den_i den_im ",
c     *  6(1pe12.5))'),
c     *  den_n,den_i,den_im

c         n_imp=6

      den_e=den_i

c      Begin calculation for each impurity jj=1:n_imp_tot


         n=n_imp(jj)

C  i=1,6 are Carbon Charge states  jj=1

C  i=1,8 are Oxigen Charge states  jj=2


       do i=1,n+1
	    tay_h(i)=tay_help
!		tay_loss(i)=1.d3*z_imp(i)**2*alf1
!		tay_loss(i)=1.d3*z_imp(i)**3*alf1
		tay_loss(i)=tay_lo

c	if(jj.eq.2.and.i.eq.n)tay_loss(i)=0.1d-0*tay_lo/z_imp(i)

c	tay_loss(i)=1.d-1*tay_loss(i)
c	if(i.eq.6)tay_loss(i)=tay_loss(i)*100.d0


	 end do

         do i=1,n
            d_imp(i)=den_imp(jj,i,j_x)
            d_imp0(i)=den0_imp(jj,i,j_x)

c            print *,' i z_imp',i,z_imp(i)

            den_e=den_e+z_imp(i)*d_imp(i)

         end do


c	te=1.
c	tn=1.

	nz_inp=n
       call rates_zog(te,tn,nz_inp,
     *  rin_zog,rre_zog,rcx_zog)

!      call test1_c(te,wion,wrec)

!	write(6,'(" te tn den_e ",
!     *  6(1pe12.5))'),
!     *  te,tn,den_e


      do i=1,n+1
	jz=i-1

c            rin_zog(i)=rin(te,jz)
c            rre_zog(i)=rre(te,jz)
c            rcx_zog(i)=rcx(tn,jz)


!	write(6,'("  n i c_ion wion c_rec  wrec ",
!     *  2i4,6(1pe12.5))'),
!     *  n,i,rin_zog(i),wion(i)*1.d6,rre_zog(i),wrec(i)*1.d6

!	 rin_zog(i)=wion(i)*1.d6
!	 rre_zog(i)=wrec(i)*1.d6

      end do



!!!	rin_zog(3)=rin_zog(3)*0.5

       do i=1,n+1

	 s_ex=3.6d-1*(i-1)*sqrt(ti*1.d-3)

c	write(6,'("  ## n i  c_ex s_ex",
c     *  2i4,6(1pe12.5))'),
c     *  n,i,rcx_zog(i),s_ex

	rcx_zog(i)=s_ex

c            rre_zog(i)=0.
c            rcx_zog(i)=0.




      end do


	i_int=0

1	continue
c	stop

c	read (*,*)

         do j=1,n
            do i=1,n
               a_imp(i,j)=0.
            end do
         end do


         do i=1,n
            f_imp1(i)=(d_imp(i)-d_imp0(i))/tay_h(i)
            f_imp(i)=-d_imp(i)/tay_loss(i)
         end do


         do i=1,n

            if(i.ne.1)then
               j=i-1
               jz=j
               c_ion=rin_zog(jz+1)

!               a_imp(i,j)=a_imp(i,j)-c_ion*den_e
            f_imp(i)=f_imp(i)+d_imp(i-1)*c_ion*den_e

             else
               j=i-1
               jz=j
               c_ion=rin_zog(jz+1)
               f_imp(i)=f_imp(i)+c_ion*den_im(jj)*den_e
            end if

            j=i
            jz=j
            if(i.ne.n)then
            c_ion=rin_zog(jz+1)
            c_rec=rre_zog(jz+1)
            c_ex=rcx_zog(jz+1)

!!!            a_imp(i,j)=a_imp(i,j)+(c_ion+c_rec)*den_e+c_ex*den_n
            f_imp(i)=f_imp(i)-d_imp(i)*((c_ion+c_rec)*den_e
     *      +c_ex*den_n)

            else
            c_rec=rre_zog(jz+1)
            c_ex=rcx_zog(jz+1)

!!!            a_imp(i,j)=a_imp(i,j)+c_rec*den_e+c_ex*den_n
            f_imp(i)=f_imp(i)-d_imp(i)*(c_rec*den_e
     *      +c_ex*den_n)
            end if

            if(i.ne.n)then
            j=i+1
            jz=j
            c_rec=rre_zog(jz+1)
            c_ex=rcx_zog(jz+1)

!!!            a_imp(i,j)=a_imp(i,j)-c_rec*den_e-c_ex*den_n
            f_imp(i)=f_imp(i)+d_imp(i+1)*(c_rec*den_e
     *      +c_ex*den_n)

        end if

         end do  ! i loop

	call print3(' d_im0 den_n den_e==',den_im(1),den_n,den_e)

	do i=1,n
	call print4(' f_imp1 f_imp d_i di_0==',
     *  f_imp1(i),f_imp(i),d_imp(i),d_imp0(i))
			
c	  write(6,'(" i f_h f_imp",
c     *  i4,6(1pe12.5))'),
c     *  i,f_h(i),f_imp(i)


        end do

        return
        end


      subroutine n_dd_read()
	include 'double.inc'
	include 'new_com.inc'
      include 'br_com.inc'

	call n_dd_read_c(
     *       n_d,tt,kpr,pd0_p)

	return
	end
      subroutine n_dd_read_c(
     *       n_d,tt,kpr,pd0_p)

	include 'double.inc'
 	include 'parf_mike' 

      include 'double_break1.inc'

	dimension t_t(ntime),pn_d_t(ntime)
	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='n_d.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 
           
           if(kpr.eq.1)print *,' tay tt n_t===',tay,tt,n_t 
           
           do i=1,n_t 
              read (41,*)t_t(i),pn_d_t(i)
              t_t(i)=t_t(i)*1000. 
           if(kpr.eq.1)print *,' i t_t n_dd_t==',i,t_t(i),pn_d_t(i)
           end do 
           
           apr='-t_dd_t-' 
           if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 

           apr='-n_dd_t-' 
           if(kpr.eq.1)print 71,apr,(pn_d_t(i),i=1,n_t) 


           close (unit=41) 
        end if


71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

        do i=2,n_t
           if((tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
              t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )

              n_d=pn_d_t(i-1)+t_coef*
     *             (pn_d_t(i)-pn_d_t(i-1))
c
	 end if

	 end do

      pd0_p=n_d
      n_d=n_d*0.1d0
      if(kpr.eq.1)print *,' tt n_d pd0_d==',tt,n_d,pd0_p
c	stop

        
	return
	end

         subroutine kin_imp_testt(j_x)

         include 'double.inc'

         include 'new_com.inc'
         include 'br_com.inc'

         include 'par_imp.inc'
         include 'new_imp.inc'

    !     gamma_z2=1.e-3
    !         tay_lo=1.d10

         call kin_imp_testt_c(j_x,
     *   n_imp_tot,n_imp,
     *   den_imp,den0_imp,
     *   den_imp_n,den0_imp_n,den_neut,
     *   tempe,tempi,den,tay,
     *   z_imp,dens_imp_neut,alf_n,tay_lo,v_n,v_p,kpr,
     *   ratio_imp,ratio_imp2,gamma_z,gamma_z2)

         return
         end


         subroutine kin_imp_testt_c(j_x,
     *   n_imp_tot,n_imp,
     *   den_imp,den0_imp,
     *   den_imp_n,den0_imp_n,den_neut,
     *   tempe,tempi,den,tay,
     *   z_imp,dens_imp_neut,alf_n,tay_lo,v_n,v_p,kpr,
     *   ratio_imp,ratio_imp2,gamma_z,gamma_z2)

         include 'double.inc'

         include 'par_imp.inc'
         include 'parf0'

         dimension tempe(*),tempi(*),den(*)

         dimension  den_imp(nimp,nimp,*),den0_imp(nimp,nimp,*)

         dimension  den_imp_n(nimp,*),den0_imp_n(nimp,*),den_neut(*)

         dimension z_imp(*),n_imp(*)

         include 'parrc1.inc'
c Local arrays
         dimension a_imp(njp,njp),f_imp(njp),
     *   d_imp(njp),d_imp0(njp),den_temp(njp)

         dimension tay_h(njp),f_h(njp),den_im(njp)

        dimension rin_zog(njp),rre_zog(njp),rcx_zog(njp)

	dimension dens_imp_neut(*),tay_loss(njp),
     *  f_imp1(njp),f_imp2(njp),d_imp1(njp),d_imp2(njp)

 	   tay_help=tay*1.d+3  !  In Microsecons

	i_test=0
	if(i_test.eq.1)then
	
	do kk=1,500
	
	te=kk
	tn=1.

	write(6,'("  T_e ",
     *  6(1pe12.5))'),
     *  te

      n=n_imp(1)
	nz_inp=n
       call rates_zog(te,tn,nz_inp,
     *  rin_zog,rre_zog,rcx_zog)

       do i=1,n+1

	write(6,'("  ##  i  I R ",
     *  i4,6(1pe12.5))'),
     *  i,rin_zog(i)*1.d-6,rre_zog(i)*1.d-6

      end do
	end do
	stop

	end if





	
!!!	gamma_z2=1.d-5


c	read (*,*)

	alf_c=1.d0

!!!	call tay_ee_calc(tay_los)

! 	   tay_loss=5.d3  !  In Microsecons
c 	   tay_loss=10.d3  !  In Microsecons

c	tay_lo=2000.d3  ! 2000 msec
		
c	print *,' tay_loss==',tay_loss

c         kpr=1


!!!	tay_lo=tay_los


       te=tempe(j_x)
       
	 d_avr=0.02


c  Neutrals Density ... den_n=1 temporarily

      den_n=den_neut(j_x)*alf_n

	if(kpr.eq.1)print *,' j_x d_n den_neut_imp=',j_x,den_n,dens_imp_neut(1)

c	call n0_filter(den_n)

c	den_n=0.d0

c  Ions Density ... den_i

       den_i=den(j_x)

c	call n_i_filter(den_i)



!!!       call w_filter(den_i)

c  Neutral Impurity  Density ... den_im=1 temporarily

	do jj=1,n_imp_tot

	den_imp_n(jj,j_x)=dens_imp_neut(jj)

c	print *,' jj den_imp_n=',jj,den_imp_n(jj,j_x)

c	if(den_imp_n(jj,j_x).le.1.d-9)den_imp_n(jj,j_x)=1.d-9
	end do


c
	do jj=1,n_imp_tot
         den_im(jj)=den_imp_n(jj,j_x)*alf_c
	end do


c  Neutrals Temperature .. tn=ti?

         tn=tempi(j_x)

         ti=tn
c	if(kpr.eq.1)write(6,'(" n_imp_tot j_x te  tn",
c     *  2i4,6(1pe12.5))'),
c     *  n_imp_tot,j_x,te,tn


	if(kpr.eq.1)write(6,'(" den_n den_i den_im.1 2. ",
     *  6(1pe12.5))'),
     *  den_n,den_i,(den_im(jj),jj=1,n_imp_tot)

c         n_imp=6

      den_e=den_i

c      Begin calculation for each impurity jj=1:n_imp_tot

!      print *,' n_imp===',(n_imp(jj),jj=1,n_imp_tot)

	do jj=1,n_imp_tot


         n=n_imp(jj)

C  i=1,6 are Carbon Charge states  jj=1

C  i=1,8 are Oxigen Charge states  jj=2


       do i=1,n+1
	    tay_h(i)=tay_help
!		tay_loss(i)=1.d3*z_imp(i)**2*alf1
!		tay_loss(i)=1.d3*z_imp(i)**3*alf1
		tay_loss(i)=tay_lo

c	if(jj.eq.2.and.i.eq.n)tay_loss(i)=0.1d-0*tay_lo/z_imp(i)

c	tay_loss(i)=1.d-1*tay_loss(i)
c	if(i.eq.6)tay_loss(i)=tay_loss(i)*100.d0


	 end do

         do i=1,n
            d_imp(i)=den_imp(jj,i,j_x)
            d_imp0(i)=den0_imp(jj,i,j_x)

c            print *,' i z_imp',i,z_imp(i)

            den_e=den_e+z_imp(i)*d_imp(i)

         end do


c	te=1.
c	tn=1.

      do i=1,n+1
	jz=i-1

c            rin_zog(i)=rin(te,jz)
c            rre_zog(i)=rre(te,jz)
c            rcx_zog(i)=rcx(tn,jz)

c	write(6,'("  n i c_ion c_rec c_ex ",
c     *  2i4,6(1pe12.5))'),
c     *  n,i,rin_zog(i),rre_zog(i),rcx_zog(i)

      end do

	nz_inp=n
       call rates_zog(te,tn,nz_inp,
     *  rin_zog,rre_zog,rcx_zog)

      if(jj.eq.1)then
      kpr=1
      else
      kpr=0
      end if
      

      if(kpr.eq.1)then
      do i=1,n+1
	write(6,'("  i c_ion c_rec c_ex ",
     *  i4,6(1pe12.5))'),
     *  i,rin_zog(i),rre_zog(i),rcx_zog(i)
      end do
      end if
      
      
!      stop


!!!	rin_zog(3)=rin_zog(3)*0.5

       do i=1,n+1

	 s_ex=3.6d-1*(i-1)*sqrt(ti*1.d-3)

c	write(6,'("  ## n i  c_ex s_ex",
c     *  2i4,6(1pe12.5))'),
c     *  n,i,rcx_zog(i),s_ex

!!!	rcx_zog(i)=s_ex

c            rre_zog(i)=0.
c            rcx_zog(i)=0.




      end do


	i_int=0

1	continue
c	stop

c	read (*,*)

         do j=1,n
            do i=1,n
               a_imp(i,j)=0.
            end do
         end do


         do i=1,n
            a_imp(i,i)=1.d0/tay_h(i)

c   Impurity loss term
            a_imp(i,i)=a_imp(i,i)+1.d0/tay_loss(i)

            f_imp(i)=d_imp0(i)/tay_h(i)

         end do

         do i=1,1
         
               c_ion=rin_zog(i)

               f_imp(i)=f_imp(i)+c_ion*den_im(jj)*den_e
               f_imp2(i)=c_ion*den_e

	c_ion_11=c_ion*den_im(jj)*den_e

	if(kpr.eq.1)write(6,'("  i c_ion f_imp den_im den_e ",
     *  i4,6(1pe12.5))'),
     *  i,c_ion,f_imp(i),den_im(jj),den_e

         end do


         do i=1,n

            if(i.ne.1)then
               j=i-1
               jz=j
               c_ion=rin_zog(jz+1)
               a_imp(i,j)=a_imp(i,j)-c_ion*den_e

	if(kpr.eq.1)write(6,'(" i j c_ion ",
     *  2i4,6(1pe12.5))'),
     *  i,j,c_ion

            end if

            if(i.ne.n)then

            j=i
            jz=j
            c_ion=rin_zog(jz+1)
            c_rec=rre_zog(jz+1)
            c_ex=rcx_zog(jz+1)

            a_imp(i,j)=a_imp(i,j)+(c_ion+c_rec)*den_e+c_ex*den_n

	if(kpr.eq.1)write(6,'("  i j c_ion c_rec c_ex ",
     *  2i4,6(1pe12.5))'),
     *  i,j,c_ion,c_rec,c_ex


            else

c            c_rec=rre(te,jz)
c            c_ex=rcx(tn,jz)

            j=i
            jz=j
            c_rec=rre_zog(jz+1)
            c_ex=rcx_zog(jz+1)

            a_imp(i,j)=a_imp(i,j)+c_rec*den_e+c_ex*den_n
	if(kpr.eq.1)write(6,'("  i j  c_rec c_ex ",
     *  2i4,6(1pe12.5))'),
     *  i,j,c_rec,c_ex

            end if

            if(i.ne.n)then
            j=i+1
            jz=j

            c_rec=rre_zog(jz+1)
            c_ex=rcx_zog(jz+1)


            a_imp(i,j)=a_imp(i,j)-c_rec*den_e-c_ex*den_n

 	if(kpr.eq.1)write(6,'("  i j c_rec c_ex ",
     *  2i4,6(1pe12.5))'),
     *  i,j,c_rec,c_ex
     
           end if

         end do  ! i loop

         kpr=1

         call mat_prim(a_imp,f_imp,n)

         isol=0
         call solve_prim(isol,d_imp)


        do i=1,n
	  
	  f_imp1(i)=f_imp(i)-f_imp2(i)*den_im(jj)

	f_h(i)=0.d0
	  do k=1,n
	f_h(i)=f_h(i)+a_imp(i,k)*d_imp(k)
		end do
		
c	  write(6,'(" i f_h f_imp",
c     *  i4,6(1pe12.5))'),
c     *  i,f_h(i),f_imp(i)


        end do


         call f_prim(f_imp1,n)

         isol=1
         call solve_prim(isol,d_imp1)

         call f_prim(f_imp2,n)

         isol=1
         call solve_prim(isol,d_imp2)


        do i=1,n

	f_h(i)=0.d0
	  do k=1,n
	f_h(i)=f_h(i)+a_imp(i,k)*(d_imp1(k)+d_imp2(k)*den_im(jj))
		end do

	if(kpr.eq.-1)then		
	  write(6,'(" -- i f_h f_imp",
     *  i4,6(1pe12.5))'),
     *  i,f_h(i),f_imp(i)
	end if


        end do
c 

	  sum1=0.d0
	  sum2=0.d0

      do k=1,n
	  sum1=sum1+d_imp1(k)
	  sum2=sum2+d_imp2(k)
	end do

	if(jj.eq.1)gamma_zz=gamma_z
	if(jj.eq.2)gamma_zz=gamma_z2

!!!	sum3=gamma_zz*den_e
	sum3=gamma_zz*den_i


	sum33=sum1+sum2*den_im(jj)
	
	dens_neut_new=(sum3-sum1)/(1.d0+sum2)

	if(kpr.eq.1)then			
	  write(6,'(" sum1 sum2 sum3 sum33",
     *  6(1pe12.5))'),
     *  sum1,sum2,sum3,sum33

	  write(6,'(" dens_neut_new den_im(jj)",
     *  6(1pe12.5))'),
     *  dens_neut_new,den_im(jj)
	end if

	if(dens_neut_new.lt.1.d-14)dens_neut_new=0.d0

	dens_imp_neut(jj)=dens_neut_new
	den_im(jj)=dens_neut_new

      do i=1,n
	  d_imp(i)=(d_imp1(i)+d_imp2(i)*den_im(jj))
	end do

      sum1=0.d0
      do k=1,n
	  sum1=sum1+d_imp(k)
	end do

!!!	sum33=(sum1+den_im(jj))/den_e
	sum33=(sum1+den_im(jj))/den_i

	if(jj.eq.1)ratio_imp=sum33
	if(jj.eq.2)ratio_imp2=sum33

	if(kpr.eq.1)write(6,'(" r_imp r_imp2 g_z g_z2 ",
     *  6(1pe12.5))'),
     *  ratio_imp,ratio_imp2,gamma_z,gamma_z2

	if(kpr.eq.-3)write(1,'(" r_imp r_imp2 g_z g_z2 ",
     *  6(1pe12.5))'),
     *  ratio_imp,ratio_imp2,gamma_z,gamma_z2



c	stop

	den_im_sum=0.d0
	den_im_sum0=0.d0

        do i=1,n
        den_imp(jj,i,j_x)=d_imp(i)


	   den_im_sum=den_im_sum+d_imp(i)
	   den_im_sum0=den_im_sum0+d_imp0(i)



c	if(kpr.eq.1)write(6,'(" i d_imp d_imp0 sum0",
c     *  i4,6(1pe12.5))'),
c     *  i,d_imp(i),d_imp0(i),den_im_sum0

        end do

      do i=1,n
	if(kpr.eq.-1)then
	write(6,'("  jj i tay_l d_imp  yy ",
     *  2i4,6(1pe12.5))'),
     *  jj,i,tay_loss(i),d_imp(i),d_imp(i)/(den_im_sum+1.d-8)
	end if
      end do


c  Equations for impurity neutrals


	if(jj.eq.1)den_im_sum_1=den_im_sum


  	end do


	jj=1
	i_en=i_en+1
	
	if(i_en.eq.1)then
	den_imp_tot=den_im(jj)

	den_imp_tot=1.d-3

	end if

	if(kpr.eq.1)print *,' den_im den_im_sum=',den_im(jj),den_im_sum

c	if(kpr.eq.1)print *,'  n_imp_tot den_imp_tot==',
c     *  n_imp_tot,den_imp_tot



c	pause 'her'



        return
        end


        subroutine into_impu_test()

        include 'double.inc'
 
        include 'new_com.inc'
        include 'br_com.inc'

        include 'par_imp.inc'
        include 'new_imp.inc'
 
        call into_impu_test_c(
     *  n0,den_neut,
     *  n_d,den,T_e0,T_i0,
     *  T_e,T_i,tempe,tempi,n_rad,kpr)

        return
        end

        subroutine into_impu_test_c(
     *  n0,den_neut,
     *  n_d,den,T_e0,T_i0,
     *  T_e,T_i,tempe,tempi,n_rad,kpr)

        include 'double.inc'

        dimension
     *  den_neut(*),den(*),tempe(*),tempi(*)

        character * 20 apr

      include 'double_break1.inc'


c	n_rad=n

		if(kpr.eq.1)print *,'n_rad==== ',n_rad
      i_en=i_en+1
      
      n0=n0+d_n0
      n_d=n_d+d_n0
 !     T_e=T_e+d_te
 !     T_i=T_i+d_te
      
      if(i_en.eq.1)then
         
 !        n0=1.e-14
 !        d_n0=1.e-15

         n0=1.e-15
 !        n0=0.e-5
 
!         d_n0=1.e-10
         d_n0=0.e-10


!         n_d=0.0016
!         n_d=0.006

!         n_d=0.016
         n_d=1.
         
         T_e=0.1
         T_i=0.1
         
!         T_e=0.5
!         T_i=0.5

         T_e=0.25
         T_i=0.25

         T_e=0.02
         T_i=0.02

!         T_e=0.0005
!         T_i=0.0005
         
      end if
         
         
           do i=1,n_rad
              den_neut(i)=n0*10.d0
              den(i)=n_d*10.d0
              tempe(i)=T_e*1.d3
              tempi(i)=T_i*1.d3

        apr=' den_neut '
       if(kpr.eq.1)print 71,apr,den_neut(i)
        apr=' den '
       if(kpr.eq.1)print 71,apr,den(i)
       apr=' tempe '
       if(kpr.eq.1)print 71,apr,tempe(i)
       apr=' tempi '
       if(kpr.eq.1)print 71,apr,tempi(i)

		end do

 

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))

        return
        end


        subroutine get_param_test(n0_xx,n_e_xx,tay_lo_xx,
     *  tn_xx,alf_n_xx)

        include 'double.inc'
 
        include 'new_com.inc'
        include 'br_com.inc'

        include 'par_imp.inc'
        include 'new_imp.inc'

        real*8 n0_xx,n_e_xx,tay_lo_xx,tn_xx,alf_n_xx

        n0_xx=n0
        n_e_xx=n_e
        tay_lo_xx=tay_lo
        
        tn_xx=tempi(1)
        
        alf_n_xx=alf_n

!        print *,' n_e n0==',n_e,n0
!        print *,' n_e_xx n0_xx==',n_e_xx,n0_xx

        

        return
        end
        subroutine get_param_test2(n0_xx,n_e_xx,tay_lo_xx,
     *  tn_xx,alf_n_xx)

        include 'double.inc'
 
        include 'new_com.inc'
        include 'br_com.inc'

        include 'par_imp.inc'
        include 'new_imp.inc'

        real*8 n0_xx,n_e_xx,tay_lo_xx,tn_xx,alf_n_xx

        n0_xx=n0
        n_e_xx=n_e
        tay_lo_xx=tay_lo
        
        tn_xx=tempi(1)
        
        alf_n_xx=alf_n

!        print *,' n_e n0==',n_e,n0
!        print *,' ----n_e_xx n0_xx==',n_e_xx,n0_xx

        

        return
        end

        subroutine put_param_test2(n0_xx,n_e_xx,tn_xx,tay_lo_xx)

        include 'double.inc'
 
        include 'new_com.inc'
        include 'br_com.inc'

        include 'par_imp.inc'
        include 'new_imp.inc'

        real*8 n0_xx,n_e_xx,tay_lo_xx,tn_xx,alf_n_xx

        n0=n0_xx*0.1
        n_e=n_e_xx*0.1
        tempi(1)=tn_xx
        tay_lo=tay_lo_xx
!        print *,' +++n_e_xx n0_xx ==',n_e_xx,n0_xx

        return
        end

