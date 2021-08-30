	subroutine ptoke1()
	include 'double.inc'
	include 'new_com.inc'

	call ptoke1_c(f_jp,i_bound,rmag,zmag,
     * 	pptab,fptab)
	return
	end

	subroutine ptoke1_c(f,i_bound,rmag,zmag,
     * 	pptab,fptab)
     
	include 'double.inc'
        include 'parf0'
        include 'parf2'
	common
     *	/n_m/n,m,mp
	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nn),y(MM),dx,dy
     *  /eq1g/psi_g(nr,nz)
     *  /eq8/jbound,xbound(ntet),ybound(ntet),alfa0
     *  /eq15/pll,zsep,rsep,zsepup,rsepup,zsepdw,rsepdw
	common
     *  /pol4/ UM,VM,UK(ntet),VK(ntet)
     *  /pol5/psend
     *  /pol6/ppx(npo),pffx(npo)
	common
     *  /ge1/pi
     *	/ge1e/rs0,tpl
     *  /ge2/NTAY,TAY,TT
     *  /ge3/AI(npo),poA0(npo),HA2(npo),poa(npo),ha(npo)
     *  /ge4/EPS1,EPS2,EPS0
     *  /ge5/kpr

     *  /c_ge5/ksepa 

	common
     *	/fluxc2/delta0,pom(ntet)
     *	/fluxc6/pmag,pbound,psep,p_s,delaval,dr_h
     *	/fluxc7/coef,coef1,api
     *  /fluxc9/fdd,fdd0

	common
     *	/point1/r0,z0
	common
     *  /halo4/expfg,avalb,w_h,del_r,al0
     *  /halo4e/w_h0,delaval0,pshalo0,te_h0
     *  /halo5e/pshalo
     *  /halo15/e_sep,nsep
	common
     *  /eq11/psval(npo),psval0(npo)
	common
     *	/keys1/i_graph
     *	/keys2/key_b
     *  /keys11/i_ramp
	common
     *	/efit5/it1,it2
        common
     *  /ves9/tokc,tokc0
	common
     *  /ef_0/key_ef
     *  /cont4/ZPP,RPP,WVSPIP,ZXP,ELP,SHAPE,GAPINP,
     *  DFZP, DFZP0

c----------
	dimension f(nwnh)
	dimension pspl_temp(nwnh)                                      

	dimension pptab(*),fptab(*)

	delta0=1.2*sqrt(dx**2+dy**2)
	COEF=10./(4.*PI)
	api=1./(2.*pi)

c--- calc. pspl boundary...  
	i_bound=i_bound+1

!!!	i_old=1
	i_old=0

c	i_bound=1

	nw_h=10
	n1=nr-1
	m1=nz-1
c------------------------------------
c calc.psi(i,j)
	if(kpr.eq.1)print *,' call to psi_tot--'

c	call bz_calc()

	   do i=1,nwnh                                                         
	      pspl_temp(i)=pspl(i)                                            
	   end do                                                              

	call psi_tot()

	do i=1,nr
	do j=1,nz
	psi_g(i,j)=psi(i,j)
	end do
	end do

	um=rmag
	vm=zmag


c   call to plasma-limiter contact...
	if(kpr.eq.1)print *,' call to pom_lim--'
	call pom_lim()
c--------------------------
c calc. boundary values...
	if(kpr.eq.1)print *,' call to psi_b--'
	call psi_b(psep,rsep,zsep,ksepa)
	if(kpr.eq.1)print *,'  psep rsep zsep',psep,rsep,zsep
	
	call second_sep()  

c---------------------
c for fluxcont.r0 and z0 used in (subr. sort)
	r0=um
	z0=vm
	delaval=pmag-psep
c	e_sep=5.e-3

      if(ksepa.eq.1)then
	pbound=psep+e_sep*delaval
	else
	pbound=psep+e_sep*delaval
!!!	pbound=psep+1.e-3*delaval	
	end if
	
	if(kpr.eq.1)print *,' pmag psep pbound',pmag,psep,pbound
c-------
c calc. plasma boundary coordinates...
	call bound_coor()
	if(kpr.eq.1)print *,' end bound_coor--'
c  calc. pll dr_h bpbound...
	call pl_integ()

	call psi_plb()


c	call pl_inte()
c	call fdd_pf()
c	call pll_new()
	if(kpr.eq.1)print *,' end pl_integr   TOKC',tokc
c----------------------------------------<<<<

	call bunem_coef()

	psval(1)=pmag
	do i=2,n
!!1	psval(i)=pmag+poa(i)**2*(p_s-pmag)
	psval(i)=pmag+poa(i)**2*(pbound-pmag)
	end do

c	call v_sec()

	psend=(psval(n)-psval(1))*2.*pi*2.*ai(n)
	psval(n+1)=pbound

c-------
c calc. plasma current density...
	call cur_dens(n,al1,f)
c
	coef1=al1*dx*dy*coef
c-------
c  calc. flux from plasma to vessel,PF loops and probes...
	call pl_out(f)

c---------------
c--- calc. pspl boundary...
	if(key_b.eq.1)call  pspl_b1(f)
	if(key_b.eq.2.and.i_old.eq.1)call  pspl_b2(al1,f)

	   if(kpr.eq.1)print *,' i_old i_bound key_b==',
     *  i_old,i_bound,key_b

	if(i_old.eq.0)then
	if(i_bound.eq.1.and.key_b.eq.2)then
	   call bndmat()
c	   call ves_bnd_green()
	end if

	call g_calc(al1,f)
	call bound_pet()
	call b_temp()

	end if

c------------------
c  calc. psi_plasma - pspl...
	call psi_pl(al1,f,errm)
	it1=0
	if(errm.gt.eps2)it1=1
c
	if(kpr.eq.1)print *,'error_max eps2 ',errm,eps2
	
	if(it1.eq.0)print *,'error_max eps2 al1 ',errm,eps2,al1
c
	alfa0=alfa0*al1

	do i=1,n
	ppx(i)=ppx(i)*al1
	pffx(i)=pffx(i)*al1

	pptab(i)=pptab(i)*al1
	fptab(i)=fptab(i)*al1

	end do

c        fdd_1=fdd
c	fdd=2.*pi*psval(n)-pll*tpl
c        if(kpr.eq.1)print *,' psval p_s',psval(n)*1.e-5,p_s*1.e-5
c        if(kpr.eq.1)print *,' fdd FDD ==',fdd_1*1.e-5,fdd*1.e-5

c!!!	if(abs(del_r).gt.1.e-1)call bound_hcoor()

c	if(abs(del_r).gt.1.e-1.and.ntay.gt.0)
c     *  call bound_h2()

!      	call psi_pl_test(f,pspl)

	   do i=1,nwnh   
	      pspl(i)=0.5d0*(pspl_temp(i)+pspl(i))
         end do

!      	call psi_pl_test(f,pspl)

	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	psi(i,j)=psi_g(i,j)
	end do
	end do




71	format(20x,a6/,(6(1pe10.3)))
	return
	end



	subroutine br_bz_new()
	include 'double.inc'
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

c---Z stabilization---

        if(kpr.eq.1)print *,' ind_z ',ind_z(1),ind_z(2)
        if(kpr.eq.1)print *,' ind_r ',ind_r(1),ind_r(2)

	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i
	psext0=0.
	DO k=1,npf
	if(k.eq.ind_z(1))psext0=psext0+FLUXARR(kk,K)
	if(k.eq.ind_z(2))psext0=psext0-FLUXARR(kk,K)
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
	if(k.eq.ind_r(1))psext0=psext0+FLUXARR(kk,K)
	if(k.eq.ind_r(2))psext0=psext0+FLUXARR(kk,K)
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
	if(k.eq.ind_z(1))psext0=psext0+x1*FLUXARR(kk,K)
	if(k.eq.ind_z(2))psext0=psext0-x1*FLUXARR(kk,K)

	if(k.eq.ind_r(1))psext0=psext0+x2*FLUXARR(kk,K)
	if(k.eq.ind_r(2))psext0=psext0+x2*FLUXARR(kk,K)


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

	DO k=1,npf

	if(k.eq.ind_z(1))then
	   pf_k=pf(k)
           pf(k)=pf(k)+x1
           if(kpr.eq.1)print *,' k pf_k pf(k)',k,pf_k,pf(k)
        end if
	if(k.eq.ind_z(2))then
	   pf_k=pf(k)
           pf(k)=pf(k)-x1
           if(kpr.eq.1)print *,' k pf_k pf(k)',k,pf_k,pf(k)
        end if


	if(k.eq.ind_r(1))then
c vic Naka 1999
           pf(k)=0.
c vic Naka 1999
	   pf_k=pf(k)
           pf(k)=pf(k)+x2
           if(kpr.eq.1)print *,' k pf_k pf(k)',k,pf_k,pf(k)
        end if
	if(k.eq.ind_r(2))then
c vic Naka 1999
           pf(k)=0.
c vic Naka 1999
	   pf_k=pf(k)
           pf(k)=pf(k)+x2
           if(kpr.eq.1)print *,' k pf_k pf(k)',k,pf_k,pf(k)
        end if

	END DO

71	format(20x,a6/,(6(1pe10.3)))


	ksep=-1

	call spoint(ksep,xw,yw,fint,rmag,zmag,pmag,
     *  rsep,zsep,psep,rsep1,zsep1,psep1)

	if(kpr.eq.1)print *,' ---rmag zmag pmag',rmag,zmag,pmag

        return
        end

	subroutine br_bz()
	include 'double.inc'
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

c	rref=626.1
c	zref=55.1
c	if(kpr.eq.1)print*,'rref zref',rref,zref
c	pause 'from br_bz'


	urr=rref
c	urr=rmag
	vrr=zref
c	vrr=zmag

c---Z stabilization---

        if(kpr.eq.1)print *,' ind_z 1',ind_z(1)
        if(kpr.eq.1)print *,' ind_r 1',ind_r(1)

	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i
	psext0=0.
	DO k=1,npf
	   if(k.eq.ind_z(1)) psext0=psext0+FLUXARR(kk,K)
	END DO
	work(kk1)=psext0*api
!	if(kpr.eq.1)print *,' kk1 work',kk1,work(kk1)
	end do
	end do

	call boxda(work,urr,vrr,pdd,ier)

        a_r=pdd(2)
        a_z=pdd(3)

	if(kpr.eq.1)print *,' api a_r a_z',api,a_r,a_z

c---R stabilization---

	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i
	psext0=0.
	DO k=1,npf
	if(k.eq.ind_r(1))psext0=psext0+FLUXARR(kk,K)
	END DO
	work(kk1)=psext0*api
	end do
	end do

	call boxda(work,urr,vrr,pdd,ier)


        b_r=pdd(2)
        b_z=pdd(3)

	if(kpr.eq.1)print *,' b_r b_z',b_r,b_z

        a11=a_z
        a12=b_z
        a21=a_r
        a22=b_r

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
	if(k.eq.ind_z(1))psext0=psext0+x1*FLUXARR(kk,K)

	if(k.eq.ind_r(1))psext0=psext0+x2*FLUXARR(kk,K)

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

	DO k=1,npf

	if(k.eq.ind_z(1))then
           pf(k)=pf(k)+x1
           if(kpr.eq.1)print *,' k pf0(k) pf(k)',k,pf0(k),pf(k)
        end if


	if(k.eq.ind_r(1))then
           pf(k)=pf(k)+x2
           if(kpr.eq.1)print *,' k pf0(k) pf(k)',k,pf0(k),pf(k)
        end if

	END DO

71	format(20x,a6/,(6(1pe10.3)))


	ksep=-1

	call spoint(ksep,xw,yw,fint,rmag,zmag,pmag,
     *  rsep,zsep,psep,rsep1,zsep1,psep1)

	if(kpr.eq.1)print *,' ---rmag zmag pmag',rmag,zmag,pmag

	if(abs(brad).gt.5.e-2)go to 1
	if(abs(bvert).gt.5.e-2)go to 1


        return
        end

        subroutine q_calc()
c
	include 'double.inc'
        include 'parf0'
        include 'parf2'
	common
     *  /ge1/pi
     *	/ge1e/rs0,tpl
     *  /ge5/kpr
	common
     *	/n_m/n,m,mp
	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nr),y(nz),dx,dy
	common
     *	/fluxc1/xp1(50,mu1),yp1(50,mu1)
     *  /fluxc2/delta0,pom(ntet)
     *  /fluxc4/mcurve,x11(mu1),y11(mu1)
        common
     *  /eq11/psval(npo),psval0(npo)
        common
     *  /pol6/ppx(npo),pffx(npo)
        common
     *  /dfm7/bt0,uind
        common
     *  /graf2/q_99
	common
     *  /halo5/q_vde,q_95,del_f,i_halo

        dimension ind1(50),f8(npo),dhal(mu1),dint2(mu1),q8(npo)

	dimension pdd(6)

	character *20 apr

        nrad=n

        f8(nrad)=bt0

	fsqrt0=f8(nrad)**2
	i=nrad
	ps_1=0.5*(psval(i)+psval(i-1))
	nrad1=nrad-1
	do i0=2,nrad1
	i=nrad1-i0+2
	fprime=-pffx(i)
	ps_0=ps_1
	ps_1=0.5*(psval(i)+psval(i-1))
	psi_i=ps_0-ps_1
	fsqrt=fsqrt0-fprime*psi_i/rs0
	fsqrt0=fsqrt
	f8(i)=sqrt(fsqrt)
	end do

        apr= 'f8 '
        if(kpr.eq.1)print 71,apr,(f8(i),i=2,nrad)

71	format(20x,a6/,(6(1pe10.3)))
c----------------------------
        do ii=1,2

c        do ii=1,nrad

c        aval=psval(ii)

        if(ii.eq.1)aval=psval(1)-0.95*(psval(1)-psval(n))
        if(ii.eq.2)aval=psval(1)-0.99*(psval(1)-psval(n))

        call feet_p(nrad,f8,f8_i,psval,aval)
	if(kpr.eq.1)print *,'after feet_p'
c
	do i0=1,5
	ind1(i0)=0
	end do
c
	dcur=1.e-11*(abs(aval)+1.)
	call fluxcont(nn,mm,PSI,aval,x,y,xp1,yp1,num,ind1,delta0,dcur)
	if(kpr.eq.1)print *,'after fluxcont'
	i=1
	mcurve=ind1(i)
      DO  J=1,mcurve
      x11(J)=xp1(i,j)
      y11(J)=yp1(i,j)
	end do
	k=0
        do j=1,mcurve
c
	k=k+1
        urr=x11(j)
        vrr=y11(j)

        if(j.gt.1)dhal(j)=sqrt( (x11(j)-x11(j-1))**2+(y11(j)-
     *  y11(j-1))**2 )

	call boxd(urr,vrr,pdd,ier)
	gradpsi=sqrt( pdd(2)**2+pdd(3)**2 )

c!!!	if(kpr.eq.1)print *,'after boxd, gradpsi urr',gradpsi,urr

	psi_r=pdd(2)
	psi_z=pdd(3)
c
	dint0=1./(2.*pi*urr)
	dint2(j)=dint0/gradpsi
c
	end do

	c3_i=0.
        do j=2,mcurve
        c3_i=c3_i+0.5*(dint2(j)+dint2(j-1))*dhal(j)
	end do

c        pfi=2.*pi*rs0*c3_i*f8_i
        pfi=rs0*c3_i*f8_i
	q_i=pfi
        q8(ii)=q_i

        if(kpr.eq.1)print *,' ii f8_i q_i',ii,f8_i,q_i

c        if(kpr.eq.1)print *,' x11 1 mcurve===',x11(1),x11(mcurve)
c        if(kpr.eq.1)print *,' y11 1 mcurve===',y11(1),y11(mcurve)
c	if(kpr.eq.1)print *,' q_i===',q_i
        if(ii.eq.1)q_95=q_i
        if(ii.eq.2)q_99=q_i

        end do

        do i=6,nrad
           q8(i)=0.5*(q8(i)+q8(i-1))
        end do

        apr= 'q8 '
        if(kpr.eq.1)print 71,apr,(q8(i),i=2,nrad)
c
	return
	end

	subroutine v_sec()
	include 'double.inc'
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
     *  /eq11/psval(npo),psval0(npo)

     *  /eq10/vesarr(nwnh,mu)                                           
     *  /ves2/ncam,rc(mu),zc(mu)                                        

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
     *  /fluxc13/volt_sec(kf)
     *  /fluxc14/vs_pf,vs_pl,vs_tot

      common                                     
     *  /c_ktm_2/vs_res,vs_ext

	dimension pdd(6)
	character *20 apr

	urr=rmag
	vrr=zmag

	v_tot=0.
	do k=1,npf

	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i
	psext0=FLUXARR(kk,K)
	work(kk1)=psext0
	END DO
	end do

	call boxda(work,urr,vrr,pdd,ier)
	volt_sec(k)=pdd(1)*pf(k)*1.e-5
	v_tot=v_tot+volt_sec(k)
	end do

	vs_pf=v_tot

	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i
	work(kk1)=pspl(kk)*2.*pi
	END DO
	end do

	call boxda(work,urr,vrr,pdd,ier)
	vs_pl=pdd(1)*1.e-5
	vs_tot=2.*pi*psval(1)*1.e-5

	call boxd(urr,vrr,pdd,ier)
        vs_tot=2.*pi*pdd(1)*1.e-5

      

        vs_tot1=vs_pf+vs_pl
	if(kpr.eq.1)print *,' vs_pf vs_pl ',vs_pf,vs_pl
	if(kpr.eq.1)print *,' vs_tot1 vs_tot',vs_tot1,vs_tot


71	format(20x,a6/,(6(1pe10.3)))



	call psi_tot_br()    

	do i=1,nr                                                              
	do j=1,nz                                                              
	kk=(i-1)*nz+j                                                          
	kk1=(j-1)*nr+i                                                         
	work(kk1)=psext(kk)*2.d0*pi                                               
	END DO                                                                 
	end do                                                                 
                                                                        
	call boxda(work,urr,vrr,pdd,ier)                                       
	vs_ext=pdd(1)*1.e-5                                                     

      if(abs(vs_tot).le.1.e-5)vs_tot=vs_ext

                                                                        
	do i=1,nr                                                              
	do j=1,nz                                                              
	kk=(i-1)*nz+j                                                          
	kk1=(j-1)*nr+i                                                         
	work(kk1)=pspl(kk)*2.*pi                                               
	END DO                                                                 
	end do                                                                 
                                                                        
	call boxda(work,urr,vrr,pdd,ier)                                       
	vs_pl=pdd(1)*1.e-5                                                     


        return
        end

	subroutine psi_tot_br()
	include 'double.inc'
	include 'new_com.inc'                                                  
              
        dimension p_pl(nr,nz)
                                                          
	call psi_tot_br_c(  
     *  p_pl,i_bound,k_efit)    
                                                                        
	return                                                                 
	end                                                                    
                                                                        
                                                                        
	subroutine psi_tot_br_c(                                                  
     *  p_pl,i_bound,k_efit)

        include 'double.inc'  

        include 'parf0'                                                 
        include 'parf1'                                                 
        include 'parf2'                                                 
        include 'parf2e'                                                
                                                                        
	common                                                                 
     *  /ge1/pi                                                         
     *  /ge5/kpr                                                        
     *  /ge7/eu,rout,zout,elong                                         
	common                                                                 
     *  /pf1/npf,pf(kf),pf0(kf)                                         
	common                                                                 
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nr),y(nz),dx,dy                    
     *  /eq1e/psext(nwnh),re(nre),ze(nze),dr,dz                         
     *  /eq1g/psi_g(nr,nz)                                              
     *  /ge2/NTAY,TAY,TT                                                
     *  /eq3/FLUXARR(nwnh,kf)                                           
     *  /eq10/vesarr(nwnh,mu)                                           
     *  /eq12/omega,pspl0(nwnh)                                         
	common                                                                 
     *	/cont9/brad,kefit                                                
     *  /cont13/zmag,zvel,delrmag,delzmag                               
     *  /cont13e/zmag0,rmag,rmag0,rvel                                  
	common                                                                 
     *  /ves1/psp(mu),psp0(mu),tcam(mu),tcam0(mu)                       
     *  /ves2/ncam,rc(mu),zc(mu)                                        
	common                                                                 
     *  /pol4/ UM,VM,UK(ntet),VK(ntet)                                  
	common                                                                 
     *	/fluxc6/pmag,pbound,psep,p_s,delaval,dr_h                        
     *	/fluxc7/coef,coef1,api                                           
        common                                                          
     *	/con1/gain,ta,zref,kzref                                         
     *  /con2/rref,krref,bvert                                          
     *  /con3/i_pf                                                      
	common                                                                 
     *  /keys9/i_d3d,i_iter,i_smal                                      
     *  /keys15/i_br                                                    
                                                                        
	common                                                                 
     *	/fluxc8/work(nwnhe)                                              
                                                                        
	dimension pdd(6),pfhelp(kf),yh(nz)                                     
                                                                        
	dimension p_pl(nr,nz)                                                  
                                                                        
	real *8 psext0,pscam                                                   
                                                                        
	character *30 apr     
	                                                 
	dimension a_print(200),psi_fer(nr,nz)

c=========================================                              
                                                                        
cccc	call brad_ctest()                                                  
	api=1./(2.*pi)                                                         
                                                                                                                                                
	do i=1,nr                                                              
	do j=1,nz                                                              
C                                                                       
	kk=(i-1)*nz+j                                                          
                                                                        
	PSEXT0=0.                                                              
c                                                                       
	DO K=1,NPF                                                             
	psext0=psext0+PF(K)*FLUXARR(kk,K)                                      
	END DO                                                                 
c                                                                       
	pscam=0.                                                               
	DO K=1,ncam                                                            
	pscam=pscam+tcam(K)*vesarr(kk,K)                                       
	END DO                                                                 
	psext0=psext0+pscam                                                    
                                                                        
	PSEXT(kk)=PSEXT0*api                                                   
                                                                        
	end do                                                                 
	end do                                                                 

                                                                        
	return                                                                 
	end                                                                    

	subroutine brad_pf()
	include 'double.inc'
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

	urr=rmag
	vrr=zref

