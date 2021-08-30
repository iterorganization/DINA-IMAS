	subroutine d3d_coef()
c---------------------------------------
	include 'double.inc'
	include 'parf1'
	common
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /pf8/pfind(kf,kf),pfres(kf),a1(kf,kf),e1(kf),e2(kf)

	character *8 apr

	do i=1,npf
	e1(i)=0.
	e2(i)=1.
	end do
	do i=1,5
	k=i+9
	e1(i)=1.
	e1(k)=1.
	e2(i)=0.
	e2(k)=0.
	end do
c--->
	do i=8,9
	k=i+9
	e1(i)=1.
	e1(k)=1.
	e2(i)=0.
	e2(k)=0.
	end do

71	format(20x,a6/,(6(1x,1pe12.5)))
	return
	end
	subroutine prob_r()
	include 'double.inc'
c	implicit real*8 (a-h,o-z)
	include 'parf1'
	include 'parf4'
	common
     *  /ge1/pi
     *  /ge5/kpr
	common
     *  /probe1/kprobe,bprobe(nprobe)
     *  /probe2/pfprobe(nprobe,kf),vesprobe(nprobe,mu)
c
	character *8 apr
	CHARACTER*120 tmp
cc
	open (unit=40,file='probe.fl',form='formatted')
	read (40,*)
	read (40,74)tmp
74	format(a110)
	close (40)
c
c  read probe coordinates
     	open(unit=41,file=tmp,form='formatted')
	read (41,*)
	read (41,*)kprobe,npf

	if(kprobe.eq.0)then
	   close(41)
	   return
	end if


	do i=1,kprobe
	read (41,*)(pfprobe(i,j),j=1,npf)
	end do
	read (41,*)
	read (41,*)kprobe,ncam

	do i=1,kprobe
	read (41,*)(vesprobe(i,j),j=1,ncam)
	end do
	close(41)

	apr='pfprobe'
	do i=1,kprobe
c	if(kpr.eq.1)print 71,apr,(pfprobe(i,j),j=1,npf)
	end do

	apr='ves pr'
	do i=1,kprobe
c	if(kpr.eq.1)print 71,apr,(vesprobe(i,j),j=1,ncam)
	end do
c
71	format(20x,a8/,(6(1x,1pe10.3)))
72	format(20x,a8/,(3(3x,1pe10.3,1x,1pe10.3)))
	return
	end

	subroutine loop_r()
c-----------------------------------------
c  input loops coordinates
c  calculate greens from PF and vessel...
c---------------------------------------
	include 'double.inc'
c	implicit real*8 (a-h,o-z)

	include 'parf1'
	include 'parf4'
c
	common
     *  /ge1/pi
     *  /ge5/kpr
	common
     *  /loop1/kloop,RL(nloop),ZL(nloop),psloop(nloop)
     *  /loop2/pfgreen(nloop,kf),vesgreen(nloop,mu)
     *  /loop4/psloopg(nloop),psloopg0(nloop)
c
	dimension f(kf)

	character *8 apr
	CHARACTER*120 fshot,tmp
c------------------------------
c  read loops coordinates
cc
	open (unit=40,file='loop.fl',form='formatted')
	read (40,*)
	read (40,74)tmp
	close (40)
74	format(a110)
     	open(unit=41,status='old',file=tmp,form='formatted')
	read (41,*)
	read (41,*)kloop,npf

	if(kloop.eq.0)then
	   close(41)
	   return
	end if

	do i=1,kloop
	read (41,*)(pfgreen(i,j),j=1,npf)
	end do

	read (41,*)
	read (41,*)kloop,ncam
	do i=1,kloop
	read (41,*)(vesgreen(i,j),j=1,ncam)
	end do

	apr='pfgree'
	do i=1,kloop
c	if(kpr.eq.1)print 71,apr,(pfgreen(i,j),j=1,npf)
	end do

	apr='vesgreen'
	do i=1,kloop
c	if(kpr.eq.1)print 71,apr,(vesgreen(i,j),j=1,ncam)
	end do

71	format(20x,a6/,(6(1x,1pe10.3)))
	return
	end
c
	subroutine ves_pf_r()
	include 'double.inc'
c	implicit real*8 (a-h,o-z)
	include 'parf1'
	include 'parf4'
