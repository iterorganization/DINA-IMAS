!> dina2 is a subroutine to do the DINA modeling in one time step,
!> In that subroutine the kpr.dat, tt_kavin.dat, k_jetto, tran_times.dat files
!> are written,
!> If tt>tt_dina and k_jetto=0 there are the calls to the external transport modules,
!> If tt<tt_kavin there is a call equil to simulate the one time DINA modeling with
!> energy and particle 0D transport modules,
!> If tt>tt_kavin there is a call equil2 to simulate the one time DINA modeling with
!> energy and particle 1D transport modules

	subroutine dina2(
!-----------------------------------  inputs---
     *  c_input1,c_input2,
!------------------------------------outputs
     *  c_output1,c_output2,c_output3)

      include 'double.inc'
	include 'new_com.inc'                                                  

      dimension c_input1(*),c_input2(*)
      dimension c_output1(*),c_output2(*),c_output3(*)

      parameter (kint=mu)

	dimension pf_xx(kint),gaps_xx(kint),tcam_xx(kint)

	dimension vchopper_x2(kint),shape_out(kint)

	character *30 apr,filename
	character *70 apr2

      integer, save :: i_en=0

	dimension a_print(200)

	common /c_data_in_time2/i_c_data,i_c_data1       

      common /c_tran2/k_ener_ext,k_dens_ext,k_ajb_ext
      
            common /c_imas_is/ih_imas
            common /c_kpr/kpr_c
      common /c_tran_times/tt_dina_c
      common /c_tt_kavin/tt_kavin_c

      common /c_ext_c16/k_ener_ext_c16,k_dens_ext_c16,k_ajb_ext_c16

!-----------------------------------  inputs---
!     *  vchopper_x2,tpl_x2,tt_dw_x2)

	
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))


      i_en=i_en+1

      
      if(i_en.eq.1)then

!        open (unit=1,file='kpr.dat',form='formatted')
!        read (49,*)
!        read (49,*)kpr
        kpr=kpr_c

        if(kpr.eq.1)print *,' i_en2==key_equil kpr ',i_en2,key_equil,kpr
        
        

!              i_con=3

!        close ( unit=1)       


!           open (unit=41,file='tt_kavin.dat',form='formatted') 
!           read (41,*)
!           read (41,*)tt_kavin,tt_dw
!  		   close (41)

           !tt_kavin=3500.d0
           tt_kavin = tt_kavin_c
           tt_dw=1.d+10

        if(kpr.eq.1)print *,'tt_kavin,tt =',
     *  tt_kavin,tt


      if(tt.gt.tt_kavin)then
      ih_imas=3
      else
      ih_imas=0
      do i=1,ncam
      tcam(i)=0.
      end do
      end if
      

!     		 open (unit=40,file='k_jetto.dat',form='formatted') 
!          read (40,*) 
!          read (40,*)k_jetto
!         close (40)
         
        if(kpr.eq.1)print *,'tt_kavin,tt_dw =',
     *  tt_kavin,tt_dw
      

        if(kpr.eq.1)print *,'k_jetto  ih_imas =',
     *  k_jetto,ih_imas

       	if(ih_imas.eq.3.and.i_en.eq.1)then
            k_ener_h=k_ener
!       	k_ener=0

	  rmag_h=rmag
	  zmag_h=zmag
	  tpl_h=tpl
        tt_h=tt
        	  
        end if
      
        if(kpr.eq.1)print *,'k_jetto i_en=',
     *  k_jetto,i_en

     		ARG=1.d0
	  pi=4.d0*atan(ARG)
	  coef=10.d0/(4.d0*pi)

	  call read_data() 
       	
       	if(ih_imas.eq.3.and.i_en.eq.1)then
!        call read_equil()
        tt_dina=tt_dina_c
        tt=tt_dina
!        call shape_equil()
!        call shape_equil2()
        
     	  rmag=rmag_h
	  zmag=zmag_h
	  tpl=tpl_h
        tt=tt_h

        end if
       
      	
	 call anglep_kav()


	  call angl_p()                                                          
	  call ONE2d()  



      if(ih_imas.eq.3)tt_kavin=-1.
      

      if(kpr.eq.1)print *,' tt tt_dina==',tt,tt_dina
      if(kpr.eq.1)print *,' tt tt_kavin==',tt,tt_kavin








     
      apr='+ai-' 
!      if(kpr.eq.1)print 71,apr,(ai(i),i=1,n) 


       if(ih_imas.eq.1)then 
        k_jetto=1
        call prof_astra()
        ih_imas=2
       end if

       if(ih_imas.eq.3)then 
!        k_jetto=1
!        call prof_astra()
        ih_imas=4
       end if


      end if

      if(i_en.eq.1.and.kpr.eq.1)then
!           Iopen=0
!      call OpenCloseConsole(Iopen) 
      end if

      if(i_en.gt.2)then
