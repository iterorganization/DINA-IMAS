
#define AllocIfNull(array, size)  if (.NOT.associated(array)) allocate(array(size))

#define FillCodeParameters(ids, error_flag, paramstr, codename, desc) AllocIfNull(ids%code%repository, 1) ; \
ids%code%repository = GIT_URL ; \
AllocIfNull(ids%code%commit, 1) ; \
ids%code%commit = GIT_COMMIT_ID ; \
AllocIfNull(ids%code%version, 1) ; \
ids%code%version = GIT_VERSION ; \
AllocIfNull(ids%code%parameters, size(paramstr)) ; \
ids%code%parameters = paramstr ; \
AllocIfNull(ids%code%output_flag, 1) ; \
ids%code%output_flag(1) = error_flag ; \
AllocIfNull(ids%code%name, 1) ; \
ids%code%name = codename ; \
AllocIfNull(ids%code%description, 1) ; \
ids%code%description = desc

#define FillCodeParametersWF(ids) FillCodeParameters(ids, error_flag, buffer, 'DINA-Workflow-Fortran', 'Workflow for simulation of ITER scenarios using DINA with feedback magnetic controller.')


#define CopyString(str_from, str_to) if (associated(str_from)) then ; \
  if (associated(str_to)) deallocate(str_to) ; \
  allocate(str_to(size(str_from))) ; \
  str_to = str_from ; \
endif


program DINA_SCENARIO

use ids_schemas
use ids_routines

use f90_file_reader, only: file2buffer
use xml2eg_mdl, only: xml2eg_parse_memory, xml2eg_get, type_xml2eg_document, xml2eg_free_doc

use dina_green
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
type (ids_dataset_description) :: data_description
type (ids_summary) :: summary
type (ids_wall) :: wall
type (ids_workflow) :: workflow


! IDS location data
character(len=300) :: uri_prs, uri_psch, uri_pfa, uri_pfp, uri_mag, uri_emc, uri_wll, uri_ext, uri_out
character (len=255) :: user_default


! Workflow parameters
real (ids_real) :: pulsetime = 0.0, time_start=0.0, time_stop=10000.0
integer :: idec, imax
integer :: ext_transp, restart=0

! Local variables
integer :: i, iloop
integer :: idx, idx0, err
!integer :: nact,npass,ngrid
integer :: interp_start = 1, interp_transp = 1
real (ids_real) :: time_get, time_ext, current_pf_stop

character(len=30) :: ConfigFile
type(type_xml2eg_document) :: doc
character(len=132), pointer :: buffer(:) => NULL()
integer :: io_unit = 1
logical :: errorflag

! For timing tests
INTEGER :: clock_start,clock_end,clock_rate

integer,dimension(8) :: DATETIME
integer :: hh, mm

 type(ids_parameters_input) :: codeparam_green, codeparam_dina
 integer :: error_flag
 character(len=:), pointer :: error_message
 logical:: error_emc, error_mag
 


call getenv("USER", user_default)


ext_transp=0

if (command_argument_count().eq.0) then
  print *,'Not enough arguments. First argument must be the name of a workflow config XML file!'
  stop
endif

do i = 1, command_argument_count()
  call get_command_argument(i, ConfigFile)
end do


print *,' Using workflow config file: ', ConfigFile


call file2buffer(ConfigFile, io_unit, buffer)
call xml2eg_parse_memory(buffer, doc)
  
  call xml2eg_get(doc, 'pulse_schedule/uri', uri_psch)
  call xml2eg_get(doc, 'input_pf_active/uri', uri_pfa)
  call xml2eg_get(doc, 'input_pf_passive/uri', uri_pfp)
  call xml2eg_get(doc, 'input_magnetics/uri', uri_mag, error_mag)
  call xml2eg_get(doc, 'input_em_coupling/uri', uri_emc, error_emc)
  call xml2eg_get(doc, 'input_wall/uri', uri_wll)
  call xml2eg_get(doc, 'input_start/uri', uri_prs)
  call xml2eg_get(doc, 'input_transp/uri', uri_ext)
  call xml2eg_get(doc, 'output/uri', uri_out)
  
  call xml2eg_get(doc, 'time_start', time_start)
  call xml2eg_get(doc, 'start_interp_mode', interp_start)
  call xml2eg_get(doc, 'transp_interp_mode', interp_transp)
  call xml2eg_get(doc, 'time_stop', time_stop)
  call xml2eg_get(doc, 'decimation', idec)
  call xml2eg_get(doc, 'time_ext', time_ext)
  call xml2eg_get(doc, 'step_max', imax)
  