c
	common
     *  /ves2/ncam,rc(mu),zc(mu)
     *  /ves2e/dl(mu),hl(mu)
     *  /ves3/b(mu,mu),pmj(mu,mu)
     *  /ves4/rcam(mu)
     *  /ves5/pfc(mu,kf)
	common
     *  /ge1/pi
     *  /ge5/kpr
	common
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /pf4/rvert(kf),svert(kf)
     *  /pf8/pfind(kf,kf),pfres(kf),a1(kf,kf),e1(kf),e2(kf)
     *  /pf9/zvert(kf)
c
	dimension a(mu,mu),d(mu,mu),ppm(mu),ed(mu,mu)
c
	dimension f(kf)
	character *8 apr

	CHARACTER*120 fshot,tmp
c---------------------------------
	open (unit=40,file='ves_ind.fl',form='formatted')
	read (40,*)
	read (40,74)tmp
	close (40)
     	open(unit=4,file=tmp,form='formatted')
74	format(a110)
	read (4,*)
	read (4,*)ncam
	read (4,*)
	do i=1,ncam
	read (4,5000)(pmj(i,j),j=1,ncam)
	end do

	open (unit=40,file='pf_ves.fl',form='formatted')
	read (40,*)
	read (40,74)tmp
	close (40)
     	open(unit=4,file=tmp,form='formatted')

	read (4,*)
	read (4,*)ncam,npf
	read (4,*)
	do i=1,ncam
	read (4,5000)(pfc(i,j),j=1,npf)
	end do


	tmp='pfc'
	do i=1,ncam
c	if(kpr.eq.1)print 71,tmp,(pfc(i,j),j=1,npf)
	end do

	do i=1,ncam
	do j=1,npf
c	if(j.eq.7)pfc(i,j)=0.
c	if(j.eq.7+9)pfc(i,j)=0.
	end do
	end do

	close(4)

5000	format(4(1x,1pe11.4))

71	format(20x,a6/,(6(1x,1pe10.3)))
c----
	return
	end
c
	subroutine limiter()
c-----------------------------------------
c  input limiter coordinates
c---------------------------------------
	include 'double.inc'
c	implicit real*8 (a-h,o-z)
	include 'parf7'
c
        common
     *  /ge5/kpr
	common
     *  /eq2/ke,xu(mu_l),yu(mu_l)
	common
     *	/keys3/kzero,iread,iwrite
	character *8 apr
c---------------------------------
	CHARACTER*120 fshot,tmp
c---------------------------------
	if(iread.eq.0)
     *	open (unit=40,file='lim_sqr.fl',form='formatted')
	if(iread.eq.1)
     *	open (unit=40,file='lim_bas.fl',form='formatted')
	read (40,*)
	read (40,74)tmp
	close (40)
     	open(unit=41,status='old',file=tmp,form='formatted')
74	format(a110)
	read (41,*)
	read (41,*)ke,ksim
	read (41,*)
	read(41,*)(xu(i),yu(i),i=1,ke)
	if(kpr.eq.1)print *,'ke ksim',ke,ksim
c====================================
	if(ksim.eq.1)then
	n_ke=ke
	do i=1,n_ke
	ke=ke+1
	ik=n_ke-i+1
	xu(ke)=xu(ik)
	yu(ke)=-yu(ik)
	END DO
	end if
	ke=ke+1
	xu(ke)=xu(1)
	yu(ke)=yu(1)
c=====================================
	if(kpr.eq.1)print *,'ke=',ke
	apr='xu'
	if(kpr.eq.1)print 71,apr,(xu(i),i=1,ke)
	apr='yu'
	if(kpr.eq.1)print 71,apr,(yu(i),i=1,ke)
	close(41)
71	format(20x,a6/,(6(1x,1pe10.3)))
	return
	end
	subroutine res_ves()
	include 'double.inc'
	include 'new_com.inc'

	call res_ves_c(ncam,rcam,res_coef,kpr)


	return
	end

	subroutine res_ves_c(ncam,rcam,res_coef,kpr)
	include 'double.inc'
	dimension rcam(ncam)

	res_ves=0.
	do i=1,ncam
	   rcam(i)=rcam(i)*res_coef
	   res_ves=res_ves+1./rcam(i)
	end do
	   res_ves=1./res_ves

	if(kpr.eq.1)print *,'ncam res_ves res_coef',ncam,res_ves,res_coef

	return
	end
	subroutine vessel()
