
program DINA_GREEN_test

use ids_schemas
use ids_routines

use f90_file_reader, only: file2buffer
use xml2eg_mdl, only: xml2eg_parse_memory, xml2eg_get, type_xml2eg_document, xml2eg_free_doc

use dina_green

implicit none




type (ids_em_coupling) :: em_coupling
type (ids_equilibrium) :: equilibrium
type (ids_magnetics) :: magnetics
type (ids_pf_active) :: pf_active
type (ids_pf_passive) :: pf_passive



! IDS location data
character(len=300) ::  uri_pfa, uri_pfp, uri_mag, uri_eq, uri_out


integer :: i
integer :: nr, nz
real (ids_real) :: r1, r2, z1, z2, dr, dz

integer :: idx_a, idx_p, idx_m, idx_e, idx
integer :: interp_start = 1
real (ids_real) :: time_start

character(len=30) :: ConfigFile, CodeParamsFile
type(type_xml2eg_document) :: doc
character(len=132), pointer :: buffer(:) => NULL()
integer :: io_unit = 1

! For timing tests
INTEGER :: clock_start,clock_end,clock_rate


 type(ids_parameters_input) :: codeparam
 integer :: error_flag
 character(len=:), pointer :: error_message
 logical:: error_eq, error_mag


nr = 65
nz = 129
r1 = 3.d0
r2 = 9.d0
z1 = -6.d0
z2 = 6.d0



if (command_argument_count().eq.0) then
  print *,'Two arguments must be provided. First argument must be the name of a workflow config XML file, second argument is a code parameters XML file.'
  stop
endif


  call get_command_argument(1, ConfigFile)
  call get_command_argument(2, CodeParamsFile)


print *,' Using workflow config file: ', ConfigFile


call file2buffer(ConfigFile, io_unit, buffer)
call xml2eg_parse_memory(buffer, doc)
  
  call xml2eg_get(doc, 'input_pf_active/uri', uri_pfa)

  call xml2eg_get(doc, 'input_pf_passive/uri', uri_pfp)

  call xml2eg_get(doc, 'input_magnetics/uri', uri_mag, error_mag)

  call xml2eg_get(doc, 'input_equilibrium/uri', uri_eq, error_eq)

  call xml2eg_get(doc, 'output/uri', uri_out)

  call xml2eg_get(doc, 'grid/nr', nr)
  call xml2eg_get(doc, 'grid/nz', nz)
  call xml2eg_get(doc, 'grid/rmin', r1)
  call xml2eg_get(doc, 'grid/rmax', r2)
  call xml2eg_get(doc, 'grid/zmin', z1)
  call xml2eg_get(doc, 'grid/zmax', z2)


call xml2eg_free_doc(doc)
deallocate(buffer)


print *,' PF Active uri =', trim(uri_pfa)
print *,' PF Passive uri =', trim(uri_pfp)


print *,' Output uri =', trim(uri_out)





interp_start = 1
time_start = 0.d0

if (.NOT.error_eq) then
write(*,*) 'Using grid from equilibrium IDS, URI=', trim(uri_eq)

call imas_open(uri_eq, OPEN_PULSE, idx_e, error_flag)
call ids_get_slice(idx_e,"equilibrium",equilibrium, time_start, interp_start)
call imas_close(idx_e)

else
write(*,*) 'No equilibrium IDS, using grid parameters'

print *,' nr, nz =', nr, nz
print *,' r1, r2 =', r1, r2
print *,' z1, z2 =', z1, z2

equilibrium%ids_properties%homogeneous_time=1

allocate(equilibrium%time(1))
allocate(equilibrium%time_slice(1))
equilibrium%time(1) = 0.d0
allocate(equilibrium%time_slice(1)%profiles_2d(1))
equilibrium%time_slice(1)%profiles_2d(1)%type%index = 0
! Grid dimensions
equilibrium%time_slice(1)%profiles_2d(1)%grid_type%index = 1 ! Rectangular a la eqdsk
allocate(equilibrium%time_slice(1)%profiles_2d(1)%grid%dim1(nr))
allocate(equilibrium%time_slice(1)%profiles_2d(1)%grid%dim2(nz))

dr = (r2 - r1)/nr
dz = (z2 - z1)/nz
do i=1,nr
  equilibrium%time_slice(1)%profiles_2d(1)%grid%dim1(i) = r1 + i*dr
enddo
do i=1,nz
  equilibrium%time_slice(1)%profiles_2d(1)%grid%dim2(i) = z1 + i*dz
enddo

endif

call imas_open(uri_pfa, OPEN_PULSE, idx_a, error_flag)
call ids_get_slice(idx_a,"pf_active",pf_active, time_start, interp_start)
call imas_close(idx_a)

call imas_open(uri_pfp, OPEN_PULSE, idx_p, error_flag)
call ids_get_slice(idx_p,"pf_passive",pf_passive, time_start, interp_start)
call imas_close(idx_p)

if (.NOT.error_mag) then
write(*,*) 'Using magnetics IDS URI=', trim(uri_mag)

call imas_open(uri_mag, OPEN_PULSE, idx_m, error_flag)
call ids_get_slice(idx_m,"magnetics",magnetics, time_start, interp_start)
call imas_close(idx_m)

else
write(*,*) 'No magnetics IDS'
endif

flush(6)


! Get code parameters
call file2buffer(CodeParamsFile, io_unit, codeparam%parameters_value)

call get_em_coupling(pf_active, pf_passive, magnetics, equilibrium, em_coupling, &
& codeparam, error_flag, error_message)

write(*,*) 'get_em_coupling error_flag =', error_flag
if (associated(error_message) .and. error_flag.ne.0) then 
write(*,*) 'get_em_coupling error_message =', error_message
endif

flush(6)


write(*,*) 'em_coupling array sizes:'
write(*,*) 'active_active: ', size(em_coupling%mutual_active_active,1), size(em_coupling%mutual_active_active,2)
write(*,*) 'passive_passive: ', size(em_coupling%mutual_passive_passive,1), size(em_coupling%mutual_passive_passive,2)
write(*,*) 'passive_active: ', size(em_coupling%mutual_passive_active,1), size(em_coupling%mutual_passive_active,2)
write(*,*) 'grid_active: ', size(em_coupling%mutual_grid_active,1), size(em_coupling%mutual_grid_active,2)
write(*,*) 'grid_passive: ', size(em_coupling%mutual_grid_passive,1), size(em_coupling%mutual_grid_passive,2)


  call imas_open(uri_out, CREATE_PULSE, idx, error_flag)
  write(*,*) 'Output database is created'
  !call imas_open_env('ids',pulse_out,run_out,idx,user_out,database_out,'3')
  !write(*,*) 'Output database is opened'

    write(*,*)  'Put em_coupling'
    call ids_put(idx,"em_coupling",em_coupling)

    write(*,*)  'Put pf_active'
    call ids_put(idx,"pf_active",pf_active)
    
    write(*,*)  'Put pf_passive'
    call ids_put(idx,"pf_passive",pf_passive)
  
    write(*,*)  'Put equilibrium'
    call ids_put(idx,"equilibrium",equilibrium)
  
    write(*,*)  'Put magnetics'
    !call ids_put(idx,"magnetics",magnetics)
	
  call imas_close(idx)
	
	
call ids_deallocate(em_coupling)
call ids_deallocate(pf_active)
call ids_deallocate(pf_passive)
call ids_deallocate(equilibrium)
call ids_deallocate(magnetics)
write(*,*) 'IDS deallocated'
flush(6)

write(*,*) 'DINA_IMAS Exiting cleanly'

end program DINA_GREEN_test
