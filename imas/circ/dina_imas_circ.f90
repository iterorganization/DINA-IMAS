subroutine dina_imas_circ(&
  &  em_coupling0, equilibrium0, pf_active0, pf_passive0, core_profiles0, core_sources0 &
  & ,bndcond_in &
  & ,pulse_schedule &
  & ,equilibrium, magnetics, pf_active, pf_passive, core_profiles, core_sources, core_transport &
  & ,summary &
  & ,arr_in1, arr_out1 )


use ids_schemas
use ids_routines
implicit none


! trees are static or dynamic; if not defined, they are static
type (ids_em_coupling)  :: em_coupling0
type (ids_equilibrium) :: equilibrium0, equilibrium
type (ids_magnetics)   :: magnetics
type (ids_pf_active)   :: pf_active0, pf_active
type (ids_pf_passive)   :: pf_passive0, pf_passive
type (ids_core_profiles)   :: core_profiles0, core_profiles
type (ids_core_transport)   :: core_transport
type (ids_core_sources)   :: core_sources0, core_sources
type (ids_transport_solver_numerics) :: bndcond_in
type (ids_pulse_schedule)   :: pulse_schedule
type (ids_summary) :: summary


!integer, parameter :: DP = kind(1.0d0)
real (ids_real) :: arr_in1(*), arr_out1(*)


! define local fixed size variables
integer,save :: i, k,  j
integer,save :: first_call = 1, loop_count = 0, ntime = 0

integer,save :: kloop,kprobe, ke=57

integer,save :: nact=30, npass=300 , nflux=60, nbpol=70, nelem = 1

integer,save :: n_input1, n_input2, ng
integer,save :: n_output1, n_output2

integer,save ::  n_gaps=6
          
integer ::  kpr

      common /ge5/kpr

integer   ::  ih_imas
     common /c_imas_is/ih_imas

integer,save :: key(27)=(/ (0,i=1,27) /)

! static and prescribed data expressed in DINA terms
real (ids_real),save :: dina_time=0
real (ids_real),save :: time_8,tt_8,tay_8

integer ::  npo

parameter ( npo=500)

real (ids_real),save :: vec(npo) = (/ (0,i=1,npo) /)

! dynamic inputs and outputs groups
real (ids_real),save :: input_1(npo) = (/ (0,i=1,npo) /)
real (ids_real),save :: input_2(npo) = (/ (0,i=1,npo) /)
real (ids_real),save :: input_3(npo) = (/ (0,i=1,npo) /)

real (ids_real),save :: output_1(npo) = (/ (0,i=1,npo) /)
real (ids_real),save :: output_2(npo) = (/ (0,i=1,npo) /)
real (ids_real),save :: output_3(npo) = (/ (0,i=1,npo) /)
real (ids_real),save :: output_4(npo) = (/ (0,i=1,npo) /)


! DINA parameters
    integer,parameter :: ntet = 134
    integer,parameter :: nr = 65, nz = 129, ngrid=nr*nz
    integer,parameter :: npf = 15, ncam = 100
    
    real(ids_real) :: tpl=1000.0,uli=1000.0,v=1000.0,parea=1000.0,psi_ax=1000.0,rmag=1000.0,zmag=1000.0 &
  & ,q_ax=1000.0,q_95=1000.0,rs0=1000.0,bt0=1000.0,wen2=1000.0,tt = 1.0,psi_bnd = 1000.0 &
  & ,rmajor,rminor,elong,tri
    real(ids_real) :: betap,betat,tec,tqc,pec,pic,zeff,vloop,tene,wfus,emag

    real(ids_real) :: x(nr),y(nz),psi(nr,nz),psi1(nr,nz),curr_d(nr,nz)

    real(ids_real) :: ai(npo),te0(npo),tq0(npo),pne(npo),tok1(npo),q(npo)

    real(ids_real) :: pd0(npo),pt0(npo),sigk(npo),jbut(npo),aj0(npo),qe0(npo),qq0(npo)
    
    real(ids_real) :: xbound(ntet),ybound(ntet)
    
    real(ids_real) :: vchopper(npf),pf(npf),tcam(ncam)

    real(ids_real),parameter :: pi = 3.14159265358979323846


  integer :: TimeSteps, CurTimeStep
  
  integer :: n1, n2, n ,i_wr

real (ids_real),save ::  gridrange(4)
real(ids_real), dimension(:,:), ALLOCATABLE,save :: fluxarr,vesarr,pslgreen,bprgreen,pfind,pmj
real(ids_real), dimension(:,:), ALLOCATABLE,save :: pfc,pfgreen,vesgreen,pfprobe,vesprobe
real(ids_real), dimension(:), ALLOCATABLE,save :: pfres, rcam, xu, yu

real(ids_real),save :: cpu_old = 0.d0, cpu_new

real(ids_real) :: yfluxd_xx,yfluxt_xx,yfluxe_xx,yfluxi_xx,ysbound_xx


	character *20 apr,filename

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))


if (first_call == 1) then ! convert input trees to local variables before calling dina

call cpu_time(cpu_old)

! call schedulefiles(pulse_schedule,equilibrium0)


nact=size(em_coupling0%mutual_grid_active,2)
print *,'size em_coupling0%mutual_grid_active',nact
npass=size(em_coupling0%mutual_grid_passive,2)
print *,'size em_coupling0%mutual_grid_passive',npass

nflux=size(em_coupling0%mutual_loops_grid,1)
print *,'em_coupling0%mutual_loops_grid 1',nflux
nbpol=size(em_coupling0%field_probes_grid,1)
print *,'em_coupling0%field_probes_grid 1',nbpol

ke=size(equilibrium0%time_slice(1)%coordinate_system%r,1)
print *,'equilibrium0%coordinate_system%r 1',ke


ALLOCATE(fluxarr(ngrid,nact))
ALLOCATE(vesarr(ngrid,npass))
ALLOCATE(pslgreen(ngrid,nflux))
ALLOCATE(bprgreen(ngrid,nbpol))