print *,' Pulse schedule uri =', trim(uri_psch)

print *,' PF Active uri =', trim(uri_pfa)
print *,' PF Passive uri =', trim(uri_pfp)
print *,' Wall uri =', trim(uri_wll)

print *,' Start uri =', trim(uri_prs)
print *,' Start time, s =', time_start
print *,' Start interpolation =', interp_start

print *,' Transp uri =', trim(uri_ext)
print *,' Transp interpolation =', interp_transp

print *,' Output uri =', trim(uri_out)
print *,' Output put decimation =', idec

print *,' External transport time, s =', time_ext
print *,' Maximum time steps amount =', imax
print *,' Maximum simulation time, s =', time_stop



  write(*,*) 'Restart from t=', time_start
  time_get = time_start
  
  write(*,*) 'Reading the prescribed IDS'
  call imas_open(uri_prs, OPEN_PULSE, idx0, error_flag)
! call ids_get(idx0, "workflow", workflow)

  !call ids_get_slice(idx0,"em_coupling",em_coupling, time_get, interp_start)
  !call ids_get_slice(idx0,"magnetics",magnetics0, time_get, interp_start)
  call ids_get_slice(idx0,"equilibrium",equilibrium0, time_get, interp_start)
  !call ids_get_slice(idx0,"pf_active",pf_active0, time_get, interp_start)
  !call ids_get_slice(idx0,"pf_passive",pf_passive0, time_get, interp_start)
  call ids_get_slice(idx0,"core_profiles",core_profiles0, time_get, interp_start)
  call ids_get_slice(idx0,"core_sources",core_sources0, time_get, interp_start)
  call ids_get_slice(idx0,"transport_solver_numerics",bndcond, time_get, interp_start)

  data_description%simulation%time_restart = equilibrium0%time(1)
  
  write(*,*) 'Restart from plasma current, A = ', equilibrium0%time_slice(1)%global_quantities%ip

  write(*,*) 'Finished reading the prescribed IDS'
  call imas_close(idx0)




call imas_open(uri_pfa, OPEN_PULSE, idx0, error_flag)
call ids_get_slice(idx0,"pf_active",pf_active0, time_start, interp_start)
call imas_close(idx0)

call imas_open(uri_pfp, OPEN_PULSE, idx0, error_flag)
call ids_get_slice(idx0,"pf_passive",pf_passive0, time_start, interp_start)
call imas_close(idx0)

if (.NOT.error_mag) then
print *,' Using magnetics from URI =', trim(uri_mag)
call imas_open(uri_mag, OPEN_PULSE, idx0, error_flag)
call ids_get_slice(idx0,"magnetics",magnetics0, time_start, interp_start)
call imas_close(idx0)
endif

call imas_open(uri_wll, OPEN_PULSE, idx0, error_flag)
call ids_get_slice(idx0,"wall",wall, time_start, interp_start)
call imas_close(idx0)


call file2buffer('codeparam_dina.xml', io_unit, codeparam_dina%parameters_value)


workflow%ids_properties%homogeneous_time = 2
if (associated(workflow%time_loop%component)) deallocate(workflow%time_loop%component)
allocate(workflow%time_loop%component(3))


if (.NOT.error_emc) then

print *,' Using em_coupling from URI =', trim(uri_emc)
call imas_open(uri_emc, OPEN_PULSE, idx0, error_flag)
call ids_get_slice(idx0,"em_coupling",em_coupling, time_start, interp_start)
call imas_close(idx0)

else

call file2buffer('codeparam_green.xml', io_unit, codeparam_green%parameters_value)

call get_em_coupling(pf_active0, pf_passive0, magnetics0, equilibrium0, em_coupling &
&, codeparam_green, error_flag, error_message)

write(*,*) 'get_em_coupling error_flag =', error_flag
if (associated(error_message) .and. error_flag.ne.0) then 
write(*,*) 'get_em_coupling error_message =', error_message
endif

  CopyString(em_coupling%code%name, workflow%time_loop%component(1)%name)
  CopyString(em_coupling%code%description, workflow%time_loop%component(1)%description)
  CopyString(em_coupling%code%commit, workflow%time_loop%component(1)%commit)
  CopyString(em_coupling%code%version, workflow%time_loop%component(1)%version)
  CopyString(em_coupling%code%repository, workflow%time_loop%component(1)%repository)
  CopyString(em_coupling%code%parameters, workflow%time_loop%component(1)%parameters)

