	subroutine eq_ech(time_8,tt_8,tay_8,key_mat,vec_mat,
     *	p_input_1,p_input_2,p_input_3,
     *	output_1,output_2,output_3,output_4,ng)


	include 'double.inc'

      common
     *  /ge5/kpr

	real *8 time_8, tay_8
	real *8 tt_8 

	real *8 vec_mat(*)
		
	dimension key_mat(*) 

	real *8 p_input_1(*),p_input_2(*),p_input_3(*)

	real *8 output_1(*)
	real *8 output_2(*)
	real *8 output_3(*)
	real *8 output_4(*)


	real *8 a_print(200)
	
      parameter (kint=500)
      
      dimension c_input1(kint),c_input2(kint)
      dimension c_output1(kint),c_output2(kint)

	character *25 apr


c =================================================================

c	print *,' ok1 '

c =================================================================

	i_en0=i_en0+1    

      ng=i_en0

      if(kpr.eq.1)print *,' kpr=',kpr

!      kpr=1

      do i=1,6
	a_print(i)=key_mat(i)
      end do
      
	n_pr=6
	apr='  key'
	num=6
!	call out42(n_pr,a_print,num,apr)
                                                                        

      n_input1=15
      do i=1,n_input1
      c_input1(i)=p_input_1(i)
      end do

      do i=1,n_input1
	a_print(i)=c_input1(i)
      end do
      
	n_pr=n_input1
	apr='  kav_input1'
	num=10
!	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)


!        c_output1(11)=npf_xx
!        c_output1(12)=n_gaps_xx
!        c_output1(14)=ncam_xx

        npf_xx=c_input1(11)
        n_gaps_xx=c_input1(12)
        ncam_xx=c_input1(14)

      n_input2=npf_xx+n_gaps_xx+ncam_xx
      
	a_print(1)=npf_xx
	a_print(2)=n_gaps_xx
	a_print(3)=ncam_xx
	a_print(4)=n_input2
      
	n_pr=4
	apr='  npf n_ga ncam n_input2'
	num=20
	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)

      
      do i=1,n_input2
      c_input2(i)=p_input_2(i)
      end do

      do i=1,n_input2
	a_print(i)=c_input2(i)
      end do
      
	n_pr=n_input2
	apr='  kav_input2'
	num=10
!	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)

!        print *,' kav_contr=='
!        read (*,*)

      print *,' tt in KA=',c_input1(9)


      call kav_contr(
!-----------------------------------  inputs---
     *  c_input1,c_input2,
!------------------------------------outputs
     *  c_output1,c_output2)

!        print *,' after kav_contr'
!        read (*,*)


c ============ outputs ==============================================


!        c_output1(1)=tpl_x2      
!        c_output1(2)=tt_dw_x2      

        do i=1,2
		output_1(i)=c_output1(i)
        end do

      do i=1,2
	a_print(i)=output_1(i)
      end do
      
	n_pr=2
	apr=' kav output1'
	num=10
!	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)

              
      do i=1,38
!        do i=1,npf_xx
        output_2(i)=c_output2(i)
        end do

      do i=1,38
!      do i=1,npf_xx
	a_print(i)=output_2(i)
      end do
      
	n_pr=npf_xx
	apr=' kav output2'
	num=10
	if(kpr.eq.3.or.kpr.eq.1)call out42(n_pr,a_print,num,apr)



      return
      end


