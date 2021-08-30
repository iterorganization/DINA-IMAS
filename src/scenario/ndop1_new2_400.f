
	subroutine tpl_cal_kav()
	include 'double.inc'
	include 'new_com.inc'                                                  
                                                                        
	call tpl_cal_kav_c(                      
     *  heli,kmaj,c20,dpsi_ax,e_pol,dl_pol)                             
                                                                        
                                                                        
	return                                                                 
	end                                                                    
                                                                        
                                                                        
	subroutine tpl_cal_kav_c(                
     *  heli,kmaj,c20,dpsi_ax,e_pol,dl_pol)    
        include 'double.inc'                   
	include 'parf0'                                                        
	include 'parf1'                                                        
	common                                                                 
     *	/n_m/n,m,mp                                                      
	common                                                                 
     *  /keys5/next                                                     
     *  /keys11/i_ramp                                                  
	common                                                                 
     *	/ge1/pi                                                          
     *  /ge2/NTAY,TAY,TT                                                
     *	/ge1e/rs0,tpl                                                    
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)                     
     *  /ge5/kpr                                                        
	common                                                                 
     *	/efit4/coef                                                      
     *	/efit6/tpl_p                                                     
	common                                                                 
     *  /mid1/C1(npo),C2(npo),C3(npo)                                   
     *  /mid2/vi(npo),spo(npo)                                          
	common                                                                 
     *  /DFM1/UDM,ZDM,L3,SIG0                                           
     *  /DFM2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)                       
     *  /dfm3/dfmax(npo),dfmax0(npo)                                    
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)            
     *  /dfm9/aj0(npo)                                                  
	common                                                                 
     *  /pol2/Qx(npo),ANUx(npo),Px(npo),Fx(npo),                        
     *   PPxx(npo),PFFxx(npo)                                           
     *  /pol5/psend                                                     
	common                                                                 
     *  /eq11/psval(npo),psval0(npo)                                    
     *  /eq15/pll,zsep,rsep,zmax,rmax,zmin,rmin                         
     *  /eq15e/pll0,tpl0,udd                                            
	common                                                                 
     *  /fluxc9/fdd,fdd0                                                
	common                                                                 
     *  /halo2e/next0,li_drop,n_li,n_dif,nmix                           
	common                                                                 
     *  /ramp1/fdd_ind                                                  
        common                                                          
     *  /pf1/npf,pf(kf),pf0(kf)                                         
                                                                        
	dimension c20(*),c20_help(npo),e_pol(*),dl_pol(*)                      
                                                                        
	dimension a_print(200)
	character *30 apr                                                      
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))                                      
                                                                        
                                                                        
!	if(kpr.eq.1)print *,' ntay li_drop n_dif kmaj ',ntay,li_drop,n_dif,kma
                                                                        
	i_en=i_en+1                                                            
	if(i_en.eq.1)pll_help=pll                                              
               
			                                                          
!	pll=pll_help                                                       
          
!      pll=1000.d0                                                              

c	pll=0.5d0*(pll+pll0)
                                                                        
c	al1=2.*pi*(psval(1)-psval(n))/(dm0(1)-dm0(n))                         
                                                                        
c	do i=1,n                                                              
c	   dm0(i)=dm0(i)*al1                                                  
c	end do                                                                
                                                                        
	if(n_dif.eq.0)then                                                     
                                                                        
 2	continue                                                             
                                                                        
                                                                        
                                                                        
	UDM=0.                                                                 
	ZDM=tpl*4.*PI/( 10.*F(n) )                                             
	L3=3                                                                   
!        if(kpr.eq.1)print *,'  udm zdm l3',udm,zdm,l3                  

	udd_ex0=udd_ex
                                                                       
	udd_ex=-(fdd-fdd0)/(tay*100.)                                          
          
c        udd=0.5d0*(udd_ex +udd_ex0)  
		
		                                                              
         udd=udd_ex
	  
c   	  udd=2.0d0


c	udd=20.d0	                                                     
                                                                        
c###                                                                    
                                                                        
c	if(ntay.le.ndisrup.and.kmaj.eq.1)udd=0.                               
                                                                        
c	if(ntay.gt.ndisrup.and.n_dif.eq.0.and.kmaj.eq.1)call udd_filter()     
c###                                                                    
                                                                        
c        udd=0.                                                      
                                                                        
        udd_psval=-( 2.*pi*( psval(1)-psval0(1) )                       
     *  -( dm0(1)-dmn(1) ) )/(tay*100.)                                 
                                                                        
                                                                        
                                                                        
                                                                        
c	if(ntay.gt.li_drop)udd=udd_ex+udd_psval                               
c	udd=udd_ex+udd_psval                                                  
                                                                        
!        if(kpr.eq.1)print *,' pll pll0 udd_ex udd_psval',pll,pll0,udd_e
                                                                        
!        if(kpr.eq.1)print *,' udd fdd fdd0 ',udd,fdd*1.e-5,fdd0*1.e-5  
                                                                        
	udd_tor=-(dfmax(n)-dfmax0(n))/(q(n)*100.*tay)                          

	udd_tor1=-0.5d0*( (dfmax(n)-dfmax0(n))+
     *  ( dfmax(n-1)-dfmax0(n-1)) )/(q(n)*100.*tay)                          
                                                                        
c	udd=udd+udd_tor                                                       
                                                                        
c	print *,' udd udd_ex udd_tor==',udd,udd_ex,udd_tor                      
                                                                        
	do i=2,n                                                               
!	e_pol(i)=-(dfmax(i)-dfmax0(i))/dl_pol(i)                               
	end do                                                                 
                                                                        
                                                                        
!        if(kpr.eq.1)print *,'  tpl tpl0',tpl,tpl0                      
!        if(kpr.eq.1)print *,' next ntay ',next,ntay                    
                                                                        
	if(ntay.gt.next)then                                                   
!        if(kpr.eq.1)print *,' pll pll0 udd ',pll,pll0,udd              
!        if(kpr.eq.1)print *,'  tpl tpl0',tpl,tpl0                      
	UDM=4.*PI/( 10.*PLL*f(n) )                                             
                                                                        
	ZDM=UDM*(-DMN(n)+pll0*tpl0+udd*tay*100. )                              
                                                                        
c	al1=dm0(n)/(tpl*pll+fdd)                                              
                                                                        
c	ZDM=UDM*(-fdd*al1 )                                                   
                                                                        
!        if(kpr.eq.1)print *,'  udm zdm l3',udm,zdm,l3                  
	end if                                                                 
                                                                        
                                                                        
	CALL DIFMF_3(n)    
	                                                    
!	if(kpr.eq.1)print *,' tpl tpl_in dmn dm0',tpl,tpl_in,dmn(n),dm0(n)    
                                                                        
                                                                        
c!!!	if(ntay.gt.0)CALL DIFMF_2(n)                                       
                                                                        
                                                                        
	dpsi_ax=(dm0(1)-dmn(1))/(2.*pi)                                        
                                                                        
	if(i_en.eq.1)then                                                      
	CALL TOKK(N,RS0)                                                       
	do i=2,n                                                               
	c20_help(i)=c20(i)                                                     
	end do                                                                 
	end if                                                                 
                                                                        
                                                                        
	if(ntay.le.-next)then                                                  
	do i=2,n                                                               
	psi(i)=-c20_help(i)/c2(i)	                                             
	dm0(i)=dm0(i-1)+psi(i)*ha(i)                                           
	dmn(i)=dm0(i)                                                          
	q(i)=-pfi(i)/psi(i)                                                    
	end do                                                                 
	end if                                                                 
                                                                        
	do i=1,n                                                               
	qx(i)=q(i)                                                             
	end do                                                                 
                                                                        
	tpl_tor=-coef*c2(n)*psi(n)                                             
	if(ntay.gt.next)tpl=tpl_tor                                            
!	if(kpr.eq.1)print *,' tpl tpl_tor ==',tpl,tpl_tor                     
c------------------                                                     
	udd_pl=-(tpl*pll-tpl0*pll0)/(tay*100.)                                 
!	if(kpr.eq.1)print *,' udd_pf udd_pl',udd,udd_pl                       
        udd_tot=udd+udd_pl                                              
c------------------                                                     
	udd_dif=-(dm0(n)-dmn(n))/(tay*100.)                                    
                                                                        
	udd_dif1=udd_dif+udd_tor                                               
                                                                        
	udd_ps=-2.*pi*(psval(n)-psval0(n))/(tay*100.)                          
c	print *,' udd_dif udd_dif1 udd_ps',                                   
c     *  udd_dif,udd_dif1,udd_ps                                        
                                                                        
	u_ax=-(dm0(1)-dmn(1))/(tay*100.)                                       
	udd_psa=-2.*pi*(psval(1)-psval0(1))/(tay*100.)                         
                                                                        

c	a_print(1)=u_ax
c	a_print(2)=udd_psa
	a_print(1)=udd_dif
	a_print(2)=udd_ps
	a_print(3)=udd
	a_print(4)=pll
	a_print(5)=pll0
	a_print(6)=udd_tor1
	n_pr=5


	apr='u_dif u_ps udd pll pll0'

	num=25

	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)


c        print *,' u_ax udd_psa ',u_ax,udd_psa                          
c-------------                                                          
	q_b=q(n)                                                               
                                                                        
	call hel()                                                             
	hel_0=heli                                                             
!	if(kpr.eq.1)print *,' heli hel_0',heli,hel_0                          
                                                                        
	end if                                                                 
                                                                        
	if(n_dif.eq.1)then                                                     
                                                                        
	   udd=0.                                                              
                                                                        
	do i=1,nmix                                                            
	q(i)=q(nmix)                                                           
	end do                                                                 
                                                                        
        dm0(1)=2.*pi*psval(1)                                           
                                                                        
	do i=2,n                                                               
	psi(i)=-pfi(i)/q(i)                                                    
	dm0(i)=dm0(i-1)+psi(i)*ha(i)                                           
	dmn(i)=dm0(i)                                                          
	end do                                                                 
                                                                        
	call hel()                                                             
                                                                        
!	if(kpr.eq.1)print *,' q(n) q_b dfmax',q(n),q_b,dfmax(n)*1.e-5         
	                                                                       
!	if(kpr.eq.1)print *,' heli hel_0',heli,hel_0                          
                                                                        
                                                                        
	al1=sqrt(heli/hel_0)                                                   
                                                                        
	apr='q(i)'                                                             
!	if(kpr.eq.1)print 71,apr,(q(i),i=1,n)                                 
                                                                        
	do i=1,n                                                               
	q(i)=q(i)*al1                                                          
	end do                                                                 
                                                                        
	do i=1,n                                                               
	qx(i)=q(i)                                                             
	end do                                                                 
                                                                        
c-------                                                                
        dm0(1)=2.*pi*psval(1)                                           
                                                                        
	do i=2,n                                                               
	psi(i)=-pfi(i)/q(i)                                                    
	dm0(i)=dm0(i-1)+psi(i)*ha(i)                                           
	dmn(i)=dm0(i)                                                          
	end do                                                                 
                                                                        
	tpl=-coef*c2(n)*psi(n)                                                 
c                                                                       
	apr='q(i)'                                                             
!	if(kpr.eq.1)print 71,apr,(q(i),i=1,n)                                 
                                                                        
!	if(kpr.eq.1)print *,' tpl q_b al1 ===',tpl,q_b,al1                    
c                                                                       
	end if                                                                 
                                                                        
	return                                                                 
	end                                                                    
      subroutine tpl_cal()
      include 'double.inc'
	include 'new_com.inc'

	call tpl_cal_c(
     *  heli,kmaj,dpsi_ax)


	return
	end


	subroutine tpl_cal_c(
     *  heli,kmaj,dpsi_ax)

      include 'double.inc'
	include 'parf0'
	include 'parf1'
	common
     *	/n_m/n,m,mp
	common
     *  /keys5/next
     *  /keys11/i_ramp
	common
     *	/ge1/pi
     *  /ge2/NTAY,TAY,TT
     *	/ge1e/rs0,tpl
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
     *  /ge5/kpr
	common
     *	/efit4/coef
     *	/efit6/tpl_p
	common
     *  /mid1/C1(npo),C2(npo),C3(npo)
     *  /mid2/vi(npo),spo(npo)
	common
     *  /DFM1/UDM,ZDM,L3,SIG0
     *  /DFM2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)
     *  /dfm3/dfmax(npo),dfmax0(npo)
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)
     *  /dfm9/aj0(npo)
	common
     *  /pol2/Qx(npo),ANUx(npo),Px(npo),Fx(npo),
     *   PPxx(npo),PFFxx(npo)
     *  /pol5/psend
	common
     *  /eq11/psval(npo),psval0(npo)
     *  /eq15/pll,zsep,rsep,zmax,rmax,zmin,rmin
     *  /eq15e/pll0,tpl0,udd
	common
     *  /fluxc9/fdd,fdd0
	common
     *  /halo2e/next0,li_drop,n_li,n_dif,nmix
	common
     *  /ramp1/fdd_ind
        common
     *  /pf1/npf,pf(kf),pf0(kf)

	dimension a_print(200)
	character *30 apr                                                      
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))


	if(kpr.eq.1)
     *       print *,' ntay li_drop n_dif kmaj ',ntay,li_drop,n_dif,kmaj

	i_en=i_en+1
	if(i_en.eq.1)pll_help=pll

!	pll=pll_help
      
!      pll=1000.d0
      

	if(n_dif.eq.0)then

	UDM=0.
	ZDM=tpl*4.*PI/( 10.*F(n) )
	L3=3
        if(kpr.eq.1)print *,'  udm zdm l3',udm,zdm,l3

	udd_ex=-(fdd-fdd0)/(tay*100.)

        udd=udd_ex

c###

!	if(ntay.le.ndisrup.and.kmaj.eq.1)udd=0.

c	if(ntay.gt.ndisrup.and.n_dif.eq.0.and.kmaj.eq.1)call udd_filter()
c###

c!!!        udd=0.

        udd_psval=-( 2.*pi*( psval(1)-psval0(1) ) 
     *  -( dm0(1)-dmn(1) ) )/(tay*100.)



c	if(ntay.gt.li_drop)udd=udd_ex+udd_psval
c	udd=udd_ex+udd_psval

        if(kpr.eq.1)
     *    print *,' pll pll0 udd_ex udd_psval',pll,pll0,udd_ex,udd_psval

        if(kpr.eq.1)print *,' udd fdd fdd0 ',udd,fdd*1.e-5,fdd0*1.e-5

	udd_tor=-(dfmax(n)-dfmax0(n))/(q(n)*100.*tay)

c	udd=udd-udd_tor

	if(kpr.eq.1)print *,' udd udd_tor==',udd,udd_tor


        if(kpr.eq.1)print *,'  tpl tpl0',tpl,tpl0
        if(kpr.eq.1)print *,' next ntay ',next,ntay

	if(ntay.gt.next)then
        if(kpr.eq.1)print *,' pll pll0 udd ',pll,pll0,udd
        if(kpr.eq.1)print *,'  tpl tpl0',tpl,tpl0
	UDM=4.*PI/( 10.*PLL*f(n) )
	ZDM=UDM*(-DMN(n)+pll0*tpl0+udd*tay*100. )
        if(kpr.eq.1)print *,'  udm zdm l3',udm,zdm,l3
	end if

!	CALL DIFMF_1(n)
	CALL DIFMF_1()
	if(kpr.eq.1)print *,' dmn dm0',dmn(n),dm0(n)

           dpsi_ax=(dm0(1)-dmn(1))/(2.*pi)
c
	do i=1,n
	qx(i)=q(i)
	end do

	tpl_tor=-coef*c2(n)*psi(n)
	if(ntay.gt.next)tpl=tpl_tor
	if(kpr.eq.1)print *,' tpl tpl_tor ==',tpl,tpl_tor
c------------------
	udd_pl=-(tpl*pll-tpl0*pll0)/(tay*100.)
	if(kpr.eq.1)print *,' udd_pf udd_pl',udd,udd_pl
        udd_tot=udd+udd_pl
c------------------
	udd_dif=-(dm0(n)-dmn(n))/(tay*100.)
	udd_ps=-2.*pi*(psval(n)-psval0(n))/(tay*100.)
	if(kpr.eq.1)print *,' udd_dif udd_ps',udd_dif,udd_ps
c-------------
	q_b=q(n)

	u_ax=-(dm0(1)-dmn(1))/(tay*100.)
	udd_psa=-2.*pi*(psval(1)-psval0(1))/(tay*100.)

	a_print(1)=udd_dif
	a_print(2)=udd_ps
	a_print(3)=udd
	a_print(4)=pll
	n_pr=4

	apr='u_dif u_ps udd pll '

	num=20

	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)


        if(kpr.eq.1)print *,' u_ax udd_psa ',u_ax,udd_psa

	call hel()
	hel_0=heli
	if(kpr.eq.1)print *,' heli hel_0',heli,hel_0

	end if

	if(n_dif.eq.1)then

	   udd=0.

	do i=1,nmix
	q(i)=q(nmix)
	end do

        dm0(1)=2.*pi*psval(1)

	do i=2,n
	psi(i)=-pfi(i)/q(i)
	dm0(i)=dm0(i-1)+psi(i)*ha(i)
	dmn(i)=dm0(i)
	end do

	call hel()

	if(kpr.eq.1)print *,' q(n) q_b dfmax',q(n),q_b,dfmax(n)*1.e-5
	
	if(kpr.eq.1)print *,' heli hel_0',heli,hel_0


	al1=sqrt(heli/hel_0)

	apr='q(i)'
	if(kpr.eq.1)print 71,apr,(q(i),i=1,n)

	do i=1,n
	q(i)=q(i)*al1
	end do

	do i=1,n
	qx(i)=q(i)
	end do

c-------
        dm0(1)=2.*pi*psval(1)

	do i=2,n
	psi(i)=-pfi(i)/q(i)
	dm0(i)=dm0(i-1)+psi(i)*ha(i)
	dmn(i)=dm0(i)
	end do

	tpl=-coef*c2(n)*psi(n)