ALLOCATE(vesgreen(nflux,npass))
ALLOCATE(vesprobe(nbpol,npass))

ALLOCATE(pfgreen(nflux,nact))
ALLOCATE(pfprobe(nbpol,nact))

ALLOCATE(pfind(nact,nact))
ALLOCATE(pmj(npass,npass))
ALLOCATE(pfc(npass,nact))

ALLOCATE(pfres(nact))
ALLOCATE(rcam(npass))

ALLOCATE(xu(ke))
ALLOCATE(yu(ke))


  write(*,*) 'Shapes of locally allocated arrays'
  write(*,100) shape(fluxarr),shape(vesarr),shape(pslgreen),shape(bprgreen)
  write(*,100) shape(pfgreen),shape(vesgreen),shape(pfprobe),shape(vesprobe)
  write(*,100) shape(pfind),shape(pmj),shape(pfc)
  write(*,100) shape(pfres),shape(rcam),shape(xu),shape(yu)


write(*,*) 'Entering DINA_IMAS, first_call = ', first_call, loop_count, dina_time

flush(6)


!print *,' before imas_open'
! call imas_open('ids',prescribedpulse,prescribedrun,idx0) 
! print *,' before ids_get idx0',idx0
! 
! !call ids_get(idx0,"dina/1",dina0)
! call ids_get(idx0,"pf_active",pf_active)
! 
! call imas_close(idx0)
!print *,' close imas'


  write(*,*) 'Shapes '
  write(*,100) shape(em_coupling0%mutual_grid_active),shape(em_coupling0%mutual_grid_passive)

write(*,*) 'Shapes '
write(*,100) shape(em_coupling0%mutual_loops_grid),shape(em_coupling0%field_probes_grid)

fluxarr = em_coupling0%mutual_grid_active
vesarr = em_coupling0%mutual_grid_passive

pslgreen = transpose(em_coupling0%mutual_loops_grid)
bprgreen = transpose(em_coupling0%field_probes_grid)

i=size(em_coupling0%mutual_loops_grid,1)
print *,'em_coupling0%mutual_loops_grid',i

i=size(em_coupling0%field_probes_grid,1)
print *,'em_coupling0%field_probes_grid',i

vesgreen = em_coupling0%mutual_loops_passive
vesprobe = em_coupling0%field_probes_passive

pfgreen = em_coupling0%mutual_loops_active
pfprobe = em_coupling0%field_probes_active

pfind = em_coupling0%mutual_active_active
pmj = em_coupling0%mutual_passive_passive
pfc = em_coupling0%mutual_passive_active

i=size(pf_active0%coil%resistance)
print *,'pf_active0%coil%resistance',i

print *,pf_active0%coil(1:nact)%resistance

i=size(pf_passive0%loop%resistance)
print *,'pf_passive0%loop%resistance',i
print *,pf_passive0%loop(1:nact)%resistance

write(*,100) shape(pf_active0%coil%resistance),shape(pf_passive0%loop%resistance)


pfres(1:nact) = pf_active0%coil(1:nact)%resistance
rcam(1:npass) = pf_passive0%loop(1:npass)%resistance


xu(1:ke)=equilibrium0%time_slice(1)%coordinate_system%r(1:ke,1)
yu(1:ke)=equilibrium0%time_slice(1)%coordinate_system%z(1:ke,1)

x(1:nr)=equilibrium0%time_slice(1)%coordinate_system%grid%dim1(1:nr) ![m]
y(1:nz)=equilibrium0%time_slice(1)%coordinate_system%grid%dim2(1:nz) ![m]

gridrange(1)=y(1)
gridrange(2)=y(nz)
gridrange(3)=x(1)
gridrange(4)=x(nr)


write(*,*) "End of static data extraction"

call write_cputime(0., 0., 1)

  write(*,*) "pfres(1:3)=",pfres(1:3)
  write(*,*) "rcam(1:3)=",rcam(1:3)
  write(*,*) "limiterxu(1:3)=", xu(1:3)
  write(*,*) "limiteryu(1:3)=", yu(1:3)
  write(*,*) "gridrange=",gridrange

100 format (2I5, 4x,2I5, 4x, 2I5, 4x,2I5)


        kloop=nflux
        kprobe=nbpol


        do i=1,npf
           pf(i) = pf_active0%coil(i)%current%data(1)
        enddo
        do i=1,ncam
           tcam(i) = pf_passive0%loop(i)%current(1)
        enddo
        
write(*,*) "pf0 =", pf        
write(*,*) "tcam0 =", tcam 

     call  dina_v96_in(ncam,npf,kloop,kprobe,&
& 	gridrange,nact,npass,&
&	fluxarr,vesarr, pslgreen,bprgreen,&
&	pfind,pmj,pfc, pfres,rcam,&
&	xu,yu,ke,key,&
&   pfgreen,vesgreen,pfprobe,&
&   vesprobe,ngrid,&
&   pf,tcam)



first_call = first_call+1 ! cancel the initialisation for the next call

else


end if ! end of first_call



loop_count = loop_count + 1 ! number of times the iterative routine was entered

write(*,*) 'dina_imas loop, first_call = ', loop_count, first_call



      n_input1=2
!      n_input2=15
      n_input2=38

do i=1,n_input1
input_1(i)=arr_in1(i)
!print *,' i input_1=',i,input_1(i)
end do
do i=1,n_input2
input_2(i)=arr_in1(n_input1+i)
!print *,' i input_2 arr2=',i,input_2(i),arr_in1(n_input1+i)
end do


!write(*,*) '!!!dina0 enter'
	call dina_0(time_8,tt_8,tay_8,key,vec, &
     &	input_1,input_2,input_3, &
     &	output_1,output_2,output_3,output_4,ng)




