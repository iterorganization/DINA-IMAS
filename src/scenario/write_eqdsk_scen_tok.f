
c************************************************

	subroutine equidsk_write(key_file_xx)
	include 'double.inc'
	include 'new_com.inc'

	call equidsk_write_c(key_file_xx,
     *  n,mp,q,f,p,ppx,pffx,a,jbound,xbound,ybound,x,y,ke,xu,yu,
     *  psi_g,pi,kpr,nr,nz,tpl,ai,rmag,zmag,pmag,psep,pbound,
     *  bt0,rs0)

	return
	end
	 
	subroutine equidsk_write_c(key_file,
     *  n,mp,q,f,p,ppx,pffx,a,jbound,xbound,ybound,r,z,ke,xu,yu,
     *  psi_g,pi,kpr,nr,nz,tpl,ai,rmag,zmag,pmag,psep,pbound,
     *  bt0,rs0)

	parameter ( mu1=1500, npo=1000 )

	include 'double.inc'


	character*10 case(6)
	character*24 case_dina1,case_dina2

	dimension q(*),f(*),p(*),ppx(*),pffx(*),r(*),z(*),
     . xbound(*),ybound(*),xu(*),yu(*),psi_g(nr,nz),ai(*)

	dimension psirz(nr,nz),fpol(npo),pres(npo),ffprim(npo),
     . pprime(npo),qpsi(npo),rbbbs(npo),zbbbs(npo),
     . rlim(npo),zlim(npo),
     . poa(npo)

	character *12 apr
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))


	pmu0=4.d0*pi*1.d-7
	coef=10.d0/(4.d0*pi)


!!!	call map_ps()



      call polar_map()


	neqdsk=41

	if(key_file.eq.1)
     *	open (unit=neqdsk,file='file1.eqdsk',form='formatted')                        
	if(key_file.eq.2)
     *	open (unit=neqdsk,file='file2.eqdsk',form='formatted')                        
	if(key_file.eq.3)
     *	open (unit=neqdsk,file='file3.eqdsk',form='formatted')                        
	if(key_file.eq.4)
     *	open (unit=neqdsk,file='file4.eqdsk',form='formatted')                        
	if(key_file.eq.5)
     *	open (unit=neqdsk,file='file5.eqdsk',form='formatted')                        
	if(key_file.eq.6)
     *	open (unit=neqdsk,file='file6.eqdsk',form='formatted')                        


	rdim=( r(nr)-r(1) )*1.d-2
	zdim=( z(nz)-z(1) )*1.d-2

	zmid=0.5d0*(z(1)+z(nz))*1.d-2

	rleft=r(1)*1.d-2


	rcentr=rs0*1.d-2
	bcentr=bt0*1.d-1

	rmaxis=rmag*1.d-2
	zmaxis=zmag*1.d-2

	current=tpl*1.d+3
	simag=pmag*1.d-5
!!!	sibry=pbound*1.d-5
	sibry=psep*1.d-5

	nw=nr
	nh=nz
	nrad=n

	do i=1,nw
	poa(i)=dfloat(i-1)/dfloat(nw-1)
!!!	x(i)=simag+dfloat(i-1)/dfloat(nw-1)*(sibry-simag)
	end do

	apr='-f-' 
	if(kpr.eq.1)print 71,apr,(f(i),i=1,n) 
	apr='-p-' 
	if(kpr.eq.1)print 71,apr,(p(i),i=1,n) 
	apr='-q-' 
	if(kpr.eq.1)print 71,apr,(q(i),i=1,n) 

	apr='-ai-' 
	if(kpr.eq.1)print 71,apr,(ai(i),i=1,n) 
	apr='-poa-' 
	if(kpr.eq.1)print 71,apr,(poa(i),i=1,nw) 
c	stop

	q(1)=q(2)

	ai(n+1)=1.d0
 	teta_xx=1.d0
        call inter_h0(q,ai,n,teta_xx,val)
	q(n+1)=val

c	if(kpr.eq.1)print *,' ai 1=',ai(n+1),q(n+1)

