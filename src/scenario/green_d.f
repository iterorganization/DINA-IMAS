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
!      Turns of PF coils consistent with koor file!!!
     *	/v_turn/pf_turns(kf)

	common /c_ind_bound/ind_bound
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
	print *,' i c_xbound(i),c_ybound(i)=',i,c_xbound(i),c_ybound(i)
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
	call vic_turn()


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
	green_pf(j,jj)=fint*pf_turns(jj)

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

	if(kk.le.100)then
	!     print *,' kk k green_pl=',kk,k,green_pl(kk,k)
	end if

	end do  !k
	end do
	end do
	!     stop
	return
	end
c
	subroutine plas_circ()
	include 'double.inc'
c	implicit real *8 (a-h,o-z)
c
	include 'parf0'
	include 'parf1'
	include 'parf2'
	include 'parf2e'
c
	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nn),y(MM),dx,dy
     *  /eq1g/psi_g(nr,nz)
     *  /eq1e/psext(nwnh),re(nre),ze(nze),dr,dz
     *  /eq3/FLUXARR(nwnh,kf)
     *  /eq10/vesarr(nwnh,mu)
     *  /eq12/omega,pspl0(nwnh)
c
	common
     *  /ves1/psp(mu),psp0(mu),tcam(mu),tcam0(mu)
     *  /ves2/ncam,rc(mu),zc(mu)
	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /ge1/pi
     *	/ge1e/rs0,tpl
     *  /ge5/kpr
     *  /ge7/eu,rout,zout,elong
c
	common
     *	/point1/r0,z0
c
	common
     *	/bunemn/nww,nhh,drdz2,rgrid1,delr,delz
	common
     *	/fluxc3/u(nwnh),work(nwnh),sib(nwnh)
     *	/fluxc7/coef,coef1,api
	common /c_imas_curr_d/curr_d(nr,nz)
	dimension f(nwnh),f_h(nwnh)

	nww=nr-1
	nhh=nz-1
	rgrid1=x(1)
	delr=dx
	delz=dy
	drdz2=(delr/delz)**2

	n=nn
	m=mm
	n1=n-1
	m1=m-1
c
	curd=tpl/(pi*eu**2)
c_________________________________________________
	COEF=10./(4.*PI)
	api=1./(2.*pi)
	coef1=dx*dy*coef
	r0=650.
	z0=0.
	eu=50.
	if(kpr.eq.1)print *,'r0= ',r0,'  z0',z0, ' eu',eu
c  	call print3(' r0 z0 eu==',r0,z0,eu)
	tok=0.
c
	dist_min=1.e5
	DO I=1,N
	DO J=1,M
	kk=(i-1)*nz+j
	work(kk)=0.
	dist=sqrt( (x(i)-r0)**2+(y(j)-z0)**2)
	if(dist.le.dist_min )dist_min=dist
	if(dist.gt.eu )go to 9
	work(kk)=curd
	TOK=TOK+work(kk)
9	CONTINUE
	END DO
	END DO
74	format (20i2)
C
	TOK=TOK*COEF*dx*dy
C
	if(kpr.eq.1)print *,'TOK tpl dist_min= ',TOK,tpl,dist_min
c
	al1=tpl/tok
	tok=0.
	do i=1,n
	do j=1,m
	kk=(i-1)*nz+j
	work(kk)=work(kk)*al1
	f(kk)=work(kk)
	tok=tok+f(kk)
	end do
	end do
	TOK=TOK*COEF*dx*dy

	DO i=1,nr
	DO j=1,nz
	kk=(i-1)*nz+j
	curr_d(i,j)=f(kk)*coef
	end do
	end do

	tok_2=0.
	do i=1,nr
	do j=1,nz
	tok_2=tok_2+curr_d(i,j)*dx*dy
	end do
	end do
	print *,' +tpl  tok_2==',tpl,tok_2
	!      stop
