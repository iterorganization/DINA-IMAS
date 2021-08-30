  	subroutine shape_pf_iam() 
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

	character *20 apr

71	FORMAT(20X,A20/,(6(1X,1PE10.3)))

	dimension a(190)


	if(ntay.le.2)then 
	npf1=npf
	else
	npf1=12
	end if

	i_en=i_en+1
	if(i_en.eq.1)then
	   open (unit=40,file='scr_data',form='formatted')
	   read (40,*,err=1,end=1)

	   n_t=0
	   do j=1,10000
	      read (40,*,err=1,end=1)(a(i),i=1,npf+2)
c	      read (40,*,err=1,end=1)(a(i),i=1,13)

	      n_t=n_t+1

	      t_t(n_t)=a(1)*1.e3
	      tpl_t(n_t)=a(2)*1.e3

	      do k=1,npf
		 pf_t(k,n_t)=a(2+k)*1.e3
	      end do

	      if(kpr.eq.1)
     *             print *,' npf n_t===  ntime== t_t',npf,n_t,ntime,
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
	 
	      do k=1,npf1
		 pf(k)=pf_t(k,i-1)+t_coef*(pf_t(k,i)-pf_t(k,i-1))
c!!!		 pf0(k)=pf(k)
	      end do

		 tpl_p=tpl_t(i-1)+t_coef*(tpl_t(i)-tpl_t(i-1))

c
	   end if

	end do

	if(i_en.eq.1)then
	   do k=1,npf1
	      pf0(k)=pf(k)
	   end do

	   tpl=tpl_p

	end if

	cip1=tpl_p
	
	if(ntay.le.next)tpl=cip1

	if(kpr.eq.1)
     *       print *,' from SHAPE PF tt tpl tpl_p===',tt,tpl,tpl_p

	apr='pf from shape_pf_iam' 
	if(kpr.eq.1)print 71,apr,(pf(i),i=1,npf1) 

c	stop
c        pause 'from shape_pf_iam'

	return
	end

	subroutine volt_feed()
	include 'double.inc'
	include 'new_com.inc'

	call volt_feed_c(
     *  npf,pf,pf0,vchopper)

	return
	end

c

	subroutine volt_feed_c(
     *  npf,pf,pf0,v)

	include 'double.inc'
        common
     *  /ge5/kpr

	dimension pf(*),pf0(*),v(*)
	character *20 apr
c--
           apr='-pf-' 
           if(kpr.eq.1)print 71,apr,(pf(i),i=1,npf) 
	
	do i=1,npf
	   v_c=10.*(pf(i)-pf0(i))
	   v(i)=v_c
	   pf(i)=pf0(i)
	end do

           apr='-pf0-' 
           if(kpr.eq.1)print 71,apr,(pf0(i),i=1,npf) 

           apr='-v-' 
           if(kpr.eq.1)print 71,apr,(v(i),i=1,npf) 


71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

	return
	end
	subroutine ip_it_feed()
	include 'double.inc'
	include 'new_com.inc'

	call ip_it_feed_c(
     *  npf,pf,pf0,tpl,cip1,plasma,pll)

	return
	end

c

	subroutine ip_it_feed_c(
     *  npf,pf,pf0,tpl,cip1,plasma,pll)

	include 'double.inc'
        common
     *  /ge5/kpr

	dimension pf(*),pf0(*),plasma(*)

	character *20 apr
c--

cccccc	pf_ind=(plasma(8)+plasma(9))/(2.*tpl)
	pf_ind=plasma(9)/tpl
c888	pf_ind=plasma(8)/tpl

cccccc	d_pf=0.25*(tpl-cip1)/pf_ind*pll
	d_pf9=0.25*(tpl-cip1)/pf_ind*pll
c888	d_pf8=0.25*(tpl-cip1)/pf_ind*pll

c	if(d_pf9.gt.0.)d_pf9=0.

cccccc	pf(9)=pf0(9)+0.5*d_pf
	pf(9)=pf0(9)+0.5*d_pf9
	pf(10)=pf(9)