c-----------------------------------------
c  input vessel coordinates
c---------------------------------------
	include 'double.inc'
c	implicit real*8 (a-h,o-z)
	include 'parf1'
c
        common
     *  /ge5/kpr
	common
     *  /ves2/ncam,rc(mu),zc(mu)
     *  /ves2e/dl(mu),hl(mu)
     *  /ves4/rcam(mu)
	character *8 apr
	CHARACTER*120 fshot,tmp
c---------------------------------
c Here spatial dimensions in *cm*, resistances in *ohms*
	open (unit=40,file='klim.fl',form='formatted')
	read (40,*)
	read (40,74)tmp
	close (40)

     	open(unit=41,status='old',file=tmp,form='formatted')
74	format(a110)
	read (41,*)
	read (41,*)ncam
	do i=1,ncam
	read (41,*)
	read (41,*)
	read(41,*) rc(i),zc(i),dl(i),hl(i),rcam(i)
	end do
	if(kpr.eq.1)print *,'ncam',ncam
	close (41)
	apr='rcam'
	if(kpr.eq.1)print 71,apr,(rcam(i),i=1,ncam)
	apr='rc'
	if(kpr.eq.1)print 71,apr,(rc(i),i=1,ncam)
	apr='zc'
	if(kpr.eq.1)print 71,apr,(zc(i),i=1,ncam)
71	format(20x,a6/,(6(1x,1pe10.3)))

	r_ves=0.
	do i=1,ncam
	   r_ves=r_ves+1./rcam(i)
	end do
	r_ves=1./r_ves
	if(kpr.eq.1)print*,'our r_ves=',r_ves

	return
	end

	subroutine pf_d3d()
c-----------------------------------------
c  input PF mutuals and resistances
c---------------------------------------
	include 'double.inc'
c	implicit real*8 (a-h,o-z)
	include 'parf1'
	common
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /pf3/nmx(kf),turn(kf)
     *  /pf4/rvert(kf),svert(kf)
     *  /pf8/pfind(kf,kf),pfres(kf),a1(kf,kf),e1(kf),e2(kf)
     *  /pf9/zvert(kf)
        common
     *  /ge1/pi
     *  /ge5/kpr

	character *8 apr
c===================================================
	CHARACTER*120 fshot,tmp
c---------------------------------
	open (unit=40,file='induc.fl',form='formatted')
	read (40,*)
	read (40,74)tmp
	close (40)

     	open(unit=41,status='old',file=tmp,form='formatted')
	if(kpr.eq.1)print *,' induc reading...',tmp
74	format(a110)
c________________________________________________
c   read inductances and resistances
c	npfc is number of f-coils
	npfc=npf-4
c    npfe -is number of E-coils
	npfe=2
c
	do i=1,npf
	do j=1,npf
	pfind(i,j)=0.
	end do
	end do

	read(41,*)
	do j=1,npf
	read(41,*)aaa,turn(j)
	end do

c  read fc due to fc
	read(41,*)
	DO I=1,npfc
	read(41,*)(pfind(i,j),j=1,npfc)
	END DO
c  read fc due to ec
	read(41,*)
	DO j=npfc+1,npfc+npfe
	read(41,*)(pfind(i,j),i=1,npfc)
	do i=1,npfc
	pfind(i,j)=pfind(i,j)/turn(j)
	end do
	END DO
c  calculate  ec due to fc
	DO I=npfc+1,npfc+npfe
	do j=1,npfc
	pfind(i,j)=pfind(j,i)
	end do
	END DO
c read ec due ec
	read(41,*)
	do i=npfc+1,npfc+npfe
	read(41,*)(pfind(i,j),j=npfc+1,npfc+npfe)
	do j=npfc+1,npfc+npfe
	pfind(i,j)=pfind(i,j)/(turn(i)*turn(j))
	end do
	end do
c  read additinal self-inductance
	read (41,*)
	read(41,*)(pfind(i,i),i=npf-1,npf)
c
	read(41,*)
	read(41,*)(pfres(j),pfres(j+9),j=1,9)
	read(41,*)
	read(41,*)(pfres(j),j=npfc+1,npf)
c
	close(41)
c
	do i=1,npf
	pfres(i)=pfres(i)*1.e-3
