	subroutine choppers_test_old()
c--------------------------------------------
c--------------------------------------------
	include 'double.inc'
c	implicit real *8(a-h,o-z)
	include 'parf1'
	parameter ( NPFC=KF-4)
C
	common
     *  /loop3/vloop,psf1a,psf1a0
	common
     *  /dfm5/pt01,pt02
	COMMON
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /ge2/ntay,tay,tt
     *  /ge5/kpr
	common
     *  /cont1/vchopper(kf),veps
     *  /cont2/vcont(kf),tcont(kf)
     *  /cont3/veps0,tramp,kread
     *  /cont4/ZPP,RPP,WVSPIP,ZXP,ELP,SHAPE,GAPINP,
     *  DFZP, DFZP0
     *  /CONT5/	FCOM(NPFC)
     *  /cont6/cip1,cip2,time1,time2


C
	character * 12 apr

	common 
     *  /c_con2/KCHOP(NPFC),
     *  KSIGN(NPFC),NCHOP(NPFC),res_ext(npfc)
     *  /c_con3/pow_names(npfc)
     *  /c_con4/vps(npfc),kvert(npfc)
     *  /c_con5/d,d2,v,t2,hv1,hv2
     *  /c_con7/volt(kf)
     *  /c_con8/key_con

	character *4 pow_names

	DIMENSION VPULL(NPFC)

	if(kpr.eq.1)print*,'ZPP from chopper  ',zpp

c   I_pl current transfer to A from kA...
	TPL=pt01*1.e3


 	apr='PF'
	if(kpr.eq.1)print 71,apr,(pf(i),i=1,npf)

	i_en=i_en+1
	if(i_en.eq.1)then
	   call read_patch()
	   call read_power()

	apr='vps'
	if(kpr.eq.1)print 71,apr,(vps(i),i=1,npfc)

	apr='kchop'
	if(kpr.eq.1)print 72,apr,(kchop(i),i=1,npfc)
	apr='nchop'
	if(kpr.eq.1)print 72,apr,(nchop(i),i=1,npfc)
	apr='ksign'
	if(kpr.eq.1)print 72,apr,(ksign(i),i=1,npfc)
	apr='kvert'
	if(kpr.eq.1)print 72,apr,(kvert(i),i=1,npfc)

	apr='pow_name'
	if(kpr.eq.1)print 5,(pow_names(i),i=1,npfc)
 5	format(9(a3))
	apr='res_ext'
	if(kpr.eq.1)print 71,apr,(res_ext(i),i=1,npfc)

c	read (*,*)

	end if

72	format(20x,a6/,(1x,8(i4)))


c----------------------------------------------------------
  	call shape_eps() 
	call ecoil_test()
	call eps_filter()
	call shape_volt()

c!!!	call ecoil_cont()

	do i=1,npfc
	vchopper(i)=0.
	fcom(i)=0.
	end do
C
	DO I=1,NPFC
c was in mOhm	VCHOPPER(I)=VCHOPPER(I)-pf(i)*1.e3*res_ext(i)*1.e-3
	VCHOPPER(I)=VCHOPPER(I)-pf(i)*1.e3*res_ext(i)
	END DO
c

	if(key_con.eq.0)then
	   
	   if(kpr.eq.1)print *,' KEY_CON===',key_con

	do i=1,npfc
	   if(kchop(i).ne.0)vchopper(i)=vchopper(i)+ksign(i)*volt(i)
c!!     if(kchop(i).ne.0)vchopper(i)=volt(i)
	end do

 	apr='VCHOP'
	if(kpr.eq.1)print 71,apr,(vchopper(i),i=1,npfc)
 	apr='volt'
	if(kpr.eq.1)print 71,apr,(volt(i),i=1,npfc)

	   end if



71	format(20x,a6/,(1X,6(1pe10.3)))
	return
	end
C
	subroutine smal_choppers()

	include 'double.inc'
	include 'new_com.inc'

	call smal_choppers_c(
     *  key_volt6,key_volt7,rmag)

	return
	end



	subroutine  smal_choppers_c(
     *  key_volt6,key_volt7,rmag)

c--------------------------------------------
c--------------------------------------------
	include 'double.inc'
c	implicit real *8(a-h,o-z)
	include 'parf1'
	parameter ( NPFC=KF-4)
C
	common
     *  /loop3/vloop,psf1a,psf1a0
	common
     *  /dfm5/pt01,pt02
	COMMON
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /ge2/ntay,tay,tt
     *  /ge5/kpr
	common
     *  /cont1/vchopper(kf),veps
     *  /cont2/vcont(kf),tcont(kf)
     *  /cont3/veps0,tramp,kread
     *  /cont4/ZPP,RPP,WVSPIP,ZXP,ELP,SHAPE,GAPINP,
     *  DFZP, DFZP0
     *  /CONT5/	FCOM(NPFC)
     *  /cont6/cip1,cip2,time1,time2
     *  /c_cont9/g_r_p(2),g_r_d(2),g_r_i(2)
     *  /c_cont10/g_z_p(2),g_z_d(2),g_z_i(2)