cccccc	pf(8)=pf0(8)+0.2*d_pf
cccccc	pf(11)=pf(8)

	if(kpr.eq.1)print *,' pf_ind pll cip1 tpl ',pf_ind,pll,cip1,tpl
	if(kpr.eq.1)print *,' d_pf9 pf(9) pf0(9) ',d_pf9,pf(9),pf0(9)

c	read (*,*)

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

	return
	end

	subroutine ip_feed()
	include 'double.inc'
	include 'new_com.inc'

	call ip_feed_c(
     *  npf,pf,pf0,tpl,cip1,plasma,pll)

	return
	end

c

	subroutine ip_feed_c(
     *  npf,pf,pf0,tpl,cip1,plasma,pll)

	include 'double.inc'
        common
     *  /ge5/kpr

	dimension pf(*),pf0(*),plasma(*)

	character *20 apr
c--

	pf_ind=plasma(6)/tpl

	d_pf6=0.2*(tpl-cip1)/pf_ind*pll

	pf(6)=pf0(6)+d_pf6

	if(kpr.eq.1)print *,' pf_ind pll ',pf_ind,pll
	if(kpr.eq.1)print *,' d_pf6 pf(6) pf0(6) ',d_pf6,pf(6),pf0(6)

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

	return
	end


	subroutine r_feed()
	include 'double.inc'
	include 'new_com.inc'

	call r_feed_c(
     *  npf,pf,pf0,rmag,rmag0,rref_p,vchopper,tay)

	return
	end

c

	subroutine r_feed_c(
     *  npf,pf,pf0,rmag,rmag0,rref_p,v,tay)

	include 'double.inc'
        common
     *  /ge5/kpr


	dimension pf(*),pf0(*),v(*)
	character *20 apr
c--
        vel=(rmag-rmag0)/tay


c	v_c=-100.*((rmag-rref_p)+5.*vel)
	v_c=-10.*(rmag-rref_p)

c	v(15)=v_c
c	v(16)=v(15)
	v(3)=v_c
	v(4)=v(3)

c--
	if(kpr.eq.1)print *,' v_r vel  rmag rref ',v_c,vel,rmag,rref_p

           apr='-pf-' 
c           if(kpr.eq.1)print 71,apr,(pf(i),i=1,npf) 
           apr='-pf0-' 
c           if(kpr.eq.1)print 71,apr,(pf0(i),i=1,npf) 
           apr='-v-' 
c           if(kpr.eq.1)print 71,apr,(v(i),i=1,npf) 


71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

	return
	end
      subroutine z_feed()
	include 'double.inc'
      include 'new_com.inc'

      call z_feed_c(
     *     vchopper,zmag,zref,pf,zmag0,tay)

      return
      end

      subroutine z_feed_c(
     *     vchopper,zmag,zref,pf,zmag0,tay)

	include 'double.inc'
        common
     *  /ge5/kpr



      dimension vchopper(*),pf(*)


      i_en=i_en+1
      if(i_en.eq.1)then
         open (unit=41, file='v_feed.dat',form='formatted')
         read (41,*)
         read (41,*)i_up,i_dw,zref_in
         read (41,*)
         read (41,*)v_max,pw_max
         read (41,*)
         read (41,*)p_feed,tay_feed

	 if(kpr.eq.1)
     *        print *,' i_up i_dw v_max pw_max ',i_up,i_dw,v_max,pw_max
	 if(kpr.eq.1)print *,' p_feed tay_feed ',p_feed,tay_feed

         close (41)

      end if

	i=i_up
        vel=(zmag-zmag0)/tay
	vchopper(i)=-v_max*p_feed*((zmag-zref)+tay_feed*vel)

	if(abs(vchopper(i)).ge.v_max)vchopper(i)=v_max*vchopper(i)/
     *       abs(vchopper(i))

        pw=vchopper(i)*pf(i)*1.e-3

	if(kpr.eq.1)print *,' i_up v_up pw',i_up,vchopper(i),pw

	i=i_dw

	vchopper(i)=v_max*p_feed*((zmag-zref)+tay_feed*vel)

	if(abs(vchopper(i)).ge.v_max)vchopper(i)=v_max*vchopper(i)/
     *       abs(vchopper(i))

        pw=vchopper(i)*pf(i)*1.e-3

	if(kpr.eq.1)print *,'  i_dw v_dw pw',i_dw,vchopper(i),pw

	if(kpr.eq.1)print *,' zmag zref vel',zmag,zref,vel
        if(kpr.eq.1)print*,'ntay=',ntay

      return
      end
	subroutine v_f()
	include 'double.inc'
	include 'new_com.inc'

	call v_f_c(
     *  npf,pf,pf0,rout,rref_p,vchopper)

	return
	end

