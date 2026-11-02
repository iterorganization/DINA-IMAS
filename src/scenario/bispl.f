	subroutine boxd(xx,zz,pdd,ier)
		include 'double.inc'
c	implicit real *8 (a-h,o-z)
	include 'parf2'
        common
     *  /ge5/kpr
	common
     *  /eq1/psi(nr,nz),pspl(nwnh),r(nr),z(nz),dr,dz
c
	dimension vat(4,4),fmat(4,4),poly(4,4),pdd(6)
	integer nni(4),nnj(4)

c------------------------------
	real  *8 rhs(4),xp,zp,sp

	real *8 vat,fmat,poly
c-----------------------------------
	data errt/1.e-14/

	jval=(1.0+errt)*(1.0+(zz-z(1))/dz)
	ival=(1.0+errt)*(1.0+(xx-r(1))/dr)
c
	if(ival.lt.1.or.ival.ge.nr.or.jval.lt.1.or.jval.ge.nz)then
	ier=1
	if(kpr.eq.1)print *,' xx zz ier===',xx,zz,ier
	if(kpr.eq.1)print *,' x_1 x_n ===',r(1),r(nr)
	if(kpr.eq.1)print *,' y_1 y_n ===',z(1),z(nz)
	print *, "STOP boxd"
	stop
	return
	end if
	xp=(xx-r(ival))/dr
	zp=(zz-z(jval))/dz
c
c   calculate function values and function derivatives at four
c   corners of reference cell
c
	nni(1)=0
	nni(2)=0
	nni(3)=1
	nni(4)=1

	nnj(1)=0
	nnj(2)=1
	nnj(3)=0
	nnj(4)=1

	
	do ii=1,4

	i=ival+nni(ii)
	j=jval+nnj(ii)

	vat(1,ii)=psi(i,j)-psi(ival,jval)
	vat(2,ii)=0.5*(psi(i+1,j)-psi(i-1,j))
	vat(3,ii)=0.5*(psi(i,j+1)-psi(i,j-1))
	vat(4,ii)=0.25*(psi(i+1,j+1)-psi(i-1,j+1)-
     *  psi(i+1,j-1)+psi(i-1,j-1))
	end do

	sp=psi(ival,jval)

10	continue
c.....................................
c
c   determine coeficients by evaluating polynomial at
c   four corner points
c
c.........................................
c
c...point (i,j)
c
	fmat(1,1)=0.0
	fmat(2,1)=vat(2,1)
	fmat(1,2)=vat(3,1)
	fmat(2,2)=vat(4,1)
c
c...point (i,j+1)
c
	fmat(1,3)=3.*vat(1,2)-2.*fmat(1,2)-vat(3,2)
	fmat(1,4)=vat(3,2)+fmat(1,2)-2.*vat(1,2)
	fmat(2,3)=3.*vat(2,2)-3.*fmat(2,1)-vat(4,2)-2.*fmat(2,2)
	fmat(2,4)=vat(4,2)+2.*fmat(2,1)-2.*vat(2,2)+fmat(2,2)
c
c...point (i+1,j)
c
	fmat(3,1)=3.*vat(1,3)-2.*fmat(2,1)-vat(2,3)
	fmat(4,1)=vat(2,3)+fmat(2,1)-2.*vat(1,3)
	fmat(3,2)=3.*vat(3,3)-3.*fmat(1,2)-vat(4,3)-2.*fmat(2,2)
	fmat(4,2)=vat(4,3)+2.*fmat(1,2)-2.*vat(3,3)+fmat(2,2)