C
	character * 12 apr

	common 
     *  /c_con2/KCHOP(NPFC),
     *  KSIGN(NPFC),NCHOP(NPFC),res_ext(npfc)
     *  /c_con3/pow_names(npfc)
     *  /c_con4/vps(npfc),kvert(npfc)
     *  /c_con5/d,d2,v,t2,hv1,hv2
     *  /c_con7/volt(kf)
     *  /c_con8/key_con

	character *4 pow_names

	i_en=i_en+1
	if(i_en.eq.1)then
	   call read_patch()
	   call read_power()
	   call read_gains()

	apr='vps'
	if(kpr.eq.1)print 71,apr,(vps(i),i=1,npfc)

	apr='kchop'
	if(kpr.eq.1)print 72,apr,(kchop(i),i=1,npfc)
	apr='nchop'
	if(kpr.eq.1)print 72,apr,(nchop(i),i=1,npfc)
	apr='ksign'
	if(kpr.eq.1)print 72,apr,(ksign(i),i=1,npfc)
	apr='kvert'
	if(kpr.eq.1)print 72,apr,(kvert(i),i=1,npfc)

	apr='pow_name'
	if(kpr.eq.1)print 5,(pow_names(i),i=1,npfc)
 5	format(9(a3))

	apr='res_ext'
	if(kpr.eq.1)print 71,apr,(res_ext(i),i=1,npfc)


	end if

72	format(20x,a6/,(1x,8(i4)))

	return
c----------------------------------------------------------
	do i=1,npfc
	vchopper(i)=0.
c###	fcom(i)=0.
	end do

c###	CALL zp_CONTROL()
c###	CALL rp_CONTROL()
	

	rp0=rpp
	del_x0=del_x
	del_x=(rmag-rp0)
	vel_x=(del_x-del_x0)/tay
	r_vel=vel_x	
	if(ntay.le.3)r_vel=0.
	!call rvel_filter()
	if(ntay.gt.3)then
	   if(kpr.eq.1)print*,g_r_p
	   if(kpr.eq.1)print*,g_r_d
	if(kpr.eq.1)print*,'111 pf7 pf8=',pf(7),pf(8)
	if(kpr.eq.1)print*,'ntay rmag rp0 tay',ntay,rmag,rp0,tay
	if(kpr.eq.1)print *,' del_x vel_x r_vel',del_x,vel_x,r_vel
	   pf(8)=pf(8)-(g_r_p(1)*del_x+g_r_d(1)*vel_x)
	   pf(8+8)=pf(8)
	if(kpr.eq.1)print*,'222 pf8=',pf(8)
c	   pf(7)=pf(7)-(g_r_p(1)*del_x+g_r_d(1)*vel_x)
c	   pf(7+8)=pf(7)
	if(kpr.eq.1)print*,'222 pf7 pf8=',pf(7),pf(8)
c	pause '!!!!!!!'
	end if

 	apr='VCHOP'
	if(kpr.eq.1)print 71,apr,(vchopper(i),i=1,npfc)



71	format(20x,a6/,(1X,6(1pe10.3)))
	return
	end


	subroutine read_epsdata()

	include 'double.inc'
	include 'new_com.inc'

	call read_epsdata_c(
     *  taup,v_offset)

	   return
	   end

	subroutine read_epsdata_c(
     *  taup,v_offset)

	include 'double.inc'
	   open(unit=41,file='eps_filter.dat',form='formatted')
	   read (41,*)
	   read (41,*)taup,v_offset
	   if(kpr.eq.1)print *,' taup v_offset',taup,v_offset
	   close (41)

	   return
	   end


	subroutine ecoil_test()

	include 'double.inc'
	include 'new_com.inc'

	call ecoil_test_c(
     *  r_r,r_l1,r_l2,r3,
     *  pt01,cip1,
     *  pf,vchopper,npf,
     *  veps,v_e,vecoil,v_out,
     *  tt,ntay,
     *  kpr,v_offset)

	return
	end

	subroutine ecoil_test_c(
     *  r_r,r_l1,r_l2,r_3,
     *  pt01,cip1,
     *  pf,vchopper,npf,
     *  veps,v_e,vecoil,v_out,
     *  tt,ntay,
     *  kpr,v_offset)
c---------------------
	include 'double.inc'
	dimension pf(npf),vchopper(npf)
c
c


c     ecoils comand
c---------------------------------------------------------


c   i_e total (IE+IF+) current in A...
	i_e=(pf(19)+pf(20)+pf(6)+pf(7)+pf(6+9)+
     *  pf(7+9))*1.e3

