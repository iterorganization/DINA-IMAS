c********************* 00 **********************************
c       ------I plasma---------
	ygr(1,igr)=tpl/1.e3
	yy(1)='I_pl[MA]'
c       ----beta p(2) --
	ygr(2,igr)=betpj
	yy(2)='BETAp'
c       ------a minor-----
	ygr(3,igr)=eu
	yy(3)='a[cm]'
c       -----L(3)----
	ygr(4,igr)=uli
	yy(4)='l_i(3)'
c*********************************************************
c       ---- rmag ------
	ygr(5,igr)=rmag
	yy(5)='Rmag[cm]'
c	ygr(5,igr)=r_cur
c	yy(5)='Rcur[cm]'
c	----Zmag-----
	ygr(6,igr)=zmag
	yy(6)='Zmag[cm]'
c	ygr(6,igr)=z_cur
c	yy(6)='Zcur[cm]'
c       ---- vessel current ------
c	ygr(7,igr)=tokc
c	yy(7)='Ivv[kA]'
c*** Power across separatrix with thermoconductivity + dQ/dt, MW
cc	ygr(7,igr)=p_sep
cc	yy(7)='Psep[MW]'
	ygr(7,igr)=wdh
	yy(7)='P_Joul[MW]'
c       ---- elong ------
	ygr(8,igr)=eksk
c	yy(8)='k_99'
	yy(8)='k_bnd'
c*******************************************************
c       -------ne average-----
	ygr(9,igr)=pcch/10.
	yy(9)='Ne_avr[20]'
c       ---- gamma ------
	gamma=(pcch/10.)*pi*eu**2*1.e-4/(tpl/1.e3)
	ygr(10,igr)=gamma
	yy(10)='Gamma'


c	ygr(10,igr)=dfmax(n)*1.d-5
c	yy(10)='Fmax'

	if(kpr.eq.1)print *,' ++zeff_a zeff_avr',zeff_a,zeff_avr

c       -------Zeff_a-----
	ygr(12,igr)=zeff_a
	yy(12)='Zeff_a'
	
c       -------Zeff_b-----
c	ygr(12,igr)=zeff_b
c	yy(12)='Zeff_b'
c	ygr(12,igr)=teoh
c	yy(12)='TAYoh,ms'
c	ygr(12,igr)=psipl_av
c	yy(12)='psipl_av,vs'


!	ygr(12,igr)=psiext_av
!	yy(12)='psiext_av,vs'
c********************************************************


c       -----te average-----
	ygr(13,igr)=tec
	yy(13)='Te_avr[eV]'
c       -----ti average----
	ygr(14,igr)=tqc
	yy(14)='Ti_avr[eV]'
c       -----te axis-----
	ygr(15,igr)=te0(1)
	yy(15)='Te_ax[eV]'
c       -----ti axis-----
	ygr(16,igr)=tq0(1)
	yy(16)='Ti_ax[eV]'
c***********************************************************
c       ---- wdop ------
        wdop=wde+wdq
ccc	wdop=wdop+wpe+wpq
	ygr(17,igr)=wdop
	yy(17)='P_aux,MW'
c       -----q bound---
c	ygr(13,igr)=q(n)
c	yy(13)='q_bn'
	ygr(18,igr)=q_95
	yy(18)='q_95'
c       ---- q_ax ------
	ygr(19,igr)=q(2)
	yy(19)='q_ax'
c       ---- uact ------
	ygr(20,igr)=vs
	yy(20)='VS_res[Wb]'
c*********************************************************
c	---- tay_e -----
	ygr(21,igr)=tene
	yy(21)='Tay_E[ms]'
c       ---- rsep ------
c	ygr(23,igr)=rsep
c	yy(23)='Rsep[cm]'
c       ---- zsep ------
	ygr(22,igr)=zsep
	yy(22)='Zsep[cm]'
c	---- Ce -----
c!!!!!	c_e=vs/(0.1*4*pi*rmag*1.e-2*tpl*1.e-3)
	ce_0=0.25
	if(ntay.eq.next)vs_0=ce_0*(0.1*4*pi*rmag*1.e-2*tpl*1.e-3)
	c_e_old=(vs_0+vs)/(0.1*4*pi*rmag*1.e-2*tpl*1.e-3)
	c_e_new=vs/(0.1*4*pi*rmag*1.e-2*tpl*1.e-3)
	
	ygr(23,igr)=c_e_old
	yy(23)='C_Ejima'

	ygr(23,igr)=tokae*1.d-3
	yy(23)='I run [MA]'

	
