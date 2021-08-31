	subroutine triang(x,y,n,x_g,y_g)
	include 'double.inc'
	dimension x(*),y(*)
	dimension y2(n)

	yp1=1.1d30
	ypn=1.1d30

c ***	preparation of y2 array	
	call spline(x,y,n,yp1,ypn,y2)

c *** searching y_g-minimum of function y(x) 
	n2=n/2+1
	ax=x(1)
	cx=x(n)
	bx=x(n2)

	call golden2(x,y,y2,n,ax,bx,cx,x_g,y_g)

	return
	end

	subroutine golden2(x,y,y2,n,ax,bx,cx,x_g,y_g)
	include 'double.inc'
	parameter(r=0.61803399, c=1.-r, tol=1.d-3)
      INTEGER n
      dimension x(n),y(n),y2(n)
 
	x0=ax
	x3=cx

	if(abs(cx-bx).gt.abs(bx-ax))then
		x1=bx
		x2=bx+c*(cx-bx)
	else
		x2=bx
		x1=bx-c*(bx-ax)
	endif

	call splint(x,y,y2,n,x1,f1)
      call splint(x,y,y2,n,x2,f2)	

1     if(abs(x3-x0).gt.tol*(abs(x1)+abs(x2)))then
		if(f2.lt.f1)then
			x0=x1
			x1=x2
			x2=r*x1+c*x3
			f0=f1
			f1=f2
			call splint(x,y,y2,n,x2,f2)
		else
			x3=x2
			x2=x1
			x1=r*x2+c*x0
			f3=f2
			f2=f1
			call splint(x,y,y2,n,x1,f1)
		endif
	go to 1
	endif
	
	if(f1.lt.f2)then
		golden=f1
		xmin=x1
	else
		golden=f2
		xmin=x2
	endif

	x_g=xmin
	y_g=golden
	return
	end
										

	subroutine abc1()
        include 'double.inc'
c *** hauptprogramm zur berechnung eines echten kubischen splines ***
      dimension x(25),y(25),ys(25),hf(100)
	print *,'eingabe der zahl der wertepaare n:'
      read *,n
      open (unit=61,file='a0.dat')
      print *,'eingabe der n wertepaare xi,yi (zeilenweise):'
      do 10 i=1,n
       read (61,*) x(i),y(i)
   10 continue
	close(61)

c	n=30

c	open(unit=61,file='b.dat')

c	pi=3.1415
c	dfi=pi/(2*n)
c	do i=1,n
c	x(i)=(pi/4+dfi*(i))
c	y(i)=(pi/4+dfi*(i))**2
c	write(61,*) x(i),y(i)
c	enddo
c	close(61)

	
      call splabl(x,y,ys,n,hf,hf(n+1),hf(2*n+1),hf(3*n+1))
c *** Ausgabefile 'spline.dat' mit einer Wertetabelle der berechneten
c *** Spline-Funktion
c *** xx  | f(xx)
c *** ...
      open (unit=9,file='spline.dat')
      print *,'Werte der berechneten Funktion im 300ter raster:'
      do 20 i=1,100
        xx=x(1)+(i-1)*(x(n)-x(1))/99.
        f=splber(xx,x,y,ys,n)
        print *,'f(',x,')=',f
        write (9,*) xx,f
   20 continue
      close (unit=9)
      end

c *** interpolation mit echten splines/bestimmung der ableitungen ***
c *** benutzung von tridia: -c xi-1 + d xi -e xi+1 = b ***
      subroutine splabl(x,y,ys,n,c,d,e,b)
      include 'double.inc'
      dimension x(*),y(*),ys(*),c(*),d(*),e(*),b(*)
      do 10 i=1,n-1
        ys(i)=x(i+1)-x(i)
   10 continue
      do 20 i=2,n-1
        c(i)=-1./ys(i-1)
        d(i)=2./ys(i-1)+2./ys(i)
        e(i)=-1./ys(i)
   20 continue
      d(1)=2./ys(1)
      e(1)=-1./ys(1)
      c(n)=-1./ys(n-1)
      d(n)=2./ys(n-1)
      do 30 i=1,n-1
        ys(i)=(y(i+1)-y(i))/(ys(i)*ys(i))
   30 continue
      do 40 i=2,n-1
        b(i)=3.*(ys(i)+ys(i-1))
   40 continue
      b(1)=3.*ys(1)
      b(n)=3.*ys(n-1)
c *** bestimmung der ableitungen ys(1)...ys(n)
      call tridia(c,d,e,b,ys,1,n)
      return
      end

c *** berechnung eines kubischen splines ***
      function splber(z,x,y,ys,n)
      include 'double.inc'
      dimension x(*),y(*),ys(*)
      na=1
      nb=n
   99 i=(na+nb)/2
      if (x(i).lt.z) then
        na=i
      else
        nb=i
      endif
      if (na+1.ne.nb) goto 99
      i=na
      h=x(i+1)-x(i)
      t=(z-x(i))/h
      a0=y(i)
      a1=y(i+1)-a0
      a2=a1-h*ys(i)
      a3=h*ys(i+1)-a1
      a3=a3-a2
      splber=a0+(a1+(a2+a3*t)*(t-1))*t
      end

c *** Unterprogramm zur Loesung eines linearen Gleichungssystems
c *** mit tridiagonaler Koeffizientenmatrix
      SUBROUTINE TRIDIA(PC,PD,PE,PF,YPS,NANF,NEND)
      include 'double.inc'