c
c...point (i+1,j+1):
c
	rhs(1)=vat(1,4)-vat(1,3)-vat(3,3)-
     *  (fmat(1,3)+fmat(2,3)+fmat(1,4)+fmat(2,4))
	rhs(2)=vat(2,4)-vat(2,3)-vat(4,3)-
     *  (fmat(2,3)+fmat(2,4))
	rhs(3)=vat(3,4)-vat(3,3)-
     *  2.*(fmat(1,3)+fmat(2,3))-3.*(fmat(1,4)+fmat(2,4))
	rhs(4)=vat(4,4)-vat(4,3)-
     *  2.*(fmat(2,3))-3.*(fmat(2,4))


	fmat(3,3)=9.*rhs(1)-3.*rhs(2)-3.*rhs(3)+rhs(4)
	fmat(4,3)=-6.*rhs(1)+3.*rhs(2)+2.*rhs(3)-rhs(4)
	fmat(3,4)=-6.*rhs(1)+2.*rhs(2)+3.*rhs(3)-rhs(4)
	fmat(4,4)=4.*rhs(1)-2.*rhs(2)-2.*rhs(3)+rhs(4)




c...........................................
c   evaluate function and derivatives at (xx,zz)
c............................................

	poly(1,1)=1.
	do k=2,4
	poly(1,k)=zp**(k-1)
	poly(k,1)=xp**(k-1)
	end do
	do k=2,4
	do l=2,4
	poly(k,l)=poly(k,1)*poly(1,l)
	end do
	end do
c
c
	do l=1,6
	pdd(l)=0.
	end do
c
c
	do k=1,4
	do l=1,4
	pdd(1)=pdd(1)+poly(k,l)*fmat(k,l)
	end do
	end do
	pdd(1)=pdd(1)+sp
c
c
	do k=1,3
	do l=1,4
	pdd(2)=pdd(2)+poly(k,l)*k*fmat(k+1,l)
	end do
	end do
	pdd(2)=pdd(2)/dr
c
c
	do k=1,2
	do l=1,4
	pdd(5)=pdd(5)+poly(k,l)*k*(k+1)*fmat(k+2,l)
	end do
	end do
	pdd(5)=pdd(5)/dr/dr
c
c
	do l=1,3
	do k=1,4
	pdd(3)=pdd(3)+poly(k,l)*l*fmat(k,l+1)
	end do
	end do
	pdd(3)=pdd(3)/dz
c
c
	do l=1,2
	do k=1,4
	pdd(6)=pdd(6)+poly(k,l)*l*(l+1)*fmat(k,l+2)
	end do
	end do
	pdd(6)=pdd(6)/dz/dz
c
c
	do l=1,3
	do k=1,3
	pdd(4)=pdd(4)+poly(k,l)*k*l*fmat(k+1,l+1)
	end do
	end do
	pdd(4)=pdd(4)/dr/dz
c
	return
	end

	subroutine boxd_1(xx,zz,pdd,ier)
		include 'double.inc'
c	implicit real *8 (a-h,o-z)
	include 'parf2'
        common
     *  /ge5/kpr
	common
     *  /eq1/psi(nwnh),pspl(nwnh),r(nr),z(nz),dr,dz
c
	dimension vat(4,4),fmat(4,4),poly(4,4),pdd(6)
	integer nna(4)
c------------------------------
	dimension rhs(4)

	real *8 vat,fmat,poly
c-----------------------------------
	data errt/1.e-14/
	jm=nr
	km=nz
	jval=(1.0+errt)*(1.0+(zz-z(1))/dz)
	ival=(1.0+errt)*(1.0+(xx-r(1))/dr)
ccc	jval=1+(zz-z(1))/dz
ccc	ival=1+(xx-r(1))/dr
	nval=(jval-1)*jm+ival
c
	if(ival.lt.1.or.ival.ge.jm.or.jval.lt.1.or.jval.ge.km)then
	ier=1
	if(kpr.eq.1)print *,' xx zz ier===',xx,zz,ier
	if(kpr.eq.1)print *,' x_1 x_n ===',r(1),r(nr)
	if(kpr.eq.1)print *,' y_1 y_n ===',z(1),z(nz)
	stop
	return
	end if
	xp=(xx-r(ival))/dr
	zp=(zz-z(jval))/dz
c
c   calculate function values and function derivatives at four
c   corners of reference cell
c
c.....................................
	nna(1)=0
	nna(2)=jm
	nna(3)=1
	nna(4)=jm+1

