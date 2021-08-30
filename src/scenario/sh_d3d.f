  	subroutine s_zpp() 
	include 'double.inc'
	include 'new_com.inc'

  	call s_zpp_c(
     *  zref,tt) 

	return
	end

  	subroutine s_zpp_c(
     *  zref_p,tt) 

	include 'double.inc'
        common
     *  /ge5/kpr

 	include 'parf_mike' 

	dimension t_t(ntime),zp_t(ntime)

	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='zpp.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 
	k=0
      do i=1,99999
	k=k+1
              read (41,*,err=2000,end=2000)t_t(i),zp_t(i)
              t_t(i)=t_t(i)*1000. 
                n_t=k
           end do 

2000	continue
           
 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 

       close (unit=41) 

        end if
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

      do i=2,n_t
      if( (tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
	 t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )

	 zref_p=zp_t(i-1)+t_coef*(zp_t(i)-zp_t(i-1))

c
	 end if

	 end do

 	if(kpr.eq.1)print *,' from SHAPE ZPP tt zref_p',tt,zref_p

       return 
       end 

	subroutine w_filter(wen2_xx)
	include 'double.inc'
	include 'new_com.inc'

	call w_filter_c(
     *  wen2_xx,ntay,tay,tt)

	return
	end

	subroutine w_filter_c(
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

!	taup=5.*tay
	taup=20.*tay

	qqp = 0.5 * (time - time1)/taup

	f9af =(qqp * (f9a + e1) - (qqp - 1.0) * v1) / (qqp + 1.0)


	wen2=f9af


	return
	end

  	subroutine shape_fc() 
	include 'double.inc'
 	include 'parf1' 
 	parameter ( NPFC=KF-4) 

 	include 'parf_mike' 

c 	parameter (ntime=20)
 
	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /ge2/ntay,tay,tt
        common
     *  /ge5/kpr


	dimension t_t(ntime),pf_t(kf,ntime)

	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='fc.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 
           read (41,*) 

           do i=1,n_t 
              read (41,*)t_t(i),(pf_t(k,i),k=1,18)
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
	 
	 do k=1,npfc
	    pf(k)=pf_t(k,i-1)+t_coef*(pf_t(k,i)-pf_t(k,i-1))
	 end do

c
	 end if

	 end do
	if(kpr.eq.1)print *,' from SHAPE 67',pf(6),pf(7),pf(6+9),pf(7+9)

       return 
       end 

  	subroutine shape_fcomm() 
	include 'double.inc'
 	include 'parf1' 
 	parameter ( NPFC=KF-4) 

 	include 'parf_mike' 

c 	parameter (ntime=20)
 
	common
     *  /ge2/ntay,tay,tt
        common
     *  /ge5/kpr

	common
     *  /CONT5/	FCOM(NPFC)

 	dimension t_t(ntime),fcom_t(npfc,ntime) 
 	character *12 apr 

 	i_sh=i_sh+1 
 	if(i_sh.eq.1)then 
           open (unit=41,file='fcommand.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 
           
           do i=1,n_t 
              read (41,*)t_t(i),(fcom_t(j,i),j=1,npfc) 
              t_t(i)=t_t(i)*1000. 
           end do 
           
           apr='-t_t-' 
c           if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 
           close (unit=41) 
        end if


 71	FORMAT(20X,A8/,(6(1X,1PE10.3))) 

 	do i=2,n_t 

 	if( (tt-t_t(i-1))*(tt-t_t(i)).le.0.)then 
 	   t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) ) 

 	   do j=1,npfc 
	   fcom(j) =fcom_t(j,i-1)+t_coef*(fcom_t(j,i)-fcom_t(j,i-1))
 	   end do 

 	end if 
 	end do 

 	apr='-fcom-' 
 	if(kpr.eq.1)print 71,apr,(fcom(j),j=1,npfc) 

       return 
       end 

  	subroutine shape_rpp() 
	include 'double.inc'
	include 'new_com.inc'

  	call shape_rpp_c(
!     *  rref_p,tt) 
     *  rref,tt) 

	return
	end

  	subroutine shape_rpp_c(
     *  rref_p,tt) 

	include 'double.inc'
        common
     *  /ge5/kpr

 	include 'parf_mike' 

	dimension t_t(ntime),rp_t(ntime)

	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
