	ygr(1,igr)=tpl
	yy(1)='Ip,kA'

!	ygr(1,igr)=I_p*1.e3
!	yy(1)='Ip,kA'


	ygr(2,igr)=T_e*1.e3
	yy(2)=' Te,eV'

	ygr(3,igr)=T_i*1.e3
	yy(3)=' Ti,eV'

	ygr(4,igr)=n_e
	yy(4)='ne,20'

c*************************************************
	ygr(5,igr)=P_oh*v_p
	yy(5)='Poh,MW'

	ygr(6,igr)=P_ioniz*v_p
	yy(6)='Pion,MW'

	ygr(7,igr)=P_cx*v_p
	yy(7)='Pcx,MW'

	ygr(8,igr)=P_rad*v_p
	yy(8)='Prad,MW'

c*************************************************
	ygr(9,igr)=dens_imp(1)*0.1
	yy(9)='n i1,20'

	ygr(10,igr)=dens_imp(2)*0.1
	yy(10)='n i2,20'


	ygr(11,igr)=dens_imp(3)*0.1
	yy(11)='n i3,20'


	ygr(12,igr)=dens_imp(4)*0.1
	yy(12)='n i4,20'

c*************************************************
	ygr(13,igr)=dens_imp(5)*0.1
	yy(13)='n i5,20'

	ygr(14,igr)=dens_imp(6)*0.1
	yy(14)='n i6,20'

	ygr(13,igr)=q_ch(1)*0.1*v_p
	yy(13)='P ch1 MW'


	ygr(14,igr)=q_ch(2)*0.1*v_p
	yy(14)='P ch2 MW'


	    if(kpr.eq.1)print *,'+sel1 sel2 ',
     *  sel(1),sel(2)
        if(kpr.eq.1)print *,'+q_ch1 q_ch2 ',
     *  q_ch(1),q_ch(2)


	ygr(15,igr)=z_eff
	yy(15)='Zeff'

c*** r_pl is plasma resistence in mikro-Om 
	r_plx=r_pl
       	if(r_plx.gt.250.)r_plx=250
	ygr(16,igr)=R_plx
	yy(16)='Rpl,mkOm'


!	ygr(16,igr)=tay_lo*1.d-6
!	yy(16)='tay lo'

	

	ygr(16,igr)=g_v
	yy(16)='Flux neut'

!	ygr(16,igr)=(q_zrad(1)*0.1)*v_p
!	yy(16)='q zrad1'


c**************************************************
	ygr(17,igr)=n0
	yy(17)='n0,20'

	ygr(18,igr)=n_d
	yy(18)='nd,20'

	ygr(19,igr)=den_imp_neut(1)*0.1
	yy(19)='nimp01,20'

c	  print*,'n0 nd nimp',n0,n_d,den_imp_neut(1)*0.1
c	  read(*,*)


	  ddd=ygr(19,igr)+ygr(9,igr)+ygr(10,igr)+ygr(11,igr)+
     &    ygr(12,igr)+ygr(13,igr)+ygr(14,igr)

	  if(kpr.eq.1)print*,'19 9 10 11 12 13 14',ygr(19,igr),ygr(9,igr),
     *(ygr(k,igr),k=10,14)	  
	  if(kpr.eq.1)print*,'ddd z_eff',ddd,z_eff

c	  read(*,*)

c	ygr(18,igr)=qlos_e*v_p
c	yy(18)='qloss'


	ygr(20,igr)=(sel(1)*0.1)*v_p

	qlos_imp=(sel(1)*0.1)

	if(kpr.eq.1)print *,' 00 qlos_imp v_p==',qlos_imp,v_p

!	ygr(20,igr)=qlos_imp*v_p
	yy(20)='Plos imp1,MW'

c	ygr(20,igr)=qloss_ion*v_p
c	yy(20)='q ion'
c*********************************************
	ng=20

c	if(n_imp_tot.eq.1)then

	 if(kpr.eq.1) print*,'q_ech=',q_ech
c        read(*,*)



	ygr(21,igr)=q_ech
	yy(21)='Pech,MW'

 	   x_x=v_n/v_p

	ygr(22,igr)=x_x
	yy(22)='Vn/Vp'

	ygr(23,igr)=ddd
	yy(23)='Ntot imp1,20'


!!!	ratio_imp=ddd/n_e


