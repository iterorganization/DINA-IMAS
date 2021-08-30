	subroutine pol_halo()
 	include 'double.inc'
	include 'new_com.inc'

	call pol_halo_c(
     *  nr,nz,dx,dy,coef,pi,
     *  pmag,p_s,pbound,
     *  thalo,index_li,x,y,rs0,
     *  bt0,r0,z0,
     *  ke,xu,yu,psi,expfg)

	return
	end

	subroutine pol_halo_c(
     *  nr,nz,dx,dy,coef,pi,
     *  pmag,p_s,pbound,
     *  thalo,index_li,x,y,rs0,
     *  bt0,r0,z0,
     *  ke,xu,yu,psi,expfg)

 	include 'double.inc'
	dimension psi(nr,nz),index_li(*),x(*),y(*),xu(*),yu(*)

        sp_halo=0.

	do i=1,nr
	do j=1,nz
	kk=(i-1)*nz+j
	index_li(kk)=0
	p=psi(i,j)
        urr=x(i)
        vrr=y(j)
	if((pmag-p)*(p_s-p).le.0.)then
           call caet2(r0,z0,urr,vrr,ipoint,ke,xu,yu)
	   if(ipoint.eq.1)then
              index_li(kk)=1
           end if
	end if

	if((pbound-p)*(p_s-p).le.0.)then
           if(index_li(kk).eq.1)then
              sp_halo=sp_halo+1./x(i)
           end if
	end if

	end do
	end do

        sp_halo=sp_halo*coef*dx*dy*0.5*rs0

        pff_halo=thalo/sp_halo
        fprime=pff_halo

	fsqrt0=bt0**2

        psi_i=p_s-pbound

	fsqrt=fsqrt0-fprime*psi_i/rs0

	f8_halo=sqrt(fsqrt)

	del_f=f8_halo-bt0

	expfg=5.*rs0*del_f

	if(kpr.eq.1)print *,' -- del_f-  halo_pol ',del_f,expfg

      if(kpr.eq.1)  print *,' pff_halo sp_halo==',pff_halo,sp_halo
	
	return
	end

        subroutine cur_den_2()

 	include 'double.inc'
        include 'new_com.inc'
      
        call cur_den_2_c(
     *  u_h,gr_fil,tpl,
     *  npo,aj,ro,tok_fil,n_rad,index_li)

        return
        end

        subroutine cur_den_2_c(
     *  u_h,gr_fil,tpl,
     *  npo,aj,ro,tok_fil,n_rad,index_li)

 	include 'double.inc'
	include 'parf2'
        dimension f(nwnh)

        dimension u_h(*),gr_fil(nwnh,*),aj(npo,*),
     *  ro(npo,*),tok_fil(*),index_li(*)

c
	character*70 apr
71	format(20x,a6/,(6(1pe10.3)))

	if(kpr.eq.1)print *,' nwnh nr nz n_rad ===',nwnh,nr,nz,n_rad


	do i=1,nwnh
	   u_h(i)=0.
	end do

	tok_s=0.
	do kk=1,nwnh
	index_li(kk)=0

	do ii=2,n_rad
	   jj=gr_fil(kk,ii)
	   if(jj.gt.0)then
	      ll=aj(ii,jj)
	      u_h(kk)=tok_fil(ll)/ro(ii,jj)
	      index_li(kk)=1
	   end if
	   end do

	   tok_s=tok_s+u_h(kk)
	end do


	if(kpr.eq.1)print *,' tok_s======',tok_s


	call cur_den(f)


	call bunem_coef()

	al1=1.
	call  pspl_b2_old(al1,f)

	if(kpr.eq.1)print *,'pspl_b2_old'

c------------------
c  calc. psi_plasma - pspl...

	call psi_pl(al1,f,errm)

	if(kpr.eq.1)print *,'error_max ',errm

	call pl_out(f)

c	read (*,*)

        return
        end

	subroutine caet_fil(rt_xx,zt_xx,
     *  ii_xx,kk_xx)
 	include 'double.inc'
	include 'new_com.inc'

	call caet_fil_c(rt_xx,zt_xx,
     *  ii_xx,kk_xx,
     *  npo,xpl,ypl,ro,
     *  nwnh,gr_fil,
     *  n_tet,x_b,y_b,
     *  r0,z0)

	return
	end
	


	subroutine caet_fil_c(rt,zt,
     *  ii,kk,
     *  npo,xpl,ypl,ro,
     *  nwnh,gr_fil,
     *  n_tet,x_b,y_b,
     *  r0,z0)

 	include 'double.inc'
	dimension xpl(npo,*),ypl(npo,*),ro(npo,*),gr_fil(nwnh,*)
	dimension  x_b(*),y_b(*)

c--------------------------------------------
c  calculate is point in xpl,ypl...
c  revision 3.02.99 - RRK
c--------------------------------------------

71 	FORMAT(20X,A6/,(12E10.3))
c

	i=1
	r_2=x_b(i)
	z_2=y_b(i)

	r_3=r0
	z_3=z0

	do i=2,n_tet

	   r_1=r_2
	   z_1=z_2

	   r_2=x_b(i)
	   z_2=y_b(i)


	call tri_sq(r_1,z_1,r_2,z_2,r_3,z_3,s_123)

	call tri_sq(r_1,z_1,r_2,z_2,rt,zt,s_12)

	call tri_sq(rt,zt,r_2,z_2,r_3,z_3,s_23)

	call tri_sq(r_1,z_1,rt,zt,r_3,z_3,s_31)

	s_tot=s_12+s_23+s_31

	if(abs(s_123-s_tot).le.1.e-3)then
	   gr_fil(kk,ii)=i
	   ro(ii,i)=ro(ii,i)+1.
	   xpl(ii,i)=xpl(ii,i)+rt
	   ypl(ii,i)=ypl(ii,i)+zt
	end if
	end do

	return
	end
c
c-------------



        subroutine fil_dis_cir_3()

 	include 'double.inc'
        include 'new_com.inc'
      
        call fil_dis_cir_3_c(
     *  ke,xu,yu,
     *  n_fil,r_fil,z_fil,
     *  r0,z0,rmag,zmag,pi,pmag,p_s,
     *  xpl,ypl,ro,aj,psi_pff,
     *  nr,nz,x,y,psi,
     *  n_rad,n_tet,x_b,y_b,
     *  nwnh,gr_fil,seps_fil,index_ves)


        return
        end

        subroutine fil_dis_cir_3_c(
     *  ke,xu,yu,
     *  n_fil,r_fil,z_fil,
     *  r0,z0,rmag,zmag,pi,pmag,p_s,
     *  xpl,ypl,ro,aj,psi_pff,
     *  nr,nz,x,y,psi,
     *  n_rad,n_tet,x_b,y_b,
     *  nwnh,gr_fil,seps_fil,index_ves)


 	include 'double.inc'
	include 'parf0'

        dimension r_fil(*),z_fil(*),xu(*),yu(*),
     *  xpl(npo,*),ypl(npo,*),ro(npo,*),aj(npo,*),psi_pff(*),
     *  x(*),y(*),psi(nr,nz),
     *  gr_fil(nwnh,*),seps_fil(*)

        dimension x_b(*),y_b(*),index_ves(*)


c
	character*70 apr
71	format(20x,a6/,(6(1pe10.3)))


	call caet2(r0,z0,rmag,zmag,ipoint,ke,xu,yu)

	if(ipoint.eq.1)then
	   r0=rmag
	   z0=zmag
	   if(kpr.eq.1)print *,' NEXT r0 z0==',r0,z0
	end if


	i_en=i_en+1
	if(i_en.eq.1)then

	   open (unit=41,file='fil_dis.dat',form='formatted')
	   read (41,*)
	   read (41,*)n_rad,n_tet,elong,eu_fil
	   n_fil=n_rad*n_tet
	   close (41)

	   do j=2,n_tet
	      tet=2.*pi*(j-1.)/(n_tet-1.)
	      x_b(j)=r0+5.*eu_fil*cos(tet)
	      y_b(j)=z0+5.*eu_fil*sin(tet)
	   end do
	   x_b(1)=x_b(n_tet)
	   y_b(1)=y_b(n_tet)

	   psi_pff(1)=0.
	   do i=2,n_rad
	      psi_pff(i)=(float(i)-1.5)/(float(n_rad)-1.5)
	      if(kpr.eq.1)print *,' i psi_pff ',i,psi_pff(i)
	   end do

	end if



        do i=1,n_rad
        do j=1,n_tet
	   xpl(i,j)=0.
	   ypl(i,j)=0.
	   ro(i,j)=0.
	end do
	end do

	if(kpr.eq.1)print *,' pmag p_s===',pmag,p_s

	if(kpr.eq.1)print *,' nr nz ===',nr,nz


	do i=3,nr-2
	do j=3,nz-2
	kk=(i-1)*nz+j

	if(index_ves(kk).eq.0)go to 1024

	p=psi(i,j)
	xpsi=(pmag-p)/(pmag-p_s)

	do ii=2,n_rad
	   gr_fil(kk,ii)=0.

	if( (xpsi-psi_pff(ii-1))*(xpsi-psi_pff(ii)).le.0.)then
	   urr=x(i)
	   vrr=y(j)

c###           call caet2(r0,z0,urr,vrr,ipoint,ke,xu,yu)
	   call caet_fil(urr,vrr,ii,kk)
	end if
	end do

 1024	continue

	end do
	end do

        sep=1.
	ii=0
        do i=2,n_rad

c!!!           sep=sep*0.99

        do j=1,n_tet
	   ro_del=ro(i,j)
           if(ro_del.gt.0.1)then
	   urr=xpl(i,j)/ro_del
	   vrr=ypl(i,j)/ro_del
              ii=ii+1
	      aj(i,j)=ii
              r_fil(ii)=urr
              z_fil(ii)=vrr
              seps_fil(ii)=sep
	   end if

	end do
	end do

        n_fil=ii
        if(kpr.eq.1)print *,' n_fil= eu_fil',n_fil,eu_fil

	apr='r_fil'
	if(kpr.eq.1)print 71,apr,(r_fil(i),i=1,n_fil)
	apr='z_fil'
	if(kpr.eq.1)print 71,apr,(z_fil(i),i=1,n_fil)

        return
        end
	subroutine magn_fil()
 	include 'double.inc'
        include 'new_com.inc'

	call magn_fil_c(
     *  kloop,kprobe,n_fil,
     *  g_loop,g_probe,tok_fil,
     *  psloopp,bprobep,pi)


        return
        end

	subroutine magn_fil_c(
     *  kloop,kprobe,n_fil,
     *  g_loop,g_probe,tok_fil,
     *  psloopp,bprobep,pi)
        
 	include 'double.inc'
        include 'parf4'

        dimension psloopp(*),bprobep(*),
     *  g_loop(nloop,*),g_probe(nprobe,*),tok_fil(*)
c

	character*70 apr
c
71	format(20x,a6/,(6(1pe10.3)))

        if(kpr.eq.1)print *,' kloop kprobe n_fil===',kloop,kprobe,n_fil
        if(kpr.eq.1)print *,' nloop nprobe ',nloop,nprobe
        d=0.
        do i=1,n_fil
           d=d+tok_fil(i)
        end do
        if(kpr.eq.1)print *,' tok===',d

c   transformation to api=volt*second/2pi

	api=1.e-5/(2.*pi)

	apr='psl'
c	if(kpr.eq.1)print 71,apr,(psloopp(i),i=1,kloop)


        do k=1,kloop
           d=0.
           psloopp(k)=d
           do i=1,n_fil
              d=d+g_loop(k,i)*tok_fil(i)
           end do
           psloopp(k)=d
        end do

	apr='psloopp'
c	if(kpr.eq.1)print 71,apr,(psloopp(i),i=1,kloop)

c   == transform to Tesla *0.1
	api=0.1
	apr='bpr'
c	if(kpr.eq.1)print 71,apr,(bprobep(i),i=1,kprobe)

        do k=1,kprobe
           d=0.
           bprobep(k)=d
           do i=1,n_fil
              d=d+g_probe(k,i)*tok_fil(i)
           end do
           bprobep(k)=d
        end do
	apr='bprobep'
