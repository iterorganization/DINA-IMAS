
program DINA_IMAS_test

use ids_schemas
use ids_routines

use f90_file_reader, only: file2buffer
use xml2eg_mdl, only: xml2eg_parse_memory, xml2eg_get, type_xml2eg_document, xml2eg_free_doc

use dina_imas

implicit none




type (ids_em_coupling) :: em_coupling
type (ids_equilibrium) :: equilibrium0, equilibrium
type (ids_magnetics) :: magnetics, magnetics0
type (ids_pf_active) :: pf_active, pf_active0
type (ids_pf_passive) :: pf_passive, pf_passive0
type (ids_core_profiles)   :: core_profiles0, core_profiles
type (ids_core_sources)   :: core_sources0, core_sources
type (ids_core_transport)   :: core_transport
type (ids_transport_solver_numerics) :: bndcond
type (ids_pulse_schedule)   :: pulse_schedule
type (ids_summary) :: summary
type (ids_wall) :: wall


! IDS location data
character (len=255) :: uri_in, uri_out


integer :: i, imax = 1000

integer :: idx_e, idx
integer :: interp_start = 1
real (ids_real) :: time_start, time_sim, time_get, time_stop

character(len=50) :: ConfigFile, CodeParamsFile
type(type_xml2eg_document) :: doc
character(len=132), pointer :: buffer(:) => NULL()
integer :: io_unit = 1

! For timing tests
INTEGER :: clock_start,clock_end,clock_rate


 type(ids_parameters_input) :: codeparam
 integer :: error_flag
 character(len=:), pointer :: error_message




if (command_argument_count().eq.0) then
  print *,'Two arguments must be provided. First argument must be the name of a workflow config XML file, second argument is a code parameters XML file.'
  stop
endif


  call get_command_argument(1, ConfigFile)
  call get_command_argument(2, CodeParamsFile)


print *,' Using workflow config file: ', ConfigFile
print *,' Using code parameters file: ', CodeParamsFile



call file2buffer(ConfigFile, io_unit, buffer)
call xml2eg_parse_memory(buffer, doc)
  
  call xml2eg_get(doc, 'input_scenario/uri', uri_in)
  call xml2eg_get(doc, 'output/uri', uri_out)
  
  call xml2eg_get(doc, 'time_start', time_start)
  call xml2eg_get(doc, 'time_sim', time_sim)

call xml2eg_free_doc(doc)
deallocate(buffer)



print *,' Input scenario URI =', trim(uri_in)
print *,' Output URI =', trim(uri_out)



interp_start = 1

call imas_open(uri_in, OPEN_PULSE, idx_e, error_flag)

call ids_get(idx_e,"pulse_schedule",pulse_schedule)
call ids_get(idx_e,"em_coupling",em_coupling)
call ids_get(idx_e,"wall",wall)

call ids_get_slice(idx_e,"equilibrium",equilibrium0, time_start, interp_start)
call ids_get_slice(idx_e,"core_profiles",core_profiles0, time_start, interp_start)
call ids_get_slice(idx_e,"core_sources",core_sources0, time_start, interp_start)
call ids_get_slice(idx_e,"pf_active",pf_active0, time_start, interp_start)
call ids_get_slice(idx_e,"pf_passive",pf_passive0, time_start, interp_start)
call ids_get_slice(idx_e,"magnetics",magnetics0, time_start, interp_start)

  call imas_close(idx_e)
  
  
  call imas_open(uri_out, CREATE_PULSE, idx, error_flag)
  write(*,*) 'Output database is created'
  
flush(6)

    write(*,*)  'Put pulse_schedule'
    call ids_put(idx,"pulse_schedule",pulse_schedule)
	
    write(*,*)  'Put em_coupling'
    call ids_put(idx,"em_coupling",em_coupling)

    write(*,*)  'Put wall'
    call ids_put(idx,"wall",wall)



! Get code parameters
call file2buffer(CodeParamsFile, io_unit, codeparam%parameters_value)

time_stop = time_start + time_sim
time_get = time_start

do i=1,imax

if (time_get.gt.time_stop) exit

call dina_step( &
 &   em_coupling, equilibrium0, magnetics0, pf_active0, pf_passive0, wall, core_profiles0, core_sources0 &
 & , bndcond &
 & , pulse_schedule &
 & , equilibrium, magnetics, pf_active, pf_passive, core_profiles, core_sources, core_transport &
 & , summary &
 & , codeparam, error_flag, error_message)


write(*,*) 'dina_step error_flag =', error_flag
if (associated(error_message) .and. error_flag.ne.0) then 
write(*,*) 'dina_step error_message =', error_message
endif

flush(6)


    write(*,*)  'Put pf_active'
    call ids_put_slice(idx,"pf_active",pf_active)
    
    write(*,*)  'Put pf_passive'
    call ids_put_slice(idx,"pf_passive",pf_passive)
  
    write(*,*)  'Put equilibrium'
    call ids_put_slice(idx,"equilibrium",equilibrium)
  
    write(*,*)  'Put core_profiles'
    call ids_put_slice(idx,"core_profiles",core_profiles)
  
    write(*,*)  'Put core_sources'
    call ids_put_slice(idx,"core_sources",core_sources)
  
    write(*,*)  'Put core_transport'
    call ids_put_slice(idx,"core_transport",core_transport)
  
    write(*,*)  'Put summary'
    call ids_put_slice(idx,"summary",summary)
  
    write(*,*)  'Put magnetics'
    call ids_put_slice(idx,"magnetics",magnetics)
	

time_get = pf_active%time(1)


call ids_deallocate(pf_active0)
call ids_deallocate(pf_passive0)
call ids_deallocate(equilibrium0)
call ids_deallocate(magnetics0)

call ids_deallocate(core_profiles0)
call ids_deallocate(core_sources0)



call ids_copy(pf_active, pf_active0)
call ids_copy(pf_passive, pf_passive0)
call ids_copy(equilibrium, equilibrium0)
call ids_copy(magnetics, magnetics0)

call ids_copy(core_profiles, core_profiles0)
call ids_copy(core_sources, core_sources0)



call ids_deallocate(pf_active)
call ids_deallocate(pf_passive)
call ids_deallocate(equilibrium)
call ids_deallocate(magnetics)

call ids_deallocate(core_profiles)
call ids_deallocate(core_sources)
call ids_deallocate(core_transport)
call ids_deallocate(summary)

enddo

  
  call imas_close(idx)
	
	
call ids_deallocate(pulse_schedule)
call ids_deallocate(em_coupling)
call ids_deallocate(wall)


write(*,*) 'IDS deallocated'
flush(6)

write(*,*) 'DINA_IMAS Exiting cleanly'

end program DINA_IMAS_test
