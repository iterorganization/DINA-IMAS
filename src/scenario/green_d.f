	subroutine read_psgrid()
	include 'double.inc'
	include 'parf2'
	include 'parf2e'

	common
     *  /ge5/kpr
	common
     *  /eq1/psi(nwnh),pspl(nwnh),x(NR),y(NZ),dx,dy
     *  /eq16/psgrid(nwnh,ngrid)
c
	common /fluxc8/
     *  work(nwnhe)
c
	character *200 f1,f2,f3
c
c-----------
	open (unit=40,file='flux.fl',form='formatted')
	read (40,*)
	read (40,74)f1
	read (40,*)
	read (40,74)f2
	read (40,*)
	read (40,74)f3
74	format(a110)
	close (40)
c----
	open (unit=2,file=f3,form='unformatted')

	do k=1,ngrid
	read (2) work
	do i=1,nwnhe
	psgrid(i,k)=work(i)

c        if(kpr.eq.1)print *,' i psgrid==',i,psgrid(i,k)
	end do
	end do

	if(kpr.eq.1)print *,' end of reading psgrid  '

	close (unit=2)
	return
	end
	subroutine read_flux()
	include 'double.inc'
	include 'parf1'
	include 'parf2'
	include 'parf4'
	include 'parf2e'

c	implicit real *8 (a-h,o-z)
	common
     *  /ge5/kpr
	COMMON
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /eq1e/psext(nwnh),re(nre),ze(nze),dr,dz
     *  /eq3e/FLUXARRE(nwnhe,kf)
     *  /eq10e/vesarre(nwnhe,mu)
	common
     *  /ves2/ncam,rc(mu),zc(mu)
c
	common
     *	/loop1/kloop,rl(nloop),zl(nloop),psloop(nloop)
     *	/loop5e/pslgreene(nwnhe,nloop)
c
	common
     *	/probe1/kprobe,bprobe(nprobe)
     *	/probe4e/bprgreene(nwnhe,nprobe)
c
	common /fluxc8/
     *  work(nwnhe)
c
	character *200 f1,f2
c
c-----------
	open (unit=40,file='flux.fl',form='formatted')
	read (40,*)
	read (40,74)f1
	read (40,*)
	read (40,74)f2
74	format(a110)
	close (40)
c----
	open (unit=1,file=f1,form='unformatted')
	open (unit=2,file=f2,form='unformatted')
	read(1) z0,dz,r0,dr

	if(kpr.eq.1)print *,' npf nre nze nwnhe',npf,nre,nze,nwnhe
	if(kpr.eq.1)print *,' ncam  kloop kprobe ',ncam,kloop,kprobe

	do k=1,npf
	read (1) work
	do i=1,nwnhe
	fluxarre(i,k)=work(i)
	end do
	end do

	do k=1,ncam
	read (1) work
	do i=1,nwnhe
	vesarre(i,k)=work(i)
	end do

	end do
	if(kloop.gt.0)then
	do k=1,kloop
	read (2) work
	do i=1,nwnhe
	pslgreene(i,k)=work(i)
	end do

	end do
	end if

	if(kprobe.gt.0)then
	do k=1,kprobe
	read (2) work
	do i=1,nwnhe
	bprgreene(i,k)=work(i)
	end do


c        if(k.eq.1)then
c           if(kpr.eq.1)print*,'!!!!!'
c           if(kpr.eq.1)print*,(work(i),i=1,10)
c        end if


	end do
	end if

	close (unit=1)
	close (unit=2)

	if(kpr.eq.1)print *,'z0,  dz,  r0,  dr,  nz,  nr,   npf'
	if(kpr.eq.1)print *,z0,dz,r0,dr,nz,nr,npf
