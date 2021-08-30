	subroutine brz_vec_r()
	include 'double.inc'
	include 'new_com.inc'

 	call brz_vec_r_c(
     *  vec_br,vec_bz,npf)

	return
	end


	subroutine brz_vec_r_c(
     *  vec_br,vec_bz,npf)

	include 'double.inc'
	dimension  vec_br(*),vec_bz(*)
	
	open (unit=41,file='tok.bz',form='formatted')

	read (41,*)
	read (41,*)npf_vec
	if(npf.ne.npf_vec)then
	   if(kpr.eq.1)print *,' npf NE npf_vec'
	   stop
	end if

	do i=1,npf
	   read (41,*)
	   read (41,*)vec_bz(i)
	end do

	close (41)
	open (unit=41,file='tok.br',form='formatted')

	read (41,*)
	read (41,*)npf_vec
	if(npf.ne.npf_vec)then
	   if(kpr.eq.1)print *,' npf NE npf_vec'
	   stop
	end if

	do i=1,npf
	   read (41,*)
	   read (41,*)vec_br(i)
	end do

	close (41)

	return
	end


	subroutine br_bz_vec()
	include 'double.inc'
	include 'new_com.inc'

 	call br_bz_vec_c(
     *  vec_br,vec_bz)

	return
	end
C----------------------------------


	subroutine br_bz_vec_c(
     *  vec_br,vec_bz)

	include 'double.inc'
	dimension  vec_br(*),vec_bz(*)

        include 'parf0'
        include 'parf1'
        include 'parf2'
        include 'parf2e'

	common
     *  /ge1/pi
     *  /ge5/kpr
	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nr),y(nz),dx,dy
     *  /eq1e/psext(nwnh),re(nre),ze(nze),dr,dz
     *  /eq3/FLUXARR(nwnh,kf)

	common
     *  /pf1/npf,pf(kf),pf0(kf)

        common
     *	/con1/gain,ta,zref,kzref
     *  /con2/rref,krref,bvert
     *  /con3/i_pf
     *  /con6/ind_r(2),ind_z(2)

        common
     *	/cont9/brad,kefit
     *  /cont13/zmag,zvel,delrmag,delzmag
     *  /cont13e/zmag0,rmag,rmag0,rvel

	common
     *	/fluxc6/pmag,pbound,psep,p_s,delaval,dr_h
     *	/fluxc7/coef,coef1,api
     *  /fluxc8/work(nwnhe)

	dimension pdd(6),pfhelp(kf)
	character *20 apr

	urr=rref
	vrr=zref

        if(kpr.eq.1)print*,'urr vrr',urr,vrr


c---Z stabilization---

	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i
	psext0=0.
	DO k=1,npf
	psext0=psext0+vec_br(k)*FLUXARR(kk,K)
	END DO
	work(kk1)=psext0*api
	end do
	end do

	call boxda(work,urr,vrr,pdd,ier)

        a_r=pdd(2)
        a_z=pdd(3)

c---R stabilization---

	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i
	psext0=0.
	DO k=1,npf
	psext0=psext0+vec_bz(k)*FLUXARR(kk,K)
	END DO
	work(kk1)=psext0*api
	end do
	end do

	call boxda(work,urr,vrr,pdd,ier)


        b_r=pdd(2)
        b_z=pdd(3)

        a11=a_z
        a12=b_z
        a21=a_r
        a22=b_r


        if(kpr.eq.1)print*,'a11 a12 a21 a22',a11,a12,a21,a22


 1      continue

	ksep=-1
	rmag=urr
	zmag=vrr

	call spoint(ksep,xw,yw,fint,rmag,zmag,pmag,
     *  rsep,zsep,psep,rsep1,zsep1,psep1)

	if(kpr.eq.1)print *,' rmag zmag pmag',rmag,zmag,pmag

	call boxd(urr,vrr,pdd,ier)
c---------------
	psi_r=pdd(2)
	psi_z=pdd(3)
c-------------------
	brad=-psi_z
	bvert=-psi_r
        if(kpr.eq.1)print*,'from br_bz_vec'
        if(kpr.eq.1)print *,' brad bvert ',brad,bvert

        f1=brad
        f2=bvert

	call mat_prep(a11,a12,a21,a22,f1,f2,x1,x2)

        if(kpr.eq.1)print *,' x1 x2 api ',x1,x2,api

        f1_c=a11*x1+a12*x2
        f2_c=a21*x1+a22*x2

        if(kpr.eq.1)print *,' f1_c f1 ',f1_c,f1
        if(kpr.eq.1)print *,' f2_c f2 ',f2_c,f2