c
	apr='q(i)'
	if(kpr.eq.1)print 71,apr,(q(i),i=1,n)

	if(kpr.eq.1)print *,' tpl q_b al1 ===',tpl,q_b,al1
c
	end if

	return
	end

	subroutine hel()
      include 'double.inc'
	include 'new_com.inc'

	call hel_c(
     *  n,dm0,q,pfi,ha,heli,pi )


	return
	end

	subroutine hel_c(
     *  n,dm0,q,pfi,ha,heli,pi )

      include 'double.inc'
	include 'parf0'

        common
     *  /ge5/kpr
	dimension dm0(*),q(*),pfi(*),ha(*)

	character *12 apr

	q(1)=q(2)

	psend=(dm0(1)-dm0(n))

	q_h=0.
	q_ph=0.
	do i=2,n
	   q_h=q_h+pfi(i)*ha(i)/psend

	   psv=(dm0(1)-dm0(i))/psend

c###	   psv=dm0(i)/psend
	   q_ph=q_ph+pfi(i)*ha(i)*psv/psend
	end do

	heli=(q_h-q_ph)*(psend*1.e-5)**2

	if(kpr.eq.1)
     *       print *,' q_h  q_ph  heli psend',q_h,q_ph,heli,psend*1.e-5
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

	return
	end
	subroutine hel_old()
      include 'double.inc'
	include 'new_com.inc'

	call hel_old_c(
     *  n,dm0,q,psval,ha,ai,psend,heli,pi      )


	return
	end

	subroutine hel_old_c(
     *  n,dm0,q,psval,ha,ai,psend,heli,pi      )

      include 'double.inc'
	include 'parf0'
        common
     *  /ge5/kpr
	dimension qz(npo),poa(npo),aiz(npo)

	dimension dm0(*),q(*),psval(*),ha(*),ai(*)

	character *12 apr

	poa(1)=0.
	do i=2,n
	dpoa= (dm0(i)-dm0(1))/(dm0(n)-dm0(1))
	poa(i)=sqrt(dpoa)
	aiz(i)=0.5*(poa(i)+poa(i-1))
	end do

	q(1)=q(2)

c*** recalculate in poloidal coordinate system q
	

 	ateta=1.
	ai(n+1)=1.
        call inter_h0(q,ai,n-1,ateta,val)
	q(n+1)=val


	do i=2,n
	call feeti(n+1,q,qz(i),aiz,ai(i))
	end do

	apr='-q-'
c	if(kpr.eq.1)print 71,apr,(q(i),i=1,n+1)

	apr='-qz-'
c	if(kpr.eq.1)print 71,apr,(qz(i),i=1,n)

	apr='-aiz-'
c	if(kpr.eq.1)print 71,apr,(aiz(i),i=1,n)

	qz(1)=qz(2)
	qz(n)=q(n)

	psend=(psval(n)-psval(1))*2.*pi*2.*ai(n)

	q_h=0.
	q_ph=0.
	do i=2,n
	   q_h=q_h+qz(i)*ha(i)
	   psv=2.*pi*0.5*(psval(i)+psval(i-1))
	   q_ph=q_ph+qz(i)*ha(i)*psv/psend
	end do

	heli=(q_h-q_ph)*(psend*1.e-5)**2

	if(kpr.eq.1)
     *       print *,' q_h  q_ph  heli psend',q_h,q_ph,heli,psend*1.e-5
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

	return
	end


	subroutine pff_corr()
      include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *	/efit4/coef
	common
     *  /DFM2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)
	common
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)
     *  /dfm11/c20(npo),tok1(npo),tok2(npo)
     *  /dfm12/betj,dlint,bett,bet2,betpc,tk,tkp,tkf
     *	/dfm15/uli
        COMMON
     *  /mid1/C1(npo),C2(npo),C3(npo)
     *  /mid2/vi(npo),spo(npo)
	common
     *	/ge1/pi
     *	/ge1e/rs0,tpl
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
     *  /ge5/kpr

	dimension psi_help(npo),tok_help(npo)


	character *20 apr



	do i=1,n
	   psi_help(i)=psi(i)
	end do

	CALL BTA(n,mp,RS0)

	betp_help=betj
	uli_help=uli

	i_en=i_en+1
	if(i_en.eq.1)x0=0.1
	alf=4.


	DKOF=10./(4.*PI)

	if(kpr.eq.1)print *,' DKOF==',dkof

	int=0

	x_0=0.7


 1	continue

	a_a=-x0
	b_b=(3.*a_a*x_0**2-a_a)/(1.-x_0)
	c_c=-(a_a+b_b)

	tok_help(2)=0.

	do i=2,n-1

c	   tok1(i)=(1.-ai(i)**alf)-x0*(ai(i)**2-ai(i))

	   f_f=a_a*ai(i)**3+b_b*ai(i)**2+c_c*ai(i)

	   tok1(i)=(1.-ai(i)**alf)+f_f

	   tok_help(i+1)=tok_help(i)+tok1(i)*0.5*(spo(i)*ha(i)+
     *  spo(i+1)*ha(i+1))

	end do

	tok=0.
	do i=2,n
	tok=tok+tok1(i)*spo(i)*ha(i)
	end do

c	tok=tok-0.5*tok1(n)*spo(n)*ha(n)

	al1=tpl/tok

	do i=2,n
	   tok_help(i)=tok_help(i)*al1
	   tok1(i)=tok1(i)*al1
	   psi(i)=-tok_help(i)/(c2(i)*dkof)
	end do

	tok1(1)=tok1(2)

	if(kpr.eq.1)print *,' TPL==',tok_help(n)

	
	do  I=2,N
	PFF(I)=-2.*spo(i)/(c3(i)*2.*pi*rs0)*
     *  (TOK1(I)/dkof+PP(I)*VI(I)/(RS0*SPO(I)))

	end do
c
	tok=0.
	do i=2,n
	TOK=tok-coef*( PP(I)*VI(I)*ha(I)/RS0+
     *  0.5*PFF(I)*RS0*2.*PI*c3(i)*ha(I) )
	end do

	if(kpr.eq.1)print*,'x0 tok=-(pp+pff)=',x0,tok

	CALL BTA(n,mp,RS0)

	d_uli=abs(uli_help-uli)/uli_help
	
	if(kpr.eq.1)print *,' uli_help uli d_uli x0',uli_help,uli,d_uli,x0

	apr=' ** tok1 '
	if(kpr.eq.1)print 71,apr,(tok1(i),i=1,n)

	if(d_uli.gt.1.e-2)then

	   d_x0=1.*(uli_help-uli)

	   x0=x0-d_x0

	   int=int+1
	   if(int.gt.100)go to 2
	   go to 1
	end if

 2	continue
c
	apr='pff'
	if(kpr.eq.1)print 71,apr,(pff(i),i=1,n)

c!	stop

	do i=1,n
	   psi(i)=psi_help(i)
	end do

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))
	return
	end
	subroutine pf_volt()

      include 'double.inc'
	include 'new_com.inc'

	call pf_volt_c(
     *  pf_volts,vchopper)

	
	return
	end
	subroutine pf_volt_c(
     *  pf_volts,vchopper)
c--------------------------------------------
c  calculate pf currents
c--------------------------------------------
      include 'double.inc'
	include 'parf1'
	common
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /pf6/pves(kf),pves0(kf)
     *  /pf8/pfind(kf,kf),pfres(kf),a1(kf,kf),e1(kf),e2(kf)
	common
     *  /ves1/psp(mu),psp0(mu),tcam(mu),tcam0(mu)
     *  /ves2/ncam,rc(mu),zc(mu)
     *  /ves5/pfc(mu,kf)
c
	common
     *  /pf7/plasma(kf),plasma0(kf)
c
	common
     *  /ge2/ntay,tay,tt
     *  /ge5/kpr
c
	dimension fu(kf),f(kf),pfhelp(kf)

	dimension pf_volts(*),vchopper(*)

	character *70 apr

	beta=1.
	alf=1.
	

c***********************
c   vessel flux   ****************
	do i=1,npf
ccc	do i=1,npf-4
	pves(i)=0.
	end do
	do j=1,npf
ccc	do j=1,npf-4
	do i=1,ncam
	pves(j)=pves(j)+pfc(i,j)*tcam(i)
	end do
	end do

	i_en=i_en+1
	if(i_en.eq.1)then
	   do j=1,npf
ccc	   do j=1,npf-4
	      pves0(j)=pves(j)
	      plasma0(j)=plasma(j)
	      pf0(j)=pf(j)
	   end do
	end if

c
	apr='pves'
c	if(kpr.eq.1)print 71,apr,(pves(j),j=1,npf)
	apr='pves0'
c	if(kpr.eq.1)print 71,apr,(pves0(j),j=1,npf)

c******
c!!!	if(ntay.lt.2)return
c
	volt_pl=0.
	volt_ves=0.
	volt_pf=0.

	do i=1,npf
ccc	do i=1,npf-4
	fu(i)=0.
	volt_pl=volt_pl-beta*(plasma(i)-plasma0(i))
	volt_ves=volt_ves-alf*(pves(i)-pves0(i))
c
	do j=1,npf
ccc	do j=1,npf-4
	volt_pf=volt_pf-pfind(i,j)*(pf(j)-pf0(j))
	fu(i)=fu(i)+pfind(i,j)*(pf(j)-pf0(j))
	end do
c
	fu(i)=fu(i)+beta*(plasma(i)-plasma0(i))+alf*(pves(i)-pves0(i))
	
	fu(i)=fu(i)+pfres(i)*pf(i)*1.e5*tay

	end do
c***************************************************************
c    chopper voltage
c	
	do i=1,npf
	pf_volts(i)=fu(i)/(100.*tay)
	end do
c
c        print*,'from gen'
c	apr='PF_VOLTS'
c	if(kpr.eq.1)print 71,apr,(pf_volts(i),i=1,npf)
c	apr='CHOP_VOLTS'
c	if(kpr.eq.1)print 71,apr,(vchopper(i),i=1,npf)


71	format(5x,a70/,(1X,6(1pe11.3)))

	volt_pl=volt_pl/(tay*100.)
	volt_pf=volt_pf/(tay*100.*npf)
	volt_ves=volt_ves/(tay*100.*ncam)
        if(kpr.eq.1)print *,' volt_pl volt_ves volt_pf ',volt_pl,
     *  volt_ves,volt_pf

c	pause 'from pf_volt'

	return
	end


	subroutine ihalo_calc()
        include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *  /DFM2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)

	common
     *  /halo5/q_vde,q_95,del_f,i_halo

	common
     *  /eq11/psval(npo),psval0(npo)

	common
     *	/ge1e/rs0,tpl
     *  /ge2/NTAY,TAY,TT
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
     *  /ge5/kpr


	dpo_a= (psval(n+1)-psval(1))/(psval(n)-psval(1))
	dpo_a=sqrt(dpo_a)

	do i=2,n
	dpoa= (dm0(i)-dm0(1))/(dm0(n)-dm0(1))
	dpoa=sqrt(dpoa)

	if(dpoa.ge.dpo_a)then
	i_halo=i
	go to 1
	end if

	end do

1	continue
	if(kpr.eq.1)print *,' dpo_a dpoa==',dpo_a,dpoa
	return
	end

	subroutine transf_bound()
        include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *	/ge1/pi
     *  /ge2/NTAY,TAY,TT
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
	common
     *	/efit4/coef
	common
     *  /eq4/xpl(npo,ntet),ypl(npo,ntet)
	common
     *	/ge1e/rs0,tpl
     *  /ge5/kpr
	common
     *  /pol1/RO(npo,ntet),AJ(npo,ntet)
     *  /pol2/Qx(npo),ANUx(npo),Px(npo),Fx(npo),
     *   PPxx(npo),PFFxx(npo)
     *  /pol4/UM,VM,UK(ntet),VK(ntet)
     *  /pol5/psend
     *  /pol5e/um1,vm1,um2,vm2
     *  /pol6/ppx(npo),pffx(npo)
	common
     *  /DFM2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)
     *  /dfm3/dfmax(npo),dfmax0(npo)
     *  /dfm3e/dfmaxc(npo),dfmaxh(npo)
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)
     *  /dfm7/bt0,uind
     *  /dfm7e/bt0_0,f_na
        COMMON
     *  /mid1/C1(npo),C2(npo),C3(npo)
     *  /mid2/vi(npo),spo(npo)
     *  /mid2e/vol(npo),spov(npo),pcur(npo)
     *  /mid3/GRA1(npo),GRA2(npo)
	common
     *  /en1/PNE(npo),PD0(npo),PT0(npo),PH0(npo),PDN(npo),
     *  PTN(npo),PHN(npo)
     *  /en1e/te_a,ti_a,te_b,ti_b,pw_e
     *  /en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),WE0(npo),
     *  WQ0(npo)
     *  /en33/anom_e,anom_i,key_t11,kcchp
	common
     *  /halo4/expfg,avalb,w_h,del_r,al0
     *  /halo5/q_vde,q_95,del_f,i_halo
     *  /halo9/fluxt,fluxt0
     *  /halo9e/dfmax_h
     *  /halo10/fves,fves0,self_v
     *  /halo11/fmaxv,fmaxv0

	dimension qz(npo),poa(npo),aiz(npo)
	dimension dfmax_help(npo)

	character *12 apr

	do i=1,n
	do j=1,mp
	ro(i,j)=a(i)
	end do
	end do

1	continue

c---------------------

	do i=1,n
	do j=1,mp
	xpl(i,j)=um+ro(i,j)*(uk(j)-um)
	ypl(i,j)=vm+ro(i,j)*(vk(j)-vm)
	end do
	end do

	call midc(n,mp,rs0)

	tpl_i=-coef*c2(n)*psi(n)
	
	al1=tpl/tpl_i
	
	do i=2,n
c!!!	   psi(i)=psi(i)*al1
	end do


	if(kpr.eq.1)print *,'tpl tpl_i=c2*psi(n)',tpl,tpl_i
	err_t=abs(tpl-tpl_i)/tpl


	d11=pi*rs0*c3(n)/ai(n)

	fmax_ref=f(n)*d11
 
	dfmax(1)=0.
	do i=2,n
c!!!	f(i)=ai(i)*fmax/(c3(i)*pi*rs0)                                         
        fx(i)=f(i)
	dfmax_help(i)=dfmaxc(i)
	pfi(i)=2.*pi*rs0*c3(I)*fx(i)
	end do

c--- transref to toroidal coordinates---
c
	dfmaxc(1)=0.
	do i=2,n
	dfmaxc(i)=dfmaxc(i-1)+pfi(i)*ha(i)
	end do
c
	fmax=dfmaxc(n)
c-----------------------------

	poa(1)=0.
	aiz(1)=0.
	do i=2,n
	poa(i)=sqrt( dfmaxc(i)/fmax)
	dfmaxc_m=0.5*(dfmaxc(i)+dfmaxc(i-1))
c	aiz(i)=sqrt( dfmaxc_m/fmax )
	aiz(i)=0.5*(poa(i)+poa(i-1))
	end do
	aiz(n+1)=poa(n)

c---->  ro(i,j) variable...
c
	do j=1,mp
	do i=1,n
	qz(i)=ro(i,j)
	end do

	do i=2,n-1
	call feet_p(n,qz,ro(i,j),poa,a(i))
	end do

	end do


	apr='-poa-'
c	if(kpr.eq.1)print 71,apr,(poa(i),i=1,n)
	apr='-a-'
c	if(kpr.eq.1)print 71,apr,(a(i),i=1,n)

	apr='-dfmax_h-'
c	if(kpr.eq.1)print 71,apr,(dfmax_help(i),i=1,n)
	apr='-dfmaxc-'
c	if(kpr.eq.1)print 71,apr,(dfmaxc(i),i=1,n)

	err=0.
	do i=2,n
	diff=abs(poa(i)-a(i))/a(i)
	err=amax1(err,diff)
	end do

	errp=0.
	do i=2,n
	diff=abs(dfmax_help(i)-dfmaxc(i))/dfmaxc(i)
	errp=amax1(errp,diff)
	end do


	if(kpr.eq.1)
     *       print *,' fmax fmax_ref  ======',fmax*1.e-5,fmax_ref*1.e-5


	if(kpr.eq.1)print *,' errp err err_t ',errp,err,err_t

	if(err.gt.1.e-3)go to 1

c!!!	if(errp.gt.1.e-3)go to 1

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))
	return
	end
	subroutine ptoke_res()
        include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *	/ge1/pi
     *  /ge2/NTAY,TAY,TT
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
     *  /ge5/kpr
	common
     *	/efit4/coef
     *	/efit5/it1,it2
	common
     *  /eq4/xpl(npo,ntet),ypl(npo,ntet)
     *  /eq11/psval(npo),psval0(npo)
	common
     *	/ge1e/rs0,tpl
	common
     *  /pol1/RO(npo,ntet),AJ(npo,ntet)
     *  /pol2/Qx(npo),ANUx(npo),Px(npo),Fx(npo),
     *   PPxx(npo),PFFxx(npo)
     *  /pol4/UM,VM,UK(ntet),VK(ntet)
     *  /pol5/psend
     *  /pol6/ppx(npo),pffx(npo)
	common
     *  /DFM2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)
     *  /dfm7/bt0,uind
     *  /dfm7e/bt0_0,f_na
        COMMON
     *  /mid1/C1(npo),C2(npo),C3(npo)
     *  /mid2/vi(npo),spo(npo)
     *  /mid2e/vol(npo),spov(npo),pcur(npo)
	common
     *  /halo4/expfg,avalb,w_h,del_r,al0
     *  /halo5/q_vde,q_95,del_f,i_halo
	dimension qz(npo)
	character *12 apr

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

	f(n)=bt0+f_na

	fsqrt0=f(n)**2
c
	i_halo=n
	do i0=2,n
	i=n-i0+2
	fprime=-0.5*(pffx(i)+pffx(i-1))
	if(psval(i).lt.psval(n+1))i_halo=i
	psi_i=2.*pi*(psval(i)-psval(i-1))/ha(i)
	fhelp=fprime*(psi_i/(2.*pi*rs0))
	fsqrt=fsqrt0-fhelp*ha(i)
	fsqrt0=fsqrt
	f(i-1)=sqrt(fsqrt)
	end do