c
	do i=1,nre
	re(i)=r0+(i-1)*dr
	end do
	do i=1,nze
	ze(i)=z0+(i-1)*dz
	end do
	if(kpr.eq.1)print *,'z1,   zk,    r1,     rk'
	if(kpr.eq.1)print *,ze(1),ze(nze),re(1),re(nre)

	return
	end
	subroutine psgrid_z()
	include 'double.inc'
	include 'parf2'
	include 'parf2e'
	common
     *  /ge1/pi
     *  /ge5/kpr
	common
     *  /eq1/psi(nwnh),pspl(nwnh),x(NR),y(NZ),dx,dy
     *  /eq1e/psext(nwnh),re(nre),ze(nze),dr,dz
     *  /eq16/psgrid(nwnh,ngrid)
c
	PSF(Xx,hr,hz)=4.*PI/10.*Xx*(dlog(16.*Xx/SQRT(HZ**2+HR**2))
     *-0.5-0.5*(HR/HZ*DATAN(HZ/HR)+HZ/HR*DATAN(HR/HZ)))
c
	do i=1,nr
	x(i)=re(i)
	!	   print *,' i x==',i,x(i)
	end do
	do j=1,nz
	y(j)=ze(j)
	!	   print *,' j y==',j,y(j)
	end do
	dx=dr
	dy=dz
	!	print *,' dx dy=',dx,dy
	k=0
	nz1=nz-1
	nr1=nr-1

	avert=sqrt(dx**2+dy**2)

	do ig=1,nr
	do jg=1,nz,nz1
	k=k+1
	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	igreen=1
	if(i.eq.ig.and.j.eq.jg)igreen=0
	if(igreen.eq.0)fgreen=psf(x(ig),avert,avert)
	if(igreen.eq.1)fgreen=fp(x(i),x(ig),y(j),y(jg))
	psgrid(kk,k)=fgreen
	end do
	end do
	end do
	end do
c
	!	print *,'first boundary'
	do ig=1,nr,nr1
	do jg=1,nz
	k=k+1
	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	igreen=1
	if(i.eq.ig.and.j.eq.jg)igreen=0
	if(igreen.eq.0)fgreen=psf(x(ig),avert,avert)
	if(igreen.eq.1)fgreen=fp(x(i),x(ig),y(j),y(jg))
	psgrid(kk,k)=fgreen
	end do
	end do
	end do
	end do

	!	print *,'psgrid zero o kay    ngrid==',k
c
	return
	end

	subroutine write_psgrid()
	include 'double.inc'
	include 'parf2'
	include 'parf2e'
	common
     *  /ge5/kpr
	common
     *  /eq1/psi(nwnh),pspl(nwnh),x(NR),y(NZ),dx,dy
     *  /eq16/psgrid(nwnh,ngrid)
c
	common /fluxc8/
     *  work(nwnhe)
c
	character *200 f1,f2,f3
c
c-----------
	open (unit=40,file='flux.fl',form='formatted')
	read (40,*)
	read (40,74)f1
	read (40,*)
	read (40,74)f2
	read (40,*)
	read (40,74)f3
74	format(a20)
	close (40)
c----
	open (unit=2,file=f3,form='unformatted')
	do k=1,ngrid
	do i=1,nwnhe
	work(i)=psgrid(i,k)
	end do
	write (2) work
	end do
	print *,' end of writing psgrid  '
	close (unit=2)
	return
	end
	subroutine bound_psgrid()
	include 'double.inc'
	include 'parf0'
	include 'parf1'
	include 'parf2'
	include 'parf2e'
	common
     *  /ge1/pi
     *  /ge5/kpr
	common
     *  /eq1/psi(nwnh),pspl(nwnh),x(NR),y(NZ),dx,dy
     *  /eq3/FLUXARR(nwnh,kf)
     *  /c_eq8/c_xbound(ntet),c_ybound(ntet),jbound_c
     *  /eq8/jbound,xbound(ntet),ybound(ntet),alfa0
     *  /c_eq1e/c_psext(nr,nz)
     *  /fluxc8/work(nwnhe)
	common
     *  /cont13/zmag,zvel,delrmag,delzmag
     *  /cont13e/zmag0,rmag,rmag0,rvel
     *  /c_green_pf/green_pf(ntet,kf)
     *  /c_green_ves/green_ves(ntet,mu)
	common
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /eq10/vesarr(nwnh,mu)
     *  /ves2/ncam,rc(mu),zc(mu)
     *  /c_green_pl/green_pl(nwnh,ntet)
	dimension ind_bound(ntet)
