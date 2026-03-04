
program KMC_test

use ids_schemas
use ids_routines

use f90_file_reader, only: file2buffer
use xml2eg_mdl, only: xml2eg_parse_memory, xml2eg_get, type_xml2eg_document, xml2eg_free_doc

use kav_mag_contr

implicit none




type (ids_equilibrium) :: equilibrium0
type (ids_pf_active) :: pf_active, pf_active0
type (ids_pulse_schedule)   :: pulse_schedule, pulse_schedule_term


integer :: ibackend = 12


! IDS location data
character (len=255) :: user_default

character (len=255) :: user_out='', database_out
integer :: pulse_out=-1, run_out=-1

character (len=255) :: user_eq='', database_eq
integer :: pulse_eq=-1, run_eq=-1



integer :: i, imax = 1000

integer :: idx_e, idx
integer :: interp_start = 1
real (ids_real) :: time_start, time_sim, time_get, time_stop

character(len=30) :: ConfigFile, CodeParamsFile
type(type_xml2eg_document) :: doc
character(len=132), pointer :: buffer(:) => NULL()
integer :: io_unit = 1

! For timing tests
INTEGER :: clock_start,clock_end,clock_rate


 type(ids_parameters_input) :: codeparam
 integer :: error_flag
 character(len=:), pointer :: error_message




call getenv("USER", user_default)



if (command_argument_count().eq.0) then
  print *,'Two arguments must be provided. First argument must be the name of a workflow config XML file, second argument is a code parameters XML file.'
  stop
endif


  call get_command_argument(1, ConfigFile)
  call get_command_argument(2, CodeParamsFile)



print *,' Using workflow config file: ', ConfigFile


call file2buffer(ConfigFile, io_unit, buffer)
call xml2eg_parse_memory(buffer, doc)
  
  call xml2eg_get(doc, 'input_scenario/user', user_eq)
  call xml2eg_get(doc, 'input_scenario/database', database_eq)
  call xml2eg_get(doc, 'input_scenario/pulse', pulse_eq)
  call xml2eg_get(doc, 'input_scenario/run', run_eq)

  call xml2eg_get(doc, 'output/user', user_out)
  call xml2eg_get(doc, 'output/database', database_out)
  call xml2eg_get(doc, 'output/pulse', pulse_out)
  call xml2eg_get(doc, 'output/run', run_out)

  call xml2eg_get(doc, 'time_start', time_start)
  call xml2eg_get(doc, 'time_sim', time_sim)
  
call xml2eg_free_doc(doc)
deallocate(buffer)


if (trim(user_eq).eq.'') user_eq = user_default
if (trim(user_out).eq.'') user_out = user_default


print *,' Equilibrium user, database, pulse, run =', trim(user_eq), trim(database_eq), pulse_eq, run_eq
print *,' Output user =', trim(user_out), trim(database_out), pulse_out, run_out



interp_start = 1


call imas_open_env('ids',pulse_eq,run_eq,idx_e,user_eq,database_eq,'3')

call ids_get(idx_e,"pulse_schedule",pulse_schedule)
call ids_get(idx_e,"pulse_schedule/1",pulse_schedule_term)




flush(6)


! Get code parameters
call file2buffer(CodeParamsFile, io_unit, codeparam%parameters_value)


  call imas_create_env('ids',pulse_out,run_out,1,1,idx,user_out,database_out,'3')
  write(*,*) 'Output database is created'
  
    write(*,*)  'Put pulse_schedule'
    call ids_put(idx,"pulse_schedule",pulse_schedule)
	
    write(*,*)  'Put pulse_schedule_term'
    call ids_put(idx,"pulse_schedule/1",pulse_schedule_term)
	

time_stop = time_start + time_sim
time_get = time_start

do i=1,imax

if (time_get.gt.time_stop) exit

call ids_get_slice(idx_e,"equilibrium",equilibrium0, time_get, interp_start)
call ids_get_slice(idx_e,"pf_active",pf_active0, time_get, interp_start)

pf_active0%time(1) = time_get
equilibrium0%time(1) = time_get
equilibrium0%time_slice(1)%time = time_get

call kmc_step(pulse_schedule, pulse_schedule_term, equilibrium0, pf_active0 &
 & , pf_active &
 & , codeparam, error_flag, error_message)

write(*,*) 'kmc error_flag =', error_flag
if (associated(error_message) .and. error_flag.ne.0) then 
write(*,*) 'kmc error_message =', error_message
endif

flush(6)


    write(*,*)  'Put pf_active'
    call ids_put_slice(idx,"pf_active",pf_active)
	call ids_put_slice(idx,"pf_active/1",pf_active0)
    
    write(*,*)  'Put equilibrium'
    call ids_put_slice(idx,"equilibrium",equilibrium0)

! Time step 
time_get = pf_active%time(1) + 1.e-2

call ids_deallocate(equilibrium0)
call ids_deallocate(pf_active0)
call ids_deallocate(pf_active)

enddo


 call imas_close(idx_e)	
 call imas_close(idx)
	
	
call ids_deallocate(pulse_schedule)
call ids_deallocate(pulse_schedule_term)


write(*,*) 'IDS deallocated'
flush(6)

write(*,*) 'DINA_IMAS Exiting cleanly'

end program KMC_test