c------------------------------------------------------
	if(pf(19).le.0)then
	   r_s=r_l1
	   sign_e=-1.
	else
	   r_s=r_3+r_l1
	   sign_e=1.
	end if

	if(ntay.lt.2)veps=0.
	if(ntay.gt.2)then

	   vecoil=-i_e*(r_l2+r_s*r_r/(r_s+r_r))
	   coef_e=1.
	   

	   
c	   v_out=v_out+55.
	   v_out=v_out+v_offset


c!!!!	   call ve_calc()
c!!! old	   VEPS=sign_e*v_e*r_r/(r_s+r_r)-i_e*(r_l2+r_s/(r_s+r_r))
	   VEPS=sign_e*v_out*r_r/(r_s+r_r)+coef_e*vecoil
cccc	   VEPS=-VEPS
	end if

c	   veps=veps+75.

c	   vchopper(19)=veps

c	   veps=v_out


	if(veps.gt.1000.)veps=1000.
	if(veps.lt.-1000.)veps=-1000.


	if(kpr.eq.1)print*,'*** time ntay ',tt,ntay

c###
c	veps=0.
c###


	if(kpr.eq.1)print *,'i_e vecoil veps[V]',i_e,vecoil,veps
	if(kpr.eq.1)print *,'Ecoila Ecoilb [kA]',pf(19),pf(20)

	return
	end

	subroutine choppers_test()
c--------------------------------------------
c--------------------------------------------
	include 'double.inc'
c	implicit real *8(a-h,o-z)
	include 'parf1'
	parameter ( NPFC=KF-4)
C
	common
     *  /loop3/vloop,psf1a,psf1a0
	common
     *  /dfm5/pt01,pt02
	COMMON
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /ge2/ntay,tay,tt
     *  /ge5/kpr
	common
     *  /cont1/vchopper(kf),veps
     *  /cont2/vcont(kf),tcont(kf)
     *  /cont3/veps0,tramp,kread
     *  /cont4/ZPP,RPP,WVSPIP,ZXP,ELP,SHAPE,GAPINP,
     *  DFZP, DFZP0
     *  /CONT5/	FCOM(NPFC)
     *  /cont6/cip1,cip2,time1,time2


C
	character * 12 apr

	common 
     *  /c_con2/KCHOP(NPFC),
     *  KSIGN(NPFC),NCHOP(NPFC),res_ext(npfc)
     *  /c_con3/pow_names(npfc)
     *  /c_con4/vps(npfc),kvert(npfc)
     *  /c_con5/d,d2,v,t2,hv1,hv2
     *  /c_con7/volt(kf)
     *  /c_con8/key_con

	character *4 pow_names

	DIMENSION VPULL(NPFC)

	if(kpr.eq.1)print*,'ZPP from chopper  ',zpp

c   I_pl current transfer to A from kA...
	TPL=pt01*1.e3


 	apr='PF'
	if(kpr.eq.1)print 71,apr,(pf(i),i=1,npf)

	i_en=i_en+1
	if(i_en.eq.1)then
	   call read_patch()
	   call read_power()

	apr='vps'
	if(kpr.eq.1)print 71,apr,(vps(i),i=1,npfc)

	apr='kchop'
	if(kpr.eq.1)print 72,apr,(kchop(i),i=1,npfc)
	apr='nchop'
	if(kpr.eq.1)print 72,apr,(nchop(i),i=1,npfc)
	apr='ksign'
	if(kpr.eq.1)print 72,apr,(ksign(i),i=1,npfc)
	apr='kvert'
	if(kpr.eq.1)print 72,apr,(kvert(i),i=1,npfc)

	apr='pow_name'
	if(kpr.eq.1)print 5,(pow_names(i),i=1,npfc)
 5	format(9(a3))
	apr='res_ext'
	if(kpr.eq.1)print 71,apr,(res_ext(i),i=1,npfc)

c	read (*,*)

	end if

72	format(20x,a6/,(1x,8(i4)))


c----------------------------------------------------------
  	call shape_eps() 
	call ecoil_test()
	call eps_filter()
	call shape_volt()

c!!!	call ecoil_cont()

	do i=1,npfc
	vchopper(i)=0.
	fcom(i)=0.
	end do
C
	DO I=1,NPFC
c was in mOhm	VCHOPPER(I)=VCHOPPER(I)-pf(i)*1.e3*res_ext(i)*1.e-3
c!!!	VCHOPPER(I)=VCHOPPER(I)-pf(i)*1.e3*res_ext(i)
	END DO
c

	if(key_con.eq.0)then
	   
	   if(kpr.eq.1)print *,' KEY_CON===',key_con

	   do i=1,npfc
c!!!	      if(kchop(i).ne.0)vchopper(i)=ksign(i)*volt(i)+vchopper(i)
	      if(kchop(i).ne.0)vchopper(i)=volt(i)
	   end do

 	apr='VCHOP'
	if(kpr.eq.1)print 71,apr,(vchopper(i),i=1,npfc)
 	apr='volt'
	if(kpr.eq.1)print 71,apr,(volt(i),i=1,npfc)

	   end if