c---Z stabilization---

        if(kpr.eq.1)print *,' ind_z ',ind_z

	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i
	psext0=0.
	DO k=1,npf
	if(k.eq.ind_z(1))psext0=psext0+FLUXARR(kk,K)
	if(k.eq.ind_z(2))psext0=psext0-FLUXARR(kk,K)
	END DO
	work(kk1)=psext0*api
	end do
	end do

	call boxda(work,urr,vrr,pdd,ier)

        a_z=pdd(3)

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
	
	x1=brad/a_z

        if(kpr.eq.1)print *,' brad bvert x1 ',brad,bvert,x1


c ----->
	do i=1,nr
	do j=1,nz

	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i

        psext0=0.
	DO k=1,npf
	if(k.eq.ind_z(1))psext0=psext0+x1*FLUXARR(kk,K)
	if(k.eq.ind_z(2))psext0=psext0-x1*FLUXARR(kk,K)
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

	DO k=1,npf

	if(k.eq.ind_z(1))then
           pf(k)=pf(k)+x1
           if(kpr.eq.1)print *,' k pf0(k) pf(k)',k,pf0(k),pf(k)
        end if

	if(k.eq.ind_z(2))then
           pf(k)=pf(k)-x1
           if(kpr.eq.1)print *,' k pf0(k) pf(k)',k,pf0(k),pf(k)
        end if

	END DO

71	format(20x,a6/,(6(1pe10.3)))


	ksep=-1

	call spoint(ksep,xw,yw,fint,rmag,zmag,pmag,
     *  rsep,zsep,psep,rsep1,zsep1,psep1)

	if(kpr.eq.1)print *,' ---rmag zmag pmag',rmag,zmag,pmag


        return
        end

	subroutine index_calc()
	include 'double.inc'
	include 'new_com.inc'

	call index_calc_c(
     *  bzz_pl,bz_pl)

	return
	end

	subroutine index_calc_c(
     *  bzz_pl,bz_pl)

	include 'double.inc'
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

        common
     *  /cont13/zmag,zvel,delrmag,delzmag
     *  /cont13e/zmag0,rmag,rmag0,rvel
	common
     *  /fluxc8/work(nwnhe)
     *  /fluxc17/f_index

	dimension pdd(6)
	character *20 apr


	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i
	psext0=psext(kk)
	work(kk1)=psext0
	END DO
	END DO

	urr=rmag
	vrr=zmag
	call boxda(work,urr,vrr,pdd,ier)

	psi_r=pdd(2)
	bz_ext=psi_r/urr

	if(abs(bz_ext).lt.1.e-8)then
	   if(bz_ext.lt.0)bz_ext=-1.e-8
	   if(bz_ext.ge.0)bz_ext=1.e-8
	end if

        f_index=-urr/bz_ext*(pdd(5)/urr-pdd(2)/urr**2)

	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i
	psext0=pspl(kk)
	work(kk1)=psext0
	END DO
	END DO

	call boxda(work,urr,vrr,pdd,ier)

	psi_r=pdd(2)
	bz_pl=psi_r/urr
	bz_tot=bz_pl+bz_ext

	if(kpr.eq.1)print *,' bz_pl== bz_tot ',bz_pl,bz_tot


	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i
	psext0=psext(kk)
	work(kk1)=psext0
	END DO
	END DO


	do ii=1,4

	   d_r=0.
	   d_z=0.
	   if(ii.eq.1)d_r=5.
	   if(ii.eq.2)d_r=-5.
	   if(ii.eq.3)d_z=5.
	   if(ii.eq.4)d_z=-5.

	urr=rmag+d_r
	vrr=zmag+d_z

	call boxda(work,urr,vrr,pdd,ier)

	psi_r=pdd(2)
	bz_ext=psi_r/urr

	if(abs(bz_ext).lt.1.e-8)then
	   if(bz_ext.lt.0)bz_ext=-1.e-8
	   if(bz_ext.ge.0)bz_ext=1.e-8
	end if


	f_ind=-urr/bz_ext*(pdd(5)/urr-pdd(2)/urr**2)

	if(kpr.eq.1)print *,' ii bz_ext f_ind ',ii,bz_ext,f_ind

	end do

71	format(20x,a6/,(6(1pe10.3)))

        return
        end
	subroutine mag_ax(rmag,zmag,pmag)

	include 'double.inc'
        include 'parf0'
        include 'parf2'
        include 'parf2a'

	common
     *  /ge1/pi
     *  /ge5/kpr
	common
     *  /pol4/ UM,VM,UK(ntet),VK(ntet)
	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nr),y(nz),dx,dy

	dimension pdd(6)

	character *20 apr

c---------------

	r1=um-0.5*dx
	r2=um+0.5*dx

	if(kpr.eq.1)print *,' r1 um r2',r1,um,r2

	z1=vm-0.5*dy
	z2=vm+0.5*dy

	if(kpr.eq.1)print *,' z1 vm z2',z1,vm,z2

	d_x=dx/(n_r-1)
	d_y=dy/(n_z-1)

	pmag=-1.e10

	do i=1,n_r
	urr=r1+(i-1)*d_x
	do j=1,n_z
	vrr=z1+(j-1)*d_y
	call boxd(urr,vrr,pdd,ier)
	if(pdd(1).ge.pmag)then
	pmag=pdd(1)
	rmag=urr
	zmag=vrr
	end if

	end do
	end do

71	format(20x,a6/,(6(1pe10.3)))

        return
        end
	subroutine pfves_d3d()

	include 'double.inc'
        include 'parf1'

	common
     *  /ge1/pi
     *  /ge4/EPS1,EPS2,EPS0
     *  /ge4e/it_v,it_pf
     *  /ge5/kpr
	common
     *  /dop1/volt_sum,volt_tot(kf),volt_pl(kf),volt_ves(kf)
	common
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /pf1e/pfhelp(kf)
        common
     *  /ves1/psp(mu),psp0(mu),tcam(mu),tcam0(mu)
     *  /ves2/ncam,rc(mu),zc(mu)
     *  /ves1e/tcam_i(mu)
     *  /ves9/tokc,tokc0

	int_pf=0

	if(kpr.eq.1)print *,' EA EB==',pf(19),pf(20)
1999    continue
c

	do i=1,npf
	pfhelp(i)=pf(i)
	end do


	do i=1,ncam
	tcam_i(i)=tcam(I)
	end do
c------------
	call ful()
c	call pfcur_d3d()
	call pfcurrent()
c----------------

	do i=1,ncam
	tcam(i)=0.5*(tcam_i(i)+tcam(I))
	end do
c
	do i=1,npf
	pf(i)=0.5*(pfhelp(i)+pf(i))
	end do
c
	errp=0.

	do i=1,npf
	err=abs(pfhelp(i)-pf(i))/( abs(pf(i))+1.)
	if(err.ge.errp)errp=err
	end do

	do i=1,ncam
	err=abs(tcam_i(i)-tcam(i))/( abs(tcam(i))+1.)
	if(err.ge.errp)errp=err
	end do
c
	int_pf=int_pf+1
	if(int_pf.gt.15)then
	if(kpr.eq.1)
     *	print *,' int_pf errp tokc volt_sum',int_pf,errp,tokc,volt_sum
	end if

	if( errp.gt.1.e-3.and.int_pf.le.20 )go to 1999

	if(kpr.eq.1)print *,' EA EB==##',pf(19),pf(20)
	if(kpr.eq.1)
     *	print *,' int_pf errp tokc volt_sum',int_pf,errp,tokc,volt_sum



        return
        end

	subroutine pfves()

	include 'double.inc'
        include 'parf1'

	common
     *  /ge1/pi
     *  /ge4/EPS1,EPS2,EPS0
     *  /ge4e/it_v,it_pf
     *  /ge5/kpr
	common
     *  /dop1/volt_sum,volt_tot(kf),volt_pl(kf),volt_ves(kf)
	common
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /pf1e/pfhelp(kf)
        common
     *  /ves1/psp(mu),psp0(mu),tcam(mu),tcam0(mu)
     *  /ves2/ncam,rc(mu),zc(mu)
     *  /ves1e/tcam_i(mu)
     *  /ves9/tokc,tokc0

	int_pf=0

1999    continue
c
c	call bz_calc()

	do i=1,npf
	pfhelp(i)=pf(i)
	end do

	do i=1,ncam
	tcam_i(i)=tcam(I)
	end do
c------------
	call ful()
c	call pfcur_d3d()
	call pfcur()
c----------------

	do i=1,ncam
	tcam(i)=0.5*(tcam_i(i)+tcam(I))
	end do
c
	do i=1,npf
	pf(i)=0.5*(pfhelp(i)+pf(i))
	end do
c
	errp=0.

	do i=1,npf
	err=abs(pfhelp(i)-pf(i))/( abs(pf(i))+1.)
	if(err.ge.errp)errp=err
	end do

	do i=1,ncam
	err=abs(tcam_i(i)-tcam(i))/( abs(tcam(i))+1.)
	if(err.ge.errp)errp=err
	end do
c
	int_pf=int_pf+1
	if(int_pf.gt.15)then
	if(kpr.eq.1)
     *	print *,' int_pf errp tokc volt_sum',int_pf,errp,tokc,volt_sum
	end if

	if( errp.gt.1.e-3.and.int_pf.le.20 )go to 1999

	if(kpr.eq.1)
     *	print *,' int_pf errp tokc volt_sum',int_pf,errp,tokc,volt_sum

	if(kpr.eq.1)print *,' pf6 pf60==',pf(6),pf0(6)
	if(kpr.eq.1)print *,' pf6+9 pf60==',pf(6+9),pf0(6+9)


        return
        end
	subroutine brad_test()
	include 'double.inc'
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
     *  /eq12/omega,pspl0(nwnh)

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

	k=0
1	continue
	k=k+1

	ksep=-1

	call spoint(ksep,xw,yw,fint,rmag,zmag,pmag,
     *  rsep,zsep,psep,rsep1,zsep1,psep1)

	if(kpr.eq.1)print *,' rmag zmag pmag',rmag,zmag,pmag

	urr=rmag
	vrr=zref

	call boxd(urr,vrr,pdd,ier)
c---------------
	psi_r=pdd(2)
	psi_z=pdd(3)

	if(kpr.eq.1)print *,'  psi_z psi_r==',psi_z,psi_r

	brad=-psi_z

	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
c---
	psi(i,j)=psi(i,j)+brad*y(j)
c---
	end do
	end do

	return


	call boxd(urr,vrr,pdd,ier)
c---------------
	psi_r=pdd(2)
	psi_z=pdd(3)
	if(kpr.eq.1)print *,'  vrr psi_z psi_r==',vrr,psi_z,psi_r

c	if(k.lt.3)go to 1


	ksep=-1

	call spoint(ksep,xw,yw,fint,rmag,zmag,pmag,
     *  rsep,zsep,psep,rsep1,zsep1,psep1)

	if(kpr.eq.1)print *,' rmag zmag pmag',rmag,zmag,pmag

	urr=rmag
	vrr=zmag

	dzz=0.05
	vrr=vrr-5.*dzz
	do ii=1,10
	vrr=vrr+dzz
	if(ii.eq.10)vrr=zref
c
	call boxd(urr,vrr,pdd,ier)
c---------------
	psi_r=pdd(2)
	psi_z=pdd(3)
c-------------------
	brad=-psi_z
	bvert=-psi_r

        if(kpr.eq.1)print *,' vrr brad psi ',vrr,brad,pdd(1)*1.e-5

	end do

c	read (*,*)

c	stop

71	format(20x,a6/,(6(1pe10.3)))

        return
        end
c!!!	subroutine brad_vert_rus()
	subroutine brad_vert()
	include 'double.inc'
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

        if(kpr.eq.1)print *,' ind_r ',ind_r

	ksep=-1

	call spoint(ksep,xw,yw,fint,rmag,zmag,pmag,
     *  rsep,zsep,psep,rsep1,zsep1,psep1)

	if(kpr.eq.1)print *,' rmag zmag pmag',rmag,zmag,pmag

	urr=rref
	vrr=zmag

	call boxd(urr,vrr,pdd,ier)
c---------------
	psi_r=pdd(2)
	psi_z=pdd(3)
c-------------------
	brad=-psi_z
	bvert=-psi_r
        if(kpr.eq.1)print *,' brad bvert ',brad,bvert

        f2=bvert

c---R stabilization---

	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i
	psext0=0.
	DO k=1,npf
	if(k.eq.ind_r(1))psext0=psext0+FLUXARR(kk,K)
	if(k.eq.ind_r(2))psext0=psext0+FLUXARR(kk,K)
	END DO
	work(kk1)=psext0*api

	end do
	end do

	call boxda(work,urr,vrr,pdd,ier)


        b_r=pdd(2)
        b_z=pdd(3)


	x2=f2/b_r
c ----->
	do i=1,nr
	do j=1,nz

	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i

        psext0=0.
	DO k=1,npf

	if(k.eq.ind_r(1))psext0=psext0+x2*FLUXARR(kk,K)
	if(k.eq.ind_r(2))psext0=psext0+x2*FLUXARR(kk,K)
	END DO
	work(kk1)=psext0*api
cccc	psext(kk)=psext(kk)+psext0*api
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
c!!!	brad=-psi_z
	bvert=-psi_r

        if(kpr.eq.1)print *,' brad bvert ',brad,bvert

	DO k=1,npf

	if(k.eq.ind_r(1))then
           pf(k)=pf(k)+x2
           if(kpr.eq.1)print *,' k pf0(k) pf(k)',k,pf0(k),pf(k)
        end if

	if(k.eq.ind_r(2))then
           pf(k)=pf(k)+x2
           if(kpr.eq.1)print *,' k pf0(k) pf(k)',k,pf0(k),pf(k)
        end if

	END DO

71	format(20x,a6/,(6(1pe10.3)))

        return
        end
	subroutine brad_hor_it()
	include 'double.inc'
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

        if(kpr.eq.1)print *,' ind_z ',ind_z

	ksep=-1

	call spoint(ksep,xw,yw,fint,rmag,zmag,pmag,
     *  rsep,zsep,psep,rsep1,zsep1,psep1)

	if(kpr.eq.1)print *,' rmag zmag zref',rmag,zmag,rref

	urr=rmag
	vrr=zref

	call boxd(urr,vrr,pdd,ier)
c---------------
	psi_r=pdd(2)
	psi_z=pdd(3)
c-------------------
	brad_it=-psi_z
	bvert=-psi_r
        if(kpr.eq.1)print *,' brad_it bvert ',brad_it,bvert

        f2=bvert

c---R stabilization---


c  1 PF
	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i
	psext0=0.
	DO k=1,npf
	if(k.eq.ind_z(1))psext0=psext0+FLUXARR(kk,K)
	END DO
	work(kk1)=psext0*api

	end do
	end do

	call boxda(work,urr,vrr,pdd,ier)


        b_r1=pdd(2)
        b_z1=pdd(3)

c  2 PF
	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i
	psext0=0.
	DO k=1,npf
	if(k.eq.ind_z(2))psext0=psext0+FLUXARR(kk,K)
	END DO
	work(kk1)=psext0*api

	end do
	end do

	call boxda(work,urr,vrr,pdd,ier)


        b_r2=pdd(2)
        b_z2=pdd(3)

c--------  x1*b_r1+x2*b_r2=bvert
c--------  x1*b_z1+x2*b_z2=brad_it

	delt=(b_r1*b_z2-b_z1*b_r2)

	x1=(bvert*b_z2-brad_it*b_r2)/delt
	x2=(b_r1*brad_it-b_z1*bvert)/delt


c ----->
	do i=1,nr
	do j=1,nz

	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i

        psext0=0.
	DO k=1,npf

	if(k.eq.ind_z(1))psext0=psext0+x1*FLUXARR(kk,K)
	if(k.eq.ind_z(2))psext0=psext0+x2*FLUXARR(kk,K)
	END DO
	work(kk1)=psext0*api
cccc	psext(kk)=psext(kk)+psext0*api
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
	brad_it=-psi_z
	bvert=-psi_r

        if(kpr.eq.1)print *,' brad_it bvert ',brad_it,bvert

	DO k=1,npf

	if(k.eq.ind_z(1))then
           pf(k)=pf(k)+x1
           if(kpr.eq.1)print *,' k pf0(k) pf(k)',k,pf0(k),pf(k)
        end if

	if(k.eq.ind_z(2))then
           pf(k)=pf(k)+x2
           if(kpr.eq.1)print *,' k pf0(k) pf(k)',k,pf0(k),pf(k)
        end if

	END DO

71	format(20x,a6/,(6(1pe10.3)))

        return
        end
c!!!	subroutine brad_vert_rus()
	subroutine brad_vert_it()
	include 'double.inc'
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

        if(kpr.eq.1)print *,' ind_r ',ind_r

	ksep=-1

	call spoint(ksep,xw,yw,fint,rmag,zmag,pmag,
     *  rsep,zsep,psep,rsep1,zsep1,psep1)

	if(kpr.eq.1)print *,' rmag rref zmag ',rmag,rref,zmag

	urr=rref
	vrr=zmag

	call boxd(urr,vrr,pdd,ier)
c---------------
	psi_r=pdd(2)
	psi_z=pdd(3)
c-------------------
	brad_it=-psi_z
	bvert=-psi_r
        if(kpr.eq.1)print *,' brad_it bvert ',brad_it,bvert

        f2=bvert

c---R stabilization---


c  1 PF
	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i
	psext0=0.
	DO k=1,npf
	if(k.eq.ind_r(1))psext0=psext0+FLUXARR(kk,K)
	END DO
	work(kk1)=psext0*api

	end do
	end do

	call boxda(work,urr,vrr,pdd,ier)

        b_r1=pdd(2)
        b_z1=pdd(3)

c  2 PF
	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i
	psext0=0.
	DO k=1,npf
	if(k.eq.ind_r(2))psext0=psext0+FLUXARR(kk,K)
	END DO
	work(kk1)=psext0*api

	end do
	end do

	call boxda(work,urr,vrr,pdd,ier)

        b_r2=pdd(2)
        b_z2=pdd(3)

c--------  x1*b_r1+x2*b_r2=bvert
c--------  x1*b_z1+x2*b_z2=brad_it

	delt=(b_r1*b_z2-b_z1*b_r2)

	x1=(bvert*b_z2-brad_it*b_r2)/delt
	x2=(b_r1*brad_it-b_z1*bvert)/delt


c ----->
	do i=1,nr
	do j=1,nz

	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i

        psext0=0.
	DO k=1,npf

	if(k.eq.ind_r(1))psext0=psext0+x1*FLUXARR(kk,K)
	if(k.eq.ind_r(2))psext0=psext0+x2*FLUXARR(kk,K)
	END DO
	work(kk1)=psext0*api
cccc	psext(kk)=psext(kk)+psext0*api
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
	brad_it=-psi_z
	bvert=-psi_r

        if(kpr.eq.1)print *,' brad_it bvert ',brad_it,bvert

	DO k=1,npf

	if(k.eq.ind_r(1))then
           pf(k)=pf(k)+x1
           if(kpr.eq.1)print *,' k pf0(k) pf(k)',k,pf0(k),pf(k)
        end if

	if(k.eq.ind_r(2))then
           pf(k)=pf(k)+x2
           if(kpr.eq.1)print *,' k pf0(k) pf(k)',k,pf0(k),pf(k)
        end if

	END DO

71	format(20x,a6/,(6(1pe10.3)))

        return
        end
	subroutine brad_vert_vic()
c!!!	subroutine brad_vert()
	include 'double.inc'
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
     *  /cont4/ZPP,RPP,WVSPIP,ZXP,ELP,SHAPE,GAPINP,
     *  DFZP, DFZP0
     *	/cont9/brad,kefit
     *  /cont13/zmag,zvel,delrmag,delzmag
     *  /cont13e/zmag0,rmag,rmag0,rvel

	common
     *	/fluxc6/pmag,pbound,psep,p_s,delaval,dr_h
     *	/fluxc7/coef,coef1,api
     *  /fluxc8/work(nwnhe)
	dimension pdd(6),pfhelp(kf)
c$
	common /key_3_8/key_3_8
 	dimension pf_54(5)
c$
	character *20 apr

        if(kpr.eq.1)print *,' ind_r ',ind_r

	ksep=-1

	call spoint(ksep,xw,yw,fint,rmag,zmag,pmag,
     *  rsep,zsep,psep,rsep1,zsep1,psep1)


	if(kpr.eq.1)print *,' rmag zmag pmag',rmag,zmag,pmag
c$
	rref=rpp
c$
	urr=rref
	vrr=zmag

	call boxd(urr,vrr,pdd,ier)
c---------------
	psi_r=pdd(2)
	psi_z=pdd(3)
c-------------------
	brad=-psi_z
	bvert=-psi_r
	if(kpr.eq.1)print*,'rref',rref
        if(kpr.eq.1)print *,' brad bvert ',brad,bvert
c	pause 'from brad_vert'

        f2=bvert

c---R stabilization---

	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i
	psext0=0.
	DO k=1,npf
	if(k.eq.ind_r(1))psext0=psext0+FLUXARR(kk,K)
	if(k.eq.ind_r(2))psext0=psext0+FLUXARR(kk,K)
	END DO
	work(kk1)=psext0*api

	end do
	end do

	call boxda(work,urr,vrr,pdd,ier)


        b_r=pdd(2)
        b_z=pdd(3)


	x2=f2/b_r
c ----->
	do i=1,nr
	do j=1,nz

	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i

        psext0=0.
	DO k=1,npf

	if(k.eq.ind_r(1))psext0=psext0+x2*FLUXARR(kk,K)
	if(k.eq.ind_r(2))psext0=psext0+x2*FLUXARR(kk,K)
	END DO
	work(kk1)=psext0*api
cccc	psext(kk)=psext(kk)+psext0*api
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
	if(kpr.eq.1)print*,'x2 b_r',x2,b_r
c	pause 'from brad_vert'

c$
c*** to switch puching coils ***
	pf_54(5)=-358.
	pf_54(4)=-375.
	pf_54(3)=-1.e10
	if(pf(ind_r(1)).lt.pf_54(ind_r(1)))then
	   ind_r(1)=ind_r(1)-1
	   ind_r(2)=ind_r(2)-1
	   if(ind_r(1).eq.3)key_3_8=1
	end if
c$	

	d_x2=0.1
	DO k=1,npf

	if(k.eq.ind_r(1))then
           pf(k)=pf(k)+x2*d_x2
           if(kpr.eq.1)print *,' k pf0(k) pf(k)',k,pf0(k),pf(k)
        end if

	if(k.eq.ind_r(2))then
           pf(k)=pf(k)+x2*d_x2
           if(kpr.eq.1)print *,' k pf0(k) pf(k)',k,pf0(k),pf(k)
        end if

	END DO