c-------
           open (unit=41,file='rpp.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 


	k=0
      do i=1,99999
	k=k+1
              read (41,*,err=2000,end=2000)t_t(i),rp_t(i)
              t_t(i)=t_t(i)*1000. 
                n_t=k
           end do 

2000	continue
           
 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 

           apr='-t_t-' 
c           print 71,apr,(t_t(i),i=1,n_t) 
           close (unit=41) 
        end if
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

      do i=2,n_t
      if( (tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
	 t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )

	 rpp=rp_t(i-1)+t_coef*(rp_t(i)-rp_t(i-1))

c
	 end if

	 end do
	 
	 rref_p=rpp


 	if(kpr.eq.1)print *,' from SHAPE RPP rref_p',rref_p

       return 
       end 


  	subroutine shape_udd() 
	include 'double.inc'
	include 'new_com.inc'

  	call shape_udd_c(
!     *  rref_p,tt) 
     *  udd,tt) 

	return
	end

  	subroutine shape_udd_c(
     *  udd,tt) 

	include 'double.inc'
        common
     *  /ge5/kpr

 	include 'parf_mike' 

	dimension t_t(ntime),rp_t(ntime)

	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
c-------
           open (unit=41,file='udd.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 


	k=0
      do i=1,99999
	k=k+1
              read (41,*,err=2000,end=2000)t_t(i),rp_t(i)
              t_t(i)=t_t(i)*1000. 
                n_t=k
           end do 

2000	continue
           
 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 

           apr='-t_t-' 
c           print 71,apr,(t_t(i),i=1,n_t) 
           close (unit=41) 
        end if
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

      do i=2,n_t
      if( (tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
	 t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )

	 rpp=rp_t(i-1)+t_coef*(rp_t(i)-rp_t(i-1))

c
	 end if

	 end do
	 
	 udd=rpp


 	if(kpr.eq.1)print *,' from SHAPE udd',udd

       return 
       end 


  	subroutine shape_1() 
	include 'double.inc'
 	include 'parf1' 
 	parameter ( NPFC=KF-4) 

 	include 'parf_mike' 

c 	parameter (ntime=20)
 
	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /ge2/ntay,tay,tt
        common
     *  /ge5/kpr


	dimension t_t(ntime),pf_t(ntime)

	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='1.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 
           read (41,*) 

           do i=1,n_t 
              read (41,*)t_t(i),pf_t(i)
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

	 pf(1)=pf_t(i-1)+t_coef*(pf_t(i)-pf_t(i-1))
c
	 end if

	 end do
	if(kpr.eq.1)print *,' from SHAPE 1',pf(1)

       return 
       end 

  	subroutine shape_2() 
	include 'double.inc'
 	include 'parf1' 
 	parameter ( NPFC=KF-4) 

 	include 'parf_mike' 

c 	parameter (ntime=20)
 
	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /ge2/ntay,tay,tt
        common
     *  /ge5/kpr


	dimension t_t(ntime),pf_t(ntime)

	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='2.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 
           read (41,*) 

           do i=1,n_t 
              read (41,*)t_t(i),pf_t(i)
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

	 pf(2)=pf_t(i-1)+t_coef*(pf_t(i)-pf_t(i-1))
c
	 end if

	 end do
	if(kpr.eq.1)print *,' from SHAPE 2',pf(2)

       return 
       end 

  	subroutine shape_3() 
	include 'double.inc'
 	include 'parf1' 
 	parameter ( NPFC=KF-4) 

 	include 'parf_mike' 

c 	parameter (ntime=20)
 
	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /ge2/ntay,tay,tt
        common
     *  /ge5/kpr


	dimension t_t(ntime),pf_t(ntime)

	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='3.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 
           read (41,*) 

           do i=1,n_t 
              read (41,*)t_t(i),pf_t(i)
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

	 pf(3)=pf_t(i-1)+t_coef*(pf_t(i)-pf_t(i-1))
c
	 end if

	 end do
	if(kpr.eq.1)print *,' from SHAPE 3',pf(3)

       return 
       end 

  	subroutine shape_4() 
	include 'double.inc'
 	include 'parf1' 
 	parameter ( NPFC=KF-4) 

 	include 'parf_mike' 

c 	parameter (ntime=20)
 
	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /ge2/ntay,tay,tt
        common
     *  /ge5/kpr


	dimension t_t(ntime),pf_t(ntime)

	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='4.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 
           read (41,*) 

           do i=1,n_t 
              read (41,*)t_t(i),pf_t(i)
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

	 pf(4)=pf_t(i-1)+t_coef*(pf_t(i)-pf_t(i-1))
c
	 end if

	 end do
	if(kpr.eq.1)print *,' from SHAPE 4',pf(4)

       return 
       end 
  	subroutine shape_5() 
	include 'double.inc'
 	include 'parf1' 
 	parameter ( NPFC=KF-4) 

 	include 'parf_mike' 

c 	parameter (ntime=20)
 
	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /ge2/ntay,tay,tt
        common
     *  /ge5/kpr


	dimension t_t(ntime),pf_t(ntime)

	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='5.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 
           read (41,*) 

           do i=1,n_t 
              read (41,*)t_t(i),pf_t(i)
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

	 pf(5)=pf_t(i-1)+t_coef*(pf_t(i)-pf_t(i-1))

c
	 end if

	 end do
	if(kpr.eq.1)print *,' from SHAPE 5',pf(5)

       return 
       end 
  	subroutine shape_6() 
	include 'double.inc'
 	include 'parf1' 
 	parameter ( NPFC=KF-4) 

 	include 'parf_mike' 

c 	parameter (ntime=20)
 
	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /ge2/ntay,tay,tt
        common
     *  /ge5/kpr


	dimension t_t(ntime),pf_t(ntime)

	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='6.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 
           read (41,*) 

           do i=1,n_t 
              read (41,*)t_t(i),pf_t(i)
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

	 pf(6)=pf_t(i-1)+t_coef*(pf_t(i)-pf_t(i-1))

c
	 end if

	 end do
	if(kpr.eq.1)print *,' from SHAPE 6',pf(6)

       return 
       end 
  	subroutine shape_7() 
	include 'double.inc'
 	include 'parf1' 
 	parameter ( NPFC=KF-4) 

 	include 'parf_mike' 

c 	parameter (ntime=20)
 
	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /ge2/ntay,tay,tt
        common
     *  /ge5/kpr


	dimension t_t(ntime),pf_t(ntime)

	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='7.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 
           read (41,*) 

           do i=1,n_t 
              read (41,*)t_t(i),pf_t(i)
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

	 pf(7)=pf_t(i-1)+t_coef*(pf_t(i)-pf_t(i-1))

c
	 end if

	 end do
	if(kpr.eq.1)print *,' from SHAPE 7',pf(7)

       return 
       end 
  	subroutine shape_8() 
	include 'double.inc'
 	include 'parf1' 
 	parameter ( NPFC=KF-4) 

 	include 'parf_mike' 

c 	parameter (ntime=20)
 
	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /ge2/ntay,tay,tt
        common
     *  /ge5/kpr


	dimension t_t(ntime),pf_t(ntime)

	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='8.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 
           read (41,*) 

           do i=1,n_t 
              read (41,*)t_t(i),pf_t(i)
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

	 pf(8)=pf_t(i-1)+t_coef*(pf_t(i)-pf_t(i-1))

c
	 end if

	 end do
	if(kpr.eq.1)print *,' from SHAPE 8',pf(8)

       return 
       end 

  	subroutine shape_9() 
	include 'double.inc'
 	include 'parf1' 
 	parameter ( NPFC=KF-4) 

 	include 'parf_mike' 

c 	parameter (ntime=20)
 
	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /ge2/ntay,tay,tt
        common
     *  /ge5/kpr


	dimension t_t(ntime),pf_t(ntime)

	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='9.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 
           read (41,*) 

           do i=1,n_t 
              read (41,*)t_t(i),pf_t(i)
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

	 pf(9)=pf_t(i-1)+t_coef*(pf_t(i)-pf_t(i-1))

c
	 end if

	 end do
	if(kpr.eq.1)print *,' from SHAPE 9',pf(9)

       return 
       end 

  	subroutine shape_10() 
	include 'double.inc'
 	include 'parf1' 
 	parameter ( NPFC=KF-4) 

 	include 'parf_mike' 

c 	parameter (ntime=20)
 
	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /ge2/ntay,tay,tt
        common
     *  /ge5/kpr


	dimension t_t(ntime),pf_t(ntime)

	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='10.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 
           read (41,*) 

           do i=1,n_t 
              read (41,*)t_t(i),pf_t(i)
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

	 pf(10)=pf_t(i-1)+t_coef*(pf_t(i)-pf_t(i-1))
c
	 end if

	 end do
	if(kpr.eq.1)print *,' from SHAPE 10',pf(10)

       return 
       end 

  	subroutine shape_11() 
	include 'double.inc'
 	include 'parf1' 
 	parameter ( NPFC=KF-4) 

 	include 'parf_mike' 

c 	parameter (ntime=20)
 
	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /ge2/ntay,tay,tt
        common
     *  /ge5/kpr


	dimension t_t(ntime),pf_t(ntime)

	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='11.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 
           read (41,*) 

           do i=1,n_t 
              read (41,*)t_t(i),pf_t(i)
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

	 pf(11)=pf_t(i-1)+t_coef*(pf_t(i)-pf_t(i-1))
c
	 end if

	 end do
	if(kpr.eq.1)print *,' from SHAPE 11',pf(11)

       return 
       end 


	subroutine eps_filter()
	include 'double.inc'
	include 'new_com.inc'

	call eps_filter_c(veps,taup)

	return
	end

	subroutine eps_filter_c(veps,taup)

	include 'double.inc'
	common
     *  /ge2/ntay,tay,tt
        common
     *  /ge5/kpr


        i_en=i_en+1

	time=tt

	f9a=veps

	if(i_en.eq.1)then

           e1 = f9a
           f9af=e1
           v1 = f9af
           time1 = time
        end if

	if(taup.lt.0.)return


c	qqp = 0.5 * 5.0e-5 * (time - time1)*1.e3

c!!!	qqp = 0.5 * 5.0e-2 * (time - time1)
c    ;  /* 1/taup = 1/20.0e3 = 5.0e-5 */
c	qqp = 0.5 * 5.0e-2 * (time - time1)

c    ;  /* 1/taup = 1/20.0 = 5.0e-2 */
c    ;  /* 1/taup = 1/0.5 = 2. */

c--------------------
	qqp = 0.5 *(time - time1)/taup
c--------------------

c    ;  /* 1/taup = 1/1. = 1. */

	f9af =(qqp * (f9a + e1) - (qqp - 1.0) * v1) / (qqp + 1.0)

	if(kpr.eq.1)print *,' eps - tt  f9a f9af----',tt,f9a,f9af

	veps=f9af


c  saving for the next time_step...

	e1 = f9a
	
	v1 = f9af
	
	time1 = time

	return
	end

  	subroutine shape_eps()

	include 'double.inc'

	include 'new_com.inc'

  	call shape_eps_c(v_out) 


	return
	end


 
  	subroutine shape_eps_c(v_out) 

	include 'double.inc'
 	parameter (ntime=6000)
 	include 'parf1' 

 	common
     *  /ge2/ntay,tay,tt
        common
     *  /ge5/kpr


	dimension t_t(ntime),eps_t(ntime)

	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='epsvolts.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 
           read (41,*) 

           do i=1,n_t 
              read (41,*)t_t(i),eps_t(i)
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

	 v_out=eps_t(i-1)+t_coef*(eps_t(i)-eps_t(i-1))

c
	 end if

	 end do
	if(kpr.eq.1)print *,' from SHAPE EPS',v_out

       return 
       end 

  	subroutine shape_39() 
	include 'double.inc'
 	include 'parf1' 
 	parameter ( NPFC=KF-4) 

 	include 'parf_mike' 

c 	parameter (ntime=20)
 
	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /ge2/ntay,tay,tt
        common
     *  /ge5/kpr


	dimension t_t(ntime),pf_t(kf,ntime)

	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='39.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 
           read (41,*) 

           do i=1,n_t 
              read (41,*)t_t(i),pf_t(3,i),pf_t(9,i),
     *  pf_t(3+9,i),pf_t(9+9,i)
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

	 pf(3)=pf_t(3,i-1)+t_coef*(pf_t(3,i)-pf_t(3,i-1))
	 pf(9)=pf_t(9,i-1)+t_coef*(pf_t(9,i)-pf_t(9,i-1))

	 pf(3+9)=pf_t(3+9,i-1)+t_coef*(pf_t(3+9,i)-pf_t(3+9,i-1))
	 pf(9+9)=pf_t(9+9,i-1)+t_coef*(pf_t(9+9,i)-pf_t(9+9,i-1))


c
	 end if

	 end do
	if(kpr.eq.1)print *,' from SHAPE 67',pf(6),pf(7),pf(6+9),pf(7+9)

       return 
       end 
  	subroutine shape_67() 
	include 'double.inc'
 	include 'parf1' 
 	parameter ( NPFC=KF-4) 

 	include 'parf_mike' 

c 	parameter (ntime=20)
 
	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /ge2/ntay,tay,tt
        common
     *  /ge5/kpr


	dimension t_t(ntime),pf_t(kf,ntime)

	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='67.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 
           read (41,*) 

           do i=1,n_t 
              read (41,*)t_t(i),pf_t(6,i),pf_t(7,i),
     *  pf_t(6+9,i),pf_t(7+9,i)
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

	 pf(6)=pf_t(6,i-1)+t_coef*(pf_t(6,i)-pf_t(6,i-1))
	 pf(7)=pf_t(7,i-1)+t_coef*(pf_t(7,i)-pf_t(7,i-1))

	 pf(6+9)=pf_t(6+9,i-1)+t_coef*(pf_t(6+9,i)-pf_t(6+9,i-1))
	 pf(7+9)=pf_t(7+9,i-1)+t_coef*(pf_t(7+9,i)-pf_t(7+9,i-1))


c
	 end if

	 end do
	if(kpr.eq.1)print *,' from SHAPE 67',pf(6),pf(7),pf(6+9),pf(7+9)

       return 
       end 

	subroutine zp_filter()
	include 'double.inc'

	common
     *  /ge2/ntay,tay,tt
	common
     *  /cont4/ZPP,RPP,WVSPIP,ZXP,ELP,SHAPE,GAPINP,
     *  DFZP, DFZP0
        common
     *  /ge5/kpr


        i_en=i_en+1

	time=tt

	f9a=zpp

	if(i_en.eq.1)then
           e1 = f9a
           f9af=e1
           v1 = f9af
           time1 = time
        end if

c	qqp = 0.5 * 5.0e-5 * (time - time1)*1.e3

	qqp = 0.5 * 5.0e-2 * (time - time1)

	f9af =(qqp * (f9a + e1) - (qqp - 1.0) * v1) / (qqp + 1.0)

	if(kpr.eq.1)print *,' tt zpp f9a f9af----',tt,zpp,f9a,f9af

	zpp=f9af

c  saving for the next time_step...

	e1 = f9a
	
	v1 = f9af
	
	time1 = time

	return
	end

  	subroutine shape_zpp() 

	include 'double.inc'
 	include 'parf_mike' 
	common
     *  /ge2/ntay,tay,tt
     *  /cont4/ZPP,RPP,WVSPIP,ZXP,ELP,SHAPE,GAPINP,
     *  DFZP, DFZP0
        common
     *  /ge5/kpr


	dimension t_t(ntime),zp_t(ntime)

	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='zp.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 

           do i=1,n_t 
              read (41,*)t_t(i),zp_t(i)
              t_t(i)=t_t(i)*1000. 
              zp_t(i)=zp_t(i)*0.1
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

	 zpp=zp_t(i-1)+t_coef*(zp_t(i)-zp_t(i-1))

c
	 end if

	 end do
	if(kpr.eq.1)print *,' from SHAPE zpp',zpp

       return 
       end 

  	subroutine shape_eb() 
	include 'double.inc'
 	include 'parf1' 
 	parameter ( NPFC=KF-4) 

 	include 'parf_mike' 

c 	parameter (ntime=20)
 
	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /ge2/ntay,tay,tt
        common
     *  /ge5/kpr


	dimension t_t(ntime),pf_t(ntime)

	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='eb.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 
           read (41,*) 

           do i=1,n_t 
              read (41,*)t_t(i),pf_t(i)
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

	 pf(20)=pf_t(i-1)+t_coef*(pf_t(i)-pf_t(i-1))

c
	 end if

	 end do
	if(kpr.eq.1)print *,' from SHAPE EB',pf(20)

       return 
       end 

  	subroutine shape_ea() 
	include 'double.inc'
 	include 'parf1' 
 	parameter ( NPFC=KF-4) 

 	include 'parf_mike' 

c 	parameter (ntime=20)
 
	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /ge2/ntay,tay,tt
        common
     *  /ge5/kpr


	dimension t_t(ntime),pf_t(ntime)

	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='ea.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 
           
           read (41,*) 
           do i=1,n_t 
              read (41,*)t_t(i),pf_t(i)
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

	 pf(19)=pf_t(i-1)+t_coef*(pf_t(i)-pf_t(i-1))

c
	 end if

	 end do
	if(kpr.eq.1)print *,' from SHAPE EA',pf(19)

       return 
       end 

  	subroutine shape_f9a() 
	include 'double.inc'
 	include 'parf1' 
 	parameter ( NPFC=KF-4) 

 	include 'parf_mike' 

c 	parameter (ntime=20)
 
	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /ge2/ntay,tay,tt
        common
     *  /ge5/kpr


	dimension t_t(ntime),pf_t(ntime)

	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='f9a.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 
           
           read (41,*) 
           do i=1,n_t 
              read (41,*)t_t(i),pf_t(i)
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

	 pf(9)=pf_t(i-1)+t_coef*(pf_t(i)-pf_t(i-1))

c
	 end if

	 end do
	if(kpr.eq.1)print *,' from SHAPE F9A',pf(9)

       return 
       end 

  	subroutine shape_ip() 
	include 'double.inc'
 	include 'parf1' 
 	parameter ( NPFC=KF-4) 

 	include 'parf_mike' 

c 	parameter (ntime=20)
 
	common
     *  /ge2/ntay,tay,tt
     *	/ge1e/rs0,tpl
        common
     *  /ge5/kpr

	common
     *  /keys5/next

	dimension t_t(ntime),tpl_t(ntime)

	character *12 apr

!	if(next.ne.9999)return

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='ip.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 
           
c!!!           read (41,*) 
	k=0
      do i=1,99999
	k=k+1
              read (41,*,err=2000,end=2000)t_t(i),tpl_t(i)
              t_t(i)=t_t(i)*1000. 
                n_t=k
           end do 

2000	continue
           
           apr='-t_t-' 
c           if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 
           close (unit=41) 
        end if


71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

      do i=2,n_t
      if( (tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
	 t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )

	 tpl=tpl_t(i-1)+t_coef*(tpl_t(i)-tpl_t(i-1))

	 tpl=tpl*1.e3
c
	 end if

	 end do
	if(kpr.eq.1)print *,' from SHAPE IP tpl',tpl

       return 
       end 

  	subroutine shape_ipp() 
	include 'double.inc'
 	include 'parf1' 
 	parameter ( NPFC=KF-4) 

 	include 'parf_mike' 

c 	parameter (ntime=20)
 
	common
     *  /ge2/ntay,tay,tt
     *  /keys5/next

     *  /cont6/cip1,cip2,time1,time2
        common
     *  /ge5/kpr


	dimension t_t(ntime),tpl_t(ntime)

	character *12 apr


	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='ipp.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 
           
c!!!           read (41,*) 
           do i=1,n_t 
              read (41,*)t_t(i),tpl_t(i)
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

	 cip1=tpl_t(i-1)+t_coef*(tpl_t(i)-tpl_t(i-1))
c
	 end if

	 end do
	if(kpr.eq.1)print *,' from SHAPE cip1',cip1

       return 
       end 

  	subroutine shape_volt() 
	include 'double.inc'
 	include 'parf1' 
 	parameter ( NPFC=KF-4) 

 	include 'parf_mike' 

c 	parameter (ntime=20)
 
	common
     *  /ge2/ntay,tay,tt
        common
     *  /ge5/kpr


        common
     *  /c_con7/volt(kf)

 	dimension t_t(ntime),volt_t(npfc,ntime) 
 	character *12 apr 

 	i_sh=i_sh+1 
 	if(i_sh.eq.1)then 
           open (unit=41,file='chopperv.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 
           
           do i=1,n_t 
              read (41,*)t_t(i),(volt_t(j,i),j=1,npfc) 
              t_t(i)=t_t(i)*1000. 
           end do 
           
           apr='-t_t-' 
c           if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 
           close (unit=41) 
        end if


 71	FORMAT(20X,A8/,(6(1X,1PE10.3))) 

 	do i=2,n_t 

 	if( (tt-t_t(i-1))*(tt-t_t(i)).le.0.)then 
 	   t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) ) 

 	   do j=1,npfc 
	   volt(j) =volt_t(j,i-1)+t_coef*(volt_t(j,i)-volt_t(j,i-1))
 	   end do 

 	end if 
 	end do 

 	apr='-volt-' 
 	if(kpr.eq.1)print 71,apr,(volt(j),j=1,npfc) 

       return 
       end 

 	subroutine shape_pow() 
	include 'double.inc'
 	include 'parf1' 
 	parameter ( NPFC=KF-4) 

 	include 'parf_mike' 

c 	parameter (ntime=2) 

 	dimension t_t(ntime), hv1_t(ntime), hv2_t(ntime),
     *  d1_t(ntime), d2_t(ntime), t1_t(ntime), t2_t(ntime),
     *  v_t(ntime)


	common
     *  /ge2/ntay,tay,tt
        common
     *  /ge5/kpr


        common
     *  /c_con3/pow_names(npfc)
     *  /c_con4/vps(npfc),kvert(npfc)
     *  /c_con5/d,d2,v,t2,hv1,hv2

 	character *12 apr 
 	character *4 pow_names 
 	i_sh=i_sh+1 
 	if(i_sh.eq.1)then 

 	 open (unit=41,file='fsupplyv.dat',form='formatted') 
 	 read (41,*) 
 	 read (41,*)n_t
 
 	 do i=1,n_t 

 	 read (41,*)t_t(i),hv1_t(i),hv2_t(i),d1_t(i),
     *  d2_t(i),t1_t(i),t2_t(i),v_t(i)
c
 	 t_t(i)=t_t(i)*1000. 
 	 end do 
 	 close (unit=41) 
 	 end if 
 	apr='-t_t-' 

c 	if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 
 71	FORMAT(20X,A8/,(6(1X,1PE10.3))) 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 

 	do i=2,n_t 
 	if( (tt-t_t(i-1))*(tt-t_t(i)).le.0.)then 
 	   t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) ) 

 	   hv1=hv1_t(i-1)+t_coef*(hv1_t(i)-hv1_t(i-1)) 
 	   hv2=hv2_t(i-1)+t_coef*(hv2_t(i)-hv2_t(i-1)) 
 	   d1 =d1_t(i-1)+t_coef*(d1_t(i)-d1_t(i-1)) 
 	   d2 =d2_t(i-1)+t_coef*(d2_t(i)-d2_t(i-1)) 
 	   t1 =t1_t(i-1)+t_coef*(t1_t(i)-t1_t(i-1)) 
 	   t2 =t2_t(i-1)+t_coef*(t2_t(i)-t2_t(i-1)) 
 	   v  =v_t(i-1)+t_coef*(v_t(i)-v_t(i-1)) 

 	end if 
 	end do 

 	do i=1,npfc 
 	if(pow_names(i).eq.'D  ,')vps(i)=d1 
  	if(pow_names(i).eq.'D1 ,')vps(i)=d1 
  	if(pow_names(i).eq.'D2 ,')vps(i)=d2 
 	if(pow_names(i).eq.'V  ,')vps(i)=v 
 	if(pow_names(i).eq.'V1 ,')vps(i)=v 
 	if(pow_names(i).eq.'V2 ,')vps(i)=v2 
 	if(pow_names(i).eq.'T1 ,')vps(i)=t1 
 	if(pow_names(i).eq.'T2 ,')vps(i)=t2 
 	if(pow_names(i).eq.'HV1,')vps(i)=hv1 
 	if(pow_names(i).eq.'HV2,')vps(i)=hv2 
 	end do 

 	apr='-vps-' 

 	if(kpr.eq.1)print 71,apr,(vps(j),j=1,npfc) 
       return 
       end 

	subroutine shape_d3d()
	include 'double.inc'
c
	common
     *  /ge2/NTAY,TAY,TT
	common
     *  /cont4/ZPP,RPP,WVSPIP,ZXP,ELP,SHAPE,GAPINP,
     *  DFZP, DFZP0
     *  /cont6/cip1,cip2,time1,time2
        common
     *  /ge5/kpr


c-------
	parameter (ntime=20)
c------

	dimension t_p(ntime),rpp_t(ntime),zpp_t(ntime),
     *  tpl_t(ntime)

	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
	 open (unit=41,file='shape_d3d',form='formatted')
	 read (41,*)
	 read (41,*)n_t
	 read (41,*)
	 read (41,*)(t_p(i),i=1,n_t)
c
	 read (41,*)
	 read (41,*)(rpp_t(i),i=1,n_t)
	 read (41,*)
	 read (41,*)(zpp_t(i),i=1,n_t)
	 read (41,*)
	 read (41,*)(tpl_t(i),i=1,n_t)

	 close (unit=41)
	 end if

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))
c	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t
	apr='-zpp_t-'