!!       call inter_axis(q,ai,4,teta_xx,val)
!!	q_xx(1)=val


	pres(1)=p(1)
	pres(nw)=p(n)

	pprime(1)=ppx(1)
	ffprim(1)=pffx(1)

c---------------------------

!	psval(i)=pmag+poa(i)**2*(pbound-pmag)

	do i=2,nw-1
	psix=sqrt( poa(i) )
!!!	psix= poa(i)*poa(i)

	call feeti(nrad,ppx,pprime(i),a,psix)
	call feeti(nrad,pffx,ffprim(i),a,psix)
	call feeti(nrad,p,pres(i),a,psix)
	end do

	pprime(nw)=ppx(nrad)
	ffprim(nw)=pffx(nrad)

	apr='-ppx-' 
	if(kpr.eq.1)print 71,apr,(ppx(i),i=1,n) 
	apr='-pffx-' 
	if(kpr.eq.1)print 71,apr,(pffx(i),i=1,n) 

	apr='-pprime-' 
	if(kpr.eq.1)print 71,apr,(pprime(i),i=1,nw) 
	apr='-ffprim-' 
	if(kpr.eq.1)print 71,apr,(ffprim(i),i=1,nw) 
	apr='-pres-' 
	if(kpr.eq.1)print 71,apr,(pres(i),i=1,nw) 

	qpsi(1)=q(1)
	qpsi(nw)=q(n+1)

	fpol(1)=f(1)
	fpol(nw)=bt0

	f(n+1)=bt0

	do i=2,nw-1
	psix=sqrt( poa(i) )
	call feeti(nrad+1,f,fpol(i),ai,psix)
	call feeti(nrad+1,q,qpsi(i),ai,psix)

c	if(kpr.eq.1)print *,' i psix ==',i,psix

	end do


	apr='-fpol-' 
	if(kpr.eq.1)print 71,apr,(fpol(i),i=1,nw) 
	apr='-qpsi-' 
	if(kpr.eq.1)print 71,apr,(qpsi(i),i=1,nw) 

	apr='-pres-' 
	if(kpr.eq.1)print 71,apr,(pres(i),i=1,nw) 

      coef_pres=1.d0/(200.*1.d-6)

!!!	p(i)=( te0(i)+tq0(I) )*pne(i)*200.*1.e-6

	do i=1,nw
	pprime(i)=-coef*100.d0/rs0*pprime(i)*1.d7
	ffprim(i)=-coef*0.5d0*rs0/100.d0*ffprim(i)*1.d7*pmu0
	fpol(i)=fpol(i)*(rs0*1.d-3)
	pres(i)=pres(i)*coef_pres
	end do


	apr='-pprime-' 
	if(kpr.eq.1)print 71,apr,(pprime(i),i=1,nw) 
	apr='-ffprim-' 
	if(kpr.eq.1)print 71,apr,(ffprim(i),i=1,nw) 
	apr='-pres-' 
	if(kpr.eq.1)print 71,apr,(pres(i),i=1,nw) 
	apr='-fpol-' 
	if(kpr.eq.1)print 71,apr,(fpol(i),i=1,nw) 


!!!	F00=(PPRIME*X(I)/rS0+0.5*FPRIME*rS0/X(I))
!!!	j=coef*f00*dx*dy

c	f_pp=P_PRIME*r(i)*dx*dy
c	f_pff=ff_PRIME/r(i)/pmu0*dx*dy

	nbbbs=jbound
	do j=1,jbound
	rbbbs(j)=xbound(j)*1.d-2
	zbbbs(j)=ybound(j)*1.d-2
	end do

	limitr=ke

	do i=1,ke
	rlim(i)=xu(i)
	zlim(i)=yu(i)
	end do

	apr='-rlim-' 
	if(kpr.eq.1)print 71,apr,(rlim(i),i=1,limitr) 
	apr='-zlim-' 
	if(kpr.eq.1)print 71,apr,(zlim(i),i=1,limitr) 


	do i=1,nw
		do j=1,nh
		psirz(i,j)=psi_g(i,j)*1.d-5
		end do
	end do


      if(kpr.eq.1) print *,' current,bcentr,=',current,bcentr
      if(kpr.eq.1) print *,' rmaxis,zmaxis=',rmaxis,zmaxis
      if(kpr.eq.1) print *,' simag,sibry,=',simag,sibry
      if(kpr.eq.1) print *,' nw nh',nw,nh


      if(kpr.eq.1) print *,' rdim,zdim=',rdim,zdim
      if(kpr.eq.1) print *,' rleft,zmid',rleft,zmid



	do j=32,33