c ----->
	do i=1,nr
	do j=1,nz

	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i

        psext0=0.
	DO k=1,npf
	psext0=psext0+x2*vec_bz(k)*FLUXARR(kk,K)
	psext0=psext0+x1*vec_br(k)*FLUXARR(kk,K)
	END DO

	work(kk1)=psext0*api
      	psi(i,j)=psi(i,j)+work(kk1)

	end do
	end do

	call boxda(work,urr,vrr,pdd,ier)

        if(kpr.eq.1)print *,' pdd2 pdd3',pdd(2),pdd(3)

	ksep=-1
	rmag=urr
	zmag=vrr

	call spoint(ksep,xw,yw,fint,rmag,zmag,pmag,
     *  rsep,zsep,psep,rsep1,zsep1,psep1)

	if(kpr.eq.1)print *,' rmag zmag pmag',rmag,zmag,pmag

	call boxd(urr,vrr,pdd,ier)
c---------------
	psi_r=pdd(2)
	psi_z=pdd(3)
c-------------------
	brad=-psi_z
	bvert=-psi_r

        if(kpr.eq.1)print *,' brad bvert ',brad,bvert

        if(kpr.eq.1)print*,'x_br x_bz',x1,x2

	DO k=1,npf
	   pf_k=pf(k)
	   del_pf2=x2*vec_bz(k)
           pf(k)=pf(k)+del_pf2
	   del_pf1=x1*vec_br(k)
           pf(k)=pf(k)+del_pf1

           if(kpr.eq.1.and.(vec_br(k).gt.0.1.or.vec_bz(k).gt.0.1))
     * print *,' k pf0 pf del_r del_z ',k,pf0(k),pf(k),del_pf1,del_pf2

	END DO

71	format(20x,a6/,(6(1pe10.3)))


	ksep=-1

	call spoint(ksep,xw,yw,fint,rmag,zmag,pmag,
     *  rsep,zsep,psep,rsep1,zsep1,psep1)

	if(kpr.eq.1)print *,' ---rmag rref',rmag,rref
	if(kpr.eq.1)print *,' ---zmag zref',zmag,zref


	call boxd(rmag,zmag,pdd,ier)
c---------------
	psi_r=pdd(2)
	psi_z=pdd(3)
c-------------------
	brad=-psi_z
	bvert=-psi_r

      if(kpr.eq.1)print *,' brad bvert ',brad,bvert




        return
        end




	subroutine br_bz_ves()
	include 'double.inc'
	include 'new_com.inc'

 	call br_bz_ves_c(
     *  ves_br,ves_bz)

	return
	end
C----------------------------------


	subroutine br_bz_ves_c(
     *  ves_br,ves_bz)

	include 'double.inc'
	dimension  ves_br(*),ves_bz(*)

        include 'parf0'
        include 'parf1'
        include 'parf2'
        include 'parf2e'

	common
     *  /ge1/pi
     *  /ge5/kpr
	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nr),y(nz),dx,dy
     *  /eq1e/psext(nwnh),re(nre),ze(nze),dr,dz
     *  /eq10/vesarr(nwnh,mu)

        common
     *  /ves1/psp(mu),psp0(mu),tcam(mu),tcam0(mu)
     *  /ves2/ncam,rc(mu),zc(mu)
     *  /ves9/tokc,tokc0

        common
     *	/con1/gain,ta,zref,kzref
     *  /con2/rref,krref,bvert
     *  /con3/i_pf
     *  /con6/ind_r(2),ind_z(2)

        common
     *	/cont9/brad,kefit
     *  /cont13/zmag,zvel,delrmag,delzmag
     *  /cont13e/zmag0,rmag,rmag0,rvel

	common
     *	/fluxc6/pmag,pbound,psep,p_s,delaval,dr_h
     *	/fluxc7/coef,coef1,api
     *  /fluxc8/work(nwnhe)

	dimension pdd(6),pfhelp(kf)
	character *20 apr


      i_en=i_en+1
      
      if(i_en.eq.1)then
      
      ncam1=100
      
	open (unit=41,file='vv_100.dat',form='formatted')

	read (41,*)

	do i=1,ncam1
	   read (41,*)ves_br(i),ves_bz(i)
        if(kpr.eq.1)
     *	 write(6,'(" i ves_br(i),ves_bz(i)  ", i4,1x,5(1pe13.6))'),
     *  i,ves_br(i),ves_bz(i)

	end do

	close (41)
      
      end if
      

	urr=rref
	vrr=zref

c---Z stabilization---

	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i
	psext0=0.
	DO k=1,ncam1
	psext0=psext0+ves_br(k)*vesarr(kk,K)
	END DO
	work(kk1)=psext0*api
	end do
	end do

	call boxda(work,urr,vrr,pdd,ier)

        a_r=pdd(2)
        a_z=pdd(3)