c       ---- W_sum ------
	w_pf=0.
	do i=1,npf
	w_pf=w_pf+vchopper(i)*pf(i)*1.e3*1.e-6
	end do
c	ygr(24,igr)=w_pf
c	yy(24)='P_PF[MW]'
        pmag_out=pmag*1.e-5*2.*pi
	ygr(24,igr)=pmag_out
	yy(24)='Pmag[Vs]'
c************************************************************
c           if(tt.gt.t_end)then
c              print*,'!!!tt t_end',tt,t_end
c	      print*,'d_gaps pf'
c	      do mmm=9,20
c	      print*,d_gaps(mmm),pf(mmm)/1.e3
c	      end do
c	   end if

	ygr(25,igr)=d_gaps(1)
	yy(25)='error_01'

	ygr(26,igr)=d_gaps(2)
	yy(26)='error_02'

	ygr(27,igr)=d_gaps(3)
	yy(27)='error_03'

	ygr(28,igr)=d_gaps(4)
	yy(28)='error_04'
c***********************************************
	ygr(29,igr)=d_gaps(5)
	yy(29)='error_05'

	ygr(30,igr)=d_gaps(6)
	yy(30)='error_06'

	ygr(31,igr)=d_gaps(7)
	yy(31)='error_07'

	ygr(32,igr)=d_gaps(8)
	yy(32)='error_08'
c***********************************************
	ygr(33,igr)=d_gaps(9)
	yy(33)='error_09'

	ygr(34,igr)=d_gaps(10)
	yy(34)='error_10'

	ygr(35,igr)=d_gaps(11)
	yy(35)='error_11'

	ygr(36,igr)=d_gaps(12)
	yy(36)='error_12'
c***********************************************
	ygr(37,igr)=d_gaps(13)
	yy(37)='error_13'

	ygr(38,igr)=d_gaps(14)
	yy(38)='error_14'

	ygr(39,igr)=d_gaps(15)
	yy(39)='error_15'

	ygr(40,igr)=d_gaps(16)
	yy(40)='error_16'
c***********************************************
	ygr(41,igr)=d_gaps(17)
	yy(41)='error_17'

	ygr(42,igr)=d_gaps(18)
	yy(42)='error_18'

	ygr(43,igr)=d_gaps(19)
	yy(43)='error_19'

	ygr(44,igr)=d_gaps(20)
	yy(44)='error_20'
c***********************************************
	i=1
	ggg=gaps(i)-gaps0(i)
	ygr(45,igr)=ggg
	yy(45)='del_g1[cm]'

	i=2
	ggg=gaps(i)-gaps0(i)
	ygr(46,igr)=ggg
	yy(46)='del_g2[cm]'

	i=3
	ggg=gaps(i)-gaps0(i)
	ygr(47,igr)=ggg
	yy(47)='del_g3[cm]'

	i=4
	ggg=gaps(i)-gaps0(i)
	ygr(48,igr)=ggg
	yy(48)='del_g4[cm]'
c************************************************
	i=5
	ggg=gaps(i)-gaps0(i)
	ygr(49,igr)=ggg
	yy(49)='del_g5[cm]'

	i=6
	ggg=gaps(i)-gaps0(i)
	ygr(50,igr)=ggg
	yy(50)='del_g6[cm]'

	ygr(51,igr)=pf(1)/1.e3
	yy(51)='CS3U[MA]'

	ygr(52,igr)=vchopper(1)
	yy(52)='V_CS3U[V]'
c************************************************
	ygr(53,igr)=pf(2)/1.e3
	yy(53)='CS2U[MA]'

	ygr(54,igr)=vchopper(2)
	yy(54)='V_CS2U[V]'

	ygr(55,igr)=pf(3)/1.e3
	yy(55)='CS1[MA]'

	ygr(56,igr)=vchopper(3)
	yy(56)='V_CS1[V]'
