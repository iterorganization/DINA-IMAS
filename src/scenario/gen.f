      subroutine gen_cor()
      include 'double.inc'
      include 'parf1'
      common
     *  /ge2/ntay,tay,tt
     *  /ge5/kpr
      common
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /pf8/pfind(kf,kf),pfres(kf),a1(kf,kf),e1(kf),e2(kf)
      common
     *  /gen1/n_gen
     *  /gen2/a1_gen(mu,mu)
     *  /gen5/t_gen(mu),t_gen0(mu)
      common
     *  /ves2/ncam,rc(mu),zc(mu)
      common
     *  /cont1/vchopper(kf),veps

      dimension d0(kf),d1(kf),d2(kf)

      character*70 apr

c        real *8 a1_gen
        
      do i=1,npf
         t_gen0(i+ncam)=pf(i)
      end do

	apr='pf'
	if(kpr.eq.1)print 71,apr,(pf(i),i=1,npf)

c===============================
71	format(5x,a10/,(1X,6(1pe11.3)))
      return
      end
c

      subroutine d3d_cor_2()
	include 'double.inc'
      include 'parf1'
      common
     *  /ge2/ntay,tay,tt
     *  /ge5/kpr
      common
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /pf8/pfind(kf,kf),pfres(kf),a1(kf,kf),e1(kf),e2(kf)
      common
     *  /gen1/n_gen
     *  /gen2/a1_gen(mu,mu)
     *  /gen5/t_gen(mu),t_gen0(mu)
      common
     *  /ves2/ncam,rc(mu),zc(mu)
      common
     *  /cont1/vchopper(kf),veps

      dimension d0(kf),d1(kf),d2(kf)

      character*70 apr

c        real *8 a1_gen
        
c---- coeficients for D3D power system...

      i_en=i_en+1
      if(i_en.eq.1)then

	do i=1,npf
	d1(i)=0.
	d2(i)=0.
	do k=1,npf
	d1(i)=d1(i)+a1(i,k)*e1(k)
	d2(i)=d2(i)+a1(i,k)*e2(k)
	end do
	end do
	apr='d1'
	if(kpr.eq.1)print 71,apr,(d1(i),i=1,npf)
	apr='d2'
	if(kpr.eq.1)print 71,apr,(d2(i),i=1,npf)
c     
      end if

	if(ntay.lt.2)return

      do i=1,npf
         d0(i)=pf(i)
      end do
      
      apr='d0'
      if(kpr.eq.1)print 71,apr,(d0(i),i=1,npf)
	sum0=0.
	sum1=0.
	sum2=0.
	do i=1,5
	k=i+9
	sum0=sum0+d0(i)+d0(k)
	sum1=sum1+d1(i)+d1(k)
	sum2=sum2+d2(i)+d2(k)
	end do
c
	do i=8,9
	k=i+9
	sum0=sum0+d0(i)+d0(k)
	sum1=sum1+d1(i)+d1(k)
	sum2=sum2+d2(i)+d2(k)
	end do
c_____________________________________________________
	veps1=veps*100.*tay
	v0=-(sum0+veps1*sum2)/sum1
c	if(ntay.le.100)v0=0.1*v0
	v0prin=v0/(100.*tay)
	if(kpr.eq.1)print *,'v0 veps[V]',v0prin,veps
c
	do i=1,npf
	pf(i)=d0(i)+v0*d1(i)+veps1*d2(i)
	end do

	sum0=0.
	do i=1,5
	k=i+9
	sum0=sum0+pf(i)+pf(k)
	end do
c
	do i=8,9
	k=i+9
	sum0=sum0+pf(i)+pf(k)
	end do
c	if(kpr.eq.1)print *,'total pf coil currents=',sum0,' kA'
        
      do i=1,npf
         t_gen(i+ncam)=pf(i)
      end do

	apr='pf'
	if(kpr.eq.1)print 71,apr,(pf(i),i=1,npf)
c        read (*,*)

c===============================
71	format(5x,a10/,(1X,6(1pe11.3)))
      return
      end
c

      subroutine d3d_corr_test()
	include 'double.inc'
      include 'parf1'
      common
     *  /ge2/ntay,tay,tt
     *  /ge5/kpr
      common
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /pf8/pfind(kf,kf),pfres(kf),a1(kf,kf),e1(kf),e2(kf)
      common
     *  /gen1/n_gen
     *  /gen2/a1_gen(mu,mu)
     *  /gen5/t_gen(mu),t_gen0(mu)
      common
     *  /ves2/ncam,rc(mu),zc(mu)
      common
     *  /cont1/vchopper(kf),veps

      dimension d0(kf),d1(kf),d2(kf)

      character*70 apr

c        real *8 a1_gen
        
c---- coeficients for D3D power system...

      i_en=i_en+1
      if(i_en.eq.1)then

	do i=1,npf
	e1(i)=0.
	e2(i)=1.
	end do

	do i=1,5
	k=i+9
	e1(i)=1.
	e1(k)=1.
	e2(i)=0.
	e2(k)=0.
	end do