!write(*,*) '!!!dina_outp enter'
	call dina_outp(n,  &
     & tpl,uli,v,parea,psi_ax,rmag,zmag,  &
     & q_ax,q_95,rs0,bt0,wen2,tt,  &
     & ai,te0,tq0,pne,tok1,q,  &
     & x,y,psi,psi_bnd,curr_d,  &
     & xbound,ybound,rmajor,rminor,elong,tri, &
     & pd0,pt0,sigk,jbut,aj0,qe0,qq0, &
     & betap,betat,tec,tqc,pec,pic,zeff,vloop,tene,wfus,emag, &
     & vchopper,pf,tcam)

    dina_time=tt
 
    n = 1 ! dummy radial dimension
    write(*,*) 'dina_outp call n tpl tt= ', n,tpl,tt


!write(*,*) "output_1",output_1

      n_output1=15

      do i=1,n_output1
	  arr_out1(i)=output_1(i)
      end do


      n_gaps=6
 

      n_output2=npf+n_gaps+ncam

      do i=1,n_output2
	  arr_out1(n_output1+i)=output_2(i)
      end do


!write(*,*) "-dina inp=",arr_in1(1:n_input1+n_input2)
!write(*,*) "dina out=",arr_out1(1:n_output1+n_output2)
    


	call cpu_time(cpu_new)

	write(*,*) 'CPUTime = ', cpu_new-cpu_old

	call write_cputime(cpu_new-cpu_old, cpu_new, 0)

	cpu_old = cpu_new


! !write(*,*) '!!!ids_copy pf_active0 enter'
! call ids_copy(pf_active0,pf_active)
! !write(*,*) '!!!ids_copy pf_active0 exit'
! !write(*,*) '!!!ids_copy pf_passive0 enter'
! call ids_copy(pf_passive0,pf_passive)
! !write(*,*) '!!!ids_copy pf_passive0 exit'

!re-allocate instead of copy
call ids_deallocate(pf_active)
allocate(pf_active%coil(nact))
call ids_deallocate(pf_passive)
allocate(pf_passive%time(1))
print *,' nact=',nact
do i=1,nact
!         if(associated(pf_active%coil(i)%current%data)) deallocate(pf_active%coil(i)%current%data)
        allocate(pf_active%coil(i)%current%data(1))
!         allocate(pf_active%coil(i)%current%time(1))

!        if(associated(pf_active%coil(i)%voltage%data)) deallocate(pf_active%coil(i)%voltage%data)
        allocate(pf_active%coil(i)%voltage%data(1))
!         allocate(pf_active%coil(i)%voltage%time(1))
enddo
allocate(pf_active%time(1))
allocate(pf_passive%loop(npass))
print *,' npass=',npass  
do i=1,npass
    allocate(pf_passive%loop(i)%current(1))
end do

pf_passive%ids_properties%homogeneous_time = 1
pf_active%ids_properties%homogeneous_time = 1

do i=1,nact

!    pf_active%coil(i)%current%data(1) = output_2(n_gaps+i)
    pf_active%coil(i)%current%data(1) = pf(i)
!    pf_active%coil(i)%current%time(1) = dina_time

!    pf_active%coil(i)%voltage%data(1) = input_2(i)
    pf_active%coil(i)%voltage%data(1) = vchopper(i)
!    pf_active%coil(i)%voltage%time(1) = dina_time

end do

pf_active%time(1) = dina_time

do i=1,npass
!    print *,' i pass=',i
!    pf_passive%loop(i)%current(1) = output_2(n_gaps+npf+i)
    pf_passive%loop(i)%current(1) = tcam(i)
end do

pf_passive%time(1) = dina_time


   
! Work with IDS

    TimeSteps = 1 ! One time step filled for put_slice function
    CurTimeStep = 1


! Allocations summary
allocate(summary%time(TimeSteps))

allocate(summary%global_quantities%ip%value(TimeSteps))
allocate(summary%global_quantities%li%value(TimeSteps))
allocate(summary%global_quantities%beta_pol%value(TimeSteps))
allocate(summary%global_quantities%beta_tor%value(TimeSteps))

allocate(summary%global_quantities%v_loop%value(TimeSteps))
allocate(summary%global_quantities%tau_energy%value(TimeSteps))
allocate(summary%volume_average%n_e%value(TimeSteps))
allocate(summary%volume_average%n_i_total%value(TimeSteps))
allocate(summary%volume_average%t_e%value(TimeSteps))
allocate(summary%volume_average%t_i_average%value(TimeSteps))
allocate(summary%volume_average%zeff%value(TimeSteps))
allocate(summary%global_quantities%energy_thermal%value(TimeSteps))
allocate(summary%global_quantities%energy_b_field_pol%value(TimeSteps))
allocate(summary%fusion%power%value(TimeSteps))
allocate(summary%local%magnetic_axis%position%r(TimeSteps))
allocate(summary%local%magnetic_axis%position%z(TimeSteps))

! Filling summary
summary%ids_properties%homogeneous_time = 1
summary%time(CurTimeStep) = tt;

summary%global_quantities%ip%value(CurTimeStep) = tpl
summary%global_quantities%li%value(CurTimeStep) = uli
summary%global_quantities%beta_pol%value(CurTimeStep) = betap
summary%global_quantities%beta_tor%value(CurTimeStep) = betat

summary%global_quantities%v_loop%value(CurTimeStep) = vloop
summary%global_quantities%tau_energy%value(CurTimeStep) = tene
summary%volume_average%n_e%value(CurTimeStep) = pec
summary%volume_average%n_i_total%value(CurTimeStep) = pic
summary%volume_average%t_e%value(CurTimeStep) = tec
summary%volume_average%t_i_average%value(CurTimeStep) = tqc
summary%volume_average%zeff%value(CurTimeStep) = zeff
summary%global_quantities%energy_thermal%value(CurTimeStep) = wen2
summary%global_quantities%energy_b_field_pol%value(CurTimeStep) = emag
summary%fusion%power%value(CurTimeStep) = wfus
summary%local%magnetic_axis%position%r(CurTimeStep) = rmag
summary%local%magnetic_axis%position%z(CurTimeStep) = zmag