71	format(20x,a6/,(1X,6(1pe10.3)))
	return
	end
C
	subroutine contr_r()

	include 'double.inc'
	include 'new_com.inc'

	call contr_r_c(
     *  r_r,r_l1,r_l2,r_3,
     * 	cip1,cip2,
     *  tau_p,tau_i,tau_d,
     *  ECOIL_GP,ECOIL_GD,ECOIL_GI )


	return
	end

	subroutine contr_r_c(
     *  r_r,r_l1,r_l2,r_3,
     * 	cip1,cip2,
     *  tau_p,tau_i,tau_d,
     *  ECOIL_GP,ECOIL_GD,ECOIL_GI )

	include 'double.inc'
	common
     *  /cont4/ZPP,RPP,WVSPIP,ZXP,ELP,SHAPE,GAPINP,
     *  DFZP, DFZP0

c---
	open (unit=2,file='contr.dat',form='formatted')
	read (2,*)
	read (2,*)rpp,zxp,wvspip,shape,gapinp,elp
	read (2,*)
	read (2,*)zpp,cip1
	read (2,*)
	read (2,*)r_r,r_l1,r_l2,r_3
	read (2,*)
	read (2,*)tau_p,tau_d,tau_i
	read (2,*)
	read (2,*)ECOIL_GP,ECOIL_GD,ECOIL_GI
	close(2)

	return
	end

	subroutine ve_calc()

	include 'double.inc'
	include 'new_com.inc'

	call ve_calc_c(
     *  pt01,cip1,v_e,
     *  e_inp,p_out,v_out)

	return
	end

	subroutine ve_calc_c(
     *  pt01,cip1,v_e,
     *  e_inp,p_out,v_out)

	include 'double.inc'
	cip=cip1
	TPL=pt01*1.e3

	v_e=-1200.*(cip-tpl)/5.e5

	if(kpr.eq.1)print *,' cip tpl v_e ',cip,tpl,v_e

	e_inp=-(tpl-cip)/5.e5



        call pid()

	v_out=p_out*100.


	if(kpr.eq.1)print *,' e_inp p_out v_out ',e_inp,p_out,v_out

	return
	end

	subroutine ecoil_cont()

	include 'double.inc'
	include 'new_com.inc'

	call ecoil_cont_c(
     *  r_r,r_l1,r_l2,r3,
     *  pt01,cip1,
     *  pf,npf,
     *  veps,v_e,vecoil,v_out,
     *  fcom,key_con_ext,
     *  tt,ntay,
     *  kpr)

	return
	end

	subroutine ecoil_cont_c(
     *  r_r,r_l1,r_l2,r_3,
     *  pt01,cip1,
     *  pf,npf,
     *  veps,v_e,vecoil,v_out,
     *  fcom,key_con_ext,
     *  tt,ntay,
     *  kpr)
c---------------------
	include 'double.inc'
	dimension pf(*),fcom(*)
c
c


c     ecoils comand
c---------------------------------------------------------


c   i_e total (IE+IF+) current in A...
	i_e=(pf(19)+pf(20)+pf(6)+pf(7)+pf(6+9)+
     *  pf(7+9))*1.e3

c------------------------------------------------------
	if(pf(19).le.0)then
	   r_s=r_l1
	   sign_e=-1.
	else
	   r_s=r_3+r_l1
	   sign_e=1.
	end if

	   vecoil=-i_e*(r_l2+r_s*r_r/(r_s+r_r))
	   coef_e=1.



	if(ntay.lt.2)veps=0.
	if(ntay.gt.2)then
	   call ve_calc()

c  here v_out is fcom(19)...???

	   if(key_con_ext.eq.2)v_out=fcom(19)

c!!! old	   VEPS=sign_e*v_e*r_r/(r_s+r_r)-i_e*(r_l2+r_s/(r_s+r_r))
	   VEPS=sign_e*v_out*r_r/(r_s+r_r)+coef_e*vecoil
	end if

	if(veps.gt.1000.)veps=1000.
	if(veps.lt.-1000.)veps=-1000.


	if(kpr.eq.1)print*,'*** time ntay key_con_ext',tt,ntay,key_con_ext
	if(kpr.eq.1)print *,'i_e vecoil veps[V]',i_e,vecoil,veps
	if(kpr.eq.1)print *,'Ecoila Ecoilb [kA] v_out',pf(19),pf(20),v_out
	if(kpr.eq.1)print *,'fcom(19)',fcom(19)

	return
	end

C
	subroutine pfcurrent()
c--------------------------------------------
c  calculate pf currents
c--------------------------------------------
	include 'double.inc'
