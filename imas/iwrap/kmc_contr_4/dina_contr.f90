!> kmc_step simulates one time step of the magnetic controller work. 
!> The actor calls C-code generated from Simulink and connects inputs/outputs with IMAS IDS


#define ReAlloc(array, length)  if (.NOT.associated(array)) then ; \
  allocate(array(length)) ; \
  else ; \
  if (size(array).ne.length) then ; \
  deallocate(array) ; \
  allocate(array(length)) ; \
  end if ; \
  end if

#define FillCodeParameters(ids, error_flag, paramstr, codename, desc) ReAlloc(ids%code%repository, 1) ; \
ids%code%repository = GIT_URL ; \
ReAlloc(ids%code%commit, 1) ; \
ids%code%commit = GIT_COMMIT_ID ; \
ReAlloc(ids%code%version, 1) ; \
ids%code%version = GIT_VERSION ; \
ReAlloc(ids%code%parameters, size(paramstr)) ; \
ids%code%parameters = paramstr ; \
ReAlloc(ids%code%output_flag, 1) ; \
ids%code%output_flag(1) = error_flag ; \
ReAlloc(ids%code%name, 1) ; \
ids%code%name = codename ; \
ReAlloc(ids%code%description, 1) ; \
ids%code%description = desc

#define FillCodeParametersKMC(ids) FillCodeParameters(ids, error_flag, codeparam%parameters_value, 'kmc_step', 'ITER magnetic controller designed by A.Kavin for the plasma current, shape and vertical stabilisation; working from fully charged central solenoid to the end of poloidal coils discharge, supporting restart.')


module kav_mag_contr


integer :: code_state

contains


subroutine kmc_step(pulse_schedule, pulse_schedule_term, equilibrium0, pf_active0, pf_active &
  & ,codeparam,error_flag,error_message)

use ids_schemas
use ids_routines
implicit none

include 'imas_interface.inc'

 type(ids_parameters_input) :: codeparam
 integer, intent(out) :: error_flag
 character(len=:), pointer, intent(out) :: error_message
 
type (ids_pulse_schedule), intent(IN) :: pulse_schedule, pulse_schedule_term
type (ids_equilibrium), intent(IN) :: equilibrium0
type (ids_pf_active), intent(IN) :: pf_active0
type (ids_pf_active), intent(OUT) :: pf_active


integer :: kpr
      common /ge5/kpr

integer :: i, kk
integer,save :: loop_count = 0

integer,parameter :: npf=15, n_gaps=6, ncam=100;
integer,parameter :: n_input1=15, n_input2=n_gaps+npf+ncam
integer,parameter :: n_output1=2, n_output2=38

integer,parameter :: nact=12, npfa=14

! dynamic inputs and outputs groups
integer, parameter ::  kint=200
real*8 :: input_1(kint), input_2(kint)
real*8 :: output_1(kint), output_2(kint)


real*8 :: pf(npf)
integer :: ncirc(npf), dircirc(npf)
integer :: igaps(n_gaps)
real*8 :: vmult(npf)
real*8 :: pf_turn(nact)
data ncirc(1:14) /1, 2, 3, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 12/
data dircirc(1:14) /1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1/
data vmult(1:14) /1, 1, 0.5d0, 0.5d0, 1, 1, 1, 1, 1, 1, 1, 1, 0.5d0, -0.5d0/
data pf_turn(1:12) /554., 554., 554. ,554., 554., 248.6, 115.2, 185.9, 169.9, 216.8, 459.4, 4.0/
data igaps(1:6) /1, 2, 2, 3, 4, 4/


integer :: ncirc2(14)
real*8 :: vmult2(14)
!                   CS3U  CS2U  CS1U  CS1L  CS2L  CS3L   PF1    PF2    PF3    PF4    PF5    VS1    PF6   VS3
data ncirc2(1:14) /  16,   17,   18,   18,   19,   20,   21,    22,    23,    24,    25,    36,    26,   38 /
data vmult2(1:14) / 554., 554., 277., 277., 554., 554., 248.6, 115.2, 185.9, 169.9, 216.8, 216.8, 459.4,  4.0 /


