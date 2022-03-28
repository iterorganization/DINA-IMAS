subroutine dina_sdn(sdnin,arrinout,ioswitch,sdn)

use ids_schemas
use ids_routines
implicit none

type(ids_real_time_data) :: sdnin,sdn
!integer, parameter :: DP = kind(1.0d0)
real(ids_real) arrinout(*)
integer :: ioswitch

integer :: i, k, j, idx
integer,save :: ifirst = 1

write(*,*) 'dina_sdn ', ifirst, ioswitch
if (ifirst.eq.1 .AND. ioswitch.eq.0) then
  write(*,*) 'Static SDN setup'
!else
!  write(*,*) 'before ids_deallocate(sdn)'
!  call ids_deallocate(sdn)
!  write(*,*) 'after  ids_deallocate(sdn)'
!endif 

  !allocate(sdn%signal(74)) !36input+38output
  allocate(sdn%topic(2))
  allocate(sdn%topic(1)%name(1))
  sdn%topic(1)%name(1) = 'Input SDN'
  allocate(sdn%topic(1)%signal(36))
  do i=1,36 !indices in arrin
    sdn%topic(1)%signal(i)%allocated_position = i
    allocate(sdn%topic(1)%signal(i)%name(1))
    allocate(sdn%topic(1)%signal(i)%value%data(1))
    allocate(sdn%topic(1)%signal(i)%value%time(1))
    sdn%topic(1)%signal(i)%name(1) = ' '
  enddo
  allocate(sdn%topic(2)%name(1))
  sdn%topic(2)%name(1) = 'Output SDN'
  allocate(sdn%topic(2)%signal(38))
  do k=1,38 !indices in arrout
    sdn%topic(2)%signal(k)%allocated_position = k+2
    allocate(sdn%topic(2)%signal(k)%name(1))
    allocate(sdn%topic(2)%signal(k)%value%data(1))
    allocate(sdn%topic(2)%signal(k)%value%time(1))
    sdn%topic(2)%signal(k)%name(1) = ' '
  enddo

  !input names
  i=1
  sdn%topic(1)%signal(i)%name(1) = 'Z coordinate of the plasma current centroid, m'
  i=2
  sdn%topic(1)%signal(i)%name(1) = 'Z coordinate of the plasma magnetic axis, m'
  i=3
  sdn%topic(1)%signal(i)%name(1) = 'Plasma elongation'
  i=4
  sdn%topic(1)%signal(i)%name(1) = 'Plasma current, A'
  i=5
  sdn%topic(1)%signal(i)%name(1) = 'Marker of the limiter plasma configuration'
  i=6
  sdn%topic(1)%signal(i)%name(1) = 'R coordinate of the left plasma boundary point in mid-plane, m'
  i=7
  sdn%topic(1)%signal(i)%name(1) = 'R coordinate of the right plasma boundary point in mid-plane, m'
  i=8
  sdn%topic(1)%signal(i)%name(1) = 'R coordinate of the separatrix point or plasma limiter touching point, m'
  i=9
  sdn%topic(1)%signal(i)%name(1) = 'time, ms'
  i=10
  sdn%topic(1)%signal(i)%name(1) = 'Z coordinate of the separatrix point or plasma limiter touching point, m'
  i=11
  sdn%topic(1)%signal(i)%name(1) = 'number of PF coils including contours of VS3, triangular support, copper cladding and divertor inboard rail (= 15)'
  i=12
  sdn%topic(1)%signal(i)%name(1) = 'number of controlled gaps between plasma boundary and first wall (= 6)'
  i=13
  sdn%topic(1)%signal(i)%name(1) = 'current number of time step'
  i=14
  sdn%topic(1)%signal(i)%name(1) = 'number of vacuum vessel filaments (= 100)'
  i=15
  sdn%topic(1)%signal(i)%name(1) = 'internal flag'
  i=16
  sdn%topic(1)%signal(i)%name(1) = 'gaps between plasma and limiter (6 inputs), m'
  i=22
  sdn%topic(1)%signal(i)%name(1) = 'currents in the poloidal field coils, internal coils and copper cladding (15 inputs), A'

  !output names
  k=1
  sdn%topic(2)%signal(k)%name(1) = 'voltages in the poloidal field coils (11 outputs), V'
  k=12
  sdn%topic(2)%signal(k)%name(1) = 'voltage in VS3 coils (1 output), V'
  k=13
  sdn%topic(2)%signal(k)%name(1) = 'voltage in triangular support (1 output), V'
  k=14
  sdn%topic(2)%signal(k)%name(1) = 'voltage in copper cladding (1 output), V'
  k=15
  sdn%topic(2)%signal(k)%name(1) = 'voltage in divertor inboard rail (1 output), V'
  k=16
  sdn%topic(2)%signal(k)%name(1) = 'voltages in main converters (11 outputs), V'
  k=27
  sdn%topic(2)%signal(k)%name(1) = 'voltages in vertical stabilization converters (12 outputs), V'

  sdn%ids_properties%homogeneous_time=1
  allocate(sdn%time(1))
  sdn%time(1)=0
  allocate(sdn%ids_properties%comment(1))
  sdn%ids_properties%comment(1)='DINA SDN'
  ifirst = ifirst+1

else
  write(*,*) 'before ids_copy(sdnin,sdn)'
  !call ids_deallocate(sdn)
  !write(*,*) 'after ids_deallocate(sdn)'
  call ids_copy(sdnin,sdn)
  write(*,*) 'after ids_copy(sdnin,sdn)'
endif

if (ioswitch.eq.0) then

  write(*,*) 'Input SDN data ', size(sdn%topic(1)%signal)
  do i=1,size(sdn%topic(1)%signal)
    sdn%topic(1)%signal(i)%value%data(1) = arrinout(sdn%topic(1)%signal(i)%allocated_position)
  enddo

  !put input time
  sdn%time(1)=sdn%topic(1)%signal(9)%value%data(1)*1e-3

else if (ioswitch.eq.1) then

  write(*,*) 'Output SDN data ', size(sdn%topic(2)%signal)
  do k=1,size(sdn%topic(2)%signal)
    sdn%topic(2)%signal(k)%value%data(1) = arrinout(sdn%topic(2)%signal(k)%allocated_position)
  enddo

endif

return
end subroutine