c--->
	do i=8,9
	k=i+9
	e1(i)=1.
	e1(k)=1.
	e2(i)=0.
	e2(k)=0.
	end do

	do i=6,7
	k=i+9
	e2(i)=0.
	e2(k)=0.
	end do

         do i=1,npf
            d1(i)=0.
            d2(i)=0.
         end do

         do i=1,npf
            do k=1,npf
               d1(i)=d1(i)+a1_gen(i+ncam,k+ncam)*e1(k)
               d2(i)=d2(i)+a1_gen(i+ncam,k+ncam)*e2(k)
            end do
         end do
         apr='d1'
         if(kpr.eq.1)print 71,apr,(d1(i),i=1,npf)
         apr='d2'
         if(kpr.eq.1)print 71,apr,(d2(i),i=1,npf)
c     
      end if

	if(ntay.lt.2)return

      do i=1,npf
         d0(i)=pf(i)
      end do
      
      apr='d0'
      if(kpr.eq.1)print 71,apr,(d0(i),i=1,npf)

      sum0=0.
      sum1=0.
      sum2=0.
      do i=1,5
         k=i+9
         sum0=sum0+d0(i)+d0(k)
         sum1=sum1+d1(i)+d1(k)
         sum2=sum2+d2(i)+d2(k)
      end do
c
      do i=8,9
         k=i+9
         sum0=sum0+d0(i)+d0(k)
         sum1=sum1+d1(i)+d1(k)
         sum2=sum2+d2(i)+d2(k)
      end do

c_____________________________________________________

      veps1=veps*100.*tay
      v0=-(sum0+veps1*sum2)/sum1
      
c     if(ntay.le.100)v0=0.1*v0
      v0prin=v0/(100.*tay)

c      if(kpr.eq.1)print *,'sum0 sum1 sum2',sum0,sum1,sum2
      if(kpr.eq.1)print *,'v0 veps[V]',v0prin,veps


c
      do i=1,npf
         pf(i)=d0(i)+v0*d1(i)+veps1*d2(i)
      end do

      sum0=0.
      do i=1,5
         k=i+9
         sum0=sum0+pf(i)+pf(k)
      end do
c
      do i=8,9
         k=i+9
         sum0=sum0+pf(i)+pf(k)
      end do
      if(kpr.eq.1)print *,'total pf coil currents=',sum0,' kA'

c      if(ntay.lt.4)then
c         pf(19)=pf0(19)
c         pf(20)=pf0(20)
c      end if


        
      do i=1,npf
         t_gen(i+ncam)=pf(i)
      end do

	apr='pf'
	if(kpr.eq.1)print 71,apr,(pf(i),i=1,npf)
c        read (*,*)

c===============================
71	format(5x,a10/,(1X,6(1pe11.3)))
      return
      end



      subroutine d3d_corr_pf()
	include 'double.inc'
      include 'new_com.inc'

      call d3d_corr_pf_c(index)


      return
      end

      subroutine d3d_corr_pf_c(index)
	include 'double.inc'
      include 'parf1'
      common
     *  /ge2/ntay,tay,tt
     *  /ge5/kpr
      common
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /pf8/pfind(kf,kf),pfres(kf),a1(kf,kf),e1(kf),e2(kf)
      common
     *  /gen1/n_gen
     *  /gen2/a1_gen(mu,mu)
     *  /gen5/t_gen(mu),t_gen0(mu)
      common
     *  /ves2/ncam,rc(mu),zc(mu)
      common
     *  /cont1/vchopper(kf),veps

      dimension d0(mu),d1(mu),d2(mu)

      dimension index(kf)

      character*70 apr

c        real *8 a1_gen
        
c---- coeficients for D3D power system...

      i_en=i_en+1
      if(i_en.eq.1)then
         do i=1,n_gen
            d1(i)=0.
            d2(i)=0.
         end do

         do i=1,n_gen
            do k=1,npf
               if(index(k).ne.0)then
                  l=index(k)
                  d1(i)=d1(i)+a1_gen(i,l+ncam)*e1(k)
                  d2(i)=d2(i)+a1_gen(i,l+ncam)*e2(k)
               end if
            end do
         end do
         apr='d1'
c         if(kpr.eq.1)print 71,apr,(d1(i),i=1,npf)
         apr='d2'
c         if(kpr.eq.1)print 71,apr,(d2(i),i=1,npf)
c     
      end if

	if(ntay.lt.2)return

      do i=1,n_gen
         d0(i)=t_gen(i)
      end do
      
      apr='d0'
c      if(kpr.eq.1)print 71,apr,(d0(i),i=1,npf)

      sum0=0.
      sum1=0.
      sum2=0.

      sum_pf=0.

      do i=1,5
         if(index(i).ne.0)then
            l=index(i)
            sum0=sum0+d0(ncam+l)
            sum1=sum1+d1(ncam+l)
            sum2=sum2+d2(ncam+l)
         else
            sum_pf=sum_pf+pf(i)
         end if
         k=i+9
         if(index(k).ne.0)then
            l=index(k)
            sum0=sum0+d0(ncam+l)
            sum1=sum1+d1(ncam+l)
            sum2=sum2+d2(ncam+l)
         else
            sum_pf=sum_pf+pf(k)
         end if

      end do