c	if(kpr.eq.1)print 71,apr,(bprobep(i),i=1,kprobe)

	return
	end
	subroutine chi_mag()
 	include 'double.inc'
        include 'new_com.inc'

	call chi_mag_c(
     *  kloop,kprobe,
     *  fwtp,fwtb,psloop,bprobe,
     *  psloop_e,bprobe_e,seps1,seps2)


        return
        end

	subroutine chi_mag_c(
     *  kloop,kprobe,
     *  fwtp,fwtb,psloop,bprobe,
     *  psloop_e,bprobe_e,seps1,seps2)

 	include 'double.inc'
        dimension fwtp(*),fwtb(*),
     *  psloop(*),bprobe(*),
     *  psloop_e(*),bprobe_e(*)

	character*70 apr
c
71	format(20x,a6/,(6(1pe10.3)))

c   here start loops....
	psmax=0.
	do ii=1,kloop
	if(fwtp(ii).gt.0)then
	if(abs(psloop_e(ii)).gt.psmax)psmax=abs(psloop_e(ii))
	end if
	end do

	k_l=0
        chi_ps=0.
	do ii=1,kloop
	if(fwtp(ii).gt.0)then
	k_l=k_l+1
	chi_ps=chi_ps+((psloop_e(ii)-psloop(ii))/(seps1*psmax))**2
	end if
	end do

c   here start bprobes....
	bsmax=0.
	do ii=1,kprobe
	if(fwtb(ii).gt.0)then
	if(abs(bprobe_e(ii)).gt.bsmax)bsmax=abs(bprobe_e(ii))
	end if
	end do

	k_b=0
        chi_bp=0.
	do ii=1,kprobe
	if(fwtb(ii).gt.0)then
	k_b=k_b+1
	chi_bp=chi_bp+((bprobe_e(ii)-bprobe(ii))/(seps2*bsmax))**2
	end if
	end do

	if(kpr.eq.1)print *,' kloop k_l kprobe k_b psmax bsmax',kloop,
     *  k_l,kprobe,k_b,psmax,bsmax

        chi=chi_ps+chi_bp

	if(kpr.eq.1)print *,' chi  chi_ps chi_bp ',chi,chi_ps,chi_bp

	apr='psloop'
c	if(kpr.eq.1)print 71,apr,(psloop(i),i=1,kloop)
	apr='psloop_e'
c	if(kpr.eq.1)print 71,apr,(psloop_e(i),i=1,kloop)

	apr='bprobe'
c	if(kpr.eq.1)print 71,apr,(bprobe(i),i=1,kprobe)
	apr='bprobe_e'
c	if(kpr.eq.1)print 71,apr,(bprobe_e(i),i=1,kprobe)

	return
	end
        subroutine fil_dis_cir_2()

 	include 'double.inc'
        include 'new_com.inc'
      
        call fil_dis_cir_2_c(
     *  r0,z0,ke,xu,yu,
     *  n_fil,r_fil,z_fil,tok_fil,
     *  pi,
     *  rmag,zmag,eu_fil,rs0)

        return
        end

        subroutine fil_dis_cir_2_c(
     *  r0,z0,ke,xu,yu,
     *  n_fil,r_fil,z_fil,tok_fil,
     *  pi,
     *  rmag,zmag,eu_fil,rs0)

 	include 'double.inc'
        dimension r_fil(*),z_fil(*),tok_fil(*),xu(*),yu(*)

c
	character*70 apr
71	format(20x,a6/,(6(1pe10.3)))


           call caet2(r0,z0,rmag,zmag,ipoint,ke,xu,yu)

           if(ipoint.eq.1)then
              r0=rmag
              z0=zmag
	      if(kpr.eq.1)print *,' NEXT r0 z0==',r0,z0
           end if


	   i_en=i_en+1
	   if(i_en.eq.1)then

	      open (unit=41,file='fil_dis.dat',form='formatted')
	      read (41,*)
	      read (41,*)n_rad,n_tet,elong,eu_fil
	      n_fil=n_rad*n_tet
	      close (41)

	   end if

	   zs0=0.


        ii=1
	urr=r0
	vrr=z0
	r_fil(ii)=urr
	z_fil(ii)=vrr
        do i=2,n_rad
        po=eu_fil*(i-1.5)/(n_rad-1.5)
        do j=2,n_tet
           tet=2.*pi*(j-1.)/(n_tet-1.)
           
           urr=r0+po*elong*cos(tet)
           vrr=z0+po*elong*sin(tet)
           
           call caet2(r0,z0,urr,vrr,ipoint,ke,xu,yu)
c!!!           call caet2_fil(rs0,zs0,urr,vrr,ipoint,ke,xu,yu)

           if(ipoint.eq.1)then
              ii=ii+1
              r_fil(ii)=urr
              z_fil(ii)=vrr
           end if

	END DO
	END DO

        n_fil=ii
        if(kpr.eq.1)print *,' n_fil= eu_fil',n_fil,eu_fil

	apr='r_fil'
	if(kpr.eq.1)print 71,apr,(r_fil(i),i=1,n_fil)
	apr='z_fil'
	if(kpr.eq.1)print 71,apr,(z_fil(i),i=1,n_fil)

        return
        end
	subroutine psi_fil_pl()
 	include 'double.inc'
        include 'new_com.inc'

	call psi_fil_pl_c(
     *  n_fil,r_fil,z_fil,tok_fil,
     *  urr,vrr,sq_sel,u_h)
        
        return
        end


	subroutine psi_fil_pl_c(
     *  n_fil,r_fil,z_fil,tok_fil,
     *  urr,vrr,sq_sel,u_h)

 	include 'double.inc'
        dimension r_fil(*),z_fil(*),tok_fil(*),u_h(*)

	include 'parf2'
        dimension f(nwnh)

	character*70 apr

71	format(20x,a6/,(6(1pe10.3)))
c=========================================

        if(kpr.eq.1)print *,' n_fil ',n_fil

	apr='tok_fil'
	if(kpr.eq.1)print 71,apr,(tok_fil(i),i=1,n_fil)

	do i=1,nwnh
	   u_h(i)=0.
	end do


	do ii=1,n_fil
	   urr=r_fil(ii)
	   vrr=z_fil(ii)
	   sq_sel=tok_fil(ii)
	   call ip_plasma()
	end do

	tok=0.
	tok2=0.
	do i=1,nwnh
	   tok=tok+u_h(i)
	f(i)=u_h(i)
	   tok2=tok2+f(i)
	end do

	if(kpr.eq.1)print *,' tok tok2=',tok,tok2

	call cur_den(f)
	call bunem_coef()

	al1=1.
	call  pspl_b2_old(al1,f)

	if(kpr.eq.1)print *,'pspl_b2_old'

c------------------
c  calc. psi_plasma - pspl...
	call psi_pl(al1,f,errm)

	if(kpr.eq.1)print *,'error_max ',errm

	call pl_out(f)

	return
	end

	subroutine ip_plasma()
 	include 'double.inc'
	include 'new_com.inc'

	call ip_plasma_c(
     *	urr,vrr,nz,
     *  x,y,u_h,dx,dy,sq_sel)
c

	return
	end

	subroutine ip_plasma_c(
     *	urr,vrr,nz,
     *  x,y,u_h,dx,dy,sq_sel)


 	include 'double.inc'
	dimension x(*),y(*),u_h(*)
	dimension tok(4)

	data errt/1.e-14/

	
	dxy=1./(dx*dy)

	alf=sq_sel*dxy

c	if(kpr.eq.1)print *,' urr vrr sq_sel',urr,vrr,sq_sel
c	if(kpr.eq.1)print *,' alf pprime fprime',alf,pprime,fprime

	ival=(1.0+errt)*(1.0+(urr-x(1))/dx)
	jval=(1.0+errt)*(1.0+(vrr-y(1))/dy)

c----     1st point (i,j)
	i=ival
	j=jval

	dx_i=urr-x(i)
	dy_i=vrr-y(j)
	ds_i=dx_i*dy_i

	if(dx_i.lt.0)print *,' i j urr x ',i,j,urr,x(i)
	if(dy_i.lt.0)print *,' i  urr x ',i,j,vrr,y(j)

	tok(1)=ds_i*alf

	kk=(i-1)*nz+j
	u_h(kk)=u_h(kk)+tok(1)

c  ----   2d point (i,j+1)

	i=ival
	j=jval+1

	dx_i=urr-x(i)
	dy_i=y(j)-vrr
	ds_i=dx_i*dy_i

	if(dx_i.lt.0)print *,' i j urr x ',i,j,urr,x(i)
	if(dy_i.lt.0)print *,' i  urr x ',i,j,vrr,y(j)

	tok(2)=ds_i*alf

	kk=(i-1)*nz+j
	u_h(kk)=u_h(kk)+tok(2)

c  ----   3d point (i+1,j)
	i=ival+1
	j=jval

	dx_i=x(i)-urr
	dy_i=vrr-y(j)
	ds_i=dx_i*dy_i

	if(dx_i.lt.0)print *,' i j urr x ',i,j,urr,x(i)
	if(dy_i.lt.0)print *,' i  urr x ',i,j,vrr,y(j)

	tok(3)=ds_i*alf

	kk=(i-1)*nz+j
	u_h(kk)=u_h(kk)+tok(3)

c  ------- 4th point (i+1,j+1)
	i=ival+1
	j=jval+1

	dx_i=x(i)-urr
	dy_i=y(j)-vrr
	ds_i=dx_i*dy_i

	if(dx_i.lt.0)print *,' i j urr x ',i,j,urr,x(i)
	if(dy_i.lt.0)print *,' i  urr x ',i,j,vrr,y(j)

	tok(4)=ds_i*alf

	kk=(i-1)*nz+j
	u_h(kk)=u_h(kk)+tok(4)

	return
	end
	subroutine cur_den(f_xx)
 	include 'double.inc'
	include 'new_com.inc'
	dimension f_xx(*)

	call cur_den_c(
     *  nr,nz,u_h,dx,dy,coef,f_xx,eu_fil,pi,
     *  pmag,p_s,pbound,psi,
     *  thalo,index_li,x,rs0,
     *  bt0,index_ves,sp_t)

	return
	end

	subroutine cur_den_c(
     *  nr,nz,u_h,dx,dy,coef,f,eu_fil,pi,
     *  pmag,p_s,pbound,psi,
     *  thalo,index_li,x,rs0,
     *  bt0,index_ves,sp_t)

 	include 'double.inc'
	dimension u_h(*),f(*),psi(nr,nz),index_li(*),x(*),
     *  index_ves(*)

	if(kpr.eq.1)print *,' Call to cur_den...'
	if(kpr.eq.1)print *,' pmag p_s ',pmag,p_s

	alf=1./(coef*dx*dy)

	i_en=i_en+1

	tok_s=0.
	tok_h=0.
	s_pl=0.
        sp_halo=0.

	do i=3,nr-2
	do j=3,nz-2
	kk=(i-1)*nz+j
	if(i_en.eq.1)index_li(kk)=0

	if(index_ves(kk).eq.0)go to 1024

	d=u_h(kk)
	p=psi(i,j)
	f(kk)=d*alf
	tok_s=tok_s+d

	if((pmag-p)*(p_s-p).le.0.)then
	   s_pl=s_pl+1.
	   if(i_en.eq.1)index_li(kk)=1
	end if

	if((pbound-p)*(p_s-p).le.0.)then
           if(index_li(kk).eq.1)then
              sp_halo=sp_halo+1./x(i)
           end if

	tok_h=tok_h+d
	end if

 1024	continue

	end do
	end do

	s_pl=s_pl*dx*dy

	if(kpr.eq.1)print *,' s_pl tok_s ',s_pl,tok_s

        if(kpr.eq.1)print *,' pff_halo sp_halo==',pff_halo,sp_halo

        sp_halo=sp_halo*coef*dx*dy*0.5*rs0

        pff_halo=tok_h/sp_halo
        fprime=pff_halo

	fsqrt0=bt0**2

        psi_i=p_s-pbound

	fsqrt=fsqrt0-fprime*psi_i/rs0

	f8_halo=sqrt(fsqrt)

	del_f=f8_halo-bt0

	expfg=5.*rs0*del_f

	if(kpr.eq.1)print *,' -- del_f-  halo_pol ',del_f,expfg

        if(kpr.eq.1)print *,' pff_halo sp_halo==',pff_halo,sp_halo

	eu_fil=0.9*sqrt(s_pl/pi)

	if(kpr.eq.1)print *,'  eu_fil tok_s tok_h',eu_fil,tok_s,tok_h

	thalo=tok_h
	
	sp_t=sp_pl+sp_halo

	return
	end
	subroutine cur_de()
 	include 'double.inc'
	include 'new_com.inc'

	call cur_de_c(
     *  nr,nz,dx,dy,coef,eu_fil,pi,
     *  pmag,p_s,pbound,psi,
     *  n_fil,r_fil,z_fil,tok_fil,
     *  index_ves,sp_t)

	return
	end

	subroutine cur_de_c(
     *  nr,nz,dx,dy,coef,eu_fil,pi,
     *  pmag,p_s,pbound,psi,
     *  n_fil,r_fil,z_fil,tok_fil,
     *  index_ves,sp_t)

 	include 'double.inc'
	dimension psi(nr,nz),index_ves(*),r_fil(*),z_fil(*),tok_fil(*)

	dimension ind_fil(5000),pdd(6)

	if(kpr.eq.1)print *,' Call to cur_de...'
	if(kpr.eq.1)print *,' pmag pbound p_s n_fil ',pmag,pbound,p_s,n_fil

	alf=1./(coef*dx*dy)

	tok_h=0.
	tok=0.
	do i=1,n_fil
	ind_fil(i)=0
	tok=tok+tok_fil(i)
	end do
	
	if(kpr.eq.1)print *,'tok==',tok