c
	q_95=q(i_halo)

	del_f=f(i_halo)-f(n)
	expfg=5.*rs0*del_f
	if(kpr.eq.1)print *,' ----q_95 del_f i_halo----',q_95,del_f,i_halo
c

c  here we calculate f(i) in toroidal coordinates....

	fsqrt0=f(n)**2

	do i0=2,n
	i=n-i0+2
	fprime=-pff(i)
	fhelp=fprime*(psi(i)/(2.*pi*rs0))
	fsqrt=fsqrt0-fhelp*ha(i)
	fsqrt0=fsqrt
	f(i-1)=sqrt(fsqrt)
	end do
	do i=1,n
	fx(i)=f(i)
	end do

	apr='-pffx-'
	if(kpr.eq.1)print 71,apr,(pffx(i),i=1,n)
c-----------------
c	read (*,*)
	return
	end
c
c
	subroutine tor_data()
        include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *	/ge1/pi
     *  /ge2/NTAY,TAY,TT
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
	common
     *	/efit4/coef
	common
     *  /eq4/xpl(npo,ntet),ypl(npo,ntet)
	common
     *	/ge1e/rs0,tpl
     *  /ge5/kpr
	common
     *  /pol1/RO(npo,ntet),AJ(npo,ntet)
     *  /pol2/Qx(npo),ANUx(npo),Px(npo),Fx(npo),
     *   PPxx(npo),PFFxx(npo)
     *  /pol4/UM,VM,UK(ntet),VK(ntet)
     *  /pol5/psend
     *  /pol5e/um1,vm1,um2,vm2
     *  /pol6/ppx(npo),pffx(npo)
	common
     *  /DFM2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)
     *  /dfm3/dfmax(npo),dfmax0(npo)
     *  /dfm3e/dfmaxc(npo),dfmaxh(npo)
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)
     *  /dfm7/bt0,uind
     *  /dfm7e/bt0_0,f_na
        COMMON
     *  /mid1/C1(npo),C2(npo),C3(npo)
     *  /mid2/vi(npo),spo(npo)
     *  /mid2e/vol(npo),spov(npo),pcur(npo)
     *  /mid3/GRA1(npo),GRA2(npo)
	common
     *  /en1/PNE(npo),PD0(npo),PT0(npo),PH0(npo),PDN(npo),
     *  PTN(npo),PHN(npo)
     *  /en1e/te_a,ti_a,te_b,ti_b,pw_e
     *  /en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),WE0(npo),
     *  WQ0(npo)
     *  /en33/anom_e,anom_i,key_t11,kcchp
	common
     *  /halo4/expfg,avalb,w_h,del_r,al0
     *  /halo5/q_vde,q_95,del_f,i_halo
     *  /halo9/fluxt,fluxt0
     *  /halo9e/dfmax_h
     *  /halo10/fves,fves0,self_v
     *  /halo11/fmaxv,fmaxv0

	dimension qz(npo),poa(npo),aiz(npo)
	dimension gra1help(npo),gra2help(npo)

	character *12 apr
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))
c--- toroidal coordinates---
c
	apr='-fx-'
	if(kpr.eq.1)print 71,apr,(fx(i),i=1,n)

	dfmaxh(1)=0.
	dfmaxc(1)=0.
	do i=2,n
	fx(i)=f(i)
	dfmaxc(i)=dfmaxc(i-1)+pfi(i)*ha(i)
	dfmaxh(i)=dfmaxh(i-1)+2.*pi*rs0*c3(i)*fx(n)*ha(i)
	end do
c
	fmax=dfmaxc(n)

	do i=2,n
	if(dfmaxc(i).ge.fmax/(1.+al0))then
	i_halo=i
	go to 1
	end if
	end do
1	continue

	i_halo1=i_halo

c------------------------------
	call ihalo_calc()

	if(kpr.eq.1)print *,' i_halo1 i_halo=====',i_halo1,i_halo

	q_95=q(i_halo)
	if(kpr.eq.1)print *,'  q_95 ===',q_95

c  calc. fves ...
	r_d0=0.
	r_tot=0.
	fmaxv=0.5*( (dfmaxc(n)-dfmaxh(n))+fmaxv)
	if(ntay.gt.1)then
           dfmax_h=dfmax(i_halo)
	fves=( -(fmaxv-fmaxv0)-self_v*(bt0-
     *  bt0_0)+self_v*fves0-expfg*r_d0*1.e5*tay )
     *  /( self_v+r_tot*1.e5*tay )
	f_na=fves/(5.*rs0)
	if(kpr.eq.1)print *,' fves fves0',fves,fves0
	if(kpr.eq.1)print *,' bt0 bt0_0',bt0,bt0_0
	if(kpr.eq.1)print *,' expfg f_na ',expfg,f_na
	if(kpr.eq.1)print *,' dfmax_h fmax ',dfmax_h*1.e-5,fmax*1.e-5
	end if

	return
	end

	subroutine polar_tor()
        include 'double.inc'
	include 'new_com.inc'

	call polar_tor_c(
     *  n_polar,bt0)


	return
	end
	

	subroutine polar_tor_c(
     *  n_polar,bt0)

        include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *  /mid1/C1(npo),C2(npo),C3(npo)
	common
     *	/ge1/pi
     *	/ge1e/rs0,tpl
     *  /ge2/NTAY,TAY,TT
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
     *  /ge5/kpr
	common
     *	/efit4/coef
	common
     *  /DFM2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)
     *  /dfm3/dfmax(npo),dfmax0(npo)
	common
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)
	common
     *  /pol1/RO(npo,ntet),AJ(npo,ntet)
     *  /pol2/Qx(npo),ANUx(npo),Px(npo),Fx(npo),
     *   PPxx(npo),PFFxx(npo)
     *  /pol4/UM,VM,UK(ntet),VK(ntet)
	common
     *  /eq4/xpl(npo,ntet),ypl(npo,ntet)
	common
     *  /halo4/expfg,avalb,w_h,del_r,al0

	character *12 apr
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

	f(n)=bt0

	fsqrt0=f(n)**2

	do i0=2,n
	i=n-i0+2
	fprime=-pff(i)
	fhelp=fprime*(psi(i)/(2.*pi*rs0))
	fsqrt=fsqrt0-fhelp*ha(i)
	fsqrt0=fsqrt
	f(i-1)=sqrt(fsqrt)
	end do

	apr='-f-'
	if(kpr.eq.1)print 71,apr,(f(i),i=1,n)

	do i=2,n
	anux(i)=-psi(i)/(2.*pi*rs0)
	end do
c
	do i=2,n
	ppxx(i)=pp(i)
	end do
c
	do i=1,n
	do j=1,mp
	aj(i,j)=anux(i)
	end do
	end do
c
	pt0z=-tpl
c
	kp=0
	if(kpr.eq.1)print *,' n mp rs0 pt0z=',n,mp,rs0,pt0z

	k_polar=0
c!!!	if(del_r.lt.0.1) then
	if(ntay.lt.n_polar) then
	k_polar=1
        CALL POLAR1(n,mp,rs0,kp,pt0z)
	end if

	if(kpr.eq.1)print *,'f fx',f(n),fx(n)

	if(k_polar.eq.0)then
	call transf_bound()
	end if

	if(kpr.eq.1)print *,'f fx',f(n),fx(n)

	do i=1,n
	do j=1,mp
	xpl(i,j)=um+ro(i,j)*(uk(j)-um)
	ypl(i,j)=vm+ro(i,j)*(vk(j)-vm)
	end do
	end do

	call midc(n,mp,rs0)
c------------------------------
	d11=pi*rs0*c3(n)/ai(n)
	fmax=f(n)*d11
	dfmax(1)=0.
	do i=2,n
	f(i)=ai(i)*fmax/(c3(i)*pi*rs0)                                         
        fx(i)=f(i)
	pfi(i)=2.*pi*rs0*c3(I)*fx(i)
c	dfmax(i)=dfmax(i-1)+pfi(i)*ha(i)
	dfmax(i)=a(i)**2*fmax
	q(i)=-pfi(i)/psi(i)
	qx(i)=q(i)
	end do
c==================================
	tpl_i=-coef*c2(n)*psi(n)

	if(kpr.eq.1)print *,'tpl tpl_i=c2*psi(n)',tpl,tpl_i

c	read (*,*)
	return
	end
c
	subroutine volt_ind()

        include 'double.inc'
        include 'parf1'
        common
     *  /pf1/npf,pf(kf),pf0(kf)
	common
     *  /cont1/vchopper(kf),veps
        common
     *  /ge5/kpr

        do i=1,npf
        vchopper(i)=100.
        end do
        return
        end
c
	subroutine pll_calc()
        include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *	/ge1e/rs0,tpl
     *  /ge5/kpr
	common
     *  /eq15/pll,zsep,rsep,zmax,rmax,zmin,rmin
	common
     *  /pol4/UM,VM,UK(ntet),VK(ntet)

	pll=0.
	p_k=0.
	pll_1=0.
	do j=2,mp
	p_k=p_k+1.
	r=uk(j)
	z=vk(j)
	call flux_pl(fpl,r,z,n,mp)
	pll=pll+fpl
	pll_1=pll_1+tpl*fp(r,um,z,vm)
	end do
	pll=pll/(p_k*tpl)
	pll_1=pll_1/(p_k*tpl)
	if(kpr.eq.1)print *,' pll===pll_1 ',pll,pll_1
	return
	end

	subroutine dens_prog()
        include 'double.inc'
	include 'new_com.inc'

	call dens_prog_c(
     *  ntay)


	return
	end



	subroutine dens_prog_c(
     *  ntay)

        include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *  /mid2/vi(npo),spo(npo)
	common
     *  /en1/PNE(npo),PD0(npo),PT0(npo),PH0(npo),PDN(npo),
     *  PTN(npo),PHN(npo)
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
     *  /ge5/kpr
     *  /ge8/pcch
     *  /ge8e/pcchp
     *  /en33/anom_e,anom_i,key_t11,kcchp
	character *12 apr
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

	ppch=0.
	vv=0.
	do i=2,n
      VV=VV+VI(I)*HA(I)
      p_ion=0.5*(Pd0(I)+Pd0(I-1))
      p_ion=p_ion+0.5*(Pt0(I)+Pt0(I-1))
!      PPch=PPch+0.5*(PNE(I)+PNE(I-1))*VI(I)*HA(I)
      PPch=PPch+p_ion*VI(I)*HA(I)
	end do
        PCch=PPch/VV
	if(kpr.eq.1)print *,'===1 pcchp pcch=kcchp===',pcchp,pcch,kcchp

!!!	if(ntay.lt.2)pcchp=pcch


	if(kcchp.eq.1)then
	al1=pcchp/pcch
	if(kpr.eq.1)print *,'===1 pcchp pcch=al1===',pcchp,pcch,al1
	do i=1,n
!	   pne(i)=pne(i)*al1
         pd0(i)=pd0(i)*al1
         pt0(i)=pt0(i)*al1
	   pne(i)=pd0(i)+pt0(i)
        end do
	end if

	return
	end


	subroutine time_out()

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
	character *12 apr

	i_dop=i_dop+1

	if(i_dop.eq.1)open (unit=42,file='for042',
     *	form='formatted')
	if(i_dop.gt.1)open (unit=42,file='for042',access='append',
     *	form='formatted')

c
      igr=1
	if(igr.gt.0)then
	write (42,5001)igr,ng
c
	write (42,5000) ((ygr(i,j),j=1,igr),i=1,ng),
     *(tgr(j),j=1,igr)
	
	apr='tgr'
c	if(kpr.eq.1)print 71,apr,(tgr(j),j=1,ng)
	apr='ygr'
	j=igr
c	if(kpr.eq.1)print 71,apr,(ygr(i,j),i=1,ng)


c	call out42(igr,ng,ygr,tgr)

	igr=0
c
	if(kpr.eq.1)print*,'!!! i_dop=',i_dop
	if(kpr.eq.1)print *,'writing "for042",here igr=',igr
	end if

	close (unit=42)


5001    format(4i4)
5000    format (16(1p,1e16.7e3))
!5000    format (6(1pe14.6))

	apr='CHOP_VOLTS'

71	format(5x,a70/,(1X,6(1pe11.3)))
	return
	end
	subroutine time_out_kav()

        include 'double.inc'
	include 'parf0'
        include 'parf3'
c
	common
     *	/igr1/ygr(iy,ny),tgr(ny),igr
	common
     *	/ng_igr1/ng
	character *12 fstatus
        common
     *  /ge5/kpr
	character *12 apr

	i_dop=i_dop+1

	if(i_dop.eq.1)open (unit=42,file='for042_br',
     *	form='formatted')
	if(i_dop.gt.1)open (unit=42,file='for042_br',access='append',
     *	form='formatted')

c
      igr=1
	if(igr.gt.0)then
	write (42,5001)igr,ng
c
	write (42,5000) ((ygr(i,j),j=1,igr),i=1,ng),
     *(tgr(j),j=1,igr)
	
	apr='tgr'
c	if(kpr.eq.1)print 71,apr,(tgr(j),j=1,ng)
	apr='ygr'
	j=igr
c	if(kpr.eq.1)print 71,apr,(ygr(i,j),i=1,ng)


c	call out42(igr,ng,ygr,tgr)

	igr=0
c
	if(kpr.eq.1)print*,'!!! i_dop ng=',i_dop,ng
	if(kpr.eq.1)print *,'writing "for042",here igr=',igr
	end if

	close (unit=42)


5001    format(4i4)
!5000    format (6(1pe14.6))
5000    format (16(1p,1e16.7e3))
	apr='CHOP_VOLTS'

71	format(5x,a70/,(1X,6(1pe11.3)))
	return
	end


	subroutine time_step()
        include 'double.inc'
	include 'new_com.inc'

	call time_step_c(
     *  r_tok,z_tok,r_tok0,z_tok0)


	return
	end

	subroutine time_step_c(
     *  r_tok,z_tok,r_tok0,z_tok0)


        include 'double.inc'
	include 'parf0'
	include 'parf1'
	include 'parf8'
	common
     *	/n_m/n,m,mp
	common
     *  /DFM2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)
     *  /dfm3/dfmax(npo),dfmax0(npo)
     *  /dfm7/bt0,uind
     *  /dfm7e/bt0_0,f_na
     *  /dfm14/tokae,ajae(npo),ajae0(npo),enae
	common
     *  /en1/PNE(npo),PD0(npo),PT0(npo),PH0(npo),PDN(npo),
     *  PTN(npo),PHN(npo)
     *  /en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),WE0(npo),
     *  WQ0(npo)
     *  /en4/WD0(npo),WT0(npo),WH0(npo),VD(npo),DIF(npo),
     *  GGT(npo),GGTN(npo)
     *  /en5/SD0(npo),ST0(npo),SH0(npo)
     *  /en10/GGE(npo),GGEN(npo),DXE(npo),DXQ(npo),WU(npo),
     *  UG(npo),VG(npo)
	common
     *  /en12/pnal(npo),pnaln(npo),zalfa,talfa
     *  /en18/pin(npo),pin0(npo),q11(npo),pal(npo)
     *	/en28/wen1,wen2
     *  /eq15/pll,zsep,rsep,zmax,rmax,zmin,rmin
     *  /eq15e/pll0,tpl0,udd
	common
     *  /fluxc9/fdd,fdd0
     *  /fluxc9e/pf_volt(kf),pf_fdd(kf),pf_fdd0(kf)
     *  /fluxc10e/ves_fdd,ves_fdd0
	common
     *  /eq11/psval(npo),psval0(npo)

        common
     *  /pf1/npf,pf(kf),pf0(kf)
     *  /pf6/pves(kf),pves0(kf)
     *  /pf7/plasma(kf),plasma0(kf)

	common
     *  /ves1/psp(mu),psp0(mu),tcam(mu),tcam0(mu)
     *  /ves2/ncam,rc(mu),zc(mu)
     *  /ves6/pind(mu),pind0(mu),pindn(mu)
     *  /ves9/tokc,tokc0
	common
     *  /cont4/ZPP,RPP,WVSPIP,ZXP,ELP,SHAPE,GAPINP,
     *  DFZP, DFZP0
     *  /cont7/zp,gapin
     *  /cont8/zp00
     *  /cont13/zmag,zvel,delrmag,delzmag
     *  /cont13e/zmag0,rmag,rmag0,rvel
c
	common
     *	/ge1e/rs0,tpl
     *  /ge2/NTAY,TAY,TT
     *  /ge5/kpr

	common
     *  /halo10/fves,fves0,self_v
     *  /halo11/fmaxv,fmaxv0

        common
     *  /con2/rref,krref,bvert


	common
     *  /abcdx_a/x_a(kf_c),x0_a(kf_c)
	common
     *  /abcdx_b/x_b(kf_c),x0_b(kf_c)

	common
     *  /abcdx/x_c(kf_c),x0_c(kf_c),gaps0(kf_c),d_gaps(kf_c)
        common
     *  /cont20/x_gaps(kf_c),y_gaps(kf_c),gaps(kf_c),n_gaps
     *  /cont21/n_ga,n_int
     *  /cont23/v_gaps(kf_c),d_gaps0(kf_c)

        common
     *  /keys13/i_con,i_act

        common
     *  /loop3/vloop,psf1a,psf1a0

	common
     *  /mid2/vi(npo),spo(npo)
     *  /mid2_0/vi0(npo),pfi0(npo)
c***vic for SCEN_CONTROL
     *	/vic_mario_filt/state(kf_c),state_old(kf_c)
     *	/vic_mario_filt1/state_vert(kf_c),state_old_vert(kf_c)
     *  /vic_rz_cur/r_cur,z_cur,z_cur0
     *  /vic_rref/rref_0

	character *52 apr

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

	apr='te0(from time_step)'
	if(kpr.eq.1)print 71,apr,(te0(i),i=1,n)
	apr='pne(from time_step)'
	if(kpr.eq.1)print 71,apr,(pne(i),i=1,n)