c
      do i=8,9
         if(index(i).ne.0)then
            l=index(i)
            sum0=sum0+d0(ncam+l)
            sum1=sum1+d1(ncam+l)
            sum2=sum2+d2(ncam+l)
         else
            sum_pf=sum_pf+pf(i)
         end if
         k=i+9
         if(index(k).ne.0)then
            l=index(k)
            sum0=sum0+d0(ncam+l)
            sum1=sum1+d1(ncam+l)
            sum2=sum2+d2(ncam+l)
         else
            sum_pf=sum_pf+pf(k)
         end if
      end do

c_____________________________________________________

      veps1=veps*100.*tay
      v0=-(sum_pf+sum0+veps1*sum2)/sum1
      
c     if(ntay.le.100)v0=0.1*v0
      v0prin=v0/(100.*tay)

      if(kpr.eq.1)print *,'sum_pf sum0 sum1 sum2',sum_pf,sum0,sum1,sum2
      if(kpr.eq.1)print *,'v0 veps[V]',v0prin,veps


c
      do i=1,n_gen
         t_gen(i)=d0(i)+v0*d1(i)+veps1*d2(i)
      end do
c
      do i=1,npf
         if(index(i).ne.0)then
            l=index(i)
            pf(i)=t_gen(ncam+l)
         end if
      end do

      sum0=0.
      do i=1,5
         k=i+9
         sum0=sum0+pf(i)+pf(k)
      end do
c
      do i=8,9
         k=i+9
         sum0=sum0+pf(i)+pf(k)
      end do
      if(kpr.eq.1)print *,'total pf coil currents=',sum0,' kA'


	apr='pf'
	if(kpr.eq.1)print 71,apr,(pf(i),i=1,npf)
c        read (*,*)

c===============================
71	format(5x,a10/,(1X,6(1pe11.3)))
      return
      end

      subroutine d3d_corr()
	include 'double.inc'
      include 'parf1'
      common
     *  /ge2/ntay,tay,tt
     *  /ge5/kpr
      common
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /pf8/pfind(kf,kf),pfres(kf),a1(kf,kf),e1(kf),e2(kf)
      common
     *  /gen1/n_gen
     *  /gen2/a1_gen(mu,mu)
     *  /gen5/t_gen(mu),t_gen0(mu)
      common
     *  /ves2/ncam,rc(mu),zc(mu)
      common
     *  /cont1/vchopper(kf),veps

      dimension d0(mu),d1(mu),d2(mu)

      character*70 apr

c        real *8 a1_gen
        
c---- coeficients for D3D power system...

      i_en=i_en+1
      if(i_en.eq.1)then
         do i=1,n_gen
            d1(i)=0.
            d2(i)=0.
         end do

         do i=1,n_gen
            do k=1,npf
               d1(i)=d1(i)+a1_gen(i,k+ncam)*e1(k)
               d2(i)=d2(i)+a1_gen(i,k+ncam)*e2(k)
            end do
         end do
         apr='d1'
c         if(kpr.eq.1)print 71,apr,(d1(i),i=1,npf)
         apr='d2'
c         if(kpr.eq.1)print 71,apr,(d2(i),i=1,npf)
c     
      end if

	if(ntay.lt.2)return

      do i=1,n_gen
         d0(i)=t_gen(i)
      end do
      
      apr='d0'
c      if(kpr.eq.1)print 71,apr,(d0(i),i=1,npf)

      sum0=0.
      sum1=0.
      sum2=0.
      do i=1,5
         k=i+9
         sum0=sum0+d0(ncam+i)+d0(ncam+k)
         sum1=sum1+d1(ncam+i)+d1(ncam+k)
         sum2=sum2+d2(ncam+i)+d2(ncam+k)
      end do
c
      do i=8,9
         k=i+9
         sum0=sum0+d0(ncam+i)+d0(ncam+k)
         sum1=sum1+d1(ncam+i)+d1(ncam+k)
         sum2=sum2+d2(ncam+i)+d2(ncam+k)
      end do

c_____________________________________________________

      veps1=veps*100.*tay
      v0=-(sum0+veps1*sum2)/sum1
      
c     if(ntay.le.100)v0=0.1*v0
      v0prin=v0/(100.*tay)

c      if(kpr.eq.1)print *,'sum0 sum1 sum2',sum0,sum1,sum2
      if(kpr.eq.1)print *,'v0 veps[V]',v0prin,veps


c
      do i=1,n_gen
         t_gen(i)=d0(i)+v0*d1(i)+veps1*d2(i)
      end do
c
      do i=1,npf
         pf(i)=t_gen(ncam+i)
      end do

      sum0=0.
      do i=1,5
         k=i+9
         sum0=sum0+pf(i)+pf(k)
      end do
c
      do i=8,9
         k=i+9
         sum0=sum0+pf(i)+pf(k)
      end do
      if(kpr.eq.1)print *,'total pf coil currents=',sum0,' kA'


	apr='pf'
	if(kpr.eq.1)print 71,apr,(pf(i),i=1,npf)
c        read (*,*)