c	read (*,*)


	do k=1,n_fil
	urr=r_fil(k)
	vrr=z_fil(k)

	ind_fil(k)=1
c	if(tok_fil(k).lt.0.)then

      call boxdl(fint,urr,vrr)
	p=fint
	if((pmag-p)*(pbound-p).le.0.)then

c	ind_fil(k)=1
	tok_h=tok_h+tok_fil(k)
	end if
	end do

	kk=0
	do k=1,n_fil
	if(ind_fil(k).eq.1)then
	kk=kk+1
	r_fil(kk)=r_fil(k)
	z_fil(kk)=z_fil(k)
	n_fil=kk
	end if
	end do

	if(kpr.eq.1)print *,' tok_h n_fil==',tok_h,n_fil

	open (unit=41,file='fil_out.dat',form='formatted')

	write (41,*)n_fil
	do i=1,n_fil
	write (41,*)r_fil(i)
	end do
	do i=1,n_fil
	write (41,*)z_fil(i)
	end do
	do i=1,n_fil
	write (41,*)tok_fil(i)
	end do
	
	close (41)

	return
	end

	subroutine svd_fil()
 	include 'double.inc'
	include 'parf1'
	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /ef_0/key_ef
        common
     *  /efil_8/ves_coef,tpl_coef

c        common
c     *  /ge12e/indpf(kf),seps1,seps2,seps3

	dimension indpf(kf)

	CHARACTER*120 fshot,tmp

	k_svd=k_svd+1

74      format(a110)                                                           
	if(k_svd.eq.1)then
c---
     	open(unit=2,file='for040_fil.fl',status='old',form='formatted')
	read (2,*)
	read (2,74)tmp
	close (2)
c---
     	open(unit=41,status='old',file=tmp,form='formatted')
	read (41,*)
	read (41,*)(indpf(i),i=1,npf)
	read (41,*)
	read (41,*)seps1,seps2,seps3
	read (41,*)
	read (41,*)ves_coef,tpl_coef
c	read (41,*)
c	read (41,*)i_svd,i_cal
c	if(kpr.eq.1)print *,'i_svd i_cal',i_svd,i_cal
	close (41)
	end if
	
	if(kpr.eq.1)print *,' KEY_EF==',key_ef
c	read (*,*)


!	call gsvd_ef_ves_fil(indpf,seps1,seps2,seps3)
	call gsvd_ef_fil(indpf,seps1,seps2,seps3)

	return
	end
	subroutine gsvd_ef_fil(indpf,seps1,seps2,seps3)
 	include 'double.inc'
c	implicit real *8 (a-h,o-z)
c====================

	include 'parf1'
	include 'parf2'
	include 'parf4'
	include 'parf5'

	dimension amat(nx,mx),y(nx),indpf(kf),
     *  jpf(kf),sig(nx),a(mx)


	common
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /fwt/fwtp(nloop),fwtb(nprobe)
	common
     *  /probe1/kprobe,bprobe(nprobe)
     *  /probe2/pfprobe(nprobe,kf),vesprobe(nprobe,mu)
     *  /probe3/kpb,Rprobe(nprobe,npb),
     *  zprobe(nprobe,npb),cosa(nprobe),sina(nprobe)
     *  /probe5/bprobep(nprobe)
	common
     *  /ves1/psp(mu),psp0(mu),tcam(mu),tcam0(mu)
     *  /ves2/ncam,rc(mu),zc(mu)
     *  /ves9/tokc,tokc0
	common
     *  /loop1/kloop,RL(nloop),ZL(nloop),psloop(nloop)
     *  /loop2/pfgreen(nloop,kf),vesgreen(nloop,mu)
     *  /loop3/vloop,psf1a,psf1a0
     *  /loop4/psloopg(nloop),psloopg0(nloop)
     *  /loop6/psloopp(nloop)
	common
     *  /ge1/pi
     *  /ge5/kpr
	common
     *  /svd1/psloop_e(nloop),bprobe_e(nprobe)
     *  /svd2/pf_e(kf)

        include 'par_fil'

	common
     *  /efil_1/g_loop(nloop,k_fil),g_probe(nprobe,k_fil)
     *  /efil_2/tok_fil(k_fil)
     *  /efil_3/r_fil(k_fil),z_fil(k_fil)
     *  /efil_4/n_fil
        common
     *  /efil_8/ves_coef,tpl_coef
     *  /efil_9/seps_fil(k_fil)

        parameter (k_ves=20)
	common
     *  /ves_ef_1/ves_loop(nloop,k_ves),ves_probe(nprobe,k_ves)
     *  /ves_ef_2/tok_ves(k_ves)
     *  /ves_ef_3/n_ves

        common
     *	/ge1e/rs0,tpl
     *  /ge2/NTAY,TAY,TT

        common
     *  /c_svd1/chi(1000)

        common
     *  /efil_7/chi_sqr,chi_ps,chi_bp,chi_pf

	character*70 apr
c
	dimension pfc(kf)
	
	real *8 amat,y,sig,a

71	format(20x,a6/,(6(1pe10.3)))
 72     format(20x,a6/,(6(i4)))
c
c   transformation to api=volt*second/2pi

	api=1.e-5/(2.*pi)

c        call ves_green_fur()

c!!!        call ves_green()

	
	n_ves=0

        if(kpr.eq.1)print *,' n_ves==',n_ves


	apr='ves_loop'

        do ii=1,1
c	if(kpr.eq.1)print 71,apr,(ves_loop(ii,i),i=1,n_ves)
        end do

	apr='ves_probe'
        do ii=1,1
c	if(kpr.eq.1)print 71,apr,(ves_probe(ii,i),i=1,n_ves)
        end do

c        stop

c$$$        call cur_green_fil()

	apr='g_loop'
        do ii=1,2
c	if(kpr.eq.1)print 71,apr,(g_loop(ii,i),i=1,n_fil)
        end do

	apr='g_probe'
        do ii=1,2
c	if(kpr.eq.1)print 71,apr,(g_probe(ii,i),i=1,n_fil)
        end do

        call movem_fil()

	apr='g_loop'
        do ii=1,2
c	if(kpr.eq.1)print 71,apr,(g_loop(ii,i),i=1,n_fil)
        end do

	apr='g_probe'
        do ii=1,2
c	if(kpr.eq.1)print 71,apr,(g_probe(ii,i),i=1,n_fil)
        end do



	apr='indpf'
	if(kpr.eq.1)print 72,apr,(indpf(i),i=1,npf)
        

c---
	do i=1,npf
	pfc(i)=pf_e(i)
	end do
c
	k=0
	do i=1,npf
	k=k+indpf(i)
	if(indpf(i).ne.0)jpf(k)=i
	end do

	ma_pf=k
        
c        if(kpr.eq.1)print *,' npf ma_pf==',npf,ma_pf

c--  here we are adding vessel current  terms...

        ma=ma_pf+n_ves

c--  here we are adding current filament terms...

        ma=ma_pf+n_ves+n_fil

	ma1=ma

	ndata=kloop+kprobe+ma_pf+n_ves+1+n_fil

c        if(kpr.eq.1)print *,' ndata ma1==',ndata,ma1
c
	do i=1,ndata
	do j=1,ma
	amat(i,j)=0.
	end do	
	end do
c
c   here start loops....
	psmax=0.

	k_l=0
	do ii=1,kloop
	if(fwtp(ii).gt.0)then
	k_l=k_l+1
	y(ii)=psloop_e(ii)
	if(abs(y(ii)).gt.psmax)psmax=abs(y(ii))
	end if
	end do

	bsmax=0.
	k_b=0
	do ii=1,kprobe
	if(fwtb(ii).gt.0)then
	k_b=k_b+1
	y(ii)=bprobe_e(ii)
	if(abs(y(ii)).gt.bsmax)bsmax=abs(y(ii))
	end if
	end do

	if(kpr.eq.1)print *,' kloop k_l kprobe k_b psmax bsmax',kloop,
     *  k_l,kprobe,k_b,psmax,bsmax

	apr='pfc'
c	if(kpr.eq.1)print 71,apr,(pfc(i),i=1,npf)
	apr='jpf'
c	if(kpr.eq.1)print 72,apr,(jpf(i),i=1,npf)
	apr='indpf'
c	if(kpr.eq.1)print 72,apr,(indpf(i),i=1,npf)

	pfmax=0.
c        if(kpr.eq.1)print *,' ma1==',ma1

	do k=1,ma_pf
c        if(kpr.eq.1)print *,'k kjj==',k,kjj
	kjj=jpf(k)
c        if(kpr.eq.1)print *,'k kjj jpf',k,kjj,jpf(k)

	if(pfmax.lt.abs(pfc(kjj)))pfmax=abs(pfc(kjj))
	end do
	if(kpr.eq.1)print *,' psmax bsmax pfmax',psmax,bsmax,pfmax

	icam=1

c        read (*,*)

	kk=0
	do 100 ii=1,kloop
	if(fwtp(ii).lt.0.9)go to 100
	kk=kk+1
c == experimental psloop_e...
	y(kk)=psloop_e(ii)

c###	sig(kk)=seps1*psmax
	sig(kk)=seps1*(abs(y(kk))+1.e-1*psmax)

c   == pf to loops...
	do  k=1,npf
	if(indpf(k).eq.0)then
	fint=pfgreen(ii,k)*pf(k)
	y(kk)=y(kk)-fint*api
	end if
	end do
c   == vessel to loops...
	
	if(icam.eq.1)then

	tok_cam=0.

	DO  K=1,ncam
	fint=vesgreen(ii,k)*tcam(k)

	tok_cam=tok_cam+tcam(k)

	y(kk)=y(kk)-fint*api
	end do
	end if
c
	do jj=1,ma_pf
	kjj=jpf(jj)	
c   here we determine A matrix
	fint=pfgreen(ii,kjj)
	amat(kk,jj)=fint*api
	end do


c  here plasma to loop greens...
        kjj=0
	do jj=ma_pf+n_ves+1,ma1
	kjj=kjj+1	
c   here we determine A matrix
	fint=g_loop(ii,kjj)
	amat(kk,jj)=fint*api
	end do


c
100	continue
	if(kpr.eq.1)print *,' kk kloop tok_cam',kk,kloop,tok_cam
c---------------------------------------------

c	go to 800
c
c   here start probes....
c   == transform to Tesla *0.1
	api=0.1
	do 101 ii=1,kprobe
	if(fwtb(ii).lt.1.0)go to 101
	kk=kk+1
c == experimental bprobe_e...
	y(kk)=bprobe_e(ii)

c###	sig(kk)=seps2*bsmax
	sig(kk)=seps2*(abs(y(kk))+1.e-1*bsmax)