c  control parameters---
	zp00=zp
	DFZP0=DFZP
	psf1a0=psf1a

	r_tok0=r_tok
	z_tok0=z_tok


c----


	do i=1,n
	DMN(I)=DM0(I)
	dfmax0(i)=dfmax(i)
      GGTN(I)=GGT(I)
      PDN(I)=PD0(I)
      PTN(I)=PT0(I)
      GGEN(I)=GGE(I)
      TEN(I)=TE0(I)
	TQN(I)=TQ0(I)
c---
	pin0(i)=pin(i)
	pnaln(i)=pnal(i)
	sd0(i)=0.
	st0(i)=0.
	sh0(i)=0.

	ajae0(i)=ajae(i)
	vi0(i)=vi(i)
	pfi0(i)=pfi(i)
	psval0(i)=psval(i)


	psval0(i)=psval(i)
	end do

	pll0=pll
	tpl0=tpl
	ves_fdd0=ves_fdd
	fdd0=fdd
	wen1=wen2
	zmag0=zmag

	z_cur0=z_cur

	rmag0=rmag
	fmax0=fmax
	epol0=epol
	bt0_0=bt0
	fves0=fves
	fmaxv0=fmaxv

	do i=1,ncam
	tcam0(i)=tcam(i)
	pind0(i)=pind(i)
	psp0(i)=psp(i)
	end do

        do i=1,npf
        pf0(i)=pf(i)
        pves0(i)=pves(i)
        plasma0(i)=plasma(i)
	pf_fdd0(i)=pf_fdd(i)
        end do

        tokc0=tokc

        rref_0=rref
c

	DO I=1,kf_c
	x0_c(i)=x_c(i)
	x0_a(i)=x_a(i)
	x0_b(i)=x_b(i)
	END DO
c-----------
        do i=1,kf_c
           state_old(i)=state(i)
           state_old_vert(i)=state_vert(i)
        end do
c-----------

	DO I=1,n_gaps

	if(ntay.le.2)gaps0(i)=gaps(i)

	d_gaps0(i)=d_gaps(i)

	END DO
        if(kpr.eq.1)print *,' i_con n_int n_gaps',i_con,n_int,n_gaps

c        end if

c----------------

	return
	end
c
	subroutine ppx_pffx()
        include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *  /DFM2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)
	common
     *  /pol5/psend
     *  /pol6/ppx(npo),pffx(npo)
     *  /pol6d/ppxd(npo),pffxd(npo)
	common
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)
	common
     *	/ge1e/rs0,tpl
     *  /ge2/NTAY,TAY,TT
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
     *  /ge5/kpr
	dimension ppz(npo),pffz(npo),poa(npo),aiz(npo)

	character *20 apr

	if(ntay.gt.0)psend=(dm0(n)-dm0(1))*2.*ai(n)
c	if(ntay.gt.5)return


	poa(1)=0.
	do i=2,n
	dpoa= (dm0(i)-dm0(1))/(dm0(n)-dm0(1))
	poa(i)=sqrt(dpoa)
c=================
c       dpoa_m= (0.5*(dm0(i)+dm0(i-1))-dm0(1))/(dm0(n)-dm0(1))
c       aiz(i)=sqrt(dpoa_m)
c==============
	aiz(i)=0.5*(poa(i)+poa(i-1))
	end do
	pp(1)=pp(2)
	pff(1)=pff(2)
	do i=1,n
	ppz(i)=pp(i)
	pffz(i)=pff(i)
	end do
c*** recalculate in poloidal coordinate system just ppx and pffx
c *** to do PTOKE

	nrad=n

 	teta=1.d0
        call inter_h0(pp,aiz,n,teta,val)
	pp(n+1)=0.d0

 	teta=1.d0
        call inter_h0(pff,aiz,n,teta,val)
	pff(n+1)=0.d0
	aiz(n+1)=1.d0

	apr='ppz'
c	if(kpr.eq.1)print 71,apr,(ppz(i),i=1,nrad)
	apr='pffz'
	if(kpr.eq.1)print 71,apr,(pffz(i),i=nrad-5,nrad)

	apr='dm0'
c	if(kpr.eq.1)print 71,apr,(dm0(i),i=1,nrad)
	apr='poa'
c	if(kpr.eq.1)print 71,apr,(poa(i),i=1,nrad)

	apr='aiz'
	if(kpr.eq.1)print 71,apr,(aiz(i),i=nrad-5,nrad)

	apr='a'
	if(kpr.eq.1)print 71,apr,(a(i),i=nrad-5,nrad)

	do i=2,n-1

	call feet_p(n+1,pp,ppx(i),aiz,a(i))
	call feet_p(n+1,pff,pffx(i),aiz,a(i))

!           call linear(n,pp,ppx(i),aiz,a(i))
!           call linear(n,pff,pffx(i),aiz,a(i))


	end do

	apr='ppx'
	if(kpr.eq.1)print 71,apr,(ppx(i),i=nrad-5,nrad)
	apr='pffx'
	if(kpr.eq.1)print 71,apr,(pffx(i),i=nrad-5,nrad)

71	format(20x,a6/,(6(1pe10.3)))

	ppx(1)=ppx(2)
	pffx(1)=pffx(2)

	ppx(n)=0.d0
	pffx(n)=0.d0

	do i=1,n
	ppxd(i)=ppx(i)
	pffxd(i)=pffx(i)
	end do

	return
	end

	subroutine pp_calc()
        include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *	/efit4/coef
	common
     *  /DFM2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)
	common
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)
     *  /dfm11/c20(npo),tok1(npo),tok2(npo)
        COMMON
     *  /mid1/C1(npo),C2(npo),C3(npo)
     *  /mid2/vi(npo),spo(npo)
	common
     *	/ge1/pi
     *	/ge1e/rs0,tpl
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
     *  /ge5/kpr
	common
     *  /en1/PNE(npo),PD0(npo),PT0(npo),PH0(npo),PDN(npo),
     *  PTN(npo),PHN(npo)
     *  /en1e/te_a,ti_a,te_b,ti_b,pw_e
     *  /en2e/pd0_a,pt0_a,pd0_b,pt0_b,pw_p
     *  /en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),WE0(npo),
     *  WQ0(npo)

	character *20 apr


	tpl_o=-coef*c2(n)*psi(n)
	if(kpr.eq.1)print *,'tpl=c2(n)*psi(n)=',tpl_o
c+++++++++++++++++++++++++++++++++
	i=1
	p(i)=( te0(i)+tq0(I) )*pne(i)*200.*1.e-6
	do i=2,n
	p(i)=( te0(i)+tq0(I) )*pne(i)*200.*1.e-6
	pp(i)=-(p(i)-p(i-1))/(ha(i)*psi(i))*2.*pi*rs0
	end do

	pp(1)=pp(2)

	apr='--pp'
	if(kpr.eq.1)print 71,apr,(pp(i),i=1,n)

	apr='p'
	if(kpr.eq.1)print 71,apr,(p(i),i=1,n)

	apr='te0'
	if(kpr.eq.1)print 71,apr,(te0(i),i=1,n)
	apr='tq0'
	if(kpr.eq.1)print 71,apr,(tq0(i),i=1,n)


c	pause 'pp_calc'


71	FORMAT(20X,A8/,(6(1X,1PE10.3)))
	return
	end

	subroutine pff_calc()
        include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *	/efit4/coef
	common
     *  /DFM2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)
	common
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)
     *  /dfm7/bt0,uind
     *  /dfm11/c20(npo),tok1(npo),tok2(npo)
        COMMON
     *  /mid1/C1(npo),C2(npo),C3(npo)
     *  /mid2/vi(npo),spo(npo)
	common
     *	/ge1/pi
     *	/ge1e/rs0,tpl
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
     *  /ge5/kpr
	common
     *  /pol2/Qx(npo),ANUx(npo),Px(npo),Fx(npo),
     *   PPxx(npo),PFFxx(npo)

	character *20 apr

	CALL TOKK(N,RS0)
c
	tok=0.
	z_cur=0.
	do i=2,n
	TOK=tok-coef*( PP(I)*VI(I)*ha(I)/RS0+
     *  0.5*PFF(I)*RS0*2.*PI*c3(i)*ha(I) )
	end do
	if(kpr.eq.1)print*,'tok=-(pp+pff)=',tok
c
	apr='pff'
	if(kpr.eq.1)print 71,apr,(pff(i),i=1,n)
	
	
	
	f(n)=bt0
                                                                        
	fsqrt0=f(n)**2                                                         
c                                                                       

	do i0=2,n                                                              
	i=n-i0+2                                                               
	fprime=-pff(i)                                                         
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


	
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))
	return
	end


	subroutine z_cur_calc()
      include 'double.inc'
	include 'new_com.inc'

	call z_cur_calc_c(
     *  n,m,rs0,pp,pff,kpr,pi,
     *  z_cur,xpl,ypl)
 
	return
	end
	subroutine z_cur_calc_c(
     *  n,m,rs0,pp,pff,kpr,pi,
     *  z_cur,xpl,ypl)
        include 'double.inc'

	include 'parf0'

	dimension pp(*),pff(*)
	dimension xpl(npo,*),ypl(npo,*)

	character *20 apr

	coef=10./(4.*PI)

c
	tok=0.
	z_cur=0.

c	!print *,' n m =',n,m

	do i=2,n
	do j=2,m-1

      U1=xpl(i,j)
      V1=ypl(i,j)
      U2=xpl(i-1,j)
      V2=ypl(i-1,j)
      U3=xpl(i-1,j-1)
      V3=ypl(i-1,j-1)
      U4=xpl(i,j-1)
      V4=ypl(i,j-1)
c
      UA=U1-U2+U4-U3
      UT=U1-U4+U2-U3
      UT_1=U1-U4
      UT_2=U2-U3
c-------------------------
      VA=V1-V2+V4-V3
      VT=V1-V4+V2-V3
      VT_1=V1-V4
      VT_2=V2-V3

      DS=0.25*(UA*VT-VA*UT)
      UC=0.25*(U1+U2+U3+U4)
      VC=0.25*(V1+V2+V3+V4)

	if(i.ne.n)then
      tok1=-(PP(I)*uc/rs0+0.5*pff(i)*rs0/uc)*DS*coef
	else
      tok1=-(PP(I)*uc/rs0+0.5*pff(i)*rs0/uc)*DS*coef*0.5
	end if

	z_cur=z_cur+tok1*vc

	TOK=tok+tok1

	end do
	end do

	z_cur=z_cur/tok

	if(kpr.eq.1)print*,'tok z_cur=',tok,z_cur

c	pause 'z_cur'
c
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))
	return
	end



	subroutine pol_res_t()
        include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *	/ge1/pi
     *  /ge2/NTAY,TAY,TT
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
     *  /ge5/kpr
	common
     *	/efit4/coef
	common
     *  /eq4/xpl(npo,ntet),ypl(npo,ntet)
	common
     *	/ge1e/rs0,tpl
	common
     *  /pol1/RO(npo,ntet),AJ(npo,ntet)
     *  /pol2/Qx(npo),ANUx(npo),Px(npo),Fx(npo),
     *   PPxx(npo),PFFxx(npo)
     *  /pol4/UM,VM,UK(ntet),VK(ntet)
     *  /pol5/psend
     *  /pol6/ppx(npo),pffx(npo)
	common
     *  /DFM2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)
     *  /dfm7/bt0,uind
        COMMON
     *  /mid1/C1(npo),C2(npo),C3(npo)
     *  /mid2/vi(npo),spo(npo)
     *  /mid2e/vol(npo),spov(npo),pcur(npo)
	dimension qz(npo)

c	if(kpr.eq.1)print *,' n mp psend==',n,mp,psend

	do i=1,n
	do j=1,mp
	xpl(i,j)=um+ro(i,j)*(uk(j)-um)
	ypl(i,j)=vm+ro(i,j)*(vk(j)-vm)
	end do
	end do

	call midc(n,mp,rs0)
	tok=0.
	co_n=1.
	do i=2,n
	if(i.eq.n)co_n=0.5
        TOK=tok-co_n*coef*( PP(I)*VI(I)/RS0 +
     *  0.5*PFF(I)*RS0*2.*PI*c3(i) )*ha(i)
	end do
	tpl_1=-coef*c2(n)*psi(n)
	if(kpr.eq.1)print *,'tpl tok==tpl_t',tpl,tok,tpl_1
	return
	end
	subroutine polar_res()
        include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *	/ge1/pi
     *  /ge2/NTAY,TAY,TT
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
     *  /ge5/kpr
	common
     *	/efit4/coef
     *	/efit5/it1,it2
	common
     *  /eq4/xpl(npo,ntet),ypl(npo,ntet)
     *  /eq11/psval(npo),psval0(npo)
	common
     *	/ge1e/rs0,tpl
	common
     *  /pol1/RO(npo,ntet),AJ(npo,ntet)
     *  /pol2/Qx(npo),ANUx(npo),Px(npo),Fx(npo),
     *   PPxx(npo),PFFxx(npo)
     *  /pol4/UM,VM,UK(ntet),VK(ntet)
     *  /pol5/psend
     *  /pol6/ppx(npo),pffx(npo)
	common
     *  /DFM2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)
     *  /dfm7/bt0,uind
     *  /dfm7e/bt0_0,f_na
        COMMON
     *  /mid1/C1(npo),C2(npo),C3(npo)
     *  /mid2/vi(npo),spo(npo)
     *  /mid2e/vol(npo),spov(npo),pcur(npo)
	common
     *  /halo4/expfg,avalb,w_h,del_r,al0
     *  /halo5/q_vde,q_95,del_f,i_halo
	dimension qz(npo)
	character *12 apr

	if(kpr.eq.1)print *,' n mp psend==',n,mp,psend
c	if(kpr.eq.1)print *,' pi rs0==',pi,rs0
c	if(kpr.eq.1)print *,' um vm==',um,vm

c	dpsi=psend/(2.*ai(n))
c	do i=2,n
c	psi(i)=2.*ai(i)*dpsi
c	end do

	do i=1,n
	do j=1,mp
	xpl(i,j)=um+ro(i,j)*(uk(j)-um)
	ypl(i,j)=vm+ro(i,j)*(vk(j)-vm)
	end do
	end do
c
	f(n)=bt0+f_na

	fsqrt0=f(n)**2
c
	i_halo=n
	do i0=2,n
	i=n-i0+2
	fprime=-pff(i)
	if(psval(i).lt.psval(n+1))i_halo=i
	fhelp=fprime*(psi(i)/(2.*pi*rs0))
	fsqrt=fsqrt0-fhelp*ha(i)
	fsqrt0=fsqrt
	f(i-1)=sqrt(fsqrt)
	end do

	do i=1,n
	fx(i)=f(i)
	end do

c
	call midc(n,mp,rs0)
	tok=0.
	co_n=1.
	do i=2,n
	if(i.eq.n)co_n=0.5
        TOK=tok-co_n*coef*( PP(I)*VI(I)/RS0 +
     *  0.5*PFF(I)*RS0*2.*PI*c3(i) )*ha(i)
	end do
	tpl_1=-coef*c2(n)*psi(n)
	if(kpr.eq.1)print *,'tpl tok tpl_1 ',tpl,tok,tpl_1
	err_tpl=abs(tpl-tpl_1)/tpl

	it2=0
	if(err_tpl.gt.1.e-3)it2=1
	if(kpr.eq.1)print *,'err_tpl it2 ',err_tpl,it2

c!!!	al1=tpl/tpl_1
	al1=tpl/tok

	do i=1,n
	ppx(i)=al1*ppx(i)
	pffx(i)=al1*pffx(i)
	end do

c---->  F(I) variable...
c
	do i=1,n
	qz(i)=f(i)
	end do
	do i=2,n
	call feeti(n,qz,f(i),a,ai(i))
	end do
	f(1)=f(2)

	do i=2,n
	fx(i)=f(i)
	pfi(i)=2.*pi*rs0*c3(I)*fx(i)
	q(i)=-pfi(i)/psi(i)
	qx(i)=q(i)
	end do

	apr='-fx-'
	if(kpr.eq.1)print 71,apr,(fx(i),i=1,n)
	apr='-q-'
	if(kpr.eq.1)print 71,apr,(q(i),i=1,n)

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))
c
	fsqrt0=p(n)
	do i0=2,n
	i=n-i0+2
	pprime=-pp(i)
	fhelp=pprime*(psi(i)/(2.*pi*rs0))
	fsqrt=fsqrt0-fhelp*ha(i)
	fsqrt0=fsqrt
	p(i-1)=fsqrt
	end do
c
	q_95=q(i_halo)

	del_f=f(i_halo)-f(n)
	expfg=5.*rs0*del_f
	if(kpr.eq.1)print *,' ----q_95 del_f i_halo----',q_95,del_f,i_halo
