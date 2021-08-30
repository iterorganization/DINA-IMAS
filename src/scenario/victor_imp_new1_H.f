	
	subroutine vic_br_bz()
	include 'double.inc'
	include 'new_com.inc'

	call vic_br_bz_c(
     *  npf,pf,coef,f_jp,ncam,tcam,rc,zc,b_cs,kpr)

	return
	end

	subroutine vic_br_bz_c(
     *  npf,pf,coef,f_jp,ncam,tcam,rc,zc,b_cs,kpr)
	include 'double.inc'
	include 'parf2'

	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nr),y(nz),dx,dy
	dimension pf(*),f_jp(*),tcam(*),rc(*),zc(*)
	dimension brr(50),bzz(50),pdd(6)
	dimension r_b(3),z_b(3),b_cs(3)

        i_en=i_en+1

  	if(i_en.eq.1)then
           call pf_coor()
           if(kpr.eq.1)print *,' CALL ELKE...'
           call edim1
        end if

c*** Br, Bz calculation in T *******************
	n1=nr-1
	m1=nz-1
c        urr=120.
        urr=620.
c        vrr=0.
        vrr=300.
        b_c=0.1
c
	r_b(1)=136.2
	z_b(1)=106.3
	r_b(2)=136.2
	z_b(2)=0.
	r_b(3)=136.2
	z_b(3)=-106.2
	do 1000 mmm=1,3
	   urr=r_b(mmm)
	   vrr=z_b(mmm)

        bz=0.
        br=0.
c*** from PFc ***
	call bisa(brr,bzz,urr,vrr)
        do jj=1,npf
        bz=bz+bzz(jj)*pf(jj)*b_c
        br=br+brr(jj)*pf(jj)*b_c
        end do
c*** from plasma ***
        t_tok=0.
        DO i=2,N1
        DO j=2,M1
        kk=(i-1)*nz+j
        call brz(br_p,bz_p,urr,x(i),vrr,y(j))
        bz=bz+bz_p*f_jp(kk)*coef*dx*dy*b_c
        br=br+br_p*f_jp(kk)*coef*dx*dy*b_c
        t_tok=t_tok+f_jp(kk)*coef*dx*dy
        end do
        end do
c*** from vessel ***
        do  k=1,ncam
        call brz(br_v,bz_v,urr,rc(k),vrr,zc(k))
	br=br+br_v*tcam(k)*b_c
	bz=bz+bz_v*tcam(k)*b_c
	end do
c
	if(kpr.eq.1)print*,'t_tok=',t_tok
	if(kpr.eq.1)print*,'urr vrr',urr,vrr
	if(kpr.eq.1)print*,'br bz',br,bz
c	pause
c*** Now by means of GRAD_PSI ***
c	call boxd(urr,vrr,pdd,ier)
c        psi_r=pdd(2)
c	psi_z=pdd(3)
c        br_psi=-psi_z/urr*b_c
c        bz_psi=psi_r/urr*b_c
c        print*,'bz_psi br_psi',bz_psi,br_psi
c        print*,'bz br',bz,br
c        pause 'from vic_br_bz'
	b_cs(mmm)=sqrt(br**2+bz**2)
	
 1000	continue

        return
        end
