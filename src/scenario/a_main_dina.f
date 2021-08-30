c	include 'fgraph.fi'
	include 'double.inc'
	include 'new_com.inc'

	character *20 yy

      parameter (kint=300)
      
      dimension c_input1(kint),c_input2(kint)
      dimension c_output1(kint),c_output2(kint),c_output3(kint)

 !     kpr=1

      print *,' -------- a_main=',a_main


      do k=1,999993
      
	  call dina2(
!-----------------------------------  inputs---
     *  c_input1,c_input2,
!------------------------------------outputs
     *  c_output1,c_output2,c_output3)


       if(kpr.gt.0)print *,' -------- k tt t_vde=',k,tt,t_vde

       if(k.gt.7000)then
       stop
       end if
       
       if(tt.gt.t_vde)then
       stop
       end if
       
 
	  call kav_contr(
!-----------------------------------  inputs---
     *  c_output1,c_output2,
!------------------------------------outputs
     *  c_input1,c_input2)


      end do


      end