c	if(kpr.eq.1)print 71,apr,(zpp_t(i),i=1,n_t)
	apr='-t_p-'
c	if(kpr.eq.1)print 71,apr,(t_p(i),i=1,n_t)

      do i=2,n_t
      if( (tt-t_p(i-1))*(tt-t_p(i)).le.0.)then
c==================
	 t_coef=(tt-t_p(i-1))/( t_p(i)-t_p(i-1) )
c=================
c 9) ---- rpp ----
	 rpp=rpp_t(i-1)+t_coef*(rpp_t(i)-rpp_t(i-1))
c
c 10) ---- zpp ----
	 zpp=zpp_t(i-1)+t_coef*(zpp_t(i)-zpp_t(i-1))
c 11) ---- tpl_p ----
	 cip1=tpl_t(i-1)+t_coef*(tpl_t(i)-tpl_t(i-1))
c
	 end if

	 end do
	if(kpr.eq.1)print *,' from SHAPE rpp zpp cip1',rpp,zpp,cip1
      return
      end

	subroutine ef_read()
	include 'double.inc'
	include 'parf0'
	include 'parf1'
        common
     *  /ge2/NTAY,TAY,TT
     *	/ge1e/rs0,tpl
        common
     *  /ge5/kpr

	common
     *	/efit1/alfax(2),betax(2)
        common
     *  /cont13/zmag,zvel,delrmag,delzmag
	common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /pol4/ UM,VM,UK(ntet),VK(ntet)
	common
     *  /con1/gain,ta,zref,kzref                                               

        open (unit=41,file='tok.dat',form='formatted')
        read (41,*)
        read (41,*)npf

        do i=1,npf
        read (41,*)
        read (41,*)pf(i)
        end do
        close (41)

        open (unit=41,file='ef.dat',form='formatted')

        read (41,*)
        read (41,*)alfax
        read (41,*)
        read (41,*)betax

	if(kpr.eq.1)print *,' alfax',alfax
	if(kpr.eq.1)print *,' betax',betax

        read (41,*)
        read (41,*)tt,tpl,zmag

	vm=zmag
	zref=zmag

	if(kpr.eq.1)print *,' tt tpl zmag',tt,tpl,zmag
	if(kpr.eq.1)print *,' zref',zref
	
        close (41)



	return
        end