! Allocations equilibrium

    allocate(equilibrium%time_slice(TimeSteps))
    allocate(equilibrium%time(TimeSteps))
  
    
    n1 = nz
    n2 = nr

    !allocate(equilibrium%time_slice(CurTimeStep)%coordinate_system%grid%dim1(nr))
    !allocate(equilibrium%time_slice(CurTimeStep)%coordinate_system%grid%dim2(nz))
    allocate(equilibrium%time_slice(CurTimeStep)%coordinate_system%r(ke,1))
    allocate(equilibrium%time_slice(CurTimeStep)%coordinate_system%z(ke,1))


    allocate(equilibrium%time_slice(CurTimeStep)%profiles_1d%rho_tor_norm(n))
    allocate(equilibrium%time_slice(CurTimeStep)%profiles_1d%surface(n))
    allocate(equilibrium%time_slice(CurTimeStep)%boundary%outline%r(ntet))
    allocate(equilibrium%time_slice(CurTimeStep)%boundary%outline%z(ntet))
    allocate(equilibrium%time_slice(CurTimeStep)%boundary%lcfs%r(ntet))
    allocate(equilibrium%time_slice(CurTimeStep)%boundary%lcfs%z(ntet))


    allocate(equilibrium%time_slice(CurTimeStep)%profiles_2d(1))
    allocate(equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%psi(nz,nr))
    allocate(equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%j_tor(nz,nr))
    
    allocate(equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%grid%dim1(nz))
    allocate(equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%grid%dim2(nr))
    
    
    allocate(equilibrium%vacuum_toroidal_field%b0(TimeSteps))
  
! Filling equilibrium 

    equilibrium%ids_properties%homogeneous_time = 1
    equilibrium%time_slice(CurTimeStep)%profiles_1d%rho_tor_norm(1:n) = ai(1:n)
    
    
    equilibrium%time_slice(CurTimeStep)%global_quantities%ip = tpl ![A]
	equilibrium%time_slice(CurTimeStep)%global_quantities%li_3 = uli
	equilibrium%time_slice(CurTimeStep)%global_quantities%volume = v ![m3]
	equilibrium%time_slice(CurTimeStep)%global_quantities%area = parea ![m2]
	equilibrium%time_slice(CurTimeStep)%global_quantities%psi_axis= psi_ax ![Wb]
	equilibrium%time_slice(CurTimeStep)%global_quantities%psi_boundary = psi_bnd ![Wb]
	equilibrium%time_slice(CurTimeStep)%global_quantities%magnetic_axis%r = rmag ![m]
	equilibrium%time_slice(CurTimeStep)%global_quantities%magnetic_axis%z = zmag ![m]
	equilibrium%time_slice(CurTimeStep)%global_quantities%q_axis = q_ax
	equilibrium%time_slice(CurTimeStep)%global_quantities%q_95 = q_95
	equilibrium%time_slice(CurTimeStep)%global_quantities%w_mhd = wen2 ![J]

        equilibrium%time_slice(CurTimeStep)%boundary%geometric_axis%r = rmajor
        equilibrium%time_slice(CurTimeStep)%boundary%minor_radius = rminor
        equilibrium%time_slice(CurTimeStep)%boundary%elongation = elong
        equilibrium%time_slice(CurTimeStep)%boundary%triangularity = tri

        equilibrium%time_slice(CurTimeStep)%global_quantities%surface = ysbound_xx
        equilibrium%time_slice(CurTimeStep)%profiles_1d%surface(n) = ysbound_xx

	equilibrium%vacuum_toroidal_field%r0 = rs0 ![m]
	equilibrium%vacuum_toroidal_field%b0(CurTimeStep) = bt0 ![T]
    
    equilibrium%time_slice(CurTimeStep)%boundary%outline%r(1:ntet) = xbound(1:ntet)
    equilibrium%time_slice(CurTimeStep)%boundary%outline%z(1:ntet) = ybound(1:ntet)
    equilibrium%time_slice(CurTimeStep)%boundary%lcfs%r(1:ntet) = xbound(1:ntet)
    equilibrium%time_slice(CurTimeStep)%boundary%lcfs%z(1:ntet) = ybound(1:ntet)

    !equilibrium%time_slice(CurTimeStep)%coordinate_system%grid%dim1(1:n1)=x(1:n1) ![m]
    !equilibrium%time_slice(CurTimeStep)%coordinate_system%grid%dim2(1:n2)=y(1:n2) ![m]

    equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%grid%dim1(1:nz)=y(1:nz)
    equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%grid%dim2(1:nr)=x(1:nr)


    do i=1,nz
    do j=1,nr
      equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%psi(i,j)=psi(j,i)
      equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%j_tor(i,j)=curr_d(j,i)
    enddo
    enddo
    

    do i=1,nz
    do j=1,nr
      psi1(j,i) = equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%psi(i,j)
    enddo
    enddo

    equilibrium%time_slice(CurTimeStep)%coordinate_system%r(1:ke,1) = xu(1:ke)
    equilibrium%time_slice(CurTimeStep)%coordinate_system%z(1:ke,1) = yu(1:ke)


    equilibrium%time_slice(CurTimeStep)%time = tt
    equilibrium%time(CurTimeStep) = tt ![s]
    
! Allocations core_profiles    

! call ids_copy(core_profiles0,core_profiles)

!write(*,*) 'Allocate core_profiles... '

    allocate(core_profiles%profiles_1d(TimeSteps))
    allocate(core_profiles%time(TimeSteps))

    allocate(core_profiles%profiles_1d(CurTimeStep)%grid%rho_tor_norm(n))

    allocate(core_profiles%profiles_1d(CurTimeStep)%j_tor(n))
    allocate(core_profiles%profiles_1d(CurTimeStep)%q(n))
 

! Filling core_profiles  

    core_profiles%ids_properties%homogeneous_time = 1
    
    
    core_profiles%profiles_1d(CurTimeStep)%grid%rho_tor_norm(1:n) = ai(1:n)

	
	core_profiles%profiles_1d(CurTimeStep)%j_tor(1:n) = tok1(1:n) ![A/m2]
	core_profiles%profiles_1d(CurTimeStep)%q(1:n) = q(1:n)


    
    core_profiles%profiles_1d(CurTimeStep)%time = tt
    core_profiles%time(CurTimeStep) = tt ![s]