c******************************************
        subroutine vic_zeff_read()
	include 'double.inc'
	include 'new_com.inc'

	call vic_zeff_read_c(
     *       zeff_a,zeff_b,zeff,a,n,tt,pcch,pcchp,ntay)

	return
	end

        subroutine vic_zeff_read_c(
     *       zeff_a,zeff_b,zeff,a,n,tt,pcch,pcchp,ntay)

	include 'double.inc'
 	include 'parf_mike' 

        common
     *  /ge5/kpr
        dimension a(*),zeff(*)
	dimension t_t(ntime),zeff_a_t(ntime),zeff_b_t(ntime)
	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='zeff.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 
           
           if(kpr.eq.1)print *,' tay tt n_t===',tay,tt,n_t 
           
           do i=1,n_t 
              read (41,*)t_t(i),zeff_a_t(i),zeff_b_t(i)
              t_t(i)=t_t(i)*1000. 
           end do 
           
           apr='-t_t-' 
           if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 

           apr='-zeff_a_t-' 
           if(kpr.eq.1)print 71,apr,(zeff_a_t(i),i=1,n_t) 

           apr='-zeff_b_t-' 
           if(kpr.eq.1)print 71,apr,(zeff_b_t(i),i=1,n_t) 

           close (unit=41) 
        end if

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

        do i=2,n_t
           if((tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
              t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )

              zeff_a=zeff_a_t(i-1)+t_coef*
     *             (zeff_a_t(i)-zeff_a_t(i-1))
              zeff_b=zeff_b_t(i-1)+t_coef*
     *             (zeff_b_t(i)-zeff_b_t(i-1))
c
	 end if

	 end do
c*****************************
        if(kpr.eq.1)print *,'from zeff_read zeff_a zeff_b ntay',
     *        zeff_a,zeff_b,ntay
        if(kpr.eq.1)print*,'pcch_0 pcch pcchp',pcch_0,pcch,pcchp

	do i=1,n
           psix=a(i)
           zeff(i)=zeff_a+(zeff_b-zeff_a)*psix
        end do
c	if(kpr.eq.1)print*,(zeff(i),i=1,n)
c	pause 'from vic_zeff_read'
        
	return
	end
c**********************************************
        subroutine vic_dens()
	include 'double.inc'
	include 'new_com.inc'

	call vic_dens_c(
     *       pcchp,eu,tpl,pi,t_end,tt,tt_dw,ntay,key_h_to_l,dt_term_h)

	return
	end

	subroutine vic_dens_c(
     *       pcchp,eu,tpl,pi,t_end,tt,tt_dw,ntay,key_h_to_l,dt_term_h)

	include 'double.inc'
        common
     *  /ge5/kpr


c	print*,'ntay tt_dw dt_term_h',ntay,tt_dw,dt_term_h
c	read(*,*)

	i_sh=i_sh+1

c=================================
ccc	tt_gamma=404000.
ccc	tt_gamma=534000.
c	tt_gamma=500000.
c=================================

	if(i_sh.eq.1)then
c-------
           open (unit=40,file='dt_term.dat',form='formatted') 
           read (40,*) 
           read (40,*)dt,dt_1
           close (40)

           open (unit=40,file='pcchp_end.dat',form='formatted') 
           read (40,*) 
           read (40,*)pcchp_end
           close (40)

        end if

c******* H to L at tt_dw time moment!!!!
	if(kpr.eq.1)print*,'tt dt_term_h key_gamma',tt,dt_term_h,key_gamma
	 
	if(dt_term_h.lt.1.e-5)then

	if(ntay.gt.30.and.tt.gt.tt_dw.and.key_gamma.eq.0)then
	   key_gamma=1
	   pcchp_help=pcchp
	end if
	if(key_gamma.eq.1.and.tt.le.tt+dt_1)then
cc	   pcchp=pcchp_help-(pcchp_help-4.)*(tt-tt_dw)/dt_1
ccc      pcchp=pcchp_help-(pcchp_help-1.)*(tt-tt_dw)/dt_1
	   pcchp=pcchp_help-(pcchp_help-pcchp_end)*(tt-tt_dw)/dt_1

	if(kpr.eq.1)print*,'pcchp_help pcchp pcchp_end',pcchp_help,pcchp_end

	end if
	if(tt.gt.tt_dw+dt_1.and.key_gamma.eq.1)then
	   key_gamma=2
	   gamma_mem=(pcchp/10.)*pi*eu**2*1.e-4/(tpl/1.e3)
	end if
	if(key_gamma.eq.2)then
	   pcchp=10.*gamma_mem*(tpl/1.e3)/(pi*eu**2*1.e-4)
	if(kpr.eq.1)print*,' gamma_mem pcchp',gamma_mem,pcchp
	end if

	end if
ccc end of H to L at tt_dw time moment

c********** H to L at tt_dw+dt_term_h time moment !!!
	if(dt_term_h.gt.1.e-5)then
	
	if(ntay.gt.30.and.tt.gt.tt_dw.and.key_gamma.eq.0)then
	   key_gamma=1
	   gamma_end=0.6
	   gamma_beg=(pcchp/10.)*pi*eu**2*1.e-4/(tpl/1.e3)

	if(kpr.eq.1)print*,'key_gamma gamma1 gamma2',key_gamma,
     *  gamma_end,gamma_beg


	end if
	if(key_gamma.eq.1)then
	   gamma_mem=(tt_dw+dt-tt)*(gamma_beg-gamma_end)/dt+gamma_end
c	if(gamma_mem.lt.gamma_end)gamma_mem=gamma_end
	   pcchp=10.*gamma_mem*(tpl/1.e3)/(pi*eu**2*1.e-4)
	if(kpr.eq.1)print*,' gamma_mem pcchp',gamma_mem,pcchp
	end if
c!!!	if(key_gamma.eq.1.and.tt.gt.tt_dw+dt)then
	if(key_gamma.eq.1.and.key_h_to_l.eq.1)then
	   tt_1=tt
	   key_gamma=2
ccc	   gamma_end=0.35
	   gamma_end=0.05
	   gamma_beg=gamma_mem
	end if
	if(key_gamma.eq.2)then
c	   gamma_mem=(tt_dw+dt+dt_1-tt)*
	   gamma_mem=(tt_1+dt_1-tt)*
     *  (gamma_beg-gamma_end)/dt_1+gamma_end
	   if(gamma_mem.lt.gamma_end)gamma_mem=gamma_end
	   pcchp=10.*gamma_mem*(tpl/1.e3)/(pi*eu**2*1.e-4)
	end if
	  
	end if
ccc end of H to L at tt_dw+dt_term_h time moment
	
           if(kpr.eq.1)print*,'tpl eu pcchp dt_term_h',
     *  tpl,eu,pcchp,dt_term_h
     
c        pause 'from vic_dens'

	if(kpr.eq.1)
     *   print*,'!!!!!!!!!!!!!tt tt_dw key_h_to_l',tt,tt_dw,key_h_to_l
	if(kpr.eq.1)print*,'key_gamma pcchp',key_gamma,pcchp
c	read(*,*)


        return
        end

c*******************************************************
        subroutine vic_t_edge()
	include 'double.inc'
	include 'new_com.inc'

	call vic_t_edge_c(
     *       tec,te0,tq0,n,tt,r_lh,ksepa,key_lh)

	return
	end

	subroutine vic_t_edge_c(
     *       tec,te0,tq0,n,tt,r_lh,ksepa,key_lh)

	include 'double.inc'
        common
     *  /ge5/kpr
        dimension te0(*),tq0(*)


              te0(n)=0.5
              tq0(n)=te0(n)
      
      return
      

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
	   open (unit=41,file='g_edge.dat',form='formatted') 
           read (41,*) 
           read (41,*)g_edge1,g_edge2 
           close (41)

         open (unit=41, file='scale.dat',form='formatted')
         read (41,*)
         read (41,*)scale
	 if(kpr.eq.1)print *,'scale',scale
         close (41)
        end if

	g_edge=g_edge1
c        te0(n)=10.
c*** te_b and ti_b = g_edge * tec !!!
	if(tt.gt.scale*100.e3.and.r_lh.ge.1.1.and.i_lh.eq.0)then
	i_lh=i_lh+1
	tt_beg=tt
	end if
	if(i_lh.ge.1)then
	g_edge=g_edge1+(g_edge2-g_edge1)*
     *	(tt-tt_beg)/3000.	
	if(g_edge.gt.g_edge2)g_edge=g_edge2
	end if	

c!!!        te0(n)=g_edge*tec
c        te0(n)=200.
c!!!!!  OK!!!        te0(n)=100.
        te0(n)=25.
        if(ksepa.eq.1)te0(n)=100.
ccc        if(ksepa.eq.1)te0(n)=25.
c        if(ksepa.eq.1)then
c	   te0(n)=2.*te0(n-1)-te0(n-2)
c	   if(te0(n).le.2.)te0(n)=2.
c	end if

ccc	if(ksepa.eq.1)te0(n)=g_edge1*tec
        if(key_lh.eq.1)te0(n)=190.

        tq0(n)=te0(n)

c        if(kpr.eq.1)print*,'ksepa tec te0(n)',ksepa,tec,te0(n)
c        print*, 'from victor.f'
c	read(*,*)

        return
        end
c***********************************************************
      subroutine vic_z_feed()
	include 'double.inc'
      include 'new_com.inc'

      call vic_z_feed_c(
     *     vchopper,zmag,zref,pf,zmag0,tay,pf_turns,
     *     ntay,npf,index,tpl)

      return
      end

      subroutine vic_z_feed_c(
     *     vchopper,zmag,zref,pf,zmag0,tay,pf_turns,
     *     ntay,npf,index,tpl)

	include 'double.inc'
        common
     *  /ge5/kpr
      dimension vchopper(*),pf(*),pf_turns(*),index(*)


      i_en=i_en+1
      if(i_en.eq.1)then
         open (unit=41, file='vic_z_feed.dat',form='formatted')
         read (41,*)
         read (41,*)p_feed,tay_feed

	 if(kpr.eq.1)print *,' p_feed tay_feed ',p_feed,tay_feed

         close (41)

      end if


        vel=(zmag-zmag0)/tay
        g_d=150./13.3*(tpl/1.e3)*10.

ccccccccc
	i=2
        alf=-1.
c	vchopper(i)=-p_feed*pf_turns(i)*((zmag-zref)+tay_feed*vel)
	vchopper(i)=p_feed*alf*((zmag-zref)+tay_feed*vel)+
     *       vchopper(i)
c	vchopper(i)=g_d*alf*vel
ccccccccc
	i=3
        alf=-0.8871
c	vchopper(i)=-p_feed*pf_turns(i)*((zmag-zref)+tay_feed*vel)
	vchopper(i)=p_feed*alf*((zmag-zref)+tay_feed*vel)+
     *       vchopper(i)
c	vchopper(i)=g_d*alf*vel
ccccccccc
	i=4
        alf=0.58511
c	vchopper(i)=p_feed*pf_turns(i)*((zmag-zref)+tay_feed*vel)
	vchopper(i)=p_feed*alf*((zmag-zref)+tay_feed*vel)+
     *       vchopper(i)
c	vchopper(i)=g_d*alf*vel
ccccccccc
	i=5
        alf=0.58511
c	vchopper(i)=p_feed*pf_turns(i)*((zmag-zref)+tay_feed*vel)
	vchopper(i)=p_feed*alf*((zmag-zref)+tay_feed*vel)+
     *       vchopper(i)
c	vchopper(i)=g_d*alf*vel

 5003   format(6(1pe12.3))
        if(kpr.eq.1)print*,(index(i),i=1,npf)
        if(kpr.eq.1)print 5003,(pf(i),i=1,npf)
        if(kpr.eq.1)print 5003,(vchopper(i),i=1,npf)
        if(kpr.eq.1)print*,'ntay tay',ntay,tay
	if(kpr.eq.1)print *,' zmag zref vel',zmag,zref,vel

c*** To apply to CSU1 the same voltage that in CSL1
        vchopper(10)=vchopper(9)

c        pause 'from vic_z_feed'


      return
      end
c************************************
      subroutine vic_turn()
	include 'double.inc'
      include 'new_com.inc'

      call vic_turn_c(
     *     pf_turns,npf)

      return
      end

      subroutine vic_turn_c(
     *     pf_turns,npf)

	include 'double.inc'
        common
     *  /ge5/kpr

      dimension pf_turns(*)

      open (unit=41, file='turn.dat',form='formatted')
      read (41,*)
      read (41,*)(pf_turns(i),i=1,npf)
      
c      if(kpr.eq.1)print*,(pf_turns(i),i=1,npf)
c      pause 'from vic_turn'
      
      close (41)
      
      return
      end
c*******************************************************
  	subroutine vic_shape_pf_iam() 
	include 'double.inc'
        include 'new_com.inc'

        call vic_shape_pf_iam_c(
     *       index)

        return
        end

  	subroutine vic_shape_pf_iam_c( 
     *       index)
	include 'double.inc'
 	include 'parf1' 

 	include 'parf_mike' 

c 	parameter (ntime=20)

        dimension index(*)
 
	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /cont6/cip1,cip2,time1,time2

	common
     *  /keys5/next

	common
     *	/ge1e/rs0,tpl
     *  /ge2/ntay,tay,tt
        common
     *  /ge5/kpr


	dimension t_t(ntime),pf_t(kf,ntime),tpl_t(ntime)

	character *12 apr

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

	dimension a(140)

	i_en=i_en+1
	if(i_en.eq.1)then
	   open (unit=40,file='scr_data',form='formatted')
	   read (40,*,err=1,end=1)

	   n_t=0
	   do j=1,10000
	      read (40,*,err=1,end=1)(a(i),i=1,13)
c	      read (40,*)(a(i),i=1,17)

	      n_t=n_t+1

	      t_t(n_t)=a(1)*1.e3
	      tpl_t(n_t)=a(2)*1.e3

	      do k=1,npf
		 pf_t(k,n_t)=a(2+k)*1.e3
	      end do

	      if(kpr.eq.1)
     *  print *,' npf n_t===  ntime== t_t',npf,n_t,ntime,
     *  t_t(n_t),tpl_t(n_t)

c	      if(kpr.eq.1)print*,(a(i),i=1,2)
	   end do

 1	   continue

	   if(kpr.eq.1)print *,' n_t===  ntime==',n_t,ntime
	   if(n_t.gt.ntime)stop

	   close (40)

	end if

	
	do i=2,n_t
	   if( (tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
	      t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )
	 
	      do k=1,npf
		 ppp=pf_t(k,i-1)+t_coef*(pf_t(k,i)-pf_t(k,i-1))
                 if(ntay.le.next)pf(k)=ppp
                 if(index(k).eq.0.and.ntay.gt.next)pf(k)=ppp
c		 pf(k)=pf_t(k,i-1)+t_coef*(pf_t(k,i)-pf_t(k,i-1))
c!!!		 pf0(k)=pf(k)
	      end do

		 tpl_p=tpl_t(i-1)+t_coef*(tpl_t(i)-tpl_t(i-1))

c
	   end if

	end do

	if(i_en.eq.1)then
	   do k=1,npf
	      pf0(k)=pf(k)
	   end do

	   tpl=tpl_p

	end if

	cip1=tpl_p
	
	if(ntay.le.next)tpl=cip1

	if(kpr.eq.1)print *,' from SHAPE PF tt tpl tpl_p===',tt,tpl,tpl_p

	apr='-pf-' 
	if(kpr.eq.1)print 71,apr,(pf(i),i=1,npf) 

c        pause 'from shape_pf_iam'

	return
	end
c****************************************************
        subroutine vic_portone()
	include 'double.inc'
        include 'new_com.inc'

        call vic_portone_c(
     *       tpl,cip1,zref,zmag,zmag0,rref,rmag,
     *       npf,vchopper,r_cur,z_cur,
     *       u_1,u_kd,d_gaps,zvel,elong,elong_ref,tt,
     *       res_coef)

        return
        end

        subroutine vic_portone_c(
     *       tpl,cip1,zref,zmag,zmag0,rref,rmag,
     *       npf,vchopper,r_cur,z_cur,
     *       u_1,u_kd,d_gaps,zvel,elong,elong_ref,tt,
     *       res_coef)

	include 'double.inc'
 	parameter (k_voltg=11,k_param=3)
        dimension a_kk(k_voltg,k_param),a_gz(k_voltg)
        dimension u_1(k_voltg),u_kd(k_voltg),d_gaps(k_param)
        dimension vchopper(*),u_help(30)

        common/vic_vic/coef_port


	character *20 apr

        npf2=npf-4
        do i=1,npf2
           u_help(i)=vchopper(i)
        end do


        i_en=i_en+1
        if(i_en.eq.1)then
           open (unit=41, file='kk.flat',form='formatted')     
           do j=1,k_param
              do i=1,k_voltg
                 read (41,*)a_kk(i,j)
              end do
           end do
           close (41)
c
           open (unit=41, file='gz.flat',form='formatted')     
           do i=1,k_voltg
              read (41,*)a_gz(i)
           end do
           close (41)
c           if(kpr.eq.1)print*,'a_kk(5,2)=',a_kk(5,2)
c           if(kpr.eq.1)print*,'a_gz(2)=',a_gz(2)

           open (unit=41,file='coef_port.dat',form='formatted') 
           read(41,*)
           read (41,*)coef_ch,tt_ch
           close (41)

        end if

c        coef_port=150.
c        if(tt.gt.tt_ch)coef_port=coef_ch

        elong_min=1.
        elong_max=2.
        pow=1.
c        d_gaps(1)=(rmag-rref)/1.e2
c        d_gaps(2)=(zmag-zref)/1.e2

c        coef_r=res_coef
c        d_gaps(1)=(r_cur-rref)/1.e2*coef_r
        d_gaps(1)=(r_cur-rref)/1.e2

c        coef_z=tpl/(1.e3*7.)*(1./(elong_max-elong))*res_coef
c        d_gaps(2)=(z_cur-zref)/1.e2*coef_z
        d_gaps(2)=(z_cur-zref)/1.e2

        d_gaps(3)=(tpl-cip1)/1.e3

c!!!!!!!!!!!!
c        g_d=coef_port*10.*(elong_ref/1.8)
c        g_d=coef_port*tpl/(13.3*1.e3)*10.
c!!!!!!!!!!!!


c!!!        g_d=150.*10.*(elong_ref/1.8)
        g_d=150.*10.*tpl/(13.3*1.e3)
c        g_d=150.*10.*tpl/(7.*1.e3)
ccc        g_d=150.*10.*(tpl/(13.3*1.e3))*(elong-elong_min)**pow/
ccc     *       (elong_max-elong)**pow
c        g_d=150.*(elong/1.8)*10.
c var_1.5        g_d=150./13.3*(1500./1.e3)*10.
c var_13.3        g_d=150./13.3*(13300./1.e3)*10.

        if(kpr.eq.1)print*,'rmag rref',rmag,rref
        if(kpr.eq.1)print*,'zmag zref',zmag,zref
        if(kpr.eq.1)print*,'tpl cip1',tpl,cip1
        if(kpr.eq.1)print*,'elong_ref',elong_ref

	do i=1,k_voltg
           u_1(i)=0.
           do j=1,k_param
ccc           do j=2,2
c              if(kpr.eq.1)
c     *          print *,' i j a_kk d_gaps',i,j,a_kk(i,j),d_gaps(j)
              u_1(i)=u_1(i)+a_kk(i,j)*d_gaps(j)
           end do
	end do
c
	do i=1,k_voltg
           u_kd(i)=g_d*a_gz(i)*zvel
        end do
c
        apr='u_1'
c        if(kpr.eq.1)print 71,apr,(u_1(i),i=1,k_voltg)
        apr='u_kd'
c        if(kpr.eq.1)print 71,apr,(u_kd(i),i=1,k_voltg)
        apr='from volt.dat'
c        if(kpr.eq.1)print 71,apr,(u_help(i),i=1,npf2)

        do i=1,npf
c           u_1(i)=0.
c           u_kd(i)=0.

           if(i.le.8)vchopper(i)=u_1(i)+u_kd(i)+u_help(i)
           if(i.eq.9)vchopper(i)=u_1(i)/2.+u_kd(i)/2.+u_help(i)
           if(i.eq.10)vchopper(i)=vchopper(9)
           if(i.eq.11)vchopper(i)=u_1(10)+u_kd(10)+u_help(11)
           if(i.eq.12)vchopper(i)=u_1(11)+u_kd(11)+u_help(12)
        end do

c        pause 'from vic_portone'

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))

        return
        end