c************************************************************
	ygr(57,igr)=pf(4)/1.e3
	yy(57)='CS2L[MA]'

	ygr(58,igr)=vchopper(4)
	yy(58)='V_CS2L[V]'

	ygr(59,igr)=pf(5)/1.e3
	yy(59)='CS3L[MA]'

	ygr(60,igr)=vchopper(5)
	yy(60)='V_CS3L[V]'
c************************************************************
	ygr(61,igr)=pf(6)/1.e3
	yy(61)='PF1[MA]'

	ygr(62,igr)=vchopper(6)
	yy(62)='V_1[V]'

	ygr(63,igr)=pf(7)/1.e3
	yy(63)='PF2[MA]'

	ygr(64,igr)=vchopper(7)
	yy(64)='V_2[V]'
c*************************************************************
	ygr(65,igr)=pf(8)/1.e3
	yy(65)='PF3[MA]'

	ygr(66,igr)=vchopper(8)
	yy(66)='V_3[V]'

	ygr(67,igr)=pf(9)/1.e3
	yy(67)='PF4[MA]'

	ygr(68,igr)=vchopper(9)
	yy(68)='V_4[V]'
c*************************************************************
	ygr(69,igr)=pf(10)/1.e3
	yy(69)='PF5'

	ygr(70,igr)=vchopper(10)
	yy(70)='V_5[V]'

	ygr(71,igr)=pf(11)/1.e3
	yy(71)='PF6[MA]'

	ygr(72,igr)=vchopper(11)
	yy(72)='V_6[V]'
c***********************************************************
	ygr(73,igr)=pf(12)/1.e3
	yy(73)='I_VS[MA]'

	ygr(74,igr)=vchopper(12)
	yy(74)='V_VS[V]'

	ygr(75,igr)=zvconverter(1)*pf_turns(1)
	yy(75)='zvc(1)[V]'

	ygr(76,igr)=zvconverter(2)*pf_turns(2)
	yy(76)='zvc(2)[V]'
c************************************************************
	ygr(77,igr)=zvconverter(3)*pf_turns(3)
	yy(77)='zvc(3)[V]'

	ygr(78,igr)=zvconverter(4)*pf_turns(4)
	yy(78)='zvc(4)[V]'

	ygr(79,igr)=zvconverter(5)*pf_turns(5)
	yy(79)='zvc(5)[V]'

	ygr(80,igr)=zvconverter(6)*pf_turns(6)
	yy(80)='zvc(6)[V]'
c***********************************************
	ygr(81,igr)=zvconverter(7)*pf_turns(7)
	yy(81)='zvc(7)[V]'

	ygr(82,igr)=zvconverter(8)*pf_turns(8)
	yy(82)='zvc(8)[V]'

	ygr(83,igr)=zvconverter(9)*pf_turns(9)
	yy(83)='zvc(9)[V]'

	ygr(84,igr)=zvconverter(10)*pf_turns(10)
	yy(84)='zvc(10)[V]'
c*****************************************************
	ygr(85,igr)=zvconverter(11)*pf_turns(11)
	yy(85)='zvc(11)[V]'

	ygr(86,igr)=zvconverter(12)*pf_turns(12)
	yy(86)='zvc(12)[V]'

	ygr(87,igr)=u_1(1)
	yy(87)='u_1(1)[V]'

	ygr(88,igr)=u_1(2)
	yy(88)='u_1(2)[V]'
c*****************************************************
	ygr(89,igr)=u_1(3)
	yy(89)='u_1(3)[V]'

	ygr(90,igr)=u_1(4)
	yy(90)='u_1(4)[V]'

	ygr(91,igr)=u_1(5)
	yy(91)='u_1(5)[V]'

	ygr(92,igr)=u_1(6)
	yy(92)='u_1(6)[V]'
c******************************************************
	ygr(93,igr)=u_1(7)
	yy(93)='u_1(7)[V]'

	ygr(94,igr)=u_1(8)
	yy(94)='u_1(8)[V]'

	ygr(95,igr)=u_1(9)
	yy(95)='u_1(9)[V]'

	ygr(96,igr)=u_1(10)
	yy(96)='u_1(10)[V]'
c*****************************************************
	ygr(97,igr)=u_1(11)
	yy(97)='u_1(11)[V]'

	ygr(98,igr)=u_1(12)
	yy(98)='u_1(12)[V]'

	ygr(99,igr)=u_kd(1)
	yy(99)='u_kd(1)[V]'

	ygr(100,igr)=u_kd(2)
	yy(100)='u_kd(2)[V]'