c-----------------
c	read (*,*)
	return
	end
	subroutine transf_data_new()
	include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *	/ge1/pi
     *  /ge2/NTAY,TAY,TT
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
	common
     *	/efit0/kefit
     *	/efit4/coef
	common
     *  /eq4/xpl(npo,ntet),ypl(npo,ntet)
     *  /eq11/psval(npo),psval0(npo)
	common
     *	/ge1e/rs0,tpl
     *  /ge5/kpr
	common
     *  /pol1/RO(npo,ntet),AJ(npo,ntet)
     *  /pol2/Qx(npo),ANUx(npo),Px(npo),Fx(npo),
     *   PPxx(npo),PFFxx(npo)
     *  /pol4/UM,VM,UK(ntet),VK(ntet)
     *  /pol5/psend
     *  /pol5e/um1,vm1,um2,vm2
     *  /pol6/ppx(npo),pffx(npo)
	common
     *  /DFM2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)
     *  /dfm3/dfmax(npo),dfmax0(npo)
     *  /dfm3e/dfmaxc(npo),dfmaxh(npo)
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)
     *  /dfm7/bt0,uind
     *  /dfm7e/bt0_0,f_na
        COMMON
     *  /mid1/C1(npo),C2(npo),C3(npo)
     *  /mid2/vi(npo),spo(npo)
     *  /mid2e/vol(npo),spov(npo),pcur(npo)
     *  /mid3/GRA1(npo),GRA2(npo)
	common
     *  /en1/PNE(npo),PD0(npo),PT0(npo),PH0(npo),PDN(npo),
     *  PTN(npo),PHN(npo)
     *  /en1e/te_a,ti_a,te_b,ti_b,pw_e
     *  /en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),WE0(npo),
     *  WQ0(npo)
     *  /en33/anom_e,anom_i,key_t11,kcchp
	common
     *  /halo4/expfg,avalb,w_h,del_r,al0
     *  /halo5/q_vde,q_95,del_f,i_halo
     *  /halo9/fluxt,fluxt0
     *  /halo9e/dfmax_h
     *  /halo10/fves,fves0,self_v
     *  /halo11/fmaxv,fmaxv0

	dimension qz(npo),poa(npo),aiz(npo)
	dimension gra1help(npo),gra2help(npo)

	character *12 apr

	apr='  ---- kcchp'
	if(kpr.eq.1)print *,apr,kcchp

	p_n=p(n)


	if(kpr.eq.1)then
	
	apr='-te0-'                                                            
!	print 71,apr,(te0(i),i=1,n)                               
	apr='-tq0-'                                                            
	!print 71,apr,(tq0(i),i=1,n)                               
	apr='-pd0-'                                                            
	!print 71,apr,(pd0(i),i=1,n)                               
	apr='-pt0-'                                                            
	!print 71,apr,(pt0(i),i=1,n)
	
	end if                                                                 




	if(ntay.eq.0)then                                                      


c-----------temperature is given if kcchp=0 -                           
	if(kcchp.eq.0)then 
	al1=te0(1)/p(1)	
	al2=tq0(1)/p(1)	
	do i=1,n                                                               
c	te0(I)=p(I)*al1*(1.+0.1*a(i)**2)
	te0(I)=p(I)*al1
c	tq0(i)=p(i)*al2*(1.+0.1*a(i)**2)
	tq0(i)=te0(i)
	end do

	apr='  al1 al2 kcchp'
	if(kpr.eq.1)print *,apr,al1,al2,kcchp

	end if

                                                                        
c-----------temperature is given if kcchp=0 -                           
	if(kcchp.eq.0)then 
	do i=1,n                                                               
	pd0(I)=p(I)/((te0(I)+tq0(I))*2.e-4*2.)
	pt0(I)=pd0(I)                                                          
	pne(i)=pd0(i)+pt0(i) 
	end do
	end if
		
	if(kcchp.eq.1)then

	call dens_prog() 

	apr='-p-'
	if(kpr.eq.1)print 71,apr,(p(i),i=1,n)
                                                                        
	
	te_b=te0(n)                                                            
	ti_b=tq0(n)

	i=n
	p(i)=(te0(i)+tq0(I))*(pd0(i)+pt0(I))*200.*1.e-6

	del_pn=p(i)-p_n

	do i=1,n-1
	   p(i)=p(i)+del_pn
	end do

	if(kefit.ne.5)then
	do i=1,n
	   te0(I)=p(I)/((pd0(I)+pt0(I))*2.e-4*2.)
	   tq0(i)=te0(i)                                
	end do
	else
	do i=1,n
	
	al1=te0(1)/(te0(1)+tq0(1))	
	al2=1-al1	
c
c	   te0(I)=al1*p(I)/((pd0(I)+pt0(I))*2.e-4)
c	   tq0(i)=al2*p(I)/((pd0(I)+pt0(I))*2.e-4)                                
	end do
	end if


	end if

	te_a=te0(1)                                                            
	ti_a=tq0(1)                                                            
	te_b=te0(n)                                                            
	ti_b=tq0(n)

	if(kpr.eq.1)then
	
	apr='-te0-'                                                            
!	print 71,apr,(te0(i),i=1,n)                               
	apr='-tq0-'                                                            
	!print 71,apr,(tq0(i),i=1,n)                               
	apr='-pd0-'                                                            
	!print 71,apr,(pd0(i),i=1,n)                               
	apr='-pt0-'                                                            
	!print 71,apr,(pt0(i),i=1,n)
	
	end if                                                                 


	te_a=te0(1)
	ti_a=tq0(1)
	te_b=te0(n)
	ti_b=tq0(n)

	if(kpr.eq.1)print *,' ntay  p_n p(n) del_pn',
     *  ntay,p_n,p(n),del_pn

	apr='-p-'
	if(kpr.eq.1)print 71,apr,(p(i),i=1,n)

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

	end if

c
	dm0(1)=2.d0*pi*psval(1)

	do i=2,n
	dm0(i)=dm0(i-1)+psi(i)*ha(i)
	dmn(i)=dm0(i)
	end do


	apr='-psi-'                                                            
!	print 71,apr,(psi(i),i=1,6)


	return
	end

c
	subroutine transf_data()
        include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *	/ge1/pi
     *  /ge2/NTAY,TAY,TT
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
     *  /ge5/kpr
	common
     *	/efit4/coef
	common
     *  /eq4/xpl(npo,ntet),ypl(npo,ntet)
	common
     *	/ge1e/rs0,tpl
	common
     *  /pol1/RO(npo,ntet),AJ(npo,ntet)
     *  /pol2/Qx(npo),ANUx(npo),Px(npo),Fx(npo),
     *   PPxx(npo),PFFxx(npo)
     *  /pol4/UM,VM,UK(ntet),VK(ntet)
     *  /pol5/psend
     *  /pol5e/um1,vm1,um2,vm2
     *  /pol6/ppx(npo),pffx(npo)
	common
     *  /DFM2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)
     *  /dfm3/dfmax(npo),dfmax0(npo)
     *  /dfm3e/dfmaxc(npo),dfmaxh(npo)
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)
     *  /dfm7/bt0,uind
     *  /dfm7e/bt0_0,f_na
        COMMON
     *  /mid1/C1(npo),C2(npo),C3(npo)
     *  /mid2/vi(npo),spo(npo)
     *  /mid2e/vol(npo),spov(npo),pcur(npo)
     *  /mid3/GRA1(npo),GRA2(npo)
	common
     *  /en1/PNE(npo),PD0(npo),PT0(npo),PH0(npo),PDN(npo),
     *  PTN(npo),PHN(npo)
     *  /en1e/te_a,ti_a,te_b,ti_b,pw_e
     *  /en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),WE0(npo),
     *  WQ0(npo)
     *  /en2e/pd0_a,pt0_a,pd0_b,pt0_b,pw_p
     *  /en33/anom_e,anom_i,key_t11,kcchp
	common
     *  /halo4/expfg,avalb,w_h,del_r,al0
     *  /halo5/q_vde,q_95,del_f,i_halo
     *  /halo9/fluxt,fluxt0
     *  /halo9e/dfmax_h
     *  /halo10/fves,fves0,self_v
     *  /halo11/fmaxv,fmaxv0

	dimension qz(npo),poa(npo),aiz(npo)
	dimension gra1help(npo),gra2help(npo)

	character *12 apr

	spov(1)=0.
	vol(1)=0.
	pcur(1)=0.
	do i=2,n
	spov(i)=spov(i-1)+spo(i)*ha(i)
	vol(i)=vol(i-1)+vi(i)*ha(i)
	pcur(i)=-c2(i)*psi(i)*coef
	fx(i)=f(i)
	pfi(i)=2.*pi*rs0*c3(I)*fx(i)
	q(i)=-pfi(i)/psi(i)
	qx(i)=q(i)
	end do
	if(kpr.eq.1)print *,' pcur==q========',pcur(n),q(n)

	do i=1,n
	gra1help(i)=gra1(i)*vi(i)
	gra2help(i)=gra2(i)*vi(i)*psi(i)
	end do
c--- transref to toroidal coordinates---
c
	dfmaxh(1)=0.
	dfmaxc(1)=0.
	do i=2,n
	dfmaxc(i)=dfmaxc(i-1)+pfi(i)*ha(i)
	dfmaxh(i)=dfmaxh(i-1)+2.*pi*rs0*c3(i)*fx(n)*ha(i)
	end do
c
	fmax=dfmaxc(n)
c------------------------------
c  calc. fves ...
	r_d0=0.
	r_tot=0.
	fmaxv=0.5*( (dfmaxc(n)-dfmaxh(n))+fmaxv)
	if(ntay.gt.1)then
           dfmax_h=dfmax(i_halo)
	fves=( -(fmaxv-fmaxv0)-self_v*(bt0-
     *  bt0_0)+self_v*fves0-expfg*r_d0*1.e5*tay )
     *  /( self_v+r_tot*1.e5*tay )
	f_na=fves/(5.*rs0)
	if(kpr.eq.1)print *,' fves fves0',fves,fves0
	if(kpr.eq.1)print *,' bt0 bt0_0',bt0,bt0_0
	if(kpr.eq.1)print *,' expfg f_na ',expfg,f_na
	if(kpr.eq.1)print *,' dfmax_h fmax ',dfmax_h*1.e-5,fmax*1.e-5
	end if

c-----------------------------

	poa(1)=0.
	aiz(1)=0.
	do i=2,n
	poa(i)=sqrt( dfmaxc(i)/fmax)
	dfmaxc_m=0.5*(dfmaxc(i)+dfmaxc(i-1))
c	aiz(i)=sqrt( dfmaxc_m/fmax )
	aiz(i)=0.5*(poa(i)+poa(i-1))
	end do
	aiz(n+1)=poa(n)

c---->  p variable...
c
	do i=1,n
	qz(i)=p(i)
	end do
	do i=2,n-1
	call feeti(n,qz,p(i),poa,a(i))
	end do
c-------------------
	call dens_prog()

	if(ntay.eq.0)then
	do i=1,n
c	(te0(i)+tq0(I))*(pd0(i)+pt0(I))*200.*1.e-6=p(I)
c-----------temperature is given if kcchp=0 -

	if(kcchp.eq.0)then

	pd0(I)=p(I)/((te0(I)+tq0(I))*2.e-4*2.)
	pt0(I)=pd0(I)
	pne(i)=pd0(i)+pt0(i)
	end if

	te0(I)=p(I)/((pd0(I)+pt0(I))*2.e-4*2.)
	tq0(i)=te0(i)
	end do


	te_a=te0(1)
	ti_a=tq0(1)
	te_b=te0(n)
	ti_b=tq0(n)

	pd0_a=pd0(1)
	pd0_b=pd0(n)

	pt0_a=pt0(1)
	pt0_b=pt0(n)

	if(kpr.eq.1)print *,' ntay==============',ntay
	apr='-te0-'
	if(kpr.eq.1)print 71,apr,(te0(i),i=1,n)
	apr='-tq0-'
	if(kpr.eq.1)print 71,apr,(tq0(i),i=1,n)
	apr='-pd0-'
	if(kpr.eq.1)print 71,apr,(pd0(i),i=1,n)
	apr='-pt0-'
	if(kpr.eq.1)print 71,apr,(pt0(i),i=1,n)

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

	end if

c
c---->  vol variable...
	vol(1)=0.
c
	do i=1,n
	qz(i)=vol(i)
	end do
	do i=2,n-1
	call feeti(n,qz,vol(i),poa,a(i))
	end do
	do i=2,n
	vi(i)=(vol(i)-vol(i-1))/ha(i)
	end do
c
c---->  spov variable...
c
	spov(1)=0.
	do i=1,n
	qz(i)=spov(i)
	end do
	do i=2,n-1
	call feeti(n,qz,spov(i),poa,a(i))
	end do
	do i=2,n
	spo(i)=(spov(i)-spov(i-1))/ha(i)
	end do
c----> q variable...
c
c	mppx='q'
c	if(kpr.eq.1)print 72,mppx,(q(i),i=1,n)
	q(1)=q(2)
	do i=1,n
	qz(i)=q(i)
	end do
c-----------------------------
 	teta=aiz(n+1)
        call inter_h0(qz,ai,n,teta,val)
	qz(n+1)=val
c	qz(n+1)=q(n)
c------------------------------
	do i=2,n
	call feeti(n+1,qz,q(i),aiz,ai(i))
	end do
c
c  gra1
c
	do i=1,n
	qz(i)=gra1help(i)
	end do
c-----------------------------
 	teta=aiz(n+1)
        call inter_h0(qz,ai,n,teta,val)
	qz(n+1)=val
c------------------------------
	do i=2,n
	call feeti(n+1,qz,gra1help(i),aiz,ai(i))
	end do
c
c  gra2
c
	do i=1,n
	qz(i)=gra2help(i)
	end do
c-----------------------------
 	teta=aiz(n+1)
        call inter_h0(qz,ai,n,teta,val)
	qz(n+1)=val
c------------------------------
	do i=2,n
	call feeti(n+1,qz,gra2help(i),aiz,ai(i))
	end do
c
c---->  I_p (c20)variable...
c
	do i=1,n
	qz(i)=pcur(i)
	end do
c-----------------------------
 	teta=aiz(n+1)
        call inter_h0(qz,ai,n,teta,val)
	qz(n+1)=val
c	qz(n+1)=q(n)
c------------------------------
c	qz(n+1)=c20(n)
	do i=2,n
	call feeti(n+1,qz,pcur(i),aiz,ai(i))
	end do
c---->  F(I) variable...
c
	do i=1,n
	qz(i)=f(i)
	end do
c-----------------------------
 	teta=aiz(n+1)
        call inter_h0(qz,ai,n,teta,val)
	qz(n+1)=val
	do i=2,n
	call feeti(n+1,qz,f(i),aiz,ai(i))
	end do
	f(1)=f(2)

	if(kpr.eq.1)print *,' pcur==q========',pcur(n),q(n)
c-------
c---->  pff(I) variable...
c
	pff(1)=pff(2)
	do i=1,n
	qz(i)=pff(i)
	end do
c-----------------------------
 	teta=aiz(n+1)
        call inter_h0(qz,ai,n,teta,val)
	qz(n+1)=val
	do i=2,n
	call feeti(n+1,qz,pff(i),aiz,ai(i))
	end do
	pff(1)=pff(2)
c-------
c---->  pp(I) variable...
c
	pp(1)=pp(2)
	do i=1,n
	qz(i)=pp(i)
	end do
c-----------------------------
 	teta=aiz(n+1)
        call inter_h0(qz,ai,n,teta,val)
	qz(n+1)=val
	do i=2,n
	call feeti(n+1,qz,pp(i),aiz,ai(i))
	end do
	pp(1)=pp(2)
c---->  p variable...
c
	do i=1,n
	qz(i)=p(i)
	end do
	do i=2,n-1
	call feeti(n,qz,p(i),poa,a(i))
	end do
c
	if(ntay.eq.0)dmn(1)=0.

	dm0(1)=dmn(1)
	dfmax(1)=0.
	do i=2,n
	fx(i)=f(i)
	qx(i)=q(i)
	dfmax(i)=a(i)**2*fmax
	pfi(i)=2.*ai(i)*fmax
	psi(i)=-pfi(i)/qx(i)
	c2(i)=-pcur(i)/(psi(i)*coef)
	c3(i)=pfi(i)/(2.*pi*rs0*f(i))

	if(ntay.eq.0)then
	dm0(i)=dm0(i-1)+psi(i)*ha(i)
	dmn(i)=dm0(i)
	end if
c
	end do

	do i=2,n
	gra1(i)=gra1help(i)/vi(i)
	gra2(i)=gra2help(i)/vi(i)/psi(i)
	end do
c--------------
	tpl_tor=-coef*c2(n)*psi(n)
	if(kpr.eq.1)print *,' tpl_tor==',tpl_tor
	return
	end

	subroutine tpl_calc()
        include 'double.inc'
	include 'new_com.inc'

	call tpl_calc_c(c20)

	return
	end

	subroutine tpl_calc_c(c20)
        include 'double.inc'
	include 'parf0'
	include 'parf1'

	dimension c20(*)


	common
     *	/n_m/n,m,mp
	common
     *  /keys5/next
     *  /keys11/i_ramp
	common
     *	/ge1/pi
     *  /ge2/NTAY,TAY,TT
     *	/ge1e/rs0,tpl
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
     *  /ge5/kpr
	common
     *	/efit4/coef
     *	/efit6/tpl_p
	common
     *  /mid1/C1(npo),C2(npo),C3(npo)
     *  /mid2/vi(npo),spo(npo)
	common
     *  /DFM1/UDM,ZDM,L3,SIG0
     *  /DFM2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)
     *  /dfm3/dfmax(npo),dfmax0(npo)
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)
     *  /dfm9/aj0(npo)
	common
     *  /pol2/Qx(npo),ANUx(npo),Px(npo),Fx(npo),
     *   PPxx(npo),PFFxx(npo)
	common
     *  /eq11/psval(npo),psval0(npo)
     *  /eq15/pll,zsep,rsep,zmax,rmax,zmin,rmin
     *  /eq15e/pll0,tpl0,udd
	common
     *  /fluxc9/fdd,fdd0
	common
     *  /halo2e/next0,li_drop,n_li,n_dif,nmix
	common
     *  /ramp1/fdd_ind
        common
     *  /pf1/npf,pf(kf),pf0(kf)

	dimension c20_help(npo)

	character *12 apr
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

	UDM=0.
	ZDM=tpl*4.*PI/( 10.*F(n) )
	L3=3
        if(kpr.eq.1)print *,'  udm zdm l3',udm,zdm,l3

	udd=-(fdd-fdd0)/(tay*100.)

c!!!	call udd_filter()