C   CALCULATE BOUNDARY PSIPL
C
C
C END PLASMA BOUNDARY
c
	return
	end
	subroutine bound_pf_calc()
	include 'double.inc'
	include 'parf0'
	include 'parf1'
	include 'parf2'
	include 'parf2e'
	include 'parf5'
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
	common
     *  /ves1/psp(mu),psp0(mu),tcam(mu),tcam0(mu)
     *  /ves2/ncam,rc(mu),zc(mu)
     *  /c_green_pl/green_pl(nwnh,ntet)
c*** Turns of PF coils consistent with koor file!!!
     *	/v_turn/pf_turns(kf)
	common /c_imas_curr_d/curr_d(nr,nz)
	common /c_ind_bound/ind_bound
	dimension ind_bound(ntet),yy(ntet),pl_green(ntet)
	common /c_ind_pf/d_wght(nx)
	dimension amat(mu,kf),tok_fil(kf),cur_ref(kf)
c
	PSF(Xx,hr,hz)=4.*PI/10.*Xx*(dlog(16.*Xx/SQRT(HZ**2+HR**2))
     *-0.5-0.5*(HR/HZ*DATAN(HZ/HR)+HZ/HR*DATAN(HR/HZ)))
c
	character *20 apr
5000	format(4(1x,1pe14.7))
c
	i_en=i_en+1
	if(i_en.eq.1)then
	open (unit=61,file='pf_waits.dat',
     *  form='formatted')
	read (61,*)
	do i=1,npf
	read (61,*)d_wght(i)
	print *,' i d_wght(i)=',i,d_wght(i)
	end do
	close (61)
	end if
	do i=1,npf
	cur_ref(i)=pf(i)
	print *,' i pf=',i,pf(i)
	end do
	tokc=0.
	do jj=1,ncam
	tokc=tokc+tcam(jj)
	end do
	tok_2=0.
	do i=1,nr
	do j=1,nz
	tok_2=tok_2+curr_d(i,j)*dx*dy
	end do
	end do
	print *,' + tok_2 tokc==',tok_2,tokc
	print *,' jbound_c=',jbound_c
	k=0
	do j=1,jbound_c
	if(ind_bound(j).eq.1)then
	k=k+1
	yy(k)=0.
	!     print *,'  k yy=',k,yy(k)
	do ii=1,nr
	do jj=1,nz
	kk=(ii-1)*nz+jj
	yy(k)=yy(k)+green_pl(kk,j)*curr_d(ii,jj)*dx*dy
	end do
	end do
	!      print *,' plas k yy=',k,yy(k)
	do jj=1,ncam
	yy(k)=yy(k)+green_ves(j,jj)*tcam(jj)
	end do
	!     print *,' Ves k yy=',k,yy(k)
	do jj=1,npf
	amat(k,jj)=green_pf(j,jj)*1.e-5
	end do

	end if ! ind_bound(j)=1

	end do


	lfit=k
	!    lfit=21

	do k=1,lfit
	pl_green(k)=yy(k)*1.e-5
	print *,' plas k yy pl_green=',k,yy(k),pl_green(k)
	end do

	print *,' lfit npf=',lfit,npf

	kpr=1

	call cursol22_c(amat,mu,
     * lfit,npf,pl_green,tok_fil,cur_ref,pi,kpr)

	return
	end
	subroutine cursol22_c(aaa,mu,
     * nps,npf,pl_green,tok_fil,cur_ref,pi,kpr)

	include 'double.inc'

	dimension  aaa(mu,*),tok_fil(*),pl_green(*),cur_ref(*)

	include 'parf5'

	dimension amat(nx,nx),y(nx),x(nx),ip(nx),rrr(nx),
     *  gindk(nx,mx),gindp(nx,mx),w_wght(nx)

	dimension y1(nx),x1(nx),x2(nx)

	common /c_ind_pf/d_wght(nx)

	character *8 apr