c*****************************************************
	ygr(101,igr)=u_kd(3)
	yy(101)='u_kd(3)[V]'

	ygr(102,igr)=u_kd(4)
	yy(102)='u_kd(4)[V]'

	ygr(103,igr)=u_kd(5)
	yy(103)='u_kd(5)[V]'

	ygr(104,igr)=u_kd(6)
	yy(104)='u_kd(6)[V]'
c**********************************************************
	ygr(105,igr)=u_kd(7)
	yy(105)='u_kd(7)[V]'

	ygr(106,igr)=u_kd(8)
	yy(106)='u_kd(8)[V]'

	ygr(107,igr)=u_kd(9)
	yy(107)='u_kd(9)[V]'

	ygr(108,igr)=u_kd(10)
	yy(108)='u_kd(10)[V]'
c*****************************************************
	ygr(109,igr)=u_kd(11)
	yy(109)='u_kd(11)[V]'

	ygr(110,igr)=u_kd(12)
	yy(110)='u_kd(12)[V]'

	ygr(111,igr)=rsep
	yy(111)='Rsep[cm]'

	ygr(112,igr)=teit_95
	yy(112)='tay_L[ms]'
c****************************************************
	ygr(113,igr)=teit_98
	yy(113)='tay_H[ms]'
	
	ygr(114,igr)=r_lh
	ygr(114,igr)=r_lh_new 
		yy(114)='r_LH'
	
	if(ksepa.eq.0)then
		ell=eksk
	else
		ell=elong_sep
	end if		
	ygr(115,igr)=ell
	yy(115)='k_sep'

	ygr(116,igr)=u_ffw(1)
	yy(116)='u_ffw(1)[V]'
c*****************************************************
	ygr(117,igr)=u_ffw(2)
	yy(117)='u_ffw(2)[V]'

	ygr(118,igr)=u_ffw(3)
	yy(118)='u_ffw(3)[V]'

	ygr(119,igr)=u_ffw(4)
	yy(119)='u_ffw(4)[V]'

	ygr(120,igr)=u_ffw(5)
	yy(120)='u_ffw(5)[V]'
c*****************************************************

	ygr(121,igr)=u_ffw(6)
	yy(121)='u_ffw(6)[V]'

	ygr(122,igr)=u_ffw(7)
	yy(122)='u_ffw(7)[V]'

	ygr(123,igr)=u_ffw(8)
	yy(123)='u_ffw(8)[V]'

	ygr(124,igr)=u_ffw(9)
	yy(124)='u_ffw(9)[V]'
c***************************************************
	ygr(125,igr)=u_ffw(10)
	yy(125)='u_ffw(10)[V]'

	ygr(126,igr)=u_ffw(11)
	yy(126)='u_ffw(11)[V]'

	i=1
	ygr(127,igr)=gaps(i)
	yy(127)='gap_1[cm]'

	i=1
	ygr(128,igr)=gaps0(i)
	yy(128)='gap0_1[cm]'
c***************************************************
	i=2
	ygr(129,igr)=gaps(i)
	yy(129)='gap_2[cm]'

	i=2
	ygr(130,igr)=gaps0(i)
	yy(130)='gap0_2[cm]'

	i=3
	ygr(131,igr)=gaps(i)
	yy(131)='gap_3[cm]'

	i=3
	ygr(132,igr)=gaps0(i)
	yy(132)='gap0_3[cm]'
c************************************************
	i=4
	ygr(133,igr)=gaps(i)
	yy(133)='gap_4[cm]'

	i=4
	ygr(134,igr)=gaps0(i)
	yy(134)='gap0_4[cm]'

	i=5
	ygr(135,igr)=gaps(i)
	yy(135)='gap_5[cm]'

	i=5
	ygr(136,igr)=gaps0(i)
	yy(136)='gap0_5[cm]'
c************************************************
	i=6
	ygr(137,igr)=gaps(i)
	yy(137)='gap_6[cm]'

	i=6
	ygr(138,igr)=gaps0(i)
	yy(138)='gap0_6[cm]'

        ygr(139,igr)=qc
	yy(139)='qc,MW'

        ygr(140,igr)=wtor
	yy(140)='wtor,MW'