71	format(20x,a6/,(6(1pe10.3)))

        return
        end
	subroutine kpl_out()
	include 'double.inc'
        include 'parf1'
        include 'parf2'
        include 'parf4'

	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /ge2/NTAY,TAY,TT
     *  /ge5/kpr
        common
     *  /keys10/ngra
        common
     *  /fluxc11/npl,pl_cur(nwnh),x_cur(nwnh),y_cur(nwnh)

        common
     *  /ves1/psp(mu),psp0(mu),tcam(mu),tcam0(mu)
     *  /ves2/ncam,rc(mu),zc(mu)


c        open (unit=41,file='kpl.dat',access='append',form='formatted')
        open (unit=41,file='kpl.dat',form='formatted')
        write (41,*)'npl time [msec]'
        write (41,*)npl,tt
        write (41,*)'rpl   zpl  tokpl'
        tok=0.
        do i=1,npl
        write (41,*)x_cur(i),y_cur(i),pl_cur(i)
        tok=tok+pl_cur(i)
        end do
        if(kpr.eq.1)print *,' npl tok======================',npl,tok
        close (41)

c        open (unit=41,file='tok.dat',access='append',form='formatted')
        open (unit=41,file='tok.dat',form='formatted')
        write (41,*)'npf time [msec]'
        write (41,*)npf,tt

        do i=1,npf
        write (41,*)
        write (41,*)pf(i)
        end do
        close (41)

c        open (unit=41,file='tcami.dat',access='append',form='formatted')
        open (unit=41,file='tcami.dat',form='formatted')
        write (41,*)'ncam time [msec]'
        write (41,*)ncam,tt

        do i=1,ncam
        write (41,*)
        write (41,*)tcam(i)
        end do
        close (41)

	return
        end

	subroutine brad_c()
	include 'double.inc'
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
	common
     *  /pol4/ UM,VM,UK(ntet),VK(ntet)

	dimension pdd(6),pfhelp(kf)
	character *20 apr

	urr=rmag
	vrr=zref

c---Z stabilization---
	call boxd(urr,vrr,pdd,ier)
c---------------
	psi_r=pdd(2)
	psi_z=pdd(3)
c-------------------
	brad=-psi_z
	bvert=-psi_r
        if(kpr.eq.1)print *,' kzref brad bvert ',kzref,brad,bvert

        return
        end

	subroutine brad_calc()
	include 'double.inc'
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

c---Z stabilization---

        if(kpr.eq.1)print *,' ind_z ',ind_z
        if(kpr.eq.1)print *,' ind_r ',ind_r

	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i
	psext0=0.
	DO k=1,npf
	if(k.eq.ind_z(1))psext0=psext0+FLUXARR(kk,K)
	if(k.eq.ind_z(2))psext0=psext0-FLUXARR(kk,K)
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
	if(k.eq.ind_r(1))psext0=psext0+FLUXARR(kk,K)
	if(k.eq.ind_r(2))psext0=psext0+FLUXARR(kk,K)
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
	if(k.eq.ind_z(1))psext0=psext0+x1*FLUXARR(kk,K)
	if(k.eq.ind_z(2))psext0=psext0-x1*FLUXARR(kk,K)

	if(k.eq.ind_r(1))psext0=psext0+x2*FLUXARR(kk,K)
	if(k.eq.ind_r(2))psext0=psext0+x2*FLUXARR(kk,K)
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

	DO k=1,npf

	if(k.eq.ind_z(1))then
           pf(k)=pf(k)+x1
           if(kpr.eq.1)print *,' k pf0(k) pf(k)',k,pf0(k),pf(k)
        end if

	if(k.eq.ind_z(2))then
           pf(k)=pf(k)-x1
           if(kpr.eq.1)print *,' k pf0(k) pf(k)',k,pf0(k),pf(k)
        end if

	if(k.eq.ind_r(1))then
           pf(k)=pf(k)+x2
           if(kpr.eq.1)print *,' k pf0(k) pf(k)',k,pf0(k),pf(k)
        end if

	if(k.eq.ind_r(2))then
           pf(k)=pf(k)+x2
           if(kpr.eq.1)print *,' k pf0(k) pf(k)',k,pf0(k),pf(k)
        end if

	END DO

71	format(20x,a6/,(6(1pe10.3)))


	ksep=-1

	call spoint(ksep,xw,yw,fint,rmag,zmag,pmag,
     *  rsep,zsep,psep,rsep1,zsep1,psep1)

	if(kpr.eq.1)print *,' ---rmag zmag pmag',rmag,zmag,pmag

        return
        end

	subroutine psi_tot()
	include 'double.inc'
        include 'parf0'
        include 'parf1'
        include 'parf2'
        include 'parf2e'

	common
     *  /ge1/pi
     *  /eq1e/psext(nwnh),re(nre),ze(nze),dr,dz
     *  /eq1g/psi_g(nr,nz)
     *  /ge5/kpr
     *  /ge7/eu,rout,zout,elong
	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nr),y(nz),dx,dy
     *	/ge1e/rs0,tpl
     *  /ge2/NTAY,TAY,TT
     *  /eq3/FLUXARR(nwnh,kf)
     *  /eq10/vesarr(nwnh,mu)
     *  /eq12/omega,pspl0(nwnh)
	common
     *  /cont4/ZPP,RPP,WVSPIP,ZXP,ELP,SHAPE,GAPINP,
     *  DFZP, DFZP0
     *	/cont9/brad,kefit
     *  /cont13/zmag,zvel,delrmag,delzmag
     *  /cont13e/zmag0,rmag,rmag0,rvel
	common
     *  /ves1/psp(mu),psp0(mu),tcam(mu),tcam0(mu)
     *  /ves2/ncam,rc(mu),zc(mu)
	common
     *  /pol4/ UM,VM,UK(ntet),VK(ntet)
	common
     *	/fluxc6/pmag,pbound,psep,p_s,delaval,dr_h
     *	/fluxc7/coef,coef1,api
        common
     *	/con1/gain,ta,zref,kzref
     *  /con2/rref,krref,bvert
     *  /con3/i_pf
	common
     *  /keys9/i_d3d,i_iter,i_smal
     *  /keys15/i_br

	common
     *	/fluxc8/work(nwnhe)
c********* psext_pf ****
	common
     *	/v_jp/f_jp(nwnh)
     *  /vic_003/psi_pf
     *  /vic_psi_av/psipl_av,psiext_av
	dimension pdd(6),pfhelp(kf),yh(nz)
	character *20 apr
c=========================================

cccc	call brad_ctest()

        rref0=rref
        zref0=zref

 7000   continue

	tok_test=0.
	psi_pf=0.
	psipl_av=0.
	psiext_av=0.
	do i=1,nr
	do j=1,nz
C
	kk=(i-1)*nz+j
	psext(kk)=0.
	PSEXT0=0.
	psext_pf=0.
c
	DO K=1,NPF
	psext0=psext0+PF(K)*FLUXARR(kk,K)
	psext_pf=psext_pf+PF(K)*FLUXARR(kk,K)
	END DO
c
	pscam=0.
	DO K=1,ncam
	pscam=pscam+tcam(K)*vesarr(kk,K)
	END DO
	psext0=psext0+pscam

	PSEXT(kk)=psext(kk)+PSEXT0*api
c******
	tok_test=tok_test+f_jp(kk)
	psi_pf=psi_pf+psext_pf*f_jp(kk)
	psipl_av=psipl_av+pspl(kk)*f_jp(kk)/api
	psiext_av=psiext_av+psext(kk)*f_jp(kk)/api
	end do
	end do
	tok_test=tok_test*coef*dx*dy
	psi_pf=psi_pf*coef*dx*dy*1.e-5/(tok_test+1.e-8)
	psipl_av=psipl_av*coef*dx*dy*1.e-5/(tok_test+1.e-8)
	psiext_av=psiext_av*coef*dx*dy*1.e-5/(tok_test+1.e-8)
c	print*,'dx dy coef',dx,dy,coef
c	print*,'psi_pf tpl tok_test',psi_pf,tpl,tok_test
c
	tokc=0.
	DO K=1,ncam
	tokc=tokc+tcam(K)
	END DO
	if(kpr.eq.1)print *,' TOKC omega',tokc,omega


c************************
c BRAD - additional radial magnetic field to establish the plasma
c column in  z=zref  for the first time

cccc	call svd_0()

c        psi_max=-1.e10
	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	psi0=pspl(kk)+psext(kk)

c	psi(i,j)=omega*psi0+(1.-omega)*pspl0(kk)
	psi(i,j)=omega*psi0+(1.-omega)*psi_g(i,j)
c$$$
c###	if(j.gt.33) psi(i,j)=psi(i,33-(j-33))
c$$$
c        if(psi(i,j).ge.psi_max)then
c           psi_max=psi(i,j)
c           imax=i
c           jmax=j
c        end if

	end do
	end do

	rmag=um
	zmag=vm


	if(kpr.eq.1)print *,' rmag zmag===',rmag,zmag
	ksep=-1
	call spoint(ksep,xw,yw,fint,rmag,zmag,pmag,
     *  rsep,zsep,psep,rsep1,zsep1,psep1)

	dist=sqrt( (rmag-um)**2+(zmag-vm)**2)

	if(dist.gt.eu)then
	if(kpr.eq.1)print *,' dist======= eu',dist,eu
	call mag_ax(rmag,zmag,pmag)
	if(kpr.eq.1)print *,' rmag zmag pmag ---',rmag,zmag,pmag
	end if

c
	um=rmag
	vm=zmag
	if(kpr.eq.1)print *,' um vm===pmag',rmag,zmag,pmag
c
	if(kpr.eq.1)print *,' ***rm zm  brad bvert *** ',rmag,
     *  zmag,brad,bvert


	if(kzref.eq.1.and.krref.eq.1)then


!!!           call br_bz_vec()

	do i=1,nr                                                              
	do j=1,nz                                                              
	kk=(i-1)*nz+j                                                          

	      psi(i,j)=psi(i,j)+brad*(y(j)-zref)+
     *  bvert*x(i)*x(i)/(2.*rref)
c---                                                                    
	end do                                                                 
	end do                                                                 


           call br_bz_rus_kav()  


!           call br_bz_rus()  


           return
        end if

	if(kzref.eq.1.and.krref.eq.3)then

	if(kpr.eq.1)print *,' ***kzref krref *** ',kzref,krref

           call br_bz_vec()

!!!           call br_bz_rus()  


           return
        end if



	if(kzref.eq.1.and.krref.eq.2)then


!!!           call br_bz_vec()

!           call br_bz()  
           call br_bz_ves()  


           return
        end if

	if(kzref.eq.1.and.krref.eq.4)then


!!!           call br_bz_vec()

           call br_bz()  


           return
        end if


c	if(kpr.eq.1)print*,'rpp=',rpp
c	if(kpr.eq.1)print*,'kzref krref',kzref,krref
c	pause 'from psi_tot'

	if(kzref.eq.1) then

c	if(i_smal.eq.1) call brad_pf()
	call brad_test()
c	call brad_hor_it()
c	call brad_pf()

	if(kpr.eq.1)print *,' ***rmag zmag zref brad*** ',rmag,
     *  zmag,zref,brad

c secod search for magnetic axis (ksep=-1)
	ksep=-1

	call spoint(ksep,xw,yw,fint,rmag,zmag,pmag,
     *  rsep,zsep,psep,rsep1,zsep1,psep1)
	psep1=0.
c
	um=rmag
	vm=zmag
c---------
           return

        end if

	if(kzref.eq.3) then

	call brad_pf()

	if(kpr.eq.1)print *,' ***rmag zmag zref brad*** ',rmag,
     *  zmag,zref,brad

c secod search for magnetic axis (ksep=-1)
	ksep=-1

	call spoint(ksep,xw,yw,fint,rmag,zmag,pmag,
     *  rsep,zsep,psep,rsep1,zsep1,psep1)
	psep1=0.
c
	um=rmag
	vm=zmag
c---------
           return

       end if



	if(krref.eq.1)then
	call brad_vert_it()
	 return

        end if

	if(krref.eq.0.and.krref.eq.0)then

	do i=1,nr                                                              
	do j=1,nz                                                              
	kk=(i-1)*nz+j                                                          

	      psi(i,j)=psi(i,j)+brad*(y(j)-zref)+
     *  bvert*x(i)*x(i)/(2.*rref)
c---                                                                    
	end do                                                                 
	end do                                                                 

c secod search for magnetic axis (ksep=-1)
	ksep=-1

	call spoint(ksep,xw,yw,fint,rmag,zmag,pmag,
     *  rsep,zsep,psep,rsep1,zsep1,psep1)
	psep1=0.
c
	um=rmag
	vm=zmag
c---------

      end if
      
      

	if(kpr.eq.1)print *,' um vm==pmag=',rmag,zmag,pmag
71	format(20x,a6/,(6(1pe10.3)))


	return
	end


	subroutine ind_ind()
	include 'double.inc'
        include 'parf0'
        include 'parf1'
        include 'parf2'
        include 'parf4'

	common
     *  /ge1/pi
     *  /ge5/kpr
	common
     *  /pf1/npf,pf(kf),pf0(kf)
        common
     *  /eq3/FLUXARR(nwnh,kf)
     *  /eq8/jbound,xbound(ntet),ybound(ntet),alfa0
	common
     *	/fluxc3/u(nwnh),work(nwnh),sib(nwnh)
     *	/fluxc7/coef,coef1,api
	common
     *  /ramp1/fdd_ind
        common
     *  /pol4/ UM,VM,UK(ntet),VK(ntet)

        dimension pdd(6)

	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i
c
        psext0=0.
	DO K=npf-2,npf
	psext0=psext0+FLUXARR(kk,K)
	END DO

	work(kk1)=psext0
	end do
	end do
c
c  starting calculate flux

	fpl=0.

	urr=um
	vrr=vm
c
	call boxda(work,urr,vrr,pdd,ier)

	fint=pdd(1)
	fpl=fpl+fint

        fdd_ind=fpl

	if(kpr.eq.1)print *,'fdd_ind ',fdd_ind

	return
	end

	subroutine psi_pl(al1,f,errm)
	include 'double.inc'
        include 'parf2'
        include 'parf2e'
	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nr),y(nz),dx,dy
     *  /eq1e/psext(nwnh),re(nre),ze(nze),dr,dz
     *  /eq12/omega,pspl0(nwnh)
c-----------------------------------------------------------
        common
     *  /ge5/kpr
	common
     *	/bunemn/nww,nhh,drdz2,rgrid1,delr,delz
	common
     *	/fluxc3/u(nwnh),work(nwnh),sib(nwnh)
	common
     *  /keys9/i_d3d,i_iter,i_smal

	dimension f(nwnh)
c--------------------
	nww=nr-1
	nhh=nz-1
	rgrid1=x(1)
	delr=dx
	delz=dy
	drdz2=(delr/delz)**2
c--------------------------------
	n1=nr-1
	m1=nz-1

	DO I=1,nr
	DO J=1,nz
	kk=(i-1)*nz+j
	work(kk)=-f(kk)*al1*X(I)
	U(kk)=PSPL(kk)
	END DO
	END DO
c	if(kpr.eq.1)print *,'here BUNETO'
	DO I=1,nr
	DO J=1,nz,m1
	kk=(i-1)*nz+j
	sib(kk)=-pspl(kk)
	end do
	end do
c
	DO I=1,nr,n1
	DO J=1,nz
	kk=(i-1)*nz+j
	sib(kk)=-pspl(kk)
	end do
	end do
c
	do i=2,n1
	do j=2,m1
	kk=(i-1)*nz+j
	sib(kk)=0.5*work(kk)*delz**2
	end do
	end do
	call buneto(sib,nr,nz,work,nwnh)
	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	u(kk)=-sib(kk)
	end do
	end do
	it1=0
	errm=0.
	DO I=2,N1
	DO J=2,M1
	kk=(i-1)*nz+j
	err=abs(U(kk)-PSPL(kk))/(abs(PSPL(kk))+1.e-3)
	IF(err.GT.errm)errm=err
	pspl(kk)=u(kk)
c	pspl0(kk)=pspl(kk)+psext(kk)
	psi(i,j)=pspl(kk)+psext(kk)
	
	END DO
	END DO


	return
	end

	subroutine psi_b(psep,rsep,zsep,ksepa)
	include 'double.inc'
        include 'parf0'
	  include 'parf2'
	  include 'parf7'
      common
     *	/n_m/n,m,mp
	common
     *  /eq1/psi(nr,nz),pspl(nwnh),r(nr),z(nz),dr,dz
     *  /eq2/ke,xu(mu_l),yu(mu_l)
     *  /eq6/sinus(ntet),cosin(ntet)
     *  /eq14e/rsep_pf,zsep_pf
	common
     *  /pol4/ UM,VM,UK(ntet),VK(ntet)
	common
     *  /ge5/kpr
     *  /ge7/eu,rout,zout,elong

	common
     *	/fluxc2/delta0,pom(ntet)

	dimension pdd(6)
	dimension  vkref(ntet),ukref(ntet)

	data errt/1.e-14/


c!!!	abeg=eu
	abeg=0.5*eu

	do j=1,m
	ukref(j)=um+ABEG*cosin(j)
	vkref(j)=vm+elong*ABEG*sinus(j)
	end do

71	format(20x,a6/,(6(1pe10.3)))

	i1=2
	i2=m-1
c---------
	pom_m=pom(2)
	i3=2
	do i=3,m-1
	if(pom(i).lt.pom_m)i3=i
	end do
c	i1=2
c	i2=m-1
c	i3=2
	pocoef=0.1*delta0
	kc=1
	psepa=-1.e14
c-----------------------------------------------
c PSEPA(from separatrix1) - max psi in limiter
c RSEPA,ZSEPA - coordinates of this point

	call separatrix1 (i1,i2,i3,m,ukref,vkref,um,vm,pom,
     *  sinus,cosin,pocoef,psepa,rsepa,zsepa,isep,ksepa,kc)
	if(kpr.eq.1)print *,'psepa***=',psepa
	if(kpr.eq.1)print *,'zsepa rsepa',zsepa,rsepa
	posepa=sqrt( (rsepa-um)**2+(zsepa-vm)**2 )
	ksepa=1
	do i=2,m-1
	if(abs(posepa-pom(i)).lt.1.e-4)then
	if(kpr.eq.1)print *,'i posepa pom(i)',i,posepa,pom(i)
c
	if(kpr.eq.1)print *,' plasma touchs limiter'
	ksepa=0
	urr=rsepa
	vrr=zsepa

	rsep_pf=rsepa
	zsep_pf=zsepa

	call boxd(urr,vrr,pdd,ier)
	psepa=pdd(1)
	end if
	end do
c__________________________
c  search for separatrix...
	ksep=2
	psep=-1.e12
	psep1=-1.e12
	if(ksepa.ne.0)then
	xw=rsepa
	yw=zsepa
	call spoint(ksep,xw,yw,fint,rmag,zmag,pmag,
     *  rsep,zsep,psep,rsep1,zsep1,psep1)
	end if
c__________________________
c
	if(psepa.gt.psep.and.ksepa.eq.0)then
c	if(kpr.eq.1)print *,'***psepa gt psep---',psepa,psep
	psep=psepa
	rsep=rsepa
	zsep=zsepa
	end if
	if(abs(psep).gt.1.e10)then
	psep=psepa
	rsep=rsepa
	zsep=zsepa
	end if
	
	
      if(ksepa.eq.0)then
      i_min=1
      dist_min=1.d5
      do i=1,ke
      dist=sqrt( (xu(i)-rsep)**2+(yu(i)-zsep)**2)
      if(dist.le.dist_min)then
      dist_min=dist
      i_min=i
      end if
      end do
  
!      print *,' i_min dist_min==',i_min,dist_min
      
      i1=i_min-1
      i2=i_min+1
      
      if(i1.le.2)i1=2
      if(i2.ge.ke)i2=ke

      n_div=500
!      print *,' i1 i2 ke n_div==',i1,i2,ke,n_div

 !     print *,' rsep zsep psep==',rsep,zsep,psep

      do i=i1-1,i2

      xx=xu(i)
      zz=yu(i)

	jval=(1.0+errt)*(1.0+(zz-z(1))/dz)
	ival=(1.0+errt)*(1.0+(xx-r(1))/dr)
c
!	print *,' xx zz ival jval===',xx,zz,ival,jval

	if(ival.lt.1.or.ival.ge.nr.or.jval.lt.1.or.jval.ge.nz)then
	ier=1
!	print *,' xx zz ier===',xx,zz,ier
	!print *,' x_1 x_n ===',r(1),r(nr)
	!print *,' y_1 y_n ===',z(1),z(nr)
	return
	end if
	end do
	
            
      do i=i1,i2
      dxx=(xu(i)-xu(i-1))/float(n_div)
      dyy=(yu(i)-yu(i-1))/float(n_div)

!      print *,' i xu yu =',i,xu(i),xu(i-1),yu(i),yu(i-1)

      do j=1,n_div
      urr=xu(i-1)+dxx*float(j)
      vrr=yu(i-1)+dyy*float(j)

!      print *,' i j urr vrr=dxx dyy =',i,j,urr,vrr,dxx,dyy

	call boxd(urr,vrr,pdd,ier)
	p_lim=pdd(1)

!      print *,' i j p_lim psep==',i,j,p_lim,psep

      if(p_lim.gt.psep)then
      psep=p_lim
      rsep=urr
      zsep=vrr
      end if
      
      end do
      end do
      
!      print *,' rsep zsep psep==',rsep,zsep,psep
      
      end if
      
      
	
	
c------------------------------------
	return
	end
	subroutine bound_coor()
c
	include 'double.inc'
        include 'parf0'
        include 'parf2'
	common
     *  /ge1/pi
     *  /ge2/NTAY,TAY,TT
     *  /ge5/kpr
	common
     *	/n_m/n,m,mp
	common
     *  /eq6/sinus(ntet),cosin(ntet)
	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nr),y(nz),dx,dy
     *  /eq7/tetq(ntet),htq(ntet)
     *  /eq8/jbound,xbound(ntet),ybound(ntet),alfa0
	common
     *  /pol4/ UM,VM,UK(ntet),VK(ntet)
	common
     *	/fluxc1/xp1(50,mu1),yp1(50,mu1)
     *  /fluxc2/delta0,pom(ntet)
     *  /fluxc4/mcurve,x11(mu1),y11(mu1)
     *	/fluxc6/pmag,pbound,psep,p_s,delaval,dr_h

	dimension ind1(50)

	aval=pbound
	inte=0
        if(kpr.eq.1)print *,'pmag,pbound from bound_coor',pmag,pbound