c
c
71	format(20x,a6/,(6(1pe10.3)))


	psi_axis=-0.


	!          a(j,k)*I(k)+a(j,NEQUI+l)*Lam(l)+a(j,NEQUI+Lpre+1)*Psi_b=y(j)


	!        equation (.)*d(I_j)=0

	!          a(j,k)*I(k) ,j-number of equation


	print *,' nx==',nx

	nequi=npf
	ma1=NEQUI

	ma=ma1+1

	Lfit=nps

	print *,' NEQUI Lfit ==',NEQUI,Lfit
	print *,' nps tok_ref ==',nps,tok_ref

	s_wght=1.d-1
	!	s_wght=1.d-10

	do l=1,Lfit
	!           w_wght(l)=5.0d5
	w_wght(l)=1.0d0
	enddo

	pfmax=0.1d0
	do j=1,NEQUI
	!          d_wght(j)=1.d-1
	if(dabs(cur_ref(j)).gt.pfmax)pfmax=dabs(cur_ref(j))
	enddo


	do j=1,NEQUI
	!          d_wght(j)=1.d-6
	enddo

	!          d_wght(6)=1.d2
	!          d_wght(7)=1.d2


	do jj=1,NEQUI
	do ii=1,Lfit
	fint=aaa(ii,jj)
	Gindk(jj,ii)=fint
	enddo
	enddo


	do l=1,nps
	flux=0.d0
	do iq=1,ma1
	flux=flux+Gindk(iq,l)*cur_ref(iq)
	enddo
	flux=flux+pl_green(l)
	!        print *,' l flux cur_ref(ma)=',l,flux,cur_ref(ma)
	write(6,'(" 0 -l flux psi_axis pl_green(l) = ",i4,6(1pe14.5))')
     *  l,flux,psi_axis,pl_green(l)
	enddo


	do iq=1,ma1
	x2(iq)=cur_ref(iq)
	!         cur_ref(iq)=1.
	enddo
	!         cur_ref(6)=0.
	!         cur_ref(7)=0.

	do iq=1,ma1
	tok_fil(iq)=cur_ref(iq)
	enddo



c--
	do k=1,NEQUI
	do j=1,NEQUI
	asum=0.d0
	do l=1,Lfit
	asum=asum+Gindk(k,l)*Gindk(j,l)*w_wght(l)
	enddo
	amat(j,k)=asum
	enddo
	enddo