!      stop


        !tpl_x2=c_input1(1)      
        !tt_dw_x2=c_input1(2)   
        
        !if(kpr.eq.1)print *,'   tpl_x2,tt_dw_x2==', tpl_x2, tt_dw_x2

 !           call prof_astra()
            
      ! do i=1,npf
      !       vchopper_x2(i)=c_input2(i)
      !       if(kpr.eq.1)print *,'   vchopper_x2(i)==', i, vchopper_x2(i)
      ! end do
      
      ! do i=1,11
      !       zvconverter(i)=c_input2(npf+i)
      !       if(kpr.eq.1)print *,'   zvconverter(i)==', i, zvconverter(i)
      ! end do      

      ! do i=1,12
      !       u_kd(i)=c_input2(npf+11+i)
      !       if(kpr.eq.1)print *,'   u_kd(i)==', i, u_kd(i)
      ! end do      


      !call get_contr_signals(vchopper_x2,tpl_x2,tt_dw_x2)
      end if

      if(i_en.eq.1)then
      call vic_read_gaps()

!        open (unit=1,file='tran_times.dat',form='formatted')
!        read (49,*)
!        read (49,*)tt_dina
        tt_dina=tt_dina_c

      end if
      
!      tt_dina=1352.

 

       
      if(kpr.eq.1)print *,' tt== tt_dina==',tt,tt_dina

      call prof_dina_input()


      if(tt.gt.tt_dina.and.k_jetto.eq.0)then
!      if(tt.gt.2250.)then
!      if(tt.gt.5250.)then

      i_en_ext=i_en_ext+1

!      k_ener_ext=0
!      k_dens_ext=0
!      k_ajb_ext=0

      if(i_en_ext.eq.1)then
!          read (49,*) 
!          read (49,*)k_ener_ext, k_dens_ext,k_ajb_ext
          k_ener_ext=k_ener_ext_c16
          k_dens_ext=k_dens_ext_c16
          k_ajb_ext=k_ajb_ext_c16
      end if

      if(kpr.eq.1)print *,' FOR_EXT k_ener_ext k_dens_ext k_ajb_ext=='

       print *,' k_ener_ext k_dens_ext k_ajb_ext==',
     *   k_ener_ext,k_dens_ext,k_ajb_ext
      
!      k_ener_ext=1
!      k_dens_ext=1
!      k_ajb_ext=1
      
      nn2=n
      
!      if(tt.gt.tt_kavin)then

      if(k_ener_ext.eq.1)then

      call transp500(
!-----------------------------------  inputs---
     *  c_input1,c_input2,
!------------------------------------outputs
     *  c_output1,c_output2)
 	

	do i=1,n
	
	qde0(I)=c_output1(i)
	qdq0(I)=c_output2(i)
	
      end do


      DO I=1,n
    	c_input1(I)=qde0(i)
    	c_input2(I)=qdq0(i)
	end do

      apr='+QDE0_tran-' 
      if(kpr.eq.1)print 71,apr,(QDE0(i),i=1,nn2) 
      apr='+QDQ0_tran-' 
      if(kpr.eq.1)print 71,apr,(QDQ0(i),i=1,nn2) 
      
      end if

       if(k_ener_ext.eq.1)then
      
      call transp100(
!-----------------------------------  inputs---
     *  c_input1,c_input2,
!------------------------------------outputs
     *  c_output1,c_output2)

      TE0(n)=c_output1(n)
	Tq0(n)=c_output2(n)

      print *,' Boundary Energy te0 tq0=',TE0(n),Tq0(n)
 	
		do i=1,n
	
	TE0(I)=c_output1(i)
	Tq0(I)=c_output2(i)
	
      TE0_tran(I)=TE0(I)
	TQ0_tran(I)=Tq0(I)
      end do

      apr='+te0_tran-' 
      if(kpr.eq.1)print 71,apr,(te0(i),i=1,nn2) 
      apr='+tq0_tran-' 
      if(kpr.eq.1)print 71,apr,(tq0(i),i=1,nn2) 
 
      end if
      
      if(k_dens_ext.eq.1)then
      
      
      call transp200(
!-----------------------------------  inputs---
     *  c_input1,c_input2,
!------------------------------------outputs
     *  c_output1,c_output2,c_output3)
 	
      apr='+c_output2_tran-' 
      if(kpr.eq.1)print 71,apr,(c_output2(i),i=1,n) 
      apr='+c_output3_tran-' 
      if(kpr.eq.1)print 71,apr,(c_output3(i),i=1,n) 

	do i=1,n
	
	pd0(I)=c_output1(i)
	pt0(I)=c_output2(i)
	pne(I)=c_output3(i)
	
      pd0_tran(I)=pd0(I)
	pt0_tran(I)=pt0(I)
	pne_tran(I)=pne(I)
	
      end do
      apr='+pd0_tran-' 
      if(kpr.eq.1)print 71,apr,(pd0(i),i=1,n) 
      apr='+pt0_tran-' 
      if(kpr.eq.1)print 71,apr,(pt0(i),i=1,n) 
      apr='+pne_tran-' 
      if(kpr.eq.1)print 71,apr,(pne(i),i=1,n) 

      end if
      
      if(k_ajb_ext.eq.1)then
      
      call transp300(
!-----------------------------------  inputs---
     *  c_input1,c_input2,
!------------------------------------outputs
     *  c_output1,c_output2)
 	

	do i=1,n
	
	ajb(I)=c_output1(i)
	sigk(I)=c_output2(i)
	
      ajb_tran(I)=ajb(I)
	sigk_tran(I)=sigk(I)
      end do

      apr='+ajb_tran-' 
      if(kpr.eq.1)print 71,apr,(ajb(i),i=1,nn2) 
      apr='+sigk_tran-' 
      if(kpr.eq.1)print 71,apr,(sigk(i),i=1,nn2) 
      end if

       if(k_ajb_ext.eq.1)then

      call transp400(
!-----------------------------------  inputs---
     *  c_input1,c_input2,
!------------------------------------outputs
     *  c_output1,c_output2)
 	
	do i=1,n
		aj0(I)=c_output1(i)
      end do
      apr='+aj0-' 
      if(kpr.eq.1)print 71,apr,(aj0(i),i=1,nn2) 

      end if
      

 	end if

      if(kpr.eq.1)print *,' tt==tt_kavin=',tt,tt_kavin
 
        apr= 'd te0 '
        print 71,apr,(te0(i),i=1,n)
        apr= 'd tq0 '
        print 71,apr,(tq0(i),i=1,n)
        apr= 'd pd0 '
        print 71,apr,(pd0(i),i=1,n)
        apr= 'd pt0 '
        print 71,apr,(pt0(i),i=1,n)

      
      if(tt.le.tt_kavin)then
      omega=1.d0
 	call equil()
 	else
      if(ih_imas.eq.4.and.i_en.eq.1)then
      k_ener_h=k_ener