1111	continue
	inte=inte+1
	if(inte.gt.10)then
	if(kpr.eq.1)print *,'INTE gt 10'
	go to 1112

	call write_surf()
	ier=1
c	read (*,*)
	tt=tt+1000.
!	print *,' WRITE one MORE time tt=',tt
	call write_surf()
	!print *,' end of writing SURF'
	call w_b_coor()
	!print *,' end of writing SURF'
	end if

c
	do i0=1,5
	ind1(i0)=0
	end do
c
	dcur=1.e-11*(abs(aval)+1.)
	call fluxcont(nn,mm,PSI,aval,x,y,xp1,yp1,num,ind1,delta0,dcur)
c
	i=1
	mcurve=ind1(i)
      DO  J=1,mcurve
      x11(J)=xp1(i,j)
      y11(J)=yp1(i,j)
	end do
c
c
	dist=sqrt( (x11(1)-x11(mcurve))**2+(y11(1)-y11(mcurve))**2 )
c
	if(dist.gt.delta0)then
           aval=aval+1.e-2*delaval
	if(kpr.eq.1)print *,' space is greater than delta0',dist
	go to 1111
	end if
 1112   continue

c	call pomin_mo (pom,tetq,m,um,vm,x11,y11,mcurve,pi)
c	call pomin_m(pom,tetq,m,um,vm,x11,y11,mcurve,pi)
	call pomin_pet_r(pom,tetq,m,um,vm,x11,y11,mcurve,pi)                    
                                                                        
c	apr='pom'                                                              
c	print 71,apr,(pom(j),j=1,m)                                           
                                                                        
	do j=2,m-1                                                             
	xbound(j)=um+cosin(j)*pom(j)                                           
	ybound(j)=vm+sinus(j)*pom(j)                                           
	key_pr=0                                                               
c	call psical(xbound(j),ybound(j),um,vm,pbound,psi_0,key_pr)            
	end do                                                                 
c                                                                       
	jbound=m-1                                                             
	xbound(1)=xbound(jbound)                                               
	ybound(1)=ybound(jbound)                                               
                                                                        
	do jj=2,mp-1
c##	j=2.*jj-2
	j=jj
	uk(jj)=xbound(j)
	vk(jj)=ybound(j)
	end do
c
	uk(mp)=uk(2)
	vk(mp)=vk(2)

	uk(1)=uk(mp-1)
	vk(1)=vk(mp-1)
c

	return
	end

	subroutine pspl_b1(f)
	include 'double.inc'
        include 'parf2'
	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nr),y(nz),dx,dy
     *  /eq16/psgrid(nwnh,ngrid)
	common
     *	/fluxc7/coef,coef1,api
        common
     *  /ge5/kpr

	dimension f(nwnh)

C   CALCULATE BOUNDARY PSIPL
C
	n1=nr-1
	m1=nz-1

	coef2=coef1*api
	
c	if(kpr.eq.1)print *,' nwnh nr nz coef2 ===',nwnh,nr,nz,coef2

	k=0
	DO I=1,nr
	DO J=1,nz,M1
	k=k+1
	kk2=(i-1)*nz+j
c   calculations ---
	fpl=0.
	DO Ip=2,N1
	DO Jp=2,M1
	kk=(ip-1)*nz+jp
	fpl=fpl+F(kk)*psgrid(kk,k)
	end do
	end do
	pspl5=pspl(kk2)
	pspl(kk2)=fpl*coef2
c	if(kpr.eq.1)
c     *	print *,' kk2 pspl psgrid ',kk2,pspl(kk2),psgrid(kk,k)
	end do
	end do
c
C
	DO I=1,nr,N1
	DO J=1,nz
	k=k+1
	kk2=(i-1)*nz+j
c   calculations ---
	fpl=0.
	DO Ip=2,N1
	DO Jp=2,M1
	kk=(ip-1)*nz+jp
	fpl=fpl+F(kk)*psgrid(kk,k)
	end do
	end do
	pspl(kk2)=fpl*coef2
c
	END DO
	END DO
C
C END PLASMA BOUNDARY
	return
	end

	subroutine pspl_b2(al1,f)
	include 'double.inc'
        include 'parf2'
	common
     *  /ge1/pi
     *  /ge5/kpr
	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nr),y(nz),dx,dy
	common
     *	/fluxc3/u(nwnh),work(nwnh),sib(nwnh)
     *	/fluxc7/coef,coef1,api
	common
     *	/bunemn/nww,nhh,drdz2,rgrid1,delr,delz

	dimension f(nwnh),
     *  dps_1(nr),dps_2(nz),dps_3(nr),dps_4(nz)

	parameter ( nb=2*(nr+nz) )
	dimension
     *  x_b(nb),y_b(nb),c_b(nb)

c   CALCULATE BOUNDARY PSIPL
c  boundary method .......
c
	n1=nr-1
	m1=nz-1

	DO I=1,nr
	DO J=1,nz
	kk=(i-1)*nz+j
	work(kk)=-f(kk)*al1*X(I)
	END DO
	END DO
c
	DO I=1,nr
	DO J=1,nz,M1
	kk=(i-1)*nz+j
	sib(kk)=0.
	end do
	end do
c
	DO I=1,nr,N1
	DO J=1,nz
	kk=(i-1)*nz+j
	sib(kk)=0.
	end do
	end do
c
	do i=2,n1
	do j=2,m1
	kk=(i-1)*nz+j
	sib(kk)=0.5*work(kk)*delz**2
	end do
	end do
	call buneto(sib,nr,nz,work,nwnh)
C
	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	psi(i,j)=-sib(kk)
	end do
	end do
c	pause ' end first calculation'
c	go to 7
c...................
c  ib=1 j=1 i=1,nr
	ib=1
	call bound(dps_1,ib,nr)
	k=0
	do i=2,nr
	k=k+1
	x_b(k)=0.5*(x(i)+x(i-1))
	y_b(k)=y(1)
	c_b(k)=0.5*(dps_1(i)+dps_1(i-1))/x_b(k)*dx
	end do
c
c  ib=3 j=nz i=1,nr
	ib=3
	call bound(dps_3,ib,nr)
	do i=2,nr
	k=k+1
	x_b(k)=0.5*(x(i)+x(i-1))
	y_b(k)=y(nz)
	c_b(k)=0.5*(dps_3(i)+dps_3(i-1))/x_b(k)*dx
	end do
C
c  ib=2 j=1,nz i=1
	ib=2
	call bound(dps_2,ib,nz)
	do j=2,nz
	k=k+1
	x_b(k)=x(1)
	y_b(k)=0.5*(y(j)+y(j-1))
	c_b(k)=0.5*(dps_2(j)+dps_2(j-1))/x_b(k)*dy
	end do
c
c  ib=4 j=1,nz i=nr
	ib=4
	call bound(dps_4,ib,nz)
	do j=2,nz
	k=k+1
	x_b(k)=x(nr)
	y_b(k)=0.5*(y(j)+y(j-1))
	c_b(k)=0.5*(dps_4(j)+dps_4(j-1))/x_b(k)*dy
	end do
c
	k_b=k


	k=0
	DO I=1,nr
	DO J=1,nz,M1
	k=k+1
	kk2=(i-1)*nz+j
c   calculations ---
	fpl=0.
	DO Ip=1,k_b
	fpl=fpl-coef*api*c_b(ip)*fp(x(i),x_b(ip),y(j),y_b(ip))
	end do
c	if(kpr.eq.1)print *,' pspl fpl',pspl(kk2),fpl
	pspl(kk2)=fpl
	end do
	end do
c
C
	DO I=1,nr,N1
	DO J=1,nz
	k=k+1
	kk2=(i-1)*nz+j
c   calculations ---
	fpl=0.
	DO Ip=1,k_b
	fpl=fpl-coef*api*c_b(ip)*fp(x(i),x_b(ip),y(j),y_b(ip))
	end do
c	if(kpr.eq.1)print *,' pspl fpl',pspl(kk2),fpl
	pspl(kk2)=fpl
c
	END DO
	END DO
C
C END PLASMA BOUNDARY
	return
	end

	subroutine pl_out(f)
	include 'double.inc'
        include 'parf1'
        include 'parf2'
        include 'parf4'
	common
     *  /ge1/pi
     *	/ge1e/rs0,tpl
     *  /ge5/kpr
	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nr),y(nz),dx,dy
	common
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /pf7/plasma(kf),plasma0(kf)
	common
     *  /eq3/FLUXARR(nwnh,kf)
     *  /eq10/vesarr(nwnh,mu)
	common
     *  /ves1/psp(mu),psp0(mu),tcam(mu),tcam0(mu)
     *  /ves2/ncam,rc(mu),zc(mu)
	common
     *  /loop1/kloop,RL(nloop),ZL(nloop),psloop(nloop)
     *  /loop5/pslgreen(nwnh,nloop)
     *  /loop6/psloopp(nloop)
	common
     *  /probe1/kprobe,bprobe(nprobe)
     *  /probe4/bprgreen(nwnh,nprobe)
     *  /probe5/bprobep(nprobe)
	common
     *	/fluxc7/coef,coef1,api
     *  /fluxc11/npl,pl_cur(nwnh),x_cur(nwnh),y_cur(nwnh)
        common /c_imas_curr_d/curr_d(nr,nz)

	dimension f(nwnh)

	n1=nr-1
	m1=nz-1
	if(kloop.gt.0)then
	do k=1,kloop
	fpl=0.
	DO Ip=2,N1
	DO Jp=2,M1
	kk=(ip-1)*nz+jp
	fpl=fpl+F(kk)*pslgreen(kk,k)
	end do
	end do
	psloopp(k)=fpl*coef1
	end do
	end if
c
	if(kprobe.gt.0)then
	do k=1,kprobe
	fpl=0.
	DO Ip=2,N1
	DO Jp=2,M1
	kk=(ip-1)*nz+jp
	fpl=fpl+F(kk)*bprgreen(kk,k)
	end do
	end do
	bprobep(k)=fpl*coef1
	end do
	end if

c
	do k=1,npf
	fpl=0.
	DO Ip=2,N1
	DO Jp=2,M1
	kk=(ip-1)*nz+jp
	fpl=fpl+F(kk)*fluxarr(kk,k)
	end do
	end do
	plasma(k)=fpl*coef1
	end do
c
	do k=1,ncam
	fpl=0.
	DO Ip=2,N1
	DO Jp=2,M1
	kk=(ip-1)*nz+jp
	fpl=fpl+F(kk)*vesarr(kk,k)
	end do
	end do
	psp(k)=fpl*coef1
	end do


        k=0
	DO i=1,nr
           DO j=1,nz
              kk=(i-1)*nz+j
        curr_d(i,j)=f(kk)*coef
              if(abs(f(kk)).gt.1.e-5)then
                 k=k+1
                 pl_cur(k)=f(kk)*coef1
                 x_cur(k)=x(i)
                 y_cur(k)=y(j)
              end if
           end do
	end do
        npl=k


      tok_2=0.
	do i=1,nr
	   do j=1,nz
              tok_2=tok_2+curr_d(i,j)*dx*dy
	   end do
	end do

	print *,' +tpl  tok_2==',tpl,tok_2



	return
	end

	subroutine psi_plb()
	include 'double.inc'
        include 'parf0'
        include 'parf2'
        include 'parf4'

	common
     *  /ge1/pi
     *  /ge5/kpr
     *	/ge1e/rs0,tpl
	common
     *  /eq8/jbound,xbound(ntet),ybound(ntet),alfa0
	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nn),y(MM),dx,dy
     *  /eq13/bpbound
     *  /eq15/pll,zsep,rsep,zsepup,rsepup,zsepdw,rsepdw
	common
     *  /dfm5/pt01,pt02
	common
     *	/fluxc3/u(nwnh),work(nwnh),sib(nwnh)
     *	/fluxc6/pmag,pbound,psep,p_s,delaval,dr_h
     *	/fluxc7/coef,coef1,api
	common
     *  /halo4/expfg,avalb,w_h,del_r,al0

	common
     *  /c_dave1/ps_plb

	dimension bpol(ntet),pdd(6),tokb(ntet),dlb(ntet)
c
	k=0
	do j=2,jbound
	k=k+1
	urr=xbound(j)
	vrr=ybound(j)
	call boxd(urr,vrr,pdd,ier)
	gradpsi=sqrt( pdd(2)**2+pdd(3)**2 )
	psi_r=pdd(2)
	psi_z=pdd(3)
	btemp=sqrt( psi_r**2+psi_z**2 )/urr
	bpol(j)=btemp
	end do

	bpol(1)=bpol(jbound)

	tok_p=0.
	do j=2,jbound
	dlb(j)=sqrt((xbound(j)-xbound(j-1))**2+
     *	(ybound(j)-ybound(j-1))**2)

	tokb(j)=0.5*(bpol(j)+bpol(j-1))*dlb(j)*coef
	tok_p=tok_p+0.5*(bpol(j)+bpol(j-1))*dlb(j)
	end do

	tok_p=tok_p*coef


	tok=0.
	do j=2,jbound
	tok=tok+tokb(j)
	end do

	if(kpr.eq.1)print *,'tok_p tok ',tok_p,tok

	k=0
	   fpl=0.
	do i=2,jbound
	   k=k+1
	do j=2,jbound
	   urr=0.5*(xbound(j)+xbound(j-1))
	   vrr=0.5*(ybound(j)+ybound(j-1))
	fpl=fpl+tokb(j)*fp( xbound(i),urr,ybound(i),vrr )
	end do
	end do
	fpl=fpl/k
	pll_1=fpl/tok
	if(kpr.eq.1)print *,' fpl pll_1=',fpl,pll_1
c--

	ps_plb=fpl*1.e-5

c--	read (*,*)

	return
	end

	subroutine pll_new()
	include 'double.inc'
        include 'parf0'
        include 'parf2'
        include 'parf4'

	common
     *  /ge1/pi
     *  /ge5/kpr
     *	/ge1e/rs0,tpl
	common
     *  /eq8/jbound,xbound(ntet),ybound(ntet),alfa0
	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nn),y(MM),dx,dy
     *  /eq13/bpbound
     *  /eq15/pll,zsep,rsep,zsepup,rsepup,zsepdw,rsepdw
	common
     *  /dfm5/pt01,pt02
	common
     *	/fluxc3/u(nwnh),work(nwnh),sib(nwnh)
     *	/fluxc6/pmag,pbound,psep,p_s,delaval,dr_h
     *	/fluxc7/coef,coef1,api
	common
     *  /halo4/expfg,avalb,w_h,del_r,al0

	dimension bpol(ntet),pdd(6),tokb(ntet),dlb(ntet)
c
	k=0
	do j=2,jbound
	k=k+1
	urr=xbound(j)
	vrr=ybound(j)
	call boxd(urr,vrr,pdd,ier)
	gradpsi=sqrt( pdd(2)**2+pdd(3)**2 )
	psi_r=pdd(2)
	psi_z=pdd(3)
	btemp=sqrt( psi_r**2+psi_z**2 )/urr
	bpol(j)=btemp
	end do

	bpol(1)=bpol(jbound)

	tok_p=0.
	do j=2,jbound
	dlb(j)=sqrt((xbound(j)-xbound(j-1))**2+
     *	(ybound(j)-ybound(j-1))**2)

	tokb(j)=0.5*(bpol(j)+bpol(j-1))*dlb(j)*coef
	tok_p=tok_p+0.5*(bpol(j)+bpol(j-1))*dlb(j)
	end do

	tok_p=tok_p*coef

	pll=fpl*2.*pi/tpl
c
	if(kpr.eq.1)print *,'tok_p pll ',tok_p,pll

	return
	end
	subroutine pl_integ()
	include 'double.inc'
        include 'parf0'
        include 'parf2'
        include 'parf2e'

	common
     *  /ge1/pi
     *  /ge5/kpr
     *	/ge1e/rs0,tpl
	common
     *  /eq8/jbound,xbound(ntet),ybound(ntet),alfa0
	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nn),y(MM),dx,dy
     *  /eq1e/psext(nwnh),re(nre),ze(nze),dr,dz
     *  /eq13/bpbound
     *  /eq15/pll,zsep,rsep,zsepup,rsepup,zsepdw,rsepdw
	common
     *  /dfm5/pt01,pt02
	common
     *	/fluxc3/u(nwnh),work(nwnh),sib(nwnh)
     *	/fluxc6/pmag,pbound,psep,p_s,delaval,dr_h
     *	/fluxc7/coef,coef1,api
     *  /fluxc9/fdd,fdd0

	common
     *  /halo4/expfg,avalb,w_h,del_r,al0

	dimension bpol(ntet),pdd(6)

	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i
	work(kk1)=pspl(kk)
	end do
	end do
c
c  starting calculate flux
	k=0
	fpl=0.
	do j=2,jbound
	k=k+1
	urr=xbound(j)
	vrr=ybound(j)
c
	call boxda(work,urr,vrr,pdd,ier)
	fint=pdd(1)
	fpl=fpl+fint
	end do
	fpl=fpl/k
c	if(kpr.eq.1)print *,' fpl=',fpl
c
	k=0
	dr_h=0.
	do j=2,jbound
	k=k+1
	urr=xbound(j)
	vrr=ybound(j)
	call boxd(urr,vrr,pdd,ier)
	gradpsi=sqrt( pdd(2)**2+pdd(3)**2 )
	dr_h=dr_h+gradpsi
	psi_r=pdd(2)
	psi_z=pdd(3)
	btemp=sqrt( psi_r**2+psi_z**2 )/urr
	bpol(j)=btemp
	end do

	bpol(1)=bpol(jbound)
	dr_h=dr_h/k

	tok_p=0.
	dl_p=0.
	do j=2,jbound
	dl=sqrt((xbound(j)-xbound(j-1))**2+
     *	(ybound(j)-ybound(j-1))**2)
	tok_p=tok_p+0.5*(bpol(j)+bpol(j-1))*dl
	dl_p=dl_p+dl
	end do
	bpbound=tok_p/dl_p
	tok_p=tok_p*coef
c	if(kpr.eq.1)print *,'tok_p=',tok_p
	pt01=tok_p
c
	pll1=fpl*2.*pi/pt01

	pll=fpl*2.*pi/tpl
c


	if(kpr.eq.1)print *,'tok_p bpbound pll--- ',tok_p,bpbound,pll

	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i
	work(kk1)=psext(kk)
	end do
	end do
c
c  starting calculate flux
	k=0
	fpl=0.
c	fplp=0.
	do j=2,jbound
	k=k+1
	urr=xbound(j)
	vrr=ybound(j)
c
c	call boxd(urr,vrr,pdd,ier)
c        fplp=fplp+pdd(1)
	call boxda(work,urr,vrr,pdd,ier)
	fint=pdd(1)
	fpl=fpl+fint
	end do
	fpl=fpl/k
c	fplp=fplp/k

        fdd=2.*pi*fpl
c	k_fdd=5
c	k_fdd=2
c	call avr_fdd(fdd,k_fdd)
c        fddp=2.*pi*fplp
c        fdd_tot=fdd+pll*pt01

c	if(kpr.eq.1)print *,' fdd_tot= fddp',fdd_tot*1.e-5,fddp*1.e-5

	return
	end

	subroutine pl_inte()
	include 'double.inc'
        include 'parf0'
        include 'parf2'
        include 'parf2e'

	common
     *  /ge1/pi
     *  /ge2/NTAY,TAY,TT
     *  /ge5/kpr
     *	/ge1e/rs0,tpl
	common
     *  /fluxc4/mcurve,x11(mu1),y11(mu1)
	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nn),y(MM),dx,dy
     *  /eq1e/psext(nwnh),re(nre),ze(nze),dr,dz
     *  /eq13/bpbound
     *  /eq15/pll,zsep,rsep,zsepup,rsepup,zsepdw,rsepdw
	common
     *  /dfm5/pt01,pt02
	common
     *	/fluxc3/u(nwnh),work(nwnh),sib(nwnh)
     *	/fluxc6/pmag,pbound,psep,p_s,delaval,dr_h
     *	/fluxc7/coef,coef1,api
     *  /fluxc9/fdd,fdd0
	common
     *  /halo4/expfg,avalb,w_h,del_r,al0

	dimension bpol(ntet),pdd(6)

	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i
	work(kk1)=pspl(kk)
	end do
	end do
c
c  starting calculate flux
	k=0
	fpl=0.
	do j=2,mcurve
	k=k+1
	urr=x11(j)
	vrr=y11(j)
c
	call boxda(work,urr,vrr,pdd,ier)
	fint=pdd(1)
	fpl=fpl+fint
	end do
	fpl=fpl/k
c	if(kpr.eq.1)print *,' fpl=',fpl
	pll=fpl*2.*pi/tpl
c


	if(kpr.eq.1)print *,'tok_p bpbound pll ',tok_p,bpbound,pll

	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	kk1=(j-1)*nr+i
	work(kk1)=psext(kk)
	end do
	end do
c
c  starting calculate flux
	k=0
	fpl=0.
	do j=2,mcurve
	k=k+1
	urr=x11(j)
	vrr=y11(j)
c
	call boxda(work,urr,vrr,pdd,ier)
	fint=pdd(1)
	fpl=fpl+fint
	end do
	fpl=fpl/k
        fdd=2.*pi*fpl
	pf_volt=-(fdd-fdd0)/(tay*100.)
	if(kpr.eq.1)print *,' pf_volt====',pf_volt
c	k_fdd=5
c	k_fdd=2
c	call avr_fdd(fdd,k_fdd)

	return
	end

	subroutine ves_pind()
	include 'double.inc'
        include 'parf0'
        include 'parf2'
        include 'parf7'

	common
     *  /pol4/ UM,VM,UK(ntet),VK(ntet)
	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nn),y(MM),dx,dy
     *  /eq2/ke,xu(mu_l),yu(mu_l)
	common
     *  /halo9/fluxt,fluxt0
        common
     *  /ge5/kpr

	fluxt0=0.
	npoint=0
	do in=1,nr
	do jn=1,nz
        call caet2(um,vm,x(in),y(jn),ipoint,ke,xu,yu)
	if(ipoint.eq.1)then
	fluxt0=fluxt0+1./x(in)
	npoint=npoint+1
	end if
	end do
	end do
	fluxt0=fluxt0*dx*dy
	if(kpr.eq.1)print *,'**** npoint= fluxt0= ',npoint,fluxt0
	return
	end