c***** V_v0=V_v-(V_p-V_n) volume where plasma neutrals are located 
  	    n_tot=n_d*V_p+n0*V_v0
c	  print*,'V_p V_n V_v0',V_p,V_n,V_v0
c	  print*,'n_d n0 n_tot',n_d,n0,n_tot
c	  pause

c	ygr(24,igr)=n_tot
c	yy(24)='N tot,20'

	ygr(24,igr)=tay_ee
	yy(24)='tay e,s'


	ng=24

c	end if
c

	if(n_imp_tot.eq.2)then

	kk=6

	ygr(25,igr)=dens_imp(1+kk)*0.1
	yy(25)=' n w1'

	ygr(26,igr)=dens_imp(2+kk)*0.1
	yy(26)=' n w2'


	ygr(27,igr)=dens_imp(3+kk)*0.1
	yy(27)=' n w3'


	ygr(28,igr)=dens_imp(4+kk)*0.1
	yy(28)=' n w4'


	ygr(29,igr)=dens_imp(5+kk)*0.1
	yy(29)=' n w5'


	ygr(30,igr)=dens_imp(6+kk)*0.1
	yy(30)=' n w6'

	ygr(31,igr)=dens_imp(7+kk)*0.1
	yy(31)=' n w7'

	ygr(32,igr)=dens_imp(8+kk)*0.1
	yy(32)=' n w8'

	ygr(27,igr)=(q_zrad(1)*0.1)*v_p
	yy(27)=' Pzrad imp1,MW'

	ygr(28,igr)=(q_zrad(2)*0.1)*v_p
	yy(28)='Pzrad imp2,MW'


	ygr(29,igr)=(q_ion(1)*0.1)*v_p
	yy(29)=' Pion imp1,MW'

	ygr(30,igr)=(q_ion(2)*0.1)*v_p
	yy(30)='Pion imp2,MW'


	ygr(31,igr)=(q_rad(1)*0.1)*v_p
	yy(31)=' Prad imp1,MW'

	ygr(32,igr)=(q_rad(2)*0.1)*v_p
	yy(32)='Prad imp2,MW'

	ygr(33,igr)=den_imp_neut(2)*0.1
	yy(33)='nimp02,20'

	ygr(34,igr)=(sel(2)*0.1)*v_p
	yy(34)='Plos imp2,MW'

	ddd=0.d0
	do i=25,32
	  ddd=ddd+ygr(i,igr)
	 end do

	if(kpr.eq.1)  print*,'ddd ',ddd

!	ygr(35,igr)=ddd
!	yy(35)='Ntot imp2,20'

	ygr(35,igr)=ratio_imp
	yy(35)='ratio_imp'

	ygr(36,igr)=ratio_imp2
	yy(36)='ratio_imp2'


!	ygr(36,igr)=(q_rad(1)+q_rad(2))*0.1d0*v_p
!	yy(36)='q rad imp'


	ng=36

	end if

	ygr(37,igr)=rmag
	yy(37)='rmag'

	ygr(38,igr)=eu
	yy(38)='eu'

!	ygr(39,igr)=anom_e
!	yy(39)='anom_e'

	ygr(39,igr)=udd
	yy(39)='udd'


	ygr(40,igr)=v_p
	yy(40)='V p'

	ng=40


	ygr(41,igr)=vloop
	yy(41)='U total'

	ygr(42,igr)=uact
	yy(42)='V resistive'

	ygr(43,igr)=betj
	yy(43)='beta pol'

	ygr(44,igr)=zmag
	yy(44)='zmag'

	ng=44

	ygr(45,igr)=elong
	yy(45)=' k'

	ygr(46,igr)=q(n)
	yy(46)=' q b'

	ygr(47,igr)=q(2)
	yy(47)=' q ax'

	ygr(48,igr)=te_av
	yy(48)='te av'

	ng=48

	ygr(49,igr)=s_plas
	yy(49)=' S pl'

	ygr(50,igr)=rout
	yy(50)=' rout'

	ygr(51,igr)=zout
	yy(51)=' zout'

	ygr(52,igr)=alfa2_avr
	yy(52)=' alfa2'


	ng=52

	ygr(53,igr)=alf_b
	yy(53)=' alf b'

	ygr(54,igr)=bet_b
	yy(54)=' bet b'

	ygr(55,igr)=x1_b
	yy(55)='x1 b'

	ygr(56,igr)=pn_prog
	yy(56)=' pn_prog'

	ng=56