!      k_ener=0
 	omega=0.5d0
 	call equil3()
      k_ener=k_ener_h
 	end if
 	if(k_jetto.eq.1)k_ener=0
 	omega=0.33d0
 	call equil2()
 	end if

       if(ih_imas.eq.4)t_end=0.

	if(kpr.eq.1)print*,'!!!ih_imas k_jetto',ih_imas,k_jetto
	if(kpr.eq.1)print*,'!!!tt tay t_end',tt,tay,t_end
 	
      if(tt.gt.t_end+tay)then 	
c  i_fil=0  old case without reconstruction....
	call separ_coor()                                                
	call separ_coor2()                                                
      call get_gaps()
      i_en3=i_en3+1
      end if
 
 
      
      if(i_gaps.eq.1)then
      
         if(i_en3.eq.1)then
         open (unit=1,file='gaps.dat',form='formatted')
          apr2='tt[s]	gap1[m]	gap2[m]	gap3[m]	gap4[m]	gap5[m]	gap6[m]'
          write (1,*)apr2
         end if
         if(i_en3.gt.1)then
         open (unit=1,file='gaps.dat',access='append',form='formatted')
         end if
         
         
      write (1,*)tt*1.e-3,(gaps(i)*1.e-2,i=1,n_ga)
      close(1)
      
      end if
      
      
    	ntay=ntay+1
	tt=tt+tay

!	ntay=ntay+1
!	tt=tt+tay


        if(tt.gt.1520.)then
        call write_tran1()
        call write_eq_in()
        end if



	if(kpr.eq.1)print*,'!!!tt tay ntay',tt,tay,ntay

	if(kpr.eq.1)print*,'@@@@@from main  next k_jetto',next,k_jetto

	if(kpr.eq.1)print*,'put_signals'

	call put_dina_signals(z_cur_xx,elong_xx,xleft_xx,
     *  xright_xx,tpl_xx,tt_xx,
     *  npf_xx,pf_xx,n_gaps_xx,gaps_xx,
     *  ntay_xx,ncam_xx,zvel_xx,tcam_xx,rsep_xx,klim_xx,
     *  zsep_xx,i_wr_xx)

!------------------------------------outputs
!     *  z_cur_xx,elong_xx,xleft_xx,
!     *  xright_xx,tpl_xx,tt_xx,
!     *  npf_xx,pf_xx,n_gaps_xx,gaps_xx,
!     *  ntay_xx,next_xx,zvel_xx,pf_turns_xx,rsep_xx,klim_xx,
!     *  t_end_xx,i_wr_xx,

        c_output1(1)=z_cur_xx
        c_output1(2)=zvel_xx
        c_output1(3)=elong_xx
        c_output1(4)=tpl_xx
       
      	if(kpr.eq.1)print*,'z_cur zvel elong tpl ',(c_output1(i),i=1,4)

        
        c_output1(5)=klim_xx
        c_output1(6)=xleft_xx
        c_output1(7)=xright_xx
        c_output1(8)=rsep_xx

      	if(kpr.eq.1)print*,'klim xleft xright rsep',(c_output1(i),i=5,8)


        c_output1(9)=tt_xx
        c_output1(10)=zsep_xx

      	if(kpr.eq.1)print*,'tt zsep',(c_output1(i),i=9,10)

        c_output1(11)=npf_xx
        c_output1(12)=n_gaps_xx
        c_output1(13)=ntay_xx
        c_output1(14)=ncam_xx
        c_output1(15)=i_wr_xx



        apr= 'c_output1 '
        print 71,apr,(c_output1(i),i=1,15)



      	if(kpr.eq.1)print*,'npf n_gaps ntay ncam ',(c_output1(i),i=11,14)


      kk=0
      do i=1,n_gaps_xx
      kk=kk+1
      c_output2(kk)=gaps_xx(i)
      end do
      
        apr= 'gaps '
        print 71,apr,(gaps_xx(i),i=1,n_gaps_xx)

      
      do i=1,npf_xx
      kk=kk+1
      c_output2(kk)=pf_xx(i)
      end do
      
        apr= 'pf_xx '
        print 71,apr,(pf_xx(i),i=1,npf_xx)

      
      do i=1,ncam_xx
      kk=kk+1
      c_output2(kk)=tcam_xx(i)
     	a_print(i)=tcam_xx(i)
      end do

        apr= 'tcam_xx '
        print 71,apr,(tcam_xx(i),i=1,ncam_xx)

	n_pr=ncam_xx

	apr='tcam_xx'

	num=10