c
	subroutine cur_dens(nrad,al1,f)
	include 'double.inc'
        include 'parf0'
        include 'parf2'
        include 'parf7'
	common
     *  /fluxc4/jbound0,xp(mu1),yp(mu1)
     *	/fluxc5/nhalo,xtest(nwnh),ytest(nwnh)
     *	/fluxc6/pmag,pbound,psep,p_s,delaval,dr_h
     *	/fluxc7/coef,coef1,api
	common
     *	/ge1e/rs0,tpl
     *  /ge3/AI(npo),poA0(npo),HA2(npo),poa(npo),ha(npo)
     *  /ge5/kpr
     *  /ge7/eu,rout,zout,elong

        common
     *  /c_ge5/ksepa 
        common
     *  /graf1/tri,tri_up,tri_dw,el_up,el_dw


	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nn),y(MM),dx,dy
     *  /eq2/ke,xu(mu_l),yu(mu_l)
     *  /eq8/jbound,xbound(ntet),ybound(ntet),alfa0
     *  /eq15/pll,zsep,rsep,zsepup,rsepup,zsepdw,rsepdw
     *  /eq23/xleft,xright
	common
     *  /halo4/expfg,avalb,w_h,del_r,al0
     *  /halo6/thalo,thalo0
     *  /halo14/hpart

	common
     *  /pol4/ UM,VM,UK(ntet),VK(ntet)
     *  /pol6/ppx(npo),pffx(npo)
c-------------------------------------------------------
	common
     *	/keys3/kzero,iread,iwrite

c*vic
        common
     *       /vic_rz_cur/r_cur,z_cur
     *       /vic_elong/elong_sep

	common
     *  /c_grib1/u_nor(nr,nz)

	character *20 apr
	dimension f(nwnh)


	n1=nr-1
	m1=nz-1

	ZMAX=-1.e8
	ZMIN=+1.e8
c
	DO J=1,JBOUND0
	if(yp(j).ge.zmax)then
	ZMAX=Yp(J)
	rmax=xp(j)
	end if
	if(yp(j).le.zmin)then
	ZMin=yp(J)
	rmin=xp(j)
	end if
	END DO
c
	zmax_p=zmax
	zmin_p=zmin
	ZMAX=-1.e8
	ZMIN=+1.e8
c
c
	DO J=1,JBOUND
	if(ybound(j).ge.zmax)then
	ZMAX=Ybound(J)
	rmax=xbound(j)
	end if
	if(ybound(j).le.zmin)then
	ZMin=ybound(J)
	rmin=xbound(j)
	end if
	END DO
	zmax_p=zmax
	zmin_p=zmin

c	zmax=amax1(zmax,zmax_p)
c	zmin=amin1(zmin,zmin_p)

	xumin=xu(1)
	do j=1,ke
	xumin=amin1(xumin,xu(j))
	end do
	xleft=1.e8
	xright=-1.e8
	do j=1,jbound0
	xleft=amin1(xleft,xp(j))
	xright=amax1(xright,xp(j))
	end do
	gapin=xleft-xumin
	eu=0.5*(xright-xleft)
	bheight=0.5*(zmax-zmin)
	zout=0.5*(zmax+zmin)
	rout=0.5*(xleft+xright)
	elong=bheight/eu

	asp=rout/eu
        el_up=(zmax-zmag)/eu
        el_dw=(zmag-zmin)/eu
        tri_up=(rout-rmax)/eu
        tri_dw=(rout-rmin)/eu

	tri=0.5*(tri_up+tri_dw)

        if(kpr.eq.1)print *,' EL_UP EL_DW ASP',el_up,el_dw,asp
        if(kpr.eq.1)print *,' tri TRI_UP TRI_DW',tri,tri_up,tri_dw

        if(ksepa.eq.1)elong_sep=0.5*(zmax-zsep)/eu

	if(kpr.eq.1)print *,'xleft  xright xumin',xleft,xright,xumin
	if(kpr.eq.1)print *,'gapin  eu    ',gapin,eu
	if(kpr.eq.1)print *,'rout  zout   ',rout,zout
	if(kpr.eq.1)print *,'bheight elong',bheight,elong

	zsepdw=zsep
	if(zmin.le.zsepdw)then
	zsepdw=zmin
	rsepdw=rmin
	end if
	zsepup=zsep
	if(zmax.ge.zsepup)then
	zsepup=zmax
	rsepup=rmax
	end if

	npoint=0
	nhalo=0

	TOK=0.
	tok_g=0.

	zmin_h=zmin_p-del_r*elong
	zmax_h=zmax_p+del_r*elong


	apr='ppx'
c	if(kpr.eq.1)print 71,apr,(ppx(i),i=1,nrad)
	apr='pffx'
c	if(kpr.eq.1)print 71,apr,(pffx(i),i=1,nrad)

71	format(20x,a6/,(6(1pe10.3)))

c*vic
        r_cur=0.
        z_cur=0.
	
	i_old=0
!	i_old=1


	call pp_pff_mat()

	zmin_eq=zmin-0.5*dy
	zmax_eq=zmax+0.5*dy

	xleft_eq=xleft-0.5*dx
	xright_eq=xright+0.5*dx

c
	DO I=2,N1
	DO J=2,M1

	kk=(i-1)*nz+j
	F(kk)=0.
	PSIX=PSI(i,j)

      u_nor(i,j)=0.d0
c----------------

	if( psix.gt.psep.and.(y(j)-zmin_eq)*(y(j)-zmax_eq).gt.0.)
     *	go to 9
	if( psix.gt.psep.and.(x(i)-xleft_eq)*(x(i)-xright_eq).gt.0.)
     *	go to 9

c----------------

	IF( (PSIX-pbound)*(PSIX-pmag).LE.0.)THEN
!	PSIX=(PSI(i,j)-PMAG)/(p_s-PMAG)
	PSIX=(PSI(i,j)-PMAG)/(pbound-PMAG)

      u_nor(i,j)=psix

	psix=sqrt(psix)
	npoint=npoint+1

	if(i_old.eq.1)then
	call feeti(nrad,ppx,pprime,poa,psix)
	call feeti(nrad,pffx,fprime,poa,psix)

c	call feet_p(nrad,ppx,pprime,poa,psix)
c	call feet_p(nrad,pffx,fprime,poa,psix)

	pprime=-pprime
	fprime=-fprime
	F00=(PPRIME*X(I)/rS0+0.5*FPRIME*rS0/X(I))
	
	else

	call cur_den_p(f00,f_pp,f_pff,i,j,psix)
!	call cur_den_pet(f00,i,j)

	end if

	TOK=TOK+f00
	F(kk)=f00
c*vic Current center coordinates ********
        r_cur=r_cur+f00*x(i)
        z_cur=z_cur+f00*y(j)

	END IF

9	continue

	END DO
	END DO

c*vic
        r_cur=r_cur/tok
        z_cur=z_cur/tok

        if(kpr.eq.1)print*,'r_cur z_cur',r_cur,z_cur
c        pause 'from cur_dens'

	TOK=TOK*COEF*dx*dy
	TOK_g=TOK_g*COEF*dx*dy
	thalo=tok_g
	tok_s=tok+tok_g
	sp_h=nhalo*dx*dy
	sp_t=npoint*dx*dy
	sp_pl=sp_t-sp_h
	if(kpr.eq.1)print *,' sp_t sp_h sp_pl=',sp_t,sp_h,sp_pl
	al0=sp_h/sp_pl
c	hpart=1.05

	al1=tpl/(tok+tok_g)
C
	if(kpr.eq.1)print *,'tpl al1 ',tpl,al1
	if(kpr.eq.1)print *,' tok tok_g tok_s ',tok,tok_g,tok_s
C
	al0=al0*hpart

      SP_p=0.
      xbound(jbound+1)=xbound(2)
      ybound(jbound+1)=ybound(2)
      DO J=2,jbound
      SP_p=SP_p+xbound(J)*(ybound(J+1)-ybound(J-1))
  	end do
	SP_p=SP_p*0.5
       if(kpr.eq.1)print *,' sp_p sp_pl',sp_p,sp_pl

	return
	end


	subroutine cur_dens_old(nrad,al1,f)
	include 'double.inc'
        include 'parf0'
        include 'parf2'
        include 'parf7'
	common
     *  /fluxc4/jbound0,xp(mu1),yp(mu1)
     *	/fluxc5/nhalo,xtest(nwnh),ytest(nwnh)
     *	/fluxc6/pmag,pbound,psep,p_s,delaval,dr_h
     *	/fluxc7/coef,coef1,api
	common
     *	/ge1e/rs0,tpl
     *  /ge3/AI(npo),poA0(npo),HA2(npo),poa(npo),ha(npo)
     *  /ge5/kpr
     *  /ge7/eu,rout,zout,elong

        common
     *  /c_ge5/ksepa 


	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nn),y(MM),dx,dy
     *  /eq2/ke,xu(mu_l),yu(mu_l)
     *  /eq8/jbound,xbound(ntet),ybound(ntet),alfa0
     *  /eq15/pll,zsep,rsep,zsepup,rsepup,zsepdw,rsepdw
     *  /eq23/xleft,xright
	common
     *  /halo4/expfg,avalb,w_h,del_r,al0
     *  /halo6/thalo,thalo0
     *  /halo14/hpart

	common
     *  /pol4/ UM,VM,UK(ntet),VK(ntet)
     *  /pol6/ppx(npo),pffx(npo)
c-------------------------------------------------------
	common
     *	/keys3/kzero,iread,iwrite

c*vic
        common
     *       /vic_rz_cur/r_cur,z_cur
     *       /vic_elong/elong_sep

	character *20 apr
	dimension f(nwnh)


	n1=nr-1
	m1=nz-1

	ZMAX=-1.e8
	ZMIN=+1.e8
c
	DO J=1,JBOUND0
	if(yp(j).ge.zmax)then
	ZMAX=Yp(J)
	rmax=xp(j)
	end if
	if(yp(j).le.zmin)then
	ZMin=yp(J)
	rmin=xp(j)
	end if
	END DO
c
	zmax_p=zmax
	zmin_p=zmin
	ZMAX=-1.e8
	ZMIN=+1.e8
c
c
	DO J=1,JBOUND
	if(ybound(j).ge.zmax)then
	ZMAX=Ybound(J)
	rmax=xbound(j)
	end if
	if(ybound(j).le.zmin)then
	ZMin=ybound(J)
	rmin=xbound(j)
	end if
	END DO
	zmax_p=zmax
	zmin_p=zmin

c	zmax=amax1(zmax,zmax_p)
c	zmin=amin1(zmin,zmin_p)

	xumin=xu(1)
	do j=1,ke
	xumin=amin1(xumin,xu(j))
	end do
	xleft=1.e8
	xright=-1.e8
	do j=1,jbound0
	xleft=amin1(xleft,xp(j))
	xright=amax1(xright,xp(j))
	end do
	gapin=xleft-xumin
	eu=0.5*(xright-xleft)
	bheight=0.5*(zmax-zmin)
	zout=0.5*(zmax+zmin)
	rout=0.5*(xleft+xright)
	elong=bheight/eu

        if(ksepa.eq.1)elong_sep=0.5*(zmax-zsep)/eu

	if(kpr.eq.1)print *,'xleft  xright xumin',xleft,xright,xumin
	if(kpr.eq.1)print *,'gapin  eu    ',gapin,eu
	if(kpr.eq.1)print *,'rout  zout   ',rout,zout
	if(kpr.eq.1)print *,'bheight elong',bheight,elong

	zsepdw=zsep
	if(zmin.le.zsepdw)then
	zsepdw=zmin
	rsepdw=rmin
	end if
	zsepup=zsep
	if(zmax.ge.zsepup)then
	zsepup=zmax
	rsepup=rmax
	end if

	npoint=0
	nhalo=0

	TOK=0.
	tok_g=0.

	zmin_h=zmin_p-del_r*elong
	zmax_h=zmax_p+del_r*elong


	apr='ppx'
c	if(kpr.eq.1)print 71,apr,(ppx(i),i=1,nrad)
	apr='pffx'
c	if(kpr.eq.1)print 71,apr,(pffx(i),i=1,nrad)

71	format(20x,a6/,(6(1pe10.3)))

c*vic
        r_cur=0.
        z_cur=0.
	
c	i_old=0
	i_old=1


	call pp_pff_mat()

c
	DO I=2,N1
	DO J=2,M1
	kk=(i-1)*nz+j
	F(kk)=0.
	PSIX=PSI(i,j)

	if( psix.gt.psep.and.(y(j)-zmin)*(y(j)-zmax).gt.0.)
     *	go to 9
	if( psix.gt.psep.and.(x(i)-xleft)*(x(i)-xright).gt.0.)
     *	go to 9
	IF( (PSIX-pbound)*(PSIX-pmag).LE.0.)THEN
	PSIX=(PSI(i,j)-PMAG)/(p_s-PMAG)
	psix=sqrt(psix)
	npoint=npoint+1

	if(i_old.eq.1)then
	call feeti(nrad,ppx,pprime,poa,psix)
	call feeti(nrad,pffx,fprime,poa,psix)

c	call feet_p(nrad,ppx,pprime,poa,psix)
c	call feet_p(nrad,pffx,fprime,poa,psix)

	pprime=-pprime
	fprime=-fprime
	F00=(PPRIME*X(I)/rS0+0.5*FPRIME*rS0/X(I))
	
	else

	call cur_den_pet(f00,i,j)

	end if

	TOK=TOK+f00
	F(kk)=f00
c*vic Current center coordinates ********
        r_cur=r_cur+f00*x(i)
        z_cur=z_cur+f00*y(j)

	END IF
9	continue

	go to 1004

	PSIX=PSI(i,j)
c---
	if( (y(j)-zmin_h)*(y(j)-zmax_h).gt.0.)
     *	go to 1004
c----
	IF( (PSIX-pbound)*(PSIX-p_s).LE.0.)THEN
	PSIX=(PSI(i,j)-PMAG)/(p_s-PMAG)
	ipoint=0
        call caet2(um,vm,x(i),y(j),ipoint,ke,xu,yu)
	if(ipoint.eq.0) go to 1004
	psix=sqrt(psix)
	npoint=npoint+1
	nhalo=nhalo+1
	xtest(nhalo)=x(i)
	ytest(nhalo)=y(j)

	if(i_old.eq.1)then
	call feeti(nrad,ppx,pprime,poa,psix)
	call feeti(nrad,pffx,fprime,poa,psix)
	pprime=-pprime
	fprime=-fprime
	F00=(PPRIME*X(I)/rS0+0.5*FPRIME*rS0/X(I))
	else

	call cur_den_pet(f00,i,j)

	end if
	TOK_g=TOK_g+f00
	F(kk)=f00
	END IF
1004	CONTINUE
	END DO
	END DO

c*vic
        r_cur=r_cur/tok
        z_cur=z_cur/tok
c        if(kpr.eq.1)print*,'r_cur z_cur',r_cur,z_cur
c        pause 'from cur_dens'

	TOK=TOK*COEF*dx*dy
	TOK_g=TOK_g*COEF*dx*dy
	thalo=tok_g
	tok_s=tok+tok_g
	sp_h=nhalo*dx*dy
	sp_t=npoint*dx*dy
	sp_pl=sp_t-sp_h
	if(kpr.eq.1)print *,' sp_t sp_h sp_pl=',sp_t,sp_h,sp_pl
	al0=sp_h/sp_pl
c	hpart=1.05

	al1=tpl/(tok+tok_g)
C
	if(kpr.eq.1)print *,'tpl hpart ',tpl,hpart
	if(kpr.eq.1)print *,' tok tok_g tok_s ',tok,tok_g,tok_s
C
	al0=al0*hpart

      SP_p=0.
      xbound(jbound+1)=xbound(2)
      ybound(jbound+1)=ybound(2)
      DO J=2,jbound
      SP_p=SP_p+xbound(J)*(ybound(J+1)-ybound(J-1))
  	end do
	SP_p=SP_p*0.5
       if(kpr.eq.1)print *,' sp_p sp_pl',sp_p,sp_pl

	return
	end




	subroutine pom_lim()
	include 'double.inc'
        include 'parf0'
        include 'parf1'
        include 'parf2'
        include 'parf7'

	common
     *	/n_m/n,m,mp
	common
     *  /ge1/pi
     *  /ge5/kpr
	common
     *  /pol4/ UM,VM,UK(ntet),VK(ntet)
	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nr),y(nz),dx,dy
     *  /eq2/ke,xu(mu_l),yu(mu_l)
     *  /eq2e/kex,xue(mu),yue(mu)
     *  /eq7/tetq(ntet),htq(ntet)
	common
     *	/fluxc2/delta0,pom(ntet)
	common
     *  /keys7/i_c

	parameter ( k_sep=1000 )
	common /c_tsp1/r_sep(k_sep),z_sep(k_sep)
	common /c_tsp2/n_sep

	dimension  pom_1(ntet)
	character *20 apr

c  new quasy limiter kex, xue, yue ...
	xue(1)=x(nr-2)
	yue(1)=y(nz-2)
	xue(2)=x(3)
	yue(2)=y(nz-2)
	xue(3)=x(3)
	yue(3)=y(3)
	xue(4)=x(nr-2)
	yue(4)=y(3)
	xue(5)=xue(1)
	yue(5)=yue(1)
	kex=5

c---------->

c search for POM - difference between boundary and limiter in each ray
	if(kpr.eq.1)print *,' before pomin '
c!!!	call pomin_mo(pom,tetq,m,um,vm,xu,yu,ke,pi)
	if(kpr.eq.1)print*,'after pomin'
	call pomin_m(pom,tetq,m,um,vm,xu,yu,ke,pi)
	if(i_c.eq.1)then
           if(kpr.eq.1)print *,' i_c ==1 um vm  --- ',um,vm
           call pomin_m (pom_1,tetq,m,um,vm,xue,yue,kex,pi)

	   n_sep=0
           do j=2,m-1
	      n_sep=n_sep+1

                 rt=um+pom(j)*cos(tetq(j))
                 zt=vm+pom(j)*sin(tetq(j))
		 r_sep(n_sep)=rt
		 z_sep(n_sep)=zt


              if(j.eq.40.and.kpr.eq.1)
     *	print *,'  pom pom_1---',pom(j),pom_1(j)
              if(pom_1(j).le.pom(j))pom(j)=pom_1(j)
              if(j.eq.40)then
                 rt=um+pom(j)*cos(tetq(j))
                 zt=vm+pom(j)*sin(tetq(j))
                 if(kpr.eq.1)print *,' rt zt ---',rt,zt
              end if

           end do
        end if
        if(i_c.eq.1)then
           apr='xue'
           if(kpr.eq.1)print 71,apr,(xue(i),i=1,kex)
           apr='yue'
           if(kpr.eq.1)print 71,apr,(yue(i),i=1,kex)
        end if

           apr='xu'
c           if(kpr.eq.1)print 71,apr,(xu(i),i=1,ke)
           apr='yu'
c           if(kpr.eq.1)print 71,apr,(yu(i),i=1,ke)

	apr='pom'
c	if(kpr.eq.1)print 71,apr,(pom(i),i=1,m)

71	format(20x,a6/,(6(1pe10.3)))
	return
	end

	subroutine read_write()
	include 'double.inc'
        include 'parf0'
        include 'parf1'
        include 'parf2'
        include 'parf2e'

	common
     *	/keys3/kzero,iread,iwrite
     *  /keys16/niter
	common
     *	/n_m/n,m,mp
	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nr),y(nz),dx,dy
     *  /eq1g/psi_g(nr,nz)
     *  /eq1e/psext(nwnh),re(nre),ze(nze),dr,dz
     *  /eq12/omega,pspl0(nwnh)
	common
     *  /pol4/ UM,VM,UK(ntet),VK(ntet)
     *  /pol6/ppx(npo),pffx(npo)
        common
     *	/con1/gain,ta,zref,kzref
     *  /con2/rref,krref,bvert
	common
     *	/cont9/brad,kefit
        common
     *  /ge5/kpr
       	common
     *  /ves1/psp(mu),psp0(mu),tcam(mu),tcam0(mu)
     *  /ves2/ncam,rc(mu),zc(mu)
        common
     *	/fluxc12/r00,z00,eu00

c=========================================
	if(iwrite.eq.1)then
	open (unit=44,file='for044',form='unformatted')

	write (44)um,vm,brad,eu,zref,niter
	write (44)(pspl(i),i=1,nwnh)
c	write (44)(pspl0(i),i=1,nwnh)
	write (44)((psi_g(i,j),i=1,nr),j=1,nz)
	write (44)(pf(i),i=1,npf)
	write (44)(ppx(i),i=1,n)
	write (44)(pffx(i),i=1,n)
	write (44)(x(i),i=1,nr)
	write (44)(y(i),i=1,nz)
	write (44)(tcam(i),i=1,ncam)
	write (44)r00,z00,eu00
	print *,' end of writing for044 file'
	close (unit=44)
	end if

	if(iread.eq.1)then
	open (unit=44,file='for043',form='unformatted')

	read (44)um,vm,brad,eu,zref,niter
	read (44)(pspl(i),i=1,nwnh)
c	read (44)(pspl0(i),i=1,nwnh)
	read (44)((psi_g(i,j),i=1,nr),j=1,nz)
	read (44)(pf(i),i=1,npf)
	read (44)(ppx(i),i=1,n)
	read (44)(pffx(i),i=1,n)
	read (44)(x(i),i=1,nr)
	read (44)(y(i),i=1,nz)
	read (44)(tcam(i),i=1,ncam)
	read (44)r00,z00,eu00
!	print *,' end of reading for043 file'
	close (unit=44)
	end if
c
	return
	end
	subroutine f_40()
