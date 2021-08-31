      subroutine ATSV(IZ,IS,II,MI,TE10,SV10,DS10)
c................Author: V.E.Zhogolev (20.11.2006)
          implicit none
      integer IZ,IS,II,MI,kpr

	common /ge5/kpr

            real TE10
      dimension SV10(MI),DS10(MI)
      real SV10,DS10
c Purpose: 
c     To calculate by spline algoritm 1 of 3 set rate coefficient (...)
c     of ionization, recombination or energy losses 
c     for the impurity element in the plasma.
c Output:
c     SV10,DS10 
c Input: 
c     TE10=alog10(Te[eV]);
c
c     IZ - the atomic number of impurity element (for Argon  IZ=18)
c     Charge state number of ions 'k' is varied as k=II+i-1, (i=1,MI).
c
c     IS -  integer parameter specifying the set coefficient: 
c  if IS=0 then SV10(i) - corresponds ionizations energy [eV], 
c               DSV10 is not changed!
c
c     If IS>0 
c               DS10(i)=d_SV10(i)/d_TE10;
c
c  if IS=1 then 10**SV10 corresponds to 
c     rate coefficient of ionization     [10**(-14) m**3/s]
c  if IS=2 then 10**SV10 corresponds to 
c     rate coefficient of recombination  [10**(-14) m**3/s],
c  if IS=3 then 10**SV10  corresponds to  
c           coefficient of energy losses [10**(-14) m**3 eV/s].
c
c ADDITIONAL DATA
c     Necessary data files sp* should be located 
c     in the ./IMP or current directory.
c
c ENTRY:SPNUL 
c     To define the caunter of read new set impurity elements  
c     to initial state.
c....................................................................
c           Maximum number of simulteneucly used impurity elements is 10,
c     jm - maximum total number of atom/ion facility.
        integer jm,jms
            parameter (jm=200)
            parameter (jms=jm*108)
      real SX(36),SY(jms),EIN(jm)
      integer LZN(4,10)
        save LZN,SX,SY,EIN
      integer NZ,LM,i,j   ,i20,l,m,n,k
         save NZ,LM,i,j
      data NZ,LM/0,18/
      data LZN/2*0,2*1,36*0/
      data i,j/1,2/
      if(NZ.eq.0) go to 3
    4 continue  
      do 1 m=1,NZ
      if(LZN(1,m).eq.IZ) go to 2
    1 continue  
      go to 3
    2 continue  
            if(IS.eq.0) then
      do 12 i20=1,MI
      SV10(i20)=EIN( LZN(4,m)-1+II+i20 )
   12 continue  
            return
            endif
      l=6*LM
      n=(LZN(3,m)-1)*LM+1
      k=((LZN(4,m)-1+II)*6+IS+IS-2)*LM+1
      call S_INDEIJ(i,j,1,LZN(2,m),LZN(2,m),TE10,SX(n))
      call S_INTER3(l,MI,i,j,TE10,SX(n),SY(k),SY(k+LM),SV10,DS10)
      return
    3 continue
      m=NZ+1
      if(m.eq.1) go to 5
      LZN(3,m)=LZN(3,NZ)+1
      LZN(4,m)=LZN(4,NZ)+LZN(1,NZ)+1  
    5 k=((LZN(4,m)-1)*6)*LM+1
      n=(LZN(3,m)-1)*LM+1
      i20=0
      call SPREAD(IZ,LM,SY(k),SX(n),EIN(LZN(4,m)),i20)
      if(i20.eq.0) go to 6
      if(i20.lt.0) go to 8
      if(i20.gt.LM) go to 7
      LZN(1,m)=IZ  
      LZN(2,m)=i20  
      if(m.eq.1) go to 9
      if(i20.ne.LZN(2,NZ)) go to 9
      k=(LZN(3,NZ)-1)*LM+1
      do 11 i20=1,LZN(2,NZ)
      if(SX(n-1+i20).ne.SX(k-1+i20)) go to 9
   11 continue
      LZN(3,m)=LZN(3,NZ)
    9 NZ=m
      go to 4
    7 LM=i20
      NZ=0
      go to 3  
    6 if(kpr.eq.1)
     *  write(*,*) 'There is no data file for element namber',IZ
      stop
    8 if(kpr.eq.1)
     *  write(*,*) 'Data file is not appropriate for element namber',IZ
      stop        
            entry SPNUL
      NZ=0
      LZN(3,1)=1
      LZN(4,1)=1  
      LM=18
            return
      end
      
	subroutine SPREAD(NF,LM,SPSV,TEM,EI,i20)
      implicit none      
      integer NF,LM,i20   ,I,J,K,IY
      real EI(*),TEM(*),SPSV(LM,6,1)
                  character*8 NFILE
      if(NF.ge.10) WRITE(NFILE,'(A2,I2,A4)')'sp', NF,'.dat'
      if(NF.lt.10)write(NFILE,'(A2,I1,A4)')'sp', NF,'.dat'
      OPEN(33,FILE='imp/'//NFILE,status='old',err=706)
      go to 701
  706 OPEN(33,FILE=NFILE,status='old',err=704)
  701 READ(33,710,err=704) IY,i20 
  710 format(1x,2I6)
      if(NF.ne.IY-1) go to 705 
      if(i20.gt.LM)  go to 703 
      READ(33,720,err=705) (EI(I),I=1,IY) 
  720 format(8x,5E12.5) 
      READ(33,720,err=705) (TEM(I),I=1,i20) 
      DO 702 I=1,IY
      DO 702 K=1,6
      READ(33,720,err=705) (SPSV(J,K,I),J=1,i20) 
  702 CONTINUE
      go to 703
  704 i20=0
  705 i20=-i20
  703 CLOSE(33)
      return
      end
C S_INTER3
            SUBROUTINE S_INTER3(NI,N,I,J,X,XX,Y,DY,W,DW)
          implicit none
      integer NI,N,I,J
      DIMENSION XX(NI),Y(NI,N),DY(NI,N),W(N),DW(N)
      real X, XX,Y,DY,W,DW
      integer L,IJ     
            real DX,DXO,ODX,U,A,B,C,D
      GO TO 5
            ENTRY S_INTCH3(NI,N,I,J,X,XX,Y,DY,W,DW)
      CALL S_INDEIJ(I,J,1,NI,NI,X,XX)
      GO TO 6
    5 CONTINUE
      IF(I.LT.1) I=1
      IF(J.LT.1) J=1
      IF(I.GT.NI) I=NI
      IF(J.GT.NI) J=NI
    6 CONTINUE
      IJ=I
      IF(I.EQ.J) GO TO 11
      DX=X-XX(I)
      IF(DX.EQ.0.) GO TO 11
      DXO=XX(J)-XX(I)
      IF(DXO.EQ.0.) GO TO 13
      IF(DXO.EQ.DX) GO TO 12
      ODX=1./DXO
      U=ODX*DX-0.5
      DO 1 L=1,N
      A=0.5*(Y(J,L)+Y(I,L))
      B=Y(J,L)-Y(I,L)
      C=0.5*(DY(J,L)-DY(I,L))*DXO
      D=DXO*(DY(J,L)+DY(I,L))-B-B
      A=A-C*0.25
      B=B-0.25*D
      IF(U.EQ.0.) GO TO 2
      DW(L)=ODX*(B+U*(C+C+U*D*3.))
      W(L)=A+U*(B+U*(C+U*D))
      GO TO 1
    2 DW(L)=ODX*B
      W(L)=A
    1 CONTINUE
      RETURN
   13 DO 3 L=1,N
      DW(L)=0.5*(DY(J,L)+DY(I,L))
    3 W(L)=0.5*(Y(J,L)+Y(I,L))
      RETURN
   12 IJ=J
   11 DO 4 L=1,N
      DW(L)=DY(IJ,L)
    4 W(L)=Y(IJ,L)
      RETURN
      END
            SUBROUTINE S_INDEIJ(I,J,L1,L2,L,X,XX)
        implicit none      
      integer I,J,L1,L2,L
      DIMENSION XX(L)
      real X, XX
            integer J1,I1
      IF(L1.GT.L2) RETURN
      IF(L1.LT.1) RETURN
      IF(L2.GT.L) RETURN
      IF(I.LE.J) GO TO 9
      J1=J
      J=I
      I=J1
    9 IF(I.LT.L1) I=L1
      IF(J.LT.I) J=I
      IF(J.GT.L2) J=L2
      IF(I.GT.J) I=J
      IF(X-XX(J)) 8,7,6
    7 I=J
      IF(J.EQ.L2) RETURN 
      J=J+1
      RETURN
    6 I=J
      IF(J.EQ.L2) RETURN 
      J1=J+1
      DO 5 J=J1,L2
      IF(XX(J).GT.X) RETURN
    5 I=J
      J=L2
      RETURN
    8 IF(X-XX(I)) 18,17,16
   17 J=I+1
      RETURN
   16 J1=J-1
      IF(I.EQ.J1) RETURN
      I1=I+1
      DO 15 J=I1,J1
      IF(XX(J).GT.X) RETURN
   15 I=J
      RETURN
   18 IF(X.GE.XX(L1)) GO TO 14
      I=L1
      J=L1
      RETURN
   14 J=I
      I=I-1
      IF(X-XX(I)) 19,17,16
   19 J1=I
      I1=L1+1
      I=L1
      DO 21 J=I1,J1
      IF(XX(J).GT.X) RETURN
   21 I=J
      RETURN
      END
c-------------------------------------------
            subroutine ZRAD_old(nz,k,i1,Te, Xz)
c.........Author: V.E.Zhogolev (20.11.2006)

          implicit none
      integer Nz,k,i1 
      dimension Te(i1),Xz(i1)
      real  Te,Xz 
c Purpose: 
c     To calculate the radial profile one of three effective 
c     characteristics for the impurity element in coronal limit use ATSV. 
c
c Output:
c     Xz(*) - array (profile) of an effective characteristics 
c Input: 
c     Te(*) - array (profile) of the electron temperatures [keV];
c
c     nz - the atomic number of impurity element (for Argon  nz=18)
c     i1 - dimension of the profile arrays;
c
c     k -  integer parameter which specifies effective characteristic: 
c  if k=1 then Xz  corresponds to  
c           coefficient of energy losses [10**-38 MW*m**3],
c  if k=2 then Xz corresponds to averaged charge <Z**1>,
c  if k=3 then Xz corresponds to averaged charge <Z**2>.
c
c ADDITIONAL DATA
c     Necessary data files sp* should be located 
c     in the ./IMP or current directory.
c
c Use subroutine AReff
c
      real*8 Z1,Z2,EE,Si,Sr,Rad
      real*4 T
      integer i
      integer Kz
      dimension Kz(1), Z1(1), Z2(1), EE(1), Si(1), Sr(1), Rad(1)

      Kz(1) = nz+1
            do 1 i=1,i1
      T=Te(i)
      call AReffm(nz,T,1,Kz,Z1,Z2,EE,Si,Sr,Rad,0.,0.,T)
      if(k.eq.1)  Xz(i)=0.16*Rad(1)
      if(k.eq.2)  Xz(i)=Z1(1)
      if(k.eq.3)  Xz(i)=Z2(1)
    1 continue  
            return 
      end
         subroutine AReffm(Nz,Te,Nk,Kz,Z1,Z2,EE,Si,Sr,Rad ,RAJ,CDe,Ti)
c................Author: V.E.Zhogolev (22.02.2007)
        implicit none      
      integer Nz,Nk, Kz(Nk) 
      real Te ,RAJ,CDe,Ti
      real*8 Z1(Nk),Z2(Nk),EE(Nk),Si(Nk),Sr(Nk),Rad(Nk)
c
c Purpose: 
c     To calculate set of effective characteristics 
c     of ions groups for reduced impurity model. 
c Input: 
c     Nz - the atomic number of impurity element (for Argon  Nz=18)
c     Te - electron temperature [eV];
c     Nk - total number of groups of ions;
c     Kz(k) - is array of highest k-ion in the group + 1,
c            k=1,Nk 
c Output:
c     Z1(k),Z2(k) - are averaged charges <Z**1> and <Z**2> ; 
c     EE(k) - average ionization potential [eV];
c     Si(k),Sr(k) - effective frequencies of ionization 
c     and recombination at electron density 10**8 cm**(-3), [1/s]; 
c     Rad(k) - effective coefficient of energy losses 
c           [10**(-8) cm**3 eV/s].
c 
c Use subroutine ATSV
c
c ADDITIONAL DATA
c     Necessary data files sp* should be located 
c     in the ./IMP or current directory.
c
c           ms>max(Nz)
      integer ms
      parameter (ms=75)
      real Ef(ms),Sif(ms),Srf(ms),Radf(ms),Ds(ms)
      real*8 C,Y(ms),YY(ms)
      real  ZSVCX, T10
      integer IY, k,i,i1
	real *8 pr_i,pr_yy,pr_rad,pr_radf 
      save IY
      data IY/0/      
            if(IY.eq.0) then
c  call SPNUL (the entry of ATSV for new it initialithaton)
c      call SPNUL
      IY=1
            endif
      IY=Nz+1
      T10=1000.*TE
      T10=alog10(T10)
      call ATSV(Nz,0,0,IY,T10,  Ef,Ds)
      call ATSV(Nz,2,0,IY,T10, Srf,Ds)
      call ATSV(Nz,1,0,IY,T10, Sif,Ds)
         if(RAJ.ne.0.) call ATSV(Nz,1,0,IY,5., Radf,Ds)
            do i=1,Nz
      Sif(i)=10.d0**Sif(i)
         if(RAJ.ne.0.) 
     # Sif(i)=Sif(i) + abs(RAJ)/480.*10.d0**( Radf(i) + Ds(i) )
      Srf(i+1)=10.d0**Srf(i+1)
c                  if(Ef(i).ge. 13.6) then
         if(CDe.gt.0.) 
     # Srf(i+1)=Srf(i+1)+1.e-5*CDe*ZSVCX(float(i),Ti,2.,2.*Nz)
c                  endif
            enddo
      call ATSV(Nz,3,0,IY,T10,Radf,Ds)
!            do k=1,Nk
            do k=1,1
        Y(k)=0.
       Z1(k)=0.
       Z2(k)=0.
       EE(k)=0.
      Rad(k)=0.
  !          print *,' k z1 z2==',k,z1(k),z2(k)
            enddo
      C=1.d0
      YY(1) = C
            do i=2,IY
      YY(i) = YY(i-1)*Sif(i-1)/Srf(i)
      C = C + YY(i)
            enddo
            do i=1,IY
      YY(i) = YY(i)/C
      DS(i) = YY(i)
            enddo
      k=1
      i1=0
      Sr(1)=0.
            do i=1,IY
            
!            print *,' i k==',i,k
            
       Y(k) =  Y(k) + YY(i)
      Z1(k) = Z1(k) + YY(i)*i1
      Z2(k) = Z2(k) + YY(i)*i1*i1
      EE(k) = EE(k) + YY(i)*Ef(i)
      Rad(k)= Rad(k)+ YY(i)*10.d0**Radf(i)

	pr_i=i
	pr_yy=yy(i)
	pr_rad=rad(k)
      pr_radf=10.d0**Radf(i)

c	call print4('i yy rad radf==',pr_i,pr_yy,pr_rad,
c     *  pr_radf)

      i1=i
                  if(i.eq.Kz(k)) then
      Z1(k) = Z1(k)/Y(k)
      Z2(k) = Z2(k)/Y(k)
      EE(k) = EE(k)/Y(k)
      Rad(k)=Rad(k)/Y(k)
      Si(k) =Sif(i)*YY(i)/Y(k)
      Sr(k) = Sr(k)/Y(k)
      if(k.ne.Nk) Sr(k+1) =Srf(i+1)*YY(i+1)
      k=k+1 
                 endif
            enddo
      Sr(Nk) = Sr(Nk)/Y(Nk)
      Si(Nk) =0.
            return
      end
c------------------------------------------
           subroutine POST(nz,k,i1,Te,Xz)
          implicit none
      integer nz,k,i1
      dimension Te(i1),Xz(i1)
      real  TE,Xz 
c All formal arguments are the same as for subroutine ZRAD !
c
c Purpose: 
c     To calculate the radial profile one of three effective
c characteristics for the impurity element 
c according to D.E.POST approximations. 
c
c Output:
c     Xz(*) - array (profile) of an effective characteristic 
c Input: 
c     Te(*) - array (profile) of the electron temperature [keV];
c     i1 - dimension of the profile arrays;
c     nz - the atomic number of impurity element (for Argon  nz=18)
c
c     k -  integer parameter specifying effective characteristic: 
c  if k=1 then Xs  corresponds to  
c           coefficient of energy losses [10**-38 MW*m**3],
c  if k=2 then Xz corresponds to averaged charge <Z**1>,
c  if k=3 then Xz corresponds to averaged charge <Z**2>.
c
c ADDITIONAL DATA
c     Necessary data files sp* should be located 
c     in the ./IMP or current directory.
c
            CHARACTER*16 NFILE
      dimension TB(6,10),ABC(6,5,3,10), ATAB(90,10)
      real TB,ABC, ATAB
	common /ge5/kpr
	integer kpr
            equivalence (ABC,ATAB)
      save TB,ABC
      real T
            integer*2 nz0(10),j1(10),k1(10), m,m0 ,i,j,l
      save m,m0, nz0,j1,k1
      data m,m0, nz0,j1,k1/1,0, 30*0/
            if(nz .le. 1) go to 8
      if(nz .eq. nz0(m)) go to 4
      i=0
            do j=1,10
      if(nz0(j) .eq. nz) i=j
            enddo
            if(i .ne. 0) then
      m=i
      go to 4
            endif
      m0=m0+1
      if(m0 .gt. 10) m0=1
      m=m0
      if(nz.ge.10)write(NFILE,'(I2,A7)') nz,'abc.dat'
      if(nz.lt.10)write(NFILE,'(I1,A7)') nz,'abc.dat'
  707 OPEN(33,FILE='imp/'//NFILE,status='old',err=706)
      go to 701
  706 OPEN(33,FILE=NFILE,status='old',err=8)
  701 READ(33,10,err=8) j1(m),k1(m)
   10 format(2i4)     
      READ(33,20,err=8)  ( TB(j+1,m), j=0,j1(m) )
   20 format(8e10.2)     
      READ(33,100,err=8) ( ATAB(j,m), j=1,90 )
  100 format(6e13.6)     
      close(33)
      nz0(m)=nz
    4 continue
      if( k.le.0 .or. k.gt.k1(m) ) stop'sub.Post:k>k1'
      do 1 i=1,i1
            do j=1,j1(m)
      if(Te(i) .lt. TB(j+1,m)) go to 2
            enddo
    2 continue
      if(j.gt.j1(m)) j=j1(m)
        T=Te(i)
            if(T .lt. TB(1,m) )      T=TB(1,m)
            if(T .gt. TB(j1(m)+1,m)) T=TB(j1(m)+1,m)
      T=alog10(T)
      Xz(i) = ABC(6  ,j,k,m)
      do 3 l=1,5
    3 Xz(i) = ABC(6-l,j,k,m) + Xz(i)*T
      if(k.eq.1) Xz(i)=10.**(Xz(i)+19.)
      if(k.eq.2 .and. Xz(i).gt.nz) Xz(i)=nz
      if(k.eq.3 .and. Xz(i).gt.nz*nz) Xz(i)=nz*nz
    1 continue
      return
    8 if(kpr.eq.1)write(*,*) 'sub.Post: file ',NFILE,' is miss or fall'  
      stop
            end
c__________________________________________________________
            function ZSVCX(q,Ti,AM1,AM2)
C                (Zhogolev V. 30.03.2005)
          implicit none
      real q,Ti,AM1,AM2, ZSVCX
C Input:
C     AM1,AM2 - atomic mass of ion Impurity and Hydrogen isotope  
C          Ti - ion temperature, [keV] 
C      abs(q) - charge state of ion impurity 
c Output:
C                        ZSVCX = 0               (if q=0) 
C                 ZSVCX = SVCX [10#-19m#3/s]     (if q>0) 
C        ZSVCX = d_alog10(SVCX)/d_alog10(Ti)     (if q<0) 
C  References:
C     CROSS SECTIONS FOR TRANSFER COLLISIONS
C              INVOLVING HYDROGEN ATOMS
C                  Y.Kaneko, et.al
C             (IPPJ-AM-15, October,1980)
c
c  The CX cross section was Maxvel averaged and 
c    then approximated  in 0.001 < Ti[kev] < 1000 diapason
c                   by V.Zhogolev (03.2005)
      real y
            ZSVCX=0.
                  if(q .eq. 0.) return
      y=alog10( (Ti/AM1+Ti/AM2) * abs(q)**(-0.464) )
            if(q .gt. 0.) then
      ZSVCX=10.**( 5.51802+y*(0.43210+y*(-0.04889 + y *(-0.09448 +  y*
     * (-0.05491  + y*(-0.0013 + y *(0.00627 + y *0.0012)))))) )  
            ZSVCX=ZSVCX*q**(1.302)
            else
      ZSVCX=                  0.43210+y*(-0.04889*2.+y*(-0.09448*3.+y*
     * (-0.05491*4.+y*(-0.0013*5.+y*(0.00627*6.+y*0.0012*7.))))) 
            endif
      end
c

            subroutine ZRAD_test(nz,k,i1,Te, Xz)
c.........Author: V.E.Zhogolev (20.11.2006)

          implicit none
      integer Nz,k,i1 
      dimension Te(i1),Xz(i1)
      real  Te,Xz 
c Purpose: 
c     To calculate the radial profile one of three effective 
c     characteristics for the impurity element in coronal limit use ATSV. 
c
c Output:
c     Xz(*) - array (profile) of an effective characteristics 
c Input: 
c     Te(*) - array (profile) of the electron temperatures [keV];
c
c     nz - the atomic number of impurity element (for Argon  nz=18)
c     i1 - dimension of the profile arrays;
c
c     k -  integer parameter which specifies effective characteristic: 
c  if k=1 then Xz  corresponds to  
c           coefficient of energy losses [10**-38 MW*m**3],
c  if k=2 then Xz corresponds to averaged charge <Z**1>,
c  if k=3 then Xz corresponds to averaged charge <Z**2>.
c
c ADDITIONAL DATA
c     Necessary data files sp* should be located 
c     in the ./IMP or current directory.
c
c Use subroutine AReff
c
      real*8 Z1,Z2,EE,Si,Sr,Rad,
     * tay_lo,n0_xx,n_e_xx,tay_lo_xx,tn_xx,alf_n_xx
     
      real*4 T,tn
      
      real RAJ,CDe
      
      integer i,Kz
      dimension Kz(1), Z1(1), Z2(1), EE(1), Si(1), Sr(1), Rad(1)

      Kz(1) = nz+1

      RAJ=0.
      
      call get_param_test(n0_xx,n_e_xx,tay_lo_xx,tn_xx,alf_n_xx)
      
        print *,' n_e_xx n0_xx==',n_e_xx,n0_xx
        print *,' tay_lo_xx alf_n_xx==',tay_lo_xx,alf_n_xx

      CDe=n0_xx/n_e_xx*alf_n_xx
!      CDe=n0_xx

      tay_lo=tay_lo_xx*n_e_xx
      
      tn=tn_xx*1.e-3
      
      print *,'CDe tay_lo tn=',CDe,tay_lo,tn 
      
            do 1 i=1,i1
      T=Te(i)
      call AReffm_t(nz,T,1,Kz,Z1,Z2,EE,Si,Sr,Rad,RAJ,CDe,tn,tay_lo)
      if(k.eq.1)  Xz(i)=0.16*Rad(1)
      if(k.eq.2)  Xz(i)=Z1(1)
      if(k.eq.3)  Xz(i)=Z2(1)
    1 continue  
            return 
      end
         subroutine AReffm_t(Nz,Te,Nk,Kz,Z1,Z2,EE,Si,Sr,Rad ,
     *  RAJ,CDe,Ti,tay_lo)
c................Author: V.E.Zhogolev (22.02.2007)
        implicit none      
      integer Nz,Nk, Kz(Nk) 
      real Te ,RAJ,CDe,Ti
      real*8 Z1(Nk),Z2(Nk),EE(Nk),Si(Nk),Sr(Nk),Rad(Nk)
c
c Purpose: 
c     To calculate set of effective characteristics 
c     of ions groups for reduced impurity model. 
c Input: 
c     Nz - the atomic number of impurity element (for Argon  Nz=18)
c     Te - electron temperature [eV];
c     Nk - total number of groups of ions;
c     Kz(k) - is array of highest k-ion in the group + 1,
c            k=1,Nk 
c Output:
c     Z1(k),Z2(k) - are averaged charges <Z**1> and <Z**2> ; 
c     EE(k) - average ionization potential [eV];
c     Si(k),Sr(k) - effective frequencies of ionization 
c     and recombination at electron density 10**8 cm**(-3), [1/s]; 
c     Rad(k) - effective coefficient of energy losses 
c           [10**(-8) cm**3 eV/s].
c 
c Use subroutine ATSV
c
c ADDITIONAL DATA
c     Necessary data files sp* should be located 
c     in the ./IMP or current directory.
c
c           ms>max(Nz)
      integer ms
      parameter (ms=75)
      real Ef(ms),Sif(ms),Srf(ms),Radf(ms),Ds(ms)
      real*8 C,Y(ms),YY(ms)
      real  ZSVCX, T10
      integer IY, k,i,i1,kpr3
	real *8 pr_i,pr_yy,pr_rad,pr_radf
	
	real *8 tay_lo,coef
	 
      save IY
      data IY/0/      
            if(IY.eq.0) then
c  call SPNUL (the entry of ATSV for new it initialithaton)
c      call SPNUL
      IY=1
            endif
      IY=Nz+1
      T10=1000.*TE
      T10=alog10(T10)
      call ATSV(Nz,0,0,IY,T10,  Ef,Ds)
      call ATSV(Nz,2,0,IY,T10, Srf,Ds)
      call ATSV(Nz,1,0,IY,T10, Sif,Ds)
         if(RAJ.ne.0.) call ATSV(Nz,1,0,IY,5., Radf,Ds)
            do i=1,Nz
      Sif(i)=10.d0**Sif(i)
         if(RAJ.ne.0.) 
     # Sif(i)=Sif(i) + abs(RAJ)/480.*10.d0**( Radf(i) + Ds(i) )
      Srf(i+1)=10.d0**Srf(i+1)

!        print *,' i Ef(i) ZSVCX(=',i,Ef(i),ZSVCX(float(i),Ti,2.,2.*Nz)

                  if(Ef(i).ge. 13.6) then
         if(CDe.gt.0.) 
     # Srf(i+1)=Srf(i+1)+1.e-5*CDe*ZSVCX(float(i),Ti,2.,2.*Nz)
!     # Srf(i+1)=Srf(i+1)+1.e-5*CDe*ZSVCX(float(i+1),Ti,2.,2.*Nz)
        
!!!        print *,' i ZSVCX(=',i,ZSVCX(float(i),Ti,2.,2.*Nz)
        
!      Scx(j,k) = 1.e-5*ZSVCX( float(k1),TI,AMz,AMd)

                  endif
            enddo
      call ATSV(Nz,3,0,IY,T10,Radf,Ds)
!            do k=1,Nk
            do k=1,1
        Y(k)=0.
       Z1(k)=0.
       Z2(k)=0.
       EE(k)=0.
      Rad(k)=0.
  !          print *,' k z1 z2==',k,z1(k),z2(k)
            enddo
      C=1.d0
      YY(1) = C
            do i=2,IY
            coef=1.
            if(i.eq.2)coef=1.
      YY(i) = YY(i-1)*(Sif(i-1))/(Srf(i)+coef*1./tay_lo)
      C = C + YY(i)
            enddo
            do i=1,IY
      YY(i) = YY(i)/C
      DS(i) = YY(i)
            enddo
      k=1
      i1=0
      Sr(1)=0.
            do i=1,IY
            
!            print *,' i k==',i,k
            
       Y(k) =  Y(k) + YY(i)
      Z1(k) = Z1(k) + YY(i)*i1
      Z2(k) = Z2(k) + YY(i)*i1*i1
      EE(k) = EE(k) + YY(i)*Ef(i)
      Rad(k)= Rad(k)+ YY(i)*10.d0**Radf(i)

	pr_i=i
	pr_yy=yy(i)
	pr_rad=rad(k)
      pr_radf=10.d0**Radf(i)

c	call print4('i yy rad radf==',pr_i,pr_yy,pr_rad,
c     *  pr_radf)

      kpr3=0
      if(kpr3.eq.1)then
      	write(6,'(" i yy rad z ",
     *  i4,6(1pe11.4))'),
     *  i,yy(i),rad(k)*1.6,z1(k)
      end if
      
      i1=i
                  if(i.eq.Kz(k)) then
      Z1(k) = Z1(k)/Y(k)
      Z2(k) = Z2(k)/Y(k)
      EE(k) = EE(k)/Y(k)
      Rad(k)=Rad(k)/Y(k)
      Si(k) =Sif(i)*YY(i)/Y(k)
      Sr(k) = Sr(k)/Y(k)
      if(k.ne.Nk) Sr(k+1) =Srf(i+1)*YY(i+1)
      

      
      k=k+1 
                 endif
            enddo
      Sr(Nk) = Sr(Nk)/Y(Nk)
      Si(Nk) =0.
            return
      end
            subroutine ZRAD(nz,k,i1,Te, Xz)
c.........Author: V.E.Zhogolev (20.11.2006)

          implicit none
      integer Nz,k,i1 
      dimension Te(i1),Xz(i1)
      real  Te,Xz 
c Purpose: 
c     To calculate the radial profile one of three effective 
c     characteristics for the impurity element in coronal limit use ATSV. 
c
c Output:
c     Xz(*) - array (profile) of an effective characteristics 
c Input: 
c     Te(*) - array (profile) of the electron temperatures [keV];
c
c     nz - the atomic number of impurity element (for Argon  nz=18)
c     i1 - dimension of the profile arrays;
c
c     k -  integer parameter which specifies effective characteristic: 
c  if k=1 then Xz  corresponds to  
c           coefficient of energy losses [10**-38 MW*m**3],
c  if k=2 then Xz corresponds to averaged charge <Z**1>,
c  if k=3 then Xz corresponds to averaged charge <Z**2>.
c
c ADDITIONAL DATA
c     Necessary data files sp* should be located 
c     in the ./IMP or current directory.
c
c Use subroutine AReff
c
      real*8 Z1,Z2,EE,Si,Sr,Rad,
     * tay_lo,n0_xx,n_e_xx,tay_lo_xx,tn_xx,alf_n_xx
     
      real*4 T,tn
      
      real RAJ,CDe
      
      integer i
      integer Kz
      dimension Kz(1), Z1(1), Z2(1), EE(1), Si(1), Sr(1), Rad(1)

      Kz(1) = nz+1

      RAJ=0.
      
      call get_param_test2(n0_xx,n_e_xx,tay_lo_xx,tn_xx,alf_n_xx)
      
!        print *,' n_e_xx n0_xx==',n_e_xx,n0_xx

 !       print *,' tay_lo_xx alf_n_xx==',tay_lo_xx,alf_n_xx


      
      CDe=n0_xx/n_e_xx*alf_n_xx
!      CDe=n0_xx

      tay_lo=tay_lo_xx*n_e_xx
      
      tn=tn_xx*1.e-3
      
!      print *,'CDe tay_lo tn=',CDe,tay_lo,tn 
      
            do 1 i=1,i1
      T=Te(i)
      call AReffm_t(nz,T,1,Kz,Z1,Z2,EE,Si,Sr,Rad,RAJ,CDe,tn,tay_lo)
      if(k.eq.1)  Xz(i)=0.16*Rad(1)
      if(k.eq.2)  Xz(i)=Z1(1)
      if(k.eq.3)  Xz(i)=Z2(1)
    1 continue  
            return 
      end