c	implicit real *8(a-h,o-z)
c	parameter(mu=88,ntet=134)
c	parameter (kf=22)
	include 'parf0'
	include 'parf1'
	parameter ( NPFC=KF-4)
	common
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /pf6/pves(kf),pves0(kf)
     *  /pf8/pfind(kf,kf),pfres(kf),a1(kf,kf),e1(kf),e2(kf)
	common
     *  /ves1/psp(mu),psp0(mu),tcam(mu),tcam0(mu)
     *  /ves2/ncam,rc(mu),zc(mu)
     *  /ves5/pfc(mu,kf)
	common
     *  /pf7/plasma(kf),plasma0(kf)
c
	common
     *  /ge2/ntay,tay,tt
     *  /ge5/kpr
	common
     *  /eq5/ts00(ntet),yrg(ntet),yzg(ntet)
	common
     *  /cont1/vchopper(kf),veps
c
	dimension fu(kf),f(kf),d0(kf),d1(kf),d2(kf)
	dimension fupl(kf),fuves(kf),fuch(kf),fupf(kf)
	character *70 apr
	beta=1.
	alf=1.
	kpr_in=kpr
	kpr=0
	if(ntay.lt.10)alf=0.
c
c
c***********************
c   vessel flux   ****************
	do i=1,npf
	pves(i)=0.
	end do
	do j=1,npf
	do i=1,ncam
	pves(j)=pves(j)+pfc(i,j)*tcam(i)
	end do
	end do
c
c******
	apr='plasma'
c	if(kpr.eq.1)print 71,apr,(plasma(i),i=1,npf)
	apr='plasm0'
c	if(kpr.eq.1)print 71,apr,(plasma0(i),i=1,npf)
	apr='pves'
c	if(kpr.eq.1)print 71,apr,(pves(i),i=1,npf)
	apr='pve0'
c	if(kpr.eq.1)print 71,apr,(pves0(i),i=1,npf)
c____________________________________________
c	if(jcam.lt.2)return
	if(ntay.lt.2)return
c_____________________________________________
	do i=1,npf
	fu(i)=0.
c
	do j=1,npf
	fu(i)=fu(i)+pfind(i,j)*pf0(j)
	end do
c
	fupl(i)=-(plasma(i)-plasma0(i))/(100.*tay)
	fuves(i)=-(pves(i)-pves0(i))/(100.*tay)
	fuch(i)=vchopper(i)*100*tay/(100.*tay)
	fu(i)=fu(i)-beta*(plasma(i)-plasma0(i))-alf*(pves(i)-pves0(i))
	end do
c***************************************************************
	apr='V in coils by pl,V (pfcurrent)'
	if(kpr.eq.1)print 71,apr,(fupl(i),i=1,npf)
	apr='V in coils by cam,V (pfcurrent)'
	if(kpr.eq.1)print 71,apr,(fuves(i),i=1,npf)
	apr='V in coils by choppers,V (pfcurrent)'
	if(kpr.eq.1)print 71,apr,(fuch(i),i=1,npf)
c    chopper voltage
	do i=1,npf
	fu(i)=fu(i)+vchopper(i)*100.*tay
	end do
	apr='fu c'
C	if(kpr.eq.1)print 71,apr,(fu(i),i=1,npf)
c*****************************************************************
	apr='e1'
C	if(kpr.eq.1)print 71,apr,(e1(i),i=1,npf)
	apr='e2'
C	if(kpr.eq.1)print 71,apr,(e2(i),i=1,npf)
	do i=1,npf
	d0(i)=0.
	d1(i)=0.
	d2(i)=0.
	do k=1,npf
	d0(i)=d0(i)+a1(i,k)*fu(k)
	d1(i)=d1(i)+a1(i,k)*e1(k)
	d2(i)=d2(i)+a1(i,k)*e2(k)
	end do
	end do
	apr='d0'
C	if(kpr.eq.1)print 71,apr,(d0(i),i=1,npf)
	apr='d1'
C	if(kpr.eq.1)print 71,apr,(d1(i),i=1,npf)
	apr='d2'
C	if(kpr.eq.1)print 71,apr,(d2(i),i=1,npf)
c
	sum0=0.
	sum1=0.
	sum2=0.
	do i=1,5
	k=i+9
	sum0=sum0+d0(i)+d0(k)
	sum1=sum1+d1(i)+d1(k)
	sum2=sum2+d2(i)+d2(k)
	end do
c
	do i=8,9
	k=i+9
	sum0=sum0+d0(i)+d0(k)
	sum1=sum1+d1(i)+d1(k)
	sum2=sum2+d2(i)+d2(k)
	end do
c_____________________________________________________
	veps1=veps*100.*tay
	v0=-(sum0+veps1*sum2)/sum1
c	if(ntay.le.100)v0=0.1*v0
	v0prin=v0/(100.*tay)
	if(kpr.eq.1)print *,'v0 veps[V]',v0prin,veps
c
	do i=1,npf
	pf(i)=d0(i)+v0*d1(i)+veps1*d2(i)
	end do
	sum0=0.
	do i=1,5
	k=i+9
	sum0=sum0+pf(i)+pf(k)
	end do