c===============================
71	format(5x,a10/,(1X,6(1pe11.3)))
      return
      end

        
      subroutine gen()
c--------------------------------------------
c  calculate   vessel + PF currents
c--------------------------------------------
	include 'double.inc'
      include 'parf1'
      common
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /pf7/plasma(kf),plasma0(kf)
      common
     *  /ves1/psp(mu),psp0(mu),tcam(mu),tcam0(mu)
     *  /ves2/ncam,rc(mu),zc(mu)
     *  /ves9/tokc,tokc0
      common
     *  /ge2/ntay,tay,tt
     *  /ge5/kpr

      common
     *  /gen1/n_gen
     *  /gen2/a1_gen(mu,mu)
     *  /gen3/a_gen(mu,mu)
     *  /gen4/psp_gen(mu),psp_gen0(mu)
     *  /gen5/t_gen(mu),t_gen0(mu)

      common
     *  /cont1/vchopper(kf),veps
        
c        real *8 a1_gen

      dimension fu(mu)

      character*70 apr
	character *30 apr1

	dimension a_print(200)

c

      beta=1.
c      beta=0.

      do i=1,ncam
         psp_gen(i)=psp(i)
      end do

	do i=1,npf
	psp_gen(i+ncam)=plasma(i)
        end do

        i_en=i_en+1
	if(i_en.eq.1)then

           if(kpr.eq.1)print *,'ntay  FROM GEN'

           do i=1,ncam
              t_gen(i)=tcam(i)
           end do
           do i=1,npf
              t_gen(i+ncam)=pf(i)
           end do

	apr='pf (GEN)'
	if(kpr.eq.1)print 71,apr,(t_gen(i+ncam),i=1,npf)

           return

        end if
c_____________________________________________
        volt_pl=0.

	do i=1,n_gen
	fu(i)=0.
	volt_pl=volt_pl-beta*(psp_gen(i)-psp_gen0(i))/(tay*100.)
c
	do j=1,n_gen
	fu(i)=fu(i)+a_gen(i,j)*t_gen0(j)
	end do
c
	fu(i)=fu(i)-beta*(psp_gen(i)-psp_gen0(i))
	end do

c    chopper voltage
c
	do i=1,npf
	fu(i+ncam)=fu(i+ncam)+vchopper(i)*100.*tay
	end do

	volt_pl=volt_pl/n_gen

	do i=1,n_gen
	t_gen(i)=0.
	do k=1,n_gen
	t_gen(i)=t_gen(i)+a1_gen(i,k)*fu(k)
	end do
	end do
c
        tok_c=0.
	do i=1,ncam
           tcam(i)=t_gen(i)
c           tokc=tokc+tcam(i)
           tok_c=tok_c+t_gen(i)
	end do

        if(kpr.eq.1)print *,' volt_pl==',volt_pl
        tokc=tok_c
        if(kpr.eq.1)print *,' tokc,tok_c==',tokc,tok_c

	do i=1,npf
           pf(i)=t_gen(i+ncam)
	end do

	apr='tcam (GEN)'
	if(kpr.eq.1)print 71,apr,(t_gen(i),i=1,6)

	apr='pf (GEN)'
	if(kpr.eq.1)print 71,apr,(t_gen(i+ncam),i=1,npf)

	apr='volt (GEN)'
	if(kpr.eq.1)print 73,apr,(vchopper(i),i=1,npf)

      do i=1,npf
!	a_print(i)=pf(i)
	end do
	
	n_pr=npf
	apr1='pf'
	num=20
!	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr1)


c        read (*,*)

c===============================
71	format(5x,a10/,(1X,6(1pe11.3)))
73	format(5x,a10/,(1X,6(1pe14.6)))
	return
	end



	subroutine time_gen()
	include 'double.inc'
	include 'parf1'

	common
     *  /gen1/n_gen
     *  /gen4/psp_gen(mu),psp_gen0(mu)
     *  /gen5/t_gen(mu),t_gen0(mu)

	do i=1,n_gen
	psp_gen0(i)=psp_gen(i)
	t_gen0(i)=t_gen(i)
        end do

c===============================
71	format(5x,a10/,(1X,6(1pe11.3)))
	return
	end

	subroutine v_test_c(
     *  pf,vchopper,npf,veps,
     *  tt,tay,ntay)
c---------------------
	include 'double.inc'
	dimension pf(npf),vchopper(npf)


c	vchopper(19)=-300.
c	vchopper(20)=-300.

c	veps=-300.

	veps=-300.

        do i=1,npf
           vchopper(i)=0.
        end do


c	vchopper(6)=-500.
c	vchopper(6+9)=500.


	return
	end
c
	subroutine e_test()

	include 'double.inc'
	include 'new_com.inc'

	call e_test_c(
     *  pf,vchopper,npf,veps,
     *  tt,tay,ntay)

	return
	end

	subroutine e_test_c(
     *  pf,vchopper,npf,veps,
     *  tt,tay,ntay)
c---------------------
	include 'double.inc'
	dimension pf(npf),vchopper(npf)