!	call out42(n_pr,a_print,num,apr)


     	a_print(1)=ncam_xx
     	a_print(2)=kk

	n_pr=2

	apr='ncam_xx kk '

	num=10

!	call out42(n_pr,a_print,num,apr)

c----------------------

!      if(i_en.gt.5)stop
      

                                                                        

	shape_out(1)=tpl_mat                                                   

	shape_out(2)=rmag*1.d-2                                                

	shape_out(3)=zmag*1.d-2                                                

	shape_out(4)=eu*1.d-2 
	                                                 
!!!	shape_out(4)=eu_95*1.d-2

c$	call trian()

	shape_out(5)=elong  
	                                                
!!!	shape_out(5)=elong_95

c	shape_out(6)=el_up                                                     
c	shape_out(6)=el_up_95

c	shape_out(7)=el_dw
c	shape_out(7)=el_dw_95


	shape_out(6)=bz_pl

!	shape_out(7)=bz_ext
	shape_out(7)=br_pl

!	shape_out(8)=shafra(1)                                                  

c	shape_out(8)=tri_95                                                  

!!!	shape_out(9)=tri_up                                                    


	shape_out(9)=udd
c	shape_out(9)=tri_up_95

c	shape_out(10)=ptot

!!!	shape_out(10)=tri
	shape_out(10)=f_index

c ***  **********
	a_print(1)= shape_out(6)
	a_print(2)= shape_out(7)
	a_print(3)= shape_out(10)
	
	n_pr=3
	apr='shape_out(6,7-10)'
	num=25
c	call out42(n_pr,a_print,num,apr)
c ***  **********                                                                        

	shape_out(11)=betj                                                     

	shape_out(12)=uli                                                      

	shape_out(13)=q(2)                                                     

	shape_out(14)=q(n)

!!!	shape_out(14)=q_95


c        print *,' q_a q_b',q(2),q(n)

                                                     

	  shape_out(15)=te0(1)

c        shape_out(16)=rsep*1.e-2


      if(tene.le.1000.)then 
 	shape_out(16)=tene*1.d-3
	else
 	shape_out(16)=1000.*1.d-3
	end if

	if(kpr.eq.1)print *,' tene_e===',tene_e

c!!!        shape_out(17)=zsep*1.e-2

        shape_out(17)=uact

c---------------------- We are changing here----

        shape_out(18)=tq0(1)

        shape_out(19)=pcch*1.d19

c-------------------------------------------------------

c        shape_out(20)=pmag*1.e-5

!!        shape_out(20)=power_ech2*1.e6
!!!        shape_out(20)=ptot_dop*1.d6
        shape_out(20)=q_ech

c        shape_out(21)=psep*1.e-5
	
!!!        shape_out(21)=tokbut*1.d3

       shape_out(21)=qlos_imp

!!!        shape_out(22)=tokuv*1.d3
       shape_out(22)=zeff(1)

        if(i_eccd.ne.0)q_rz=q(i_eccd)



        if(kpr.eq.1)print *,' i_eccd q_rz==',i_eccd,q_rz



c        shape_out(23)=q_rz        !  q at R,Z location o ECCD 


      shape_out(23)=tt      !  q at R,Z location o ECCD 

!!!	shape_out(24)=p_turb                                                
	shape_out(24)=ratio_imp                                                

	k_out_dina=24

	shape_out(25)=rsep                                                
	shape_out(26)=zsep 

	k_out_dina=26

c  EXTRA for KTM

	shape_out(27)=vs_pf                                                
	shape_out(28)=vs_pl                                               
	shape_out(29)=vs_res                                                
	shape_out(30)=vs_tot

	shape_out(31)=fdd*1.d-5

	shape_out(32)=vs_ext
 
	if(i_c_data.eq.0)then                 
!	call print3(' psi_pf,psipl_av,psiext_av==',
!     *  psi_pf,psipl_av,psiext_av)
!
!	call print3(' vs_pf,vs_pl,vs_ext==',
!     *  vs_pf,vs_pl,vs_ext)

	shape_out(27)=psi_pf                                               
	shape_out(28)=psipl_av                                               
	shape_out(32)=psiext_av

	end if


!!!	shape_out(32)=pll*tpl*1.d-5

	k_out_dina=32

	a_print(1)=vs_pf
	a_print(2)=vs_pl
	a_print(3)=vs_res
	a_print(4)=fdd*1.d-5
	a_print(5)=pll*tpl*1.d-5
	n_pr=5

	apr='v_pfa v_pla vs_res vs_pf vs_pl '
	num=30
	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)

	a_print(1)=vs_ext
	a_print(2)=vs_tot
	a_print(3)=vs_ext+vs_pl
	a_print(4)=tt
	n_pr=4

	apr='vs_ext vs_t vs_t1 tt '
	num=30
	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)


       do i=1,k_out_dina
       c_output3(i)=shape_out(i)
       end do


	a_print(1)=k_out_dina
	a_print(2)=tt
	n_pr=2

	apr='k_out_dina tt '
	num=15
	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)

      

      if(tt.gt.3450.d0)then 
      