c       PROGRAM eq
c       implicit real *8 (a-h,o-z)
c       real *4 ctm,ctm0
c
	include 'double.inc'
	include 'parf0'
	include 'parf1'
	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /ge5/kpr
     *  /ge12/nps,rps(ntet),zps(ntet)
     *  /ge12e/indpf(kf),seps1,seps2,seps3
	common /keys6/i_svd,i_cal,kpf

	open(unit=40,file='for040',form='formatted')
	read (40,*)
	read (40,*)nps
	read (40,*)
	read (40,*)(rps(i),i=1,nps)
	read (40,*)
	read (40,*)(zps(i),i=1,nps)
	read (40,*)
	read (40,*)(indpf(i),i=1,npf)
	read (40,*)
	read (40,*)seps1,seps2,seps3
	read (40,*)
	read (40,*)i_svd,i_cal,kpf
	close (unit=40)

!	print *,' print from f40'

	return
	end

	subroutine bound_hcoor()
c	subroutine bound_h1()
c
	include 'double.inc'
        include 'parf0'
        include 'parf2'
	common
     *	/n_m/n,m,mp
	common
     *  /pol4/ UM,VM,UK(ntet),VK(ntet)
	common
     *  /ge7/eu,rout,zout,elong
     *  /ge7e/eu_u
	common
     *  /halo4/expfg,avalb,w_h,del_r,al0
	common
     *	/fluxc3/u(nwnh),work(nwnh),sib(nwnh)
	common
     *  /eq15/pll,zsep,rsep,zsepup,rsepup,zsepdw,rsepdw
        common
     *  /ge5/kpr

	dimension pdd(6)

	mp1=mp-1

      SP=0.
      DO 710 J=2,mp1
      SP=SP+UK(J)*(VK(J+1)-VK(J-1))
  710 CONTINUE
      SP=SP*0.5
      sp_pl=sp

c	if(kpr.eq.1)print *,' sp_p sp_pl',sp_p,sp_pl
	if(kpr.eq.1)print *,' al0 from bound_c',al0
c	if(kpr.eq.1)print *,' mp,mp1 sp',mp,mp1,sp
	al1=1.+al0
ccc	al1=al1*1.05
	alpr=al1
	sp_t=al1*sp_pl

	sp=sp_t
	it=0
80	continue
	it=it+1
c	if(kpr.eq.1)print *,' it mp al1',it,mp,al1
	do j=1,mp
	d_u=(uk(j)-um)
	d_v=(vk(j)-vm)
	uk(j)=um+al1*d_u
	vk(j)=vm+al1*d_v
	end do

      sp_0=sp
      SP=0.
	rmax_u=-10000.
	rmin_u=10000.
      DO J=2,mp1
      SP=SP+UK(J)*(VK(J+1)-VK(J-1))
	rmax_u=amax1(rmax_u,uk(j))
	rmin_u=amin1(rmin_u,uk(j))
  	end do
      SP=SP*0.5
c	if(kpr.eq.1)
c     *	print *,' mp1 sp rmax_u rmin_u ',mp1,sp,rmax_u,rmin_u
c      if(kpr.eq.1)print *,' sp sp_t sp_pl',sp,sp_p,sp_pl
      al1=0.5*(sp_t/sp+al1)
      if(al1.le.0.95)al1=0.95
c      if(kpr.eq.1)print *,' al1 ',al1
c	if(kpr.eq.1)print *,' sp_t sp_pl sp_0 sp',sp_t,sp_pl,sp_0,sp
c	if(kpr.eq.1)print *,' it al1 sp_t sp',it,al1,sp_t,sp
	if(it.gt.300)go to 81
      if(abs(sp-sp_0).gt.1.e-4*sp)go to 80
c
	eu_u=0.5*(rmax_u-rmin_u)
	if(kpr.eq.1)print *,' --eu eu_u-----',eu,eu_u

c	eu=eu_u

	return

	k=0
	fpl=0.
	do j=2,mp1
	k=k+1
	urr=uk(j)
	vrr=vk(j)
c
	call boxda(work,urr,vrr,pdd,ier)
	fint=pdd(1)
	fpl=fpl+fint
	end do
	fpl=fpl/k

	return
81	continue
	if(kpr.eq.1)print *,' sp_t sp_pl sp_0 sp',sp_t,sp_pl,sp_0,sp
	if(kpr.eq.1)print *,' it al1 al0',it,al1,al0
c	read (*,*)
	return
	end
c
	subroutine write_surf()
	include 'double.inc'
        include 'parf0'
        include 'parf1'
        include 'parf2'
    	include 'parf7'
    	common
     *	/n_m/n,m,mp
     	common
     *  /pol4/ UM,VM,UK(ntet),VK(ntet)
     	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nn),y(MM),dx,dy
     *  /eq1g/psi_g(nr,nz)

     *  /eq2/ke,xu(mu_l),yu(mu_l)
	common
     *  /eq4/xpl(npo,ntet),ypl(npo,ntet)
     *  /eq8/jbound,xbound(ntet),ybound(ntet),alfa0
     	common
     *  /pf1/npf,pf(kf),pf0(kf)
       	common
     * /pol6/ppx(npo),pffx(npo)
	common
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)

     	common
     *	/ge1e/rs0,tpl
     *  /ge2/NTAY,TAY,TT
     *  /ge5/kpr
       	common
     *  /ves2/ncam,rc(mu),zc(mu)
     	common
     *	/fluxc6/pmag,pbound,psep,p_s,delaval,dr_h
     *	/fluxc7/coef,coef1,api

     	dimension xcur(2*npo),torcur(2*npo)

	character *20 apr

	ml=mp/2+1
	i=0
	do k0=1,2
	if(k0.eq.1)j=ml
	if(k0.eq.2)j=2
	do i0=2,n
	if(k0.eq.1)k=n-i0+2
	if(k0.eq.2)k=i0
	i=i+1
c
	xcur(i)=0.5*(xpl(k,j)+xpl(k-1,j))
c!!!	xcur(i)=xpl(k,j)
	torcur(i)=-coef*( pp(k)*xcur(i)/rs0+0.5*pff(k)*
     *  rs0/xcur(i) )
c!!!	torcur(i)=-coef*( ppx(k)*xcur(i)/rs0+0.5*pffx(k)*
c!!!     *  rs0/xcur(i) )
	end do
	end do
	iprof=i
	apr='torcur'
c	if(kpr.eq.1)print 71,apr,(torcur(i),i=1,iprof)

71	format(20x,a6/,(6(1pe10.3)))

	apr='ppx'
c	if(kpr.eq.1)print 71,apr,(ppx(i),i=1,n)

	if(kpr.eq.1)print *,'iprof n',iprof,n


c!!!	if( abs(pbound-p_s).gt.1.e-3*abs(pbound) )p_s=psep

	call write_graf(
     *	nr,nz,ke,ncam,nwnh,npf,jbound,iprof,
     *	dx,dy,tt,
     *  psi_g,x,y,xu,yu,rc,zc,
c!!!     *  pmag,pbound,p_s,um,vm,
     *  pmag,pbound,psep,um,vm,
     *  xbound,ybound,
     *  xcur,torcur )
c
c        if(kpr.eq.1)print*,'psep p_s', psep,p_s
c	read (*,*)
	return
	end
c
	subroutine write_surf_eq()
	include 'double.inc'
        include 'parf0'
        include 'parf1'
        include 'parf2'
    	include 'parf7'
    	common
     *	/n_m/n,m,mp
     	common
     *  /pol4/ UM,VM,UK(ntet),VK(ntet)
     	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nn),y(MM),dx,dy
     *  /eq1g/psi_g(nr,nz)

     *  /eq2/ke,xu(mu_l),yu(mu_l)
	common
     *  /eq4/xpl(npo,ntet),ypl(npo,ntet)
     *  /eq8/jbound,xbound(ntet),ybound(ntet),alfa0
     	common
     *  /pf1/npf,pf(kf),pf0(kf)
       	common
     * /pol6/ppx(npo),pffx(npo)
	common
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)

     	common
     *	/ge1e/rs0,tpl
     *  /ge2/NTAY,TAY,TT
     *  /ge5/kpr
       	common
     *  /ves2/ncam,rc(mu),zc(mu)
     	common
     *	/fluxc6/pmag,pbound,psep,p_s,delaval,dr_h
     *	/fluxc7/coef,coef1,api

      common /sep_points/n_sep,x_sep(mu1),y_sep(mu1)

      include 'par_fil'

	common
     *  /efil_3/r_fil(k_fil),z_fil(k_fil)
     *  /efil_4/n_fil

     *  /fluxc4/mcurve_fil,x11(mu1),y11(mu1)
     *  /fluxc5/nhalo,xtest(nwnh),ytest(nwnh)


     	dimension xcur(2*npo),torcur(2*npo)

	character *20 apr

	ml=mp/2+1
	i=0
	do k0=1,2
	if(k0.eq.1)j=ml
	if(k0.eq.2)j=2
	do i0=2,n
	if(k0.eq.1)k=n-i0+2
	if(k0.eq.2)k=i0
	i=i+1
c
	xcur(i)=0.5*(xpl(k,j)+xpl(k-1,j))
c!!!	xcur(i)=xpl(k,j)
	torcur(i)=-coef*( pp(k)*xcur(i)/rs0+0.5*pff(k)*
     *  rs0/xcur(i) )
c!!!	torcur(i)=-coef*( ppx(k)*xcur(i)/rs0+0.5*pffx(k)*
c!!!     *  rs0/xcur(i) )
	end do
	end do
	iprof=i
	apr='torcur'
c	if(kpr.eq.1)print 71,apr,(torcur(i),i=1,iprof)

71	format(20x,a6/,(6(1pe10.3)))

	apr='ppx'
c	if(kpr.eq.1)print 71,apr,(ppx(i),i=1,n)

	if(kpr.eq.1)print *,'iprof n',iprof,n


c!!!	if( abs(pbound-p_s).gt.1.e-3*abs(pbound) )p_s=psep

	call write_graf_eq(
     *	nr,nz,ke,ncam,nwnh,npf,jbound,iprof,
     *	dx,dy,tt,
     *  psi_g,x,y,xu,yu,rc,zc,
c!!!     *  pmag,pbound,p_s,um,vm,
     *  pmag,pbound,psep,um,vm,
     *  xbound,ybound,
     *  xcur,torcur,
     *  n_sep,x_sep,y_sep,
     *  n_fil,r_fil,z_fil,
     *  mcurve_fil,x11,y11,
     *  nhalo,xtest,ytest)

c
c        if(kpr.eq.1)print*,'psep p_s', psep,p_s
c	read (*,*)
	return
	end
c

	subroutine write_graf_eq(
     *	nr,nz,ke,ncam,nwnh,npf,jbound,iprof,
     *	dx,dy,ttt,
     *  psi,x,y,xu,yu,rc,zc,
     *  pmag,pbound,p_s,um,vm,
     *  xbound,ybound,xcur,torcur,
     *  n_sep,x_sep,y_sep,
     *  n_fil,r_fil,z_fil,
     *  mcurve_fil,x11,y11,
     *  nhalo,xtest,ytest)

	include 'double.inc'
	dimension x_sep(*),y_sep(*),
     *  r_fil(*),z_fil(*),
     *  x11(*),y11(*),
     *  xtest(*),ytest(*)

c$
	include 'parf0'
c#
        common
     *  /ge5/kpr
c$
	common
     *  /mid6/bp_0(npo),a_m(npo),r_m(npo)
    	common
     *	/n_m/n,m,mp
c#
	dimension
     *  psi(nr,nz),x(nr),y(nz),xu(ke),yu(ke),
     *  rc(ncam),zc(ncam),
     *  xbound(jbound),ybound(jbound),
     *  xcur(iprof),torcur(iprof)

	dimension
     *  agraf(2*npo)


	ntay=ntay+1

c$
	ml=mp/2+1
	i=0
	do k0=1,2
	if(k0.eq.1)j=ml
	if(k0.eq.2)j=2
	do i0=2,n
	if(k0.eq.1)k=n-i0+2
	if(k0.eq.2)k=i0
	i=i+1
	agraf(i)=a_m(k)
	end do
	end do	
c#

c----------- write  graphics data ---
c*** i_form=1 to do formatted writing
	i_form=1

5000	format(4(1x,1pe14.7))
	
	if(i_form.eq.0)then

c	open (unit=61,file='psi_data',access='append',
c     *  form='unformatted')
           if(ntay.le.1)then
              open (unit=61,file='psi_data_eq',status='new',
     *             form='unformatted')
           end if


           if(ntay.gt.1)then
              open (unit=61,file='psi_data_eq',status='old',
     *             form='unformatted')
           end if
c$

           write (61)ke,ncam,npf,jbound,iprof
c#
           write (61)(rc(i),i=1,ncam)
           write (61)(zc(i),i=1,ncam)
           write (61)(xu(i),i=1,ke)
           write (61)(yu(i),i=1,ke)
c
           write (61)dx,dy,pmag,pbound,p_s,um,vm,ttt
           
           write (61)((psi(i,j),i=1,nr),j=1,nz)
           write (61)(x(i),i=1,nr)
           write (61)(y(i),i=1,nz)
           write (61)(xbound(i),i=1,jbound)
           write (61)(ybound(i),i=1,jbound)
           write (61)(xcur(i),i=1,iprof)
           write (61)(torcur(i),i=1,iprof)
c$
c!!!	write (61)(agraf(i),i=1,iprof)
c#	
c	print*,(agraf(i),i=1,iprof)
c	read(*,*)


           close (61)

	end if

	if(i_form.eq.1)then

        if(ntay.le.1)then
              open (unit=61,file='psi_data_eq',
     *             form='formatted')
        end if

        if(ntay.gt.1)then
	open (unit=61,file='psi_data_eq',access='append',
     *  form='formatted')
        end if


           write (61,*)ke,ncam,npf,jbound,iprof,
     *  n_fil,mcurve_fil,nhalo,n_sep
c#    
           write (61,5000)(rc(i),i=1,ncam)
           write (61,5000)(zc(i),i=1,ncam)
           write (61,5000)(xu(i),i=1,ke)
           write (61,5000)(yu(i),i=1,ke)
c     
           write (61,5000)dx,dy,pmag,pbound,p_s,um,vm,ttt
           
           write (61,5000)((psi(i,j),i=1,nr),j=1,nz)
           write (61,5000)(x(i),i=1,nr)
           write (61,5000)(y(i),i=1,nz)
           write (61,5000)(xbound(i),i=1,jbound)
           write (61,5000)(ybound(i),i=1,jbound)
           write (61,5000)(xcur(i),i=1,iprof)
           write (61,5000)(torcur(i),i=1,iprof)

           write (61,5000)(r_fil(i),i=1,n_fil)
           write (61,5000)(z_fil(i),i=1,n_fil)

           write (61,5000)(x11(i),i=1,mcurve_fil)
           write (61,5000)(y11(i),i=1,mcurve_fil)

           write (61,5000)(xtest(i),i=1,nhalo)
           write (61,5000)(ytest(i),i=1,nhalo)

           write (61,5000)(x_sep(i),i=1,n_sep)
           write (61,5000)(y_sep(i),i=1,n_sep)


c$
c!!!!	write (61,5000)(agraf(i),i=1,iprof)
c#	
c	print*,(agraf(i),i=1,iprof)
c	read(*,*)


           close (61)

	end if
        
        
	return
	end

c********************************************************************
	subroutine write_tok()
	include 'double.inc'
	include 'new_com.inc'

	call write_tok_c(
     &  npf,ncam,nr,nz,pf,tcam,f_jp,x,y,tt,tpl,coef,n_pasc)

	return
	end

	subroutine write_tok_c(
     &  npf,ncam,nr,nz,pf,tcam,f,x,y,tt,tpl,coef,n_pasc)

	include 'double.inc'
	dimension pf(*),tcam(*),f(*),x(*),y(*)


      i_en=i_en+1
      
c	npf_help=npf-1
	npf_help=npf-n_pasc
	i_form=1

	if(i_form.eq.1)then
	if(i_en.eq.1)then
	open (unit=71,file='tok_data',
     &  form='formatted')
      else
	open (unit=71,file='tok_data',access='append',
     &  form='formatted')
      end if
      

c	print*,'npf npf_help',npf,npf_help
c	read(*,*)
	
	nwnh=nr*nz
	write (71,5000)tt,tpl,dx,dy
	write (71,*)ncam,npf_help,nr,nz
	write (71,5000)(tcam(i),i=1,ncam)
	write (71,5000)(pf(i),i=1,npf_help)
	write (71,5000)(x(i),i=1,nr)
	write (71,5000)(y(i),i=1,nz)
	write (71,5000)(f(i),i=1,nwnh)

	close(71)
	else

	open (unit=71,file='tok_data',access='append',
     &  form='unformatted')

	
	nwnh=nr*nz
	write (71)tt,tpl,dx,dy
	write (71)ncam,npf_help,nr,nz
	write (71)(tcam(i),i=1,ncam)
	write (71)(pf(i),i=1,npf_help)
	write (71)(x(i),i=1,nr)
	write (71)(y(i),i=1,nz)
	write (71)(f(i),i=1,nwnh)

	close(71)

	end if

5000	format(4(1x,1pe14.7))

c	dx=x(2)-x(1)
c	dy=y(2)-y(1)
c	tok_test=0.
c	do i=1,nwnh
c	   tok_test=tok_test+f(i)*coef*dx*dy
c	end do
c	print*,'!!! tpl tok_test coef',tpl,tok_test,coef
c	read(*,*)

	return
	end
c*************************************************************
	subroutine w_b_coor()
c
	include 'double.inc'
        include 'parf0'
        include 'parf2'
	common
     *  /ge1/pi
     *  /ge5/kpr
	common
     *	/n_m/n,m,mp
	common
     *  /eq6/sinus(ntet),cosin(ntet)
	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nr),y(nz),dx,dy
     *  /eq7/tetq(ntet),htq(ntet)
     *  /eq8/jbound,xbound(ntet),ybound(ntet),alfa0
	common
     *  /pol4/ UM,VM,UK(ntet),VK(ntet)
	common
     *	/fluxc1/xp1(50,mu1),yp1(50,mu1)
     *  /fluxc2/delta0,pom(ntet)
     *  /fluxc4/mcurve,x11(mu1),y11(mu1)
     *	/fluxc6/pmag,pbound,psep,p_s,delaval,dr_h

	dimension ind1(50)

	open (unit=41,file='error.txt',form='formatted')

	write (41,*)mcurve
	write (41,5000)(x11(i),i=1,mcurve)
	write (41,5000)(y11(i),i=1,mcurve)

	write (41,*)m
	write (41,5000)(xbound(i),i=1,m)
	write (41,5000)(ybound(i),i=1,m)

	close (41)
5000	format(4(1x,1pe14.7))

	return
	end

	subroutine mat(a,x,f)
	include 'double.inc'
	common
     *  /ge5/kpr
	dimension a(2,2),x(2),f(2)
	det=a(1,1)*a(2,2)-a(1,2)*a(2,1)
	if( abs(det).lt.1.e-8)then
	if(kpr.eq.1)print *,' det is ',det
	stop
	end if
	x(1)=(f(1)*a(2,2)-f(2)*a(1,2))/det
	x(2)=(f(2)*a(1,1)-f(1)*a(2,1))/det
	return
	end
	subroutine mat_prep(a11,a12,a21,a22,f1,f2,x1,x2)
	include 'double.inc'
	common
     *  /ge5/kpr
	dimension a(2,2),x(2),f(2)

        a(1,1)=a11
        a(1,2)=a12
        a(2,1)=a21
        a(2,2)=a22

        f(1)=f1
        f(2)=f2

        if(kpr.eq.1)print *,' a(1,1) a(1,2) ',a(1,1),a(1,2)
        if(kpr.eq.1)print *,' a(2,1) a(2,2) ',a(2,1),a(2,2)
        if(kpr.eq.1)print *,' f(1) f(2) ',f(1),f(2)

	call mat(a,x,f)
        if(kpr.eq.1)print *,' x(1) x(2) ',x(1),x(2)
        x1=x(1)
        x2=x(2)

        end


	subroutine psical(uk,vk,um,vm,pbound,psi_0,key_pr)
	include 'double.inc'
c
	dimension pds(6)
c
	a_r=(uk-um)
	a_z=(vk-vm)
c
	amod=sqrt(a_r**2+a_z**2)
c	if(kpr_pr.eq.1)print *,' amod=',amod
c
	urr=uk
	vrr=vk
c------
	call boxd(urr,vrr,pds,ier)
c--------     pds(1)=fun
c--------     pds(2)=(dfdr)
c--------     pds(3)=(dfdz)
c--------     pds(4)=(dfdr)dz
c--------     pds(5)=(dfdr)dr
c--------     pds(6)=(dfdz)dz
c______________________________________________
	p_old=pds(1)
c
	psi_r=pds(2)
	psi_z=pds(3)
c
	b=(psi_r*a_r+psi_z*a_z)/amod
c	if(kpr_pr.eq.1)print *,' dpsi/dl==',b
c
 	b_r=a_r/amod*pds(5)+a_z/amod*pds(4)
 	b_z=a_r/amod*pds(4)+a_z/amod*pds(6)
c
	a=(b_r*a_r+b_z*a_z)/amod
c	if(kpr_pr.eq.1)print *, 'd2psi/dl2 ',a
c
	c=pds(1)-pbound
c	if(kpr_pr.eq.1)print *,' delpsi',c
c

	det=b**2-4.*a*c
	if(det.lt.0.)return
	x1=(-b+sqrt(det))/(2.*a)
	x2=(-b-sqrt(det))/(2.*a)
c	if(kpr_pr.eq.1)print *,' det x1 x2',det,x1,x2
	x=x1
	if(abs(x2).le.abs(x1))x=x2
c	do i=1,2
c	if(i.eq.1)x=x1
c	if(i.eq.2)x=x2
	al=(x+amod)/amod
	urr=um+al*a_r
	vrr=vm+al*a_z
	call boxd(urr,vrr,pds,ier)
	if(key_pr.eq.1)print *,' x pboud p_old pds(1)',
     *  x,pbound,p_old,pds(1)
c	end do
	psi_0=pds(1)
	uk=urr
	vk=vrr
	return
	end
c
	subroutine bound_h2()

	include 'double.inc'
	include 'new_com.inc'

	call bound_h2_c(
     *  mp,del_r,eu,eu_u,um,vm,uk,vk)
	
	return
	end


	subroutine bound_h2_c(
     *  mp,del_r,eu,eu_u,um,vm,uk,vk)

	include 'double.inc'
	common
     *  /ge5/kpr
        dimension uk(*),vk(*)

      SP=0.
      DO 710 J=2,mp-1
      SP=SP+UK(J)*(VK(J+1)-VK(J-1))
  710 CONTINUE
      SP=SP*0.5
      sp_pl=sp