c   == pf to loops...
	do  k=1,npf
	if(indpf(k).eq.0)then
	fint=pfprobe(ii,k)*pf(k)
	y(kk)=y(kk)-fint*api
	end if
	end do
c
	do jj=1,ma_pf
	kjj=jpf(jj)	
c   here we determine A matrix
	fint=pfprobe(ii,kjj)
	amat(kk,jj)=fint*api
	end do


c here plasma to probes greens...
        kjj=0
	do jj=ma_pf+n_ves+1,ma1
	kjj=kjj+1
c   here we determine A matrix
	fint=g_probe(ii,kjj)
	amat(kk,jj)=fint*api
	end do
c
101	continue
800	continue 
c
	do k=1,ma_pf
	kk=kk+1
	kjj=jpf(k)
	y(kk)=pfc(kjj)
c###	sig(kk)=seps3*pfmax
	sig(kk)=seps3*(abs(y(kk))+0.1*pfmax)
	amat(kk,k)=1.
	end do

c  here we add term for total plasma current...

	kk=kk+1
	y(kk)=tpl
	sig(kk)=seps1*tpl

        do k=1,n_fil
	amat(kk,k+n_ves+ma_pf)=1.
	end do

c here we add terms for filaments...

	i_en=i_en+1

c	if(i_en.eq.1)then

c        end if



	c_max_c=tpl/n_fil

        if(kpr.eq.1)print *,' c_max_c===',c_max_c

c	do k=1,n_fil
c	   c_max=amax1(c_max,abs(tok_fil(k)))
c	end do


	kjj=0
	do k=ma_pf+n_ves+1,ma1
	kk=kk+1
	kjj=kjj+1

c!!!	y(kk)=0.

	y(kk)=tpl/n_fil
c	y(kk)=tpl

c	y(kk)=0.5*tpl/n_fil

c	sig(kk)=seps3*tpl_coef*seps_fil(kjj)*c_max_c
	sig(kk)=2.*tpl_coef*seps_fil(kjj)*c_max_c

	if(kpr.eq.1)print *,' kk y sig=',kk,y(kk),sig(kk)

	amat(kk,k)=1.
	end do

c=====================================================
	namat=nx
	if(kpr.eq.1)print *,' ndata kk',ndata,kk
	ndata=kk


	call svdfit(amat,y,sig,ndata,a,ma,namat)

	apr='a '

c	if(kpr.eq.1)print 71,apr,(a(i),i=1,ma)


	apr='chi_ps'
	if(kpr.eq.1)print 71,apr,(chi(i),i=1,k_l)

        chi_ps=0.
        do i=1,k_l
        chi_ps=chi_ps+chi(i)
        end do


	apr='chi_bp'
c	if(kpr.eq.1)print 71,apr,(chi(i),i=k_l+1,k_l+k_b)

        chi_bp=0.
        do i=k_l+1,k_l+k_b
        chi_bp=chi_bp+chi(i)
        end do

	apr='chi_pf'
c	if(kpr.eq.1)print 71,apr,(chi(i),i=k_l+k_b+1,k_l+k_b+ma_pf)

        chi_pf=0.
        do i=k_l+k_b+1,k_l+k_b+ma_pf
        chi_pf=chi_pf+chi(i)
        end do

	apr='chi_coef'
c	if(kpr.eq.1)print 71,apr,(chi(i),i=ndata-n_fil+1,ndata)

        chi_coef=0.
        do i=ndata-n_fil+1,ndata
        chi_coef=chi_coef+chi(i)
        end do

        if(kpr.eq.1)print *,' chi_ps chi_pb ',chi_ps,chi_bp

        if(kpr.eq.1)print *,' chi_pf chi_coef',chi_pf,chi_coef

	apr='PF_cur'
	if(kpr.eq.1)print 71,apr,(pf(i),i=1,npf)

	do k=1,ma_pf
	kjj=jpf(k)
	if(kpr.eq.1)print *,'k jpf pfc a',k,jpf(k),pfc(kjj),a(k)
	pf(kjj)=a(k)
	end do


c    here we add constancy of coefficients after 5th iteration...

	tok=0.
	tok1=0.
	tok2=0.
	do k=1,n_fil

	tok=tok+tok_fil(k)

	if(kpr.eq.1)print *,' k a tok_fil',k,a(k+ma_pf+n_ves),tok_fil(k)

	tok_fil(k)=a(k+n_ves+ma_pf)

	tok1=tok1+tok_fil(k)
c	if(tok_fil(k).lt.0.)tok_fil(k)=0.

	tok2=tok2+tok_fil(k)
	end do

	if(kpr.eq.1)print *,' i_en tpl tok1 tok2==',i_en,tpl,tok1,tok2

 
	apr='PS_E'
	if(kpr.eq.1)print 71,apr,(psloop_e(i),i=1,kloop)

	apr='BP_T'
c	if(kpr.eq.1)print 71,apr,(bprobe_e(i),i=1,20)

	apr='BP_N'
c	if(kpr.eq.1)print 71,apr,(bprobe_e(i),i=21,kprobe)


        chi_sqr=chi_ps+chi_bp+chi_pf
        
        if(kpr.eq.1)print *,' chi_sqr==',chi_sqr

5000	format(4(1x,1pe14.7))
5001    format(4(i4))


	tok=0.d0
	r_tok=0.d0
	z_tok=0.d0

      do ii=1,n_fil
	tok=tok+tok_fil(ii)
	r_tok=r_tok+r_fil(ii)*tok_fil(ii)
	z_tok=z_tok+z_fil(ii)*tok_fil(ii)
	end do

	r_tok=r_tok/tok
	z_tok=z_tok/tok

	if(kpr.eq.1)print *,' r_tok z_tok=',r_tok,z_tok


	if(kpr.eq.1)print *,' END SVD-FIL'



	return
	end

	subroutine gsvd_ef_ves_fil(indpf,seps1,seps2,seps3)
 	include 'double.inc'
c	implicit real *8 (a-h,o-z)
c====================

	include 'parf1'
	include 'parf2'
	include 'parf4'
	include 'parf5'

	dimension amat(nx,mx),y(nx),indpf(kf),
     *  jpf(kf),sig(nx),a(mx)


	common
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /fwt/fwtp(nloop),fwtb(nprobe)
	common
     *  /probe1/kprobe,bprobe(nprobe)
     *  /probe2/pfprobe(nprobe,kf),vesprobe(nprobe,mu)
     *  /probe3/kpb,Rprobe(nprobe,npb),
     *  zprobe(nprobe,npb),cosa(nprobe),sina(nprobe)
     *  /probe5/bprobep(nprobe)
	common
     *  /ves1/psp(mu),psp0(mu),tcam(mu),tcam0(mu)
     *  /ves2/ncam,rc(mu),zc(mu)
     *  /ves9/tokc,tokc0
	common
     *  /loop1/kloop,RL(nloop),ZL(nloop),psloop(nloop)
     *  /loop2/pfgreen(nloop,kf),vesgreen(nloop,mu)
     *  /loop3/vloop,psf1a,psf1a0
     *  /loop4/psloopg(nloop),psloopg0(nloop)
     *  /loop6/psloopp(nloop)
	common
     *  /ge1/pi
	common
     *  /svd1/psloop_e(nloop),bprobe_e(nprobe)
     *  /svd2/pf_e(kf)

        include 'par_fil'

	common
     *  /efil_1/g_loop(nloop,k_fil),g_probe(nprobe,k_fil)
     *  /efil_2/tok_fil(k_fil)
     *  /efil_3/r_fil(k_fil),z_fil(k_fil)
     *  /efil_4/n_fil
        common
     *  /efil_8/ves_coef,tpl_coef
     *  /efil_9/seps_fil(k_fil)

        parameter (k_ves=20)
	common
     *  /ves_ef_1/ves_loop(nloop,k_ves),ves_probe(nprobe,k_ves)
     *  /ves_ef_2/tok_ves(k_ves)
     *  /ves_ef_3/n_ves

        common
     *	/ge1e/rs0,tpl
     *  /ge2/NTAY,TAY,TT

        common
     *  /c_svd1/chi(1000)

        common
     *  /efil_7/chi_sqr,chi_ps,chi_bp,chi_pf
c
	character*70 apr
c
	dimension pfc(kf)

	real *8 amat,y,sig,a

71	format(20x,a6/,(6(1pe10.3)))
 72     format(20x,a6/,(6(i4)))
c
c   transformation to api=volt*second/2pi

	api=1.e-5/(2.*pi)

        call ves_green_fur()

c!!!        call ves_green()

        if(kpr.eq.1)print *,' n_ves==',n_ves


	apr='ves_loop'

        do ii=1,1
c	if(kpr.eq.1)print 71,apr,(ves_loop(ii,i),i=1,n_ves)
        end do

	apr='ves_probe'
        do ii=1,1
c	if(kpr.eq.1)print 71,apr,(ves_probe(ii,i),i=1,n_ves)
        end do

c        stop

c$$$        call cur_green_fil()

	apr='g_loop'
        do ii=1,2
c	if(kpr.eq.1)print 71,apr,(g_loop(ii,i),i=1,n_fil)
        end do

	apr='g_probe'
        do ii=1,2
c	if(kpr.eq.1)print 71,apr,(g_probe(ii,i),i=1,n_fil)
        end do

        call movem_fil()

	apr='g_loop'
        do ii=1,2
c	if(kpr.eq.1)print 71,apr,(g_loop(ii,i),i=1,n_fil)
        end do

	apr='g_probe'
        do ii=1,2
c	if(kpr.eq.1)print 71,apr,(g_probe(ii,i),i=1,n_fil)
        end do

        

c---
	do i=1,npf
	pfc(i)=pf_e(i)
	end do

	apr='pf_e'
	if(kpr.eq.1)print 71,apr,(pf_e(i),i=1,npf)


c
	k=0
	do i=1,npf
	k=k+indpf(i)
	if(indpf(i).ne.0)jpf(k)=i

	if(kpr.eq.1)print *,' i k indpf jpf=',i,k,indpf(i),jpf(k)
	end do

	ma_pf=k
        
        if(kpr.eq.1)print *,' npf ma_pf==',npf,ma_pf

	do k=1,ma_pf
	kjj=jpf(k)
        if(kpr.eq.1)print *,'k kjj jpf',k,kjj,jpf(k)
	end do
cc--  here we are adding vessel current  terms...

        ma=ma_pf+n_ves

c--  here we are adding current filament terms...

        ma=ma_pf+n_ves+n_fil

	ma1=ma

	ndata=kloop+kprobe+ma_pf+n_ves+1+n_fil

c        if(kpr.eq.1)print *,' ndata ma1==',ndata,ma1
c

      if(kpr.eq.1)print *,' ndata ma==',ndata,ma
      if(kpr.eq.1)print *,' nx mx==',nx,mx


	do i=1,ndata
	do j=1,ma
	amat(i,j)=0.
	end do	
	end do
c   here start loops....
	psmax=0.

	k_l=0
	do ii=1,kloop
	if(fwtp(ii).gt.0)then
	k_l=k_l+1
	y(ii)=psloop_e(ii)
	if(abs(y(ii)).gt.psmax)psmax=abs(y(ii))
	end if
	end do



	bsmax=0.
	k_b=0
	do ii=1,kprobe
	if(fwtb(ii).gt.0)then
	k_b=k_b+1
	y(ii)=bprobe_e(ii)
	if(abs(y(ii)).gt.bsmax)bsmax=abs(y(ii))
	end if
	end do

	if(kpr.eq.1)print *,' kloop k_l kprobe k_b psmax bsmax',kloop,
     *  k_l,kprobe,k_b,psmax,bsmax

	apr='pfc'
c	if(kpr.eq.1)print 71,apr,(pfc(i),i=1,npf)
	apr='jpf'
c	if(kpr.eq.1)print 72,apr,(jpf(i),i=1,npf)
	apr='indpf'
c	if(kpr.eq.1)print 72,apr,(indpf(i),i=1,npf)

	pfmax=0.
c        if(kpr.eq.1)print *,' ma1==',ma1

	do k=1,ma_pf
