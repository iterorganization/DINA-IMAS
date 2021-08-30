	subroutine dina2(
!-----------------------------------  inputs---
     *  c_input1,c_input2,
!------------------------------------outputs
     *  c_output1,c_output2,c_output3)

      include 'double.inc'
	include 'new_com.inc'                                                  

      dimension c_input1(*),c_input2(*)
      dimension c_output1(*),c_output2(*),c_output3(*)

      parameter (kint=300)

	dimension pf_xx(kint),gaps_xx(kint),tcam_xx(kint)

	dimension vchopper_x2(kint),shape_out(kint)

	character *30 apr                                                      
	character *70 apr2
	dimension a_print(300)

	common /c_data_in_time2/i_c_data,i_c_data1       

      common /c_tran2/k_ener_ext,k_dens_ext,k_ajb_ext
      
            common /c_imas_is/ih_imas
            common /c_kpr/kpr_c
      common /c_tran_times/tt_dina_c

      common /c_ext_c16/k_ener_ext_c16,k_dens_ext_c16,k_ajb_ext_c16

!-----------------------------------  inputs---
!     *  vchopper_x2,tpl_x2,tt_dw_x2)
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

	
      i_en=i_en+1

      
      if(i_en.eq.1)then
           open (unit=41,file='tt_kavin.dat',form='formatted') 
           read (41,*)
           read (41,*)tt_kavin,tt_dw
           

        if(kpr.eq.1)print *,'tt_kavin,tt_dw =',
     *  tt_kavin,tt_dw
           
  		  close (41)
  		  
		 open (unit=40,file='k_jetto.dat',form='formatted') 
          read (40,*) 
          read (40,*)k_jetto
         close (40)

  		  
      end if
      
      if(i_en.eq.1.and.kpr.eq.1)then
!           Iopen=0
!      call OpenCloseConsole(Iopen) 
      end if


      if(tt.gt.620.e3)then
!      kpr=1
      else
!      kpr=0
      end if


        do i=1,15
           	a_print(i)=c_input2(i)
        end do

	n_pr=15
	apr='vlots'
	num=10
	call out42(n_pr,a_print,num,apr)


      if(i_en.gt.2)then

        tpl_x2=c_input1(1)      
        tt_dw_x2=c_input1(2)   
        
        if(kpr.eq.1)print *,'   tpl_x2==',tpl_x2 
      
        do i=1,npf
        vchopper_x2(i)=c_input2(i)
           	a_print(i)=c_input2(i)
        end do

	n_pr=npf
	apr='vlots'
	num=10
	call out42(n_pr,a_print,num,apr)


      
       do i=1,11
      zvconverter(i)=c_input2(npf+i)
!      if(kpr.eq.1)print *,'   zvconverter==',zvconverter(i)
      end do      

      do i=1,12
      u_kd(i)=c_input2(npf+11+i)
      if(kpr.eq.1.and.i.eq.12)print *,'   u_kd==',u_kd(i)
      end do      


      call get_contr_signals(vchopper_x2,tpl_x2,tt_dw_x2)
      end if

      if(i_en.eq.1)then
      call vic_read_gaps()
      end if

      

      
      if(tt.le.tt_kavin)then
      omega=1.d0
 	call equil()
 	else
 	if(k_jetto.eq.1)k_ener=0
 	omega=0.33d0
 	call equil2()
 	end if
 	
!      if(tt.gt.4.e3)stop

 	
      if(tt.gt.t_end+tay)then 	
c  i_fil=0  old case without reconstruction....
	call separ_coor()                                                
	call separ_coor2()                                                
      call get_gaps()
      end if
      

	ntay=ntay+1
	tt=tt+tay


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

!      	call z_filter(z_cur_xx)

        c_output1(1)=z_cur_xx
        c_output1(2)=zvel_xx
        c_output1(3)=elong_xx
        c_output1(4)=tpl_xx
        c_output1(5)=klim_xx
        c_output1(6)=xleft_xx
        c_output1(7)=xright_xx
        c_output1(8)=rsep_xx
        c_output1(9)=tt_xx
        c_output1(10)=zsep_xx

        c_output1(11)=npf_xx
        c_output1(12)=n_gaps_xx
        c_output1(13)=ntay_xx
        c_output1(14)=ncam_xx
        c_output1(15)=i_wr_xx


      kk=0
      do i=1,n_gaps_xx
      kk=kk+1
      c_output2(kk)=gaps_xx(i)
      end do
      do i=1,npf_xx
      kk=kk+1
      c_output2(kk)=pf_xx(i)
      end do
      do i=1,ncam_xx
      kk=kk+1
      c_output2(kk)=tcam_xx(i)
     	a_print(i)=tcam_xx(i)
      end do

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

      

      if(tt.gt.900.e3)then 
      
      if(kpr.eq.1)print *,' tt STOP',tt
      	
      stop
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


!      if(tt.gt.1200.)then
      if(tt.gt.80.e5)then
      if(kpr.eq.1)print*,'tt  z_cur  ',tt,z_cur
      	call zz_filter(z_cur)
      end if
      
      
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
	subroutine get_contr_signals(vchopper_xx,tpl_xx,tt_dw_xx)

      include 'double.inc'
	include 'new_com.inc'                                                  

	dimension vchopper_xx(*)
     
      do i=1,npf
        vchopper(i)=vchopper_xx(i)
      end do

!      tpl=tpl_xx
!      tt_dw=tt_dw_xx

      
      
 1000 continue
 5000 format (50(1pe14.5))

      if(kpr.eq.1)print*,'END of reading contr_signals'

	return
      end