c************************************************
        ygr(141,igr)=w_imp
	yy(141)='w_imp,MW'

        ygr(142,igr)=coef_imp
	yy(142)='coef_imp'

        ygr(143,igr)=wae+waq
	yy(143)='W_alpha,MW'

	call s_calc()
        ygr(144,igr)=s_plasma/1.e4
	yy(144)='s_plasma,m2'
c*******************************************
        ygr(145,igr)=qtep
	yy(145)='Q'

        w_fusion=wnet+wae+waq
        if(ntay.le.2)gfus=0.
        if(ntay.gt.2)gfus=gfus+w_fusion*tay*1.e-3/3600.
        ygr(146,igr)=w_fusion
	yy(146)='Wfus,MW'
	ygr(11,igr)=w_fusion
	yy(11)='Wfus,MW'

	p_sum=wae+waq+wdop
	    ygr(147,igr)=p_sum
		yy(147)='Psum,MW'

	P_HL=0.082/2.5*(pcch/10.)**0.73*5.3**0.74*(s_plasma/1.e4)**0.98
	
	if(kpr.eq.1)print *,' p_hl s_plasma pcch=',p_hl,s_plasma,pcch 
	
		    ygr(148,igr)=P_HL
		yy(148)='P_HL,MW'
c****************************************************
	   pmag_out_1=dm0(1)*1.e-5
c	   ygr(149,igr)=pmag_out_1
c		yy(149)='Pmag Tr'

c	    ygr(148,igr)=zvel
c		yy(148)='zvel'

c**************************************************
	    ygr(149,igr)=dist_min_xx
		yy(149)='dist_min'

	    ygr(150,igr)=Rdist_min_xx
		yy(150)='Rdist_min'

	    ygr(151,igr)=Zdist_min_xx
		yy(151)='Zdist_min'

c	    ygr(152,igr)=Zdist_min_xx
c		yy(152)='Zdist_min'

       ygr(152,igr)=psipl_av
       
ccc       ygr(152,igr)=pll*tpl*1.e-5
       
		yy(152)='psipl_av'
c********************************************
	    ygr(153,igr)=dNB_xx(1)
		yy(153)='1bot'
	    ygr(154,igr)=dNB_xx(2)
		yy(154)='1mid'
	    ygr(155,igr)=dNB_xx(3)
		yy(155)='n01/02'
	    ygr(156,igr)=dNB_xx(4)
		yy(156)='2mid'
c********************************************
	    ygr(157,igr)=dNB_xx(5)
		yy(157)='n02/03'
	    ygr(158,igr)=dNB_xx(6)
		yy(158)='3mid'
	    ygr(159,igr)=dNB_xx(7)
		yy(159)='n03/04'
	    ygr(160,igr)=dNB_xx(8)
		yy(160)='4mid'
c********************************************
	    ygr(161,igr)=dNB_xx(9)
		yy(161)='n04/05'
	    ygr(162,igr)=dNB_xx(10)
		yy(162)='5mid'
	    ygr(163,igr)=dNB_xx(11)
		yy(163)='n05/06'
	    ygr(164,igr)=dNB_xx(12)
		yy(164)='6mid'
c**********************************************
	    ygr(165,igr)=dNB_xx(13)
		yy(165)='10mid'
	    ygr(166,igr)=dNB_xx(14)
		yy(166)='11mid'
	    ygr(167,igr)=dNB_xx(15)
		yy(167)='12mid'
	    ygr(168,igr)=dNB_xx(16)
		yy(168)='13mid'
c******************************************
	    ygr(169,igr)=dNB_xx(17)
		yy(169)='n13/14'
	    ygr(170,igr)=dNB_xx(18)
		yy(170)='14mid'
	    ygr(171,igr)=dNB_xx(19)
		yy(171)='15mid'
c	    ygr(172,igr)=dNB_xx(20)
c		yy(172)='16mid'
	    ygr(172,igr)=Rsep2
		yy(172)='Rsep2'
c******************************************
c	    ygr(173,igr)=dNB_xx(21)
c		yy(173)='17mid'
	    ygr(173,igr)=Zsep2
		yy(173)='Zsep2'

