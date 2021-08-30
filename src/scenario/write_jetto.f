c
	subroutine write_prof_ae(k_pr)
	include 'double1.inc'
        
        include 'new_com.inc'

	character *20 apr

	common /c_test1/i_test

	

   71 FORMAT(20X,A6/,(6(1pE10.3)))

c	return


	i_test=1
!!!	tok1(1)=tok1(2)

	apr='---ppr'
c      if(kpr.eq.1)print 71,apr,(Ppr(I),I=1,N)
	apr='---qdh'
c      if(kpr.eq.1)print 71,apr,(qdh(I),I=1,N)

		
	iprof=n

	if(k_pr.eq.1)then

	apr='---ajae'
      if(kpr.eq.1)print 71,apr,(ajae(I),I=1,N)
	apr='---e_par'
      if(kpr.eq.1)print 71,apr,(e_par(I),I=1,N)


	call write_graf3(iprof,tt,
!!1     *  ai,tok1,ajae,volt,zeff,ppr,te0,pd0,pne,kpr)
!!!     *  ai,tok1,ajae,e_par,zeff,ppr,te0,pd0,pne)
     *  ai,tok1,ajae,e_par,q,ppr,te0,pd0,pne)
	else

	end if


      return
      end
	subroutine write_graf1_for(iprof,ttt,
     *  xcur,torcur,qgraf,pgraf,tgraf) 

	include 'double.inc'
        include 'parf0'

    	common
     *	/n_m/n,m,mp

c$
	common
     *  /mid6/bp_0(npo),a_m(npo),r_m(npo)
c#

	dimension
     *  xcur(iprof),torcur(iprof),
     *  qgraf(iprof),pgraf(iprof),tgraf(iprof)

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

	open (unit=61,file='psi_data1',access='append',
     *  form='formatted')

c	if(ntay.le.1)then
c	open (unit=61,file='psi_data1',status='new',
c     *  form='unformatted')
c	end if

c	if(ntay.gt.1)then
c	open (unit=61,file='psi_data1',status='old',
c     *  form='unformatted')
c	end if

	write (61,*)iprof,ttt

	write (61,5000)(xcur(i),i=1,iprof)
	write (61,5000)(torcur(i),i=1,iprof)
	write (61,5000)(qgraf(i),i=1,iprof)
c$
	write (61,5000)(pgraf(i),i=1,iprof)
c!!!!!!!!!!!!	write (61)(agraf(i),i=1,iprof)
c#
	write (61,5000)(tgraf(i),i=1,iprof)
c*************
	close (61)

5000	format(4(1x,1pe14.7))
 
	return
	end
	subroutine write_prof()
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
     *  /dfm11/c20(npo),tok1(npo),tok2(npo)

     	common
     *	/ge1e/rs0,tpl
     *  /ge2/NTAY,TAY,TT
     *  /ge5/kpr
       	common
     *  /ves2/ncam,rc(mu),zc(mu)
     	common
     *	/fluxc6/pmag,pbound,psep,p_s,delaval,dr_h
     *	/fluxc7/coef,coef1,api
	common
     *  /halo5e/pshalo
	common
     *  /en1/PNE(npo),PD0(npo),PT0(npo),PH0(npo),PDN(npo),
     *  PTN(npo),PHN(npo)
     *  /en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),
     *  WE0(npo),WQ0(npo)

     	dimension xcur(2*npo),torcur(2*npo)
     	dimension pgraf(2*npo),qgraf(2*npo),tgraf(2*npo)

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

c!!!	torcur(i)=tok1(k)

	qgraf(i)=q(k)
c	pgraf(i)=p(k)
	pgraf(i)=pne(k)
	tgraf(i)=te0(k)
	end do
	end do
	iprof=i	

c	if(kpr.eq.1)then
	apr='torcur'
c	print 71,apr,(torcur(i),i=1,iprof)
	apr='tgraf'
c	print 71,apr,(tgraf(i),i=1,iprof)
	apr='pgraf'
c	print 71,apr,(pgraf(i),i=1,iprof)
c	print*,'iprof=',iprof
c	print*,'from write_prof'
c	read(*,*)
c       end if

71	format(20x,a6/,(6(1pe10.3)))

	if(kpr.eq.1)print *,'iprof n',iprof,n

	call write_graf1_for(iprof,tt,
     *  xcur,torcur,qgraf,pgraf,tgraf)