c

	subroutine v_f_c(
     *  npf,pf,pf0,rout,rref_p,v)

	include 'double.inc'
        common
     *  /ge5/kpr


	dimension pf(*),pf0(*),v(*)
	character *20 apr
c--

	do i=1,npf
	   v(i)=1.*(pf(i)-pf0(i))
	end do

           apr='-pf-' 
           if(kpr.eq.1)print 71,apr,(pf(i),i=1,npf) 
           apr='-pf0-' 
           if(kpr.eq.1)print 71,apr,(pf0(i),i=1,npf) 
           apr='-v-' 
           if(kpr.eq.1)print 71,apr,(v(i),i=1,npf) 


71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

	return
	end

	subroutine v_r()
	include 'double.inc'
	include 'new_com.inc'

	call v_r_c(
     *  npf,pf,pf0,rmag,rref_p,vchopper)

	return
	end

c

	subroutine v_r_c(
     *  npf,pf,pf0,rout,rref_p,v)

	include 'double.inc'
        common
     *  /ge5/kpr


	dimension pf(*),pf0(*),v(*)
	character *20 apr
c--
	v_c=-5.*(rout-rref_p)

c	if(abs(v_c).gt.100.)v_c=1000.*v_c/abs(v_c)


	v(4)=v_c

c!!!	v(10)=v(4)

	
c--
	if(kpr.eq.1)
     *  print *,' v_r pf4 pf04  rout rref ',v_c,pf(4),pf0(4),rout,rref_p

           apr='-pf-' 
           if(kpr.eq.1)print 71,apr,(pf(i),i=1,npf) 
           apr='-pf0-' 
           if(kpr.eq.1)print 71,apr,(pf0(i),i=1,npf) 
           apr='-v-' 
           if(kpr.eq.1)print 71,apr,(v(i),i=1,npf) 


71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

	return
	end

	subroutine v_act()
	include 'double.inc'
	include 'new_com.inc'

	call v_act_c(
     *  pf,pf0,zmag,pfind(3,3),tay)

	return
	end

c

	subroutine v_act_c(
     *  pf,pf0,zmag,pfind,tay)

	include 'double.inc'
        common
     *  /ge5/kpr


	dimension pf(*),pf0(*)
c--
	v_c=-1000.*(zmag-0.)

c	if(abs(v_c).gt.1000.)v_c=1000.*v_c/abs(v_c)


	pf(3)=pf0(3)+v_c*100.*tay/pfind
	pf(9)=pf0(9)-v_c*100.*tay/pfind
	
c--
	if(kpr.eq.1)
     *       print *,' v_c pf3 pf03  zmag ',v_c,pf(3),pf0(3),zmag



	return
	end

	subroutine den_read()
	include 'double.inc'
	include 'new_com.inc'

	call den_read_c(
     *  tt,pcchp,ntay,tay)
	
	return
	end

	subroutine den_read_c(
     *  tt,pcchp,ntay,tay)

	include 'double.inc'
 	include 'parf_mike' 

        common
     *  /ge5/kpr

	dimension t_t(ntime),den_t(ntime)


	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='dens.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 

 	 if(kpr.eq.1)print *,' tay tt n_t===',tay,tt,n_t 

           do i=1,n_t 
              read (41,*)t_t(i),den_t(i)
              t_t(i)=t_t(i)*1000. 
           end do 
           
           apr='-t_t-' 
           if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 

           apr='-den_t-' 
           if(kpr.eq.1)print 71,apr,(den_t(i),i=1,n_t) 

           close (unit=41) 
        end if

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

	   if(ntay.le.2)then