!write(*,*) 'Write core_profiles transp... '
! Transp1
allocate(core_profiles%profiles_1d(CurTimeStep)%electrons%temperature(n))
allocate(core_profiles%profiles_1d(CurTimeStep)%t_i_average(n))
 core_profiles%profiles_1d(CurTimeStep)%electrons%temperature(1:n) = te0(1:n)
 core_profiles%profiles_1d(CurTimeStep)%t_i_average(1:n) = tq0(1:n)

!Transp2
!Electrons
allocate(core_profiles%profiles_1d(1)%electrons%density(n))
 core_profiles%profiles_1d(1)%electrons%density(1:n) = pne(1:n)*1.d19

!if (.not. allocated(core_profiles%profiles_1d(1)%ion)) then
   allocate(core_profiles%profiles_1d(1)%ion(2))
!end if

! Deuterium
allocate(core_profiles%profiles_1d(1)%ion(1)%element(1))
 core_profiles%profiles_1d(1)%ion(1)%element(1)%a = 2
 core_profiles%profiles_1d(1)%ion(1)%z_ion = 1
 core_profiles%profiles_1d(1)%ion(1)%element(1)%z_n = 1
!core_profiles%profiles_1d(1)%ion(1)%label = 'D+'
! if (.not. allocated(core_profiles%profiles_1d(1)%ion(1)%n_i)) then
allocate(core_profiles%profiles_1d(1)%ion(1)%density(n))
! end if
 core_profiles%profiles_1d(1)%ion(1)%density(1:n) = pd0(1:n)*1.d19

! Tritium
allocate(core_profiles%profiles_1d(1)%ion(2)%element(1))
 core_profiles%profiles_1d(1)%ion(2)%element(1)%a = 3
 core_profiles%profiles_1d(1)%ion(2)%z_ion = 1
 core_profiles%profiles_1d(1)%ion(2)%element(1)%z_n = 1
!core_profiles%profiles_1d(1)%ion(2)%label = 'T+'
allocate(core_profiles%profiles_1d(1)%ion(2)%density(n))
 core_profiles%profiles_1d(1)%ion(2)%density(1:n) = pt0(1:n)*1.d19

!Transp3
allocate(core_profiles%profiles_1d(1)%j_bootstrap(n))
allocate(core_profiles%profiles_1d(1)%conductivity_parallel(n))
 core_profiles%profiles_1d(1)%j_bootstrap(1:n) = jbut(1:n)*1.d7
 core_profiles%profiles_1d(1)%conductivity_parallel(1:n) = sigk(1:n)

!      apr='tok1++' 
!      print 71,apr,(tok1(i),i=1,n) 
!      apr='j_cd++' 
!      print 71,apr,(aj0(i),i=1,n) 
!      apr='j_boot++' 
!      print 71,apr,(jbut(i),i=1,n) 
!      apr='tok1++' 
!      print 71,apr,(core_profiles%profiles_1d(CurTimeStep)%j_tor(i),i=1,n) 


!      apr='sigk++' 
!      print 71,apr,(core_profiles%profiles_1d(1)%conductivity_parallel(i),i=1,n) 


!Transp4
allocate(core_profiles%profiles_1d(1)%j_non_inductive(n))
 core_profiles%profiles_1d(1)%j_non_inductive(1:n) = aj0(1:n)*1.d7 + core_profiles%profiles_1d(1)%j_bootstrap(1:n)

!      apr='j_cd++' 
!      print 71,apr,(core_profiles%profiles_1d(1)%j_non_inductive(i),i=1,n) 
!      apr='j_boot++' 
!      print 71,apr,(core_profiles%profiles_1d(1)%j_bootstrap(i),i=1,n) 

!Sources


!write(*,*) 'Allocate core_sources... '
allocate(core_sources%source(1))
    allocate(core_sources%source(1)%profiles_1d(TimeSteps))
    allocate(core_sources%time(TimeSteps))

    allocate(core_sources%source(1)%profiles_1d(CurTimeStep)%grid%rho_tor_norm(n))


    core_sources%ids_properties%homogeneous_time = 1
    
    
    core_sources%source(1)%profiles_1d(CurTimeStep)%grid%rho_tor_norm(1:n) = ai(1:n)

    
    core_sources%source(1)%profiles_1d(CurTimeStep)%time = tt
    core_sources%time(CurTimeStep) = tt ![s]

!write(*,*) 'Write core_sources...'

allocate(core_sources%source(1)%profiles_1d(CurTimeStep)%electrons%energy(n))
allocate(core_sources%source(1)%profiles_1d(CurTimeStep)%total_ion_energy(n))
 core_sources%source(1)%profiles_1d(CurTimeStep)%electrons%energy(1:n) = qe0(1:n)
 core_sources%source(1)%profiles_1d(CurTimeStep)%total_ion_energy(1:n) = qq0(1:n)


!SOLPS
!write(*,*) 'Allocate core_transport... '
allocate(core_transport%model(1))
    allocate(core_transport%model(1)%profiles_1d(TimeSteps))
    allocate(core_transport%time(TimeSteps))

    allocate(core_transport%model(1)%profiles_1d(CurTimeStep)%grid_d%rho_tor_norm(n))
    
allocate(core_transport%model(1)%profiles_1d(CurTimeStep)%ion(2))


    core_transport%ids_properties%homogeneous_time = 1
    
    
    core_transport%model(1)%profiles_1d(CurTimeStep)%grid_d%rho_tor_norm(1:n) = ai(1:n)

    
    core_transport%model(1)%profiles_1d(CurTimeStep)%time = tt
    core_transport%time(CurTimeStep) = tt ![s]