C *** EINGANGSPARAMETER
C *** NANF, NEND - ANFANGS-BZW. ENDINDEX
C *** PC, PD, PE - VEKTOREN DER DIMENSION L DER TRIDIAG. MATR.
C *** PF         - VEKTOR DER RECHTEN SEITEN
C *** YPS        - ERGEBNISVEKTOR
C *** ALPHA UND BETA SIND HILFSFELDER
      DIMENSION PC(1),PD(1),PE(1),PF(1),YPS(1),ALPHA(50),BETA(50)
      NENDM=NEND-2
      D=PD(NANF)
      C=PC(NANF+1)
      F=PF(NANF)
      V=PF(NANF+1)
      DO 10 N=NANF,NENDM
      N1=N-NANF+1
      ALPHA(N1+1)=PE(N)/D
      BETA(N1+1)=F/D
      D=PD(N+1)-C*ALPHA(N1+1)
      F=V+C*BETA(N1+1)
      C=PC(N+2)
      V=PF(N+2)
   10 CONTINUE
      N=NENDM+1
      N1=N-NANF+1
      ALPHA(N1+1)=PE(N)/D
      BETA(N1+1)=F/D
      D=PD(N+1)-C*ALPHA(N1+1)
      F=V+C*BETA(N1+1)
      NEND1=NEND-NANF+1
      KN=NEND
      YPS(NEND)=F/D
   70 KM=KN-1
      YPS(KM)=ALPHA(N1+1)*YPS(KN)+BETA(N1+1)
      KN=KN-1
      N=N-1
      N1=N-NANF+1
      IF(N.GE.NANF) GOTO 70
      RETURN
      END

	SUBROUTINE splie2(x1a,x2a,ya,m,n,y2a)
	    include 'double.inc'
      INTEGER m,n,NN
      dimension x1a(m),x2a(n),y2a(m,n),ya(m,n)
      PARAMETER (NN=100)
CU    USES spline
      INTEGER j,k
      dimension y2tmp(NN),ytmp(NN)
      do 13 j=1,m
        do 11 k=1,n
          ytmp(k)=ya(j,k)
11      continue
        call spline(x2a,ytmp,n,1.d30,1.d30,y2tmp)
        do 12 k=1,n
          y2a(j,k)=y2tmp(k)
12      continue
13    continue
      return
      END
C  (C) Copr. 1986-92 Numerical Recipes Software 3#1y.zu2.

	SUBROUTINE splin2(x1a,x2a,ya,y2a,m,n,x1,x2,y)
	    include 'double.inc'
      INTEGER m,n,NN
      dimension x1a(m),x2a(n),y2a(m,n),ya(m,n)
      PARAMETER (NN=100)
CU    USES spline,splint
      INTEGER j,k
      dimension y2tmp(NN),ytmp(NN),yytmp(NN)
      do 12 j=1,m
        do 11 k=1,n
          ytmp(k)=ya(j,k)
          y2tmp(k)=y2a(j,k)
11      continue
        call splint(x2a,ytmp,y2tmp,n,x2,yytmp(j))
12    continue
      call spline(x1a,yytmp,m,1.d30,1.d30,y2tmp)
      call splint(x1a,yytmp,y2tmp,m,x1,y)
      return
      END
C  (C) Copr. 1986-92 Numerical Recipes Software 3#1y.zu2.
C
C     Subroutine spline is the Numerical Recipes cubic spline
C       routine. It computes the second derivatives at each node
C       for the data points x and y, real vectors of length n.
C       yp1 and ypn are the endpoint slopes of the spline. If
C       they are set to 1.0e30 or greater then a natural spline
C       is formed.

	SUBROUTINE spline(x,y,n,yp1,ypn,y2)
	    include 'double.inc'
      INTEGER n,NMAX
      dimension x(n),y(n),y2(n)
      PARAMETER (NMAX=500)
      INTEGER i,k
      dimension u(NMAX)
      if (yp1.gt..99d30) then
        y2(1)=0.
        u(1)=0.
      else
        y2(1)=-0.5
        u(1)=(3./(x(2)-x(1)))*((y(2)-y(1))/(x(2)-x(1))-yp1)
      endif
      do 11 i=2,n-1
        sig=(x(i)-x(i-1))/(x(i+1)-x(i-1))
        p=sig*y2(i-1)+2.
        y2(i)=(sig-1.)/p
        u(i)=(6.*((y(i+1)-y(i))/(x(i+
     *1)-x(i))-(y(i)-y(i-1))/(x(i)-x(i-1)))/(x(i+1)-x(i-1))-sig*
     *u(i-1))/p
11    continue
      if (ypn.gt..99d30) then
        qn=0.
        un=0.
      else
        qn=0.5
        un=(3./(x(n)-x(n-1)))*(ypn-(y(n)-y(n-1))/(x(n)-x(n-1)))
      endif
      y2(n)=(un-qn*u(n-1))/(qn*y2(n-1)+1.)
      do 12 k=n-1,1,-1
        y2(k)=y2(k)*y2(k+1)+u(k)
12    continue
      return
      END
C  (C) Copr. 1986-92 Numerical Recipes Software 3#1y.zu2.

	SUBROUTINE splint(xa,ya,y2a,n,x,y)
	    include 'double.inc'
      INTEGER n
      dimension xa(n),y2a(n),ya(n)
      INTEGER k,khi,klo
   
      klo=1
      khi=n
1     if (khi-klo.gt.1) then
        k=(khi+klo)/2
        if(xa(k).gt.x)then
          khi=k
        else
          klo=k
        endif
      goto 1
      endif
      h=xa(khi)-xa(klo)
      if(h.eq.0.)then
	 y=ya(n/2+1)
	else
       a=(xa(khi)-x)/h
       b=(x-xa(klo))/h
       y=a*ya(klo)+b*ya(khi)+((a**3-a)*y2a(klo)+(b**3-b)*y2a(khi))*
     *	(h**2)/6.
	endif

      return
      END
C  (C) Copr. 1986-92 Numerical Recipes Software 3#1y.zu2.


