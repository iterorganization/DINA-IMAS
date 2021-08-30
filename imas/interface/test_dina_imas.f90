! main test
! test the DINA_IMAS
! Jo Lister, August 2013

use ids_schemas
use ids_routines
implicit none

interface 
! Declaration of the dina_imas subroutine
subroutine dina_imas(&
  &  em_coupling0, equilibrium0, magnetics0, pf_active0, pf_passive0, core_profiles0, core_sources0 &
  & ,bndcond_in &
  & ,pulse_schedule &
  & ,em_coupling,equilibrium, magnetics, pf_active, pf_passive, core_profiles, core_sources, core_transport &
  & ,summary &
  & ,arr_in1, arr_out1 )
  


use ids_schemas
use ids_routines
implicit none


! trees are static or dynamic; if not defined, they are static
type (ids_em_coupling)  :: em_coupling0, em_coupling
type (ids_equilibrium) :: equilibrium0, equilibrium
type (ids_magnetics)   :: magnetics0, magnetics
type (ids_pf_active)   :: pf_active0, pf_active
type (ids_pf_passive)   :: pf_passive0, pf_passive
type (ids_core_profiles)   :: core_profiles0, core_profiles
type (ids_core_transport)   :: core_transport
type (ids_core_sources)   :: core_sources0, core_sources
type (ids_transport_solver_numerics) :: bndcond_in
type (ids_pulse_schedule)   :: pulse_schedule
type (ids_summary) :: summary

    real (ids_real) :: arr_in1(501), arr_out1(501)

    end subroutine
end interface

interface 
! Declaration of the dina_imas subroutine
    subroutine dina_contr (arr_in1,arr_out1)
     use ids_schemas
    real (ids_real) :: arr_in1(501), arr_out1(501)
    end subroutine
    
end interface


type (ids_em_coupling) :: em_coupling, em_coupling0
type (ids_equilibrium) :: equilibrium0, equilibrium
type (ids_magnetics) :: magnetics, magnetics0
type (ids_pf_active) :: pf_active, pf_active0
type (ids_pf_passive) :: pf_passive, pf_passive0
type (ids_core_profiles)   :: core_profiles0, core_profiles
type (ids_core_sources)   :: core_sources0, core_sources
type (ids_core_transport)   :: core_transport
type (ids_transport_solver_numerics) :: bndcond
type (ids_pulse_schedule)   :: pulse_schedule
type (ids_dataset_description) :: data_description
type (ids_summary) :: summary
type (ids_wall) :: wall

real (ids_real) :: arr_in1(501), arr_out1(501)

! define the pulse and run numbers for testing, will be done later outside
integer :: pulse=170, run=4, prescribedpulse=170, prescribedrun=1

! define local variables
integer :: time_loop, key(25), indpf(12), ext_transp, i, iloop, idec, imax
real (ids_real) :: tmax, tpfa
real (ids_real) :: uff1(14) = (/1,2,3,2,1,2,3,2,1,2,3,2,1,2/),temp(50)
integer :: idx, idx0, err
integer :: nact,npass,ngrid,nbpol,nflux,nrad,npolar,ncronos,nr,nz
character (len=255) :: user


! for timing tests
INTEGER :: clock_start,clock_end,clock_rate


call getenv("USER", user)
print *,'User name is ', user


print *,'Enter pulse number...'
!read (*,*) pulse
prescribedpulse = pulse


print *,'Enter run number...'
!read (*,*) run
prescribedrun = 1


!print *,' Enter maximum steps number'
!read (*,*)imax
imax=1000000


!print *,' Enter maximum time'
!read (*,*)imax
tmax=10000.d0


print *,'Enter decimation for filling the database...'
!read (*,*)idec
idec=100000


print *,' Input pulse,run =', prescribedpulse, prescribedrun
print *,' Output pulse, run =', pulse, run
print *,' Maximum time steps amount =', imax
print *,' Maximum simulation time =', tmax, ' seconds'
print *,' Database put decimation =', idec


print *,'Press any key to begin simulation...'
!read (*,*)


write(*,*) 'Reading the prescribed IDS'
! call imas_open('ids',prescribedpulse,prescribedrun,idx0) 
call imas_open_env('ids',prescribedpulse,prescribedrun,idx0,user,'test','3') 

call ids_get(idx0,"em_coupling",em_coupling0)
call ids_get(idx0,"magnetics",magnetics0)
call ids_get(idx0,"equilibrium",equilibrium0)
call ids_get(idx0,"pf_active",pf_active0)
call ids_get(idx0,"pf_passive",pf_passive0)
call ids_get(idx0,"core_profiles",core_profiles0)
call ids_get(idx0,"core_sources",core_sources0)
call ids_get(idx0,"transport_solver_numerics",bndcond)
call ids_get(idx0,"pulse_schedule",pulse_schedule)
call ids_get(idx0,"dataset_description",data_description)
call ids_get(idx0,"wall",wall)

write(*,*) 'Finished reading the prescribed IDS'
call imas_close(idx0)

arr_in1(1:31)=1
arr_out1(1:31)=0



  call imas_create_env('ids',pulse,run,1,1,idx,user,'test','3')
  write(*,*) 'Pulse file is created'

  call ids_put(idx,"dataset_description",data_description)
  call ids_put(idx,"pulse_schedule",pulse_schedule)


do iloop=1,imax

write(*,*) 'call DINA_IMAS i =',iloop
flush(6)