c!!!	al1=1.+del_r/eu
	al1=1.+del_r/sqrt(sp_pl)

	do j=1,mp
	d_u=(uk(j)-um)
	d_v=(vk(j)-vm)
	uk(j)=um+al1*d_u
	vk(j)=vm+al1*d_v
	end do

	rmax_u=-10000.
	rmin_u=10000.

      DO J=2,mp-1
	rmax_u=amax1(rmax_u,uk(j))
	rmin_u=amin1(rmin_u,uk(j))
  	end do

	eu_u=0.5*(rmax_u-rmin_u)

	if(kpr.eq.1)print *,' --eu eu_u-sp_pl ',eu,eu_u,sp_pl
	return
	end

	subroutine cur_den_pet(f00_xx,i_xx,j_xx)
	include 'double.inc'
	include 'new_com.inc'

	call cur_den_pet_c(f00_xx,i_xx,j_xx,
     *  x,y,dx,dy,psi,nr,nz,pmag,pbound,rs0)

	return
	end


	subroutine cur_den_pet_c(f00,i,j,
     *  x,y,dx,dy,psi,nr,nz,pmag,pbound,rs0)

	include 'double.inc'
	common
     *  /ge5/kpr
	dimension x(*),y(*),psi(nr,nz)

	dimension c_x(9),c_y(9),c_f(9)

	data c_x /0.,0.5,0.5,0.,-0.5,-0.5,-0.5,0.,0.5/
	data c_y /0.,0.,0.5,0.5,0.5,0.,-0.5,-0.5,-0.5/
	data c_f /4.,2.,1.,2.,1.,2.,1.,2.,1./
	
	f00=0.

	do kk=1,9

	   r=x(i)+c_x(kk)*dx
	   z=y(j)+c_y(kk)*dy

	   call boxdl(p_val,r,z)

	   if(p_val.ge.pbound)then

	      PSIX=(p_val-PMAG)/(pbound-PMAG)
	      psix=sqrt(psix)

	      call fit_pp_pff(psix,pprime,fprime)

	      curd=-(PPRIME*r/rS0+0.5*FPRIME*rS0/r)

	      f00=f00+c_f(kk)*curd

	   end if

	end do

	f00=f00/16.


	return
	end

	subroutine pp_pff_mat()
	include 'double.inc'
	include 'new_com.inc'

	call pp_ff_mat_c(a,ppx,pffx,n)

	return
	end

	subroutine pp_ff_mat_c(poa,ppx,pffx,nrad)

	include 'double.inc'
	common
     *  /ge5/kpr
	dimension poa(*),ppx(*),pffx(*)
	
c	implicit real*8 (a-h,o-z)

	parameter(np=502,n1=np-2)
	common/c_pp_pff/ppm(np),pffm(np)

c	   if(kpr.eq.1)print *,' np n1',np,n1

c	write (6,*)' ppx '
c	write (6,*)(ppx(i),i=1,nrad)
c	write (6,*)' pffx '
c	write (6,*)(pffx(i),i=1,nrad)


	do i=1,np

	   psix=(float(i)-1.)/float(n1)

!	   call feeti(nrad,ppx,pprime,poa,psix)
!	   call feeti(nrad,pffx,fprime,poa,psix)

              call linear(nrad,ppx,pprime,poa,psix)
              call linear(nrad,pffx,fprime,poa,psix)



	   ppm(i)=pprime
	   pffm(i)=fprime


	end do

c	if(kpr.eq.1)print *,' Okay pp_pff_mat'
	
c	call pp_pff_pet()

	return
	end
	subroutine cur_den_p(f00_xx,f_pp_xx,f_pff_xx,
     *  i_xx,j_xx,psix_xx)
	include 'double.inc'
	include 'new_com.inc'

	call cur_den_p_c(f00_xx,f_pp_xx,f_pff_xx,
     *  i_xx,j_xx,psix_xx,
     *  x,y,dx,dy,psi,nr,nz,pmag,pbound,rs0)

	return
	end


	subroutine cur_den_p_c(f00,f_pp,f_pff,i,j,psix,
     *  x,y,dx,dy,psi,nr,nz,pmag,pbound,rs0)
	include 'double.inc'

	dimension x(*),y(*),psi(nr,nz)
	
	r=x(i)
	z=y(j)

	call fit_pp_pff(psix,pprime,fprime)

	f_pp=-PPRIME*r/rS0

	f_pff=-0.5d0*FPRIME*rS0/r

	f00=f_pp+f_pff
	   
	return
	end

	subroutine fit_pp_pff(x,pprime,fprime)
	include 'double.inc'
c	implicit real*8 (a-h,o-z)

	parameter(np=502,n1=np-2)
	common/c_pp_pff/ppm(np),pffm(np)
	common
     *  /ge5/kpr


	y=1.+x*n1
	ie=int(y)

c	if(ie+1.gt.np)then
c	   if(kpr.eq.1)print *,' x y n1 ie np####',x,y,n1,ie,np
c	end if

	pprime=(y-ie)*(ppm(ie+1)-ppm(ie))+ppm(ie)
	fprime=(y-ie)*(pffm(ie+1)-pffm(ie))+pffm(ie)

	return
	end


	subroutine bunem_coef()
	include 'double.inc'
        include 'parf2'
	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nr),y(nz),dx,dy
	common
     *	/bunemn/nww,nhh,drdz2,rgrid1,delr,delz

	nww=nr-1
	nhh=nz-1
	rgrid1=x(1)
	delr=dx
	delz=dy
	drdz2=(delr/delz)**2
	return
	end


	subroutine pspl_b2_old(al1,f)
	include 'double.inc'
        include 'parf2'
	common
     *  /ge1/pi
     *  /ge5/kpr
	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nr),y(nz),dx,dy
	common
     *	/fluxc3/u(nwnh),work(nwnh),sib(nwnh)
     *	/fluxc7/coef,coef1,api
	common
     *	/bunemn/nww,nhh,drdz2,rgrid1,delr,delz

	dimension f(nwnh),
     *  dps_1(nr),dps_2(nz),dps_3(nr),dps_4(nz)

	parameter ( nb=2*(nr+nz) )
	dimension
     *  x_b(nb),y_b(nb),c_b(nb)

c   CALCULATE BOUNDARY PSIPL
c  boundary method .......
c
	n1=nr-1
	m1=nz-1

	DO I=1,nr
	DO J=1,nz
	kk=(i-1)*nz+j
	work(kk)=-f(kk)*al1*X(I)
	END DO
	END DO
c
	DO I=1,nr
	DO J=1,nz,M1
	kk=(i-1)*nz+j
	sib(kk)=0.
	end do
	end do
c
	DO I=1,nr,N1
	DO J=1,nz
	kk=(i-1)*nz+j
	sib(kk)=0.
	end do
	end do
c
	do i=2,n1
	do j=2,m1
	kk=(i-1)*nz+j
	sib(kk)=0.5*work(kk)*delz**2
	end do
	end do
	call buneto(sib,nr,nz,work,nwnh)
C
	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	psi(i,j)=-sib(kk)
	end do
	end do
c	pause ' end first calculation'
c	go to 7
c...................
c  ib=1 j=1 i=1,nr
	ib=1
	call bound(dps_1,ib,nr)
	k=0
	do i=2,nr
	k=k+1
	x_b(k)=0.5*(x(i)+x(i-1))
	y_b(k)=y(1)
	c_b(k)=0.5*(dps_1(i)+dps_1(i-1))/x_b(k)*dx
	end do
c
c  ib=3 j=nz i=1,nr
	ib=3
	call bound(dps_3,ib,nr)
	do i=2,nr
	k=k+1
	x_b(k)=0.5*(x(i)+x(i-1))
	y_b(k)=y(nz)
	c_b(k)=0.5*(dps_3(i)+dps_3(i-1))/x_b(k)*dx
	end do
C
c  ib=2 j=1,nz i=1
	ib=2
	call bound(dps_2,ib,nz)
	do j=2,nz
	k=k+1
	x_b(k)=x(1)
	y_b(k)=0.5*(y(j)+y(j-1))
	c_b(k)=0.5*(dps_2(j)+dps_2(j-1))/x_b(k)*dy
	end do
c
c  ib=4 j=1,nz i=nr
	ib=4
	call bound(dps_4,ib,nz)
	do j=2,nz
	k=k+1
	x_b(k)=x(nr)
	y_b(k)=0.5*(y(j)+y(j-1))
	c_b(k)=0.5*(dps_4(j)+dps_4(j-1))/x_b(k)*dy
	end do
c
	k_b=k


	k=0
	DO I=1,nr
	DO J=1,nz,M1
	k=k+1
	kk2=(i-1)*nz+j
c   calculations ---
	fpl=0.
	DO Ip=1,k_b
	fpl=fpl-coef*api*c_b(ip)*fp(x(i),x_b(ip),y(j),y_b(ip))
	end do
c	print *,' pspl fpl',pspl(kk2),fpl
	pspl(kk2)=fpl
	end do
	end do
c
C
	DO I=1,nr,N1
	DO J=1,nz
	k=k+1
	kk2=(i-1)*nz+j
c   calculations ---
	fpl=0.
	DO Ip=1,k_b
	fpl=fpl-coef*api*c_b(ip)*fp(x(i),x_b(ip),y(j),y_b(ip))
	end do
c	print *,' pspl fpl',pspl(kk2),fpl
	pspl(kk2)=fpl
c
	END DO
	END DO
C
C END PLASMA BOUNDARY
	return
	end


	subroutine psi_tot_fil()
	include 'double.inc'
        include 'new_com.inc'

	call psi_tot_fil_c(
     *  ke,xu,yu,um,vm,rmag,zmag,pmag,
     *  psi_min,psi_max,
c     *  w_h0,eu,index_ves)
     *  w_h0,eu)


        return
        end


	subroutine psi_tot_fil_c(
     *  ke,xu,yu,um,vm,rmag,zmag,pmag,
     *  psi_min,psi_max,
c     *  w_h0,eu,index_ves)
     *  w_h0,eu)

	include 'double.inc'
c        dimension xu(*),yu(*),index_ves(*)
        dimension xu(*),yu(*)

        include 'parf0'
        include 'parf1'
        include 'parf2'
        include 'parf2e'

	common
     *  /ge1/pi
     *  /eq1e/psext(nwnh),re(nre),ze(nze),dr,dz
     *  /eq1g/psi_g(nr,nz)
	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nr),y(nz),dx,dy
     *  /ge2/NTAY,TAY,TT
     *  /eq3/FLUXARR(nwnh,kf)
     *  /eq10/vesarr(nwnh,mu)
     *  /eq12/omega,pspl0(nwnh)
	common
     *  /ves1/psp(mu),psp0(mu),tcam(mu),tcam0(mu)
     *  /ves2/ncam,rc(mu),zc(mu)
	common
     *	/fluxc7/coef,coef1,api

	dimension pdd(6),pfhelp(kf),yh(nz)
	character *20 apr
c=========================================


	do i=1,nr
	do j=1,nz
C
	kk=(i-1)*nz+j

	psext(kk)=0.
	PSEXT0=0.
c
	DO K=1,NPF
	psext0=psext0+PF(K)*FLUXARR(kk,K)
	END DO
c
	pscam=0.
	DO K=1,ncam
	pscam=pscam+tcam(K)*vesarr(kk,K)
	END DO
	psext0=psext0+pscam

	PSEXT(kk)=psext(kk)+PSEXT0*api
	end do
	end do

	tokc=0.
	DO k=1,ncam
	tokc=tokc+tcam(K)
	END DO

!        print *,' tokc  eu ===',tokc,eu

        psi_max=-1.e10
        psi_min=1.e10

	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	psi0=pspl(kk)+psext(kk)


	psix=omega*psi0+(1.-omega)*psi_g(i,j)

	psi(i,j)=psix

	dist=sqrt( (rmag-x(i))**2+(zmag-y(j))**2)

c		print *,' i j dist index_ves ',i,j,dist,index_ves(kk)

c	if(index_ves(kk).eq.1.and.dist.le.eu)then
	if(dist.le.eu)then

c	print *,' i j psix pspl ',i,j,psix,pspl(kk)

	   if(psix.ge.psi_max)then
              psi_max=psix
              imax=i
              jmax=j
           end if
           end if


c	if(index_ves(kk).eq.1)then
	   if(psix.le.psi_min)then
              psi_min=psix
              imin=i
              jmin=j
           end if
c        end if

	end do
	end do


!	print *,' i j rmag zmag psi_max',imax,jmax,rmag,zmag,
!     *	psi(imax,jmax)
!	print *,'i j rmin zmin psi_min ',imin,jmin,x(imin),y(jmin),psi_min

	rmag=x(imax)
	zmag=y(jmax)

!	print *,' rmag zmag ',rmag,zmag


      call mag_axis(imax,jmax)

	!print *,' rmag zmag pmag',rmag,zmag,pmag

c	ksep=-1
c	call spoint(ksep,xw,yw,fint,rmag,zmag,pmag,
c     *  rsep,zsep,psep,rsep1,zsep1,psep1)
c
c	print *,' rmag zmag pmag',rmag,zmag,pmag
c
        um=rmag
        vm=zmag

        r0=rmag
        z0=zmag

        psi_max=pmag


71	format(20x,a6/,(6(1pe10.3)))


	return
	end


        subroutine eu_calc()
	include 'double.inc'
        include 'new_com.inc'

        call eu_calc_c(
     *  rmag,zmag,rsep,zsep,eu,sp_t,sp_pl,elong,pi)

        return
        end

        subroutine eu_calc_c(
     *  rmag,zmag,rsep,zsep,eu,sp_t,sp_pl,elong,pi)

c        eu=sqrt( (rmag-rsep)**2+(zmag-zsep)**2 )
c        if(abs(s_t).gt.1.)eu=sqrt( s_t )

	include 'double.inc'
	if(elong.le.0.8)elong=0.8

c	eu=sqrt( abs(sp_pl)/(pi*elong) )
	eu=sqrt( abs(sp_t)/(pi*elong) )


	if(eu.lt.1.)eu=1.

!        print *,' sp_t sp_pl elong EU=====',sp_t,sp_pl,elong,eu

        return
        end

	subroutine separ_coor()
	include 'double.inc'

c                                                                       
        include 'parf0'                                                 
        include 'parf2'                                                 
	common                                                                 
     *  /ge1/pi                                                         
     *  /ge2/NTAY,TAY,TT                                                
     *  /ge5/kpr                                                        
	common                                                                 
     *	/n_m/n,m,mp                                                      
	common                                                                 
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nr),y(nz),dx,dy                    
     *  /eq1g/psi_g(nr,nz)                                              
     *  /eq15/pll,zsep,rsep,zsepup,rsepup,zsepdw,rsepdw
	common                                                                 
     *	/fluxc1/xp1(50,mu1),yp1(50,mu1)                                  
     *	/fluxc6/pmag,pbound,psep,p_s,delaval,dr_h                        


      common /sep_points/n_sep,x_sep(mu1),y_sep(mu1)
                                                                        
	dimension ind1(50),pdd(6)                                              
                                                                        
	character *20 apr                                                      
                                                                        
	delta0=sqrt(dx**2+dy**2)

	aval=psep
	                                                            
	do i0=1,20                                                              
	ind1(i0)=0                                                             
	end do                                                                 
c                                                                       
	dcur=1.e-11*(abs(aval)+1.)                                             
	call fluxcont(nn,mm,PSI,aval,x,y,xp1,yp1,num,ind1,delta0,dcur)         
c       
	mcurve=0 
	k=0 
	kk=0                                                              
	do i=1,20
	m_sep=ind1(i)
	if(m_sep.gt.2)then
	kk=kk+1
	mcurve=mcurve+m_sep                                                         
      DO  J=1,m_sep

	if(yp1(i,j).le.zsepup+0.99*dy)then
	k=k+1                                                    
      x_sep(k)=xp1(i,j)                                                   
      y_sep(k)=yp1(i,j)  
	
	end if
	                                                 
	end do 
	end if
	end do

	n_sep=k

	k_d=0
      do j=2,n_sep
        x1=x_sep(j-1)
        x2=x_sep(j)
        y1=y_sep(j-1)
        y2=y_sep(j)

        delta=sqrt( (x2-x1)**2+(y2-y1)**2 )

        if(abs(delta).gt.2.*delta0)then
		k_d=k_d+1      
	   end if
	end do



!	print *,' n_sep kk k_d psep ==',n_sep,kk,k_d,psep
	     
c	stop		                                                            
c                                                                       
                                                                        
71	format(20x,a6/,(6(1pe10.3)))                                         
                                                                        
                                                                        
	return                                                                 
	end                                                                    
  
	subroutine separ_coor2()
	include 'double.inc'
	include 'new_com.inc'

	call separ_coor2_c(
     *  n_sep2,x_sep2,y_sep2,psep2,rsep2,zsep2)


	return                                                                 
	end                                                                    
	subroutine separ_coor2_c(
     *  n_sep2,x_sep2,y_sep2,psep2,rsep2,zsep2)
	include 'double.inc'

c                                                                       
        include 'parf0'                                                 
        include 'parf2'                                                 
	common                                                                 
     *  /ge1/pi                                                         
     *  /ge2/NTAY,TAY,TT                                                
     *  /ge5/kpr                                                        
	common                                                                 
     *	/n_m/n,m,mp                                                      
	common                                                                 
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nr),y(nz),dx,dy                    
     *  /eq1g/psi_g(nr,nz)                                              

	common                                                                 
     *	/fluxc1/xp1(50,mu1),yp1(50,mu1)                                  
     *	/fluxc6/pmag,pbound,psep,p_s,delaval,dr_h                        

                                                                        
	dimension ind1(50),pdd(6)                                              

	dimension x_sep2(*),y_sep2(*)                                              

                                                                        
	character *20 apr                                                      
                                                                        
	delta0=sqrt(dx**2+dy**2)

	aval=psep2

!	print *,' aval psep2 ==',aval,psep2
	      
	if(dabs(psep2).gt.5.d11)then
	rsep2=0.d0
	zsep2=0.d0
	n_sep2=0
	!print *,' n_sep2 rsep2 zsep2 ==',n_sep2,rsep2,zsep2
	end if
	      
	                                                            
	do i0=1,20                                                              
	ind1(i0)=0                                                             
	end do                                                                 
c                                                                       
	dcur=1.e-11*(abs(aval)+1.)                                             
	call fluxcont(nn,mm,PSI,aval,x,y,xp1,yp1,num,ind1,delta0,dcur)         
c       
	mcurve=0 
	k=0 
	kk=0                                                              
	do i=1,20
	m_sep=ind1(i)
	if(m_sep.gt.5)then
	kk=kk+1
	mcurve=mcurve+m_sep                                                         

      DO  J=1,m_sep
	k=k+1                                                    
      x_sep2(k)=xp1(i,j)                                                   
      y_sep2(k)=yp1(i,j)  
	end do 
	end if
	end do

	n_sep2=mcurve

!	print *,' n_sep2 kk  psep2 ==',n_sep2,kk,psep2
	     
c	stop		                                                            
c                                                                       
                                                                        
71	format(20x,a6/,(6(1pe10.3)))                                         
                                                                        
                                                                        
	return                                                                 
	end                                                                    
  


	subroutine pomin_pet_r(ro0,tetpol,ntet,rm,zm,rxb,zxb,nxb,pi)
	include 'double.inc'

	dimension ro0(*),tetpol(*),rxb(*),zxb(*)

	include 'parf2'

	dimension roxb(mu1),tetxb(mu1)

	 dimension rwork(mu1),zwork(mu1)

	character *20 apr                                                      
                                                                        

	data err /1.d-12/
	
c	print *,' rm zm nxb ntet pi',rm,zm,nxb,ntet,pi

C-----CHECK AND CORRECTION OF DIRECTION OF BOUNDARY ORIENTATION
C

	 do 1 i=1,nxb
	    rwork(i) = rxb(i)
 1	    zwork(i) = zxb(i)

	    vecpro = (rwork(1) - rm)*(zwork(2) - zm) -
     *	 (zwork(1) - zm)*(rwork(2) - rm)
C
	     
c	     print *,' vecpro ntet nxb ',vecpro,ntet,nxb
c	     print *,' rw 1 n ',rwork(1),rwork(nxb)
c	     print *,' zw 1 n ',zwork(1),zwork(nxb)

	     if( vecpro .gt. 0 ) then
		do 2 i=1,nxb
		   rxb(i) = rwork(i)
    2              zxb(i) = zwork(i)
	else
		   do 3 i=1,nxb
		      rxb(i) = rwork(nxb-i+1)
    3                 zxb(i) = zwork(nxb-i+1)
	end if



c	open(unit=43,file='rxb_coor',form='formatted')
c	write(43,*)nxb
c	do i=1,nxb
c	write(43,*)rxb(i),zxb(i)
c	end do
c	close(43)

C---------------------------------------------------------------
C     End of plasma boundary treatment
C---------------------------------------------------------------


	ig=1

	   drx=rxb(ig)-rm
	   dzx=zxb(ig)-zm

         tetp=atan(dzx/drx)

 	   tetp_in=tetp


		if(drx.lt.0.) tetp=tetp+pi


	     tetxb(ig)=tetp



	     roxb(ig)=sqrt(drx**2+dzx**2)


c      write(6,'("ig,tet tetp_in tetp_in2 drx deltet", i4,6(1pe12.5))'),
c     *  ig,tetxb(ig),tetp_in,tetp_in2,drx,deltet


	do 200 ig=2,nxb

	   drx=rxb(ig)-rm
	   dzx=zxb(ig)-zm

	    tetp=atan(dzx/drx)

	    tetp_in=tetp


		if(drx.lt.0.) tetp=tetp+pi

	    tetp_in2=tetp

		deltet=tetp-tetxb(ig-1)

		if(deltet.lt.0.) tetp=tetp+2.*pi



	     tetxb(ig)=tetp



	     roxb(ig)=sqrt(drx**2+dzx**2)


c        write(6,'("ig,tet tetp_in tetp_in2 drx deltet", i4,6(1pe12.5))'),
c     *  ig,tetxb(ig),tetp_in,tetp_in2,drx,deltet



 200        continue


	apr='roxb'                                                              