c!!!	call write_graf1(iprof,tt,
c!!!     *  xcur,torcur,qgraf,pgraf,tgraf)
c
c	read (*,*)
	return
	end
c
c
	subroutine write_graf1(iprof,ttt,
     *  xcur,torcur,qgraf,pgraf,tgraf) 

	include 'double.inc'
        include 'parf0'

        common
     *  /ge2/NTAY,TAY,TT
     *  /ge5/kpr

    	common
     *	/n_m/n,m,mp

c$
	common
     *  /mid6/bp_0(npo),a_m(npo),r_m(npo)
c#

	dimension
     *  xcur(iprof),torcur(iprof),
     *  qgraf(iprof),pgraf(iprof),tgraf(iprof)

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

	open (unit=61,file='psi_data1',access='append',
     *  form='unformatted')
c	if(ntay.le.1)then
c	open (unit=61,file='psi_data1',status='new',
c     *  form='unformatted')
c	end if

c	if(ntay.gt.1)then
c	open (unit=61,file='psi_data1',status='old',
c     *  form='unformatted')
c	end if

	write (61,*)iprof,ttt

	write (61,5000)(xcur(i),i=1,iprof)
	write (61,5000)(torcur(i),i=1,iprof)
	write (61,5000)(qgraf(i),i=1,iprof)
c$
	write (61,5000)(pgraf(i),i=1,iprof)
c!!!!!!!!!!!!	write (61)(agraf(i),i=1,iprof)
c#
	write (61,5000)(tgraf(i),i=1,iprof)
c!!!
	write (61,5000)(tgraf(i),i=1,iprof)
	write (61,5000)(tgraf(i),i=1,iprof)
	write (61,5000)(tgraf(i),i=1,iprof)
	write (61,5000)(tgraf(i),i=1,iprof)

	close (61)
 
5000	format(4(1x,1pe14.7))
	return
	end

c
	subroutine write_btor()
	include 'double.inc'
        include 'new_com.inc'
	call write_btor_c(b_tor)
	return
	end
c
	subroutine write_btor_c(b_tor)
	include 'double.inc'
        include 'parf2'
	dimension b_tor(nr,nz)
c
c----------- write  graphics of B_tor data in kGs/(2pi) ---

       	ntay=ntay+1
c	open (unit=61,file='psi_data2',access='append',
c     *  form='unformatted')
	if(ntay.le.1)then
	open (unit=61,file='psi_data2',status='new',
     *  form='unformatted')
	end if

	if(ntay.gt.1)then
	open (unit=61,file='psi_data2',status='old',
     *  form='unformatted')
	end if

	write (61)((b_tor(i,j),i=1,nr),j=1,nz)

	close (61)
 
	return
	end

	subroutine write_prof0()
	include 'double.inc'
        
        include 'new_com.inc'

!      if(kpr.eq.1)print *,' pn0==',(pn0(i),i=1,n)
	character *20 apr
71	FORMAT(5X,A10/,(2x,6(1PE11.3)))
!      if(kpr.eq.1)print *,' pn0==',(pn0(i),i=1,n)

	apr='pd0'
	if(kpr.eq.1)print 71,apr,(pd0(i),i=1,n)

        call write_prof0_c(n,
     *  ai,eu,tt,
!     *  tok1,pd0,ajb,p,q,pne,tq0,te0)
     *  tok1,pne,pd0,tq0,te0,pn0,w_imp_pr,w_imp_pr2)
!     *  tok1,pd0,ajb,p,ppx,pffx,ppxd,pffxd)
!     *  tok1,aj0,sigma_dina,p,q,pne,ajb,te0)

      


        return
        end


        subroutine write_prof0_c(n,
     *  ai,eu,tt,
c     *  tok1,aj0,ajb,p,q,pne,tq0,te0)
     *  tok1,aj0,ajb,p,q,pne,tq0,te0)

	include 'double.inc'

        dimension ai(*)

        dimension tok1(*),aj0(*),ajb(*),te0(*),
     *  tq0(*),pne(*),q(*),p(*)

        include 'parf0'

     	dimension xcur(2*npo),torcur(2*npo)
     	dimension pgraf(2*npo),qgraf(2*npo),tgraf(2*npo)
	dimension tok_ohm(2*npo)

	character *20 apr

        
        do i=1,n
c
           k=i

!           xcur(i)=ai(i)*eu
           xcur(i)=ai(i)


	end do

	iprof=n