!write(*,*) 'Write core_transport... '
allocate(core_transport%model(1)%profiles_1d(CurTimeStep)%electrons%energy%flux(n))
allocate(core_transport%model(1)%profiles_1d(CurTimeStep)%total_ion_energy%flux(n))
 core_transport%model(1)%profiles_1d(CurTimeStep)%electrons%energy%flux(1:n-1) = 0.d0
 core_transport%model(1)%profiles_1d(CurTimeStep)%electrons%energy%flux(n) = & 
 & yfluxe_xx/ysbound_xx*1.d6
 
 core_transport%model(1)%profiles_1d(CurTimeStep)%total_ion_energy%flux(1:n-1) = 0.d0
 core_transport%model(1)%profiles_1d(CurTimeStep)%total_ion_energy%flux(n) = &
 & yfluxi_xx/ysbound_xx*1.d6


! Deuterium
allocate(core_transport%model(1)%profiles_1d(1)%ion(1)%element(1))
 core_transport%model(1)%profiles_1d(1)%ion(1)%element(1)%a = 2
 core_transport%model(1)%profiles_1d(1)%ion(1)%element(1)%z_n = 1

 core_transport%model(1)%profiles_1d(1)%ion(1)%z_ion = 1
!core_transport%model(1)%profiles_1d(1)%ion(1)%label = 'D+'
! if (.not. allocated(core_transport%model(1)%profiles_1d(1)%ion(1)%n_i)) then
allocate(core_transport%model(1)%profiles_1d(CurTimeStep)%ion(1)%particles%flux(n))
! end if
 core_transport%model(1)%profiles_1d(CurTimeStep)%ion(1)%particles%flux(1:n-1) = 0.d0
 core_transport%model(1)%profiles_1d(CurTimeStep)%ion(1)%particles%flux(n) = &
 & yfluxd_xx/ysbound_xx*1.d19


! Tritium
allocate(core_transport%model(1)%profiles_1d(1)%ion(2)%element(1))
 core_transport%model(1)%profiles_1d(1)%ion(2)%element(1)%a = 3
 core_transport%model(1)%profiles_1d(1)%ion(2)%element(1)%z_n = 1

 core_transport%model(1)%profiles_1d(1)%ion(2)%z_ion = 1
!core_transport%model(1)%profiles_1d(1)%ion(2)%label = 'T+'
! if (.not. allocated(core_transport%model(1)%profiles_1d(1)%ion(2)%n_i)) then
allocate(core_transport%model(1)%profiles_1d(CurTimeStep)%ion(2)%particles%flux(n))
! end if
 core_transport%model(1)%profiles_1d(CurTimeStep)%ion(2)%particles%flux(1:n-1) = 0.d0
 core_transport%model(1)%profiles_1d(CurTimeStep)%ion(2)%particles%flux(n) = &
 & yfluxt_xx/ysbound_xx*1.d19
    
    
  !  write(*,*) "psi = ", (equilibrium%profiles_2d(1)%psi(i,1:n2,CurTimeStep),i=1,n1)



    

return
end subroutine



	subroutine write_graf_imas(nr,nz,ke,&
     &	dx,dy,ttt,&
     &  psi,x,y,xu,yu,&
     &  pmag,pbound,p_s,um,vm) 

        integer :: nr,nz,ke
	real*8,dimension(:,:) :: psi(nr,nz)
	real*8,dimension(:) :: x(nr),y(nz),xu(ke),yu(ke)

	real(8) :: dx,dy,ttt,pmag,pbound,p_s,um,vm
	

5000	format(4(1x,1pe14.7))
	
	write(*,*) 'Write Graph Enter...'

	open (unit=61,file='psi_data_imas',access='append',form='formatted')



           write (61,*)ke,1,1,1,1

           write (61,5000)0.d0
           write (61,5000)0.d0
           write (61,5000)(xu(i),i=1,ke)
           write (61,5000)(yu(i),i=1,ke)
   
           write (61,5000)dx,dy,pmag,pbound,p_s,um,vm,ttt
           
           write (61,5000)((psi(i,j),i=1,nr),j=1,nz)
           write (61,5000)(x(i),i=1,nr)
           write (61,5000)(y(i),i=1,nz)
           write (61,5000)0.d0
           write (61,5000)0.d0
           write (61,5000)0.d0
           write (61,5000)0.d0




           close (61)

        
        
	return
	end

	subroutine write_graf_imas0(nr,nz,ke,&
     &	dx,dy,ttt,&
     &  psi,x,y,xu,yu,&
     &  pmag,pbound,p_s,um,vm) 

        integer :: nr,nz,ke
	real*8,dimension(:,:) :: psi(nr,nz)
	real*8,dimension(:) :: x(nr),y(nz),xu(ke),yu(ke)

	real(8) :: dx,dy,ttt,pmag,pbound,p_s,um,vm
	

5000	format(4(1x,1pe14.7))
	
	write(*,*) 'Write Graph Enter0...'

	open (unit=61,file='psi_data_imas0',access='append',form='formatted')



           write (61,*)ke,1,1,1,1

           write (61,5000)0.d0
           write (61,5000)0.d0
           write (61,5000)(xu(i),i=1,ke)
           write (61,5000)(yu(i),i=1,ke)
   
           write (61,5000)dx,dy,pmag,pbound,p_s,um,vm,ttt
           
           write (61,5000)((psi(i,j),i=1,nr),j=1,nz)
           write (61,5000)(x(i),i=1,nr)
           write (61,5000)(y(i),i=1,nz)
           write (61,5000)0.d0
           write (61,5000)0.d0
           write (61,5000)0.d0
           write (61,5000)0.d0




           close (61)

        
        
	return
	end


	subroutine write_cputime(deltatime, time, flag_start)

	real(8) :: deltatime, time
	integer :: flag_start

6000	format(4(1x,1pe14.7))
	
	write(*,*) 'Write CPU time...'

	if (flag_start.eq.1) call system("rm cputime_dinaimas")

	open (unit=62,file='cputime_dinaimas',access='append',form='formatted')

	if (flag_start.eq.1) then
		write(62,*) "     Step    ","     Absolute"
	else
		write (62,6000) deltatime, time
	end if

        close (62)

        
        
	return
	end