c        if(kpr.eq.1)print *,'k kjj==',k,kjj
	kjj=jpf(k)
        if(kpr.eq.1)print *,'k kjj jpf',k,kjj,jpf(k)

	if(pfmax.lt.abs(pfc(kjj)))pfmax=abs(pfc(kjj))
	end do
	if(kpr.eq.1)print *,' psmax bsmax pfmax',psmax,bsmax,pfmax


	kk=0
	do 100 ii=1,kloop
	if(fwtp(ii).lt.1.)go to 100
	kk=kk+1
c == experimental psloop_e...
	y(kk)=psloop_e(ii)

c###	sig(kk)=seps1*psmax
	sig(kk)=seps1*(abs(y(kk))+1.e-1*psmax)

c   == pf to loops...
	do  k=1,npf
	if(indpf(k).eq.0)then
	fint=pfgreen(ii,k)*pf(k)
	y(kk)=y(kk)-fint*api
	end if
	end do
c
	do jj=1,ma_pf
	kjj=jpf(jj)	
c   here we determine A matrix
	fint=pfgreen(ii,kjj)
	amat(kk,jj)=fint*api
	end do

c  here vessel to loop greens...
        kjj=0
	do jj=ma_pf+1,ma_pf+n_ves
	kjj=kjj+1	
c   here we determine A matrix
	fint=ves_loop(ii,kjj)
	amat(kk,jj)=fint*api
	end do

c  here plasma to loop greens...
        kjj=0
	do jj=ma_pf+n_ves+1,ma1
	kjj=kjj+1	
c   here we determine A matrix
	fint=g_loop(ii,kjj)
	amat(kk,jj)=fint*api
	end do


c
100	continue
	if(kpr.eq.1)print *,' kk kloop',kk,kloop
c---------------------------------------------

c	go to 800
c
c   here start probes....
c   == transform to Tesla *0.1
	api=0.1
	do 101 ii=1,kprobe
	if(fwtb(ii).lt.1.0)go to 101
	kk=kk+1
c == experimental bprobe_e...
	y(kk)=bprobe_e(ii)

c###	sig(kk)=seps2*bsmax
	sig(kk)=seps2*(abs(y(kk))+1.e-1*bsmax)

c   == pf to loops...
	do  k=1,npf
	if(indpf(k).eq.0)then
	fint=pfprobe(ii,k)*pf(k)
	y(kk)=y(kk)-fint*api
	end if
	end do
c
	do jj=1,ma_pf
	kjj=jpf(jj)	
c   here we determine A matrix
	fint=pfprobe(ii,kjj)
	amat(kk,jj)=fint*api
	end do

c here vessel to probes greens...
        kjj=0
	do jj=ma_pf+1,ma_pf+n_ves
	kjj=kjj+1
c   here we determine A matrix
	fint=ves_probe(ii,kjj)
	amat(kk,jj)=fint*api
	end do

c here plasma to probes greens...
        kjj=0
	do jj=ma_pf+n_ves+1,ma1
	kjj=kjj+1
c   here we determine A matrix
	fint=g_probe(ii,kjj)
	amat(kk,jj)=fint*api
	end do
c
101	continue
800	continue 
c
	do k=1,ma_pf
	kk=kk+1
	kjj=jpf(k)
	y(kk)=pfc(kjj)
c###	sig(kk)=seps3*pfmax
	sig(kk)=seps3*(abs(y(kk))+0.1*pfmax)
	amat(kk,k)=1.
	end do

c  terms with vessel currents...

	kjj=0
	do k=ma_pf+1,ma_pf+n_ves
	kk=kk+1
	kjj=kjj+1

	y(kk)=0.

c!!!	y(kk)=tokc/n_ves

        c_max=abs(ves_cur)/n_ves+1.

        if(kjj.eq.1)c_max=abs(ves_cur)+1.
        
c        if(kpr.eq.1)print *,' cmax of tokc==',c_max

	sig(kk)=ves_coef*seps2*c_max

	amat(kk,k)=1.
	end do

c  here we add term for total plasma current...

	kk=kk+1
	y(kk)=tpl
	sig(kk)=seps1*tpl

        do k=1,n_fil
	amat(kk,k+n_ves+ma_pf)=1.
	end do

c here we add terms for filaments...

	i_en=i_en+1

c	if(i_en.eq.1)then

c        end if



	c_max_c=tpl/n_fil

        if(kpr.eq.1)print *,' c_max_c===',c_max_c

c	do k=1,n_fil
c	   c_max=amax1(c_max,abs(tok_fil(k)))
c	end do


	kjj=0
	do k=ma_pf+n_ves+1,ma1
	kk=kk+1
	kjj=kjj+1

c!!!	y(kk)=0.

	y(kk)=tpl/n_fil
c	y(kk)=tpl

c	y(kk)=0.5*tpl/n_fil

c	sig(kk)=seps3*tpl_coef*seps_fil(kjj)*c_max_c
	sig(kk)=5.*seps3*tpl_coef*seps_fil(kjj)*c_max_c

	amat(kk,k)=1.
	end do

c=====================================================
	namat=nx
	 
	if(kpr.eq.1)print *,' ndata kk ma',ndata,kk,ma
	ndata=kk


	call svdfit(amat,y,sig,ndata,a,ma,namat)

	apr='a '

c	if(kpr.eq.1)print 71,apr,(a(i),i=1,ma)


	apr='chi_ps'
	if(kpr.eq.1)print 71,apr,(chi(i),i=1,k_l)

        chi_ps=0.
        do i=1,k_l
        chi_ps=chi_ps+chi(i)
        end do


	apr='chi_bp'
c	if(kpr.eq.1)print 71,apr,(chi(i),i=k_l+1,k_l+k_b)

        chi_bp=0.
        do i=k_l+1,k_l+k_b
        chi_bp=chi_bp+chi(i)
        end do

	apr='chi_pf'
c	if(kpr.eq.1)print 71,apr,(chi(i),i=k_l+k_b+1,k_l+k_b+ma_pf)

        chi_pf=0.
        do i=k_l+k_b+1,k_l+k_b+ma_pf
        chi_pf=chi_pf+chi(i)
        end do

	apr='chi_coef'
c	if(kpr.eq.1)print 71,apr,(chi(i),i=ndata-n_fil+1,ndata)

        chi_coef=0.
        do i=ndata-n_fil+1,ndata
        chi_coef=chi_coef+chi(i)
        end do

        if(kpr.eq.1)print *,' chi_ps chi_pb ',chi_ps,chi_bp

        if(kpr.eq.1)print *,' chi_pf chi_coef',chi_pf,chi_coef

	apr='PF_cur'
	if(kpr.eq.1)print 71,apr,(pf(i),i=1,npf)

	do k=1,ma_pf
	kjj=jpf(k)
	if(kpr.eq.1)print *,'k jpf pfc a',k,jpf(k),pfc(kjj),a(k)
	pf(kjj)=a(k)
	end do

	ves_cur=0.
	do k=1,n_ves
	tok_ves(k)=a(k+ma_pf)
	ves_cur=ves_cur+tok_ves(k)
	if(kpr.eq.1)print *,' k a tok_ves',k,a(k+ma_pf),tok_ves(k)
	end do

        if(kpr.eq.1)print *,' tokc ves_cur===',tokc,ves_cur


c    here we add constancy of coefficients after 5th iteration...

	tok=0.
	tok1=0.
	tok2=0.
	do k=1,n_fil

	tok=tok+tok_fil(k)

	if(kpr.eq.1)print *,' k a tok_fil',k,a(k+ma_pf+n_ves),tok_fil(k)

	tok_fil(k)=a(k+n_ves+ma_pf)

	tok1=tok1+tok_fil(k)
c	if(tok_fil(k).lt.0.)tok_fil(k)=0.

	tok2=tok2+tok_fil(k)
	end do

	if(kpr.eq.1)print *,' i_en tpl tok1 tok2==',i_en,tpl,tok1,tok2

        call ves_cur_fur()

	apr='PS_E'
c	if(kpr.eq.1)print 71,apr,(psloop_e(i),i=1,kloop)

	apr='BP_T'
c	if(kpr.eq.1)print 71,apr,(bprobe_e(i),i=1,20)

	apr='BP_N'
c	if(kpr.eq.1)print 71,apr,(bprobe_e(i),i=21,kprobe)


        chi_sqr=chi_ps+chi_bp+chi_pf
        
        if(kpr.eq.1)print *,' chi_sqr==',chi_sqr


	open (unit=41,file='dina_out.dat',form='formatted')

	write (41,*)'time==='
	write (41,*)tt

	write (41,*)'plasma cur[KA]     vessel cur [KA] ',
     *  'vessel_cur_exp[KA]'
	write (41,5000)tpl,tokc,tokc0

	write (41,*)'chi_sqr          chi_ps      ',
     *  '    chi_bp          chi_pf '
	write (41,5000)chi_sqr,chi_ps,chi_bp,chi_pf

	write (41,*)'vessel FUR- I_ed0 M_coef:1-10 '
	write (41,5000)(tok_ves(i),i=1,n_ves)


	write (41,*)'chi_loops '
	write (41,5000)(chi(i),i=1,k_l)


	write (41,*)'chi-probes '
	write (41,5000)(chi(i),i=k_l+1,k_l+k_b)


	write (41,*)'chi_PF-coils '
	write (41,5000)(chi(i),i=k_l+k_b+1,k_l+k_b+ma_pf)

        call loopflux()       
                     
	write (41,*)'fwt_loops '
	write (41,5000)(fwtp(i),i=1,kloop)

	write (41,*)'psi_loops_calc '
	write (41,5000)(psloop(i),i=1,kloop)
                     
	write (41,*)'psi_loops_exp '
	write (41,5000)(psloop_e(i),i=1,kloop)

        call probefield()
                     
	write (41,*)'fwt_T_probes '
	write (41,5000)(fwtb(i),i=1,20)

	write (41,*)'B_T-probes-calc '
	write (41,5000)(bprobe(i),i=1,20)

	write (41,*)'B_T-probes-exp '
	write (41,5000)(bprobe_e(i),i=1,20)
                     
                     
	write (41,*)'fwt_N_probes '
	write (41,5000)(fwtb(i),i=20+1,20+19)

	write (41,*)'B_N-probes-calc '
        write (41,5000)(bprobe(i),i=20+1,20+19)

	write (41,*)'B_N-probes-exp '
        write (41,5000)(bprobe_e(i),i=20+1,20+19)

	write (41,*)'PF_calc '
	write (41,5000)(pf(i),i=1,npf)

	write (41,*)'PF_exp '
	write (41,5000)(pf_e(i),i=1,npf)

	close (41)
5000	format(4(1x,1pe14.7))
5001    format(4(i4))


	if(kpr.eq.1)print *,' END SVD-FIL'



	return
	end

	subroutine svd_fil2()
 	include 'double.inc'
	include 'parf1'
	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /ef_0/key_ef
        common
     *  /efil_8/ves_coef,tpl_coef
        common
     *  /ge12e/indpf(kf),seps1,seps2,seps3

	CHARACTER*120 fshot,tmp

	k_svd=k_svd+1

74      format(a110)                                                           
	if(k_svd.eq.1)then
c---
     	open(unit=2,file='for040.fl',status='old',form='formatted')
	read (2,*)
	read (2,74)tmp
	close (2)
c---
     	open(unit=41,status='old',file=tmp,form='formatted')
	read (41,*)
	read (41,*)(indpf(i),i=1,npf)
	read (41,*)
	read (41,*)seps1,seps2,seps3
	read (41,*)
	read (41,*)ves_coef,tpl_coef
c	read (41,*)
c	read (41,*)i_svd,i_cal
c	if(kpr.eq.1)print *,'i_svd i_cal',i_svd,i_cal
	close (41)
	end if
	
	if(kpr.eq.1)print *,' KEY_EF==',key_ef
c	read (*,*)


	call gsvd_ef_ves_fil2(indpf,seps1,seps2,seps3)

	return
	end
	subroutine gsvd_ef_ves_fil2(indpf_xx,seps1_xx,seps2_xx,seps3_xx)
 	include 'double.inc'
	dimension indpf_xx(*)
	include 'new_com.inc'

	call gsvd_ef_ves_fil2_c(indpf_xx,seps1_xx,seps2_xx,seps3_xx,
     * ves_curr)

	return
	end
	subroutine gsvd_ef_ves_fil2_c(indpf,seps1,seps2,seps3,
     * ves_curr)
 	include 'double.inc'