!      if(kpr.eq.1)print *,' STOP'
      	
!      stop
      end if
      

      return  	 
      END
	subroutine put_dina_signals(z_cur_xx,elong_xx,xleft_xx,
     *  xright_xx,tpl_xx,tt_xx,
     *  npf_xx,pf_xx,n_gaps_xx,gaps_xx,
     *  ntay_xx,ncam_xx,zvel_xx,tcam_xx,rsep_xx,klim_xx,
     *  zsep_xx,i_wr_xx)
     
      include 'double.inc'
	include 'new_com.inc'                                                  

	dimension pf_xx(*),gaps_xx(*),tcam_xx(*)

	character*70 apr

71	format(20x,a6/,(6(1pe10.3)))

 !     kpr=1

c------------
      i_wr_xx=i_wr
      klim_xx=klim
      zsep_xx=zsep
      
      if(kpr.eq.1)print*,'klim zsep ',klim,zsep
      
      rsep_xx=rsep*1.d-2
!!!      zvel_xx=zvel
      zvel_xx=zmag*1.d-2
      if(kpr.eq.1)print*,'rsep zvel ',rsep,zvel
      
      z_cur_xx=z_cur*1.d-2
      elong_xx=elong
      if(kpr.eq.1)print*,'z_cur elong ',z_cur,elong

      xleft_xx=xleft*1.d-2
      xright_xx=xright*1.d-2

      if(kpr.eq.1)print*,'xleft xright ',xleft,xright

      if(n_ga.eq.0)n_ga=6
      
      n_gaps=n_ga
      n_gaps_xx=n_gaps
      
      tpl_xx=tpl*1.d+3      
      tt_xx=tt
      if(kpr.eq.1)print*,'tt tpl',tt,tpl 
    
      npf_xx=npf
      if(kpr.eq.1)print*,'npf n_ga',npf,n_ga

       ntay_xx=ntay
       ncam_xx=ncam

      if(kpr.eq.1)print*,'ntay ncam i_wr',ntay,ncam,i_wr

      do i=1,n_gaps
      gaps_xx(i)=gaps(i)*1.d-2
!        if(kpr.eq.1)print *,' i gaps-',i,gaps(i)
      end do
       
      do i=1,npf
        pf_xx(i)=pf(i)*1.d+3
!        if(kpr.eq.1)print *,' i pf pf_turns-',i,pf(i),pf_turns(i)
      end do

      do i=1,ncam
        tcam_xx(i)=tcam(i)*1.d+3
!        if(kpr.eq.1)print *,' i pf pf_turns-',i,pf(i),pf_turns(i)
      end do



 1000 continue
 5000 format (50(1pe14.5))

	return
      end


	subroutine write_tran1()
      
      include 'double.inc'
	include 'new_com.inc'                                                  

	character * 20 apr,filename

71	format(20x,a6/,(6(1pe10.3)))


      return
      
      filename='metric.dat'

      nn2=n