subroutine schedulefiles(schedule,equil)
use ids_schemas
use ids_routines
implicit none
type (ids_equilibrium) :: equil
type (ids_pulse_schedule) :: schedule
integer :: i,nt,io
real(8) :: t, v, u

integer :: n1,n2,n3,n4,n5,n6,n7,n8
real(8) :: x1,x2,x3,x4,x5,x6,x7,x8

7000	format(4(1x,1pe14.7))


open(unit=44,file='ech.dat',action='write',access='sequential')
nt=size(schedule%ec%launcher(1)%power%reference%time)
write(44,*) 'Time points'
write(44,*) nt
write(44,*) 'Time  Power'
do i=1,nt
t = schedule%ec%launcher(1)%power%reference%time(i)
v = schedule%ec%launcher(1)%power%reference%data(i)*1.d-6
write(44,*) t, v
enddo
close(44)


open(unit=44,file='emo.dat',action='write',access='sequential')
nt=size(schedule%ec%launcher(2)%power%reference%time)
write(44,*) 'Time points'
write(44,*) nt
write(44,*) 'Time  Power'
do i=1,nt
t = schedule%ec%launcher(2)%power%reference%time(i)
v = schedule%ec%launcher(2)%power%reference%data(i)*1.d-6
u = schedule%ec%launcher(3)%power%reference%data(i)*1.d-6
write(44,*) t, v, u
enddo
close(44)


open(unit=44,file='dens.dat',action='write',access='sequential')
nt=size(schedule%density_control%valve(1)%flow_rate%reference%time)
write(44,*) 'Time points'
write(44,*) nt
write(44,*) 'Time  Density'
do i=1,nt
t = schedule%density_control%valve(1)%flow_rate%reference%time(i)
v = schedule%density_control%valve(1)%flow_rate%reference%data(i)
write(44,*) t, v
enddo
close(44)


open(unit=44,file='n_d.dat',action='write',access='sequential')
nt=size(schedule%density_control%valve(7)%flow_rate%reference%time)
write(44,*) 'Time_points  t_bar'
write(44,*) nt, 0.003
write(44,*) 'Time  Density'
do i=1,nt
t = schedule%density_control%valve(7)%flow_rate%reference%time(i)
v = schedule%density_control%valve(7)%flow_rate%reference%data(i)
write(44,*) t, v
enddo
close(44)


open(unit=44,file='gamma_z.dat',action='write',access='sequential')
nt=size(schedule%density_control%valve(2)%flow_rate%reference%time)
write(44,*) 'Time_points  t_bar'
write(44,*) nt, 0.003
write(44,*) 'Time  Density'
do i=1,nt
t = schedule%density_control%valve(2)%flow_rate%reference%time(i)
v = schedule%density_control%valve(2)%flow_rate%reference%data(i)
write(44,*) t, v
enddo
close(44)


open(unit=44,file='gamma_z1.dat',action='write',access='sequential')
nt=size(schedule%density_control%valve(3)%flow_rate%reference%time)
write(44,*) 'Time_points  t_bar'
write(44,*) nt, 0.003
write(44,*) 'Time  Density'
do i=1,nt
t = schedule%density_control%valve(3)%flow_rate%reference%time(i)
v = schedule%density_control%valve(3)%flow_rate%reference%data(i)
write(44,*) t, v
enddo
close(44)


open(unit=44,file='gamma_z2.dat',action='write',access='sequential')
nt=size(schedule%density_control%valve(4)%flow_rate%reference%time)
write(44,*) 'Time_points  t_bar'
write(44,*) nt, 0.003
write(44,*) 'Time  Density'
do i=1,nt
t = schedule%density_control%valve(4)%flow_rate%reference%time(i)
v = schedule%density_control%valve(4)%flow_rate%reference%data(i)
write(44,*) t, v
enddo
close(44)


open(unit=44,file='gamma_z3.dat',action='write',access='sequential')
nt=size(schedule%density_control%valve(5)%flow_rate%reference%time)
write(44,*) 'Time_points  t_bar'
write(44,*) nt, 0.003
write(44,*) 'Time  Density'
do i=1,nt
t = schedule%density_control%valve(5)%flow_rate%reference%time(i)
v = schedule%density_control%valve(5)%flow_rate%reference%data(i)
write(44,*) t, v
enddo
close(44)


open(unit=44,file='gamma_z4.dat',action='write',access='sequential')
nt=size(schedule%density_control%valve(6)%flow_rate%reference%time)
write(44,*) 'Time_points  t_bar'
write(44,*) nt, 0.003
write(44,*) 'Time  Density'
do i=1,nt
t = schedule%density_control%valve(6)%flow_rate%reference%time(i)
v = schedule%density_control%valve(6)%flow_rate%reference%data(i)
write(44,*) t, v
enddo
close(44)