!real(ids_real) :: dsep, dsep_ref

  !kpr = 1
  
  !tpl_dir = -1.d0
  
  if (loop_count.eq.0) then
    write(*,*) 'Controller parameters initialization...'
    call contr_data_read_imas(pulse_schedule, pulse_schedule_term, codeparam)
  endif

  loop_count = loop_count + 1 ! number of times the iterative routine was entered

  write(*,*) 'Entering dina_contr loop, loop_count = ', loop_count



  input_1(1)=equilibrium0%time_slice(1)%global_quantities%current_centre%z
  input_1(2)=equilibrium0%time_slice(1)%global_quantities%magnetic_axis%z ! Not used
  input_1(3)=equilibrium0%time_slice(1)%boundary%elongation
  input_1(4)=tpl_dir*equilibrium0%time_slice(1)%global_quantities%ip
  input_1(5)=equilibrium0%time_slice(1)%boundary%type
  input_1(6)=equilibrium0%time_slice(1)%boundary%geometric_axis%r - equilibrium0%time_slice(1)%boundary%minor_radius ! xleft
  input_1(7)=equilibrium0%time_slice(1)%boundary%geometric_axis%r + equilibrium0%time_slice(1)%boundary%minor_radius ! xright
  input_1(8)=0.d0 ! rsep
  input_1(9)=1.d3*equilibrium0%time_slice(1)%time
  input_1(10)=0.d0 ! zsep

  ! In fact the values 11-15 are not used
  input_1(11)=npf
  input_1(12)=n_gaps
  input_1(13)=1.d0 ! ntay
  input_1(14)=ncam
  input_1(15)=0.d0 ! i_wr

  
  ! print*, 'npf, npfa =', npf, npfa
  ! do i=1,npfa
    ! print*,' i, pf_active0%coil(i) current', i, pf_active0%coil(i)%current%data(1)
  ! enddo


  pf(1:npf) = 0.d0
  do i=1,npfa
    pf(ncirc(i)) = tpl_dir*dircirc(i)*pf_active0%coil(i)%current%data(1)*pf_turn(ncirc(i))
  enddo

  kk=0
  do i=1,n_gaps
    kk=kk+1
    input_2(kk) = equilibrium0%time_slice(1)%boundary_separatrix%gap(igaps(i))%value
  end do
    
  do i=1,npf
    kk=kk+1
    input_2(kk)=pf(i)
  end do

  do i=kk+1,n_input2
    input_2(i) = 0.d0
  enddo


  !dsep = equilibrium0%time_slice(1)%boundary_secondary_separatrix%distance_inner_outer

  ! dsep control
  !if ((tt.gt.70.d0).and.(dabs(input_1(4)).gt.14.5d6)) then
    !dsep_ref = 3.6d-2
    !input_2(4) = input_2(4) - 10.d0*(dsep-dsep_ref)
  !end if



  ! if (kpr.eq.1) then
  !   write(*,*) 'kav_contr n_input1 n_input2 = ',n_input1,n_input2
  !   print*, 'i  input_1(i)'
  !   do i=1,n_input1
  !     print*, i, input_1(i)
  !   enddo
  !   print*, 'i  input_2(i)'
  !   do i=1,n_input2
  !     print*, i, input_2(i)
  !   enddo
  ! endif


  call kav_contr(input_1,input_2, &
      &  output_1,output_2)
      
  
  print*, 'Native controller code finished'
  flush(6)


  call ids_copy(pf_active0, pf_active)

  print*, 'pf_active copied'
  flush(6)
  !pf_active%ids_properties%homogeneous_time = 1
  !if (.NOT.associated(pf_active%time)) allocate(pf_active%time(1))
  !pf_active%time(1) = tt
      
  ! Assign coil voltages
  do i=1,14
    if (.NOT.associated(pf_active%coil(i)%voltage%data)) allocate(pf_active%coil(i)%voltage%data(1))
    pf_active%coil(i)%voltage%data(1) = tpl_dir*vmult(i)*output_2(ncirc(i))*pf_turn(ncirc(i))
  enddo

  ! Assign power supply voltages
  do i=1,14
    if (.NOT.associated(pf_active%supply(i)%voltage%data)) allocate(pf_active%supply(i)%voltage%data(1))
    pf_active%supply(i)%voltage%data(1) = tpl_dir*output_2(ncirc2(i))*vmult2(i)
  enddo


  print*, 'pf_active voltages allocated'
  flush(6)
  
error_flag = 0

FillCodeParametersKMC(pf_active)

return
end subroutine


end module kav_mag_contr