c-------
           open (unit=41,file=filename,form='formatted')           
           write (41,5000)(a(i),i=1,nn2)
           write (41,5000)(te0(i),i=1,nn2)
           write (41,5000)(tq0(i),i=1,nn2)
           write (41,5000)(pd0(i),i=1,nn2)
           write (41,5000)(pt0(i),i=1,nn2)
           write (41,5000)(ph0(i),i=1,nn2)
           write (41,5000)(pne(i),i=1,nn2)
           write (41,5000)(q(i),i=1,nn2)
           write (41,5000)(zeff(i),i=1,nn2)
           write (41,5000)(dm0(i),i=1,nn2)
           write (41,5000)(dfmax(i),i=1,nn2)
           write (41,5000)(vi(i),i=1,nn2)
           write (41,5000)(a_m(i),i=1,nn2)
           write (41,5000)(r_m(i),i=1,nn2)
           write (41,5000)(gra1(i),i=1,nn2)
           write (41,5000)(gra2(i),i=1,nn2)
           write (41,5000)(bsq(i),i=1,nn2)
           write (41,5000)(fasp(i),i=1,nn2)
           write (41,5000)(volt(i),i=1,nn2)
           write (41,5000)(tok1(i),i=1,nn2)
           write (41,5000)(f(i),i=1,nn2)
           write (41,5000)(spo(i),i=1,nn2)

           close (41)

      kpr2=0
      if(kpr2.eq.1)then
      
      apr='a-' 
      if(kpr.eq.1)print 71,apr,(a(i),i=1,nn2) 
      apr='te0-' 
      if(kpr.eq.1)print 71,apr,(te0(i),i=1,nn2) 
      apr='tq0-' 
      if(kpr.eq.1)print 71,apr,(tq0(i),i=1,nn2) 
      apr='pd0-' 
      if(kpr.eq.1)print 71,apr,(pd0(i),i=1,nn2) 
      apr='pt0-' 
      if(kpr.eq.1)print 71,apr,(pt0(i),i=1,nn2) 
      apr='ph0-' 
      if(kpr.eq.1)print 71,apr,(ph0(i),i=1,nn2) 
      apr='pne-' 
      if(kpr.eq.1)print 71,apr,(pne(i),i=1,nn2) 
      apr='q-' 
      if(kpr.eq.1)print 71,apr,(q(i),i=1,nn2) 
      apr='zeff-' 
      if(kpr.eq.1)print 71,apr,(zeff(i),i=1,nn2) 
      apr='dm0-' 
      if(kpr.eq.1)print 71,apr,(dm0(i),i=1,nn2) 
      apr='dfmax-' 
      if(kpr.eq.1)print 71,apr,(dfmax(i),i=1,nn2) 
      apr='vi-' 
      if(kpr.eq.1)print 71,apr,(vi(i),i=1,nn2) 
      apr='a_m-' 
      if(kpr.eq.1)print 71,apr,(a_m(i),i=1,nn2) 
      apr='r_m-' 
      if(kpr.eq.1)print 71,apr,(r_m(i),i=1,nn2) 
      apr='gra1-' 
      if(kpr.eq.1)print 71,apr,(gra1(i),i=1,nn2) 
      apr='gra2-' 
      if(kpr.eq.1)print 71,apr,(gra2(i),i=1,nn2) 
      apr='bsq-' 
      if(kpr.eq.1)print 71,apr,(bsq(i),i=1,nn2) 
      apr='fasp-' 
      if(kpr.eq.1)print 71,apr,(fasp(i),i=1,nn2) 
      apr='volt-' 
      if(kpr.eq.1)print 71,apr,(volt(i),i=1,nn2) 
      apr='tok1-' 
      if(kpr.eq.1)print 71,apr,(tok1(i),i=1,nn2) 
      apr='f-' 
      if(kpr.eq.1)print 71,apr,(f(i),i=1,nn2) 
      apr='spo-' 
      if(kpr.eq.1)print 71,apr,(spo(i),i=1,nn2) 

      end if


 5000 format (50(1pe14.5))

      if(kpr.eq.1)print*,'END of writing tran1'

	return
      end
	subroutine transp100(
!-----------------------------------  inputs---
     *  c_input1,c_input2,
!     *  te0,tq0,pd0,pt0,ph0,pne,q,zeff,dm0,
!------------------------------------outputs
     *  c_output1,c_output2)

      include 'double.inc'

      dimension c_input1(*),c_input2(*)
      dimension c_output1(*),c_output2(*)

	include 'parf0'
      common /c_input1/te0(npo),tq0(npo),pne(npo),
     *  pd0(npo),pt0(npo),sigk(npo),ajb(npo),
     *  aj0(npo),qe0(npo),qq0(npo)

	common
     *	/n_m/n,m,mp

	character *20 apr,filename

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

!------------------------------------inputs
      
      DO I=1,n
    	c_output1(I)=te0(i)
    	c_output2(I)=tq0(i)
	end do

5000  format (50(1pe14.5))



      return
      end
	subroutine transp200(
!-----------------------------------  inputs---
     *  c_input1,c_input2,
!     *  te0,tq0,pd0,pt0,ph0,pne,q,zeff,dm0,
!------------------------------------outputs
     *  c_output1,c_output2,c_output3)

      include 'double.inc'

      dimension c_input1(*),c_input2(*)
      dimension c_output1(*),c_output2(*),c_output3(*)

	include 'parf0'
      common /c_input1/te0(npo),tq0(npo),pne(npo),
     *  pd0(npo),pt0(npo),sigk(npo),ajb(npo),
     *  aj0(npo),qe0(npo),qq0(npo)

	common
     *	/n_m/n,m,mp

	character *20 apr,filename

71	FORMAT(20X,A20/,(6(1X,1PE10.3)))

!------------------------------------inputs


      DO I=1,n
    	c_output1(I)=pd0(i)
    	c_output2(I)=pt0(i)
   	c_output3(I)=pne(i)
	end do


      apr='++++pD0-' 
      print 71,apr,(PD0(i),i=1,n) 
      apr='++++PT0-' 
      print 71,apr,(PT0(i),i=1,n) 
      apr='++++PNE-' 
      print 71,apr,(PNE(i),i=1,n) 

      apr='+++c_output2_tran-' 
      if(kpr.eq.1)print 71,apr,(c_output2(i),i=1,n) 
      apr='+++c_output3_tran-' 
      if(kpr.eq.1)print 71,apr,(c_output3(i),i=1,n) 


5000  format (50(1pe14.5))

      return
      end
	subroutine transp300(
!-----------------------------------  inputs---
     *  c_input1,c_input2,
!     *  te0,tq0,pd0,pt0,ph0,pne,q,zeff,dm0,
!------------------------------------outputs
     *  c_output1,c_output2)


      include 'double.inc'

      dimension c_input1(*),c_input2(*)
      dimension c_output1(*),c_output2(*)

	include 'parf0'
      common /c_input1/te0(npo),tq0(npo),pne(npo),
     *  pd0(npo),pt0(npo),sigk(npo),ajb(npo),
     *  aj0(npo),qe0(npo),qq0(npo)

	common
     *	/n_m/n,m,mp

	character *20 apr,filename

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