c!!!	udd=-100.

        if(kpr.eq.1)print *,' pll pll0 udd ',pll,pll0,udd

	udd_tor=-(dfmax(n)-dfmax0(n))/(q(n)*100.*tay)

	udd=udd-udd_tor

	if(kpr.eq.1)print *,' udd udd_tor==',udd,udd_tor

        if(kpr.eq.1)print *,' fdd fdd0 ',fdd,fdd0

        if(kpr.eq.1)print *,'  tpl tpl0',tpl,tpl0
        if(kpr.eq.1)print *,' next ntay ',next,ntay

	if(ntay.gt.next)then
        if(kpr.eq.1)print *,' pll pll0 udd ',pll,pll0,udd
        if(kpr.eq.1)print *,'  tpl tpl0',tpl,tpl0
	UDM=4.*PI/( 10.*PLL*f(n) )
	ZDM=UDM*(-DMN(n)+pll0*tpl0+udd*tay*100. )
        if(kpr.eq.1)print *,'  udm zdm l3',udm,zdm,l3
	end if

	CALL DIFMF_1()

	i_en=i_en+1

	if(i_en.eq.1)then
	CALL TOKK(N,RS0)
	do i=2,n
	c20_help(i)=c20(i)
	end do
	end if


	if(ntay.le.-next)then
	do i=2,n
	psi(i)=-c20_help(i)/c2(i)	   
	dm0(i)=dm0(i-1)+psi(i)*ha(i)
	dmn(i)=dm0(i)
	q(i)=-pfi(i)/psi(i)
	end do
	end if

	if(kpr.eq.1)print *,' dmn dm0',dmn(n),dm0(n)
c
c------------------
	udd_pl=-(tpl*pll-tpl0*pll0)/(tay*100.)
	if(kpr.eq.1)print *,' udd_pf udd_pl',udd,udd_pl
        udd_tot=udd+udd_pl
c------------------
	udd_dif=-(dm0(n)-dmn(n))/(tay*100.)
	udd_ps=-2.*pi*(psval(n)-psval0(n))/(tay*100.)
	if(kpr.eq.1)print *,' udd_dif udd_ps',udd_dif,udd_ps

	u_ax=-(dm0(1)-dmn(1))/(tay*100.)
	udd_psa=-2.*pi*(psval(1)-psval0(1))/(tay*100.)

        if(kpr.eq.1)print *,' u_ax udd_psa ',u_ax,udd_psa

	do i=1,n
	qx(i)=q(i)
	end do

	tpl_tor=-coef*c2(n)*psi(n)

	if(ntay.gt.next)tpl=tpl_tor
	if(kpr.eq.1)print *,' tpl tpl_tor ==',tpl,tpl_tor

	return
	end


	subroutine pol_data_t()
        include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *	/ge1/pi
     *	/ge1e/rs0,tpl
     *  /ge5/kpr
	common
     *  /pol1/RO(npo,ntet),AJ(npo,ntet)
     *  /pol5e/um1,vm1,um2,vm2
     *  /pol2/Qx(npo),ANUx(npo),Px(npo),Fx(npo),
     *   PPxx(npo),PFFxx(npo)
     *  /pol4/UM,VM,UK(ntet),VK(ntet)
	common
     *  /DFM2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)

	do i=2,n
	ppxx(i)=pp(i)
	pffxx(i)=pff(i)
	anux(i)=-psi(i)/(2.*pi*rs0)
	do j=1,mp
	aj(i,j)=anux(i)
	end do
	end do

	return
	end
c
	subroutine polar_data()
        include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *	/ge1/pi
     *  /ge2/NTAY,TAY,TT
     *  /ge5/kpr
	common
     *	/ge1e/rs0,tpl
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
	common
     *  /pol1/RO(npo,ntet),AJ(npo,ntet)
     *  /pol4/UM,VM,UK(ntet),VK(ntet)
     *  /pol5e/um1,vm1,um2,vm2
     *  /pol2/Qx(npo),ANUx(npo),Px(npo),Fx(npo),
     *   PPxx(npo),PFFxx(npo)
     *  /pol5/psend
     *  /pol6/ppx(npo),pffx(npo)
     *  /pol6d/ppxd(npo),pffxd(npo)
	common
     *  /DFM2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)
     *  /dfm7/bt0,uind
        common
     *	/efit5/it1,it2
	common
     *  /halo4/expfg,avalb,w_h,del_r,al0

	if(kpr.eq.1)print *,' n mp PTOKE psend==',n,mp,psend
	if(kpr.eq.1)print *,' pi rs0==',pi,rs0
	if(ntay.gt.0)psend=(dm0(n)-dm0(1))*2.*ai(n)
	if(kpr.eq.1)print *,' DIFMF psend==',psend


	dpsi=psend/(2.*ai(n))
	do i=2,n
	psi(i)=2.*ai(i)*dpsi
	anux(i)=-psi(i)/(2.*pi*rs0)
	end do
c
c	if(ntay.gt.1.and.it2.eq.0)then
c	do i=1,n
c	ppx(i)=ppxd(i)
c	pffx(i)=pffxd(i)
c	end do
c	end if

	do i=2,n
	pp(i)=0.5*(ppx(i)+ppx(i-1))
	pff(i)=0.5*(pffx(i)+pffx(i-1))
	ppxx(i)=pp(i)
	pffxx(i)=pff(i)
	end do
c
	do i=1,n
	do j=1,mp
	aj(i,j)=anux(i)
	end do
	end do
c
	return
	end

	subroutine cur_prof()
        include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *	/ge1e/rs0,tpl
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
     *  /ge5/kpr
     *  /ge6/zeff(npo),qpr(npo),ppr(npo),pr0,prg,zar
     *  /ge6e/zeff_a,zeff_b
	common
     *  /pol6/ppx(npo),pffx(npo)
	common
     *	/efit0/kefit
     *	/efit1/alfax(2),betax(2)
     *	/efit2/alfa0,beta,alfa1
     *	/efit3/pw_1,pw_2
	common
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)
	common
     *  /en1/PNE(npo),PD0(npo),PT0(npo),PH0(npo),PDN(npo),
     *  PTN(npo),PHN(npo)
     *  /en1e/te_a,ti_a,te_b,ti_b,pw_e
     *  /en2e/pd0_a,pt0_a,pd0_b,pt0_b,pw_p
     *  /en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),WE0(npo),
     *  WQ0(npo)

	character *20 yy,apr

	if(kpr.eq.1)print *,' alfa0 beta alfa1 rs0',alfa0,beta,alfa1,rs0

	if(kpr.eq.1)print *,' KEFIT++++++++++++++++',kefit

	do i=1,n
c____________________________________________________
	xpsi=a(i)**2
	if(kEFIT.eq.1) then
        ppx(i)=alfax(1)+alfax(2)*xpsi-(alfax(1)+alfax(2))*xpsi**2
	ppx(i)=-alfa0*ppx(i)*rs0*1.e-2
	pffx(i)=betax(1)+betax(2)*xpsi-
     *  (betax(1)+betax(2))*xpsi**2
	pffx(i)=-alfa0*2.*pffx(i)/(rs0*1.e-2)
	end if
c________________________________________________
	if(kEFIT.eq.0) then
	ppx(i)=-alfa0*beta*(1.-a(i)**pw_1)
	pffx(i)=-2.*alfa0*(1.-beta)*(1.-a(i)**pw_1)**pw_2
	end if
c
	if(kEFIT.eq.2) then
	expa=exp(alfa1)
	expx=exp(alfa1*(1.-xpsi))
	expon=(expx-1.)/(expa-1.)
	ppx(i)=-alfa0*beta*expon
	pffx(i)=-2.*alfa0*(1.-beta)*expon
	end if
	end do
c
	ppx(1)=ppx(2)
	pffx(1)=pffx(2)

	do i=1,n
	psix=a(i)
c	pd0(i)=pd0_b+(1.-psix**pw_p)*(pd0_a-pd0_b)
c	pt0(i)=pt0_b+(1.-psix**pw_p)*(pt0_a-pt0_b)
        ppp=1.
	pd0(i)=pd0_b+((1.-psix**pw_p))**ppp*(pd0_a-pd0_b)
!	pt0(i)=pt0_b+((1.-psix**pw_p))**ppp*(pt0_a-pt0_b)
	pne(i)=pd0(i)+pt0(i)
	te0(i)=te_b+(1.-psix**pw_e)*(te_a-te_b)
	tq0(i)=ti_b+(1.-psix**pw_e)*(ti_a-ti_b)
     	zeff(i)=zeff_a+(zeff_b-zeff_a)*psix
	end do


	apr='ppx'
	if(kpr.eq.1)print 71,apr,(ppx(j),j=1,n)
	apr='pffx'
	if(kpr.eq.1)print 71,apr,(pffx(j),j=1,n)


c        pause 'from cur_prof'



71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

	i=n
	p(i)=(te0(i)+tq0(I))*(pd0(i)+pt0(I))*200.*1.e-6
	yy='te0'
c	call prof(te0,a,n,yy)
	yy='tq0'
c	call prof(tq0,a,n,yy)
	yy='pne'
c	call prof(pne,a,n,yy)
	yy='pd0'
c	call prof(pd0,a,n,yy)
	yy='pt0'
c	call prof(pt0,a,n,yy)

	return
	end

	subroutine pl_bound_p()

        include 'double.inc'
	include 'parf0'
	character *20 yy
	common
     *	/n_m/n,m,mp
	common
     *  /keys5/next
	common
     *	/ge1e/rs0,tpl
     *  /ge2/NTAY,TAY,TT
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
     *  /ge5/kpr
     *	/ge7/eu,rs,zout,eksk
     *  /ge8/pcch
     *  /ge8e/pcchp
	common
     *  /pol4/UM,VM,UK(ntet),VK(ntet)
     *  /pol5e/um1,vm1,um2,vm2
	common
     *  /eq7e/tet_p(ntet)
	common
     *  /mid2/vi(npo),spo(npo)
	common
     *  /dfm7/bt0,uind
     *  /dfm9/aj0(npo)
	common
     *	/efit6/tpl_p

	call shape(tt,rs_p,p_p,el_p,tpl_p,bt0_p,eu_p,z_p)

	rs=rs_p
	if(ntay.le.next) tpl=tpl_p

	eksk=el_p
	eu=eu_p
	bt0=bt0_p
	pcchp=p_p
c	if(kpr.eq.1)print *,' tt mp',tt,mp
	if(kpr.eq.1)print *,' tpl_p  ',tpl_p
	if(kpr.eq.1)print *,'  rs eksk ',rs,eksk
	if(kpr.eq.1)print *,' eu bt0 pcchp',eu,bt0,pcchp
c----------------
	if(ntay.le.1)then
	um=rs
	um1=um
	um2=um
	vm=z_p
	vm1=vm
	vm2=vm
	if(kpr.eq.1)print *,' um eu elong',um,eu,eksk
	end if
c
	do jj=1,mp
	uk(jj)=rs+eu*cos(tet_p(jj))
	vk(jj)=z_p+eksk*eu*sin(tet_p(jj))
	end do
	v_min=vk(1)
	v_max=vk(1)
	do j=1,mp
	v_min=amin1(v_min,vk(j))
	v_max=amax1(v_max,vk(j))
	end do
	if(kpr.eq.1)print *,' v_min v_max',v_min,v_max
c
	yy='bound'
c	call prof(vk,uk,mp,yy)
c	stop
	return
	end
c

	subroutine pl_bound()

        include 'double.inc'
	include 'parf0'
	character *20 yy
	common
     *	/n_m/n,m,mp
	common
     *  /keys5/next
	common
     *	/ge1e/rs0,tpl
     *  /ge2/NTAY,TAY,TT
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
     *  /ge5/kpr
     *	/ge7/eu,rs,zout,eksk
     *  /ge8/pcch
     *  /ge8e/pcchp
	common
     *  /pol4/UM,VM,UK(ntet),VK(ntet)
	common
     *  /eq7e/tet_p(ntet)
        common
     *	/efit6/tpl_p
	common
     *	/point1/r0,z0

c
	do jj=1,mp
	uk(jj)=rs+eu*cos(tet_p(jj))
	vk(jj)=zout+eksk*eu*sin(tet_p(jj))
	end do
	v_min=vk(1)
	v_max=vk(1)
	do j=1,mp
	v_min=amin1(v_min,vk(j))
	v_max=amax1(v_max,vk(j))
	end do

	if(kpr.eq.1)print *,' rs eu eksk',rs,eu,eksk
	if(kpr.eq.1)print *,' v_min v_max',v_min,v_max

	return
	end

	subroutine angl_p()
        include 'double.inc'
c	implicit real *8 (a-h,o-z)
	include 'parf0'
c---
	common
     *	/n_m/n,m,mp
	common
     *	/ge1/pi
     *  /ge5/kpr
	common
     *  /eq7/tet(ntet),ht(ntet)
     *  /eq7e/tet_p(ntet)
	character *12 apr

	mp1=mp-1
	do jj=2,mp
!	j=2.*jj-2
	j=jj
	tet_p(jj)=tet(j)
	end do
	tet_p(1)=tet_p(2)-(tet_p(mp)-tet_p(mp1))
	if(kpr.eq.1)print *,' tet 1 2',tet_p(1),tet_p(2)
	if(kpr.eq.1)print *,' tet mp1 mp',tet_p(mp1),tet_p(mp)
	return
	end

	subroutine anglep()
        include 'double.inc'
c	implicit real *8 (a-h,o-z)
	include 'parf0'
c---
	common
     *	/n_m/n,m,mp
	common
     *	/ge1/pi
     *  /ge5/kpr
	common
     *  /eq6/sinus(ntet),cosin(ntet)
     *  /eq7/tet(ntet),ht(ntet)
	character *12 apr
c---

	m1=m-1
	if(kpr.eq.1)print *,' n m mp m1 pi',n,m,mp,m1,pi
      TETM=2.*PI
      H2=TETM/(M-2)
      DO 15 J=2,M
   15 TET(J)=(J-2)*H2
	tet(1)=tet(m1)
c
      DO 16 J=3,M
   16 HT(J)=TET(J)-TET(J-1)
      HT(2)=HT(M)
c
c  here we change tet(j) dependence.
	alftet=0.95
	alftet1=1./alftet
	kj=3
	kji=kj
	do j=kji,m
	if(tet(j).le.0.5*pi+0.001)then
	ht(j)=ht(j-1)*alftet
c	if(kpr.eq.1)print *,'j tet(j) ht(j)',j,tet(j),ht(j)
	kj=kj+1
	end if
	end do
	ht(kj)=ht(kj-1)
c	if(kpr.eq.1)print *,'j tet(j) ht(j)',kj,tet(kj),ht(kj)
	kj=kj+1
c______________________________________
	kji=kj
	do j=kji,m
	if(tet(j).gt.0.5*pi.and.tet(j).le.pi+0.001)then
	ht(j)=ht(j-1)*alftet1
c	if(kpr.eq.1)print *,'j tet(j) ht(j)',j,tet(j),ht(j)
	kj=kj+1
	end if
	end do
	ht(kj)=ht(kj-1)
c	if(kpr.eq.1)print *,'j tet(j) ht(j)',kj,tet(kj),ht(kj)
	kj=kj+1
c______________________________________
	kji=kj
	do j=kji,m
	if(tet(j).gt.pi.and.tet(j).le.1.5*pi+0.001)then
	ht(j)=ht(j-1)*alftet
c	if(kpr.eq.1)print *,'j tet(j) ht(j)',j,tet(j),ht(j)
	kj=kj+1
	end if
	end do
	ht(kj)=ht(kj-1)
c	if(kpr.eq.1)print *,'j tet(j) ht(j)',kj,tet(kj),ht(kj)
	kj=kj+1
c______________________________________
	kji=kj
	do j=kji,m
	if(tet(j).gt.1.5*pi)then
	ht(j)=ht(j-1)*alftet1
c	if(kpr.eq.1)print *,'j tet(j) ht(j)',j,tet(j),ht(j)
	kj=kj+1
	end if
	end do
c	if(kpr.eq.1)print *,'kj=',kj
c
	tetsum=0.
	do j=3,m
	tetsum=tetsum+ht(j)
	end do
	alftet=(2.*pi/tetsum)
c	if(kpr.eq.1)print *,'alftet=',alftet
	do j=3,m
	ht(j)=ht(j)*alftet
	tet(j)=tet(j-1)+ht(j)
	end do
	tet(1)=tet(m1)
	ht(2)=ht(m)
c______________________________________
	tetsum=0.
	do j=3,m
	tetsum=tetsum+ht(j)
	end do
	alftet=(2.*pi/tetsum)
c	if(kpr.eq.1)print *,'alftet=',alftet
	apr='tet(j)'
c	if(kpr.eq.1)print 71,apr,(tet(j),j=1,m)
c
c==========================
	do j=1,m
	sinus(j)=sin(tet(j))
	cosin(j)=cos(tet(j))
	end do
c================================
	apr='cos(j)'
c	if(kpr.eq.1)print 71,apr,(cosin(j),j=1,m)
c
	apr='sin(j)'
c	if(kpr.eq.1)print 71,apr,(sinus(j),j=1,m)
	return
	end
	subroutine anglep_kav()
	include 'double.inc'
c	implicit real *8 (a-h,o-z)                                            
	include 'parf0'                                                        
c---                                                                    
	common                                                                 
     *	/n_m/n,m,mp                                                      
	common                                                                 
     *	/ge1/pi                                                          
     *  /ge5/kpr                                                        
	common                                                                 
     *  /eq6/sinus(ntet),cosin(ntet)                                    
     *  /eq7/tet(ntet),ht(ntet)                                         
	character *30 apr                                                      
	dimension a_print(200)
c---                                                                    
                                                                        
	m1=m-1                                                                 
!	if(kpr.eq.1)print *,' n m mp m1 pi',n,m,mp,m1,pi                      
      TETM=2.*PI                                                        
      H2=TETM/(M-2)                                                     
      DO 15 J=2,M                                                       
   15 TET(J)=(J-2)*H2                                                   
	tet(1)=tet(m1)                                                         
c                                                                       
      DO 16 J=3,M                                                       
   16 HT(J)=TET(J)-TET(J-1)                                             
      HT(2)=HT(M)                                                       
c                                                                       
c  here we change tet(j) dependence.    

	tet_sep=pi+0.645*0.5*pi
	d_tet_sep=0.4*pi

	a_print(1)=tet_sep
	a_print(2)=d_tet_sep
	a_print(3)=pi
	apr=' ** tet_sep  d_tet_sep pi**'

	n_pr=3

	num=25