!	do j=1,nh

	apr='-psizr-' 
	if(kpr.eq.1)print 71,apr,(psirz(i,j),i=1,nw)
	end do
	 
	do i=16,17
!	do j=1,nh

	apr='-psizr-' 
	if(kpr.eq.1)print 71,apr,(psirz(i,j),j=1,nh)
	end do

	apr='-xbound-' 
	if(kpr.eq.1)print 71,apr,(xbound(i),i=1,jbound) 
	apr='-ybound-' 
	if(kpr.eq.1)print 71,apr,(ybound(i),i=1,jbound) 

      if(kpr.eq.1) print *,' jbound',jbound



	case(1)=' disr'
	case(2)=' 860'
	case(3)=' msec'
	case(4)=' nw'
	case(5)=' nh'
	case(6)=' vde'
	   case_dina1='DINA 15MA scenario,     '
	   case_dina2=' t=645 s; Ip=6 MA;      '

c
ccc	write (neqdsk,2000) (case(i),i=1,6),idum,nw,nh
	write (neqdsk,2000) case_dina1,case_dina2,idum,nw,nh
	write (neqdsk,2020) rdim,zdim,rcentr,rleft,zmid
	write (neqdsk,2020) rmaxis,zmaxis,simag,sibry,bcentr
	write (neqdsk,2020) current,simag,xdum,rmaxis,xdum
	write (neqdsk,2020) zmaxis,xdum,sibry,xdum,xdum
	write (neqdsk,2020) (fpol(i),i=1,nw)
	write (neqdsk,2020) (pres(i),i=1,nw)
	write (neqdsk,2020) (ffprim(i),i=1,nw)
	write (neqdsk,2020) (pprime(i),i=1,nw)
	write (neqdsk,2020) ((psirz(i,j),i=1,nw),j=1,nh)
	write (neqdsk,2020) (qpsi(i),i=1,nw)
	write (neqdsk,2022) nbbbs,limitr
	write (neqdsk,2020) (rbbbs(i),zbbbs(i),i=1,nbbbs)
	write (neqdsk,2020) (rlim(i),zlim(i),i=1,limitr)
c

c2000  format (6a8,3i4)
2000  format (2a24,3i4)
2020  format (5e16.9)
2022  format (2i5)




	close(41)



5000	format(4(1x,1pe14.7))
	

!!!		STOP

	return
	end


	subroutine ppx_pffx_save(k_save_xx)
        include 'double.inc'
	include 'new_com.inc'

	call ppx_pffx_save_c(k_save_xx,
     *  n,ppx,pffx,psval)


	return
	end

	subroutine ppx_pffx_save_c(k_save,
     *  n,ppx,pffx,psval)

        include 'double.inc'

	dimension  ppx(*),pffx(*),
     *  psval(*)

	include 'parf0'
	dimension  ppx2(npo),pffx2(npo),
     *  psval2(npo)

	if(k_save.eq.1)then
	do i=1,n
	ppx2(i)=ppx(i)
	pffx2(i)=pffx(i)
	psval2(i)=psval(i)
	end do
	else
	do i=1,n
	ppx(i)=ppx2(i)
	pffx(i)=pffx2(i)
	psval(i)=psval2(i)
	end do
	end if

	return
	end



	subroutine polar_map()
	include 'double.inc'
	include 'new_com.inc'

	 call polar_map_c(
     *  kpr,n,mp,rs0,tpl,pi,coef,psval,ppx,pffx,ppxx,pffxx,anux,aj,
     *  um,vm,uk,vk,ro,xpl,ypl,f,q,c2,c3,ha,vi,p,bt0)


	return
	end


	subroutine polar_map_c(
     *  kpr,n,mp,rs0,tpl,pi,coef,psval,ppx,pffx,ppxx,pffxx,anux,aj,
     *  um,vm,uk,vk,ro,xpl,ypl,f,q,c2,c3,ha,vi,p,bt0)


	include 'double.inc'

	include 'parf0'

	dimension psi(npo),fx(npo),ro_help(npo,ntet),
     *  f_help(npo),fx_help(npo)

	dimension psval(*),ppx(*),pffx(*),ppxx(*),pffxx(*),
     *  anux(*),aj(npo,*),uk(*),vk(*),ro(npo,*),xpl(npo,*),
     *  ypl(npo,*),f(*),q(*),c2(*),c3(*),ha(*),vi(*),p(*)

	character *20 apr

	do i=2,n                                                               
	psi(i)=2.*pi*(psval(i)-psval(i-1))/ha(i)
	anux(i)=-psi(i)/(2.*pi*rs0)                                         
	end do                                                                 
                                                                        
	do i=2,n                                                               
	ppxx(i)=0.5*(ppx(i)+ppx(i-1))
	pffxx(i)=0.5*(pffx(i)+pffx(i-1))
	end do                                                                 