c
	do i=8,9
	k=i+9
	sum0=sum0+pf(i)+pf(k)
	end do
c	if(kpr.eq.1)print *,'total pf coil currents=',sum0,' kA'
	apr='pf0 1-18,kA'
c	if(kpr.eq.1)print 71,apr,(pf0(i),i=1,18)
	apr='pf 1-18,kA'
c	if(kpr.eq.1)print 71,apr,(pf(i),i=1,18)
	fu(1)=pf0(19)
	fu(2)=pf0(20)
c
	fu(3)=pf(19)
	fu(4)=pf(20)
	apr='pf e-coils,kA'
	if(kpr.eq.1)print 71,apr,(fu(i),i=1,4)
	do i=1,npf
	fupf(i)=0.
c
	do j=1,npf
	fupf(i)=fupf(i)-pfind(i,j)*(pf(j)-pf0(j))/(100.*tay)
	end do
	end do
	apr='Upf mutual,V'
	if(kpr.eq.1)print 71,apr,(fupf(i),i=1,npf)
c
	do i=1,npf
	fu(i)=fupf(i)+fupl(i)+fuves(i)+fuch(i)+
     *  v0prin*e1(i)+veps*e2(i)
	end do
c
	apr='Upf sum,V'
	if(kpr.eq.1)print 71,apr,(fu(i),i=1,npf)
	do i=1,npf
	fu(i)=beta*fupl(i)+alf*fuves(i)+fuch(i)+
     *  v0prin*e1(i)+veps*e2(i)
	end do
	apr='Upf ext,V'
	if(kpr.eq.1)print 71,apr,(fu(i),i=1,npf)
c
	do i=1,npf
      	fu(i)= pfres(i)*pf(i)*1.e+3
	end do
	apr='Rpf * Ipf,V'
	if(kpr.eq.1)print 71,apr,(fu(i),i=1,npf)

	kpr=kpr_in
c
c===============================
71	format(5x,a70/,(1X,6(1pe11.3)))
	return
	end

c old subroutine for choppers, Arnie Kellman's pull(...)

	SUBROUTINE PULL (VPULL,KCHOP,PF,NCHOP)
	include 'double.inc'
c	IMPLICIT REAL *8 (A-H,O-Z)
	common
     *  /ge5/kpr
	REAL IPULL
	VPULL=0.
C
	IPULL=abs(PF)/NCHOP*1.E3
c	if(kpr.eq.1)print *,'KCHOP IPULL',KCHOP,IPULL
1	CONTINUE
	IF(KCHOP.EQ.2)THEN
	VPULL0=VPULL
	if(vpull.le.1.e-5)vpull=1.e-5
	VPULL=0.5*( IPULL/(1./0.81+6.*(VPULL/425.)**3.3/425.)+
     *  VPULL0)
c	if(kpr.eq.1)print *,'VPULL VPULL0',VPULL,VPULL0
	IF(abs(VPULL0-VPULL).GT.1.E-3*abs(VPULL) )GO TO 1
	END IF
	IF(KCHOP.EQ.1)THEN
	PW=1./4.5
	VPULL=190.*(IPULL/9.)**PW
C	if(kpr.eq.1)print *,'KCHOP VPULL',KCHOP,VPULL
	END IF
	RETURN
	END
c
	SUBROUTINE PULLn (VPULL,KCHOP,PF,NCHOP,VC,DC,VPS,v01)
	include 'double.inc'
c	IMPLICIT REAL *8 (A-H,O-Z)
	common
     *  /ge5/kpr
	REAL IPULL
c
	IPULL=abs(PF)*1.E3
c
	if(kchop.eq.1)then
c
c------------/DC modulation ratio/ -----
	DC=0.694+2.012e-2*VC-2.755e-3*VC**2+
     *  3.136e-4*VC**3+1.434e-5*VC**4-2.238e-6*VC**5
c-------------------------------------------
c
c--------------/ f=frequency/----
	f=2944-76.97*VC**2+2.97*VC**4-0.0779*VC**6+
     *  8.98e-4*VC**8-3.61e-6*VC**10
c-----------------
c
c----------/ v01=avearge push voltage/----
	v01=0.9584*vps*( 1.+0.146*(1.-vps/600.)*(ipull+1500.)/
     *  (ipull+300.) )
c
c----------/ vpull=avearge pull voltage/----
	v02=-94.5*(ipull/nchop)**0.25
	c=120.e-6
	pk2=0.9
	vp=0.5*pk2*c*v02*nchop*f/((1.-DC)*ipull)
c	if(kpr.eq.1)print *,' pk2 *c *v02 *nchop *f',pk2,c,v02,nchop,f
	dc1=1-DC