c---------------------

	do j=1,NEQUI
	amat(j,j)=amat(j,j)+d_wght(j)*s_wght
	enddo

	do j=1,NEQUI
	asum=0.d0
	asum1=0.d0
	do l=1,Lfit
	asum=asum+w_wght(l)*Gindk(j,l)*pl_green(l)
	asum1=asum1+w_wght(l)*Gindk(j,l)*psi_axis
	enddo
	y(j)=-asum+d_wght(j)*s_wght*tok_fil(j)
	y(j)=y(j)+asum1
	asum2=+d_wght(j)*s_wght*tok_fil(j)

	!          y(j)=asum+d_wght(j)*s_wght*cur_ref(j)
	!          y(j)=y(j)-asum1

	write(6,'(" j asum asum1 asum2 y tok_fil(j) d_wght(j)= ",i4,6(1pe14.5))')
     *   j,asum,asum1,asum2,y(j),tok_fil(j),d_wght(j)


	enddo



	!-- psi_bound

	!          a(j,NEQUI+Lpre+1)*Psi_b  ,j-number of equation

	do j=1,NEQUI
	asum=0.d0
	do l=1,Lfit
	asum=asum+w_wght(l)*Gindk(j,l)
	enddo
	amat(j,NEQUI+1)=-asum
	enddo


	do k=1,NEQUI
	asum=0.d0
	do l=1,Lfit
	asum=asum+w_wght(l)*Gindk(k,l)
	enddo
	amat(NEQUI+1,k)=asum
	enddo

	asum=0.d0
	do l=1,Lfit
	asum=asum+w_wght(l)
	enddo
	amat(NEQUI+1,NEQUI+1)=-asum
	!!!
	asum=0.d0
	do l=1,Lfit
	asum=asum+w_wght(l)*pl_green(l)
	asum=asum-w_wght(l)*psi_axis
	enddo
	y(NEQUI+1)=-asum

	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	!        call GE(NEQUI+Lpre+1,nx,Amat,Y,X,IP)
	!!!        call GE(NEQUI+Lpre,nx,Amat,Y,X,IP)

	!!!        call GE(NEQUI+1,nx,Amat,Y,X,IP)

	do k=1,NEQUI+1
	y1(k)=y(k)
	do j=1,NEQUI+1
	aaa(k,j)=amat(k,j)
	end do
	end do

	!        call GE(NEQUI,nx,amat,Y1,X1,IP)
	call GE(NEQUI+1,nx,amat,Y1,X1,IP)

	do k=1,NEQUI+1
	do j=1,NEQUI+1
	amat(k,j)=aaa(k,j)
	end do
	end do

	do l=1,NEQUI+1
	flux=0.d0
	do iq=1,NEQUI+1
	x(iq)=x1(iq)
	flux=flux+amat(l,iq)*x1(iq)
	enddo
	write(6,'(" & l flux y x= ",i4,6(1pe14.5))')
     *  l,flux,y(l),x(l)
	enddo

	cur_ref(ma)=x1(ma)




	nles=0
	!        call EVSLV1( nles,
	!     * NEQUI,amat,nx,y,x)


	do l=1,nps
	flux=0.d0
	do iq=1,ma1
	flux=flux+Gindk(iq,l)*x(iq)
	enddo
	flux=flux+pl_green(l)
	!        print *,' l flux cur_ref(ma)=',l,flux,cur_ref(ma)
	write(6,'(" l flux cur_ref(ma) pl_green(l)= ",i4,6(1pe14.5))')
     *  l,flux,cur_ref(ma),pl_green(l)
	enddo

	do l=nps+1,Lfit
	flux=0.d0
	do iq=1,ma1
	flux=flux+Gindk(iq,l)*cur_ref(iq)
	enddo
	flux=flux-pl_green(l)
	!      print *,' l flux yw =',l,flux,pl_green(l)
	enddo



	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	tok=0.d0
	tok1=0.d0
	do iq=1,ma
c	write(6,'(" iq tok_fil x ", i4,6(1pe12.5))'),
c     *  iq,tok_fil(iq),x(iq)

	tok1=tok1+cur_ref(iq)

	write(6,'(" iq cur_ref x2 x1  ", i4,6(1pe14.5))'),
     *  iq,cur_ref(iq),x2(iq),x1(iq)

	tok_fil(iq)=x(iq)
	tok=tok+tok_fil(iq)

	cur1=cur_ref(iq)

	enddo

	print *,' ma ma1 cur_ref(ma)==',ma,ma1,cur_ref(ma)

	print *,' tok1 tok cur1==',tok1,tok,cur1

	do l=1,nps
	flux=0.d0
	do iq=1,ma1
	flux=flux+Gindk(iq,l)*tok_fil(iq)
	enddo
	flux=flux+pl_green(l)
	!        print *,' l flux tok_fil(ma)=',l,flux,tok_fil(ma)
	write(6,'(" +l flux cur_ref(ma)= ",i4,6(1pe14.5))')
     *  l,flux,cur_ref(ma)
	enddo

	print *,' ma ma1 cur_ref(ma)==',ma,ma1,cur_ref(ma)


	do l=nps+1,Lfit
	flux=0.d0
	do iq=1,ma1
	flux=flux+Gindk(iq,l)*tok_fil(iq)
	enddo
	flux=flux-pl_green(l)
	!        print *,' l flux yw =',l,flux,pl_green(l)
	enddo


	!	stop

	return
	end