c	implicit real *8 (a-h,o-z)
c====================
	 dimension ves_curr(*)

	include 'parf1'
	include 'parf2'
	include 'parf4'
	include 'parf5'

	dimension amat(nx,mx),y(nx),indpf(kf),
     *  jpf(kf),sig(nx),a(mx)


	common
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /fwt/fwtp(nloop),fwtb(nprobe)
	common
     *  /probe1/kprobe,bprobe(nprobe)
     *  /probe2/pfprobe(nprobe,kf),vesprobe(nprobe,mu)
     *  /probe3/kpb,Rprobe(nprobe,npb),
     *  zprobe(nprobe,npb),cosa(nprobe),sina(nprobe)
     *  /probe5/bprobep(nprobe)
	common
     *  /ves1/psp(mu),psp0(mu),tcam(mu),tcam0(mu)
     *  /ves2/ncam,rc(mu),zc(mu)
     *  /ves9/tokc,tokc0
	common
     *  /loop1/kloop,RL(nloop),ZL(nloop),psloop(nloop)
     *  /loop2/pfgreen(nloop,kf),vesgreen(nloop,mu)
     *  /loop3/vloop,psf1a,psf1a0
     *  /loop4/psloopg(nloop),psloopg0(nloop)
     *  /loop6/psloopp(nloop)
	common
     *  /ge1/pi
	common
     *  /svd1/psloop_e(nloop),bprobe_e(nprobe)
     *  /svd2/pf_e(kf)

        include 'par_fil'

	common
     *  /efil_1/g_loop(nloop,k_fil),g_probe(nprobe,k_fil)
     *  /efil_2/tok_fil(k_fil)
     *  /efil_3/r_fil(k_fil),z_fil(k_fil)
     *  /efil_4/n_fil
        common
     *  /efil_8/ves_coef,tpl_coef
     *  /efil_9/seps_fil(k_fil)

        parameter (k_ves=20)
	common
     *  /ves_ef_1/ves_loop(nloop,k_ves),ves_probe(nprobe,k_ves)
     *  /ves_ef_2/tok_ves(k_ves)
     *  /ves_ef_3/n_ves

        common
     *	/ge1e/rs0,tpl
     *  /ge2/NTAY,TAY,TT

        common
     *  /c_svd1/chi(1000)

        common
     *  /efil_7/chi_sqr,chi_ps,chi_bp,chi_pf
c
	character*70 apr
c
	dimension pfc(kf)

	real *8 amat,y,sig,a

71	format(20x,a6/,(6(1pe10.3)))
 72     format(20x,a6/,(6(i4)))
c
c   transformation to api=volt*second/2pi

	api=1.e-5/(2.*pi)

        call ves_green_fur()

c!!!        call ves_green()

        if(kpr.eq.1)print *,' n_ves==',n_ves

       call ves_cur_exp()

	apr='ves_loop'

        do ii=1,1
c	if(kpr.eq.1)print 71,apr,(ves_loop(ii,i),i=1,n_ves)
        end do

	apr='ves_probe'
        do ii=1,1
c	if(kpr.eq.1)print 71,apr,(ves_probe(ii,i),i=1,n_ves)
        end do

c        stop

c$$$        call cur_green_fil()

	apr='g_loop'
        do ii=1,2
c	if(kpr.eq.1)print 71,apr,(g_loop(ii,i),i=1,n_fil)
        end do

	apr='g_probe'
        do ii=1,2
c	if(kpr.eq.1)print 71,apr,(g_probe(ii,i),i=1,n_fil)
        end do

        call movem_fil()

	apr='g_loop'
        do ii=1,2
c	if(kpr.eq.1)print 71,apr,(g_loop(ii,i),i=1,n_fil)
        end do

	apr='g_probe'
        do ii=1,2
c	if(kpr.eq.1)print 71,apr,(g_probe(ii,i),i=1,n_fil)
        end do

        

c---
	do i=1,npf
	pfc(i)=pf_e(i)
	end do
c
	k=0
	do i=1,npf
	k=k+indpf(i)
	if(indpf(i).ne.0)jpf(k)=i
	end do

	ma_pf=k
        
c        if(kpr.eq.1)print *,' npf ma_pf==',npf,ma_pf

c--  here we are adding vessel current  terms...

        ma=ma_pf+n_ves

c--  here we are adding current filament terms...

        ma=ma_pf+n_ves+n_fil

	ma1=ma

	ndata=kloop+kprobe+ma_pf+n_ves+1+1+n_fil

c        if(kpr.eq.1)print *,' ndata ma1==',ndata,ma1
c
	do i=1,ndata
	do j=1,ma
	amat(i,j)=0.
	end do	
	end do
c
c   here start loops....
	psmax=0.

	k_l=0
	do ii=1,kloop
	if(fwtp(ii).gt.0)then
	k_l=k_l+1
	y(ii)=psloop_e(ii)
	if(abs(y(ii)).gt.psmax)psmax=abs(y(ii))
	end if
	end do

	bsmax=0.
	k_b=0
	do ii=1,kprobe
	if(fwtb(ii).gt.0)then
	k_b=k_b+1
	y(ii)=bprobe_e(ii)
	if(abs(y(ii)).gt.bsmax)bsmax=abs(y(ii))
	end if
	end do

	if(kpr.eq.1)print *,' kloop k_l kprobe k_b psmax bsmax',kloop,
     *  k_l,kprobe,k_b,psmax,bsmax

	apr='pfc'
c	if(kpr.eq.1)print 71,apr,(pfc(i),i=1,npf)
	apr='jpf'
c	if(kpr.eq.1)print 72,apr,(jpf(i),i=1,npf)
	apr='indpf'
c	if(kpr.eq.1)print 72,apr,(indpf(i),i=1,npf)

	pfmax=0.
c        if(kpr.eq.1)print *,' ma1==',ma1

	do k=1,ma_pf
c        if(kpr.eq.1)print *,'k kjj==',k,kjj
	kjj=jpf(k)
c        if(kpr.eq.1)print *,'k kjj jpf',k,kjj,jpf(k)

	if(pfmax.lt.abs(pfc(kjj)))pfmax=abs(pfc(kjj))
	end do
	if(kpr.eq.1)print *,' psmax bsmax pfmax',psmax,bsmax,pfmax

c        read (*,*)

	kk=0
	do 100 ii=1,kloop
	if(fwtp(ii).lt.1.)go to 100
	kk=kk+1
c == experimental psloop_e...
	y(kk)=psloop_e(ii)

c###	sig(kk)=seps1*psmax
	sig(kk)=seps1*(abs(y(kk))+1.e-1*psmax)

c   == pf to loops...
	do  k=1,npf
	if(indpf(k).eq.0)then
	fint=pfgreen(ii,k)*pf(k)
	y(kk)=y(kk)-fint*api
	end if
	end do
c
	do jj=1,ma_pf
	kjj=jpf(jj)	
c   here we determine A matrix
	fint=pfgreen(ii,kjj)
	amat(kk,jj)=fint*api
	end do

c  here vessel to loop greens...
        kjj=0
	do jj=ma_pf+1,ma_pf+n_ves
	kjj=kjj+1	
c   here we determine A matrix
	fint=ves_loop(ii,kjj)
	amat(kk,jj)=fint*api
	end do

c  here plasma to loop greens...
        kjj=0
	do jj=ma_pf+n_ves+1,ma1
	kjj=kjj+1	
c   here we determine A matrix
	fint=g_loop(ii,kjj)
	amat(kk,jj)=fint*api
	end do


c
100	continue
	if(kpr.eq.1)print *,' kk kloop',kk,kloop
c---------------------------------------------

c	go to 800
c
c   here start probes....
c   == transform to Tesla *0.1
	api=0.1
	do 101 ii=1,kprobe
	if(fwtb(ii).lt.1.0)go to 101
	kk=kk+1
c == experimental bprobe_e...
	y(kk)=bprobe_e(ii)

c###	sig(kk)=seps2*bsmax
	sig(kk)=seps2*(abs(y(kk))+1.e-1*bsmax)

c   == pf to loops...
	do  k=1,npf
	if(indpf(k).eq.0)then
	fint=pfprobe(ii,k)*pf(k)
	y(kk)=y(kk)-fint*api
	end if
	end do
c
	do jj=1,ma_pf
	kjj=jpf(jj)	
c   here we determine A matrix
	fint=pfprobe(ii,kjj)
	amat(kk,jj)=fint*api
	end do

c here vessel to probes greens...
        kjj=0
	do jj=ma_pf+1,ma_pf+n_ves
	kjj=kjj+1
c   here we determine A matrix
	fint=ves_probe(ii,kjj)
	amat(kk,jj)=fint*api
	end do

c here plasma to probes greens...
        kjj=0
	do jj=ma_pf+n_ves+1,ma1
	kjj=kjj+1
c   here we determine A matrix
	fint=g_probe(ii,kjj)
	amat(kk,jj)=fint*api
	end do
c
101	continue
800	continue 
c
	do k=1,ma_pf
	kk=kk+1
	kjj=jpf(k)
	y(kk)=pfc(kjj)
c###	sig(kk)=seps3*pfmax
	sig(kk)=seps3*(abs(y(kk))+0.1*pfmax)
	amat(kk,k)=1.
	end do

c  terms with vessel currents...

	kjj=0
	do k=ma_pf+1,ma_pf+n_ves
	kk=kk+1
	kjj=kjj+1

	y(kk)=0.

c!!!	y(kk)=tokc/n_ves

        c_max=abs(ves_cur)/n_ves+1.

        if(kjj.eq.1)c_max=abs(ves_cur)+1.
        
c        if(kpr.eq.1)print *,' cmax of tokc==',c_max

	sig(kk)=ves_coef*seps2*c_max

	amat(kk,k)=1.
	end do

c  here we add term for total vessel current...

	kk=kk+1

	if(abs(tokc0).le.1.)tokc0=1.

	y(kk)=tokc0



	sig(kk)=seps1*abs(tokc0)+1.e-8

      do k=1,n_ves
	amat(kk,k+ma_pf)=ves_curr(k)
	end do



c  here we add term for total plasma current...

	kk=kk+1
	y(kk)=tpl
	sig(kk)=seps1*tpl

        do k=1,n_fil
	amat(kk,k+n_ves+ma_pf)=1.
	end do

c here we add terms for filaments...

	i_en=i_en+1

c	if(i_en.eq.1)then

c        end if



	c_max_c=tpl/n_fil

        if(kpr.eq.1)print *,' c_max_c===',c_max_c

c	do k=1,n_fil
c	   c_max=amax1(c_max,abs(tok_fil(k)))
c	end do


	kjj=0
	do k=ma_pf+n_ves+1,ma1
	kk=kk+1
	kjj=kjj+1

c!!!	y(kk)=0.

	y(kk)=tpl/n_fil
c	y(kk)=tpl

c	y(kk)=0.5*tpl/n_fil

c	sig(kk)=seps3*tpl_coef*seps_fil(kjj)*c_max_c
	sig(kk)=5.*seps3*tpl_coef*seps_fil(kjj)*c_max_c

	amat(kk,k)=1.
	end do

c=====================================================
	namat=nx
	if(kpr.eq.1)print *,' ndata kk',ndata,kk
	ndata=kk

	call svdfit(amat,y,sig,ndata,a,ma,namat)

	apr='a '

c	if(kpr.eq.1)print 71,apr,(a(i),i=1,ma)


	apr='chi_ps'
	if(kpr.eq.1)print 71,apr,(chi(i),i=1,k_l)

        chi_ps=0.
        do i=1,k_l
        chi_ps=chi_ps+chi(i)
        end do


	apr='chi_bp'
c	if(kpr.eq.1)print 71,apr,(chi(i),i=k_l+1,k_l+k_b)

        chi_bp=0.
        do i=k_l+1,k_l+k_b
        chi_bp=chi_bp+chi(i)
        end do

	apr='chi_pf'
c	if(kpr.eq.1)print 71,apr,(chi(i),i=k_l+k_b+1,k_l+k_b+ma_pf)

        chi_pf=0.
        do i=k_l+k_b+1,k_l+k_b+ma_pf
        chi_pf=chi_pf+chi(i)
        end do

	apr='chi_coef'
