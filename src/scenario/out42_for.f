
	subroutine out42_c(ng,ygr,num,name)
	include 'double.inc'

	dimension ygr(*)
	character name(*)

      print *,name(1:num)

	write(6,'("",20(1pe12.5))'),
     *  (ygr(i),i=1,ng)


!      print *,' out42_c== ng=',ng

!	write(6,'("",a20,20(1pe12.5))'),
!     *  name(1:num),(ygr(i),i=1,ng)

!!!	if(kpr.eq.1)print '(a20,(20(1p,e12.5)))',name,(ygr(i),i=1,ng)
!	print '(a20/,(6(1p,e12.5)))',name(1:num),(ygr(i),i=1,ng)

	return
	end


	subroutine out42(n_pr,a_print,num,apr)
	include 'double.inc'
	dimension a_print(*)
	character apr(*)    
      
	call out42_c(n_pr,a_print,num,apr)


	return
	end






