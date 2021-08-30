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

	interface
      subroutine t15_2_initialize()
!      subroutine t15_2_initialize(firstTime)
!      subroutine t15_2_initialize(a_in,a_out)
!       real *8 a_in, a_out
!       logical firstTime

cDEC$ ATTRIBUTES DLLIMPORT, stdcall::  t15_2_initialize
cDEC$ ATTRIBUTES ALIAS:'_t15_2_initialize'::t15_2_initialize
!cDEC$ ATTRIBUTES ALIAS:'_t15_2_initialize'::t15_2_initialize
!!!cDEC$ ATTRIBUTES VALUE :: a_in,a_out
!!!cDEC$ ATTRIBUTES VALUE :: firstTime
      end subroutine 
      end interface


	interface
      subroutine t15_2_terminate()
cDEC$ ATTRIBUTES DLLIMPORT, stdcall::  t15_2_terminate
cDEC$ ATTRIBUTES ALIAS:'_t15_2_terminate'::t15_2_terminate
      end subroutine 
      end interface


	interface
      subroutine t15_2_output(k_in, a_in,
     *  k_out, a_out)
cDEC$ ATTRIBUTES DLLIMPORT, stdcall::  t15_2_output
cDEC$ ATTRIBUTES ALIAS:'_t15_2_output'::t15_2_output
cDEC$ ATTRIBUTES VALUE :: k_in
cDEC$ ATTRIBUTES REFERENCE :: k_out
cDEC$ ATTRIBUTES REFERENCE :: a_in,a_out

       integer k_in,k_out
       real *8 a_in(*), a_out(*)
        
       end subroutine 
      end interface

	interface
      subroutine t15_2_output2() 
cDEC$ ATTRIBUTES DLLIMPORT, stdcall::  t15_2_output2
cDEC$ ATTRIBUTES ALIAS:'_t15_2_output2'::t15_2_output2
      end subroutine 
      end interface


!     pointer (p2, sub2)
 !     pointer (p3, sub3)
      
      character(80) dll_name
	logical aa2
          
      real *8 a, b, a_in(200),a_out(200)
      real *8 EqTime,SimStep

      i_en=i_en+1

!	print * ,' T15--initi'

 !     stop
      

	EqTime=1.5
	SimStep=1.

      if(i_en.eq.1)then
!       call t15_2_initialize(EqTime,SimStep)
!       call t15_2_initialize(aa2)
       call t15_2_initialize()
!     	 print *,'EqTime,SimStep',EqTime,SimStep
      end if
      
 !     stop

      k_in=15+123
      k_out=13
      
      
      do i=1,15
      a_in(i)=c_input1(i)
      end do

      do i=1,123
      a_in(i+15)=c_input2(i)
      end do
    
!     	print * ,' k_in a_in',k_in,a_in(1:24)

      do i=1,15
!      	print * ,' k_in i a_in',k_in,i,a_in(i)
      end do

      
      call t15_2_output(k_in, a_in,
     *  k_out, a_out) 

 !      print * ,' k_out a_out',k_out,a_out(1:15)
 !      print * ,' k_out2 a_out',k_out,a_out(15+1:15+11)
 !      print * ,' k_out3 a_out',k_out,a_out(15+11+1:15+11+12)
      
      do i=1,38
 !     	print * ,' k_out i a_out',k_out,i,a_out(i)
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