c                                                                       
	do i=1,n                                                               
	do j=1,mp                                                              
	aj(i,j)=anux(i)                                                        
	end do                                                                 
	end do  

	do i=1,n                                                               
	do j=1,mp                                                              
	ro_help(i,j)=ro(i,j)                                                        
	end do                                                                 
	end do  

	do i=1,n                                                               
	f_help(i)=f(i)                                                             
	fx_help(i)=fx(i)                                                             
	end do                                                                 



        pt0z=-tpl
        kp=1

        CALL POLAR1(n,mp,rs0,kp,pt0z)

        CALL POLAR1(n,mp,rs0,kp,pt0z)


	do i=1,n                                                               
	do j=1,mp                                                              
	xpl(i,j)=um+ro(i,j)*(uk(j)-um)                                         
	ypl(i,j)=vm+ro(i,j)*(vk(j)-vm)                                         
	end do                                                                 
	end do                                                                 
c                                                                       
	f(n)=bt0                                                          
                                                                        
	fsqrt0=f(n)**2                                                         
c                                                                       
	do i0=2,n                                                              
	i=n-i0+2                                                               
	fprime=-pffxx(i)                                                         
	fhelp=fprime*(psi(i)/(2.*pi*rs0))                                      
	fsqrt=fsqrt0-fhelp*ha(i)                                               
	fsqrt0=fsqrt                                                           
	f(i-1)=sqrt(fsqrt)                                                     
	end do                                                                 
                                                                        
	do i=2,n                                                               
	fx(i)=0.5*(f(i)+f(i-1))                                                
	end do                                                                 
	fx(1)=fx(2)                                                            
                                                                        
	do i=1,n                                                               
	f(i)=fx(i)                                                             
	end do                                                                 
c                                                                       
	call midc(n,mp,rs0)
	                                                    
	tok=0.                                                                 
	co_n=1.                                                                
	do i=2,n                                                               
	if(i.eq.n)co_n=0.5                                                     
        TOK=tok-co_n*coef*( PPxx(I)*VI(I)/RS0 +                           
     *  0.5*PFFxx(I)*RS0*2.*PI*c3(i) )*ha(i)                              
	end do     
	                                                            
	tpl_1=-coef*c2(n)*psi(n)                                               
	if(kpr.eq.1)print *,'tpl tok tpl_1 ',tpl,tok,tpl_1                    
	err_tpl=abs(tpl-tpl_1)/tpl                                             
                                                                        
	al1=tpl/tok                                                            
                                                                        
	do i=1,n                                                               
	ppx(i)=al1*ppx(i)                                                      
	pffx(i)=al1*pffx(i)                                                    
	end do                                                                 
                                                                                                                                                
	do i=2,n                                                               
	fx(i)=f(i)                                                             
	pfi=2.*pi*rs0*c3(I)*fx(i)                                           
	q(i)=-pfi/psi(i)                                                    
	end do                                                                 
                                                                        