c*******************************
  	subroutine shape_emo() 
	include 'double.inc'
 	include 'parf0' 
 	include 'parf_mike' 

c 	parameter (ntime=20)
 
	common
     *  /ge2/ntay,tay,tt
     *  /en14/EMOE,EMOQ,NDOP,QDE0(npo),QDQ0(npo)
        common
     *  /ge5/kpr


	dimension t_t(ntime),emoe_t(ntime),emoq_t(ntime)

	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='emo.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 
           
           read (41,*) 
           do i=1,n_t 
              read (41,*)t_t(i),emoe_t(i),emoq_t(i)
              t_t(i)=t_t(i)*1000. 
           end do 
           
           apr='-t_t-' 
           if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 
           apr='-emoe_t-' 
           if(kpr.eq.1)print 71,apr,(emoe_t(i),i=1,n_t) 
           close (unit=41) 
        end if
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

      t_coef=0.
      do i=2,n_t
      if( (tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
	 t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )
c
	 emoe=emoe_t(i-1)+t_coef*(emoe_t(i)-emoe_t(i-1))
	 emoq=emoq_t(i-1)+t_coef*(emoq_t(i)-emoq_t(i-1))

	emoe1=emoe
	emoq1=emoq

	pnor=6.25e8
	emoe=emoe*pnor
	emoq=emoq*pnor
c
	 end if

	 end do
	if(kpr.eq.1)print *,' from SHAPE tt t_coef',tt,t_coef
	if(kpr.eq.1)print *,' from SHAPE emo1',emoe1,emoq1
	if(kpr.eq.1)print *,' from SHAPE emo',emoe,emoq
c	pause 'from shape_emo'

       return 
       end 


   	subroutine write_fc() 
	include 'double.inc'
 	include 'parf1' 
 
	common
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /c_tcv14/vch0(kf),pf_ref(kf)
	common
     *  /ge2/ntay,tay,tt
     *  /ge5/kpr

	character *12 apr

	i_sh=i_sh+1
	if(i_sh.eq.1)then
       open (unit=41,file='fc.txt',form='formatted') 
       write(41,*)'n_t' 
       write(41,*)i_sh 

       if(kpr.eq.1)print *,' tt npf n_t===',tt,npf,n_t
 
       write(41,*)'PF(i),i=1,npf'
       else
       open (unit=41,file='fc.txt',form='formatted',access='append') 
       end if
       write(41,5000)tt,(pf(k),k=1,npf)

       close (unit=41) 

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

5000    format (16(1p,1e16.7e3))

	if(kpr.eq.1)print *,' from write_fc',pf_ref(1),pf_ref(8)

       return 
       end 




  	subroutine shape_pfres() 
	include 'double.inc'
 	include 'parf1' 
 	include 'parf_mike' 
 
	common
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /pf8/pfind(kf,kf),pfres(kf),a1(kf,kf),e1(kf),e2(kf)
	common
     *  /ge2/ntay,tay,tt
        common
     *  /ge5/kpr


	dimension t_t(ntime),pf_t(kf,ntime)

      character*70 apr
	character *30 apr1
	dimension a_print(200)

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='pfres.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 
           read (41,*) 

           do i=1,n_t 
              read (41,*)t_t(i),(pf_t(k,i),k=1,npf)
              t_t(i)=t_t(i)*1000. 
           end do 

      do i=1,npf
	a_print(i)=pfres(i)
	end do
	
	n_pr=npf
	apr1='pfres'
	num=20
	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr1)

      do i=1,n_t
	a_print(i)=t_t(i)
	end do
	
	n_pr=n_t
	apr1='t_t'
	num=20
	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr1)

           
           apr='-t_t-' 