c	vchopper(19)=-300.
c	vchopper(20)=-300.

	veps=-300.

	vchopper(6)=-500.
	vchopper(6+9)=500.

	tt=0.
	ntay=0

	do ii=1,100

	tt=tt+tay
	ntay=ntay+1
	if(kpr.eq.1)print*,'ii time ntay ',ii,tt,ntay
	call gen()
	call d3d_corr()
	if(kpr.eq.1)print *,'Ecoila Ecoilb [kA]',pf(19),pf(20)
	if(kpr.eq.1)print *,'f6a f6b [kA]',pf(6),pf(6+9)
c	if(kpr.eq.1)print *,'f6a f6b [kA]',pf(6),pf(6+9)
	call time_gen()

	end do
	
	stop


	return
	end
c
	subroutine v_outp()

	include 'double.inc'
	include 'new_com.inc'

	call v_outp_c(
     *  pf,vchopper,npf,veps,
     *  tt,tay,ntay)

	return
	end

	subroutine v_outp_c(
     *  pf,vchopper,npf,veps,
     *  tt,tay,ntay)
c---------------------
	include 'double.inc'
	dimension pf(npf),vchopper(npf)

        i_dop=i_dop+1
        
	if(i_dop.eq.1)open (unit=42,file='outp.dat',
c!!!	open (unit=42,file='outp.dat',access='append',
     *	form='formatted')

	write (42,5000)tt,(vchopper(i),i=1,20),(pf(i),i=1,20)
c
c!!!	close (unit=42)

5001    format(4i4)
5000    format (6(1pe14.6))

	return
	end

	subroutine gen_pf()
	include 'double.inc'
	include 'new_com.inc'

        call gen_pf_c(
     *     index,pfc,pfind)



        return
        end

      subroutine gen_pf_c(
     *     index,pfc,pfind)
c--------------------------------------------
c  calculate   vessel + PF currents
c--------------------------------------------
	include 'double.inc'
      include 'parf1'
      common
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /pf7/plasma(kf),plasma0(kf)
      common
     *  /ves1/psp(mu),psp0(mu),tcam(mu),tcam0(mu)
     *  /ves2/ncam,rc(mu),zc(mu)
     *  /ves9/tokc,tokc0
      common
     *  /ge2/ntay,tay,tt
     *  /ge5/kpr

      common
     *  /gen1/n_gen
     *  /gen2/a1_gen(mu,mu)
     *  /gen3/a_gen(mu,mu)
     *  /gen4/psp_gen(mu),psp_gen0(mu)
     *  /gen5/t_gen(mu),t_gen0(mu)

      common
     *  /cont1/vchopper(kf),veps
        
        dimension index(kf),pfc(mu,kf),pfind(kf,kf)

c        real *8 a1_gen

      dimension fu(mu),volt_pf(mu)

      real *8 fu

      character*70 apr

c

      beta=1.
c      beta=0.

      do i=1,ncam
         psp_gen(i)=psp(i)
      end do
      

      do i=1,npf
         if(index(i).ne.0)then
            k=index(i)
            psp_gen(k+ncam)=plasma(i)
         end if
      end do

      i_en=i_en+1
      if(i_en.eq.1)then

         if(kpr.eq.1)print *,'ntay ncam npf FROM GEN',ntay,ncam,npf

         do i=1,ncam
            t_gen(i)=tcam(i)
         end do
      

         do i=1,npf
            if(index(i).ne.0)then
               k=index(i)
               t_gen(k+ncam)=pf(i)
            end if

         end do
         
         call time_gen()
            
         return

      end if
           


      do i=1,ncam
         volt_pf(i)=0.
         do j=1,npf
            if(index(j).eq.0)then
               v_temp=-pfc(i,j)*(pf(j)-pf0(j))/(tay*100.)
               volt_pf(i)=volt_pf(i)+v_temp
c               if(i.eq.1)if(kpr.eq.1)print *,' i j v_temp pfc',
c     *              i,j,v_temp,pfc(i,j)
            end if
         end do
      end do


      do i=1,npf
         if(index(i).ne.0)then
            k=index(i)
            volt_pf(ncam+k)=0.
            do j=1,npf
               if(index(j).eq.0)then
                  v_temp=-pfind(i,j)*(pf(j)-pf0(j))/(tay*100.)
                  volt_pf(ncam+k)=volt_pf(ncam+k)+v_temp
c                  if(kpr.eq.1)print *,' k i j v_temp pfind',
c     *                 k,i,j,v_temp,pfind(i,j)
               end if
            end do
         end if
      end do


      if(kpr.eq.1)print*,'ncam n_gen',ncam,n_gen


	apr='volt_pf (GEN)'
	if(kpr.eq.1)print 71,apr,(volt_pf(i),i=1,6)

	if(kpr.eq.1)print 71,apr,(volt_pf(i),i=ncam+1,n_gen)


	apr='psp_gen (GEN)'
	if(kpr.eq.-1)print 71,apr,(psp_gen(i),i=1,n_gen)

	apr='psp_gen0 (GEN)'
	if(kpr.eq.-1)print 71,apr,(psp_gen0(i),i=1,n_gen)


c_____________________________________________
        volt_pl=0.

	do i=1,n_gen
	fu(i)=0.
	volt_pl=volt_pl-beta*(psp_gen(i)-psp_gen0(i))/(tay*100.)
c
c add PF VOLT's
        fu(i)=fu(i)+volt_pf(i)*100.*tay
ccc        fu(i)=fu(i)+volt_pf(i)


	do j=1,n_gen
	fu(i)=fu(i)+a_gen(i,j)*t_gen0(j)
	end do
c
	fu(i)=fu(i)-beta*(psp_gen(i)-psp_gen0(i))
	end do

c    chopper voltage
c

        do i=1,npf
           if(index(i).ne.0)then
              k=index(i)
              fu(k+ncam)=fu(k+ncam)+vchopper(i)*100.*tay
           end if
        end do


	volt_pl=volt_pl/n_gen

	do i=1,n_gen
	t_gen(i)=0.
	do k=1,n_gen
	t_gen(i)=t_gen(i)+a1_gen(i,k)*fu(k)
	end do
	end do
c
        tok_c=0.
	do i=1,ncam
           tcam(i)=t_gen(i)
c           tokc=tokc+tcam(i)
           tok_c=tok_c+t_gen(i)
	end do

        if(kpr.eq.1)print *,' volt_pl==',volt_pl
        tokc=tok_c
        if(kpr.eq.1)print *,' tokc,tok_c==',tokc,tok_c



        do i=1,npf
           if(index(i).ne.0)then
              k=index(i)
              pf(i)=t_gen(k+ncam)
           end if
	end do

	apr='tcam (GEN)'
	if(kpr.eq.1)print 71,apr,(t_gen(i),i=1,6)

	apr='pf (GEN)'
	if(kpr.eq.1)print 71,apr,(pf(i),i=1,npf)
	apr='vch (GEN)'
	if(kpr.eq.1)print 71,apr,(vchopper(i),i=1,npf)
c        pause 'from gen_pf'
c===============================
71	format(5x,a10/,(1X,6(1pe11.3)))
	return
	end

	subroutine inv_gen_pf()
        include 'double.inc'
	include 'new_com.inc'

	call inv_gen_pf_c(
     *  a_gen,a1_gen,n_gen,index,
     *  rcam,pmj,ncam,pfres,pfc,pfind,npf,tay)


        return
        end


c---------------------------------------
	subroutine inv_gen_pf_c(
     *  a_gen,a1_gen,n_gen,index,
     *  rcam,pmj,ncam,pfres,pfc,pfind,npf,tay)

        include 'double.inc'
c	implicit real*8 (a-h,o-z)
	include 'parf1'

        dimension a_gen(mu,mu),a1_gen(mu,mu),index(kf),
     *  rcam(mu),pmj(mu,mu),pfres(kf),pfc(mu,kf),pfind(kf,kf)

	common
     *  /ge5/kpr


        character *12 apr
c
	dimension a(mu,mu),d(mu,mu),ed(mu,mu),a_1(mu,mu)

        real *8 a,d,a_1


        if(kpr.eq.1)print *,' npf==ncam tay ',npf,ncam,tay

        open (unit=41,file='pf_index.dat',form='formatted')
        read (41,*)
        read (41,*)(index(i),i=1,npf)
        close (41)

           k=0
           do j=1,npf
              if(index(j).ne.0)then
                 k=k+1
                 index(j)=k
              end if
           end do


	apr='index'
	if(kpr.eq.1)print 72,apr,(index(i),i=1,npf)


c--------------------------------------
	do i=1,ncam
	do j=1,ncam
	a_gen(i,j)=pmj(i,j)
	a(i,j)=a_gen(i,j)
	end do
	a(i,i)=a(i,i)+tay*rcam(i)*1.e5
c        if(kpr.eq.1)print *,' i a rcam ',i,a(i,i),rcam(i)
	end do



c  here we add PF coils staff....

	do i=1,ncam
           do j=1,npf
              if(index(j).ne.0)then
                 k=index(j)
                 a_gen(i,ncam+k)=pfc(i,j)
                 a(i,ncam+k)=a_gen(i,ncam+k)
              end if
           end do
	end do
c------------------------------

	do i=1,npf
           if(index(i).ne.0)then
              k=index(i)
              do j=1,ncam
                 a_gen(k+ncam,j)=pfc(j,i)
                 a(k+ncam,j)=a_gen(k+ncam,j)
              end do
           end if
	end do
c------------------------------

	do i=1,npf
           if(index(i).ne.0)then
              k=index(i)
              do j=1,npf
                 if(index(j).ne.0)then
                    l=index(j)
                    a_gen(k+ncam,l+ncam)=pfind(i,j)
                    a(k+ncam,l+ncam)=a_gen(k+ncam,l+ncam)
                 end if
              end do
              a(k+ncam,k+ncam)=a(k+ncam,k+ncam)+tay*pfres(i)*1.e5
c              if(kpr.eq.1)print *,' i k a pfres ',i,k,a(k+ncam,k+ncam),pfres(i)
           end if
        end do

        n_gen=ncam+k
        if(kpr.eq.1)print *,' n_gen===',n_gen

c
c	call obrm(a,a1_gen,d,mu,n_gen)
	call obrm_8(a,a_1,d,mu,n_gen)

	if(kpr.eq.1)print*,'o ++ kay GEN n_gen',n_gen

 	do i=1,n_gen
	do j=1,n_gen
	a1_gen(i,j)=a_1(i,j)
	end do
	end do
c
	do i=1,n_gen
	do j=1,n_gen
	ed(i,j)=0.
	do k=1,n_gen
	ed(i,j)=ed(i,j)+a(i,k)*a1_gen(k,j)
	end do
	end do
	end do

	apr='e{i} (GEN) [inv]'
	if(kpr.eq.1)print 71,apr,(ed(i,i),i=1,n_gen)
	apr='e{j} (GEN) [inv]'
	do j=1,2
	if(kpr.eq.1)print *,'j=',j
	if(kpr.eq.1)print 71,apr,(ed(j,i),i=1,n_gen)
	end do

	do j=n_gen-1,n_gen
	if(kpr.eq.1)print *,'j=',j
	if(kpr.eq.1)print 71,apr,(ed(j,i),i=1,n_gen)
	end do


c        read (*,*)
c        stop

71	format(20x,a70/,(6(1x,1pe10.3)))
 72     format(20x,a70/,(6(1x,i4)))
	return
	end
 
	subroutine inv_gen()
c---------------------------------------
        include 'double.inc'
c	implicit real*8 (a-h,o-z)
	include 'parf1'
c
	common
     *  /ge2/NTAY,TAY,TT
     *  /ge5/kpr
	common
     *  /ves2/ncam,rc(mu),zc(mu)
     *  /ves3/b(mu,mu),pmj(mu,mu)
     *  /ves4/rcam(mu)
     *  /ves5/pfc(mu,kf)

	common
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /pf8/pfind(kf,kf),pfres(kf),a1(kf,kf),e1(kf),e2(kf)

	common
     *  /gen1/n_gen
     *  /gen2/a1_gen(mu,mu)
     *  /gen3/a_gen(mu,mu)
     *  /gen6/d0(mu),d1(mu),d2(mu)

        character *12 apr
c
	dimension a(mu,mu),d(mu,mu),ed(mu,mu),a_1(mu,mu)
        
        real *8 a,d,a_1

c--------------------------------------
	do i=1,ncam
	do j=1,ncam
	a(i,j)=pmj(i,j)
	a_gen(i,j)=pmj(i,j)
	end do
	a(i,i)=a(i,i)+tay*rcam(i)*1.e5
	end do

c  here we add PF coils staff....

	do i=1,ncam
	do j=1,npf
	a(i,ncam+j)=pfc(i,j)
	a_gen(i,ncam+j)=pfc(i,j)
	end do
	end do
c
	do i=1,npf
	do j=1,ncam
	a(i+ncam,j)=pfc(j,i)
	a_gen(i+ncam,j)=pfc(j,i)
	end do
	end do
c
	do i=1,npf
	do j=1,npf
	a(i+ncam,j+ncam)=pfind(i,j)
	a_gen(i+ncam,j+ncam)=pfind(i,j)
	end do
	a(i+ncam,i+ncam)=a(i+ncam,i+ncam)+tay*pfres(i)*1.e5
	end do

        n_gen=ncam+npf
c
c!!!	call obrm(a,a1_gen,d,mu,n_gen)
	call obrm_8(a,a_1,d,mu,n_gen)

	if(kpr.eq.1)print*,'o ++ kay GEN n_gen',n_gen

 	do i=1,n_gen
	do j=1,n_gen
	a1_gen(i,j)=a_1(i,j)
	end do
	end do
c
 	do i=1,n_gen
	do j=1,n_gen
	ed(i,j)=0.
	do k=1,n_gen
	ed(i,j)=ed(i,j)+a(i,k)*a1_gen(k,j)
	end do
	end do
	end do

	apr='e{i} (GEN) [inv]'
	if(kpr.eq.1)print 71,apr,(ed(i,i),i=1,n_gen)
	apr='e{j} (GEN) [inv]'
	do j=1,2
	if(kpr.eq.1)print *,'j=',j
	if(kpr.eq.1)print 71,apr,(ed(j,i),i=1,n_gen)
	end do

	do j=n_gen-1,n_gen
	if(kpr.eq.1)print *,'j=',j
	if(kpr.eq.1)print 71,apr,(ed(j,i),i=1,n_gen)
	end do


c        read (*,*)
c        stop

71	format(20x,a70/,(6(1x,1pe10.3)))
	return
	end


	subroutine inv_gen_kav()
c---------------------------------------
        include 'double.inc'
c	implicit real*8 (a-h,o-z)
	include 'parf1'
c
	common
     *  /ge2/NTAY,TAY,TT
     *  /ge5/kpr
	common
     *  /ves2/ncam,rc(mu),zc(mu)
     *  /ves3/b(mu,mu),pmj(mu,mu)
     *  /ves4/rcam(mu)
     *  /ves5/pfc(mu,kf)

	common
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /pf8/pfind(kf,kf),pfres(kf),a1(kf,kf),e1(kf),e2(kf)

	common
     *  /gen1/n_gen
     *  /gen2/a1_gen(mu,mu)
     *  /gen3/a_gen(mu,mu)
     *  /gen6/d0(mu),d1(mu),d2(mu)

        character *12 apr
c
	dimension a(mu,mu),d(mu,mu),ed(mu,mu),a_1(mu,mu)
        
        real *8 a,d,a_1

c--------------------------------------
	do i=1,ncam
	do j=1,ncam
	a(i,j)=pmj(i,j)
	a_gen(i,j)=pmj(i,j)
	end do
	a(i,i)=a(i,i)+tay*rcam(i)*1.e5
	end do

c  here we add PF coils staff....

	do i=1,ncam
	do j=1,npf
	a(i,ncam+j)=pfc(i,j)
	a_gen(i,ncam+j)=pfc(i,j)
	end do
	end do
c
	do i=1,npf
	do j=1,ncam
	a(i+ncam,j)=pfc(j,i)
	a_gen(i+ncam,j)=pfc(j,i)
	end do
	end do
c
	do i=1,npf
	do j=1,npf
	a(i+ncam,j+ncam)=pfind(i,j)
	a_gen(i+ncam,j+ncam)=pfind(i,j)
	end do
!	a(i+ncam,i+ncam)=a(i+ncam,i+ncam)+tay*pfres(i)*1.e5
	end do

        n_gen=ncam+npf
c
c!!!	call obrm(a,a1_gen,d,mu,n_gen)
	call obrm_8(a,a_1,d,mu,n_gen)

	if(kpr.eq.1)print*,'o ++ kay GEN n_gen',n_gen

 	do i=1,n_gen
	do j=1,n_gen
	a1_gen(i,j)=a_1(i,j)
	end do
	end do
c
 	do i=1,n_gen
	do j=1,n_gen
	ed(i,j)=0.
	do k=1,n_gen
	ed(i,j)=ed(i,j)+a(i,k)*a1_gen(k,j)
	end do
	end do
	end do

	apr='e{i} (GEN) [inv]'
	if(kpr.eq.1)print 71,apr,(ed(i,i),i=1,n_gen)
	apr='e{j} (GEN) [inv]'
	do j=1,2
	if(kpr.eq.1)print *,'j=',j
	if(kpr.eq.1)print 71,apr,(ed(j,i),i=1,n_gen)
	end do

	do j=n_gen-1,n_gen
	if(kpr.eq.1)print *,'j=',j
	if(kpr.eq.1)print 71,apr,(ed(j,i),i=1,n_gen)
	end do


c        read (*,*)
c        stop

71	format(20x,a70/,(6(1x,1pe10.3)))
	return
	end


c
	subroutine v_test()

        include 'double.inc'
	include 'new_com.inc'

	call v_test_c(
     *  pf,vchopper,npf,veps,
     *  tt,tay,ntay)

	return
	end

	subroutine gen_corr_kav()
c---------------------------------------
        include 'double.inc'
c	implicit real*8 (a-h,o-z)
	include 'parf1'
c
	common
     *  /ge2/NTAY,TAY,TT
     *  /ge5/kpr
	common
     *  /ves2/ncam,rc(mu),zc(mu)
     *  /ves3/b(mu,mu),pmj(mu,mu)
     *  /ves4/rcam(mu)
     *  /ves5/pfc(mu,kf)

	common
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /pf8/pfind(kf,kf),pfres(kf),a1(kf,kf),e1(kf),e2(kf)

	common
     *  /gen1/n_gen
     *  /gen2/a1_gen(mu,mu)
     *  /gen3/a_gen(mu,mu)
     *  /gen6/d0(mu),d1(mu),d2(mu)
      common
     *  /cont1/vchopper(kf),veps

      character*70 apr
	character *30 apr1
	dimension a_print(200)
c
	dimension pf_help(kf)

c--------------------------------------
c
	do i=1,npf
	pf_help(i)=( 0.*vchopper(i)*tay*100.d0+pfind(i,i)*pf0(i) )/
     *  (pfind(i,i)+tay*pfres(i)*1.e5)
       pf_help(i)=pf0(i)
	end do

      do i=1,npf
	a_print(i)=pf(i)
	end do
	
	n_pr=npf
	apr1='pf'
	num=20
	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr1)

      do i=1,npf
	a_print(i)=pf_help(i)
	end do
	
	n_pr=npf
	apr1='pf_help'
	num=20
	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr1)

      do i=1,npf
	a_print(i)=vchopper(i)
	end do
	
	n_pr=npf
	apr1='V ch'
	num=20
	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr1)

	do i=1,npf
	vchopper(i)=vchopper(i)-pf_help(i)*pfres(i)*1.e3
	end do

      do i=1,npf
	a_print(i)=pfres(i)*1.e3
	end do
	
	n_pr=npf
	apr1='V pfres'
	num=20
	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr1)

      do i=1,npf
	a_print(i)=vchopper(i)
	end do
	
	n_pr=npf
	apr1='V ch'
	num=20
	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr1)


71	format(20x,a70/,(6(1x,1pe10.3)))
	return
	end