c*vic!!!	      den_t(1)=pcchp
!!!	      t_t(1)=tt-tay
	   end if


           apr='-den_t22' 
           if(kpr.eq.1)print 71,apr,(den_t(i),i=1,n_t) 


      do i=2,n_t
      if( (tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
	 t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )

	 den=den_t(i-1)+t_coef*(den_t(i)-den_t(i-1))
c
	 end if

	 end do

!	   if(ntay.gt.2)pcchp=den

	pcchp=den

c	if(kpr.eq.1)print *,' from den_read  pcchp den ntay',pcchp,den,ntay
c	pause 'from den_read'


       return 
       end 

	subroutine pw_p_read()
	include 'double.inc'
	include 'new_com.inc'

	call pw_p_read_c(
     *  tt,pw_p)
	
	return
	end

	subroutine pw_p_read_c(
     *  tt,pw_p)

	include 'double.inc'
 	include 'parf_mike' 

        common
     *  /ge5/kpr

	dimension t_t(ntime),pw_p_t(ntime)


	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='pw_p.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 

           do i=1,n_t 
              read (41,*)t_t(i),pw_p_t(i)
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

	 pw_p=pw_p_t(i-1)+t_coef*(pw_p_t(i)-pw_p_t(i-1))
c
	 end if

	 end do

	if(kpr.eq.1)print *,' from pw_p_read',pw_p

       return 
       end 

	subroutine pw_e_read()
	include 'double.inc'
	include 'new_com.inc'

	call pw_e_read_c(
     *  tt,pw_e)
	
	return
	end

	subroutine pw_e_read_c(
     *  tt,pw_e)

	include 'double.inc'
 	include 'parf_mike' 

        common
     *  /ge5/kpr

	dimension t_t(ntime),pw_e_t(ntime)


	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='pw_e.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 

           do i=1,n_t 
              read (41,*)t_t(i),pw_e_t(i)
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

	 pw_e=pw_e_t(i-1)+t_coef*(pw_e_t(i)-pw_e_t(i-1))
c
	 end if

	 end do

	if(kpr.eq.1)print *,' from pw_e_read',pw_e

       return 
       end 


	subroutine te_b_read()
	include 'double.inc'
	include 'new_com.inc'

	call te_b_read_c(
     *  tt,te_b)
	
	return
	end

	subroutine te_b_read_c(
     *  tt,te_b)

	include 'double.inc'
 	include 'parf_mike' 

        common
     *  /ge5/kpr

	dimension t_t(ntime),te_b_t(ntime)


	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='te_b.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 

           do i=1,n_t 
              read (41,*)t_t(i),te_b_t(i)
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

	 te_b=te_b_t(i-1)+t_coef*(te_b_t(i)-te_b_t(i-1))
c
	 end if

	 end do

	if(kpr.eq.1)print *,' from te_b_read',te_b

       return 
       end 

	subroutine te_a_read()
	include 'double.inc'
	include 'new_com.inc'

	call te_a_read_c(
     *  tt,te_a)
	
	return
	end

	subroutine te_a_read_c(
     *  tt,te_a)

	include 'double.inc'
 	include 'parf_mike' 

        common
     *  /ge5/kpr

	dimension t_t(ntime),te_a_t(ntime)


	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='te_a.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 

           do i=1,n_t 
              read (41,*)t_t(i),te_a_t(i)
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

	 te_a=te_a_t(i-1)+t_coef*(te_a_t(i)-te_a_t(i-1))
c
	 end if

	 end do

	if(kpr.eq.1)print *,' from te_a_read',te_a

       return 
       end 

	subroutine pd0_b_read()
	include 'double.inc'
	include 'new_com.inc'

	call pd0_b_read_c(
     *  tt,pd0_b,ntay)
	
	return
	end

	subroutine pd0_b_read_c(
     *  tt,pd0_b,ntay)

	include 'double.inc'
 	include 'parf_mike' 

        common
     *  /ge5/kpr

	dimension t_t(ntime),pd0_b_t(ntime)


	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='pd0_b.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 

           do i=1,n_t 
              read (41,*)t_t(i),pd0_b_t(i)
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

	 pd0_bc=pd0_b_t(i-1)+t_coef*(pd0_b_t(i)-pd0_b_t(i-1))
c
	 end if

	 end do

	 pd0_b=pd0_bc

	if(kpr.eq.1)print *,' from pd0_b_read  ntay',pd0_b,ntay


       return 
       end 

	subroutine pd0_a_read()
	include 'double.inc'
	include 'new_com.inc'

	call pd0_a_read_c(
     *  tt,pd0_a,ntay)
	
	return
	end

	subroutine pd0_a_read_c(
     *  tt,pd0_a,ntay)

	include 'double.inc'
 	include 'parf_mike' 

        common
     *  /ge5/kpr

	dimension t_t(ntime),pd0_a_t(ntime)


	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='pd0_a.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 

           do i=1,n_t 
              read (41,*)t_t(i),pd0_a_t(i)
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

	 pd0_ac=pd0_a_t(i-1)+t_coef*(pd0_a_t(i)-pd0_a_t(i-1))
c
	 end if

	 end do

	   pd0_a=pd0_ac

	if(kpr.eq.1)print *,' from pd0_a_read  ntay',pd0_a,ntay

       return 
       end 

	function t_inter( tt,time_1,time_2,
     *  ps1,ps2 )
	include 'double.inc'
	if(abs(time_1-time_2).lt.1.e-5)then
	t_inter=0.5*(ps2+ps1)
	return
	end if
c
	t_inter=ps1+(tt-time_1)*(ps2-ps1)/(time_2-time_1)

	return
	end

	subroutine v_feed()
	include 'double.inc'
	include 'parf1'
	common
     *	/con1/gain,ta,zref,kzref
     *  /con2/rref,krref,bvert
	common
     *  /cont1/vchopper(kf),veps
     *  /cont13/zmag,zvel,delrmag,delzmag
     *  /cont13e/zmag0,rmag,rmag0,rvel
	common
     *	/efit6/tpl_p
	common
     *	/ge1e/rs0,tpl
     *  /ge2/NTAY,TAY,TT
        common
     *  /ge5/kpr

	common
     *  /keys5/next
     *  /keys17/i_feed,i_ecoil
c
	if(i_feed.eq.1)then
	do ii=1,2
	if(ii.eq.1)k=6
	if(ii.eq.2)k=15
c--
	v_c=-300.*(rmag-rref)
	if(abs(v_c).gt.1000.)v_c=1000.*v_c/abs(v_c)
	vchopper(k)=v_c
c--
	if(kpr.eq.1)
     *       print *,' k vchopper(k) rmag rref',k,vchopper(k),rmag,rref
	end do
	end if
	return
	end
	subroutine v_ec()
	include 'double.inc'
	include 'parf1'
	common
     *	/con1/gain,ta,zref,kzref
     *  /con2/rref,krref,bvert
	common
     *  /cont1/vchopper(kf),veps
     *  /cont13/zmag,zvel,delrmag,delzmag
     *  /cont13e/zmag0,rmag,rmag0,rvel
	common
     *	/efit6/tpl_p
	common
     *	/ge1e/rs0,tpl
     *  /ge2/NTAY,TAY,TT
        common
     *  /ge5/kpr

	common
     *  /keys5/next
     *  /keys17/i_feed,i_ecoil
c
	if(i_ecoil.eq.1)then
	if(ntay.lt.next)tpl_p=tpl

	do ii=1,2
	if(ii.eq.1)then
	k=19
	v_c=100.*(tpl-tpl_p)
	if(abs(v_c).gt.300.)v_c=300.*v_c/abs(v_c)
	vchopper(k)=v_c
	end if
	if(ii.eq.2)then
	k=20
	v_c=-0.02*(tpl-tpl_p)
	if(abs(v_c).gt.0.1)v_c=0.1*v_c/abs(v_c)
c	vchopper(k)=v_c

	end if
	if(kpr.eq.1)print *,' k vchopper(k) tpl tpl_p',k,v_c,tpl,tpl_p
	end do
	end if

	return
	end

	subroutine prog_val()
	include 'double.inc'
	include 'parf1'
	include 'parf9'
	common
     *  /con2/rref,krref,bvert
     *  /con4/tt_exp(ntime),r0_exp(ntime),pf_exp(kf,ntime)
     *  /con5/n_exp,k_cont
	common
     *  /ge2/NTAY,TAY,TT
     *  /ge5/kpr
	common
     *  /pf1/npf,pf(kf),pf0(kf)

	character *8 apr
c---------------------------------
	CHARACTER*120 fshot,tmp
c
	if(ntay.eq.0)then
	open (unit=40,file='shot.fl',form='formatted')
	read (40,*)
	read (40,74)fshot
74	format(a110)
	if(kpr.eq.1)print *,' ----  ',fshot
	close (40)

     	open(unit=40,file=fshot,form='formatted')
	read (40,*)
	read (40,*)n_exp
	if(kpr.eq.1)print *,' n_exp=====',n_exp
	read (40,*)
	read (40,*)(tt_exp(i),i=1,n_exp)
	if(kpr.eq.1)print *,' tt_exp====='
	read (40,*)
	read (40,*)(r0_exp(i),i=1,n_exp)
	if(kpr.eq.1)print *,' r0_exp====='
	do ii=1,4

	if(ii.eq.1)k=4

	if(ii.eq.2)k=5

c	if(ii.eq.3)k=6

	if(ii.eq.3)k=9

	if(ii.eq.4)k=8

	read (40,*)
	read (40,*)(pf_exp(k,i),i=1,n_exp)
	if(kpr.eq.1)print *,' ii pf_exp=====',ii
	end do
c
	close (40)
	end if
c------------------------------------

	do i=2,n_exp
        if( (tt-tt_exp(i-1))*(tt-tt_exp(i)).le.0.)then
c==================
	 t_coef=(tt-tt_exp(i-1))/( tt_exp(i)-tt_exp(i-1) )
c=================
c   ---- rref ----
	 rref=r0_exp(i-1)+t_coef*(r0_exp(i)-r0_exp(i-1))

	if(kpr.eq.1)
     *        print *,' tt tt_exp1 tt_exp_2',tt,tt_exp(i-1),tt_exp(i)
	if(kpr.eq.1)print *,' rref from SHAPE',rref

	do ii=1,4
	if(ii.eq.1)k=4
	if(ii.eq.2)k=5
	if(ii.eq.3)k=9
	if(ii.eq.4)k=8

	pf(k)=pf_exp(k,i-1)+t_coef*(pf_exp(k,i)-pf_exp(k,i-1))
	pf(k+9)=pf(k)
	if(kpr.eq.1)print *,' k pf ',k,pf(k)
	end do
	end if
	end do

	return
	end
	subroutine den_read_t()
	include 'double.inc'
	include 'new_com.inc'

	call den_read_t_c(
     *  tt,pt0_p,ntay,tay)
	
	return
	end

	subroutine den_read_t_c(
     *  tt,pcchp,ntay,tay)

	include 'double.inc'
 	include 'parf_mike' 

        common
     *  /ge5/kpr

	dimension t_t(ntime),den_t(ntime)


	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='dens.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 

 	 if(kpr.eq.1)print *,' tay tt n_t===',tay,tt,n_t 

           do i=1,n_t 
              read (41,*)t_t(i),den_t(i)
              t_t(i)=t_t(i)*1000. 
           end do 
           
           apr='-t_t-' 
           if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 

           apr='-den_t-' 
           if(kpr.eq.1)print 71,apr,(den_t(i),i=1,n_t) 

           close (unit=41) 
        end if

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

	   if(ntay.le.2)then
c*vic!!!	      den_t(1)=pcchp
!!!	      t_t(1)=tt-tay
	   end if


           apr='-den_t22' 
           if(kpr.eq.1)print 71,apr,(den_t(i),i=1,n_t) 


      do i=2,n_t
      if( (tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
	 t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )

	 den=den_t(i-1)+t_coef*(den_t(i)-den_t(i-1))
c
	 end if

	 end do

!	   if(ntay.gt.2)pcchp=den

	pcchp=den

c	if(kpr.eq.1)print *,' from den_read  pcchp den ntay',pcchp,den,ntay
c	pause 'from den_read'


       return 
       end 