endif


write(*,*) 'Reading the pulse schedule'
call imas_open(uri_psch, OPEN_PULSE, idx0, error_flag)

call ids_get(idx0,"pulse_schedule",pulse_schedule)

call imas_close(idx0)

!print *,'Press any key to begin simulation...'
!read (*,*)

 error_flag = 1
 FillCodeParametersWF(workflow)
 
  
  
  call imas_open(uri_out, CREATE_PULSE, idx, error_flag)
  write(*,*) 'Pulse file is created'

  call ids_put(idx,"wall",wall)
  call ids_put(idx,"em_coupling",em_coupling)
  
  call ids_put(idx,"pulse_schedule",pulse_schedule)
  call ids_put(idx,"workflow",workflow)


 call xml2eg_free_doc(doc)
 deallocate(buffer)
 
 
 data_description%ids_properties%homogeneous_time = 2
 
 
 allocate(data_description%data_entry%user(1))
 data_description%data_entry%user = user_default
 
 
 call date_and_time(VALUES=DATETIME)
 hh = DATETIME(5)
 mm = DATETIME(6) + DATETIME(4)
 do while (mm.gt.59)
   hh=hh+1
   mm=mm-60
 end do
 do while (mm.lt.0)
   hh=hh-1
   mm=mm+60
 end do
 allocate(data_description%simulation%time_begun(1))
 write(data_description%simulation%time_begun, '(I4.4,A,I2.2,A,I2.2,A,I2.2,A,I2.2,A,I2.2,A)') DATETIME(1), '-', DATETIME(2), '-', DATETIME(3) , 'T', &
 &hh, ':', mm, ':', DATETIME(7), 'Z'   
 
 
 call ids_put(idx,"dataset_description",data_description)

do iloop=1,imax

write(*,*) 'call DINA_IMAS i =',iloop
flush(6)


call dina_step( &
 &   em_coupling, equilibrium0, magnetics0, pf_active0, pf_passive0, wall, core_profiles0, core_sources0 &
 & , bndcond &
 & , pulse_schedule &
 & , equilibrium, magnetics, pf_active, pf_passive, core_profiles, core_sources, core_transport &
 & , summary &
 & , codeparam_dina, error_flag, error_message)

write(*,*) 'dina_step error_flag =', error_flag
if (associated(error_message) .and. error_flag.ne.0) then 
write(*,*) 'dina_step error_message =', error_message
endif


write(*,*) "DINA_IMAS finished"
flush(6)


call ids_deallocate(pf_active0)
call ids_deallocate(pf_passive0)
call ids_deallocate(equilibrium0)
call ids_deallocate(magnetics0)
call ids_deallocate(core_profiles0)
call ids_deallocate(core_sources0)
write(*,*) "DINA_IMAS inputs deallocated"
flush(6)



if (iloop.eq.1) then

  CopyString(equilibrium%code%name, workflow%time_loop%component(2)%name)
  CopyString(equilibrium%code%description, workflow%time_loop%component(2)%description)
  CopyString(equilibrium%code%commit, workflow%time_loop%component(2)%commit)
  CopyString(equilibrium%code%version, workflow%time_loop%component(2)%version)
  CopyString(equilibrium%code%repository, workflow%time_loop%component(2)%repository)
  CopyString(equilibrium%code%parameters, workflow%time_loop%component(2)%parameters)

  CopyString(pf_active%code%name, workflow%time_loop%component(3)%name)
  CopyString(pf_active%code%description, workflow%time_loop%component(3)%description)
  CopyString(pf_active%code%commit, workflow%time_loop%component(3)%commit)
  CopyString(pf_active%code%version, workflow%time_loop%component(3)%version)
  CopyString(pf_active%code%repository, workflow%time_loop%component(3)%repository)
  CopyString(pf_active%code%parameters, workflow%time_loop%component(3)%parameters)
  
  call ids_put(idx,"workflow",workflow)
  
end if


write(*,*) "Controller finished"
flush(6)