!------------------------------------inputs

      DO I=1,n
    	c_output1(I)=ajb(i)
    	c_output2(I)=sigk(i)
	end do

5000  format (50(1pe14.5))



      return
      end
	subroutine transp400(
!-----------------------------------  inputs---
     *  c_input1,c_input2,
!     *  te0,tq0,pd0,pt0,ph0,pne,q,zeff,dm0,
!------------------------------------outputs
     *  c_output1,c_output2)

      include 'double.inc'

      dimension c_input1(*),c_input2(*)
      dimension c_output1(*),c_output2(*)

	include 'parf0'
      common /c_input1/te0(npo),tq0(npo),pne(npo),
     *  pd0(npo),pt0(npo),sigk(npo),ajb(npo),
     *  aj0(npo),qe0(npo),qq0(npo)

	common
     *	/n_m/n,m,mp


	character *20 apr,filename

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

!------------------------------------inputs

      DO I=1,n
    	c_output1(I)=aj0(i)
	end do

5000  format (50(1pe14.5))



      return
      end
	subroutine transp500(
!-----------------------------------  inputs---
     *  c_input1,c_input2,
!     *  te0,tq0,pd0,pt0,ph0,pne,q,zeff,dm0,
!------------------------------------outputs
     *  c_output1,c_output2)


      include 'double.inc'

      dimension c_input1(*),c_input2(*)
      dimension c_output1(*),c_output2(*)

	include 'parf0'
      common /c_input1/te0(npo),tq0(npo),pne(npo),
     *  pd0(npo),pt0(npo),sigk(npo),ajb(npo),
     *  aj0(npo),qe0(npo),qq0(npo)

	common
     *	/n_m/n,m,mp


	character *20 apr,filename

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

!------------------------------------inputs


      DO I=1,n
    	c_output1(I)=qe0(i)
    	c_output2(I)=qq0(i)
	end do

5000  format (50(1pe14.5))



      return
      end
	subroutine write_eq_in()
      
      include 'double.inc'
	include 'new_com.inc'                                                  

	character * 20 apr,filename

      real *8 mu2(npo),ipl
      
      dimension ya(ntet),yelon(ntet),ytria(ntet),yshif(ntet),
     * yshiv(ntet),
     * AMETR(npo),RHO(npo),FP(npo),elon(npo),tria(npo),
     * shif(npo),shiv(npo),vr(npo),yrr1(npo),yrr2(npo)


71	format(20x,a6/,(6(1pe10.3)))


      BTOR=bt0*0.1d0
      RTOR=rs0*1.d-2
      ipl=tpl*1.d-3
      m1=m-1
      na1=n
      abc=a_m(n)*1.d-2
      ab=abc+0.5
      
      jneql=na1
      jnteta=m1
      
      nb1=na1

      kpr2=0
      if(kpr2.eq.1)then

        print *,' btor rtor na1',btor,rtor,na1
        print *,' abc ab1 nb1n jneql ',abc,ab,nb1,jneql
       end if
              
      
      	do ji=jneql,2,-1
		yrmax=-99999.d0
		yrmin=99999.d0
		yzmax=-99999.d0
		yzmin=99999.d0

	do jj=1,jnteta
		if(yzmin.ge.ypl(ji,jj)) then 
			yzmin=ypl(ji,jj)
			yrzmin=xpl(ji,jj)
		endif
		if(yzmax.le.ypl(ji,jj)) then 
			yzmax=ypl(ji,jj)
			yrzmax=xpl(ji,jj)
		endif
		if(yrmin.ge.xpl(ji,jj)) then 
			yrmin=xpl(ji,jj)

		endif
		if(yrmax.le.xpl(ji,jj)) then 
			yrmax=xpl(ji,jj)
		endif
c		yrmin=min(yrout(ji,jj),yrmin)
c		yrmax=max(yrout(ji,jj),yrmax)
	enddo
		yrr=.5d0*(yrmax+yrmin)

	if(ji.eq.jneql) then
		yRTOR=yrr
		SHIFT=yrr-yRTOR
	endif
		ya(ji)=.5d0*(yrmax-yrmin)
!	write(*,*) 'yrmax,yrmin,YR',yrmax,yrmin,yRr
		yshif(ji)=yrr-yRTOR
		yshiv(ji)=.5d0*(yzmin+yzmax)
		yelon(ji)=(yzmax-yzmin)/(yrmax-yrmin)
