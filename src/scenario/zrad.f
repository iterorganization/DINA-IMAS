
 
c      dimension te(100),res(100)

c      nz=18
c      k=1
c      i1=1
c      te(1)=4.e-2

c      call zrad(nz,k,i1,TE,RES)

c      end



            subroutine ZRAD1(Nz,k,i1,Te,Xz)


cDEC$ ATTRIBUTES DLLEXPORT::  ZRAD1

c................Author: V.E.Zhogolev (01.06.2000)
c, modification (29.12.2004)
c
c Purpose: 
c     To calculate the radial profile 1 of 3  effective characteristics 
c     for the impurity element in coronal limit. 
c Output:
c     Xz(i1) - array (profile) of an effective characteristics 
c Input: 
c     Te(i1) - array (profile) of the electron temperature [keV];
c     i1 - dimension of the profile arrays;
c     k -  integer parameter specifying effective characteristic: 
c  if k=1 then Xz  corresponds to  
c           coefficient of energy losses [10**-38 MW*m**3],
c  if k=2 then Xz corresponds to averaged charge <Z**1>,
c  if k=3 then Xz corresponds to averaged charge <Z**2>.
c     Nz - the atomic number of impurity element (for Argon  Nz=18)
c
c EXTERNAL: AReff,ATSV
c ADDITIONAL DATA:
c     necessary data file sp*.dat for ATSV should be located 
c     in the working directory or in subdirectory '...\IMP' .
c
	include 'double.inc'
        dimension Te(i1),Xz(i1)
      integer Nz,k,i1 ,Kg2(2)
c!!!      real*4 T
c!!!      real*8 Z1(2),Z2(2),EE(2),Si(2),Sr(2),Rad(2)
      dimension Z1(2),Z2(2),EE(2),Si(2),Sr(2),Rad(2)
        Kg2(1)=Nz+1
            do 1 i=1,i1
      T=1000.*Te(i)
      call AReff(Nz,T,1,Kg2,Z1,Z2,EE,Si,Sr,Rad)
      if(k.eq.1)  Xz(i)=0.16*Rad(1)
      if(k.eq.2)  Xz(i)=Z1(1)
      if(k.eq.3)  Xz(i)=Z2(1)
    1 continue  


c******************************
c      do i=1,i1
c         if(kpr.eq.1)print*,'k te res',k,te(i),xz(i)
c      end do


            return 
      end
c
c -------------------------------------------------------------------
c
            subroutine AReff(Nz,Te,Nk,Kz,Z1,Z2,EE,Si,Sr,Rad)
c................Author: V.E.Zhogolev (01.06.2000)
c
c Purpose: 
c     To calculate set of effective characteristics 
c     for reduced impurity model. 
c Imput: 
c     Nz - the atomic number of impurity element (for Argon  Nz=18)
c     Te - electron temperature [eV];
c     Nk - total number group of ions;
c     Kz(k) - is arrey of hiest k-ion in the group plas one,
c            k=1,Nk .
c Output:
c     Z1(k),Z2(k) - are averaged charge <Z**1> and <Z**2> ; 
c     EE(k) - average ionization potensial [eV];
c     Si(k),Sr(k) - effective frecuncis of ionization and recombination
c           at electron density 10**8 cm**(-3), [c**(-1)]; 
c     Rad(k) - effective coeffisient of energy losses 
c           [10**(-8) cm**3 eV/c].
c 
c EXTERNAL: ATSV
c ADDITIONAL DATA:
c     necessary data file sp*.dat for ATSV should be located 
c     in the working directory or in subdirectory '...\IMP' .
c
c           ms>max(Nz)
	include 'double.inc'
	integer ms
        parameter (ms=75)
      integer Nz, Nk, Kz(Nk) 
c!!!      real TE
c!!!      real*8 Z1(Nk),Z2(Nk),EE(Nk),Si(Nk),Sr(Nk),Rad(Nk)
      dimension Z1(Nk),Z2(Nk),EE(Nk),Si(Nk),Sr(Nk),Rad(Nk)
c!!!      real T10
c!!!      real Ef(ms),Sif(ms),Srf(ms),Radf(ms),Ds(ms)
      dimension Ef(ms),Sif(ms),Srf(ms),Radf(ms),Ds(ms)
c!!!      real*8 C,Y(ms),YY(ms)
      dimension Y(ms),YY(ms)
      integer IY, k,i,i1 
      save IY
      data IY/0/      
            if(IY.eq.0) then
c  SPNUL is entry of ATSV for new it initialithaton
      call SPNUL
      IY=1
            endif
      IY=Nz+1
      T10=TE
      T10=alog10(T10)
      call ATSV(Nz,0,0,IY,T10,  Ef,Ds)
      call ATSV(Nz,1,0,IY,T10, Sif,Ds)
      call ATSV(Nz,2,0,IY,T10, Srf,Ds)
      call ATSV(Nz,3,0,IY,T10,Radf,Ds)
            do k=1,Nk
        Y(k)=0.
       Z1(k)=0.
       Z2(k)=0.
       EE(k)=0.
      Rad(k)=0.
            enddo
      C=1.d0
      YY(1) = C
            do i=2,IY
      YY(i) = YY(i-1)*10.d0**(Sif(i-1)-Srf(i))
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
       Y(k) =  Y(k) + YY(i)
      Z1(k) = Z1(k) + YY(i)*i1
      Z2(k) = Z2(k) + YY(i)*i1*i1
      EE(k) = EE(k) + YY(i)*Ef(i)
      Rad(k)= Rad(k)+ YY(i)*10.d0**Radf(i)
      i1=i
                  if(i.eq.Kz(k)) then
      Z1(k) = Z1(k)/Y(k)
      Z2(k) = Z2(k)/Y(k)
      EE(k) = EE(k)/Y(k)
      Rad(k)=Rad(k)/Y(k)
      Si(k) =10.d0**Sif(i)*YY(i)/Y(k)
      Sr(k) = Sr(k)/Y(k)
      if(k.ne.Nk) Sr(k+1) =10.d0**Srf(i+1)*YY(i+1)
      k=k+1 
                 endif
            enddo
      Sr(Nk) = Sr(Nk)/Y(Nk)
      Si(Nk) =0.
            return
      end
c      