call ids_deallocate(bndcond)

  call ids_put_slice(idx,"pf_active",pf_active)
  call ids_put_slice(idx,"pf_passive",pf_passive)
  call ids_put_slice(idx,"summary",summary)

  if (mod(iloop,idec).eq.0 .or. iloop.eq.1) then
  
    write(*,*) 'Put ids slice to database, iloop = ', iloop
    flush(6)
    
    write(*,*)  'Put magnetics'
    call ids_put_slice(idx,"magnetics",magnetics)
    
    write(*,*)  'Put equilibrium'
    call ids_put_slice(idx,"equilibrium",equilibrium)
  
    write(*,*)  'Put core_profiles'
    call ids_put_slice(idx,"core_profiles",core_profiles)
  
    write(*,*)  'Put core_sources'
    call ids_put_slice(idx,"core_sources",core_sources)
  
    write(*,*)  'Put core_transport'
    call ids_put_slice(idx,"core_transport",core_transport)
  
    !write(*,*)  'Put transport_solver_numerics'
    !call ids_put_slice(idx,"transport_solver_numerics",bndcond)
  
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


time_get = summary%time(1)

flush(6)
write(*,*) 'time_get time_ext==',time_get,time_ext

if(time_get.ge.time_ext)then
write(*,*) 'Using prescribed transport'
ext_transp=1
end if

if (ext_transp.eq.1) then

  call imas_open(uri_ext, OPEN_PULSE, idx0, error_flag)

  time_get = summary%time(1)
  write(*,*) 'Using prescribed transport, time_get =', time_get
  call ids_get_slice(idx0,"core_profiles",core_profiles0, time_get, interp_transp)
  call ids_get_slice(idx0,"core_sources",core_sources0, time_get, interp_transp)

  call imas_close(idx0)

  
else
write(*,*) 'Using DINA transport'

  call ids_copy(core_profiles, core_profiles0)
  write(*,*) 'Copy core_sources'
  flush(6)
  call ids_copy(core_sources, core_sources0)

endif


pulsetime = summary%time(1)
write(*,*) '****** Pulsetime =',pulsetime,'/',time_stop
flush(6)

  current_pf_stop = 0.d0
do i=1,11
  current_pf_stop = current_pf_stop + dabs(pf_active%coil(i)%current%data(1))
enddo

if (summary%time(1).gt.time_stop .or. (dabs(summary%global_quantities%ip%value(1)).lt.1.d3 .and. current_pf_stop.lt.1.d3)) exit


write(*,*) 'Deallocate IDS '
flush(6)
call ids_deallocate(pf_active)
call ids_deallocate(pf_passive)
call ids_deallocate(equilibrium)
call ids_deallocate(magnetics)
call ids_deallocate(core_profiles)
call ids_deallocate(core_sources)
call ids_deallocate(core_transport)
call ids_deallocate(summary)
write(*,*) 'IDS deallocated'
flush(6)


end do

 

 call date_and_time(VALUES=DATETIME)
 hh = DATETIME(5)
 mm = DATETIME(6) + DATETIME(4)
 do while (mm.gt.59)
   hh=hh+1
   mm=mm-60
 end do
 do while (mm.lt.0)
   hh=hh-1
   mm=mm+60
 end do
 allocate(data_description%simulation%time_ended(1))
 write(data_description%simulation%time_ended, '(I4.4,A,I2.2,A,I2.2,A,I2.2,A,I2.2,A,I2.2,A)') DATETIME(1), '-', DATETIME(2), '-', DATETIME(3) , 'T', &
 &hh, ':', mm, ':', DATETIME(7), 'Z'
 
 data_description%simulation%time_end = pulsetime
 
 error_flag = 0
 workflow%code%output_flag(1) = error_flag

 workflow%time_loop%time_end = pulsetime

 call ids_put(idx,"dataset_description",data_description)
 call ids_put(idx,"workflow",workflow)


call imas_close(idx)

!>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
write(*,*) 'DINA_IMAS loop finished, clean up'

write(*,*) 'Deallocate static IDS'

call ids_deallocate(em_coupling)
call ids_deallocate(wall)
call ids_deallocate(pulse_schedule)
call ids_deallocate(data_description)
call ids_deallocate(workflow)

deallocate(codeparam_dina%parameters_value)
deallocate(codeparam_green%parameters_value)



write(*,*) 'DINA_IMAS Exiting cleanly'

end program DINA_SCENARIO
