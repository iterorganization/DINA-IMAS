
	subroutine plasma_bz()
	include 'double.inc'
	include 'new_com.inc'

	call plasma_bz_c(
     *  bzz_pl,key_volt6,key_volt7,kpr)

	return
	end

	
	subroutine plasma_bz_c(
     *  bzz_pl,key_volt6,key_volt7,kpr)

	include 'double.inc'

	   open (unit=41,file='bz_pl.dat',form='formatted')
	   read (41,*)
	   read (41,*)bzz_pl
	   read (41,*)
	   read (41,*)key_volt6,key_volt7

	   bzz_pl=bzz_pl/1.e3
	   
	   if(kpr.eq.1)
     *   print *,' bzz_pl key_volt6 key_volt7',bzz_pl,key_volt6,key_volt7

c  bz_pl in Gaus from plasma at center... to calculate decay index
	   close(41)

	
	return
	end



	subroutine time_out_br()

	include 'double.inc'
	include 'parf0'
        include 'parf3'
c
	common
     *	/igr/ygr(iy,ny),tgr(ny),igr
	common
     *	/ng_igr/ng
	character *12 fstatus
        common
     *  /ge5/kpr

	i_dop=i_dop+1

c	open (unit=42,file='f42_br.dat',access='append',
	if(i_dop.eq.1)open (unit=42,file='f42.dat',
     *	form='formatted')

c
	if(igr.gt.0)then
	write (42,5001)igr,ng
c
	write (42,5000) ((ygr(i,j),j=1,igr),i=1,ng),
     *(tgr(j),j=1,igr)

c	call out42(igr,ng,ygr,tgr)

	igr=0
c
	if(kpr.eq.1)print*,'!!! i_dop=',i_dop
	if(kpr.eq.1)print *,'writing "for042",here igr=',igr
	end if
c	close (unit=42)
5001    format(4i4)
5000    format (6(1pe14.6))
	return
	end

	subroutine coef_pf_res()
	include 'double.inc'
	include 'new_com.inc'

	call coef_pf_res_c(
     *  c_pf_res,pfres,npf,kpr)


        return
        end


c---------------------------------------
	subroutine coef_pf_res_c(
     *  c_pf_res,pfres,npf,kpr)

	include 'double.inc'
        dimension c_pf_res(*),pfres(*)

        open (unit=41,file='c_pf_res.dat',form='formatted')
        read (41,*)
        read (41,*)(c_pf_res(i),i=1,npf)
        close (41)

	 do k=1,npf
	    pfres(k)=pfres(k)*c_pf_res(k)
	    if(kpr.eq.1)print *,' # pfres c_pf_res',k,pfres(k),c_pf_res(k)
	 end do

 	res_ves=0.
	do i=1,npf
	   res_ves=res_ves+1./pfres(i)
	end do
	   res_ves=1./res_ves

	if(kpr.eq.1)print *,'npf pf_res ',npf,res_ves



        return
        end


	subroutine tr_volt()

	include 'double.inc'
	include 'new_com.inc'

	call  tr_volt_c(
     *  npf,vchopper,pf_volts)
	
	return
	end

	subroutine tr_volt_c(
     *  npf,vchopper,pf_volts)

	include 'double.inc'
	dimension vchopper(*),pf_volts(*)


	do i=1,npf
	   pf_volts(i)=vchopper(i)
	end do



	return
	end


	subroutine r_volt()

	include 'double.inc'
	include 'new_com.inc'

	call  r_volt_c(
     *  tt,npf,vchopper)
	
	return
	end

	subroutine r_volt_c(
     *  tt,npf,vchopper)
	
	include 'double.inc'
	include 'parf1'
	dimension vchopper(*),v1(kf),v2(kf)
        common
     *  /ge5/kpr

	character *12 apr


	open (unit=41,file='volt.dat',form='formatted')


	t2=-1.

	 read (41,*,err=1,end=1)

      do ii=1,10000

	 t1=t2
	 do k=1,npf
	    v1(k)=v2(k)
	 end do

	 read (41,*,err=1,end=1) t2,(v2(i),i=1,npf)
	 t2=t2+1.e-3

	 if( (tt-t1)*(tt-t2).le.0.)then
c==================

	    t_coef=(tt-t1)/(t2-t1)
	 
	    do k=1,npf
	       vchopper(k)=v1(k)+t_coef*(v2(k)-v1(k))
	    end do

	    go to 1
c
	 end if

	end do


 1	continue

	    if(kpr.eq.1)print *,' t1 tt t2 ===',t1,tt,t2

	apr='vchopper'
	if(kpr.eq.1)print 71,apr,(vchopper(i),i=1,npf)
	apr='v2'
	if(kpr.eq.1)print 71,apr,(v2(i),i=1,npf)
	apr='v1'
	if(kpr.eq.1)print 71,apr,(v1(i),i=1,npf)
	close (unit=41)

c        pause 'from r_volt'


71 	format (20x,a6/,(6(1pe10.3)))

	return
	end


	subroutine wr_volt()

	include 'double.inc'
	include 'new_com.inc'

	call  wr_volt_c(
     *  tt,npf,pf_volts)
	
	return
	end

	subroutine wr_volt_c(
     *  tt,npf,pf_volts)
	
	include 'double.inc'
        common
     *  /ge5/kpr
	dimension pf_volts(*)

	i_en=i_en+1
	if(i_en.eq.1)then

	open (unit=41,file='volt.dat',status='new',
     *          form='formatted')
	write (41,*) 'time [sec], Volts [V]'

c!!!	close (41)
	end if


c!!!	open (unit=41,file='volt.dat',access='append',
c!!!     *	form='formatted')

	if(i_en.gt.1)open(unit=41,file='volt.dat',status='old',
     *          form='formatted')
c	write (41,5000) tt,(pf_volts(i),i=1,npf)
	write (41,*) tt,(pf_volts(i),i=1,npf)
	write (41,*)' '

	close (unit=41)

c        if(kpr.eq.1)print*,'tt=',tt
c        pause 'from wr_volt'


5000    format (6(1pe14.6))


	return
	end


	subroutine index_br()

	include 'double.inc'
	include 'new_com.inc'

	call index_br_c(
     *  bz_tot,bz_pf,bz_ves,bz_pl,
     *  dbz_tot,dbz_pf,dbz_ves,dbz_pl,
     *  rmag,f_index_br,f_index_pf,f_index_ves,
     *  bzz_pl)

	
	return
	end

	subroutine index_br_c(
     *  bz_tot,bz_pf,bz_ves,bz_pl,
     *  dbz_tot,dbz_pf,dbz_ves,dbz_pl,
     *  rmag,f_index_br,f_index_pf,f_index_ves,
     *  bzz_pl)


	include 'double.inc'
        common
     *  /ge5/kpr

	dbz_tot=dbz_pf+dbz_ves
ccc	   if(abs(bz_tot).lt.1.e-8)bz_tot=1.e-8

c*** This is "quasi" index 	

ccc	if(abs(bz_tot).lt.bzz_pl)then
ccc	   f_index_br=-rmag/bzz_pl*dbz_tot*bz_tot/(abs(bz_tot)+1.e-30)
	   f_index_br=rmag/bzz_pl*dbz_tot
c	      if(kpr.eq.1)
c     *print *,'!!!!! bz bzz_pl f_ind',bz_ext,bzz_pl,f_index
ccc	else
ccc	   f_index_br=-rmag/bz_tot*dbz_tot
ccc	end if

ccc	   if(abs(bz_pf).lt.1.e-8)bz_pf=1.e-8

c###	   f_index_pf=-rmag/bz_pf*dbz_pf
	   f_index_pf=-rmag/bz_tot*dbz_pf
	   
	   if(abs(bz_ves).lt.1.e-8)bz_ves=1.e-8

c###	   f_index_ves=-rmag/bz_ves*dbz_ves
	   f_index_ves=-rmag/bz_tot*dbz_ves

	   if(abs(f_index_br).gt.10.)f_index_br=10.

c	if(kpr.eq.1)print *,' rmag bz_tot ==',rmag,bz_tot
c	if(kpr.eq.1)print *,' dbz_tot f_index_br==',dbz_tot,f_index_br

	return
	end




	subroutine dbz_pfc()

	include 'double.inc'
	include 'new_com.inc'

	call dbz_pfc_c(
     *  rmag,zmag,npf,pf,dbz_pf)
	
	return
	end

	subroutine dbz_pfc_c(
     *  rmag,zmag,npf,pf,dbz_pf)

	include 'double.inc'
        dimension pf(*)

	include 'parf1'
	common
     *  /pf2/RR(nmax,KF),ZZ(nmax,KF),pw(nmax,kf)
     *  /pf3/nmx(kf),turn(kf)
        common
     *  /ge5/kpr


	delb=0.
	urr=rmag
	vrr=zmag

	do jj=1,npf

	do j=1,NMX(jj)
	call dbrgdz(dbrdz,dgdz,urr,rr(j,jj),vrr,zz(j,jj))
	delb=delb+dbrdz*pw(j,jj)*pf(jj)
	end do

	end do

	dbz_pf=delb

	if(kpr.eq.1)print *,' npf dbz_pf========',npf,dbz_pf

	return
	end


	subroutine dbz_vess()

	include 'double.inc'
	include 'new_com.inc'

	call dbz_vess_c(
     *  rmag,zmag,ncam,tcam,rc,zc,
     *  dbz_ves)

	
	return
	end

	subroutine dbz_vess_c(
     *  rmag,zmag,ncam,tcam,rc,zc,
     *  dbz_ves)

	include 'double.inc'
        common
     *  /ge5/kpr
        dimension tcam(*),rc(*),zc(*)

	delb=0.
	urr=rmag
	vrr=zmag

	do jj=1,ncam

	call dbrgdz(dbrdz,dgdz,urr,rc(jj),vrr,zc(jj))
	delb=delb+dbrdz*tcam(jj)

	end do
	
	dbz_ves=delb

	if(kpr.eq.1)print *,' dbz_ves========',dbz_ves

	return
	end


	subroutine bz_calc()

	include 'double.inc'
	include 'new_com.inc'

	call bz_calc_c(
     *  rmag,zmag,ncam,tcam,rc,zc,
     *  bz_tot,bz_pf,bz_ves,bz_pl)


	
	return
	end

	subroutine bz_calc_c(
     *  rmag,zmag,ncam,tcam,rc,zc,
     *  bz_tot,bz_pf,bz_ves,bz_pl)

	include 'double.inc'
        common
     *  /ge5/kpr
        dimension tcam(*),rc(*),zc(*)

        i_en=i_en+1

c        if(kpr.eq.1)print *,'ncam rmag zmag==',ncam,rmag,zmag


  	if(i_en.eq.1)then
           call pf_coor()
           if(kpr.eq.1)print *,' CALL ELKE...'
           call edim1
        end if



        r=rmag
        z=zmag
c BZ from PF...
        call BIS(BRR,BZZ,R,Z)

	bz_pf=bzz

c        if(kpr.eq.1)print *,' BIS brr bzz',brr,bzz
c BZ from vessel...
        BR=0.
        BZ=0.
      DO  i=1,ncam
c         if(kpr.eq.1)print *,' i r z rc zc ',i,r,z,rc(i),zc(i)

         CALL BRZ(BR0,BZ0,r,rc(i),z,zc(i))

         BR=BR+BR0*tcam(i)
         BZ=BZ+BZ0*tcam(i)
	end do

	bz_ves=bz

	bz_tot=bz_pf+bz_ves+bz_pl

        if(kpr.eq.1)print *,' rmag zmag==',rmag,zmag
        if(kpr.eq.1)print *,' BZ(pf) BZ(vessel)==',bzz,bz
        if(kpr.eq.1)print *,' BR(pf) BR(vessel)==',brr,br
	
	return
	end

  	subroutine pf_coor()
c-------------------------------------------
c  read PF coil coordinates
c-----------------------------------------
	include 'double.inc'
c	implicit real*8 (a-h,o-z)
	include 'parf1'
      COMMON
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /pf2/R(nmax,KF),Z(nmax,KF),pw(nmax,KF)
     *  /pf3/nmx(kf),turn(kf)
        common
     *  /ge5/kpr

	CHARACTER*120 fshot,tmp

	open (unit=40,file='koor.fl',form='formatted')
	read (40,*)
	read (40,74)tmp
74	format(a110)
	close (40)
     	open(unit=41,status='old',file=tmp,form='formatted')

	if(kpr.eq.1)print *,' npf===',npf
	DO I=1,npf
	read(41,*)
	read(41,*)nmx(i),turn(i)
	if(kpr.eq.1)print *,' i nmx turn',i,nmx(i),turn(i)

	read(41,*)(R(J,I),Z(J,I),J=1,nmx(i))

      j=1
	if(kpr.eq.1)print *,' R Z ',R(J,I),Z(J,I)

	END DO

	if(kpr.eq.1)print *,' npf===',npf

	close(41)
2	FORMAT(/,2(2x,1PE10.3))
c
	do i=1,npf
	DO J=1,nmx(i)
	pw(j,i)=turn(i)/nmx(i)
	end do
	pw1=turn(i)/nmx(i)
	if(kpr.eq.1)print *,' i pw ',i,pw1
	END DO
c
71 	format (20x,a6/,(6(1pe10.3)))
      RETURN
      END
      SUBROUTINE BIS(BRR,BZZ,R,Z)
	include 'double.inc'
c       implicit real*8 (a-h,o-z)
	include 'parf1'
      COMMON
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /pf2/RR(nmax,KF),ZZ(nmax,KF),pw(nmax,KF)
     *  /pf3/nmx(kf),turn(kf)
c
	BRR=0.
	BZZ=0.
      DO  I=1,npf
	do j=1,NMX(i)
      CALL BRZ(BR0,BZ0,R,RR(j,I),Z,ZZ(j,i))
      BR=BR0*pw(j,i)
      BZ=BZ0*pw(j,i)
	BRR=BR*Pf(i)+BRR
	BZZ=BZ*Pf(i)+BZZ
	end do
	end do
c
      RETURN
      END
      SUBROUTINE BISA(BRR,BZZ,R,Z)
	include 'double.inc'
c       implicit real*8 (a-h,o-z)
	include 'parf1'
      COMMON
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /pf2/RR(nmax,KF),ZZ(nmax,KF),pw(nmax,KF)
     *  /pf3/nmx(kf),turn(kf)
	DIMENSION BRR(KF),BZZ(KF)
c

      DO  I=1,npf
	BRR(I)=0.
	BZZ(I)=0.
	do j=1,NMX(i)
!	print *,' i j r z brz',i,j,r,z
      CALL BRZ(BR0,BZ0,R,RR(j,I),Z,ZZ(j,i))
      BR=BR0*pw(j,i)
      BZ=BZ0*pw(j,i)
	BRR(I)=BR+BRR(I)
	BZZ(I)=BZ+BZZ(I)
	end do
	end do
c
      RETURN
      END
      SUBROUTINE IS1(F,R,Z)
	include 'double.inc'
c       implicit real*8 (a-h,o-z)
	include 'parf1'
      COMMON
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /pf2/RR(nmax,KF),ZZ(nmax,KF),pw(nmax,kf)
     *  /pf3/nmx(kf),turn(kf)
c
	dimension f(kf)
c
	do i=1,npf
	f(i)=0.
	end do
	do i=1,npf
	do j=1,NMX(i)
      F(i)=F(i)+pw(j,i)*FP(RR(j,I),R,ZZ(j,I),Z)
	end do
	end do
      RETURN
      END
c
	subroutine dbrgdz(dbrdz,dgdz,r,r1,z,z1)
	include 'double.inc'
c	real *8 dbrdz,dgdz,gk,yk,ye
	g1=(r1+r)**2
	g2=z-z1
	g3=g2**2
	g4=g1+g3
	g5=sqrt(g4)
	g6=(r1-r)**2
	g7=r1*r
	gk2=4.*g7/g4
	gk=sqrt(gk2)
	dkdz=-4.*g7*g2/gk/g4**2
	call elke(gk,yk,ye)
	dkdk=(ye/(1-gk2)-yk)/gk
	dedk=(ye-yk)/gk
	f1=g2/g5
	df1dz=g1/(g4*g5)
	f3=(r1**2+r**2+g2**2)/(g6+g3)
	df3dz=-4.*g2*g7/(g6+g3)**2
	f2=-yk+f3*ye
	df2dz=-dkdk*dkdz+df3dz*ye+f3*dedk*dkdz
	dbrdz=0.2*(df1dz*f2+f1*df2dz)/r
	dgdz=0.8*3.14159*sqrt(g7)*dkdz*(-(1.+0.5*gk2)*yk/gk+(1.-0.5*gk2)*
     * dkdk+ye/gk-dedk)/gk
	return
        end

	subroutine gsvd_br(rps,zps,nps,indpf,seps,kpf,ps_g)
	include 'double.inc'
c	implicit real *8 (a-h,o-z)
c
        common
     *  /ge5/kpr
	include 'parf1'
	include 'parf5'
c
	dimension amat(nx,mx),y(nx),yw(nx),indpf(kf),
     *  jpf(kf),sig(nx),a(kf),f(kf),pfc(kf),brr(kf),bzz(kf)
c
	dimension rps(nps),zps(nps),ps_g(nps),seps(500)
c
      COMMON
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /pf2/RR(nmax,KF),ZZ(nmax,KF),pw(nmax,kf)
     *  /pf3/nmx(kf),turn(kf)
c
	character *8 mpr,apr
c
71	format(20x,a6/,(6(1pe10.3)))
c
	if(kpr.eq.1)print *,' ps_g=',ps_g(1)
	do i=1,npf
	if(kpf.eq.0)pfc(i)=0.
c
	if(kpf.eq.1)pfc(i)=pf0(i)
c	if(kpr.eq.1)print *,' i pfc pf0',i,pfc(i),pf0(i)
	end do
c
	p_c=1.e-5
	b_c=1.e3
c
	k=0
	do i=1,npf
	k=k+indpf(i)
	if(indpf(i).ne.0)jpf(k)=i
	end do
c---
	ma=k
	ma1=ma
	ndata=nps+ma1
c
	if(kpr.eq.1)print *,'nps ma ndata ',nps,ma,ndata
c
	do i=1,ndata
	do j=1,ma
	amat(i,j)=0.
	end do
	end do
c
c   here start 1 point of constant flux....
	psmax=0.
	do ii=1,1
	urr=rps(ii)
	vrr=zps(ii)
	if(kpr.eq.1)print *,'ii rps zps',ii,rps(ii),zps(ii)
c
	y(ii)=ps_g(ii)
c---
	call is1(f,urr,vrr)
c
	do jj=1,npf
	if(indpf(jj).eq.0)then
	y(ii)=y(ii)-f(jj)*pf(jj)*p_c
	end if
	end do
c
	yw(ii)=y(ii)
	if(kpr.eq.1)print *,' ii y',ii,y(ii)
	if( psmax.lt.abs(y(ii)) )psmax=abs( y(ii) )
c
c   ---------- here we determine A matrix -----------
	do jj=1,ma1
	kjj=jpf(jj)
	p_tem=f(kjj)*p_c
	psmax=amax1(psmax,p_tem)
	amat(ii,jj)=f(kjj)*p_c
	if(kpr.eq.1)print *,' ii jj kjj amat_ps=',ii,jj,kjj,amat(ii,jj)
	end do
c
	end do

c   here end 1 point of constant flux....
c  here sigmas to flux points.....
	if(abs(psmax).lt.1.e-15)psmax=1.e-15
	do ii=1,1
	sig(ii)=seps(ii)*psmax
	end do
	if(kpr.eq.1)print *,' psmax=',psmax
c===========================================
c
c
c   here start 3 points of constant flux....
	bmax=0.
	do ii=2,nps-1
	urr=rps(ii)
	vrr=zps(ii)
	if(kpr.eq.1)print *,'ii rps zps bz_g',ii,rps(ii),zps(ii),ps_g(ii)
c
	y(ii)=ps_g(ii)
	call bisa(brr,bzz,urr,vrr)
c
	do jj=1,npf
	if(indpf(jj).eq.0)then
	y(ii)=y(ii)-bzz(jj)*pf(jj)*b_c
	end if
	end do
c
	yw(ii)=y(ii)
	if(kpr.eq.1)print *,' ii y',ii,y(ii)
	if( bmax.lt.abs(y(ii)) )bmax=abs( y(ii) )
c
c   ---------- here we determine A matrix -----------
	do jj=1,ma1
	kjj=jpf(jj)
	amat(ii,jj)=bzz(kjj)*b_c
	p_tem=bzz(kjj)*b_c
	bmax=amax1(bmax,p_tem)
	if(kpr.eq.1)print *,' ii jj kjj amat_bzz=',ii,jj,kjj,amat(ii,jj)
	end do
c
	end do

c   here end 3 points of constant bz_field....
c  here sigmas to bz points.....

	if(abs(bmax).lt.1.e-15)bmax=1.e-15
	do ii=2,nps-1
	sig(ii)=seps(ii)*bmax
	end do
	if(kpr.eq.1)print *,' bmax=',bmax
c===========================================
c
c   here start point of dbrdz...
	bmax=0.
	do ii=nps,nps
	urr=rps(ii)
	vrr=zps(ii)
	if(kpr.eq.1)
     *       print *,'ii rps zps dbdz_g',ii,rps(ii),zps(ii),ps_g(ii)
c
	y(ii)=ps_g(ii)
c
	do jj=1,npf
	if(indpf(jj).eq.0)then
	delb=0.
	do j=1,NMX(jj)
	call dbrgdz(dbrdz,dgdz,urr,rr(j,jj),vrr,zz(j,jj))
	delb=delb+dbrdz*pw(j,jj)
	end do
	y(ii)=y(ii)-delb*pf(jj)*b_c
	end if
	end do
c
	yw(ii)=y(ii)
	if(kpr.eq.1)print *,' ii y',ii,y(ii)
	if( bmax.lt.abs(y(ii)) )bmax=abs( y(ii) )
c
c   ---------- here we determine A matrix -----------
	do jj=1,ma1
	kjj=jpf(jj)
	delb=0.
	do j=1,NMX(kjj)
	call dbrgdz(dbrdz,dgdz,urr,rr(j,kjj),vrr,zz(j,kjj))
	delb=delb+dbrdz*pw(j,kjj)
	end do
	amat(ii,jj)=delb*b_c
	p_tem=delb*b_c
	bmax=amax1(bmax,p_tem)
	if(kpr.eq.1)print *,' ii jj kjj amat_bzz=',ii,jj,kjj,amat(ii,jj)
	end do
c
	end do
c   here end 3 points of constant bz_field....
c  here sigmas to bz points.....
	if(abs(bmax).lt.1.e-15)bmax=1.e-15
	do ii=nps,nps
	sig(ii)=seps(ii)*bmax
	end do
	if(kpr.eq.1)print *,' bmax=',bmax
c===========================================
c
	k=0
	pfmax=0.
	do i=nps+1,nps+ma1
	k=k+1
	kjj=jpf(k)
	y(i)=pfc(kjj)
	if( pfmax.lt.abs(y(i)) )pfmax=abs(y(i))
	amat(nps+k,k)=1.
	end do
c-----------------------------------
c   here sigmas to ma1 PF-current points (nps+ma1)
c	if(pfmax.lt.1000.)pfmax=1000.
	do i=nps+1,nps+ma1
	sig(i)=seps(i)*pfmax
c	sig(i)=1.
	end do
	if(kpr.eq.1)print *,' pfmax=',pfmax
c-------------------------------------------
c
	namat=nx
	if(abs(ps_g(nps)).gt.1.e3)ndata=ndata-1
	call svdfit(amat,y,sig,ndata,a,ma,namat)
	apr='pf'
c	if(kpr.eq.1)print 71,apr,(pf(i),i=1,npf)
	do k=1,ma1
	kjj=jpf(k)
	if(kpr.eq.1)print *,'k jpf pfc a',k,jpf(k),pfc(kjj),a(k)
	pf(kjj)=a(k)
	end do
     	open(unit=41,file='tok',form='formatted')
	write (41,*)' npf'
	write (41,*) npf
	if(kpr.eq.1)print *,'npf=',npf
c
	do i=1,npf
	write (41,*)i
	write(41,*)pf(i)
	end do
	close(41)
c
c
	do ii=1,nps
	flux=0.
	do jj=1,ma1
	flux=flux+amat(ii,jj)*a(jj)
	end do
	if(ii.eq.1.and.kpr.eq.1)
     *       print *,'ii flux yw ps_g ',ii,flux,yw(ii),ps_g(ii)
	if(ii.ne.1.and.kpr.eq.1)
     *       print *,'ii flux yw bz_g ',ii,flux,yw(ii),ps_g(ii)
	end do
c
c   here start 1 point of constant flux....

	do ii=1,1

	urr=rps(ii)
	vrr=zps(ii)
	if(kpr.eq.1)print *,'ii rps zps',ii,rps(ii),zps(ii)


c---
	call is1(f,urr,vrr)
c
	psi_ax=0.
	do jj=1,npf
	psi_ax=psi_ax+f(jj)*pf(jj)*p_c
	end do
	if(kpr.eq.1)print *,'ii ps_g psi_ax',ii,ps_g(ii),psi_ax

	end do
	
c   here start 1 point of constant flux....

	do ii=2,2

	urr=rps(ii)
	vrr=zps(ii)

	if(kpr.eq.1)print *,'ii rps zps',ii,rps(ii),zps(ii)


	call bisa(brr,bzz,urr,vrr)
c
	bz_ax=0.
	do jj=1,npf
	bz_ax=bz_ax+bzz(jj)*pf(jj)*b_c
	end do

	if(kpr.eq.1)print *,'ii ps_g bz_ax',ii,ps_g(ii),bz_ax

	end do
	
c
	return
	end

	subroutine tcam_r()

	include 'double.inc'
	include 'new_com.inc'

	call tcam_r_c(
     *  tt,ncam,tcam)

	
	return
	end

	subroutine tcam_r_c(
     *  tt,ncam,tcam)

	include 'double.inc'
        common
     *  /ge5/kpr
        dimension tcam(*)

     	open(unit=41,file='tcam.dat',form='formatted')
	read(41,*)
	read (41,*)tt,ncam
c
	read (41,*)(tcam(i),i=1,ncam)
5000    format (6(1pe14.6))

	close(41)
	tokc=0.
	do i=1,ncam
	   tokc=tokc+tcam(i)
	end do
	if(kpr.eq.1)print *,'tt ncam tokc===',tt,ncam,tokc

	
	if(tt.lt.0.)then
	   do i=1,ncam
	      tcam(i)=0.
	   end do
	   tt=-tt
	end if




	return
	end

	subroutine tcam_w()

	include 'double.inc'
	include 'new_com.inc'

	call tcam_w_c(
     *  tt,ncam,tcam)
	
	return
	end

	subroutine tcam_w_c(
     *  tt,ncam,tcam)

	include 'double.inc'
        dimension tcam(*)

     	open(unit=41,file='tcam.dat',form='formatted')
	write (41,*)' tt ncam'
	write (41,*)tt,ncam
	if(kpr.eq.1)print *,'tt ncam=',tt,ncam
c
	write (41,5000)(tcam(i),i=1,ncam)
5000    format (6(1pe14.6))

	close(41)


	return
	end





	subroutine flat_ext()
	include 'double.inc'
	include 'new_com.inc'

	call flat_ext_c(
     *  nwnh,nr,nz,npf,ncam,pf,tcam,fluxarre,vesarre,
     *  kf,mu,pfind,pfc,pmj,pfres,rcam,
     *  xu,yu,ke,
     *  nloop,nprobe,kloop,kprobe,
     *  pfgreen,vesgreen,
     *  pfprobe,vesprobe,
     *  pslgreene,bprgreene,
     *  re,ze,x,y,dr,dz,dx,dy)                       
	
	return
	end



	subroutine flat_ext_c(
     *  nwnh,nr,nz,npf,ncam,pf,tcam,
     *  fluxarr,vesarr,
     *  kf,mu,pfind,pfc,pmj,pfres,rcam,
     *  xu,yu,ke,
     *  nloop,nprobe,kloop,kprobe,
     *  pfgreen,vesgreen,
     *  pfprobe,vesprobe,
     *  pslgreen,bprgreen,
     *  re,ze,x,y,dr,dz,dx,dy)                       

	include 'double.inc'

	dimension pf(*),tcam(*),fluxarr(nwnh,*),
     *  vesarr(nwnh,*),
     *  pfind(kf,*),pfc(mu,*),pmj(mu,*),pfres(*),rcam(*),
     *  xu(*),yu(*),
     *  pfgreen(nloop,*),vesgreen(nloop,*),
     *  pfprobe(nprobe,*),vesprobe(nprobe,*),
     *  pslgreen(nwnh,*),bprgreen(nwnh,*),                       
     *  re(*),ze(*),x(*),y(*)                       

	dimension ttt(500)

      common
     *  /ge5/kpr

	character *200 f0,f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,
     * f11,f12,f13,f14,f15,f16
c

	if(kpr.eq.1)print *,' nwnh=',nwnh


c-----------
	open (unit=40,file='flux_flat.fl',form='formatted')
	read (40,*)
	read (40,74)f0
	read (40,*)
	read (40,74)f1
	read (40,*)
	read (40,74)f2
	read (40,*)
	read (40,74)f3
	read (40,*)
	read (40,74)f4
	read (40,*)
	read (40,74)f5
	read (40,*)
	read (40,74)f6
	read (40,*)
	read (40,74)f7
	read (40,*)
	read (40,74)f8
	read (40,*)
	read (40,74)f9
	read (40,*)
	read (40,74)f10
	read (40,*)
	read (40,74)f11
	read (40,*)
	read (40,74)f12
	read (40,*)
	read (40,74)f13
	read (40,*)
	read (40,74)f14
	read (40,*)
	read (40,74)f15
	read (40,*)
	read (40,74)f16

74	format(a110)
	close (40)


	if(kpr.eq.1)print *,f0
	open (unit=41,file=f0,form='formatted')                  
!!!	open (unit=41,file='glcoeff_mat.flat',form='formatted')                    

	read (41,*)npf,ncam,kloop,kprobe                                                    
	close (41)                                                             

	if(kpr.eq.1)print *,' npf ncam=',npf,ncam
	if(kpr.eq.1)print *,' kloop,kprobe=',kloop,kprobe

      
	open (unit=41,file=f1,form='formatted')                    
!	open (unit=41,file='pmj_mat.flat',form='formatted')                    

	read (41,*)ncam_mat                                                    

	read (41,*)                                                            

      if(ncam.ne.ncam_mat)then

	if(kpr.eq.1)print *,' ncam.ne.ncam_mat=',ncam,ncam_mat

	read (*,*)
	
	end if
	                                                                  

	do kk=1,ncam                                                       

	   do k=1,ncam                                                    

	      read (41,*)pmj(k,kk)
		     pmj(k,kk)=pmj(k,kk)*1.d8    
	   end do                                                              

	end do                                                                 

	close (41)                                                             

                                                                        

	open (unit=41,file=f2,form='formatted')                    
!	open (unit=41,file='pfc_mat.flat',form='formatted')                    

                                                                        

	read (41,*)ncam_mat                                                    

	read (41,*)npf_mat                                                     

                                                                        

	do kk=1,npf                                                        

	   do k=1,ncam                                                     

	   read (41,*)pfc(k,kk)                                            
	pfc(k,kk)=pfc(k,kk)*1.d8
	end do                                                                 

	end do                                                                 

                                                                        

	close (41)                                                             

                                                                        
	if(kpr.eq.1)print *,f3

	open (unit=41,file=f3,form='formatted')                  
!!!	open (unit=41,file='pfres_mat.flat',form='formatted')                  

                                                                        

	read (41,*)npf_mat                                                     

	if(kpr.eq.1)print *,' npf_mat npf==',npf_mat,npf

	read (41,*)                                                            

	do k=1,npf                                                        

	   read (41,*)pfres(k)                                             

	end do                                                                 

 	res_ves=0.
	do i=1,npf
	   res_ves=res_ves+1./pfres(i)
	end do
	   res_ves=1./res_ves

	if(kpr.eq.1)print *,'npf pf_res ',ncam,res_ves
                                                                        

	close (41)                                                             

                                                                        

	if(kpr.eq.1)print *,f4

	open (unit=41,file=f4,form='formatted')                   
!	open (unit=41,file='rcam_mat.flat',form='formatted')                   

                                                                        

	read (41,*)ncam_mat                                                    

	read (41,*)                                                            



	do k=1,ncam                                                        

	read (41,*)rcam(k)                                                 

	end do                                                                 

 	res_ves=0.
	do i=1,ncam
	
!	rcam(i)=rcam(i)*2.
	
	   res_ves=res_ves+1./rcam(i)
	end do
	   res_ves=1./res_ves

	if(kpr.eq.1)print *,'ncam res_ves ',ncam,res_ves
                                                                       

	close (41)                                           

                                                                        


	if(kpr.eq.1)print *,f5
	open (unit=41,file=f5,form='formatted')                  
!	open (unit=41,file='pfind_mat.flat',form='formatted')                  

                                                                        

	read (41,*)npf_mat                                                     

	read (41,*)                                                            

	do kk=1,npf                                                       

	   do k=1,npf                                                      

	      read (41,*)pfind(k,kk)
		  pfind(k,kk)=pfind(k,kk)*1.d8                                       
	   end do                                                              

	end do                                                                 

                                                                        

	close (41)                                                             

                                                                        


	if(kpr.eq.1)print *,f6

	open (unit=41,file=f6,form='formatted')                 
!	open (unit=41,file='vesarr_mat.flat',form='formatted')                 

                                                                       
	read (41,*)                                                            

	read (41,*)                                                            

	do k=1,ncam                                                        

	   do kk=1,nwnh                                                        

	      read (41,*)vesarr(kk,k)
		  vesarr(kk,k)=vesarr(kk,k)*1.d8 
c		  if(kpr.eq.1)print *,' k kk vesarr=',k,kk,vesarr(kk,k)                                     

	   end do                                                              

	end do                                                                 

                                                                        

	close (41)                                                             

                                                                        

	if(kpr.eq.1)print *,f7
     	open (unit=41,file=f7,form='formatted')                
!	open (unit=41,file='fluxarr_mat.flat',form='formatted')

c----------------------------------
                                                                        
	read (41,*)                                                            

	read (41,*)                                                            

	do k=1,npf                                                        

	   do kk=1,nwnh                                                        

	   read (41,*)fluxarr(kk,k)                                     
	   fluxarr(kk,k)=fluxarr(kk,k)*1.d8
	   end do                                                              
	
	
	j=1
	do i=1,nr+nz	
	ttt(i)=fluxarr(i,k)
	end do

      if(kpr.eq.1)then
	write(6,'(" k ttt ",
     *  i4,6(1pe12.5))'),
     *  k,(ttt(i),i=1,nr+nz)
      end if
      

	end do                                                                 

                                                                        

	close (41)                                                             

	if(kpr.eq.1)print *,f8
     	open (unit=41,file=f8,form='formatted')                
!!!	open (unit=41,file='pslgreen_mat.flat',form='formatted')               

                                                                        

	read (41,*)                                                            

	read (41,*)                                                   

	do k=1,kloop                                                       

	   do kk=1,nwnh                                                        

	   read (41,*)pslgreen(kk,k)                                       
	   pslgreen(kk,k)=pslgreen(kk,k)*1.d8

	   end do                                                              

	end do                                                                 

                                                                        

	close (41)                                                             



	if(kpr.eq.1)print *,f9
     	open (unit=41,file=f9,form='formatted')                
!!!	open (unit=41,file='pfgreen_mat.flat',form='formatted')               

	read (41,*)

	read (41,*)

	do k=1,kloop                                                       

	   do kk=1,npf

	   read (41,*)pfgreen(k,kk)                                       
	   pfgreen(k,kk)=pfgreen(k,kk)*1.d8 

	   end do                                                              

	end do                                                                 

	close (41)                                                             

                                                                        

	if(kpr.eq.1)print *,f10
     	open (unit=41,file=f10,form='formatted')                
!!!	open (unit=41,file='vesgreen_mat.flat',form='formatted')               

	read (41,*)

	read (41,*)

	do k=1,kloop                                                       

	   do kk=1,ncam

	   read (41,*)vesgreen(k,kk)                                       
	   vesgreen(k,kk)=vesgreen(k,kk)*1.d8 

	   end do                                                              

	end do                                                                 

	close (41)                                                             



                                                                        

	if(kpr.eq.1)print *,f11
     	open (unit=41,file=f11,form='formatted')                
!!!	open (unit=41,file='bprgreen_mat.flat',form='formatted')               

                                                                        

	read (41,*)                                                            

	read (41,*)                                                  

	do k=1,kprobe                                                 

	   do kk=1,nwnh                                                        

	   read (41,*)bprgreen(kk,k)                                       
		 bprgreen(kk,k)=bprgreen(kk,k)*1.d4

	   end do                                                              

	end do                                                                 

                                                                        

	close (41)                                                             



	if(kpr.eq.1)print *,f12
     	open (unit=41,file=f12,form='formatted')                
!!!	open (unit=41,file='pfprobe_mat.flat',form='formatted')               

	read (41,*)
	read (41,*)
	do k=1,kprobe
	   do kk=1,npf
	   read (41,*)pfprobe(k,kk)                                       
		 pfprobe(k,kk)=pfprobe(k,kk)*1.d4
	   end do                                                              
	end do                                                                 

	close (41)                                                             



	if(kpr.eq.1)print *,f13
     	open (unit=41,file=f13,form='formatted')                
!!!	open (unit=41,file='vesprobe_mat.flat',form='formatted')               

	read (41,*)
	read (41,*)
	do k=1,kprobe
	   do kk=1,ncam
	   read (41,*)vesprobe(k,kk)                                       
		 vesprobe(k,kk)=vesprobe(k,kk)*1.d4
	   end do                                                              
	end do                                                                 

	close (41)                                                             

                                                                        




	if(kpr.eq.1)print *,f14
     	open (unit=41,file=f14,form='formatted')                
!!!	open (unit=41,file='gridrange.flat',form='formatted')                  

	read (41,*)                                                            
	read (41,*)                                                            
	read (41,*)z_l                                                         
	read (41,*)z_r                                                         
	read (41,*)r_l                                                         
	read (41,*)r_r                                                         
c	if(kpr.eq.1)print *,' z_l z_r r_l r_r==',z_l,z_r,r_l,r_r                           

	close (41)                                                             

                                                                        

	if(kpr.eq.1)print *,f15
     	open (unit=41,file=f15,form='formatted')                
!!!	open (unit=41,file='xu_mat.flat',form='formatted')                     

	read (41,*)ke_mat                                                      
	read (41,*)                                                            
     	do k=1,ke_mat                                                          
	read (41,*)xu(k)                                                   
	end do                                                                 

	close (41)                                                             

	if(kpr.eq.1)print *,f16
     	open (unit=41,file=f16,form='formatted')                
!!!	open (unit=41,file='yu_mat.flat',form='formatted')                     

	read (41,*)ke_mat                                                      
	read (41,*)                                                            
	do k=1,ke_mat                                                          
	read (41,*)yu(k)                                                   
	end do                                                                 

	close (41) 
	
	ke=ke_mat                                                            

	do k=1,ke                                                              

	   xu(k)=xu(k)*100.d0                                                

	   yu(k)=yu(k)*100.d0                                                

c        write(41,*)' k xu yu ',k,xu(k),yu(k)                            

	end do                                                                 


	z0=z_l*100.d0                                                            

	zk=z_r*100.d0                                                            

                                                                        

	r0=r_l*100.d0                                                            

	rk=r_r*100.d0 

                                                                        

	dz=(zk-z0)/(nz-1.)                                                    

	dr=(rk-r0)/(nr-1.)                                                    

c----                                                                   

	do i=1,nr                                                             

	re(i)=r0+(i-1)*dr                                                      

	end do                                                                 

                                                                        

	do j=1,nz                                                             

	ze(j)=z0+(j-1)*dz                                                      

	end do                                                                 

                                                                        

	dx=dr                                                                  

	dy=dz                                                                  

                                                                        

c!        write(41,*)' nre nze ',nre,nze                                  

                                                                        

c!        write (41,*)' dx dy ',dx,dy                                     

                                                                        

                                                                        

	do i=1,nr                                                              

	x(i)=re(i)                                                             

c!        write(41,*)' i x ',i,x(i)                                       

	end do                                                                 

                                                                        

	do i=1,nz                                                              

	   y(i)=ze(i)                                                          

c!        write(41,*)' i y ',i,y(i)                                       

	end do                                                                 

	if(kpr.eq.1)print *,'z1,   zk,    r1,     rk'
	if(kpr.eq.1)print *,ze(1),ze(nz),re(1),re(nr)


	return
	end