c	call out42(n_pr,a_print,num,apr)




                                
c	alftet=0.85                                                            
	alftet=1.d0                                                            
	alftet1=1.d0/alftet                                                      

	do j=3,m                                                             
	if(tet(j).gt.tet_sep-d_tet_sep.and.tet(j).le.tet_sep)then                                         
	ht(j)=ht(j-1)*alftet                                                   

	end if                                                                 

	if(tet(j).lt.tet_sep+d_tet_sep.and.tet(j).gt.tet_sep)then                        
	ht(j)=ht(j-1)*alftet1                                                  



	end if   
	                                                              



	end do                                                                 

	tetsum=0.                                                              
	do j=3,m                                                               
	tetsum=tetsum+ht(j)                                                    
	end do                                                                 
	alftet=(2.*pi/tetsum)                                                  
c	print *,'alftet=',alftet                                              
	do j=3,m                                                               
	ht(j)=ht(j)*alftet                                                     
	tet(j)=tet(j-1)+ht(j)  
	
	a_print(1)=j
	a_print(2)=tet(j)
	a_print(3)=ht(j)
	apr=' ** j tet ht**'

	n_pr=3

	num=25

c	call out42(n_pr,a_print,num,apr)


	                                                
	end do                                                                 
	tet(1)=tet(m1)                                                         
	ht(2)=ht(m)                                                            
c______________________________________                                 
	tetsum=0.                                                              
	do j=3,m                                                               
	tetsum=tetsum+ht(j)                                                    
	end do                                                                 
	alftet=(2.*pi/tetsum)                                                  
c	print *,'alftet=',alftet                                              
	apr='tet(j)'                                                           
c	print 71,apr,(tet(j),j=1,m)                                           
c                                                                       
c==========================                                             
	do j=1,m                                                               
	sinus(j)=dsin(tet(j))                                                   
	cosin(j)=dcos(tet(j))                                                   
	end do                                                                 
c================================                                       
	apr='cos(j)'                                                           
c	print 71,apr,(cosin(j),j=1,m)                                         
c                                                                       
	apr='sin(j)'                                                           
c	print 71,apr,(sinus(j),j=1,m)                                         
	return                                                                 
	end                                                                    

      SUBROUTINE ONE2d()
      include 'double.inc'
c-------------------------------------                                  
c   initial values and profiles                                         
c-----------------------------------                                    
c	implicit real*8 (a-h,o-z)                                             
	include 'parf0'                                                        
	common                                                                 
     *	/n_m/n,m,mp                                                      
      COMMON                                                            
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)                     
     *  /ge5/kpr                                                        
	common                                                                 
     *	/pol1/ro(npo,ntet),aj(npo,ntet)                                  
     *	/pol3/Ax(npo),TET(ntet),HAx(npo),HT(ntet)                        
	character *12 apr                                                      
                                                                        
c                                                                       
c 
	                                                                      
      AI(1)=0.                                                          
      HA(1)=0.                                                          
      N1=N-1                                                            
      M1=M-1                                                            
      A0(1)=0.                                                          
      A(1)=0.                                                           
      A0(2)=0.                                                          
      DO 11 I=2,N   
	                                                    
!	xx=i-1.5d0                                                               
!	a(i)=xx/(n-1.5d0)                                                        
                                                                        
	xx=i-1.d0                                                               
	a(i)=xx/(n-1.d0)                                                        
                                                                        
	a0(i)=a(i)                                                             
c	a(i)=(1.-dexp(-alf*a(i)))/(1.-dexp(-alf))                             
c     	a(i)=a(i)**(1.5-0.5*a(i))*(1.-dexp(-alf*a(i)))/(1.-dexp(-alf))   
c	a(i)=a(i)**(1.5-0.5*a(i))                                             
c	a(i)=(i-1.)/(n2-1)*0.995                                              
c      A(I)=SQRT(A(I))                                                  
	ha(i)=a(i)-a(i-1)                                                      
   11 CONTINUE                                                          
c                                                                        
	alf=0.95d0                                                               
c	alf=0.9                                                               
                                                                        
c	alf=1.d0                                                                
                                                                        
	do i=2,n                                                               
	if(i.ge.n/2)ha(i)=ha(i-1)*alf                                          
	end do                                                                 
c	do i0=2,n                                                             
c	i=n-i0+2                                                              
c	if(i.le.n/3)ha(i-1)=ha(i)*alf                                         
c	end do                                                                
	sum=0.                                                                 
	do i=2,n                                                               
	sum=sum+ha(i)                                                          
	end do                                                                 
	al1=1./sum                                                             
	do i=2,n                                                               
	ha(i)=ha(i)*al1                                                        
	a(i)=a(i-1)+ha(i)                                                      
	end do                                                                 
c                                                                       
      A(N)=1.                                                           
	apr='a(i)'                                                             
!	if(kpr.eq.1)print 71,apr,(a(i),i=1,n)                                 
c                                                                       
      DO 1 I=2,N                                                        
	a0(i)=a(i-1)                                                           
      HA(I)=A(I)-A(I-1)                                                 
    1 CONTINUE                                                          
	apr='ha'                                                               
!	if(kpr.eq.1)print 71,apr,(ha(i),i=1,n)                                
      DO 31 I=2,N                                                       
      AI(I)=0.5*(A(I)+A(I-1))                                           
	ha2(i-1)=ai(i)-ai(i-1)                                                 
31	continue                                                             
      HA2(N)=a(n)-ai(n)                                                 
	apr='ai'                                                               
!	if(kpr.eq.1)print 71,apr,(ai(i),i=1,n)                                
	apr='ha2'                                                              
!	if(kpr.eq.1)print 71,apr,(ha2(i),i=1,n)                               
	do i=1,n                                                               
	ax(i)=a(i)                                                             
	hax(i)=ha(i)                                                           
	end do                                                                 
	apr='hax'                                                              
!	if(kpr.eq.1)print 71,apr,(hax(i),i=1,n)                               
c                                                                       
c   initial ro(i,j)                                                     
	do i=1,n                                                               
	do j=1,m                                                               
	ro(i,j)=a(i)                                                           
	end do                                                                 
	end do                                                                 
c                                                                       
c==========================                                             
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))                                      
101	continue                                                            
      RETURN                                                            
      END                                                               
                                                                        

      SUBROUTINE ONE2()
c-------------------------------------
c   initial values and profiles
c-----------------------------------
        include 'double.inc'
c	implicit real*8 (a-h,o-z)
	include 'parf0'
	common
     *	/n_m/n,m,mp
      COMMON
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
     *  /ge5/kpr
	common
     *	/pol1/ro(npo,ntet),aj(npo,ntet)
     *	/pol3/Ax(npo),TET(ntet),HAx(npo),HT(ntet)
	character *12 apr

c
c
      AI(1)=0.
      HA(1)=0.
      N1=N-1
      M1=M-1
      A0(1)=0.
      A(1)=0.
      A0(2)=0.

      DO 11 I=2,N

	xx=i-1.5
	a(i)=xx/(n-1.5)

!	xx=i-1.d0                                                               
!	a(i)=xx/(n-1.d0)                                                        

	a0(i)=a(i)


c	a(i)=(1.-dexp(-alf*a(i)))/(1.-dexp(-alf))
c     	a(i)=a(i)**(1.5-0.5*a(i))*(1.-dexp(-alf*a(i)))/(1.-dexp(-alf))
c	a(i)=a(i)**(1.5-0.5*a(i))
c	a(i)=(i-1.)/(n2-1)*0.995
c      A(I)=SQRT(A(I))
	ha(i)=a(i)-a(i-1)
   11 CONTINUE
c	alf=0.95
	alf=0.95d0
!	alf=1.
	do i=2,n
	if(i.ge.n/2)ha(i)=ha(i-1)*alf
	end do
c	do i0=2,n
c	i=n-i0+2
c	if(i.le.n/3)ha(i-1)=ha(i)*alf
c	end do
	sum=0.
	do i=2,n
	sum=sum+ha(i)
	end do
	al1=1./sum
	do i=2,n
	ha(i)=ha(i)*al1
	a(i)=a(i-1)+ha(i)
	end do
c
      A(N)=1.
	apr='a(i)'
	if(kpr.eq.1)print 71,apr,(a(i),i=1,n)
c
      DO 1 I=2,N
	a0(i)=a(i-1)
      HA(I)=A(I)-A(I-1)
    1 CONTINUE
	apr='ha'
	if(kpr.eq.1)print 71,apr,(ha(i),i=1,n)
	ai(2)=0.
      DO 31 I=3,N
      AI(I)=0.5*(A(I)+A(I-1))
	ha2(i-1)=ai(i)-ai(i-1)
31	continue
	ai(2)=0.5*a(2)
      HA2(N)=a(n)-ai(n)
	apr='ai'
	if(kpr.eq.1)print 71,apr,(ai(i),i=1,n)
	apr='ha2'
	if(kpr.eq.1)print 71,apr,(ha2(i),i=1,n)
	do i=1,n
	ax(i)=a(i)
	hax(i)=ha(i)
	end do
	apr='hax'
	if(kpr.eq.1)print 71,apr,(hax(i),i=1,n)
c
c   initial ro(i,j)
	do i=1,n
	do j=1,m
	ro(i,j)=a(i)
	end do
	end do
c
c==========================
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))
101	continue
      RETURN
      END

	subroutine feeti(n,PSI,aval,x,xp)
        include 'double.inc'
	DIMENSION psi(n),x(n)
c
	n1=n-1
c
c
	do i=1,n1
	if( (xp-x(i+1))*(xp-x(i)).gt.0.)go to 11
c
	if( (i-1)*(i-n1).lt.0) then
	call fit(1,x(i-1),x(i),x(i+1),x(i+2),psi(i-1),
     *  psi(i),psi(i+1),psi(i+2),xp,aval,yq)
	return
	end if
c
	if( i.eq.1) then
	call fit(1,x(i),x(i+1),x(i+2),x(i+3),psi(i),
     *  psi(i+1),psi(i+2),psi(i+3),xp,aval,yq)
	aval=aval
	yq=yq
	return
	end if
c
	if( i.eq.n1) then
	call fit(1,x(i-2),x(i-1),x(i),x(i+1),psi(i-2),
     *  psi(i-1),psi(i),psi(i+1),xp,aval,yq)
	aval=aval
	yq=yq
	end if
11	continue
	end do
	return
	end

	subroutine feet_p(n,PSI,aval,x,xp)
        include 'double.inc'
	DIMENSION psi(n),x(n)
c
	n1=n-1

	do i=1,n1
	if( (xp-x(i+1))*(xp-x(i)).gt.0.)go to 11
c
	if(i.ne.1) then
	call fit_p(psi,x,n,i,xp,aval)
	return
	end if
c
	if( i.eq.1) then
	call fit_p(psi,x,n,i+1,xp,aval)
	return
	end if
11	continue
	end do
	return
	end
	subroutine fit_p(f,ai,n,i,x,y)
        include 'double.inc'
        common
     *  /ge5/kpr
c---------------------------------------------
c  quadratic polinomial interpolation for array
c  from transport to equilibrium
c-----------------------------------------------
c       implicit real*8 (a-h,o-z)

	dimension f(n),ai(n)

	data err /1.e-14/

	delt=ai(i+1)**2*ai(i)+ai(i)**2*ai(i-1)+
     *  ai(i-1)**2*ai(i+1)-
     *  ai(i-1)**2*ai(i)-ai(i)**2*ai(i+1)-ai(i+1)**2*ai(i-1)

	if(abs(delt).lt.err)then
	   if(kpr.eq.1)print *,' i ai',i,ai(i-1),ai(i),ai(i+1)

 	call linear(n,f,y,ai,x)

	return
	end if


	aak=(f(i+1)*ai(i)+f(i)*ai(i-1)+f(i-1)*ai(i+1)-
     *  f(i-1)*ai(i)-f(i)*ai(i+1)-f(i+1)*ai(i-1))/delt

	bbk=(ai(i+1)**2*f(i)+ai(i)**2*f(i-1)+ai(i-1)**2
     *  *f(i+1)-
     *  ai(i-1)**2*f(i)-ai(i)**2*f(i+1)-ai(i+1)**2
     *  *f(i-1))/delt

	cck=f(i)-aak*ai(i)**2-bbk*ai(i)

	y=aak*x*x+bbk*x+cck

	return
	end


 	subroutine linear(n,PSI,aval,x,xp)
        include 'double.inc'
c	implicit real *8 (a-h,o-z)
	dimension  psi(n),x(n)
c
	n1=n-1
c
	do i=1,n1
	if( (xp-x(i+1))*(xp-x(i)).gt.0.)go to 11
c
	aval=psi(i)+(xp-x(i))*(psi(i+1)-psi(i))/(x(i+1)-x(i))

11	continue
	end do
	return
	end

	subroutine polar_data_tor()
	include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *	/ge1/pi
     *  /ge2/NTAY,TAY,TT
	common
     *	/ge1e/rs0,tpl
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
     *	/ge7/eu,rs,zout,eksk
	common
     *  /pol1/RO(npo,ntet),AJ(npo,ntet)
     *  /pol4/UM,VM,UK(ntet),VK(ntet)
     *  /pol5e/um1,vm1,um2,vm2
     *  /pol2/Qx(npo),ANUx(npo),Px(npo),Fx(npo),
     *   PPxx(npo),PFFxx(npo)
     *  /pol5/psend
     *  /pol6/ppx(npo),pffx(npo)
	common
     *  /mid1/C1(npo),C2(npo),C3(npo)                                   
	common
     *  /DFM2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)
     *  /dfm7/bt0,uind

	common
     *  /n_polar1/n_polar
        common
     * /c_gen1/delta_sh
	common
     *  /dfm3/dfmax(npo),dfmax0(npo)                                    
	common
     *  /halo2/kmaj,k_q,k_d,kaxis,ndisrup
     *  /halo2e/next0,li_drop,n_li,n_dif,nmix
     *  /halo4/expfg,avalb,w_h,del_r,al0                                


	dimension ro_help(npo,ntet)

	i_en=i_en+1

	if(i_en.eq.1)then
        do i=2,n
           do j=1,mp
              ro_help(i,j)=ro(i,j)
           end do
	um_help=um
	vm_help=vm
        end do

	end if

	do i=2,n                                                               
	psi_i=psi(i)
	anux(i)=-psi_i/(2.*pi*rs0)                                         
	end do                                                                 

	
	do i=2,n                                                               
	ppxx(i)=pp(i)
	pffxx(i)=pff(i)
	end do                                                                 
c                                                                       
	do i=1,n                                                               
	do j=1,mp                                                              
	aj(i,j)=anux(i)                                                        
	end do                                                                 
	end do  

        do i=2,n
           do j=1,mp
              ro(i,j)=ro_help(i,j)
           end do
        end do
c	um=um_help
c	vm=vm_help


        pt0z=-tpl

        kp=1
!!!        if(n_dif.eq.1)kp=0

	k_polar=1

	if(abs(del_r).gt.0.1)k_polar=0

c	if(ntay.gt.ndisrup)k_polar=0
	if(ntay.gt.2)k_polar=0

	
        if(k_polar.eq.1)then 
c	   if(ntay.gt.1)call eqb()
c	   if(ntay.le.1)CALL POLAR1(n,mp,rs0,kp,pt0z)
	   CALL POLAR1(n,mp,rs0,kp,pt0z)
c	   CALL POLAR1_tor(n,mp,rs0,kp,pt0z)
c	   CALL POLAR10(n,mp,rs0,kp,pt0z)
	end if


        do i=2,n
           do j=1,mp
              ro_help(i,j)=ro(i,j)
           end do
	um_help=um
	vm_help=vm
        end do

	return
	end
	subroutine transf_b_tor()                                              
	include 'double.inc'
	include 'parf0'                                                        
	common                                                                 
     *	/n_m/n,m,mp                                                      
	common                                                                 
     *	/ge1/pi                                                          
     *  /ge2/NTAY,TAY,TT                                                
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)                     
	common                                                                 
     *	/efit4/coef                                                      
	common                                                                 
     *  /eq4/xpl(npo,ntet),ypl(npo,ntet)                                
	common                                                                 
     *	/ge1e/rs0,tpl                                                    
     *  /ge5/kpr                                                        
	common                                                                 
     *  /pol1/RO(npo,ntet),AJ(npo,ntet)                                 
     *  /pol2/Qx(npo),ANUx(npo),Px(npo),Fx(npo),                        
     *   PPxx(npo),PFFxx(npo)                                           
     *  /pol4/UM,VM,UK(ntet),VK(ntet)                                   
     *  /pol5/psend                                                     
     *  /pol5e/um1,vm1,um2,vm2                                          
     *  /pol6/ppx(npo),pffx(npo)                                        
	common                                                                 
     *  /DFM2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)                       
     *  /dfm3/dfmax(npo),dfmax0(npo)                                    
     *  /dfm3e/dfmaxc(npo),dfmaxh(npo)                                  
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)            
     *  /dfm7/bt0,uind                                                  
     *  /dfm7e/bt0_0,f_na                                               
        COMMON                                                          
     *  /mid1/C1(npo),C2(npo),C3(npo)                                   
     *  /mid2/vi(npo),spo(npo)                                          
     *  /mid2e/vol(npo),spov(npo),pcur(npo)                             
     *  /mid3/GRA1(npo),GRA2(npo)                                       
	common                                                                 
     *  /en1/PNE(npo),PD0(npo),PT0(npo),PH0(npo),PDN(npo),              
     *  PTN(npo),PHN(npo)                                               
     *  /en1e/te_a,ti_a,te_b,ti_b,pw_e                                  
     *  /en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),WE0(npo),              
     *  WQ0(npo)                                                        
     *  /en33/anom_e,anom_i,key_t11,kcchp                               
	common                                                                 
     *  /halo4/expfg,avalb,w_h,del_r,al0                                
     *  /halo5/q_vde,q_95,del_f,i_halo                                  
     *  /halo9/fluxt,fluxt0                                             
     *  /halo9e/dfmax_h                                                 
     *  /halo10/fves,fves0,self_v                                       
     *  /halo11/fmaxv,fmaxv0                                            
                                                                        
	dimension qz(npo),poa(npo),aiz(npo)                                    
	dimension dfmax_help(npo),err_help(npo) 
                                                                        
	dimension a_print(200)
	character*30 apr
                                                                        
	apr='-f-'                                                              