71	format(20x,a6/,(6(1pe10.3)))

	if(kpr.eq.1)print *,'tt eu iprof n',tt,eu,iprof,n

	call write_graf3(iprof,tt,
c     *  xcur,tok1,qgraf,aj0_b,aj0_uv,aj0_lh,aj0_ech,ajb,te0)
!!!     *  xcur,tok1,qgraf,aj0_b,tok_ohm,aj0_lh,aj0_ech,ajb,te0)

     *  xcur,tok1,aj0,ajb,p,q,pne,tq0,te0)

	apr='aj0'
	if(kpr.eq.1)print 71,apr,(aj0(i),i=1,iprof)
	apr='dina_sigma'
	if(kpr.eq.1)print 71,apr,(ajb(i),i=1,iprof)

	return
	end
c
c
	subroutine write_graf3(iprof,ttt,
     *  xcur,y1,y2,y3,y4,y5,y6,y7,y8)

	include 'double.inc'

        common
     *  /ge5/kpr

	dimension
     *  xcur(*),y1(*),y2(*),y3(*),y4(*),y5(*),y6(*),
     *  y7(*),y8(*)

c----------- write  graphics data ---
	ntay=ntay+1

        i_form=1

        if(i_form.eq.0)then

c        open (unit=61,file='p_data1',access='append',
c     *  form='unformatted')

          if(ntay.le.1)then
              open (unit=61,file='p_data1',
     *             form='unformatted')
           end if

           if(ntay.gt.1)then
              open (unit=61,file='p_data1',access='append',
     *             form='unformatted')
           end if
c$

	write (61)iprof,ttt
	write (61)(xcur(i),i=1,iprof)
	write (61)(y1(i),i=1,iprof)
	write (61)(y2(i),i=1,iprof)
	write (61)(y3(i),i=1,iprof)
	write (61)(y4(i),i=1,iprof)
	write (61)(y5(i),i=1,iprof)
	write (61)(y6(i),i=1,iprof)
	write (61)(y7(i),i=1,iprof)
	write (61)(y8(i),i=1,iprof)

	close (61)

        else
c        open (unit=61,file='p_data1',access='append',
c     *  form='formatted')

           if(ntay.le.1)then
              open (unit=61,file='p_data1',
     *             form='formatted')
           end if

           if(ntay.gt.1)then
              open (unit=61,file='p_data1',
     *  access='append',form='formatted')
           end if
c$

        write (61,*)iprof,ttt
        write (61,5000)(xcur(i),i=1,iprof)
        write (61,5000)(y1(i),i=1,iprof)
        write (61,5000)(y2(i),i=1,iprof)
        write (61,5000)(y3(i),i=1,iprof)
        write (61,5000)(y4(i),i=1,iprof)
        write (61,5000)(y5(i),i=1,iprof)
        write (61,5000)(y6(i),i=1,iprof)
        write (61,5000)(y7(i),i=1,iprof)
        write (61,5000)(y8(i),i=1,iprof)

	close (61)
        end if

5000    format (6(1pe14.6e3))

	return
	end
c

	subroutine write_prof4()
	include 'double.inc'
        include 'new_com.inc'

         include 'par_imp.inc'
         include 'new_imp.inc'

	character *20 apr
71	FORMAT(5X,A10/,(2x,6(1PE11.3)))
!      if(kpr.eq.1)print *,' pn0==',(pn0(i),i=1,n)

	apr='pt0'
	if(kpr.eq.1)print 71,apr,(pt0(i),i=1,n)
	apr='den_neut0'
	if(kpr.eq.1)print 71,apr,(den_neut0(i),i=1,n)
	apr='den_neut1'
	if(kpr.eq.1)print 71,apr,(den_neut1(i),i=1,n)
	apr='p_lambda0'
	if(kpr.eq.1)print 71,apr,(p_lambda0(i),i=1,n)
	apr='p_lambda1'
	if(kpr.eq.1)print 71,apr,(p_lambda1(i),i=1,n)
!p_lambda0(npo),p_lambda1
        call write_prof4_c(n,
     *  ai,eu,tt,
!     *  tok1,pd0,ajb,p,q,pne,tq0,te0)
     *  tok1,pne,pd0,pt0,den_neut0,den_neut1,p_lambda0,p_lambda1)