c	if(kpr.eq.1)print 71,apr,(chi(i),i=ndata-n_fil+1,ndata)

        chi_coef=0.
        do i=ndata-n_fil+1,ndata
        chi_coef=chi_coef+chi(i)
        end do

        if(kpr.eq.1)print *,' chi_ps chi_pb ',chi_ps,chi_bp

        if(kpr.eq.1)print *,' chi_pf chi_coef',chi_pf,chi_coef

	apr='PF_cur'
	if(kpr.eq.1)print 71,apr,(pf(i),i=1,npf)

	do k=1,ma_pf
	kjj=jpf(k)
	if(kpr.eq.1)print *,'k jpf pfc a',k,jpf(k),pfc(kjj),a(k)
	pf(kjj)=a(k)
	end do

	ves_cur=0.
	tokc=0.
	do k=1,n_ves
	tok_ves(k)=a(k+ma_pf)
	ves_cur=ves_cur+tok_ves(k)
	tokc=tokc+ves_curr(k)*tok_ves(k)
	if(kpr.eq.1)print *,' k a tok_ves',k,a(k+ma_pf),tok_ves(k)
	end do

        if(kpr.eq.1)print *,' tokc tokc0 ves_cur===',tokc,tokc0,ves_cur

c    here we add constancy of coefficients after 5th iteration...

	tok=0.
	tok1=0.
	tok2=0.
	do k=1,n_fil

	tok=tok+tok_fil(k)

	if(kpr.eq.1)print *,' k a tok_fil',k,a(k+ma_pf+n_ves),tok_fil(k)

	tok_fil(k)=a(k+n_ves+ma_pf)

	tok1=tok1+tok_fil(k)
c	if(tok_fil(k).lt.0.)tok_fil(k)=0.

	tok2=tok2+tok_fil(k)
	end do

	if(kpr.eq.1)print *,' i_en tpl tok1 tok2==',i_en,tpl,tok1,tok2

        call ves_cur_fur()

	apr='PS_E'
c	if(kpr.eq.1)print 71,apr,(psloop_e(i),i=1,kloop)

	apr='BP_T'
c	if(kpr.eq.1)print 71,apr,(bprobe_e(i),i=1,20)

	apr='BP_N'
c	if(kpr.eq.1)print 71,apr,(bprobe_e(i),i=21,kprobe)


        chi_sqr=chi_ps+chi_bp+chi_pf
        
        if(kpr.eq.1)print *,' chi_sqr==',chi_sqr


	open (unit=41,file='dina_out.dat',form='formatted')

	write (41,*)'time==='
	write (41,*)tt

	write (41,*)'plasma cur[KA]     vessel cur [KA] ',
     *  'vessel_cur_exp[KA]'
	write (41,5000)tpl,tokc,tokc0

	write (41,*)'chi_sqr          chi_ps      ',
     *  '    chi_bp          chi_pf '
	write (41,5000)chi_sqr,chi_ps,chi_bp,chi_pf

	write (41,*)'vessel FUR- I_ed0 M_coef:1-10 '
	write (41,5000)(tok_ves(i),i=1,n_ves)


	write (41,*)'chi_loops '
	write (41,5000)(chi(i),i=1,k_l)


	write (41,*)'chi-probes '
	write (41,5000)(chi(i),i=k_l+1,k_l+k_b)


	write (41,*)'chi_PF-coils '
	write (41,5000)(chi(i),i=k_l+k_b+1,k_l+k_b+ma_pf)

        call loopflux()       
                     
	write (41,*)'fwt_loops '
	write (41,5000)(fwtp(i),i=1,kloop)

	write (41,*)'psi_loops_calc '
	write (41,5000)(psloop(i),i=1,kloop)
                     
	write (41,*)'psi_loops_exp '
	write (41,5000)(psloop_e(i),i=1,kloop)

        call probefield()
                     
	write (41,*)'fwt_T_probes '
	write (41,5000)(fwtb(i),i=1,20)

	write (41,*)'B_T-probes-calc '
	write (41,5000)(bprobe(i),i=1,20)

	write (41,*)'B_T-probes-exp '
	write (41,5000)(bprobe_e(i),i=1,20)
                     
                     
	write (41,*)'fwt_N_probes '
	write (41,5000)(fwtb(i),i=20+1,20+19)

	write (41,*)'B_N-probes-calc '
        write (41,5000)(bprobe(i),i=20+1,20+19)

	write (41,*)'B_N-probes-exp '
        write (41,5000)(bprobe_e(i),i=20+1,20+19)

	write (41,*)'PF_calc '
	write (41,5000)(pf(i),i=1,npf)

	write (41,*)'PF_exp '
	write (41,5000)(pf_e(i),i=1,npf)

	close (41)
5000	format(4(1x,1pe14.7))
5001    format(4(i4))


	if(kpr.eq.1)print *,' END SVD-FIL'



	return
	end

        subroutine fil_dis_cir()

	include 'double.inc'
        include 'new_com.inc'
      
        call fil_dis_cir_c(
     *  r0,z0,eu,ke,xu,yu,
     *  n_fil,r_fil,z_fil,seps_fil,
     *  pi,kpr,del_ramp)

        return
        end

        subroutine fil_dis_cir_c(
     *  r0,z0,eu,ke,xu,yu,
     *  n_fil,r_fil,z_fil,seps_fil,
     *  pi,kpr,del_ramp)

	include 'double.inc'
        dimension r_fil(*),z_fil(*),xu(*),yu(*),seps_fil(*)

	common /c_fil_dis1/elong_fil,eu_fil

c
	character*70 apr
71	format(20x,a6/,(6(1pe10.3)))


	i_en=i_en+1
	if(i_en.eq.1)then

        open (unit=41,file='fil_dis.dat',form='formatted')
        read (41,*)
        read (41,*)n_rad,n_tet,elong_fil,eu_fil
        n_fil=n_rad*n_tet
        read (41,*)
        read (41,*)seps1        
        close (41)
      
	do i=1,n_fil
	seps_fil(i)=seps1
	end do
	  
        if(kpr.eq.1)print *,' n_rad n_tet elong_fil eu_fil seps1',
     *  n_rad,n_tet,elong_fil,eu_fil,seps1


	apr='seps_fil'
	if(kpr.eq.1)print 71,apr,(seps_fil(i),i=1,n_fil)
	
	end if



      if(kpr.eq.1)print *,'  elong_fil eu_fil ',
     * elong_fil,eu_fil

	if(kpr.eq.1)print *,' r0 z0 del_ramp',
     *  r0,z0,del_ramp

        ii=1

	urr=r0
	vrr=z0

         r_fil(ii)=urr
         z_fil(ii)=vrr


!!!        do i=2,n_rad
        do i=3,n_rad

        po=0.9*eu_fil*(i-1.5)/(n_rad-1.5)

        do j=2,n_tet
           tet=2.*pi*(j-1.)/(n_tet-1.)
           
           urr=r0+po*cos(tet)
           vrr=z0+po*elong_fil*sin(tet)
           
           call caet2(r0,z0,urr,vrr,ipoint,ke,xu,yu)

           if(ipoint.eq.1)then
              ii=ii+1
              r_fil(ii)=urr
              z_fil(ii)=vrr
           end if

	END DO
	END DO

        n_fil=ii
        if(kpr.eq.1)print *,' n_fil===',n_fil

	apr='r_fil'
c	if(kpr.eq.1)print 71,apr,(r_fil(i),i=1,n_fil)
	apr='z_fil'
c	if(kpr.eq.1)print 71,apr,(z_fil(i),i=1,n_fil)




        return
        end
        subroutine fil_dis_rec()

	include 'double.inc'
        include 'new_com.inc'
      
        call fil_dis_rec_c(
     *  r0,z0,eu,ke,xu,yu,
     *  n_fil,r_fil,z_fil,seps_fil)

        return
        end

        subroutine fil_dis_rec_c(
     *  r0,z0,eu,ke,xu,yu,
     *  n_fil,r_fil,z_fil,seps_fil)

	include 'double.inc'
        dimension r_fil(*),z_fil(*),xu(*),yu(*),seps_fil(*)
c
	character*70 apr
71	format(20x,a6/,(6(1pe10.3)))

        open (unit=41,file='fil_dis.dat',form='formatted')
        read (41,*)
        read (41,*)n_rad,n_tet,elong,eu_fil
        n_fil=n_rad*n_tet

        read (41,*)
        read (41,*)(seps_fil(i),i=1,n_fil)
        
        close (41)
        
        if(kpr.eq.1)print *,' n_rad n_tet elong',n_rad,n_tet,elong

        ii=0
            
        r1=r0-eu_fil
        r2=r0+eu_fil

        z1=z0-eu_fil*elong
        z2=z0+eu_fil*elong


        do i=1,n_rad
        urr=r1+(r2-r1)*(float(i)-1.)/(float(n_rad)-1.)

        do j=1,n_tet
        vrr=z1+(z2-z1)*(float(j)-1.)/(float(n_tet)-1.)

        call caet2(r0,z0,urr,vrr,ipoint,ke,xu,yu)

c        if(kpr.eq.1)print *,' i j urr vrr',i,j,urr,vrr
c        if(kpr.eq.1)print *,' ke ipoint',ke,ipoint
c        if(kpr.eq.1)print *,' '


 	if(ipoint.eq.1)then
        ii=ii+1
        r_fil(ii)=urr
        z_fil(ii)=vrr
        end if

	END DO
	END DO

        n_fil=ii
        if(kpr.eq.1)print *,' n_fil===',n_fil

	apr='r_fil'
	if(kpr.eq.1)print 71,apr,(r_fil(i),i=1,n_fil)
	apr='z_fil'
	if(kpr.eq.1)print 71,apr,(z_fil(i),i=1,n_fil)

	apr='seps_fil'
	if(kpr.eq.1)print 71,apr,(seps_fil(i),i=1,n_fil)

        i_test=0
        if(i_test.eq.1)then
        open(unit=41,file='fit_jt.dat',form='formatted')
        read (41,*)
        read (41,*)n_fil
        read (41,*)
        read (41,*)(r_fil(i),i=1,n_fil)
        read (41,*)
        read (41,*)(z_fil(i),i=1,n_fil)
c        read (41,*)
c        read (41,*)(tok_fil(i),i=1,n_fil)
        close (41)
        end if

        return
        end

        subroutine ind_fil_c()

	include 'double.inc'
        include 'new_com.inc'
      
        call ind_fil_c_c(
     *  nr,nz,x,y,ind_fil,
     *  r0,z0,eu,ke,xu,yu)

        return
        end

        subroutine ind_fil_c_c(
     *  nr,nz,x,y,ind_fil,
     *  r0,z0,eu,ke,xu,yu)

	include 'double.inc'
        dimension x(*),y(*),ind_fil(*),xu(*),yu(*)
c
	dist_min=1.e5

	DO I=2,nr-1
	DO J=2,nz-1
	kk=(i-1)*nz+j
	ind_fil(kk)=0
	dist=sqrt( (x(i)-r0)**2+(y(j)-z0)**2)
	if(dist.le.dist_min )dist_min=dist

	if(dist.gt.eu )go to 9
        call caet2(r0,z0,x(i),y(j),ipoint,ke,xu,yu)
	if(ipoint.eq.1)ind_fil(kk)=1

9	CONTINUE

	END DO
	END DO

        return
        end


        subroutine movem_fil()
	include 'double.inc'
        include 'new_com.inc'
        
        call movem_fil_c(
     *  n_fil,r_fil,z_fil)

        return
        end

        subroutine movem_fil_c(
     *  n_fil,r_fil,z_fil)

	include 'double.inc'
        dimension r_fil(*),z_fil(*)
c
	include 'parf1'
	include 'parf2'
	include 'parf4'
	include 'parf2e'

        include 'par_fil'

	common
     *	/loop1/kloop,rl(nloop),zl(nloop),psloop(nloop)
     *	/loop5e/pslgreene(nwnhe,nloop)