v = equil%vacuum_toroidal_field%r0*1.d2 !meters to sm
u = equil%vacuum_toroidal_field%b0(1)*1.d1 !Tesla to kG

     	open(unit=44,file='for002_tmp',action='write',access='sequential')

	open(unit=2,file='for002',form='formatted',action='read')
        print *,' begin for002 reading'

	read (2,*) ; write(44,*) 'nrad(24)       mplasma    next(15)'
	read (2,*)n1,n2,n3 ; write(44,*) n1,n2,n3
	read (2,*) ; write(44,*) 'tt(2500.)    tay        t_end(900.)      RS0       psend'
	read (2,*)x1,x2,x3,x4,x5 ; write(44,*) x1,x2,x3,v,x5 !x4 is R for toroidal field
	read (2,*) ; write (44,*) 'i_graph'
	read (2,*)n1 ; write (44,*) n1
	read (2,*) ; write (44,*) 'ALFA0      BETA (0.01)     alfa1 (-1.3)  omega(0.33)'
	read (2,*)x1,x2,x3,x4 ; write(44,*) x1,x2,x3,x4
	read (2,*) ; write (44,*) 'iread      kzero      IWRITE     kEFIT'
	read (2,*)n1,n2,n3,n4 ; write(44,*) n1,n2,n3,n4
	read (2,*) ; write (44,*) 'alfax1     alfax2     betax1     betax2'
	read (2,*)x1,x2,x3,x4 ; write(44,*) x1,x2,x3,x4
	read (2,*) ; write (44,*) 'pw_1       pw_2'
	read (2,*)x1,x2 ; write(44,*) x1,x2
	read (2,*) ; write (44,*) 'te_a       ti_a       te_b      ti_b    pw_e'
	read (2,*)x1,x2,x3,x4,x5 ; write(44,*) x1,x2,x3,x4,x5
	read (2,*) ; write (44,*) 'pd0_a      pt0_a      pd0_b     pt0_b   pw_p'
	read (2,*)x1,x2,x3,x4,x5 ; write(44,*) x1,x2,x3,x4,x5
	read (2,*) ; write (44,*) 'zeff_a    zeff_b'
	read (2,*)x1,x2 ; write(44,*) x1,x2
	read (2,*) ; write (44,*) 'SIG0'
	read (2,*)x1 ; write(44,*) x1
	read (2,*) ; write (44,*) 'zhib,tego,zalfa,talfa,alp1'
	read (2,*)x1,x2,x3,x4,x5 ; write(44,*) x1,x2,x3,x4,x5
	read (2,*) ; write (44,*) 'ktp,kpin,ken,ken1,ken2,kd2,nal'
	read (2,*)n1,n2,n3,n4,n5,n6,n7 ; write(44,*) n1,n2,n3,n4,n5,n6,n7
	read (2,*) ; write (44,*) 'alpy,   ppp,    eee,    dd,     dt,     dh,     df'
	read (2,*)x1,x2,x3,x4,x5,x6,x7 ; write(44,*) x1,x2,x3,x4,x5,x6,x7
	read (2,*) ; write (44,*) 'lt,     ld,   lh,   ll, lm, it, id, ih'
	read (2,*)n1,n2,n3,n4,n5,n6,n7,n8 ; write(44,*) n1,n2,n3,n4,n5,n6,n7,n8
	read (2,*) ; write (44,*) 'eps0,eps1,eps2'
	read (2,*)x1,x2,x3 ; write(44,*) x1,x2,x3
	read (2,*) ; write (44,*) 'anom_e,anom_i,key_t11,kcchp'
	read (2,*)x1,x2,n1,n2 ; write(44,*) x1,x2,n1,n2
	read (2,*) ; write (44,*) 'edope   edopi'
	read (2,*)x1,x2 ; write(44,*) x1,x2
	read (2,*) ; write (44,*) 'udd'
	read (2,*)x1 ; write(44,*) x1
	read (2,*) ; write (44,*) 'k_ener    k_uv'
	read (2,*)n1,n2 ; write(44,*) n1,n2
	read (2,*) ; write (44,*) 't_dop'
	read (2,*)x1 ; write(44,*) x1
	read (2,*) ; write (44,*) 'r0,z0,zref'
	read (2,*)x1,x2,x3 ; write(44,*) x1,x2,x3
	read (2,*) ; write (44,*) 'kzref    krref(2)   key_b  i_pf'
	read (2,*)n1,n2,n3,n4 ; write(44,*) n1,n2,n3,n4
	read (2,*) ; write (44,*) 'i_c'
	read (2,*)n1 ; write(44,*) n1
	read (2,*) ; write (44,*) 'q_vde'
	read (2,*)x1 ; write(44,*) x1
	read (2,*) ; write (44,*) 'tay_00,tay_th,t_disr'
	read (2,*)x1,x2,x3 ; write(44,*) x1,x2,x3
	read (2,*) ; write (44,*) 'd_tpl,tpl_end'
	read (2,*)x1,x2 ; write(44,*) x1,x2
	read (2,*) ; write (44,*) 'c_h,d_halo'
	read (2,*)x1,x2 ; write(44,*) x1,x2
	read (2,*) ; write (44,*) 'kmaj,li_drop,ndisrup,n_dif,nmix'
	read (2,*)n1,n2,n3,n4,n5 ; write(44,*) n1,n2,n3,n4,n5
	read (2,*) ; write (44,*) 'hpart,te_h'
	read (2,*)x1,x2 ; write(44,*) x1,x2
	read (2,*) ; write (44,*) 'i_d3d,i_iter,i_smal'
	read (2,*)n1,n2,n3 ; write(44,*) n1,n2,n3
	read (2,*) ; write (44,*) 'ngra,i_ramp,i_v,i_con'
	read (2,*)n1,n2,n3,n4 ; write(44,*) n1,n2,n3,n4
	read (2,*) ; write (44,*) 'tpl     bt0    eu(200 or 50)  elong'
	read (2,*)x1,x2,x3,x4 ; write(44,*) x1,u,x3,x4 !x2 is toroidal field
	read (2,*) ; write (44,*) 'e_sep'
	read (2,*)x1 ; write(44,*) x1
	read (2,*) ; write (44,*) 'i_beta,i_gap5'
	read (2,*)n1,n2 ; write(44,*) n1,n2
	read (2,*) ; write (44,*) 'i_br'
	read (2,*)n1 ; write(44,*) n1
	read (2,*) ; write (44,*) 'ind_r1  ind_r2  ind_z1   ind_z2'
	read (2,*)n1,n2,n3,n4 ; write(44,*) n1,n2,n3,n4
	read (2,*) ; write (44,*) 'key_ef'
	read (2,*)n1 ; write(44,*) n1
	read (2,*) ; write (44,*) 'res_coef'
	read (2,*)x1 ; write(44,*) x1
	read (2,*) ; write (44,*) 'n_polar'
	read (2,*)n1 ; write(44,*) n1

io = 0
do 
	read (2,*,iostat=io)
	if (io.eq.0) then
		write(44,*)
	else
		exit
	endif
enddo
	close(2)

	close(44)

call system("cp for002_tmp for002")
call system("rm for002_tmp")


return
end