c	if(kpr.eq.1)print *,' vc  vps',vc,vps
c	if(kpr.eq.1)print *,'dc1 ipull',dc1,ipull
cccc	vpull=v02*(1.+(0.5*pk2*c*v02*nchop*f)/((1.-DC)*ipull))
cccc	if(vpull.gt.0.)vpull=0.
	t1=dc/f
	t2=-pk2*c*v02*nchop/ipull
	t3=(1.-dc)/f-t2
	if(t3.ge.0)vpull=v02*(0.5*t2+t3)/(t2+t3)
	if(t3.lt.0.)vpull=0.5*v02*(1.-dc)/(f*t2)
c	if(kpr.eq.1)print *,' v02 DC f ipull vpull vp',v02,dc,f,ipull,vpull,vp
c---o-----------------
c	pause
	end if
C000
	if(kchop.eq.2)then
c------------/DC modulation ratio/ -----
	DC=0.628+1.77e-2*VC-1.965e-3*VC**2+
     *  4.253e-4*VC**3+1.027e-5*VC**4-2.901e-6*VC**5
c-------------------------------------------
c
c--------------/ f=frequency/----
	f=3039.1-69.33*VC**2+2.44*VC**4-0.0619*VC**6+
     *  6.9e-4*VC**8-2.69e-6*VC**10
c-----------------
c
c----------/ v01=avearge push voltage/----
	v01=vps
c
      ppp=ipull/nchop
c----------/ vpull=avearge pull voltage/----
	if(abs(ppp).lt.700.)then
	v02=-0.75*(ipull/nchop)
	else
	v02=-(1575.*ipull/nchop-6.e5)**0.476
	end if
	c=60.e-6
	pk2=1.8
cccc	vpull=v02*(1.+(0.55*pk2*c*v02*nchop*f)/((1.-DC)*ipull))
cccc	if(vpull.gt.0.)vpull=0.
	t1=dc/f
	t2=-pk2*c*v02*nchop/ipull
	t3=(1.-dc)/f-t2
	if(t3.ge.0)vpull=v02*(0.5*t2+t3)/(t2+t3)
	if(t3.lt.0.)vpull=0.5*v02*(1.-dc)/(f*t2)
c--------------------
	end if
	RETURN
	END

	SUBROUTINE PULLc (VCHOPPER,KCHOP,PF,NCHOP,VC,VPS)
	include 'double.inc'
c	IMPLICIT REAL *8 (A-H,O-Z)
	common
     *  /ge5/kpr
c
       	real*8	y,u(4)
c
c      ' coil current ============== u(1)'
c      ' Power Supply voltage ====== u(2)'
c      ' chopper command voltage === u(3)'
c      ' number of choppers =========u(4)'
c
	u(1)=abs(pf)*1.e3
	u(2)=VPS
	u(3)=VC
	u(4)=nchop
c--->
ccc	if(kchop.eq.1)then
ccc        call x_voltage(y,u)
ccc	vchopper=y
ccc	end if
C000
ccc	if(kchop.eq.2)then
ccc        call hx_voltage(y,u)
ccc	vchopper=y
ccc	end if
	RETURN
	END			

	subroutine filter()

	include 'double.inc'
	include 'parf1'
	common
     *  /ge2/ntay,tay,tt
	COMMON
     *  /pf1/npf,pf(kf),pf0(kf)

	common 
     *  /c_filter/f9af

        i_en=i_en+1

	time=tt

	f9a=pf(9)

	if(i_en.eq.1)then
           e1 = f9a
           f9af=e1
           v1 = f9af
           time1 = time
        end if

c	qqp = 0.5 * 5.0e-5 * (time - time1)*1.e3

	qqp = 0.5 * 5.0e-2 * (time - time1)

	f9af =(qqp * (f9a + e1) - (qqp - 1.0) * v1) / (qqp + 1.0)

	if(kpr.eq.1)print *,' tt pf(9) f9a f9af----',tt,pf(9),f9a,f9af

c  saving for the next time_step...

	e1 = f9a
	
	v1 = f9af
	
	time1 = time

	return
	end

	subroutine  read_power()

	include 'double.inc'
	include 'new_com.inc'

	call read_power_c(
     *  key_con_ext)
	
	return
	end


	subroutine read_power_c(
     *  key_con_ext)

	include 'double.inc'
	include 'parf1'
	parameter ( NPFC=KF-4)
	common 
     *  /c_con2/KCHOP(NPFC),
     *  KSIGN(NPFC),NCHOP(NPFC),res_ext(npfc)
     *  /c_con3/pow_names(npfc)
     *  /c_con4/vps(npfc),kvert(npfc)
     *  /c_con5/d,d2,v,t2,hv1,hv2
     *  /c_con8/key_con

	character *4 pow_names

	open (unit=41,file='power.txt',form='formatted')
	read (41,*)
	read (41,*)d,d2,v,t2,hv1,hv2,t1,v1,d1
	read (41,*)
	read (41,*)key_con
	read (41,*)
	read (41,*)(kvert(i),i=1,npfc)
	
	close (41)

	if(kpr.eq.1)print *,'d,d2,v,t2,hv1,hv2'
	if(kpr.eq.1)print *,d,d2,v,t2,hv1,hv2

	if(kpr.eq.1)print *,' t1 v1 d1'
	if(kpr.eq.1)print *,t1,v1,d1

	if(kpr.eq.1)print *,' KEY_CON==',key_con

	if(key_con_ext.eq.1)key_con=0
	if(key_con_ext.eq.2)key_con=1
	if(key_con_ext.eq.3)key_con=2

	if(kpr.eq.1)print *,' KEY_CON=   key_con_ext   =',key_con,key_con_ext