c
	common
     *	/probe1/kprobe,bprobe(nprobe)
     *	/probe4e/bprgreene(nwnhe,nprobe)

	common
     *  /efil_1/g_loop(nloop,k_fil),g_probe(nprobe,k_fil)
        
        do ii=1,n_fil

	urr=r_fil(ii)
	vrr=z_fil(ii)

	if(kpr.eq.1)print *,' ii urr vrr=',ii,urr,vrr

	call boxde_1(urr,vrr,c00,c10,c01,c11,ij,i1j,ij1,i1j1)

	do k=1,kloop
	fint=c00*pslgreene(ij,k) + c10*pslgreene(i1j,k) +
     *  c01*pslgreene(ij1,k)+ c11*pslgreene(i1j1,k)
	g_loop(k,ii)=fint
	end do


	do k=1,nprobe
	fint=c00*bprgreene(ij,k) + c10*bprgreene(i1j,k) +
     *  c01*bprgreene(ij1,k)+ c11*bprgreene(i1j1,k)
	g_probe(k,ii)=fint
	end do

	end do


        RETURN
        END
c

        subroutine cur_green_fil()
	include 'double.inc'
        include 'new_com.inc'
        
        call cur_green_fil_c(
     *  n_fil,ind_fil,r_fil,z_fil,x,y)

        return
        end

        subroutine cur_green_fil_c(
     *  n_fil,ind_fil,r_fil,z_fil,x,y)


	include 'double.inc'
        dimension ind_fil(*),r_fil(*),z_fil(*),x(*),y(*)


	include 'parf2'
	include 'parf4'
        include 'par_fil'

	common
     *  /efil_1/g_loop(nloop,k_fil),g_probe(nprobe,k_fil)
c
	common
     *	/loop1/kloop,rl(nloop),zl(nloop),psloop(nloop)
     *	/loop5/pslgreen(nwnh,nloop)

c
	common
     *	/probe1/kprobe,bprobe(nprobe)
     *	/probe4/bprgreen(nwnh,nprobe)

        ii=0

	DO I=2,nr-1
           DO J=2,nz-1
              kk=(i-1)*nz+j
              if(ind_fil(kk).eq.1)then
                 ii=ii+1
                 r_fil(ii)=x(i)
                 z_fil(ii)=y(j)

                 do k=1,kloop
                    g_loop(k,ii)=pslgreen(kk,k)
                 end do
                 do k=1,kprobe
                    g_probe(k,ii)=bprgreen(kk,k)
                 end do
              end if

           END DO
	END DO
        
        n_fil=ii
        
        if(kpr.eq.1)print *,' n_fil===',n_fil


        return
        end


	subroutine psi_fil()
	include 'double.inc'
        include 'new_com.inc'

	call psi_fil_c(
     *  n_fil,r_fil,z_fil,tok_fil,
     *  tpl,r0,z0,r_tok1,z_tok1)
        
        return
        end


	subroutine psi_fil_c(
     *  n_fil,r_fil,z_fil,tok_fil,
     *  tpl,r0,z0,r_tok,z_tok)


	include 'double.inc'
        dimension r_fil(*),z_fil(*),tok_fil(*)

        include 'parf0'
        include 'parf1'
        include 'parf2'
        include 'parf2e'

	common
     *  /ge1/pi
     *  /eq1e/psext(nwnh),re(nre),ze(nze),dr,dz

	common
     *  /pf1/npf,pf(kf),pf0(kf)

	common
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nr),y(nz),dx,dy
     *  /eq3/FLUXARR(nwnh,kf)
     *  /eq10/vesarr(nwnh,mu)

	common
     *  /ves1/psp(mu),psp0(mu),tcam(mu),tcam0(mu)
     *  /ves2/ncam,rc(mu),zc(mu)

        common
     *  /efil_6/psi_min,psi_max
     *  /efil_10/plasma_coef

        common
     *	/fluxc7/coef,coef1,api

        PSF1(xx,yy)=4.*PI/10.*xx*(aLOG(8.*xx/yy)-2.)


	character*70 apr
71	format(20x,a6/,(6(1pe10.3)))
c=========================================

        if(kpr.eq.1)print *,' nr nz n_fil ncam npf',nr,nz,n_fil,ncam,npf
        if(kpr.eq.1)print *,' tpl r0 z0 ',tpl,r0,z0


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

	PSEXT(kk)=psext(kk)+PSEXT0
	end do
	end do



	apr='tok_fil'
	if(kpr.eq.1)print 71,apr,(tok_fil(i),i=1,n_fil)

	tok=0.d0
	r_tok=0.d0
	z_tok=0.d0

      do ii=1,n_fil
	tok=tok+tok_fil(ii)
	r_tok=r_tok+r_fil(ii)*tok_fil(ii)
	z_tok=z_tok+z_fil(ii)*tok_fil(ii)
	end do

	r_tok=r_tok/tok
	z_tok=z_tok/tok

	if(kpr.eq.1)print *,' r_tok z_tok=',r_tok,z_tok


        dist0=sqrt(dx**2+dy**2)

        ac=dist0
        if(kpr.eq.1)print *,' dist0 ',dist0

	do i=1,nr
	do j=1,nz
C
	kk=(i-1)*nz+j
           pspl(kk)=0.

           fpl=0.
           do ii=1,n_fil
              dist=sqrt( (r_fil(ii)-x(i))**2+(z_fil(ii)-y(j))**2 )

              if(dist.le.dist0)fpl_1=psf1(r_fil(ii),ac)
              if(dist.gt.dist0)fpl_1=fp(r_fil(ii),x(i),z_fil(ii),y(j))
              fpl=fpl+tok_fil(ii)*fpl_1
           end do
              pspl(kk)=fpl
	end do
	end do

	tokc=0.
	DO k=1,ncam
	tokc=tokc+tcam(K)
	END DO

        if(kpr.eq.1)print *,' tokc===',tokc

        psi_max=-1.e9
        psi_min=-psi_max


	do i=1,nr
	do j=1,nz

	kk=(i-1)*nz+j

c        pspl(kk)=0.
        
	psi0=pspl(kk)+psext(kk)

	psi(i,j)=psi0*api

        if(psi(i,j).ge.psi_max)then
           psi_max=psi(i,j)
           imax=i
           jmax=j
        end if

        if(psi(i,j).le.psi_min)then
           psi_min=psi(i,j)
           imin=i
           jmin=j
        end if

        pspl(kk)=pspl(kk)*api

	end do
	end do


	return
	end

	subroutine bound_fil()
	include 'double.inc'
        include 'new_com.inc'

	call bound_fil_c(r_tok,z_tok,del_ramp)


	return
	end

	subroutine bound_fil_c(r_tok,z_tok,del_ramp)
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
     *  /eq1/psi(nr,nz),pspl(nwnh),x(nr),y(nz),dx,dy
     *  /eq1g/psi_g(nr,nz)                                              
     *  /eq6/sinus(ntet),cosin(ntet)
     *  /eq7/tetq(ntet),htq(ntet)


	common
     *	/fluxc1/xp1(50,mu1),yp1(50,mu1)
     *  /fluxc2/delta0,pom(ntet)
     *  /fluxc4/mcurve,x11(mu1),y11(mu1)
     *	/fluxc5/nhalo,xtest(nwnh),ytest(nwnh)
     *	/fluxc6/pmag,pbound,psep,p_s,delaval,dr_h

	common /c_fil_dis1/elong_fil,eu_fil

	dimension ind1(50)
	character *20 apr


71	format(20x,a6/,(6(1pe10.3)))


	aval=psep+del_ramp*(pmag-psep)

	do i0=1,5
	ind1(i0)=0
	end do
c
	dcur=1.e-11*(abs(aval)+1.)
	call fluxcont(nn,mm,PSI,aval,x,y,xp1,yp1,num,ind1,delta0,dcur)
c
	i=1
	mcurve=ind1(i)

	r_out=0.
	z_out=0.

      DO  J=1,mcurve
      x11(J)=xp1(i,j)
      y11(J)=yp1(i,j)

	r_out=r_out+x11(J)
	z_out=z_out+y11(J)

	xtest(j)=x11(J)
	ytest(j)=y11(J)

	end do

	r_out=r_out/mcurve
	z_out=z_out/mcurve

	r_tok=r_out
	z_tok=z_out

	nhalo=mcurve

	if(kpr.eq.1)print *,' mcurve r_out z_out==',mcurve,r_out,z_out

	if(kpr.eq.1)print *,' del_ramp m pi ==',del_ramp,m,pi

	um=r_out
	vm=z_out

c	return

c	call pomin_m(pom,tetq,m,um,vm,x11,y11,mcurve,pi)

	apr='pom'                                                              
c	if(kpr.eq.1)print 71,apr,(pom(j),j=1,m) 

	call pomin_pet_r(pom,tetq,m,um,vm,x11,y11,mcurve,pi)                    
                                                                        
	apr='-pom'                                                              
c	if(kpr.eq.1)print 71,apr,(pom(j),j=1,m) 

	apr='tetq'                                                              
c	if(kpr.eq.1)print 71,apr,(tetq(j),j=1,m) 
       
	                                    
	r_out=0.
	z_out=0.
                                                                        
	do j=2,m-1                                                             
	x11(j)=um+cosin(j)*pom(j)                                           
	y11(j)=vm+sinus(j)*pom(j)                                           
	r_out=r_out+x11(J)
	z_out=z_out+y11(J)
	end do                                                                 
c                                                                       
	jbound=m-1                                                             
	x11(1)=x11(jbound)                                               
	y11(1)=y11(jbound)                                               

	mcurve=jbound

	r_out=r_out/mcurve
	z_out=z_out/mcurve

	if(kpr.eq.1)print *,' mcurve r_out z_out==',mcurve,r_out,z_out

	r_tok=r_out
	z_tok=z_out


	if(kpr.eq.1)print *,' mcurve r_tok z_tok==',mcurve,r_tok,z_tok

	ZMAX=-1.e8
	ZMIN=+1.e8
c
c
	DO J=1,JBOUND
	if(y11(j).ge.zmax)then
	ZMAX=Y11(J)
	rmax=x11(j)
	end if
	if(y11(j).le.zmin)then
	ZMin=y11(J)
	rmin=x11(j)
	end if
	END DO


	xleft=1.e8
	xright=-1.e8
	do j=1,jbound
	xleft=amin1(xleft,x11(j))
	xright=amax1(xright,x11(j))
	end do

	eu_fil=0.5*(xright-xleft)
	bheight=0.5*(zmax-zmin)
	elong_fil=bheight/eu_fil

	if(kpr.eq.1)print *,' eu_fil elong_fil==',eu_fil,elong_fil


	r_tok=0.5*(xright+xleft)
	z_tok=0.5*(zmax+zmin)



	return
	end

	subroutine polar_fil()
	include 'double.inc'
	include 'new_com.inc'

	call polar_fil_c(r_tok,z_tok)

	return
	end

	

	subroutine polar_fil_c(r_tok,z_tok)

	include 'double.inc'
	include 'parf0'
      include 'parf2'
	common
     *	/n_m/n,m,mp
	common
     *	/ge1e/rs0,tpl
     *  /ge5/kpr
	common
     *  /pol1/RO(npo,ntet),AJ(npo,ntet)
     *  /pol4/UM,VM,UK(ntet),VK(ntet)

	common
     *  /fluxc4/mcurve,x11(mu1),y11(mu1)


	dimension ro_help(npo,ntet)


c	if(kpr.eq.1)print *,' call polar_fil== kpr==',kpr
	if(kpr.eq.1)print *,' mcurve mp ',mcurve,mp

      do j=1,mp
	uk(j)=x11(j)
	vk(j)=y11(j)
	end do



        do i=2,n
           do j=1,mp
              ro_help(i,j)=ro(i,j)
           end do
	um_help=um
	vm_help=vm
      end do

	call polar_data()


        do i=2,n
           do j=1,mp
c              ro(i,j)=ro_help(i,j)
           end do
        end do
c	um=um_help
c	vm=vm_help


	if(kpr.eq.1)print *,' um vm==',um,vm

        pt0z=-tpl
        kp=1
	  CALL POLAR1(n,mp,rs0,kp,pt0z)

	if(kpr.eq.1)print *,' um vm --',um,vm
	r_tok=um
	z_tok=vm
	if(kpr.eq.1)print *,' r_tok z_tok --',um,vm



      do i=2,n
       do j=1,mp
              ro(i,j)=ro_help(i,j)
       end do
	um=um_help
	vm=vm_help
      end do

	return
	end




