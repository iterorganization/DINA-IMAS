	 subroutine kav_contr(
!-----------------------------------  inputs---
     *  c_input1,c_input2,
!------------------------------------outputs
     *  c_output1,c_output2)

       real *8 c_output1(*), c_output2(*)
       real *8 c_input1(*), c_input2(*)

!      program main
      
      common /cb/ i, j, k
      integer i, j, k
           
      integer status

!     pointer (p2, sub2)
 !     pointer (p3, sub3)
      
      character(80) dll_name
	logical aa2
          
      real *8 a, b, a_in(200),a_out(100)
      real *8 EqTime,SimStep

      i_en=i_en+1

!	print * ,' T15--initi'

 !     stop
      

	EqTime=1.5
	SimStep=1.

      if(i_en.eq.1)then
       call t15_2_initialize()
!       call t15_2_initialize(aa2)
!       call t15_2_initialize(EqTime,SimStep)
!     	 print *,'EqTime,SimStep',EqTime,SimStep
      end if
      

      k_in=15+123
      k_out=13
      
      do i=1,15
      a_in(i)=c_input1(i)
      end do

      do i=1,123
      a_in(i+15)=c_input2(i)
      end do
    
      do i=1,15
      	print * ,' k_in i a_in',k_in,i,a_in(i)
      end do
      
      
      call t15_2_output(k_in, a_in,
     *  k_out, a_out) 

      do i=1,38
      	print * ,' k_out i a_out',k_out,i,a_out(i)
      end do
      
      do i=1,38
      c_output2(i)=a_out(i)
      end do

      
!      call t15_2_output2() 

!      call t15_2_terminate()
      

	return
	end

      subroutine sub1
      common /cb/ i, j, k
      integer i, j, k
      print *,i,j,k
      return
      end