c	print 71,apr,(roxb(j),j=1,nxb) 


	nt=nxb
	nt1=nt-1

        DO 210 j=2,Ntet-1
           tetp=tetpol(j)

           if(tetp.lt.tetxb(1))tetp=tetp+2.d0*pi

           if(tetp.gt.tetxb(nxb))tetp=tetp-2.d0*pi

	   call feeti(nxb,roxb,cwk,tetxb,tetp)

	   ro0(j)=cwk

c       write(6,*) 'ifail=',ifail,j
 210    CONTINUE

c	stop

	apr='tetxb'                                                              
c	print 71,apr,(tetxb(j),j=1,nxb) 

	apr='roxb'                                                              
c	print 71,apr,(roxb(j),j=1,nxb) 


	apr='tetpol'                                                              
c	print 71,apr,(tetpol(j),j=1,ntet) 

	apr='ro0'                                                              
c	print 71,apr,(ro0(j),j=1,ntet) 




	ro0(1)=ro0(ntet-1)
	ro0(ntet)=ro0(2)



        DO j=2,Ntet-1
           tetp=tetpol(j)

           if(tetp.lt.tetxb(1))tetp=tetp+2.d0*pi
           if(tetp.gt.tetxb(nxb))tetp=tetp-2.d0*pi

	do i=2,nxb

	if( (tetp-tetxb(i))*(tetp-tetxb(i-1)).le.0 )then

c	print *,' i j  1 ro0 2 =',i,j,roxb(i-1),ro0(j),roxb(i)
c	print *,'  1 tet tetp  2 =',tetxb(i-1),tetpol(j),tetp,tetxb(i)

	end if
	end do

	
	end do



71	format(20x,a6/,(6(1pe10.3)))                                         



           return
           end

	subroutine br_bz_rus_kav()
	include 'double.inc'
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

	common
     *  /pol4/ UM,VM,UK(ntet),VK(ntet)

	dimension pdd(6),pfhelp(kf),a_print(200)

	real *8 psi_8(nr,nz)

	character *20 apr

	ksep=-1
c	rmag=rref
c	zmag=zref

	call spoint(ksep,xw,yw,fint,rmag,zmag,pmag,
     *  rsep,zsep,psep,rsep1,zsep1,psep1)

	print *,' rmag zmag ',rmag,zmag


	zmag0=zmag
	rmag0=rmag


        print *,' ** brad bvert',brad,bvert


	i_en=i_en+1
	if(i_en.le.1)then
c	if(i_en.eq.1)then
c	   rref=rmag
c	   zref=zmag
	end if

	k=0

 1	   continue

	k=k+1

	a_print(1)=rmag
	a_print(2)=zmag
	a_print(3)=rref
	n_pr=3
	apr='  **rmag zmag rref br_bz **'
	num=20
c	call out42(n_pr,a_print,num,apr)

	urr=rref
	vrr=zref

	print *,'++ rref zref ',rref,zref


	a_print(1)=urr
	a_print(2)=vrr
	a_print(3)=rref
	n_pr=3
	apr='  **rmag zmag rref br_bz **'
	num=20
c	call out42(n_pr,a_print,num,apr)

	call boxd(urr,vrr,pdd,ier)

c---------------
	psi_r=pdd(2)
	psi_z=pdd(3)
c-------------------

	brad_p=-psi_z
	bvert_p=-psi_r

      print *,' k brad_p bvert_p',k,brad_p,bvert_p

	brad=brad+brad_p
	bvert=bvert+bvert_p

      print *,' k brad bvert',k,brad,bvert

	a_print(1)=brad
	a_print(2)=bvert
	a_print(3)=brad_p
	a_print(4)=bvert_p
	a_print(5)=k

	n_pr=5
	apr='**br_bz* k '
	num=30
c	call out42(n_pr,a_print,num,apr)

	
c	print *,' brad bvert ',brad,bvert
c	if(kpr.eq.1)print *,' brad_f bvert_f ',brad_f,bvert_f

	do i=1,nr
	   do j=1,nz
	      kk=(i-1)*nz+j
c---
c---
c		 psi(i,j)=psi(i,j)+brad*y(j)+bvert*x(i)
c---
	      psi(i,j)=psi(i,j)+brad_p*(y(j)-zref)+
     *  bvert_p*x(i)*x(i)/(2.*rref)


	   end do
	end do


c       if(dabs(brad_f)+dabs(bvert_f).gt.5.e-8)go to 1

c       stop

	ksep=-1
	rmag=urr
	zmag=vrr

	call spoint(ksep,xw,yw,fint,rmag,zmag,pmag,
     *  rsep,zsep,psep,rsep1,zsep1,psep1)

       if(k.lt.4)go to 1


	a_print(1)=rmag
	a_print(2)=rref
	a_print(3)=zmag
	a_print(4)=zref
	a_print(5)=brad
	a_print(6)=bvert

	n_pr=6
	apr='**rm zm rf zf br_bz*'
	num=30
c	call out42(n_pr,a_print,num,apr)

c	read (*,*)

	um=rmag
	vm=zmag

	call boxd(urr,vrr,pdd,ier)
c---------------
	psi_r=pdd(2)
	psi_z=pdd(3)
c-------------------
	brad_fin=-psi_z
	bvert_fin=-psi_r

	a_print(1)=rmag
	a_print(2)=zmag
	a_print(3)=brad
	n_pr=3
	apr='--rmag zmag br_bz s**'
	num=20
c	call out42(n_pr,a_print,num,apr)
        print *,' brad_fin bvert_fin ',brad_fin,bvert_fin
        print *,' brad_p bvert_p ',brad_p,bvert_p
        print *,' k brad bvert',k,brad,bvert

c	call pau()

        return
        end



	subroutine br_bz_rus()
	include 'double.inc'
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

	common
     *  /pol4/ UM,VM,UK(ntet),VK(ntet)

	dimension pdd(6),pfhelp(kf),a_print(200)

	real *8 psi_8(nr,nz)

	character *20 apr

	ksep=-1
c	rmag=rref
c	zmag=zref

	call spoint(ksep,xw,yw,fint,rmag,zmag,pmag,
     *  rsep,zsep,psep,rsep1,zsep1,psep1)

c	print *,' rmag zmag pmag',rmag,zmag,pmag


	zmag0=zmag
	rmag0=rmag

	i_en=i_en+1
	if(i_en.le.1)then
c	if(i_en.eq.1)then
c	   rref=rmag
c	   zref=zmag
	end if

 1	   continue

	a_print(1)=rmag
	a_print(2)=zmag
	a_print(3)=rref
	n_pr=3
	apr='  **rmag zmag rref br_bz **'
	num=20
c	call out42(n_pr,a_print,num,apr)

	urr=rref
	vrr=zref

c	print *,'rref zref ',rref,zref


	a_print(1)=urr
	a_print(2)=vrr
	a_print(3)=rref
	n_pr=3
	apr='  **rmag zmag rref br_bz **'
	num=20
c	call out42(n_pr,a_print,num,apr)
	call boxd(urr,vrr,pdd,ier)

c---------------
	psi_r=pdd(2)
	psi_z=pdd(3)
c-------------------

	brad=-psi_z
	bvert=-psi_r

	
c	print *,' brad bvert ',brad,bvert
c	if(kpr.eq.1)print *,' brad_f bvert_f ',brad_f,bvert_f

	do i=1,nr
	   do j=1,nz
	      kk=(i-1)*nz+j
c---
c---
c		 psi(i,j)=psi(i,j)+brad*y(j)+bvert*x(i)
c---
	      psi(i,j)=psi(i,j)+brad*(y(j)-zref)+
     *  bvert*x(i)*x(i)/(2.*rref)


	   end do
	end do

c       if(dabs(brad_f)+dabs(bvert_f).gt.5.e-8)go to 1

c       stop

	ksep=-1
	rmag=urr
	zmag=vrr

	call spoint(ksep,xw,yw,fint,rmag,zmag,pmag,
     *  rsep,zsep,psep,rsep1,zsep1,psep1)


	a_print(1)=rmag
	a_print(2)=zmag
	a_print(3)=brad
	n_pr=3
	apr='  **rmag zmag br_bz s**'
	num=20
c	call out42(n_pr,a_print,num,apr)

c	if(kpr.eq.1)print *,' rmag zmag pmag',rmag,zmag,pmag

	um=rmag
	vm=zmag

	call boxd(urr,vrr,pdd,ier)
c---------------
	psi_r=pdd(2)
	psi_z=pdd(3)
c-------------------
	brad_fin=-psi_z
	bvert_fin=-psi_r

	a_print(1)=rmag
	a_print(2)=zmag
	a_print(3)=brad
	n_pr=3
	apr='--rmag zmag br_bz s**'
	num=20
c	call out42(n_pr,a_print,num,apr)
c        print *,' brad_fin bvert_fin ',brad_fin,bvert_fin

c	call pau()

        return
        end


c********************************************************************
	subroutine write_separ_coor()
	include 'double.inc'
	include 'new_com.inc'

c	print*,'from write_separ_coor'

	call write_separ_coor_c(
     &  tt,ksepa,rsep,zsep)

	return
	end

	subroutine write_separ_coor_c(
     &  tt,ksepa,rsep,zsep)

	include 'double.inc'
        include 'parf2'                                                 
	common /sep_points/n_sep,x_sep(mu1),y_sep(mu1)

	i_form=1

	if(i_form.eq.1)then
	open (unit=73,file='separ_coor',access='append',
     &  form='formatted')

!	print*,'!!!tt ksepa',tt,ksepa


	if(ksepa.eq.0)then
	   write (73,*)tt,n_sep,ksepa
	   write (73,5000)(x_sep(i),i=1,n_sep)
	   write (73,5000)(y_sep(i),i=1,n_sep)
	else
	   write (73,*)tt,n_sep+1,ksepa
	   write (73,5000)(x_sep(i),i=1,n_sep),rsep
	   write (73,5000)(y_sep(i),i=1,n_sep),zsep
	end if
	   
	close(73)
	else

	open (unit=73,file='separ_coor',access='append',
     &  form='unformatted')

	if(ksepa.eq.0)then
	   write (73)tt,n_sep
	   write (73)(x_sep(i),i=1,n_sep)
	   write (73)(y_sep(i),i=1,n_sep)
	else
	   write (73)tt,n_sep+1
	   write (73)(x_sep(i),i=1,n_sep),rsep
	   write (73)(y_sep(i),i=1,n_sep),zsep
	end if

	close(73)

	end if

 5000	format(4(1x,1pe14.7))
 5001	format((1x,1pe14.7),i4)

	return
	end


c********************************************************************
	subroutine write_separ_coor2()
	include 'double.inc'
	include 'new_com.inc'

	call write_separ_coor_c2(
     *  n_sep2,x_sep2,y_sep2,
     &  tt)

	return
	end

	subroutine write_separ_coor_c2(
     *  n_sep2,x_sep2,y_sep2,
     &  tt)

	include 'double.inc'
        include 'parf2'    
	                                               
	dimension x_sep2(*),y_sep2(*)

	i_form=1

	if(i_form.eq.1)then
	open (unit=73,file='separ_coor2.dat',access='append',
     &  form='formatted')
	
	write (73,5001)tt,n_sep2
	write (73,5000)(x_sep2(i),i=1,n_sep2)
	write (73,5000)(y_sep2(i),i=1,n_sep2)

	close(73)
	else

	open (unit=73,file='separ_coor2.dat',access='append',
     &  form='unformatted')

	write (73)tt,n_sep2
	write (73)(x_sep2(i),i=1,n_sep2)
	write (73)(y_sep2(i),i=1,n_sep2)

	close(73)

	end if

 5000	format(4(1x,1pe14.7))
 5001	format((1x,1pe14.7),i4)

	return
	end

c*************************************************************
	subroutine second_sep()                               
	include 'double.inc'                                                  
	include 'new_com.inc'                                                  
                                                                        
	call second_sep_c(
     *  rmag,zmag,rsep,zsep,
     *  rsep2,zsep2,psep2,kpr,ksepa,rsep2_r,zsep2_r)
                                                                        
	return                                                                 
	end                                                                    
                                                                        
	subroutine second_sep_c(
     *  rmag,zmag,rsep,zsep,
     *  rsep2,zsep2,psep2,kpr,ksepa,rsep2_r,zsep2_r)
	include 'double.inc'                                                  


	rsep2_r=0.d0
	zsep2_r=0.d0

      if(ksepa.eq.0)then
	zsep2=0.d0
	rsep2=0.d0
      if(kpr.eq.1)write(6,'(" ksepa rsep2 zsep2  ", i4,6(1pe12.5))'),
     *  ksepa,rsep2,zsep2
	return      
      end if
      

	zsep2=2.*zmag-zsep
	rsep2=rsep

	if(kpr.eq.1)then
      write(6,'(" rsep zsep psep ", 6(1pe12.5))'),
     *  rsep,zsep,psep

      write(6,'(" ksepa rsep2 zsep2  ", i4,6(1pe12.5))'),
     *  ksepa,rsep2,zsep2
	 
	end if
c
	ksep=-1
	call spoint(ksep,xw,yw,fint,rsep2,zsep2,psep2,
     *  rsep3,zsep3,psep3,rsep1,zsep1,psep1)
	
c	print *,' rsep2 zsep2 psep2 ksep',

	if(abs(psep2).gt.5.e11)then
	   rsep2=0.d0
	   zsep2=0.d0
      else

	if(kpr.eq.1)then
       write(6,'(" ksep rsep2 zsep2 psep2 ", i4,6(1pe12.5))'),
     *  ksep,rsep2,zsep2,psep2
	end if

      call separ_coor2_lim()
!      call write_separ_coor2_lim()
	end if

	return
	end



	subroutine separ_coor2_lim()
	include 'double.inc'
	include 'new_com.inc'

!      print *,' kex==',kex

	call separ_coor2_lim_c(
     *  n_sep2,x_sep2,y_sep2,psep2,rsep2,zsep2,ke,xu,yu,
     *  kex,xue,yue,rmag,zmag,pmag,
     *  rsep2_gr,zsep2_gr,rsep2_l,zsep2_l,rsep2_r,zsep2_r,ksepa)

	return                                                                 
	end                                                                    
	subroutine separ_coor2_lim_c(
     *  n_sep2,x_sep2,y_sep2,psep2,rsep2,zsep2,ke1,xu1,yu1,
     *  kex,xue,yue,rmag,zmag,pmag,
     *  rsep2_gr,zsep2_gr,rsep2_l,zsep2_l,rsep2_r,zsep2_r,ksepa)

	include 'double.inc'

	include 'parf0'
	
	dimension pdd(6)
c                                                                       
	common                                                                 
     *  /ge1/pi                                                         
     *  /ge5/kpr                                                        

      parameter ( nn=2000)
      
	common /c_separ2_lim/r_lim(100),z_lim(100),n_lim

	dimension x_sep2(*),y_sep2(*),xu1(*),yu1(*),xue(*),yue(*),
     * xu(nn),yu(nn),psi_lim(nn)
                                                                               
	character *20 apr                                                      

      i_en=i_en+1
      
      if(i_en.eq.1)then
            
	n_k=10
	kk=0
	xu(1)=xu1(1)
	yu(1)=yu1(1)
	kk=kk+1

      do  i=2,ke1
	do k=1,n_k
	kk=kk+1
	xu(kk)=xu1(i-1)+dfloat(k)/dfloat(n_k)*(xu1(i)-xu1(i-1))
	yu(kk)=yu1(i-1)+dfloat(k)/dfloat(n_k)*(yu1(i)-yu1(i-1))
	end do
	
!	xu(i)=xu1(i)
!	yu(i)=yu1(i)
	end do

	ke=kk
!	ke=ke1

!      print *,' ke1 ke===========',ke1,ke
            
      if(ke.gt.1999)then      
!      print *,' ke gt 2000',ke
      stop
      end if
            
	do i=1,ke
      if(yu(i).gt.0)then
!	yu(i)=yu(i)+70.d0
      end if
      
      end do

        apr= '++xu '
        if(kpr.eq.-1)print 71,apr,(xu(i),i=1,ke)
        apr= '++yu '
        if(kpr.eq.-1)print 71,apr,(yu(i),i=1,ke)
            
      
      end if
         


        apr= 'xue '
        if(kpr.eq.-1)print 71,apr,(xue(i),i=1,kex)
        apr= 'yue '
        if(kpr.eq.-1)print 71,apr,(yue(i),i=1,kex)


	r_max=xu(1)
	r_min=xu(1)

	z_max=yu(1)

	do i=1,ke
	urr=xu(i)
	
	if(urr.gt.r_max)r_max=urr
	if(urr.lt.r_min)r_min=urr

	vrr=yu(i)	
	if(vrr.gt.z_max)z_max=vrr

	psi_lim(i)=1.d12
        call caet2(rmag,zmag,urr,vrr,ipoint,kex,xue,yue)
	if(ipoint.eq.1)then
	call boxd(urr,vrr,pdd,ier)
	psi_lim(i)=pdd(1)
!	 print *,' i vrr psi_lim psep2',i,vrr,psi_lim(i),psep2
	else
!	 print *,' --- i urr vrr',i,urr,vrr
	end if

	end do                       

	k=0	
	n_lim=k
	do i=2,ke

	if(dabs(psi_lim(i-1)).gt.5.d11)goto 2
	if(dabs(psi_lim(i)).gt.5.d11)goto 2

	if((psi_lim(i-1)-psep2)*(psi_lim(i)-psep2).le.0.d0)then



      psep_2=psep2
      i_int=0
      ps_1=psi_lim(i-1)
      ps_2=psi_lim(i)
      xu_1=xu(i-1)
      yu_1=yu(i-1)
      xu_2=xu(i)
      yu_2=yu(i)


	vrr=yu_1+(psep2-ps_1)/
     *  (ps_2-ps_1)*(yu_2-yu_1)

!	print *,' --- i ps_1 psep2 ps_2  vrr',i,ps_1,psep2,ps_2,vrr


1     continue

	urr=xu_1+( psep2-ps_1)/
     *  (ps_2-ps_1)*(xu_2-xu_1)
	vrr=yu_1+(psep2-ps_1)/
     *  (ps_2-ps_1)*(yu_2-yu_1)

	call boxd(urr,vrr,pdd,ier)
	psep_2=pdd(1)

!	print *,' --- ps_1 ps_2 psep_2 psep2',ps_1,ps_2,psep_2,psep2

	if((ps_1-psep2)*(psep_2-psep2).le.0.d0)then
      ps_2=psep_2
      xu_2=urr
      yu_2=vrr
      else
      ps_1=psep_2
      xu_1=urr
      yu_1=vrr
      end if
      
      i_int=i_int+1
      if(dabs(psep_2-psep2).gt.1.d-5*pmag.and.i_int.le.5)go to 1

!	print *,' +++i_int psep_2 psep2 pmag',i_int,psep_2,psep2,pmag

      if(vrr.gt.0)then
!	print *,' +++i i_int p1 psep2 p2 del ',i,i_int,
!     *  psi_lim(i-1),psep2,psi_lim(i)

!	print *,' +++urr1 urr urr2',xu(i-1),urr,xu(i) 
!	print *,' +++vrr1 vrr vrr2',yu(i-1),vrr,yu(i) 
      end if
      
	if(vrr.gt.zsep2)then
	k=k+1
	r_lim(k)=urr
	z_lim(k)=vrr
!	 print *,' +++ k r z',r_lim(k),z_lim(k)
	n_lim=k
	end if

	end if

2     continue


	end do                       

!	 print *,' rsep2 zsep2 n_lim',rsep2,zsep2,n_lim
!	 print *,' r_min r_max z_max',r_min,r_max,z_max
	

c*************** Victor's additional *************************
	rsep2_gr=0.
	zsep2_gr=0.
	rsep2_l=0.
	zsep2_l=0.
	rsep2_r=0.
	zsep2_r=0.
	if(ksepa.eq.1)then
	   rsep2_gr=rsep2
	   zsep2_gr=zsep2
	   if(n_lim.eq.0)then
	      rsep2_l=0.
	      zsep2_l=0.
	      rsep2_r=0.
	      zsep2_r=0.
	   else
	      do i=1,n_lim
		 if(r_lim(i).le.rsep2.and.z_lim(i).ge.zsep2)then
		    rsep2_l=r_lim(i)
		    zsep2_l=z_lim(i)
		 end if
	      end do
	      do i=1,n_lim
		 if(r_lim(i).ge.rsep2.and.z_lim(i).ge.zsep2)then
		    rsep2_r=r_lim(i)
		    zsep2_r=z_lim(i)
		 end if
	      end do
	   end if
	end if

!	 print *,' rsep2_r zsep2_r',rsep2_r,zsep2_r
	 
!	print*,'ksepa rsep2_gr zsep2_gr n_lim',
!     *  ksepa,rsep2_gr,zsep2_gr,n_lim

c                                                                                 
71	format(20x,a6/,(6(1pe10.3)))                                         
                                                                        
                                                                        
	return                                                                 
	end                 

      
	subroutine cur_tor_out()
	include 'double.inc'
        include 'parf1'
        include 'parf2'
        include 'parf4'

	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /ge2/NTAY,TAY,TT
     *	/ge1e/rs0,tpl
     *  /ge5/kpr                                                        
        common
     *  /keys10/ngra
        common
     *  /fluxc11/npl,pl_cur(nwnh),x_cur(nwnh),y_cur(nwnh)

	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nn),y(MM),dx,dy

        common
     *  /ves1/psp(mu),psp0(mu),tcam(mu),tcam0(mu)
     *  /ves2/ncam,rc(mu),zc(mu)

	dimension pjk(mu)


        i_en=i_en+1
      
       if(i_en.eq.1)then
       open (unit=41,file='cur_dat.dat',form='formatted')
        else
       open(unit=41,file='cur_dat.dat',access='append',form='formatted')
       end if
        
!        write (41,*)'npl time [msec]'
        write (41,*)npl,tt
!        write (41,*)'rpl   zpl  tokpl'
        tok=0.
        do i=1,npl
        write (41,5000)x_cur(i),y_cur(i),dx,dy,pl_cur(i)*1.d3
        tok=tok+pl_cur(i)
        end do
        if(kpr.eq.1)print *,' npl tok================',npl,tok

        close (41)

5000    format (6(1pe13.4))


	  return
        end