c----
	do i=1,npfc
	   if(key_con.eq.0)kvert(i)=0
	   if(key_con.eq.1)kvert(i)=1
	end do
c----
	do i=1,npfc
	if(pow_names(i).eq.'D  ,')vps(i)=d
 	if(pow_names(i).eq.'D1 ,')vps(i)=d1
 	if(pow_names(i).eq.'D2 ,')vps(i)=d2
	if(pow_names(i).eq.'V  ,')vps(i)=v
	if(pow_names(i).eq.'V1 ,')vps(i)=v1
	if(pow_names(i).eq.'T1 ,')vps(i)=t1
	if(pow_names(i).eq.'T2 ,')vps(i)=t2
	if(pow_names(i).eq.'HV1,')vps(i)=hv1
	if(pow_names(i).eq.'HV2,')vps(i)=hv2
	end do
c----

	return
	end

	subroutine  read_patch()

	include 'double.inc'
	include 'parf1'
	parameter ( NPFC=KF-4)
	common 
     *  /c_con2/KCHOP(NPFC),
     *  KSIGN(NPFC),NCHOP(NPFC),res_ext(npfc)
     *  /c_con3/pow_names(npfc)
     *  /c_con4/vps(npfc),kvert(npfc)
     *  /c_con5/d,d2,v,t2,hv1,hv2

	character * 12 apr

	open (unit=41,file='PP_DINA.dat',form='formatted')
	read (41,*)
	read (41,*)(res_ext(i),i=1,npfc)
	if(kpr.eq.1)print *,' RES_EXT read'
	read (41,*)
	read (41,*)(kchop(i),i=1,npfc)
	if(kpr.eq.1)print *,' kchop read'
	read (41,*)
	read (41,*)(ksign(i),i=1,npfc)
	if(kpr.eq.1)print *,' ksign read'
	read (41,*)
	read (41,*)(nchop(i),i=1,npfc)
	if(kpr.eq.1)print *,' nchop read'
	read (41,*)
	read (41,5)(pow_names(i),i=1,npfc)
c	read (41,*)(pow_names(i),i=1,npfc)
	if(kpr.eq.1)print *,'pow read'

	apr='pow_name'
	if(kpr.eq.1)print 6,(pow_names(i),i=1,npfc)
 6	format(9(a4))

72	format(20x,a6/,(1x,8(i4)))
 5	format(9(a4,1x))
c 5	format(9(a4))

	return
	end



	subroutine  read_gains()

	include 'double.inc'
	include 'new_com.inc'

	call read_gains_c(
     *  g_r_p,g_r_d,g_r_i,g_z_p,g_z_d,g_z_i,
     *  t_rvel,t_zvel)
	
	return
	end


	subroutine read_gains_c(
     *  g_r_p,g_r_d,g_r_i,g_z_p,g_z_d,g_z_i,
     *  t_rvel,t_zvel)

	include 'double.inc'
	dimension g_r_p(*),g_r_d(*),g_r_i(*)
	dimension g_z_p(*),g_z_d(*),g_z_i(*)

	open (unit=41,file='gains.txt',form='formatted')
	read (41,*)
	read (41,*)g_r_p(1),g_r_d(1),g_r_i(1)
	read (41,*)
	read (41,*)g_z_p(1),g_z_d(1),g_z_i(1)
	read (41,*)
	read (41,*)g_r_p(2),g_r_d(2),g_r_i(2)
	read (41,*)
	read (41,*)g_z_p(2),g_z_d(2),g_z_i(2)
	read (41,*)
	read (41,*)t_rvel,t_zvel

	if(kpr.eq.1)print *,'g_r_p',(g_r_p(i),i=1,2)
	if(kpr.eq.1)print *,'g_z_p',(g_z_p(i),i=1,2)

	if(kpr.eq.1)print *,'g_r_d',(g_r_d(i),i=1,2)
	if(kpr.eq.1)print *,'g_z_d',(g_z_d(i),i=1,2)

	if(kpr.eq.1)print *,'g_r_i',(g_r_i(i),i=1,2)
	if(kpr.eq.1)print *,'g_z_i',(g_z_i(i),i=1,2)

	if(kpr.eq.1)print *,' t_rvel t_zvel==',t_rvel,t_zvel
	close (41)

	return
	end