call dina_imas( &
 &   em_coupling0, equilibrium0, magnetics0, pf_active0, pf_passive0, core_profiles0, core_sources0 &
 & , bndcond &
 & , pulse_schedule &
 & , em_coupling, equilibrium, &
 & magnetics, pf_active, pf_passive, core_profiles, core_sources, core_transport &
 & , summary &
 & , arr_in1,arr_out1)

 
write(*,*) "DINA_IMAS finished"
flush(6)


call ids_deallocate(pf_active0)
call ids_deallocate(pf_passive0)
call ids_deallocate(em_coupling0)
call ids_deallocate(equilibrium0)
call ids_deallocate(magnetics0)
call ids_deallocate(core_profiles0)
call ids_deallocate(core_sources0)
write(*,*) "DINA_IMAS inputs deallocated"
flush(6)


call dina_contr(arr_out1,arr_in1)

write(*,*) "Controller finished"
flush(6)

!call dina_transp1(equilibrium0, core_profiles0, core_sources0, core_profiles, core_sources)
!call dina_transp2(equilibrium0, core_profiles0, core_profiles)
!call dina_transp3(equilibrium0, core_profiles0, core_profiles)
!call dina_transp4(equilibrium0, core_profiles0, core_profiles)
!call dina_transp5(equilibrium0, core_sources0, core_sources)

call ids_deallocate(bndcond)
call solps_imas(equilibrium, core_transport, bndcond)

write(*,*) "SOLPS finished"
flush(6)

! if (iloop == 1) then
! write(*,*)  'Put non-timed'
! 
!   call ids_put(idx,"pf_active",pf_active)
!   call ids_put(idx,"pf_passive",pf_passive)
! 
!   call ids_put(idx,"equilibrium",equilibrium)
!   call ids_put(idx,"core_profiles",core_profiles)
! 
! else
! 
! write(*,*)  'Put slices'
! 
! !magnetics%time(1) = 123
! !call ids_put_slice(idx,"magnetics",magnetics)
! 
! write(*,*)  'Put pf_active'
! call ids_put_slice(idx,"pf_active",pf_active)
! 
! write(*,*)  'Put pf_passive'
! call ids_put_slice(idx,"pf_passive",pf_passive)
! 
! write(*,*)  'Put equilibrium'
! call ids_put_slice(idx,"equilibrium",equilibrium)
! 
! write(*,*)  'Put core_profiles'
! call ids_put_slice(idx,"core_profiles",core_profiles)
! 
! write(*,*)  'Slices put'
! 
! endif

if (mod(iloop,idec).eq.0 .or. iloop.eq.1) then

write(*,*) 'Put ids to database, iloop = ', iloop
flush(6)

call dina_put_slice(pf_active, pf_passive, equilibrium, core_profiles, &
 & core_sources, core_transport, bndcond, summary, wall, em_coupling, magnetics, &
& pulse, run, idx, iloop, err)


endif


write(*,*) 'Copy magnetics'
flush(6)
call ids_copy(magnetics, magnetics0)
write(*,*) 'Copy pf_active'
flush(6)
call ids_copy(pf_active, pf_active0)
write(*,*) 'Copy pf_passive'
flush(6)
call ids_copy(pf_passive, pf_passive0)
write(*,*) 'Copy core_profiles'
flush(6)
call ids_copy(core_profiles, core_profiles0)
write(*,*) 'Copy core_sources'
flush(6)
call ids_copy(core_sources, core_sources0)




write(*,*) '****** Pulsetime =',summary%time(1),'/',tmax
flush(6)

tpfa = 0.d0
do i=1,11
  tpfa = tpfa + dabs(pf_active%coil(i)%current%data(1))
enddo

if (summary%time(1).gt.tmax .or. (dabs(summary%global_quantities%ip%value(1)).lt.1.d3 .and. tpfa.lt.1.d3)) exit


write(*,*) 'Deallocate IDS '
flush(6)
call ids_deallocate(pf_active)
call ids_deallocate(pf_passive)
call ids_deallocate(em_coupling)
call ids_deallocate(equilibrium)
call ids_deallocate(magnetics)
call ids_deallocate(core_profiles)
call ids_deallocate(core_sources)
call ids_deallocate(core_transport)
call ids_deallocate(summary)
write(*,*) 'IDS deallocated'
flush(6)


end do

call imas_close(idx)

!>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
write(*,*) 'DINA_IMAS loop finished, clean up'

!write(*,*) 'Deallocate static IDS'
!call ids_deallocate(em_coupling0)
!call ids_deallocate(equilibrium0)
!call ids_deallocate(pf_active0)
!call ids_deallocate(pf_passive0)
!call ids_deallocate(pulse_schedule)
!call ids_deallocate(core_profiles0)
!call ids_deallocate(core_sources0)

!call ids_deallocate(pf_active)
!call ids_deallocate(pf_passive)
!call ids_deallocate(equilibrium)
!call ids_deallocate(magnetics)
!call ids_deallocate(core_profiles)

! write(*,*) 'Read back full dynamic IDS as a test'
! 
! call imas_open('ids',pulse,run,idx)
! !call ids_get(idx,"magnetics",magnetics)
! call ids_get(idx,"pf_active",pf_active)
! call ids_get(idx,"pf_passive",pf_passive)
! 
! call imas_close(idx)
! 
! write(*,*) "coil 1 current = ",pf_active%coil(1)%current%data
! !write(*,*) "outline = ", pf_active%coil(5)%element(1)%geometry%outline%r
! !write(*,*) "shape1",dina%output_group_7%shape%data(1,:)
! write(*,*) "loop 1 current = ",pf_passive%loop(1)%current


write(*,*) 'DINA_IMAS Exiting cleanly'

end 