!     *  tok1,pd0,ajb,p,ppx,pffx,ppxd,pffxd)
!     *  tok1,aj0,sigma_dina,p,q,pne,ajb,te0)

      


        return
        end


        subroutine write_prof4_c(n,
     *  ai,eu,tt,
c     *  tok1,aj0,ajb,p,q,pne,tq0,te0)
     *  tok1,aj0,ajb,p,q,pne,tq0,te0)

	include 'double.inc'

        dimension ai(*)

        dimension tok1(*),aj0(*),ajb(*),te0(*),
     *  tq0(*),pne(*),q(*),p(*)

        include 'parf0'

     	dimension xcur(2*npo),torcur(2*npo)
     	dimension pgraf(2*npo),qgraf(2*npo),tgraf(2*npo)
	dimension tok_ohm(2*npo)

	character *20 apr

        
        do i=1,n
c
           k=i

!           xcur(i)=ai(i)*eu
           xcur(i)=ai(i)


	end do

	iprof=n

71	format(20x,a6/,(6(1pe10.3)))

	if(kpr.eq.1)print *,'tt eu iprof n',tt,eu,iprof,n

	call write_graf4(iprof,tt,
c     *  xcur,tok1,qgraf,aj0_b,aj0_uv,aj0_lh,aj0_ech,ajb,te0)
!!!     *  xcur,tok1,qgraf,aj0_b,tok_ohm,aj0_lh,aj0_ech,ajb,te0)

     *  xcur,tok1,aj0,ajb,p,q,pne,tq0,te0)


	return
	end
c
c
	subroutine write_graf4(iprof,ttt,
     *  xcur,y1,y2,y3,y4,y5,y6,y7,y8)

	include 'double.inc'

        common
     *  /ge5/kpr

	dimension
     *  xcur(*),y1(*),y2(*),y3(*),y4(*),y5(*),y6(*),
     *  y7(*),y8(*)

c----------- write  graphics data ---
	ntay=ntay+1

        i_form=1

        if(i_form.eq.0)then

c        open (unit=61,file='p_data1',access='append',
c     *  form='unformatted')

          if(ntay.le.1)then
              open (unit=61,file='p_data2',
     *             form='unformatted')
           end if

           if(ntay.gt.1)then
              open (unit=61,file='p_data2',access='append',
     *             form='unformatted')
           end if
c$

	write (61)iprof,ttt
	write (61)(xcur(i),i=1,iprof)
	write (61)(y1(i),i=1,iprof)
	write (61)(y2(i),i=1,iprof)
	write (61)(y3(i),i=1,iprof)
	write (61)(y4(i),i=1,iprof)
	write (61)(y5(i),i=1,iprof)
	write (61)(y6(i),i=1,iprof)
	write (61)(y7(i),i=1,iprof)
	write (61)(y8(i),i=1,iprof)

	close (61)

        else
c        open (unit=61,file='p_data1',access='append',
c     *  form='formatted')

           if(ntay.le.1)then
              open (unit=61,file='p_data2',
     *             form='formatted')
           end if

           if(ntay.gt.1)then
              open (unit=61,file='p_data2',
     *  access='append',form='formatted')
           end if
c$

        write (61,*)iprof,ttt
        write (61,5000)(xcur(i),i=1,iprof)
        write (61,5000)(y1(i),i=1,iprof)
        write (61,5000)(y2(i),i=1,iprof)
        write (61,5000)(y3(i),i=1,iprof)
        write (61,5000)(y4(i),i=1,iprof)
        write (61,5000)(y5(i),i=1,iprof)
        write (61,5000)(y6(i),i=1,iprof)
        write (61,5000)(y7(i),i=1,iprof)
        write (61,5000)(y8(i),i=1,iprof)

	close (61)
        end if

5000    format (6(1pe14.6e3))

	return
	end
c


        subroutine w_sep_data()
        include 'parf2'
	  include 'double.inc'


        common /sep_points/n_sep,x_sep(mu1),y_sep(mu1)

        common
     *  /ge2/NTAY,TAY,TT
        common
     *  /keys10/ngra


c----------- write  separatrix data ---
        nta=nta+1

	ngra1=1

c	open (unit=61,file='sep_data',access='append',

	if(nta.le.1)then
	open (unit=61,file='sep_data',
     *  form='formatted')
	end if

	if(nta.gt.1)then
	open (unit=61,file='sep_data',access='append',
     *  form='formatted')
	end if

	if(ntay.eq.ngra1*(ntay/ngra1))then


	write (61,*)tt,n_sep
	write (61,5000)(x_sep(i),i=1,n_sep)
	write (61,5000)(y_sep(i),i=1,n_sep)

        end if

	close (61)

5000    format (6(1pe14.6))

	return
	end