c	    ygr(174,igr)=dNB_xx(22)
c		yy(174)='n17/19'
c	    ygr(175,igr)=dNB_xx(23)
c		yy(175)='18mid'
c	    ygr(176,igr)=dNB_xx(24)
c		yy(176)='18bot'

	    ygr(174,igr)=rsep2_r
		yy(174)='rsep2_r'
	    ygr(175,igr)=zsep2_r
		yy(175)='zsep2_r'
	    ygr(176,igr)=gaps(n_ga+1)
		yy(176)='Dsep'
c******************************************

		ng=176

c***********************************
c******  Calculation of Ivs3, Uvs3, Ivs1, Uvs1

	 num_coils=12
c   Calculation of Ivs3 (in kA)
        Curr_vs3=pf(num_coils)/4.

c   Calculation of Uvs3 (in kV)
        U_vs3=u_kd(num_coils)*4.*1.e-3

c   Calculation of Ivs1 (in kA)
        Curr_vs1=-pf(7)/pf_turns(7)-pf(8)/pf_turns(8)+
     *            pf(9)/pf_turns(9)+pf(10)/pf_turns(10)

c   Calculation of Uvs1 (in kV)
        U_vs1=-u_kd(7)*pf_turns(7)*1.e-3

c***********************************

!	print *,' write_data_in_time'

		if(kpr.eq.1)print*,'to write_plasma =w_imp ',w_imp,w_imp+prim


c***********************************
      call write_data_in_time(
     *	tt,tpl,betpj,eu,uli,r_cur,z_cur,p_sep,wel,wio,eksk,
c     *	pcch,zeff_a,tec,te0(1),tqc,tq0(1),tene,zsep,c_e_old,c_e_new,
     *	pcch,zeff_a,tec,te0(1),tqc,tq0(1),tene,zsep,rsep,c_e_old,c_e_new,
c     *  rmag,gamma,vs,q_95,q(2),zvel*10.,psi_pf,pmag_out,uact,
     *  rmag,gamma,vs,q_95,q(2),zvel*10.,psi_pf,pmag_out_1,uact,
     *  pf(1)/pf_turns(1),pf(2)/pf_turns(2),pf(3)/pf_turns(3),
     *  pf(4)/pf_turns(4),pf(5)/pf_turns(5),
     *  pf(6)/pf_turns(6),pf(7)/pf_turns(7),pf(8)/pf_turns(8),
     *  pf(9)/pf_turns(9),pf(10)/pf_turns(10),pf(11)/pf_turns(11),
     *  pf(12)/pf_turns(12),
     *  zvconverter(1)*pf_turns(1)*1.e-3,
     *	zvconverter(2)*pf_turns(2)*1.e-3,
     *  zvconverter(3)*pf_turns(3)*1.e-3,
     *	zvconverter(4)*pf_turns(4)*1.e-3,
     *  zvconverter(5)*pf_turns(5)*1.e-3,
     *	zvconverter(6)*pf_turns(6)*1.e-3,
     *  zvconverter(7)*pf_turns(7)*1.e-3,
     *	zvconverter(8)*pf_turns(8)*1.e-3,
     *  zvconverter(9)*pf_turns(9)*1.e-3,
     *	zvconverter(10)*pf_turns(10)*1.e-3,
     *  zvconverter(11)*pf_turns(11)*1.e-3,
     *	U_vs1,U_vs3,Curr_vs1,Curr_vs3,
     *  r_lh,wdop,qtep,w_fusion,wae+waq,s_plasma/1.e4,p_sum,P_HL,zmag,
     *  wtp,wtor,qc,w_imp,gfus,p_sep_tot,
!     *  wtp,wtor,qc,prim,gfus,p_sep_tot,


     *  dist_min_xx,Rdist_min_xx,Zdist_min_xx,
     *  dNB_xx)
c     *  wdop,qtep,w_fusion,
c     *  pf(2)/1.e3,pf(6)/1.e3,pf(8)/1.e3,pf(9)/1.e3,pf(11)/1.e3,
c     *  volume,z_tok,tokc)

c           print*,'from dop_port'
c           print*,'tt pf(10)/pf_turns(10) pf(10)/1000',
c     *  tt,pf(10)/pf_turns(10),pf(10)/1000
c	   read(*,*)