c           if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 
           close (unit=41) 
        end if
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))


      k_inv=0
      
      do i=1,n_t

      t1=t_t(i)-0.49d0*tay
      t2=t_t(i)+0.51d0*tay
      
	 a_print(1)=t1
	 a_print(2)=tt
	 a_print(3)=t2
	 a_print(4)=tay
	
	 n_pr=4
	 apr1='t1 tt t2 tay'
	 num=20
!	 if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr1)

      if( (tt-t1)*(tt-t2).le.0.)then


	 n_pr=4
	 apr1='t1 tt t2 tay'
	 num=20
	 if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr1)
	 
	 	 do k=1,npf
	    pfres(k)=pf_t(k,i)
	 end do

       k_inv=1
       tt_inv=t_t(i)
       
	 end if

	 end do
	 
	 if(k_inv.eq.1)then

	 a_print(1)=k_inv
	 a_print(2)=tt_inv
	 a_print(3)=tt
	
	 n_pr=3
	 apr1='k_inv t_inv tt'
	 num=20

	 if(kpr.eq.1)print *,' npf kpr==',npf,kpr

	 if(kpr.eq.3.or.kpr.eq.1)then
	 if(kpr.eq.1)print *,' ++npf kpr==',npf,kpr
	 call out42(n_pr,a_print,num,apr1)
	 end if
	 
	 if(kpr.eq.1)print *,' k_inv2 t_inv tt',k_inv,t_inv,tt
	 
	 call inv_gen()

      do i=1,npf
	a_print(i)=pfres(i)
	end do
	
	n_pr=npf
	apr1='pfres'
	num=20
	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr1)


	 end if
	 
	 if(kpr.eq.1)print *,' from SHAPE k_in pfres',k_inv,pfres(3)

       return 
       end 