c****************************************************
        subroutine vic_portone_11()
	include 'double.inc'
        include 'new_com.inc'

        call vic_portone_11_c(
     *       tpl,cip1,zref,zmag,zmag0,rref,rmag,
     *       npf,vchopper,r_cur,z_cur,
     *       u_1,u_kd,d_gaps,zvel,elong)

        return
        end

        subroutine vic_portone_11_c(
     *       tpl,cip1,zref,zmag,zmag0,rref,rmag,
     *       npf,vchopper,r_cur,z_cur,
     *       u_1,u_kd,d_gaps,zvel,elong)

	include 'double.inc'
 	parameter (k_voltg=11,k_param=3)
        dimension a_kk(k_voltg,k_param),a_gz(k_voltg)
        dimension u_1(k_voltg),u_kd(k_voltg),d_gaps(k_param)
        dimension vchopper(*),u_help(30)
	character *20 apr

        npf2=npf-4
        do i=1,npf2
           u_help(i)=vchopper(i)
        end do


        i_en=i_en+1
        if(i_en.eq.1)then
           open (unit=41, file='kk.flat',form='formatted')     
           do j=1,k_param
              do i=1,k_voltg
                 read (41,*)a_kk(i,j)
              end do
           end do
           close (41)
c
           open (unit=41, file='gz.flat',form='formatted')     
           do i=1,k_voltg
              read (41,*)a_gz(i)
           end do
           close (41)
c           if(kpr.eq.1)print*,'a_kk(5,2)=',a_kk(5,2)
c           if(kpr.eq.1)print*,'a_gz(2)=',a_gz(2)
        end if

        elong_min=1.
        elong_max=1.9
c        d_gaps(1)=(rmag-rref)/1.e2
c        d_gaps(2)=(zmag-zref)/1.e2
        d_gaps(1)=(r_cur-rref)/1.e2
        d_gaps(2)=(z_cur-zref)/1.e2
        d_gaps(3)=(tpl-cip1)/1.e3
        g_d=150./13.3*(tpl/1.e3)*10.
c        g_d=150.*10.*(tpl/(13.3*1.e3))*(elong-elong_min)/
c     *       (elong_max-elong)
c        g_d=150.*(elong/1.8)*10.
c var_1.5        g_d=150./13.3*(1500./1.e3)*10.
c var_13.3        g_d=150./13.3*(13300./1.e3)*10.

        if(kpr.eq.1)print*,'rmag rref',rmag,rref
        if(kpr.eq.1)print*,'zmag zref',zmag,zref
        if(kpr.eq.1)print*,'tpl cip1',tpl,cip1


	do i=1,k_voltg
           u_1(i)=0.
           do j=1,k_param
ccc           do j=2,2
c              if(kpr.eq.1)
c     *          print *,' i j a_kk d_gaps',i,j,a_kk(i,j),d_gaps(j)
              u_1(i)=u_1(i)+a_kk(i,j)*d_gaps(j)
           end do
	end do
c
	do i=1,k_voltg
           u_kd(i)=g_d*a_gz(i)*zvel
        end do
c
        apr='u_1'
c        if(kpr.eq.1)print 71,apr,(u_1(i),i=1,k_voltg)
        apr='u_kd'
c        if(kpr.eq.1)print 71,apr,(u_kd(i),i=1,k_voltg)
        apr='from volt.dat'
c        if(kpr.eq.1)print 71,apr,(u_help(i),i=1,npf2)

        do i=1,9
c           u_1(i)=0.
c           u_kd(i)=0.
           if(i.lt.9)vchopper(i)=u_1(i)+u_kd(i)+u_help(i)
           if(i.eq.9)vchopper(i)=u_1(i)+u_kd(i)+2.*u_help(i)
        end do
        do i=10,11
           vchopper(i)=u_1(i)+u_kd(i)+u_help(i+1)
        end do

        vchopper(12)=0.

c        pause 'from vic_portone'

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))

        return
        end
c****************************************************
        subroutine vic_pf_cs1()
	include 'double.inc'
        include 'new_com.inc'

        call vic_pf_cs1_c(
     *       pf0,pf,npf)

        return
        end
        
        subroutine vic_pf_cs1_c(
     *       pf0,pf,npf)

	include 'double.inc'
        dimension pf0(*),pf(*)
	character *12 apr
        
        i_en=i_en+1

        pf(10)=pf(11)
        pf(11)=pf(12)

        do i=12,npf
           pf(i)=0.
        end do

        if(i_in.eq.1)then
           do i=1,npf
              pf0(i)=pf(i)
           end do
        end if

        apr='pf'
        if(kpr.eq.1)print 71,apr,(pf(i),i=1,npf)
c        pause 'from vic_pf_cs1'

71	FORMAT(20X,A20/,(6(1X,1PE10.3)))
        return
        end
c************************************************
        subroutine wr_kavin()
	include 'double.inc'
        include 'new_com.inc'

        call wr_kavin_c(
     *       u_1,u_kd,tt,zvel,z_cur,r_cur,tpl,ntay,next,d_gaps)

        return
        end

        subroutine wr_kavin_c(
     *       u_1,u_kd,tt,zvel,z_cur,r_cur,tpl,ntay,next,d_gaps)

	include 'double.inc'
        dimension u_1(*),u_kd(*),u_help(11),d_gaps(*)

	i_en=i_en+1
	if(i_en.eq.1)then

           open (unit=41,file='kavin.dat',status='new',
     *          form='formatted')
           write (41,*)'time[ms] Zvel[cm/ms] dR[m] dZ[m] dIp[MA]'
           write (41,*)'U1 U2 U3 U4 U5 U6 U_L3 U_L2 U_LU1 U_U2 U_U3' 
	end if

	if(i_en.gt.1)open(unit=41,file='kavin.dat',status='old',
     *          form='formatted')
        do i=1,11
           u_help(i)=u_1(i)+u_kd(i)
c           if(ntay.gt.next.and.kpr.eq.1)
c     *          print*,'i u_1 u_kd',i,u_1(i),u_kd(i)
        end do
        
	write (41,*)tt,zvel,(d_gaps(j),j=1,3),
     *       (u_help(i),i=1,11)

	close (unit=41)

        if(ntay.gt.next)then
c           if(kpr.eq.1)
c     *       print*,'tt zvel z_cur r_cur tpl',tt,zvel,z_cur,r_cur,tpl
c           pause 'from wr_kavin'
        end if

        return
        end
c********************************
        subroutine vic_pf_13_16()
	include 'double.inc'
        include 'new_com.inc'

        call vic_pf_13_16_c(
     *      pfc,ncam,npf)

        return
        end
        
        subroutine vic_pf_13_16_c(
     *      pfc,ncam,npf)

	include 'double.inc'
        dimension pfc(ncam,npf)
        
        do i=1,ncam
           do j=1,npf
              if(j.ge.13)pfc(i,j)=pfc(i,j)*1.e-5
           end do
        end do

        return
        end