c	!print 71,apr,(f(i),i=1,n)

	it_int=0
	fmax_in=dfmaxc(n)
	
1	continue                                                              

 	it_int=it_int+1
c---------------------                                                  
                                                                        
	do i=1,n                                                               
	do j=1,mp                                                              
	xpl(i,j)=um+ro(i,j)*(uk(j)-um)                                         
	ypl(i,j)=vm+ro(i,j)*(vk(j)-vm)                                         
	end do                                                                 
	end do                                                                 
                                                                        
	call midc(n,mp,rs0)

c	call TOK_K(N,RS0)

c	stop

	dfmax(1)=0.                                                            
	do i=2,n                                                               
      fx(i)=f(i)                                                      
	dfmax_help(i)=dfmaxc(i)                                                
	pfi(i)=2.*pi*rs0*c3(I)*fx(i)                                           
	end do                                                                 
                                                                        
c--- transref to toroidal coordinates---                                
c                                                                       
	dfmaxc(1)=0.                                                           
	do i=2,n                                                               
	dfmaxc(i)=dfmaxc(i-1)+pfi(i)*ha(i)                                     
	end do                                                                 
c                                                                       
	fmax=dfmaxc(n)                                                         
c-----------------------------                                          
                                                                        
	poa(1)=0.                                                              
	aiz(1)=0.                                                              
	do i=2,n                                                               
	poa(i)=sqrt( dfmaxc(i)/fmax)                                           
	end do                                                                 
                                                                        
c---->  ro(i,j) variable...                                             
c                                                                       
	do j=1,mp                                                              
	do i=1,n                                                               
	qz(i)=ro(i,j)                                                          
	end do                                                                 
                                                                        
	do i=2,n-1                                                             
	call feet_p(n,qz,ro(i,j),poa,a(i))                                     
	end do                                                                 
                                                                        
	end do                                                                 
                                                                        
                                                                        
	apr='-poa-'                                                            
c	print 71,apr,(poa(i),i=1,n)                                           
	apr='-a-'                                                              
c	print 71,apr,(a(i),i=1,n)                                             
                                                                        
	apr='-dfmax_h-'                                                        
c	print 71,apr,(dfmax_help(i),i=1,n)                                    
	apr='-dfmaxc-'                                                         
c	print 71,apr,(dfmaxc(i),i=1,n)                                        
                                                                        
	err=0.                                                                 
	do i=2,n                                                               
	diff=abs(poa(i)-a(i))/a(i)                                             
	err=amax1(err,diff)                                                    
	end do                                                                 
                                                                        
	errp=0.                                                                
	do i=2,n                                                               
	diff=abs(dfmax_help(i)-dfmaxc(i))/dfmaxc(i) 
	err_help(i)=diff                           
	errp=amax1(errp,diff)                                                  
	end do                                                                 
                                                                        
	if(kpr.eq.1)print *,' errp err  ',errp,err   
	             
 	a_print(1)=err
	a_print(2)=errp
	a_print(3)=it_int
	a_print(4)=fmax_in
	a_print(5)=fmax
	n_pr=5
	apr=' ** err errp it f_in f **'

	num=25

!	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)

      do i=1,n
 	a_print(i)=err_help(i)
 	end do
	n_pr=n
	apr=' ** err_help **'
	num=25

!	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)


                                                                        
	if(errp.gt.1.e-5.and.it_int.lt.10)go to 1         
	if(err.gt.1.e-5.and.it_int.lt.10)go to 1        

	dfmax(1)=0.                                                            
	do i=2,n                                                               
	dfmax(i)=dfmaxc(i)  
	q(i)=-pfi(i)/psi(i)
	end do


	tok=0.                                                                 
	co_n=1.                                                                
	do i=2,n                                                               
	if(i.eq.n)co_n=0.5                                                     
        TOK=tok-co_n*coef*( PP(I)*VI(I)/RS0 +                           
     *  0.5*PFF(I)*RS0*2.*PI*c3(i) )*ha(i)                              
	end do
	tpl_1=-coef*c2(n)*psi(n)                                               
	if(kpr.eq.1)print *,'tpl tok tpl_1 ',tpl,tok,tpl_1                    


	a_print(1)=err
	a_print(2)=errp
	a_print(3)=tpl
	a_print(4)=tpl_1
	a_print(5)=it_int
	n_pr=5
	apr=' ** err errp tpl tpl_1 it_int  **'

	num=25

	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)

	apr='-q-'                                                              
	if(kpr.eq.1)print 71,apr,(q(i),i=1,n)

	apr='-q_eq-'                                                           
!	if(kpr.eq.1)print 71,apr,(q_eq(i),i=1,n)                              
                                                                        
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))                                      

	return
	end   



	subroutine ppx_pffx_corr()
	include 'double.inc'
c	implicit real *8 (a-h,o-z)
	include 'new_com.inc'

         call ppx_pffx_corr_c(
     *   rs0,
     *   n,ppx,pffx,a,pi,kpr)

         return
         end

         subroutine ppx_pffx_corr_c(
     *   rs0,
     *   n,ppx,pffx,a,pi,kpr)

	include 'double.inc'
c	 implicit real *8 (a-h,o-z)

         dimension 
     *   ppx(*),pffx(*),a(*)

	dimension a_print(200)
	character*30 apr

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))


	c_pol=0.2
	n_pol=c_pol*n

		call svd_bspline(
     *  n,n_pol,a,ppx)

	apr='ppx'
	if(kpr.eq.1)print 71,apr,(ppx(i),i=1,n)


	c_pol=0.2
	n_pol=c_pol*n

	  call svd_bspline(
     *  n,n_pol,a,pffx)


	apr='pffx'
	if(kpr.eq.1)print 71,apr,(pffx(i),i=1,n)



	return
	end




	subroutine time_st_ppx_pffx()
        include 'double.inc'
	include 'new_com.inc'

	call time_st_ppx_pffx_c(
     *  n,ppx,pffx,ppx1,pffx1,ppx2,pffx2)


	return
	end

	subroutine time_st_ppx_pffx_c(
     *  n,ppx,pffx,ppx1,pffx1,ppx2,pffx2)

        include 'double.inc'

	dimension  ppx(*),pffx(*),ppx1(*),pffx1(*),
     *  ppx2(*),pffx2(*)


	do i=1,n

	ppx2(i)=ppx1(i)
	ppx1(i)=ppx(i)

	pffx2(i)=pffx1(i)
	pffx1(i)=pffx(i)

	end do

	return
	end

	subroutine avr_ppx_pffx()
      include 'double.inc'
	include 'new_com.inc'

	call avr_ppx_pffx_c(
     *  n,ppx,pffx,ppx1,pffx1,ppx2,pffx2)


	return
	end

	subroutine avr_ppx_pffx_c(
     *  n,ppx,pffx,ppx1,pffx1,ppx2,pffx2)

      include 'double.inc'
	dimension  ppx(*),pffx(*),ppx1(*),pffx1(*),
     *  ppx2(*),pffx2(*)

	coef=0.5d0
c	coef=1.d0/3.d0

	do i=1,n

	ppx(i)=coef*(ppx(i)+ppx1(i))
	pffx(i)=coef*(pffx(i)+pffx1(i))

c	ppx(i)=coef*(ppx(i)+ppx1(i)+ppx2(i))
c	pffx(i)=coef*(pffx(i)+pffx1(i)+pffx2(i))
	end do

	return
	end



	subroutine ppx_pffx_corr2()
	include 'double.inc'
c	implicit real *8 (a-h,o-z)
	include 'new_com.inc'

         call ppx_pffx_corr2_c(
     *   rs0,
     *   n,ppx,pffx,a,pi,kpr)

         return
         end

         subroutine ppx_pffx_corr2_c(
     *   rs0,
     *   n,ppx,pffx,a,pi,kpr)

	include 'double.inc'
c	 implicit real *8 (a-h,o-z)

         dimension 
     *   ppx(*),pffx(*),a(*)

	dimension a_print(200)
	character*30 apr

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))


	c_pol=0.8
	n_pol=c_pol*n

	apr='ppx'
	if(kpr.eq.1)print 71,apr,(ppx(i),i=1,n)
	apr='pffx'
	if(kpr.eq.1)print 71,apr,(pffx(i),i=1,n)

	ppx_av=0.d0
	pffx_av=0.d0
	
	pk=0.d0
	do i=n_pol+1,n
	pk=pk+1.d0
	ppx_av=ppx_av+ppx(i)
	pffx_av=pffx_av+pffx(i)
	end do
	ppx_av=ppx_av/pk
	pffx_av=pffx_av/pk

	if(kpr.eq.1)print *,' pk ppx_av pffx_av',pk,ppx_av,pffx_av

	ip_max=0.5*(n_pol+n)

	ppx_1=ppx(n_pol)
	do i=n_pol,ip_max
	ppx(i)=ppx_1+(ppx_av-ppx_1)*
     * dfloat(i-n_pol)/dfloat(ip_max-n_pol)
	end do

	if_max=0.5*(n_pol+n)

	if(kpr.eq.1)print *,' ip_max if_max',ip_max,if_max

	pffx_1=pffx(n_pol)
	do i=n_pol,if_max
	pffx(i)=pffx_1+(pffx_av-pffx_1)*
     * dfloat(i-n_pol)/dfloat(if_max-n_pol)
	end do

	do i=ip_max,n
	ppx(i)=ppx(ip_max)*(1.d0-dfloat(i-ip_max)/dfloat(n-ip_max))
	end do

	do i=if_max,n
	pffx(i)=pffx(if_max)*(1.d0-dfloat(i-if_max)/dfloat(n-if_max))
	end do

	apr='--ppx'
	if(kpr.eq.1)print 71,apr,(ppx(i),i=1,n)
	apr='--pffx'
	if(kpr.eq.1)print 71,apr,(pffx(i),i=1,n)

	return
	end







	subroutine pet_tab()
	include 'double.inc'
c	implicit real *8 (a-h,o-z)
	include 'new_com.inc'

         call pet_tab_c(
     *   nutab,rs0,
c     *   pstab,pptab,fptab,
     *   n,ppx,pffx,a,pi,kpr)

         return
         end

         subroutine pet_tab_c(
     *   nutab,rs0,
c     *   pstab,pptab,fptab,
     *   n,ppx,pffx,a,pi,kpr)

	include 'double.inc'
	
	include 'parf0'

       dimension pstab(npo),pptab(npo),fptab(npo),
     *   ppx(*),pffx(*),a(*)

	character *20 apr

71	FORMAT(5X,A10/,(2x,6(1PE12.5)))

!	print *,' kpr from pet_tab==',kpr


         open (unit=41,file='tabppf.dat',form='formatted')
         read (41,*)nutab

         do i=1,nutab
            read (41,*)pstab(i),pptab(i),fptab(i)
         enddo

         close (41)

	coef_ff=1.
	do i=1,nutab
! OLD 	   pptab(i)=-pptab(i)*(rs0*1.e-2)*4.e-7*pi
	pstab(i)=dsqrt(pstab(i))
	   pptab(i)=-pptab(i)*(rs0*1.d-2)*0.1d0
	   fptab(i)=-2.d0*fptab(i)/(rs0*1.d-2)*0.1d0
	end do


	do i=2,n-1
c	   psn=a(i)**2
	psn=a(i)
	   call linear(nutab,pptab,ppx(i),pstab,psn)
	   call linear(nutab,fptab,pffx(i),pstab,psn)

c	   call feeti(nutab,pptab,ppx(i),pstab,psn)
c	   call feeti(nutab,fptab,pffx(i),pstab,psn)

	end do

	ppx(n)=pptab(nutab)
	ppx(1)=pptab(1)

	pffx(n)=fptab(nutab)
	pffx(1)=fptab(1)

	ppx(n)=0.d0
	pffx(n)=0.d0


        if(kpr.eq.1)print *,' rs0 n nutab==',rs0,n,nutab

	apr=' a'
	if(kpr.eq.1)print 71,apr,(a(i),i=1,n)

	apr=' ppx'
	if(kpr.eq.1)print 71,apr,(ppx(i),i=1,n)

	apr=' pffx'
	if(kpr.eq.1)print 71,apr,(pffx(i),i=1,n)

	return
	end

	subroutine pet_tab_wr()
	include 'double.inc'
c	implicit real *8 (a-h,o-z)
	include 'new_com.inc'

         call pet_tab_wr_c(
     *   nutab,rs0,
     *   n,ppx,pffx,a,pi,kpr)

         return
         end

         subroutine pet_tab_wr_c(
     *   nutab,rs0,
     *   n,ppx,pffx,a,pi,kpr)

	include 'double.inc'
c	 implicit real *8 (a-h,o-z)

         dimension ppx(*),pffx(*),a(*)

	character *20 apr

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))

      open (unit=41,file='tabppf.txt',form='formatted')
      write (41,*)nutab

      do i=1,nutab
	   psn=a(i)**2
	   pptabi=-ppx(i)/(rs0*1.e-2)*10.d0
	   fptabi=-0.5d0*pffx(i)*(rs0*1.e-2)*10.d0
      write (41,*)psn,pptabi,fptabi
      enddo

      write (41,*)'  '
      close (41)

	return
	end


	subroutine dens_prog_dt()
        include 'double.inc'
	include 'new_com.inc'

	call dens_prog_dt_c(
     *  ntay,pd0_p,pt0_p)


	return
	end



	subroutine dens_prog_dt_c(
     *  ntay,pd0_p,pt0_p)

        include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *  /mid2/vi(npo),spo(npo)
	common
     *  /en1/PNE(npo),PD0(npo),PT0(npo),PH0(npo),PDN(npo),
     *  PTN(npo),PHN(npo)
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
     *  /ge5/kpr
     *  /ge8/pcch
     *  /ge8e/pcchp
     *  /en33/anom_e,anom_i,key_t11,kcchp
	character *12 apr
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

      PP_d=0.d0
      PP_t=0.d0

	ppch=0.
	vv=0.
	
	do i=2,n
      VV=VV+VI(I)*HA(I)
      p_ion_d=0.5*(Pd0(I)+Pd0(I-1))
      p_ion_t=+0.5*(Pt0(I)+Pt0(I-1))

      PP_d=PP_d+p_ion_d*VI(I)*HA(I)
      PP_t=PP_t+p_ion_t*VI(I)*HA(I)

	end do
        pp_d=PP_d/VV
        pp_t=PP_t/VV
        
	if(kpr.eq.1)print *,'===1 pp_d pd0_p=kcchp===',pp_d,pd0_p,kcchp
	if(kpr.eq.1)print *,'===1 pp_t pt0_p=kcchp===',pp_t,pt0_p,kcchp

!!!	if(ntay.lt.2)pcchp=pcch


	if(kcchp.eq.1)then
	al1_d=pd0_p/pp_d
	if(pp_t.gt.1.d-8)then
	al1_t=pt0_p/pp_t
	else
	al1_t=0.d0
	end if
	if(kpr.eq.1)print *,'===1 pp_d pd0_p=al1_d===',pp_d,pd0_p,al1_d
	if(kpr.eq.1)print *,'===1 pp_t pt0_p=al1_t===',pp_t,pt0_p,al1_t

	do i=1,n
!	   pne(i)=pne(i)*al1
         pd0(i)=pd0(i)*al1_d
         pt0(i)=pt0(i)*al1_t
	   pne(i)=pd0(i)+pt0(i)
        end do
	end if

	return
	end

	subroutine dens_prog_n0()
        include 'double.inc'
	include 'new_com.inc'
      include 'par_imp.inc'
      include 'new_imp.inc'

	call dens_prog_n0_c(
     *  ntay,pd0_p,pt0_p,prog_n0)


	return
	end



	subroutine dens_prog_n0_c(
     *  ntay,pd0_p,pt0_p,prog_n0)

        include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *  /mid2/vi(npo),spo(npo)
	common
     *  /en1/PNE(npo),PD0(npo),PT0(npo),PH0(npo),PDN(npo),
     *  PTN(npo),PHN(npo)
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
     *  /ge5/kpr
     *  /ge8/pcch
     *  /ge8e/pcchp
     *  /en33/anom_e,anom_i,key_t11,kcchp
	character *12 apr
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))



      Pd0(n)=0.1
 
      PP_d=0.d0
      PP_t=0.d0

	ppch=0.
	vv=0.
	
	do i=2,n
      VV=VV+VI(I)*HA(I)
      p_ion_d=0.5*(Pd0(I)+Pd0(I-1))
      p_ion_t=+0.5*(Pt0(I)+Pt0(I-1))

      PP_d=PP_d+p_ion_d*VI(I)*HA(I)
      PP_t=PP_t+p_ion_t*VI(I)*HA(I)

	end do
        pp_d=PP_d/VV
        pp_t=PP_t/VV
        
	if(kpr.eq.1)print *,'===1 pp_d pd0_p=kcchp===',pp_d,pd0_p,kcchp
	if(kpr.eq.1)print *,'===1 pp_t pt0_p=kcchp===',pp_t,pt0_p,kcchp

!!!	if(ntay.lt.2)pcchp=pcch


	al1_d=pd0_p/pp_d
	if(pp_t.gt.1.d-8)then
	al1_t=pt0_p/pp_t
	else
	al1_t=0.d0
	end if
	if(kpr.eq.1)print *,'===1 pp_d pd0_p=al1_d===',pp_d,pd0_p,al1_d
	if(kpr.eq.1)print *,'===1 pp_t pt0_p=al1_t===',pp_t,pt0_p,al1_t
      
      
      prog_n0=prog_n0*al1_d
	if(kpr.eq.1)print *,'===1 prog_n0=al1_d===',prog_n0,al1_d

	return
	end