c
	PSF(Xx,hr,hz)=4.*PI/10.*Xx*(dlog(16.*Xx/SQRT(HZ**2+HR**2))
     *-0.5-0.5*(HR/HZ*DATAN(HZ/HR)+HZ/HR*DATAN(HR/HZ)))
c
	dimension pdd(6)
	character *20 apr
	i_en=i_en+1
	if(i_en.eq.1)then
5000	format(4(1x,1pe14.7))
	i_wr=0
	if(i_wr.eq.1)then
	open (unit=61,file='xy_bound',
     *  form='formatted')
	write (61,*)jbound
	write (61,*)'i,ind_bound(i),xbound(i),ybound(i)'
	do i=1,jbound
	ind_bound(i)=1
	write (61,*)i,ind_bound(i),xbound(i),ybound(i)
	end do
	close (61)

	jbound_c=jbound

	do j=1,jbound_c
	c_xbound(j)=xbound(j)
	c_ybound(j)=ybound(j)
	end do


	else
	open (unit=61,file='xy_bound.dat',
     *  form='formatted')
	read (61,*)jbound_c
	read (61,*)
	do i=1,jbound_c
	read (61,*)i_i,ind_bound(i),c_xbound(i),c_ybound(i)
	!         print *,' i c_xbound(i),c_ybound(i)=',i,c_xbound(i),c_ybound(i)
	end do
	close (61)

	end if


	end if


	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i
	psext0=c_psext(i,j)
	work(kk1)=psext0
	end do
	end do

	urr=rmag
	vrr=zmag

	call boxda(work,urr,vrr,pdd,ier)

	print *,' urr vrr pdd(1)=',urr,vrr,pdd(1)

	api=1./(2.*pi)

	print *,' npf jbound_c=jbound=',npf,jbound_c,jbound

	do jj=1,npf
c
	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i
	work(kk1)=api*fluxarr(kk,jj)
	end do
	end do
c
	do j=1,jbound_c
	urr=c_xbound(j)
	vrr=c_ybound(j)

	call boxda(work,urr,vrr,pdd,ier)
	fint=pdd(1)
	green_pf(j,jj)=fint

	!     print *,' j jj green_pf=',j,jj,green_pf(j,jj)

	end do
	end do

	do jj=1,ncam
c
	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i
	work(kk1)=api*vesarr(kk,jj)
	end do
	end do
c
	do j=1,jbound_c
	urr=c_xbound(j)
	vrr=c_ybound(j)

	call boxda(work,urr,vrr,pdd,ier)
	fint=pdd(1)
	green_ves(j,jj)=fint

	!     print *,' j jj green_ves=',j,jj,green_ves(j,jj)

	end do
	end do

	avert=sqrt(dx**2+dy**2)

	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	igreen=1

	do k=1,jbound_c
	urr=c_xbound(k)
	vrr=c_ybound(k)

	dist=sqrt( (x(i)-urr)**2+(y(j)-vrr)**2 )
	if(dist.le.1.)igreen=0
	if(igreen.eq.0)fgreen=psf(urr,avert,avert)
	if(igreen.eq.1)fgreen=fp(x(i),urr,y(j),vrr)
	green_pl(kk,k)=api*fgreen

	!     print *,' kk k green_pl=',kk,k,green_pl(kk,k)

	end do  !k

	end do
	end do

	!      stop

	print *,' Greens are calculated'
	return
	end
c