c
	do ii=1,4
	n=nval+nna(ii)
	vat(1,ii)=psi(n)-psi(nval)
	vat(2,ii)=0.5*(psi(n+1)-psi(n-1))
	vat(3,ii)=0.5*(psi(n+jm)-psi(n-jm))
	vat(4,ii)=0.25*(psi(n+jm+1)-psi(n+jm-1)-
     *  psi(n-jm+1)+psi(n-jm-1))
	end do
	sp=psi(nval)
10	continue
c.....................................
c
c   determine coeficients by evaluating polynomial at
c   four corner points
c
c.........................................
c
c...point (i,j)
c
	fmat(1,1)=0.0
	fmat(2,1)=vat(2,1)
	fmat(1,2)=vat(3,1)
	fmat(2,2)=vat(4,1)
c
c...point (i,j+1)
c
	fmat(1,3)=3.*vat(1,2)-2.*fmat(1,2)-vat(3,2)
	fmat(1,4)=vat(3,2)+fmat(1,2)-2.*vat(1,2)
	fmat(2,3)=3.*vat(2,2)-3.*fmat(2,1)-vat(4,2)-2.*fmat(2,2)
	fmat(2,4)=vat(4,2)+2.*fmat(2,1)-2.*vat(2,2)+fmat(2,2)
c
c...point (i+1,j)
c
	fmat(3,1)=3.*vat(1,3)-2.*fmat(2,1)-vat(2,3)
	fmat(4,1)=vat(2,3)+fmat(2,1)-2.*vat(1,3)
	fmat(3,2)=3.*vat(3,3)-3.*fmat(1,2)-vat(4,3)-2.*fmat(2,2)
	fmat(4,2)=vat(4,3)+2.*fmat(1,2)-2.*vat(3,3)+fmat(2,2)
c
c...point (i+1,j+1):
c
	rhs(1)=vat(1,4)-vat(1,3)-vat(3,3)-
     *  (fmat(1,3)+fmat(2,3)+fmat(1,4)+fmat(2,4))
	rhs(2)=vat(2,4)-vat(2,3)-vat(4,3)-
     *  (fmat(2,3)+fmat(2,4))
	rhs(3)=vat(3,4)-vat(3,3)-
     *  2.*(fmat(1,3)+fmat(2,3))-3.*(fmat(1,4)+fmat(2,4))
	rhs(4)=vat(4,4)-vat(4,3)-
     *  2.*(fmat(2,3))-3.*(fmat(2,4))
c...........................................
c   evaluate function and derivatives at (xx,zz)
c............................................
c	xp=(xx-xary(ival))/dr
c	zp=(zz-zary(jval))/dz
	poly(1,1)=1.
	do k=2,4
	poly(1,k)=zp**(k-1)
	poly(k,1)=xp**(k-1)
	end do
	do k=2,4
	do l=2,4
	poly(k,l)=poly(k,1)*poly(1,l)
	end do
	end do
c
c
	do l=1,6
	pdd(l)=0.
	end do
c
c
	do k=1,4
	do l=1,4
	pdd(1)=pdd(1)+poly(k,l)*fmat(k,l)
	end do
	end do
	pdd(1)=pdd(1)+sp
c
c
	do k=1,3
	do l=1,4
	pdd(2)=pdd(2)+poly(k,l)*k*fmat(k+1,l)
	end do
	end do
	pdd(2)=pdd(2)/dr
c
c
	do k=1,2
	do l=1,4
	pdd(5)=pdd(5)+poly(k,l)*k*(k+1)*fmat(k+2,l)
	end do
	end do
	pdd(5)=pdd(5)/dr/dr
c
c
	do l=1,3
	do k=1,4
	pdd(3)=pdd(3)+poly(k,l)*l*fmat(k,l+1)
	end do
	end do
	pdd(3)=pdd(3)/dz
c
c
	do l=1,2
	do k=1,4
	pdd(6)=pdd(6)+poly(k,l)*l*(l+1)*fmat(k,l+2)
	end do
	end do
	pdd(6)=pdd(6)/dz/dz
c
c
	do l=1,3
	do k=1,3
	pdd(4)=pdd(4)+poly(k,l)*k*l*fmat(k+1,l+1)
	end do
	end do
	pdd(4)=pdd(4)/dr/dz
c
	return
	end