c___________________________________________________
c	pfres(i)=pfres(i)*1.e2
c____________________________________________________
	do j=1,npf
	pfind(i,j)=pfind(i,j)*2.*pi*turn(i)*turn(j)*1.e8
c________________________________________________________
c	if(i.ne.j)pfind(i,j)=0.
c___________________________________________________________
	end do
	end do
	if(kpr.eq.1)print *,' end pfind reading'


	do i=1,npf
	do j=1,npf
c	if(i.ne.j)pfind(i,j)=0.
	end do
	end do
	apr='pfind'
	do i=1,npf
c	if(kpr.eq.1)print 71,apr,(pfind(i,j),j=1,npf)
	end do
	apr='pfres'
c	if(kpr.eq.1)print 71,apr,(pfres(j),j=1,npf)
c--------------------------------------
	i_db=1
	if(i_db.eq.1)then
	   open(unit=41,file='d3d_dina_ind.dat',form='formatted')

	apr='pfind'

	do i=1,npf
	   write(41,71)apr,(pfind(i,j),j=1,npf)
	end do
	apr='pfres'
	write(41,71)apr,(pfres(j),j=1,npf)
	
	close(41)
	end if
c--------------------------------------


	do i=1,npf
	e1(i)=0.
	e2(i)=1.
	end do
	do i=1,5
	k=i+9
	e1(i)=1.
	e1(k)=1.
	e2(i)=0.
	e2(k)=0.
	end do
c--->
	do i=8,9
	k=i+9
	e1(i)=1.
	e1(k)=1.
	e2(i)=0.
	e2(k)=0.
	end do

71	format(20x,a6/,(6(1x,1pe12.5)))
	return
	end

	subroutine pf_ind()
c-----------------------------------------
c  input PF mutuals and resistances
c---------------------------------------
	include 'double.inc'
c	implicit real*8 (a-h,o-z)
	include 'parf1'
	common
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /pf3/nmx(kf),turn(kf)
     *  /pf4/rvert(kf),svert(kf)
     *  /pf8/pfind(kf,kf),pfres(kf),a1(kf,kf),e1(kf),e2(kf)
     *  /pf9/zvert(kf)
        common
     *  /ge5/kpr

	character *8 apr
c===================================================
	CHARACTER*120 fshot,tmp
c---------------------------------
	open (unit=40,file='pf_ind.fl',form='formatted')
	read (40,*)
	read (40,74)tmp
	close (40)
     	open(unit=4,status='old',file=tmp,form='formatted')
74	format(a110)
	read (4,*)npf1
	if(kpr.eq.1)print *,' npf1 npf',npf1,npf
	read (4,*)
	do i=1,npf
	read (4,*)(pfind(i,j),j=1,npf)
	end do
	do i=1,npf
	do j=1,npf
c	if(i.ne.j)pfind(i,j)=0.
	end do
	end do
	read (4,*)
	read (4,*)(pfres(j),j=1,npf)
	close(4)
c---------
	apr='pfind'
	do i=1,npf
	if(kpr.eq.1)print 71,apr,(pfind(i,j),j=1,npf)
	end do
	apr='pfres'
	if(kpr.eq.1)print 71,apr,(pfres(j),j=1,npf)

71	format(20x,a6/,(6(1x,1pe10.3)))
	return
	end

	subroutine tok()
c------------------------------------
c  read PF coil currents
c----------------------------------
	include 'double.inc'
c	implicit real*8 (a-h,o-z)
	include 'parf1'
        COMMON
     *  /pf1/npf,pf(kf),pf0(kf)
        common
     *  /ge5/kpr
	CHARACTER*120 fshot,tmp
cc
	open (unit=40,file='tok.fl',form='formatted')
	read (40,*)
	read (40,74)tmp
74	format(a110)
	close (40)
     	open(unit=41,status='old',file=tmp,form='formatted')
	read (41,*)
	read (41,*) npf
	if(kpr.eq.1)print *,'npf=',npf
c
	do i=1,npf
	read (41,*)
	read(41,*)pf(i)
	pf0(i)=pf(i)
	end do
c
	if(kpr.eq.1)PRINT*,'CURRENTS'
	if(kpr.eq.1)PRINT 7,(Pf(i),i=1,npf)
7 	format (/,(2x,E14.7))
	close(41)
c
71 	format (20x,a6/,(8(1pe10.3)))
C
	RETURN
	END