c                                                                       
	fsqrt0=p(n)                                                            
	do i0=2,n                                                              
	i=n-i0+2                                                               
	pprime=-ppxx(i)                                                          
	fhelp=pprime*(psi(i)/(2.*pi*rs0))                                      
	fsqrt=fsqrt0-fhelp*ha(i)                                               
	fsqrt0=fsqrt                                                           
	p(i-1)=fsqrt                                                           
	end do                                                                 
                                                                        
	apr='** p**'
	if(kpr.eq.1)print 71,apr,(p(i),i=1,n)   
	apr='** f**'
	if(kpr.eq.1)print 71,apr,(f(i),i=1,n)   
	apr='** q**'
	if(kpr.eq.1)print 71,apr,(q(i),i=1,n)   


	do i=1,n                                                               
	do j=1,mp                                                              
	ro(i,j)=ro_help(i,j)                                                        
	end do                                                                 
	end do  


	do i=1,n                                                               
	f(i)=f_help(i)                                                             
	fx(i)=fx_help(i)                                                             
	end do       


                                                                        
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))                                      




	return
	end


	subroutine te0_write(key_file_xx)
	include 'double.inc'
	include 'new_com.inc'

	call te0_write_c(key_file_xx,
     *  n,pne,dm0,a,
     *  u_nor,kpr,nr,nz,x,y)

	return
	end
	 
	subroutine te0_write_c(key_file,
     *  n,te0,dm0,a,
     *  psi_nor,kpr,nr,nz,r,z)

	parameter ( npo=1000 )

	include 'double.inc'

	dimension te0(*),dm0(*),a(*),psi_nor(nr,nz),r(*),z(*)

	dimension te0_psi(npo),poa(npo),te0rz(nr,nz)

	character *12 apr
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))


	neqdsk=41

	if(key_file.eq.1)
     *	open (unit=neqdsk,file='file1.dat',form='formatted')
	if(key_file.eq.2)
     *	open (unit=neqdsk,file='file2.dat',form='formatted')
	if(key_file.eq.3)
     *	open (unit=neqdsk,file='file3.dat',form='formatted')

	poa(1)=0.
	do i=2,n
	dpoa= (dm0(i)-dm0(1))/(dm0(n)-dm0(1))
	poa(i)=dpoa
	end do


	do i=2,n-1
	call feet_p(n,te0,te0_psi(i),poa,a(i))
	end do

      te0_psi(1)=te0(1)
      te0_psi(n)=te0(n)

	apr='** te0_psi**'
	if(kpr.eq.1)print 71,apr,(te0_psi(i),i=1,n)   

	apr='** poa**'
	if(kpr.eq.1)print 71,apr,(poa(i),i=1,n)   

	apr='** r**'
	if(kpr.eq.1)print 71,apr,(r(i),i=1,nr)   

	apr='** z**'
	if(kpr.eq.1)print 71,apr,(z(i),i=1,nz)   

      do i=1,nr
      do j=1,nz

      psi_n=1.d0-psi_nor(i,j)
      if(psi_n.le.1.d-8)then
      
       te0rz(i,j)=te0_psi(1)

      else
	call feet_p(n,te0_psi,te0rz(i,j),a,psi_n)
      end if
      
      if(psi_n.ge.0.999d0)then
!        te0rz(i,j)=te0_psi(n)
        te0rz(i,j)=0.d0
      end if
      
!      if(kpr.eq.1)print *,' i j psi te0=',i,j,psi_n,te0rz(i,j)
      if(psi_n.lt.0.d0)then
      if(kpr.eq.1)print *,' i j psi_nor te0=',
     *  i,j,psi_nor(i,j),te0rz(i,j)      
      stop
      end if
      
      end do
      end do


ccc     	write (neqdsk,*)nr,nz
	write (neqdsk,*)'r[cm]   z[cm]   Ne[19]'
     	do i=1,nr
     	do j=1,nz      
     	write (neqdsk,*)r(i),z(j),te0rz(i,j)
     	end do
     	end do
     	
      
2020  format (5e16.9)


      return
      end
      
      