c===============================================
C
		ytria(ji)=(yrr-0.5d0*(yrzmin+yrzmax))/ya(ji)
		yrr1(ji)=yrr
		yrr2(ji)=0.5d0*(yrzmin+yrzmax)
	enddo
		ya(1)=0.d0
		yelon(1)=yelon(2)
		ytria(1)=0.d0
		yshif(1)=xpl(1,1)-yRTOR
		yshiv(1)=ypl(1,1)

      do i=1,na1
      AMETR(i)=a_m(i)*1.d-2
      mu2(i)=1.d0/q(i)
      elon(i)=yelon(i)
      tria(i)=ytria(i)
      shif(i)=yshif(i)*1.d-2
      shiv(i)=yshiv(i)*1.d-2
      FP(i)=2*pi*psval(i)*1.d-5
       FP(i)= -FP(i)
      RHO(i)=sqrt(dfmax(i)*1.d-5/(pi*BTOR))
      end do

      do i=2,na1
      vr(i)=2.d0*pi*vi(i)*ha(i)*1.d-6/(RHO(i)-RHO(i-1))
      end do
      vr(1)=0.5d0*vr(2)
      i=na1
      hro=RHO(i)-RHO(i-1)
      ROC=RHO(NA1) 
      
      		updwn=ypl(1,1)*1.d-2
  
      if(kpr2.eq.1)then
      print *,'  hro roc ', hro,roc
      print *,'  ipl updwn m1', ipl,updwn,m1
      end if
  
      return
      
	  open(1,file='equil_in_dina.dat')
      	  
	  	write(1,*)
     3	BTOR,RTOR,ABC,AB,ROC,SHIFT,UPDWN,HRO,NA1,NB1,
     4	VR(1:na1),SHIF(1:na1),SHIV(1:na1),ELON(1:na1),TRIA(1:na1),
     5  AMETR(1:na1),RHO(1:na1),FP(1:na1),MU2(1:na1),IPL

	  close(1)

      nn2  =na1
       
      if(kpr2.eq.1)then
      
      apr='VR-' 
      if(kpr.eq.1)print 71,apr,(VR(i),i=1,nn2) 
      apr='SHIF-' 
      if(kpr.eq.1)print 71,apr,(SHIF(i),i=1,nn2) 
      apr='SHIFV-' 
      if(kpr.eq.1)print 71,apr,(SHIV(i),i=1,nn2) 
      apr='ELON-' 
      if(kpr.eq.1)print 71,apr,(ELON(i),i=1,nn2) 
      apr='TRIA-' 
      if(kpr.eq.1)print 71,apr,(TRIA(i),i=1,nn2) 
      apr='AMETR-' 
      if(kpr.eq.1)print 71,apr,(AMETR(i),i=1,nn2) 
      apr='ya-' 
      if(kpr.eq.1)print 71,apr,(ya(i),i=1,nn2) 
      apr='yrr1-' 
      if(kpr.eq.1)print 71,apr,(yrr1(i),i=1,nn2) 
      apr='yrr2-' 
      if(kpr.eq.1)print 71,apr,(yrr2(i),i=1,nn2) 
      apr='RHO-' 
      if(kpr.eq.1)print 71,apr,(RHO(i),i=1,nn2) 
      apr='FP-' 
      if(kpr.eq.1)print 71,apr,(FP(i),i=1,nn2) 
      apr='MU-' 
      if(kpr.eq.1)print 71,apr,(MU2(i),i=1,nn2) 
      apr='q-' 
      if(kpr.eq.1)print 71,apr,(q(i),i=1,nn2) 

      end if


 5000 format (50(1pe14.5))

      if(kpr2.eq.1)print*,'END of writing equil_in_dina.dat'
 !     stop
      
	return
      end

	subroutine prof_dina_input()
      include 'double.inc'
	include 'new_com.inc'

	call prof_dina_input_c(te0,tq0,
     *  pne,pd0,pt0,sigk,
     *  ajb,aj0,qe0,qq0)

	return
      end


	subroutine prof_dina_input_c(te0_xx,tq0_xx,
     *  pne_xx,pd0_xx,pt0_xx,sigk_xx,
     *  ajb_xx,aj0_xx,qe0_xx,qq0_xx)

      include 'double.inc'

      dimension te0_xx(*),tq0_xx(*)
      dimension pne_xx(*),pd0_xx(*),pt0_xx(*),sigk_xx(*),
     *  ajb_xx(*),aj0_xx(*),qe0_xx(*),qq0_xx(*)

	include 'parf0'
      common /c_input1/te0(npo),tq0(npo),pne(npo),
     *  pd0(npo),pt0(npo),sigk(npo),ajb(npo),
     *  aj0(npo),qe0(npo),qq0(npo)

      common /ge5/kpr
	common
     *	/n_m/n,m,mp

	character *20 apr,filename

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

!------------------------------------inputs
         
      DO I=1,n
    	te0_xx(I)=te0(i)
    	tq0_xx(I)=tq0(i)

    	pne_xx(I)=pne(i)
    	pd0_xx(I)=pd0(i)
    	pt0_xx(I)=pt0(i)
    	sigk_xx(I)=sigk(i)
    	ajb_xx(I)=ajb(i)
    	aj0_xx(I)=aj0(i)
    	qe0_xx(I)=qe0(i)
    	qq0_xx(I)=qq0(i)

	end do

5000  format (50(1pe14.5))

      apr='---te0-' 
      if(kpr.eq.1)print 71,apr,(te0(i),i=1,n) 
      apr='---tq0-' 
      if(kpr.eq.1)print 71,apr,(tq0(i),i=1,n) 
      apr='---sigk-' 
      if(kpr.eq.1)print 71,apr,(sigk(i),i=1,n) 
      apr='---pd0-' 
      if(kpr.eq.1)print 71,apr,(pd0(i),i=1,n) 
      apr='---pt0-' 
      if(kpr.eq.1)print 71,apr,(pt0(i),i=1,n) 
      apr='---pne-' 
      if(kpr.eq.1)print 71,apr,(pne(i),i=1,n) 
      apr='---ajb-' 
      if(kpr.eq.1)print 71,apr,(ajb(i),i=1,n) 

      return
      end