c*******************************************************
        subroutine vic_read_gaps()
	include 'double.inc'
        include 'new_com.inc'

        call vic_read_gaps_c(
     *       n_ga,x_gaps,y_gaps)

        return
        end

        subroutine vic_read_gaps_c(
     *       n_ga,x_gaps,y_gaps)

	include 'double.inc'
        common
     *  /ge5/kpr

        dimension x_gaps(*),y_gaps(*)


c
	open(unit=40,status='old',file='gaps_data_ramp',form='formatted')
	read (40,*)
	read (40,*)n_ga
	read (40,*)
	read (40,*)(x_gaps(i),i=1,n_ga)
	read (40,*)
	read (40,*)(y_gaps(i),i=1,n_ga)
        close (40)
c

c        if(kpr.eq.1)print*,(x_gaps(i),i=1,n_ga)
c        if(kpr.eq.1)print*,(y_gaps(i),i=1,n_ga)
c        pause 'from vic_read_gaps'

        return
        end
c******************************************
        subroutine vic_gaps0_read()
	include 'double.inc'
	include 'new_com.inc'

	call vic_gaps0_read_c(
     *       tt,gaps0,n_ga)

	return
	end

        subroutine vic_gaps0_read_c(
     *       tt,gaps0,n_ga)

	include 'double.inc'
 	include 'parf_mike' 

        common
     *  /ge5/kpr

        dimension gaps0(*)
	dimension t_t(6,ntime),gaps0_t(6,ntime)
        dimension t_t1(ntime),n_t(6)

     	character *20 apr
     	character *20 apr1(6)

     	data apr1 /'g1.dat','g2.dat','g3.dat','g4.dat',
     *  'g5.dat','g6.dat'/

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           do k=1,n_ga
              open (unit=41,file=apr1(k),form='formatted') 

              if(kpr.eq.1)print*,k,apr1(k)

              read (41,*) 
              read (41,*)n_t(k) 
              read (41,*) 
              
              if(kpr.eq.1)print *,'tt n_t===',tt,n_t(k) 
              
              do i=1,n_t(k) 
                 read (41,*)t_t1(i),gaps0_t(k,i)
                 t_t(k,i)=t_t1(i)*1000. 
              end do 
           end do 
           
                      
           do k=1,n_ga
              apr='-t_t-' 
              if(kpr.eq.1)print 71,apr,(t_t(k,i),i=1,n_t(k)) 
              apr='-gaps0_t-' 
              if(kpr.eq.1)print 71,apr,(gaps0_t(k,i),i=1,n_t(k)) 
           end do
           
           close (unit=41) 
        end if

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))


        do k=1,n_ga
           do i=2,n_t(k)

              if((tt-t_t(k,i-1))*(tt-t_t(k,i)).le.0.)then
c==================
                 t_coef=(tt-t_t(k,i-1))/( t_t(k,i)-t_t(k,i-1) )
              
                 gaps0(k)=gaps0_t(k,i-1)+t_coef*
     *                (gaps0_t(k,i)-gaps0_t(k,i-1))
c     
              end if
           end do
        end do

        if(kpr.eq.1)print*,'tt=',tt
        apr='gaps0' 
        if(kpr.eq.1)print 71,apr,(gaps0(k),k=1,n_ga) 
c        pause 'from vic_gaps_read'

        return
        end
c***************************************************
        subroutine vic_tay()
	include 'double.inc'
	include 'new_com.inc'

	call vic_tay_c(
     *       tay_simul,tt_1,tt_2)

	return
	end

        subroutine vic_tay_c(
     *       tay_simul,tt_1,tt_2)

	include 'double.inc'
           open (unit=41,file='tay_simul.dat',form='formatted') 
           read (41,*) 
           read (41,*)tay_simul,tt_1,tt_2 
           close (41)

        return
        end