c---R stabilization---

	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i
	psext0=0.
	DO k=1,ncam1
	psext0=psext0+ves_bz(k)*vesarr(kk,K)
	END DO
	work(kk1)=psext0*api
	end do
	end do

	call boxda(work,urr,vrr,pdd,ier)


        b_r=pdd(2)
        b_z=pdd(3)

        a11=a_z
        a12=b_z
        a21=a_r
        a22=b_r


        if(kpr.eq.1)print*,'a11 a12 a21 a22',a11,a12,a21,a22


 1      continue

	ksep=-1
	rmag=urr
	zmag=vrr

	call spoint(ksep,xw,yw,fint,rmag,zmag,pmag,
     *  rsep,zsep,psep,rsep1,zsep1,psep1)

	if(kpr.eq.1)print *,' rmag zmag pmag',rmag,zmag,pmag

	call boxd(urr,vrr,pdd,ier)
c---------------
	psi_r=pdd(2)
	psi_z=pdd(3)
c-------------------
	brad=-psi_z
	bvert=-psi_r
	
        if(kpr.eq.1)print*,'from br_bz_vec'
        if(kpr.eq.1)print *,' brad bvert ',brad,bvert

        f1=brad
        f2=bvert

	call mat_prep(a11,a12,a21,a22,f1,f2,x1,x2)

        if(kpr.eq.1)print *,' x1 x2 api ',x1,x2,api

        f1_c=a11*x1+a12*x2
        f2_c=a21*x1+a22*x2

        if(kpr.eq.1)print *,' f1_c f1 ',f1_c,f1
        if(kpr.eq.1)print *,' f2_c f2 ',f2_c,f2

c ----->
	do i=1,nr
	do j=1,nz

	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i

        psext0=0.
	DO k=1,ncam1
	psext0=psext0+x2*ves_bz(k)*vesarr(kk,K)
	psext0=psext0+x1*ves_br(k)*vesarr(kk,K)
	END DO

	work(kk1)=psext0*api
      	psi(i,j)=psi(i,j)+work(kk1)

	end do
	end do

	call boxda(work,urr,vrr,pdd,ier)

        if(kpr.eq.1)print *,' pdd2 pdd3',pdd(2),pdd(3)

	ksep=-1
	rmag=urr
	zmag=vrr

	call spoint(ksep,xw,yw,fint,rmag,zmag,pmag,
     *  rsep,zsep,psep,rsep1,zsep1,psep1)

	if(kpr.eq.1)print *,' rmag zmag pmag',rmag,zmag,pmag

	call boxd(urr,vrr,pdd,ier)
c---------------
	psi_r=pdd(2)
	psi_z=pdd(3)
c-------------------
	brad=-psi_z
	bvert=-psi_r

        if(kpr.eq.1)print *,' brad bvert ',brad,bvert

        if(kpr.eq.1)print*,'x_br x_bz',x1,x2

      tcam_bz=0.
      tcam_br=0.
      
	DO k=1,ncam1
	   pf_k=tcam(k)
	   del_pf2=x2*ves_bz(k)
           tcam(k)=tcam(k)+del_pf2
           tcam_bz=tcam_bz+del_pf2
	   del_pf1=x1*ves_br(k)
           tcam(k)=tcam(k)+del_pf1
           tcam_br=tcam_br+del_pf2

           if(kpr.eq.-1)
!     * print *,' k pf0 pf del_r del_z ',k,tcam0(k),tcam(k),del_pf1,del_pf2
     *	 write(6,'(" k t0 tcam del_r del_z  ", i4,1x,5(1pe13.6))'),
     *  k,tcam0(k),tcam(k),del_pf1,del_pf2

	END DO

        if(kpr.eq.1)print*,'tcam_br tcam_bz',tcam_br,tcam_bz
        if(kpr.eq.1)print*,'tokc tokc0',tokc,tokc0


71	format(20x,a6/,(6(1pe10.3)))


	ksep=-1

	call spoint(ksep,xw,yw,fint,rmag,zmag,pmag,
     *  rsep,zsep,psep,rsep1,zsep1,psep1)

	if(kpr.eq.1)print *,' ---rmag rref',rmag,rref
	if(kpr.eq.1)print *,' ---zmag zref',zmag,zref


	call boxd(rmag,zmag,pdd,ier)
c---------------
	psi_r=pdd(2)
	psi_z=pdd(3)
c-------------------
	brad=-psi_z
	bvert=-psi_r

      if(kpr.eq.1)print *,' brad bvert ',brad,bvert


      return
      end



	subroutine psi_g_c(key)
	include 'double.inc'
        include 'parf2'
    	common
     *	/n_m/n,m,mp
     	common
     *  /eq1g/psi_g(nr,nz)
     *  /ge5/kpr

     	dimension psi_g_help(nr,nz)

	character *20 apr


      if(kpr.eq.1)print *,' key===',key
      

      if(key.eq.1)then
      do i=1,nr
      do j=1,nz
      
      psi_g_help(i,j)=psi_g(i,j)
      
      end do
      end do
      else

      do i=1,nr
      do j=1,nz
      
      psi_g(i,j)=psi_g_help(i,j)
      
      end do
      end do
      
      end if

      return
      end
      
      