c******************************************
        subroutine vic_elong_read()
	include 'double.inc'
	include 'new_com.inc'

	call vic_elong_read_c(
     *       elong_ref,tt)

	return
	end

        subroutine vic_elong_read_c(
     *       elong_ref,tt)

	include 'double.inc'
 	include 'parf_mike' 

        common
     *  /ge5/kpr

	dimension t_t(ntime),elong_t(ntime)
	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='elong.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 
           
           if(kpr.eq.1)print *,'tt n_t===',tt,n_t 
           
           do i=1,n_t 
              read (41,*)t_t(i),elong_t(i)
              t_t(i)=t_t(i)*1000. 
           end do 
           
           apr='-t_t-' 
           if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 

           apr='-elong_t-' 
           if(kpr.eq.1)print 71,apr,(elong_t(i),i=1,n_t) 

           close (unit=41) 
        end if

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

        do i=2,n_t
           if((tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
              t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )
              
              elong_ref=elong_t(i-1)+t_coef*
     *             (elong_t(i)-elong_t(i-1))
c
           end if

        end do

        if(kpr.eq.1)print*,'tt elong_ref',tt,elong_ref
c        pause 'from vic_elong_read'


        return
        end
c**************************************************
  	subroutine vic_shape_ip_iam() 
	include 'double.inc'
        include 'new_com.inc'

        call vic_shape_ip_iam_c(
     *       pf_p)

        return
        end

  	subroutine vic_shape_ip_iam_c(
     *       pf_p)

	include 'double.inc'
 	include 'parf1' 

 	include 'parf_mike' 

c 	parameter (ntime=20)
 
	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /cont6/cip1,cip2,time1,time2

	common
     *  /keys5/next

	common
     *	/ge1e/rs0,tpl
     *  /ge2/ntay,tay,tt
        common
     *  /ge5/kpr


	dimension t_t(ntime),pf_t(kf,ntime),tpl_t(ntime)
        dimension pf_p(*)

	character *20 apr

71	FORMAT(20X,A20/,(6(1X,1PE10.3)))

	dimension a(140)

	i_en=i_en+1
	if(i_en.eq.1)then
	   open (unit=40,file='scr_data',form='formatted')
	   read (40,*,err=1,end=1)

	   n_t=0
	   do j=1,10000
	      read (40,*,err=1,end=1)(a(i),i=1,13)

	      n_t=n_t+1

	      t_t(n_t)=a(1)*1.e3
	      tpl_t(n_t)=a(2)*1.e3

	      do k=1,npf
		 pf_t(k,n_t)=a(2+k)*1.e3
	      end do

	      if(kpr.eq.1)
     *  print *,' ++npf n_t===  ntime== t_t',npf,n_t,ntime,
     *  t_t(n_t),tpl_t(n_t)

c	      print*,'from vic_shape_ip_iam'
c	      print*,(a(i),i=1,2)
c	      print*,(a(i),i=3,13)
c	      read(*,*)
	   end do

 1	   continue

	   if(kpr.eq.1)print *,' ++n_t===  ntime==',n_t,ntime
	   if(n_t.gt.ntime)stop

	   close (40)

	   open (unit=40,file='pf_ref.dat',form='formatted')
	   write (40,*)' n_t'
	   write (40,*)n_t
	   write (40,*)' tt  tpl   pf1 - pf12'
	do i=1,n_t
	write (40,5000)t_t(i),tpl_t(i),(pf_t(k,i),k=1,11)
	end do

	write (40,*)'   '




5000    format (8(1pe14.6))
	


	end if
	
	do i=2,n_t
	   if( (tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
	      t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )
	 
	      do k=1,npf
		 pf_p(k)=pf_t(k,i-1)+t_coef*(pf_t(k,i)-pf_t(k,i-1))
	      end do

		 tpl_p=tpl_t(i-1)+t_coef*(tpl_t(i)-tpl_t(i-1))

c
	   end if

	end do

	if(i_en.eq.1)then
	   tpl=tpl_p
	end if

	cip1=tpl_p
	
	if(ntay.le.next)tpl=cip1

	if(kpr.eq.1)
     *       print *,' from SHAPE PF tt tpl tpl_p===',tt,tpl,tpl_p

	apr='pf from shape_ip_iam' 
	if(kpr.eq.1)print 71,apr,(pf_p(i),i=1,npf) 

c        pause 'from shape_ip_iam'

	return
	end
c*******************************************
c	subroutine vic_print()
c        include 'new_com.inc'

c        call vic_print_c(
c     *       tt,ksepa,z_cur,r_cur,
c     *       n,q,dm0,dmn,te0)

c        return
c       end

c	subroutine vic_print_c(
c     *       tt,ksepa,z_cur,r_cur,
c     *       n,q,dm0,dmn,te0)


c	i_in=i_in+1
c	if(i_in.eq.1)then
c	   open (unit=5,file='test',form='formatted')
c	   write (41,*)'time ksepa z_cur r_cur'
c	   write (41,*)'q dmn dm0 te0'
c	end if
c**************************************************
	subroutine wr_tok()

	include 'double.inc'
	include 'new_com.inc'

	call  wr_tok_c(
     *  tt,npf,pf)
	
	return
	end

	subroutine wr_tok_c(
     *  tt,npf,pf)
	
	include 'double.inc'
	dimension pf(*)

        common
     *  /ge5/kpr

c	open (unit=41,file='pfc.dat',access='append',
c     *	form='formatted')

	i_en=i_en+1
	if(i_en.eq.1)then

	open (unit=41,file='pfc.dat',status='new',
     *          form='formatted')
	write (41,*) 'time [msec], PF_current [kA]'
	end if

	if(i_en.gt.1)open(unit=41,file='pfc.dat',status='old',
     *          form='formatted')
c	write (41,5000) tt,(pf(i),i=1,npf)
	write (41,*) tt,(pf(i),i=1,npf)
	write (41,*)' '

	close (unit=41)

c        if(kpr.eq.1)print*,'tt=',tt
c        pause 'from wr_tok'


5000    format (6(1pe14.6))


	return
	end
c*********************************************
	subroutine r_tokk()

	include 'double.inc'
	include 'new_com.inc'

	call  r_tokk_c(
     *  tt,npf,pf,pf0)
	
	return
	end

	subroutine r_tokk_c(
     *  tt,npf,pf,pf0)
	
	include 'double.inc'
        common
     *  /ge5/kpr

	include 'parf1'
	dimension pf(*),pf0(*),cur1(kf),cur2(kf)

	character *12 apr

	open (unit=41,file='pfc.dat',form='formatted')

	t2=-1.

	 read (41,*,err=1,end=1)

      do ii=1,10000

	 t1=t2
	 do k=1,npf
	    cur1(k)=cur2(k)
	 end do

	 read (41,*,err=1,end=1) t2,(cur2(i),i=1,npf)
	 t2=t2+1.e-3

	 if( (tt-t1)*(tt-t2).le.0.)then
c==================

	    t_coef=(tt-t1)/(t2-t1)
	 
	    do k=1,npf
	       pf(k)=cur1(k)+t_coef*(cur2(k)-cur1(k))
	    end do

	    go to 1
c
	 end if

	end do


 1	continue

	i_en=i_en+1
	if(i_en.eq.1)then
	   do i=1,npf
	      pf0(i)=pf(i)
	   end do
	end if

	    if(kpr.eq.1)print *,' t1 tt t2 ===',t1,tt,t2

	apr='pf'
	if(kpr.eq.1)print 71,apr,(pf(i),i=1,npf)
	apr='cur2'
	if(kpr.eq.1)print 71,apr,(cur2(i),i=1,npf)
	apr='cur1'
	if(kpr.eq.1)print 71,apr,(cur1(i),i=1,npf)
	close (unit=41)

c        pause 'from r_tok'


71 	format (20x,a6/,(6(1pe10.3)))

	return
	end
c*********************************************
	subroutine r_tok_p()

	include 'double.inc'
	include 'new_com.inc'

	call  r_tok_p_c(
     *  tt,npf,pf_p)
	
	return
	end

	subroutine r_tok_p_c(
     *  tt,npf,pf_p)
	
	include 'double.inc'
        common
     *  /ge5/kpr

	include 'parf1'
	dimension pf_p(*),cur1(kf),cur2(kf)

	character *12 apr

	open (unit=41,file='pfc.dat',form='formatted')

	t2=-1.

	 read (41,*,err=1,end=1)

      do ii=1,10000

	 t1=t2
	 do k=1,npf
	    cur1(k)=cur2(k)
	 end do

	 read (41,*,err=1,end=1) t2,(cur2(i),i=1,npf)
	 t2=t2+1.e-3

	 if( (tt-t1)*(tt-t2).le.0.)then
c==================

	    t_coef=(tt-t1)/(t2-t1)
	 
	    do k=1,npf
	       pf_p(k)=cur1(k)+t_coef*(cur2(k)-cur1(k))
	    end do

	    go to 1
c
	 end if

	end do

 1      continue
	    if(kpr.eq.1)print *,' t1 tt t2 ===',t1,tt,t2

	apr='pf_p'
	if(kpr.eq.1)print 71,apr,(pf_p(i),i=1,npf)
	apr='cur2'
	if(kpr.eq.1)print 71,apr,(cur2(i),i=1,npf)
	apr='cur1'
	if(kpr.eq.1)print 71,apr,(cur1(i),i=1,npf)
	close (unit=41)

c        pause 'from r_tok_p'


71 	format (20x,a6/,(6(1pe10.3)))

	return
	end

c********************************************
        subroutine vic_wr()
	include 'double.inc'
        include 'new_com.inc'

        call vic_wr_c(i_wr)

        return
        end

        subroutine vic_wr_c(i_wr)

	include 'double.inc'
           open (unit=41,file='i_wr.dat',form='formatted') 
           read (41,*) 
           read (41,*)i_wr
           close (41)

        return
        end
c*******************************************
	subroutine wr_tok_new()

	include 'double.inc'
	include 'new_com.inc'

	call  wr_tok_new_c(
     *  tt,npf,pf)
	
	return
	end

	subroutine wr_tok_new_c(
     *  tt,npf,pf)
	
	include 'double.inc'
        common
     *  /ge5/kpr

	dimension pf(*)

c	open (unit=41,file='pfc.dat',access='append',
c     *	form='formatted')


	i_en=i_en+1
	if(i_en.eq.1)then

	open (unit=41,file='pfc_new.dat',
     *	form='formatted')
	write (41,*) 'time [msec], PF_current [kA]'
	else

		open (unit=41,file='pfc_new.dat',
     *	access='append',form='formatted')

	end if

c	if(i_en.gt.1)open(unit=41,file='pfc_new.dat',status='old',
c     *          form='formatted')
c	write (41,5000) tt,(pf(i),i=1,npf)
	write (41,*) tt,(pf(i),i=1,npf)
	write (41,*)' '

	close (unit=41)

c        if(kpr.eq.1)print*,'tt=',tt
c        pause 'from wr_tok_new'


5000    format (6(1pe14.6))


	return
	end
c******************************************8
	subroutine wr_volt_new()

	include 'double.inc'
	include 'new_com.inc'

	call  wr_volt_new_c(
     *  tt,npf,vchopper,
     *  gaps,gaps0,tpl,cip1,zmag,zref,n_ga)
	
	return
	end

	subroutine wr_volt_new_c(
     *  tt,npf,pf_volts,
     *  gaps,gaps0,tpl,cip1,zmag,zref,n_ga)
	
	include 'double.inc'
        common
     *  /ge5/kpr

	dimension pf_volts(*),gaps(*),gaps0(*)
	character *70 apr


	i_en=i_en+1
	if(i_en.eq.1)then

	open (unit=41,file='volt_new.dat',
     *	form='formatted')

	write (41,*) 'time [msec], Volts [V]'
      else
	open (unit=41,file='volt_new.dat',
     *	access='append',form='formatted')
      
	end if


c!!!	open (unit=41,file='volt.dat',access='append',
c!!!     *	form='formatted')

c	if(i_en.gt.1)open(unit=41,file='volt_new.dat',status='old',
c     *          form='formatted')
c	write (41,5000) tt,(pf_volts(i),i=1,npf)
c	write (41,*) tt,(pf_volts(i),i=1,npf)
	write (41,5001) tt,(pf_volts(i),i=1,npf)
c	write (41,*)' '

	close (unit=41)
c********************
c	write (51,5001) tt,tpl,cip1,(gaps(i),i=1,n_ga),
c     *  (gaps0(i),i=1,n_ga),zmag,zref

c	close (unit=51)

c        if(kpr.eq.1)print*,'tt=',tt
c        pause 'from wr_volt_new'


5000    format (6(1pe14.6))
 5001	format (60(1pe15.6))


	return
	end
c***********************************************
        subroutine vic_pf_limits()
	include 'double.inc'
        include 'new_com.inc'

        call vic_pf_limits_c(npf,pf,pf_lim)

	return
	end

        subroutine vic_pf_limits_c(npf,pf,pf_lim)
	include 'double.inc'
        dimension pf(*),pf_lim(*)

        common
     *  /ge5/kpr

      i_en=i_en+1
      if(i_en.eq.1)then
         open (unit=41, file='pf_limits.dat',form='formatted')
         read (41,*)
         read (41,*)(pf_lim(i),i=1,npf)         
c	 if(kpr.eq.1)print *,(pf_lim(i),i=1,npf)        
         close (41)
      end if

c      pause 'from vic_pf_limits'

cc      do i=1,npf
cc         if(abs(pf(i)).gt.pf_lim(i))
cc     *        pf(i)=pf_lim(i)*pf(i)/abs(pf(i))
cc      end do

      return
      end
c********************************************************
c****************************************
  	subroutine vic_ip_kavin() 
	include 'double.inc'
 	include 'parf1' 
 	parameter ( NPFC=KF-4) 

 	include 'parf_mike' 

c 	parameter (ntime=20)
 
	common
     *  /ge2/ntay,tay,tt
     *	/ge1e/rs0,tpl

	common
     *  /cont6/cip1,cip2,time1,time2
        common
     *  /ge5/kpr
	common
     *  /keys5/next

	dimension t_t(ntime),tpl_t(ntime)

	character *12 apr

	i_en=i_en+1

	if(i_en.eq.1)then
c-------
           open (unit=41,file='ip_kavin.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 
           
           do i=1,n_t 
              read (41,*)t_t(i),tpl_t(i)
              t_t(i)=t_t(i)*1000. 
              tpl_t(i)=tpl_t(i)*1000. 
           end do 
           
           apr='-t_t-' 
c           if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 
           close (unit=41) 
        end if
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

      do i=2,n_t
      if( (tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
	 t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )

	 tpl_p=tpl_t(i-1)+t_coef*(tpl_t(i)-tpl_t(i-1))
c
	 end if

	 end do

	if(i_en.eq.1)then
	   tpl=tpl_p
	end if

	cip1=tpl_p
	
	if(ntay.le.next)tpl=cip1

c	print*,'next ntay tpl cip1',next,ntay,tpl,cip1

c	if(kpr.eq.1)print *,' from SHAPE IP tpl',tpl

c	read(*,*)

       return 
       end 
c*******************************************************
	subroutine vic_bpmax_surfpf(n_coil_xx)
	include 'double.inc'
	include 'new_com.inc'
	
	call vic_bpmax_surfpf_c(n_coil_xx,bpmax,
     *  npf,pf,coef,f_jp,ncam,tcam,rc,zc)

	return
	end

	subroutine vic_bpmax_surfpf_c(n_coil_xx,bpmax,
     *  npf,pf,coef,f_jp,ncam,tcam,rc,zc)

	include 'double.inc'
	include 'parf2'

	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nr),y(nz),dx,dy
	dimension pf(*),f_jp(*),tcam(*),rc(*),zc(*)
	dimension brr(50),bzz(50),pdd(6)
	dimension r_surf(8),z_surf(8),bpmax(*)

        i_en=i_en+1
c*** The 8 surface points of n_coil_xx PFcoil
  	if(i_en.eq.1)then
           call pf_coor()
           if(kpr.eq.1)print *,' CALL ELKE...'
           call edim1
        end if
ccc        if(i_en.le.2)then
           call vic_rz_surfpf(n_coil_xx,r_surf,z_surf)
ccc	end if

        b_c=0.1
c*** Br, Bz calculation in T *******************
	n1=nr-1
	m1=nz-1
	bpmax(n_coil_xx)=0.

 	do 1000 mmm=1,8
	   urr=r_surf(mmm)
	   vrr=z_surf(mmm)

        bz=0.
        br=0.
c*** from PFc ***
	call bisa(brr,bzz,urr,vrr)
        do jj=1,npf
        bz=bz+bzz(jj)*pf(jj)*b_c
        br=br+brr(jj)*pf(jj)*b_c
        end do
c*** from plasma ***
        t_tok=0.
        DO i=2,N1
        DO j=2,M1
        kk=(i-1)*nz+j
        call brz(br_p,bz_p,urr,x(i),vrr,y(j))
        bz=bz+bz_p*f_jp(kk)*coef*dx*dy*b_c
        br=br+br_p*f_jp(kk)*coef*dx*dy*b_c
        t_tok=t_tok+f_jp(kk)*coef*dx*dy
        end do
        end do
c*** from vessel ***
        do  k=1,ncam
        call brz(br_v,bz_v,urr,rc(k),vrr,zc(k))
	br=br+br_v*tcam(k)*b_c
	bz=bz+bz_v*tcam(k)*b_c
	end do
c
c	print*,'t_tok=',t_tok
c	print*,'urr vrr',urr,vrr
c	print*,'br bz',br,bz
c	read(*,*)
c*** Now by means of GRAD_PSI ***
c	call boxd(urr,vrr,pdd,ier)
c        psi_r=pdd(2)
c	psi_z=pdd(3)
c        br_psi=-psi_z/urr*b_c
c        bz_psi=psi_r/urr*b_c
c        print*,'bz_psi br_psi',bz_psi,br_psi
c        print*,'bz br',bz,br
c        pause 'from vic_br_bz'
	bp=sqrt(br**2+bz**2)
	if(bp.gt.bpmax(n_coil_xx))bpmax(n_coil_xx)=bp
	
 1000	continue
c	print*,'n_coil_xx bp',n_coil_xx,bp
c	read(*,*)

        return
        end


c********************************************************
	subroutine vic_rz_surfpf(n_c,r_surf,z_surf)
	include 'double.inc'
	include 'parf1'
	dimension r_surf(8),z_surf(8)
	dimension nmx(kf),nmy(kf),turn(kf)
	dimension r_c(kf),z_c(kf),dr(kf),dz(kf)

	open(unit=41,status='old',file='koor_pf',form='formatted')
	read(41,*)
	read(41,*)npf,cnmx,kl_pf
c	print *,'npf cnmx',npf,cnmx,kl_pf
	do I=1,npf
	read(41,*)
	read(41,*)nmx(i),nmy(i),turn(i)
	nmx(i)=nmx(i)*cnmx
	if(nmx(i).gt.nmax)stop
	nmy(i)=nmy(i)*cnmx
	if(nmy(i).gt.nmax)stop
c
c	PRINT*,'i NMX NMY turn',i,NMX(I),nmy(i),turn(i)
	read(41,*)R_c(I),Z_c(I),dr(i),dz(i)
c	PRINT *,'r_c z_c dr dz ',r_c(i),z_c(i),dr(i),dz(i)
	END DO

	close(41)
c=========
	r_surf(1)=r_c(n_c)-0.5*dr(n_c)
	z_surf(1)=z_c(n_c)
	r_surf(2)=r_surf(1)
	z_surf(2)=z_c(n_c)+0.5*z_c(n_c)
	r_surf(3)=r_c(n_c)
	z_surf(3)=z_surf(2)
	r_surf(4)=r_c(n_c)+0.5*dr(n_c)
	z_surf(4)=z_surf(2)
	r_surf(5)=r_surf(4)
	z_surf(5)=z_c(n_c)
	r_surf(6)=r_surf(4)
	z_surf(6)=z_c(n_c)-0.5*z_c(n_c)
	r_surf(7)=r_surf(3)
	z_surf(7)=z_surf(6)
	r_surf(8)=r_surf(1)
	z_surf(8)=z_surf(6)


c	do i=1,8
c	   print*,'r_surf(i) z_surf(i)',r_surf(i),z_surf(i)
c	   end do
c	read(*,*)

	return
	end

c****************************************************
     	subroutine vic_shape_elong()
	include 'double.inc'
	include 'new_com.inc'

	call vic_shape_elong_c(
     * elong_p,tt)

	return
	end

	subroutine vic_shape_elong_c(
     * elong_p,tt)
	include 'double.inc'

 	include 'parf_mike' 
	dimension t_t(ntime),elong_t(ntime)

	character *12 apr

	i_sh=i_sh+1
	if(i_sh.eq.1)then
c-------
           open (unit=41,file='elong.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 

           do i=1,n_t 
              read (41,*)t_t(i),elong_t(i)
              t_t(i)=t_t(i)*1000. 
           end do 
           
           apr='-t_t-' 
c           if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 
           close (unit=41) 
        end if
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

      do i=2,n_t
      if( (tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
	 t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )

	 elong_p=elong_t(i-1)+t_coef*(elong_t(i)-elong_t(i-1))

c
	 end if

	 end do

 	if(kpr.eq.1)print *,' from SHAPE ELONG tt elong_p',tt,elong_p

       return 
       end 

c************************************************
     	subroutine vic_prof_chg()
	include 'double.inc'
	include 'new_com.inc'

	call vic_prof_chg_c(
     *  n,pd0_a,pt0_a,pd0_b,pt0_b,a,pd0,pt0,pne,tt)

	return
	end

	subroutine vic_prof_chg_c(
     *  n,pd0_a,pt0_a,pd0_b,pt0_b,a,pd0,pt0,pne,tt)
	include 'double.inc'

	dimension a(*),pd0(*),pt0(*),pne(*)


	alfa_fin=8.
ccccc	alfa_fin=3.
c	alfa_fin=4.
c	alfa_fin=2.
	beta_fin=0.5


	alfa_in=3.
	beta_in=1.

	i_en=i_en+1

	if(i_en.eq.1)then 
	tt_in=tt
	tt_fin=tt_in+500.
	end if

	if(tt.le.tt_fin)then

	alfa=alfa_in+(alfa_fin-alfa_in)*(tt-tt_in)/(tt_fin-tt_in)
	beta=beta_in+(beta_fin-beta_in)*(tt-tt_in)/(tt_fin-tt_in)

	else

	alfa=alfa_fin
	beta=beta_fin

	end if



	do i=1,n
           psix=a(i)
           pd0(i)=pd0_b+((1.-psix**alfa))**beta*(pd0_a-pd0_b)
           pt0(i)=pt0_b+((1.-psix**alfa))**beta*(pt0_a-pt0_b)
!	   pne(i)=pd0(i)+pt0(i)
	end do

c	print*,'!!!alfa beta=',alfa,beta

c	print*,'!!!pd0 tt=',tt
c	print*,(pd0(i),i=1,n)

	return
	end

c*********************************************************
	subroutine vic_feed_aux()
	include 'double.inc'
	include 'new_com.inc'

	call vic_feed_aux_c(
     *  emoe,emoq,tt,tay,tt_dw,betp_flat,tt_h)

	return
	end

	subroutine vic_feed_aux_c(
     *  emoe,emoq,tt,tay,tt_dw,betp_flat,tt_h)
	include 'double.inc'

	common
     */dfm12/betpj,dlint,bett,bet2,betpc,tk,tkp,tkf
     *  /vic_017/w_fusion

c	print*,'1from vic_feed_aux'
c	print*,'emoe emoq betpj tt',emoe,emoq,betpj,tt


c----------------------------
	i_sh=i_sh+1

	if(i_sh.eq.1)then
           open (unit=40,file='dt_term.dat',form='formatted') 
           read (40,*) 
           read (40,*)dt,dt_1
           close (40)
             del_emo_0=0.
	end if

c	dt=100.e3
c	dt=80.e3
	pnor=6.25e8
c	alfa_p=500.
ccc	alfa_p=720.
	alfa_p=1000.
c	alfa_p=3000.
c	alfa_p=800.
	alfa_d=0.
ccc	betp_flat=0.62
c	betp_flat=0.6
c!!!!!!!!!!!!	betp_flat=0.59

	if(tt.ge.500000.)then
c	   print*,'from vic_feed_aux'
c	   print*,'tt tt_dw dt',tt,tt_dw,dt
c	   print*,'betp_flat betp_beg betp_end',
c     *     betp_flat,betp_beg,betp_end
	end if
	      

c*************************************************
	betp_flat0=0.5
ccc	tt_end=80.e3
c	tt_end=110.e3
ccc	tt_end=100.e3
ccc	tt_end=90.e3
cc	tt_end=95.e3
	tt_end=tt_h+30.e3
	tt_end1=tt_h+42.e3
	betp_flat1=betp_flat-0.045

	if(betpj.ge.betp_flat0.and.key_aux.eq.0)then
	   key_aux=1
	   tt_aux=tt
	   betp_help=betp_flat
	   betp_help1=betp_flat1
	end if
	if(key_aux.eq.1)then
	   betp_flat=betp_flat0+((tt-tt_aux)/(tt_end-tt_aux))*
     *     (betp_help1-betp_flat0)
	end if

	if(betp_flat.gt.betp_help1.and.key_aux.eq.1)then
	   key_aux=2
	   tt_aux=tt
	   if(betp_flat.gt.betp_help1)betp_flat=betp_help1
	end if
	if(key_aux.eq.2)then
	   betp_flat=betp_help1+((tt-tt_aux)/(tt_end1-tt_aux))*
     *     (betp_help-betp_help1)
	   if(betp_flat.gt.betp_help)betp_flat=betp_help
	end if

c*************************************
c	betp_end=0.5
c	betp_end=0.4
	betp_end=0.43
	if(tt.gt.tt_dw.and.key_betp.eq.0)then
	   key_betp=1
	   betp_beg=betp_flat
	end if
	if(tt.gt.tt_dw.and.key_betp.eq.1)
     *	betp_flat=(tt_dw+dt-tt)*(betp_beg-betp_end)/dt+betp_end

c*********************************
ccccccc	if(betpj.gt.betp_flat)then

c	   deriv=(betpj-betpj0)/tay
c	   del_emo=-alfa_p*((betpj-betp_flat)+alfa_d*deriv)

c Kavin's insert, tay should be equal time step
c           Tfilt_emo=0.6
           Tfilt_emo=0.2

c           del_emo=(-alfa_p*tay*1.e-3*(betpj-betp_flat)+
c     *     Tfilt_emo*del_emo_0)/(Tfilt_emo+tay*1.e-3)

c       del_emo=del_emo_0
       del_emo=exp(-tay*1.e-3/Tfilt_emo)*del_emo_0+
     * (1.- exp(-tay*1.e-3/Tfilt_emo))*(betpj-betp_flat)*(-alfa_p)

	   if(del_emo.ge.0)del_emo=0.
	   if(betpj.le.betp_flat) del_emo=0.

c  fixed emoe, emoq are taken from dat-file
	   emoe=emoe+del_emo*pnor
	   emoq=emoq+del_emo*pnor
	   if(emoe.le.0.)emoe=0.
	   if(emoq.le.0.)emoq=0.
ccccccccc	end if

               del_emo_0=del_emo
	betpj0=betpj

c	print*,'-- emoe emoq',emoe,emoq

c        call emoe_filter(emoe)
c        call emoq_filter(emoq)

c end Kavin's insert


	i_en=i_en+1
        if(i_en.eq.1)then

	   open (unit=75,file='kavin.dat',
     *	 form='formatted')

	   write(75,*)
     *'tt,betpj,betp_flat,emoe,del_emo,del_emo_0' 
         else
         	   open (unit=75,file='kavin.dat',
     *	access='append',form='formatted')
	   end if

	   write(75,5002)
     *tt,betpj,betp_flat,emoe/pnor,del_emo,del_emo_0 

 5002   format (150(1pe12.4))

	close (75)


c	print*,'2from vic_feed_aux'
c	print*,'betpj betp_flat',betpj,betp_flat
c	print*,'deriv del_emo',deriv,del_emo
c	print*,'emoe emoq',emoe,emoq
c	read(*,*)

	return
	end

c***********************************************************
	SUBROUTINE s_calc()
c---------------------------------------------
	include 'double.inc'
	include 'new_com.inc'

	call s_calc_c(M,uk,vk,s_plasma,pi)

	return
	end


	SUBROUTINE s_calc_c(M,uk,vk,s_plasma,pi)
c--------------------------------------
c     calculation of average coefficients after equilibrium for
c               transport
c---------------------------------------------
	include 'double.inc'
c       implicit real*8 (a-h,o-z)
        dimension uk(*),vk(*)

	s_plasma=0.

      DO J=2,M-1
c
	u1=uk(j)
	u2=uk(j-1)

	v1=vk(j)
	v2=vk(j-1)

      UC=0.5*(U1+U2)

      dl=sqrt( (u2-u1)**2+(v2-v1)**2 )

	s_plasma=s_plasma+2*pi*uc*dl

	end do

c	print *,' s_plasma==',s_plasma

c	read (*,*)

      RETURN
      END

c************************************************
     	subroutine vic_prof_chg1()
	include 'double.inc'
	include 'new_com.inc'

	call vic_prof_chg1_c(
     *  n,pd0_a,pt0_a,pd0_b,pt0_b,a,pd0,pt0,pne,tt)

	return
	end

	subroutine vic_prof_chg1_c(
     *  n,pd0_a,pt0_a,pd0_b,pt0_b,a,pd0,pt0,pne,tt)
	include 'double.inc'

	dimension a(*),pd0(*),pt0(*),pne(*)


	alfa_fin=3.
	beta_fin=1.


	alfa_in=8.
	beta_in=0.5

	i_en=i_en+1

	if(i_en.eq.1)then 
	tt_in=tt
	tt_fin=tt_in+500.
	end if

	if(tt.le.tt_fin)then

	alfa=alfa_in+(alfa_fin-alfa_in)*(tt-tt_in)/(tt_fin-tt_in)
	beta=beta_in+(beta_fin-beta_in)*(tt-tt_in)/(tt_fin-tt_in)

	else

	alfa=alfa_fin
	beta=beta_fin

	end if



	do i=1,n
           psix=a(i)
           pd0(i)=pd0_b+((1.-psix**alfa))**beta*(pd0_a-pd0_b)
           pt0(i)=pt0_b+((1.-psix**alfa))**beta*(pt0_a-pt0_b)
!	   pne(i)=pd0(i)+pt0(i)
	end do

c	print*,'!!!alfa beta=',alfa,beta

c	print*,'!!!pd0 tt=',tt
c	print*,(pd0(i),i=1,n)

	return
	end
	subroutine emoe_filter(emoe_xx)
	include 'double.inc'
	include 'new_com.inc'

	call emoe_filter_c(
     *  emoe_xx,ntay,tay,tt)

	return
	end

	subroutine emoe_filter_c(
     *  wen2,ntay,tay,tt)

	include 'double.inc'

	if(time.lt.tt-0.5*tay)then
c  saving for the next time_step...
	e1 = f9a
	v1 = f9af
	time1 = time
	end if


	time=tt

	f9a=wen2

        i_en=i_en+1
	if(i_en.eq.1)then
           e1 = f9a
           f9af=e1
           v1 = f9af
           time1 = time
        end if

	taup=5.*tay

	qqp = 0.5 * (time - time1)/taup

	f9af =(qqp * (f9a + e1) - (qqp - 1.0) * v1) / (qqp + 1.0)


	wen2=f9af


	return
	end
	subroutine emoq_filter(emoq_xx)
	include 'double.inc'
	include 'new_com.inc'

	call emoq_filter_c(
     *  emoq_xx,ntay,tay,tt)

	return
	end

	subroutine emoq_filter_c(
     *  wen2,ntay,tay,tt)

	include 'double.inc'

	if(time.lt.tt-0.5*tay)then
c  saving for the next time_step...
	e1 = f9a
	v1 = f9af
	time1 = time
	end if


	time=tt

	f9a=wen2

        i_en=i_en+1
	if(i_en.eq.1)then
           e1 = f9a
           f9af=e1
           v1 = f9af
           time1 = time
        end if

	taup=5.*tay

	qqp = 0.5 * (time - time1)/taup

	f9af =(qqp * (f9a + e1) - (qqp - 1.0) * v1) / (qqp + 1.0)


	wen2=f9af


	return
	end

c--------------------------

	subroutine error_corr(error_xx,num_gaps_xx)
	include 'double.inc' 
	include 'new_com.inc'
	
	call error_corr_c(error_xx,num_gaps_xx,
     * tt,t_end,zvel,tpl)

	return
	end

c--------------------------

	subroutine error_corr_c(error,num_gaps,
     * tt,t_end,zvel,tpl)

	include 'double.inc' 

	dimension error(*)

	if( tt.gt.t_end)then

	do i=1,num_gaps+1

	error(i)=0.d0

	end do

	zvel=0.
!	tpl=1.e-8

	end if

c-------------------------------

	return
	end


        SUBROUTINE DOPP_2()

	include 'double.inc'
	include 'new_com.inc'

        call DOPP_2_c(
     *       pf_volts,tcam,ncam,bz_pl,zeff_a,zeff_b,tec,
     *       r_cur,z_cur,gaps,ksepa,u_1,u_kd,int_2000,int_2005,
     *       surface,zvconverter,zvresist,u_ffw,pf_turns,r_lh,
     *       elong_sep,b_cs,ulivel,coef_imp,nz_imp,volume,
     *       z_tok,zvel_tok,bpmax,pmag,psi_pf,s_plasma)
	return
	end




        SUBROUTINE DOPP_2_c(
     *       pf_volts,tcam,ncam,bz_pl,zeff_a,zeff_b,tec,
     *       r_cur,z_cur,gaps,ksepa,u_1,u_kd,int_2000,int_2005,
     *       surface,zvconverter,zvresist,u_ffw,pf_turns,r_lh,
     *       elong_sep,b_cs,ulivel,coef_imp,nz_imp,volume,
     *       z_tok,zvel_tok,bpmax,pmag,psi_pf,s_plasma)

c-------------------------------------------------
c  calculate energy confinement time and if(kpr.eq.1)print all values
c-------------------------------------------------------
	include 'double.inc'
c       implicit real*8 (a-h,o-z)
c
      include 'parf0'
      include 'parf1'
      include 'parf3'
      include 'parf8'


      dimension tcam(*),gaps(*)
      dimension pf_volts(*)
      dimension u_1(*),u_kd(*)
      dimension zvconverter(*),zvresist(*)
      dimension u_ffw(*),pf_turns(*),b_cs(*)
      dimension res(3),te_zrad(3)
      real res,te_zrad
      
      dimension bpmax(*)
      dimension dNB_xx(24)

c
        common
     *  /abcdx/x(kf_c),x0(kf_c),gaps0(kf_c),d_gaps(kf_c)
	common
     *  /con6/ind_r(2),ind_z(2)
     *  /con7/anom_zeff,time_anom
	common
     *  /time1e/pf_ex(kf)
	common
     *  /fluxc13/volt_sec(kf)
     *  /fluxc14/vs_pf,vs_pl,vs_tot
     *  /fluxc17/f_index



        common /temp_al/cal
	common
     *	/ge1e/rs0,tpl
	common
     *	/n_m/n,m,mp
	common
     */igr/ygr(iy,ny),tgr(ny),igr
	common
     *	/ng_igr/ng
	common
     *  /eq11/psval(npo),psval0(npo)

	common
     *	/keys4/k_ener,k_uv
     *  /keys5/next
     *  /keys9/i_d3d,i_iter,i_smal
     *  /keys11/i_ramp
     *  /keys12/i_v

        common /vic_g7_ref/g7_ref
     *  /vic_vs1_vs3/Curr_vs3,U_vs3,Curr_vs1,U_vs1

	character *10 mgr(iy),mt(iy)
	character *70 apr
	character *12 yy(iy)
	character *50 tmp
c
c
	dimension pmas(npo)
c
	common
     */pf1/npf,pf(kf),pf0(kf)
      COMMON
     */en1/PNE(npo),PD0(npo),PT0(npo),PH0(npo),
     *PDN(npo),PTN(npo),PHN(npo)
     */en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),
     *WE0(npo),WQ0(npo)
     */en4/WD0(npo),WT0(npo),WH0(npo),VD(npo),DIF(npo),
     *GGT(npo),GGTN(npo)
     */en5/SD0(npo),ST0(npo),SH0(npo)
     */en6/VN(npo)
     */en7/UD,ZD,UT,ZT,UH,ZH,LT,LD,LH,ID,IT,IH ,KTP,NNT
     */en9/QE0(npo),QQ0(npo),QDG(npo)
     */en10/GGE(npo),GGEN(npo),DXE(npo),DXQ(npo),WU(npo),
     *UG(npo),VG(npo)
     */en11/UN(4),ZN(2),LL,KEN,KEN1,KEN2,NNE
	common
     */en12/pnal(npo),pnaln(npo),zalfa,talfa
     */en13/KPIN,VPIN,ALP1,pot,skor
     */en14/EMOE,EMOQ,NDOP,QDE0(npo),QDQ0(npo)
     */en15/QNET(npo)
     */en16/QTOR(npo),QDH(npo),QpE(npo),QpQ(npo)
     */en17/QAE(npo),QAQ(npo),SAL(npo),NAL
     */en19/DD,DT,DH,SIN0,SINK,ALPY,Sss,Ppp,Eee
     */en21/qce(npo)
     */en22/XII(npo)
     */en23/kk,tn0,pna,wie(npo),wcx(npo),tn(npo),
     *pn(npo),pn0(npo)
     */en25/zhib,teoh
     */en27/NIJ
     */en28/wen1,wen2
     */en29/d_zvel
     */en31/dpsi_ax
     */en33/anom_e,anom_i,key_t11,kcchp
	common
     */ves9/tokc,tokc0
     */ves11/tokcup,tokcdw
	common
     *  /loop3/vloop,psf1a,psf1a0
     *  /loop7/vloop1,vlooppf,vloop18,vloopv,vloope,vlooppl
c
      COMMON
     */ge1/PI
     */ge2/NTAY,TAY,TT
     */ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
     */ge4/EPS1,EPS2,EPS0
     *  /ge5/kpr
     */ge6/zeff(npo),qpr(npo),ppr(npo),pr0,prg,zar
     */ge7/eu,rs,zact,eksk
     */ge8/pcch
	common
     */mid1/C1(npo),C2(npo),C3(npo)
     */mid2/VI(npo),spo(npo)
     */mid3/GRA1(npo),GRA2(npo)
     */mid5/d1,d2
	common
     */pol4/UM,VM,UK(ntet),VK(ntet)
	common
     */dfm1/UDM,ZDM,LM,SIG0
     */dfm2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)
     *  /dfm3/dfmax(npo),dfmax0(npo)
     */dfm4/Q(npo),ANU(npo),P(npo),F(npo),
     *PP(npo),PFF(npo)
     */dfm5/PT01,PT02
     */dfm7/BT,UIND
     */dfm11/c20(npo),tok1(npo),tok2(npo)
     */dfm12/betpj,dlint,bett,bet2,betpc,tk,tkp,tkf
     */dfm13/tokel,tokfi,tokbut
     *  /dfm13e/tokuv
     *  /dfm14/tokae,ajae(npo),ajae0(npo),enae
     */dfm15/uli
     */dfm17/betpi,betp2
	common
     *  /eq15/pll,zsep,rsep,zsepup,rsepup,zsepdw,rsepdw
     *  /eq23/xleft,xright
     *  /eq24/psi_ax0,psi_ax
     *  /eq25/rps(ntet),zps(ntet)
	common
     *  /cont1/vchopper(kf),veps
     *  /cont4/zpp,rpp,wvspip,zxp,elp,shepep,gapinp,dfzp,dfzp0
     *  /cont7/zp,gapin
     *  /cont11/pr1,sdiv,dfzx,dfz,dfr
     *  /cont12/zmax,zmin
     *  /cont13/zmag,zvel,delrs,delzmag
     *  /cont13e/zmag0,rmag,rmag0,rvel
     *  /cont14/p_pl,p_ves,p_pf,p_mes
     *  /cont15/p_pas
	common /pas10/c_p1,c_p2
     *  /curs1/	t_ps,t_bs,t_dia,t_beam
	common
     *  /halo4/expfg,avalb,w_h,del_r,al0
     *  /halo4e/w_h0,delaval0,pshalo0,te_h0
     *  /halo5/q_vde,q_95,del_f,i_halo
     *  /halo5e/pshalo
     *  /halo6/thalo,thalo0
c
4010    format(6e12.3)
	igr=igr+1
	tgr(igr)=tt

	if(kpr.eq.1)print *,' IGR   TT ------------------------',tt
c
	include 'dop_vs_pfw_1.inc'


      RETURN
      END



        subroutine vic_dens_dt()
	include 'double.inc'
	include 'new_com.inc'

	call vic_dens_dt_c(
     *       pcchp,eu,tpl,pi,t_end,tt,tt_dw,ntay,key_h_to_l,dt_term_h,
     *       pd0_p,pt0_p)

	return
	end

	subroutine vic_dens_dt_c(
     *       pcchp,eu,tpl,pi,t_end,tt,tt_dw,ntay,key_h_to_l,dt_term_h,
     *       pd0_p,pt0_p)

	include 'double.inc'
        common
     *  /ge5/kpr



      pcchp=pd0_p+pt0_p

	if(kpr.eq.1)print*,'pd0_p pt0_p ',pd0_p,pt0_p
	if(kpr.eq.1)print*,'pcchp ',pcchp

c	print*,'ntay tt_dw dt_term_h',ntay,tt_dw,dt_term_h
c	read(*,*)

	i_sh=i_sh+1

c=================================
ccc	tt_gamma=404000.
ccc	tt_gamma=534000.
c	tt_gamma=500000.
c=================================

	if(i_sh.eq.1)then
c-------
           open (unit=40,file='dt_term.dat',form='formatted') 
           read (40,*) 
           read (40,*)dt,dt_1
           close (40)

           open (unit=40,file='pcchp_end.dat',form='formatted') 
           read (40,*) 
           read (40,*)pcchp_end
           close (40)

        end if

c******* H to L at tt_dw time moment!!!!
	if(kpr.eq.1)print*,'tt tt_dw dt_term_h key_gamma',tt,tt_dw,
     *  dt_term_h,key_gamma

	if(dt_term_h.lt.1.e-5)then

	if(ntay.gt.30.and.tt.gt.tt_dw.and.key_gamma.eq.0)then
	   key_gamma=1
	   pcchp_help=pcchp
	end if
	if(key_gamma.eq.1.and.tt.le.tt+dt_1)then
cc	   pcchp=pcchp_help-(pcchp_help-4.)*(tt-tt_dw)/dt_1
ccc      pcchp=pcchp_help-(pcchp_help-1.)*(tt-tt_dw)/dt_1
	   pcchp=pcchp_help-(pcchp_help-pcchp_end)*(tt-tt_dw)/dt_1

	if(kpr.eq.1)print*,'pcchp_help pcchp pcchp_end',pcchp_help,
     * pcchp,pcchp_end

	end if
	if(tt.gt.tt_dw+dt_1.and.key_gamma.eq.1)then
	   key_gamma=2
	   gamma_mem=(pcchp/10.)*pi*eu**2*1.e-4/(tpl/1.e3)
	end if
	if(key_gamma.eq.2)then
	   pcchp=10.*gamma_mem*(tpl/1.e3)/(pi*eu**2*1.e-4)
	if(kpr.eq.1)print*,' gamma_mem pcchp',gamma_mem,pcchp
	end if

	end if
ccc end of H to L at tt_dw time moment

c********** H to L at tt_dw+dt_term_h time moment !!!
	if(dt_term_h.gt.1.e-5)then
	
	if(ntay.gt.30.and.tt.gt.tt_dw.and.key_gamma.eq.0)then
	   key_gamma=1
	   gamma_end=0.6
	   gamma_beg=(pcchp/10.)*pi*eu**2*1.e-4/(tpl/1.e3)

	if(kpr.eq.1)print*,'key_gamma gamma1 gamma2',key_gamma,
     *  gamma_end,gamma_beg


	end if
	if(key_gamma.eq.1)then
	   gamma_mem=(tt_dw+dt-tt)*(gamma_beg-gamma_end)/dt+gamma_end
c	if(gamma_mem.lt.gamma_end)gamma_mem=gamma_end
	   pcchp=10.*gamma_mem*(tpl/1.e3)/(pi*eu**2*1.e-4)
	if(kpr.eq.1)print*,' gamma_mem pcchp',gamma_mem,pcchp
	end if
c!!!	if(key_gamma.eq.1.and.tt.gt.tt_dw+dt)then
	if(key_gamma.eq.1.and.key_h_to_l.eq.1)then
	   tt_1=tt
	   key_gamma=2
ccc	   gamma_end=0.35
	   gamma_end=0.05
	   gamma_beg=gamma_mem
	end if
	if(key_gamma.eq.2)then
c	   gamma_mem=(tt_dw+dt+dt_1-tt)*
	   gamma_mem=(tt_1+dt_1-tt)*
     *  (gamma_beg-gamma_end)/dt_1+gamma_end
	   if(gamma_mem.lt.gamma_end)gamma_mem=gamma_end
	   pcchp=10.*gamma_mem*(tpl/1.e3)/(pi*eu**2*1.e-4)
 
    	if(kpr.eq.1)print*,'--pcchp ',pcchp

	end if
	  
	end if
ccc end of H to L at tt_dw+dt_term_h time moment
	
           if(kpr.eq.1)print*,'tpl eu pcchp dt_term_h',
     *  tpl,eu,pcchp,dt_term_h
     
c        pause 'from vic_dens'

	if(kpr.eq.1)
     *   print*,'!!!!!!!!!!!!!tt tt_dw key_h_to_l',tt,tt_dw,key_h_to_l
	if(kpr.eq.1)print*,'key_gamma pcchp',key_gamma,pcchp
c	read(*,*)

      al1=pcchp/(pd0_p+pt0_p)
      pd0_p=pd0_p*al1
      pt0_p=pt0_p*al1

	if(kpr.eq.1)print*,'pd0_p pt0_p al1',pd0_p,pt0_p,al1
      

        return
        end

