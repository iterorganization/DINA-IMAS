!> dina_step is the main subroutine to cann DINA and connect input-output data with IMAS IDS
!> As a result of call dina_v96_in the Green Functions are being transmitted to DINA from IDSs
!> After call dina_input the initial kinetic profiles are being transmitted to DINA from IDSs   
!> As a result of call dina_0 and then call dina2 the DINA modeling in one time step is being produced
!> After call dina_outp the output data are being recorded to IDS and dat files

! If needed to get the compiler:
!#ifdef __GFORTRAN__
!#ifdef __INTEL_COMPILER

#define AllocIfNull(array, size)  if (.NOT.associated(array)) allocate(array(size))

#define AllocIfNull1(array, value)  if (.NOT.associated(array)) allocate(array(1)) ; \
                                    array(1) = value

#define AllocArr(array, value, size)  if (.NOT.associated(array)) allocate(array(size)) ; \
                                    array(1:size) = value(1:size)


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

#define FillCodeParametersDINA(ids) FillCodeParameters(ids, error_flag, codeparam%parameters_value, 'dina_step', 'DINA simulates consistent evolution of non-linear 2D equilibrium, currents in the conducting structures and 1D kinetic profiles.')


 
module dina_imas

integer :: code_state

contains


subroutine dina_step(&
  &  em_coupling0, equilibrium0, magnetics0, pf_active0, pf_passive0, wall0, core_profiles0, core_sources0 &
  & ,bndcond_in &
  & ,pulse_schedule &
  & ,equilibrium, magnetics, pf_active, pf_passive, core_profiles, core_sources, core_transport &
  & ,summary &
  & ,codeparam,error_flag,error_message)
  


use ids_schemas
use ids_routines
!implicit none
include 'double.inc'

 type(ids_parameters_input) :: codeparam
 integer, intent(out) :: error_flag
 character(len=:), pointer, intent(out) :: error_message
 

type (ids_em_coupling), INTENT(IN)  :: em_coupling0
type (ids_equilibrium), INTENT(IN) :: equilibrium0
type (ids_magnetics), INTENT(IN)   :: magnetics0
type (ids_pf_active), INTENT(IN)   :: pf_active0
type (ids_pf_passive), INTENT(IN)   :: pf_passive0
type (ids_wall), INTENT(IN) :: wall0
type (ids_core_profiles), INTENT(IN)   :: core_profiles0
type (ids_core_sources), INTENT(IN)   :: core_sources0
type (ids_transport_solver_numerics), INTENT(IN) :: bndcond_in
type (ids_pulse_schedule), INTENT(IN)   :: pulse_schedule


type (ids_equilibrium), INTENT(OUT) :: equilibrium
type (ids_magnetics), INTENT(OUT)   :: magnetics
type (ids_pf_active), INTENT(OUT)   :: pf_active
type (ids_pf_passive), INTENT(OUT)   :: pf_passive
type (ids_core_profiles), INTENT(OUT)   :: core_profiles
type (ids_core_transport), INTENT(OUT)   :: core_transport
type (ids_core_sources), INTENT(OUT)   :: core_sources
type (ids_summary), INTENT(OUT) :: summary



! define local fixed size variables
integer :: i, j, k, isrc, ion
integer,save :: loop_count = 0


include 'parf0'
include 'parf1'
include 'parf2'
include 'parf4'
include 'parf8'


integer :: npfa = 0, npfp = 0

integer,parameter :: n_ions=7
integer :: n_ions_in = 2

integer :: ksepa,key_lh,n_bnd,n_sep,n_sep2,n_gaps

integer,save :: npfa2=-1, npfa3=-1, npfp2=-1
integer,save :: npass2=-1, ngrid2=-1
integer,save :: kloop=-1,kprobe=-1, ke=-1

          
integer ::  kpr, i_grid
      common /ge5/kpr


integer   ::  ih_imas
     common /c_imas_is/ih_imas
integer   ::  ih_imas_c
     common /c_k_jetto/ih_imas_c


real(ids_real) ::time_eq
     common /c_imas_time_eq/time_eq
real(ids_real) ::time_eq_c
      common /c_time_eq/time_eq_c


    
real(ids_real) :: tpl = 1000.d0, tt = 0.d0
real(ids_real) :: psi_ax,psi_bnd,psi_sep,psi_sep2,psi_ext
real(ids_real) :: rs0 = 1.d0, bt0 = 1.d0
real(ids_real) :: betap = 0.d0, betat = 0.d0, betan = 0.d0
real(ids_real) :: tene, teit_98
real(ids_real) :: pec
real(ids_real) :: rmag = 1.d0, zmag = 0.d0
real(ids_real) :: b_field_ax = 1.d0
real(ids_real) :: tokc = 0.d0

real(ids_real) :: x(nr),y(nz),psi(nr,nz),psi1(nr,nz),curr_d(nr,nz)

real(ids_real) :: a(npo),ai(npo),psi_tr(npo),psi_eq(npo),phi_1D(npo),tok1(npo),q(npo)
real(ids_real) :: a_tr(npo)
real(ids_real) :: a_xx(npo),ai_xx(npo)

real(ids_real) :: pd0(npo),pt0(npo),pne(npo),te0(npo),tq0(npo),press(npo),qe0(npo),qq0(npo)
real(ids_real) :: sigma(npo),jbut(npo),aj0(npo),ajae(npo),zeff(npo)

real(ids_real) :: xbound(ntet),ybound(ntet),x_sep(mu1),y_sep(mu1),x_sep2(mu1),y_sep2(mu1)
real(ids_real) :: gaps(kf_c)

real(ids_real) :: vchopper(kf),pf(kf),tcam(mu)

real(ids_real) :: fpol(npo),pptab(npo),fptab(npo)

real(ids_real) :: wr_imas(150)

real(ids_real) :: bprobe(nprobe), psloop(nloop)

real(ids_real) :: surface_1d(npo),volume_1d(npo),area_1d(npo)


integer :: TimeSteps = 1, CurTimeStep = 1

integer,save :: n1, n2, nu, n, n_eq, n_tr, i_wr

integer,save :: i_bnd, i_restart

real(ids_real), save ::  gridrange(4)
real(ids_real), dimension(:,:), ALLOCATABLE,save :: fluxarr,vesarr,pslgreen,bprgreen,pfind,pmj
real(ids_real), dimension(:,:), ALLOCATABLE,save :: pfc,pfgreen,vesgreen,pfprobe,vesprobe
real(ids_real), dimension(:), ALLOCATABLE,save :: pfres, rcam, xu, yu
real(ids_real), dimension(:), allocatable,save::  pf_turns

real(ids_real),save :: cpu_old = 0.d0, cpu_new

real(ids_real) :: yfluxd_xx,yfluxt_xx,yfluxe_xx,yfluxi_xx,ysbound_xx
 
character *20 apr
	
real(ids_real) :: cocos_psi = -1.d0

common /pf1/npf,pf_xx(kf),pf0_xx(kf)
common /pf_circuit/ ncirc, dircirc
integer :: ncirc(kf), dircirc(kf)

integer :: nact = -1
! ! ITER
! integer :: nact = 12
! data ncirc(1:14) /1, 2, 3, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 12/
! data dircirc(1:14) /1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1/

! !MAST-U
! integer :: nact = 25
! data ncirc(1:25) /1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25/
! data dircirc(1:25) /1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1/


real(ids_real) :: x1, y1, x2, y2, dst, dst1, dst2
integer, dimension(:), allocatable :: limunits
integer :: nlim, ju, jdir

print *,'DINA_IMAS Enter'
call system(" pwd")


flush(6)



if (loop_count == 0) then ! convert input trees to local variables before calling dina

call cpu_time(cpu_old)

call system("rm psi_data")
call system("rm psi_data_imas")
call system("rm psi_data_imas2")
call system("rm p_data1")
call system("rm for042")
call system("rm plasma.dat")
call system("rm plasma_start.dat")

call system(" ls -ll for042 ")
call system(" ls -ll psi_data ")
call system(" ls -ll p_data1 ")



if (associated(pf_active0%coil)) then
  npfa=size(pf_active0%coil)
else
  npfa = 0
endif
if (associated(pf_passive0%loop)) then
  npfp = size(pf_passive0%loop)
else
  npfp = 0
end if
if (associated(magnetics0%flux_loop)) then
  kloop = size(magnetics0%flux_loop)
else
  kloop = 0
endif
if (associated(magnetics0%b_field_pol_probe)) then
  kprobe = size(magnetics0%b_field_pol_probe)
else
  kprobe = 0
endif


npfa2=size(em_coupling0%mutual_grid_active,2)
npfp2=size(em_coupling0%mutual_grid_passive,2)
ngrid2=size(em_coupling0%mutual_grid_passive,1)
kloop2=size(em_coupling0%mutual_loops_grid,1)
kprobe2=size(em_coupling0%field_probes_grid,1)



print *,'npfa, npfa2 =', npfa, npfa2
print *,'npfp, npfp2 =', npfp, npfp2

print *,'nloop, kloop =', nloop, kloop
print *,'nprobe, kprobe =', nprobe, kprobe
print *,'nwnh, ngrid2 =', nwnh, ngrid2


if(npfa.ne.npfa2)then
  print*,'npfa.ne.npfa2', npfa, npfa2
  stop
end if
if(npfp.ne.npfp2)then
  print*, 'npfp.ne.npfp2', npfp, npfp2
  stop
end if
if(nwnh.ne.ngrid2)then
  print*, 'nwnh.ne.ngrid2', nwnh, ngrid2
  stop
end if
if(kloop.ne.kloop2)then
  print*, 'kloop.ne.kloop2', kloop, kloop2
  !stop
end if
if(kprobe.ne.kprobe2)then
  print*, 'kprobe.ne.kprobe2', kprobe, kprobe2
  !stop
end if


if(npfp+npfa.gt.mu)then
  print*, 'npfp+npfa.gt.mu', npfp, npfa, mu
  stop
end if
if(kloop.gt.nloop)then
  print*, 'kloop.gt.nloop', kloop, nloop
  stop
end if
if(kprobe.gt.nprobe)then
  print*, 'kprobe.gt.nprobe', kprobe, nprobe
  stop
end if


 call vic_turn()
 call dina_data_read_imas(pulse_schedule, pf_active0, codeparam)


nact = npf


ALLOCATE(fluxarr(nwnh,nact))
ALLOCATE(vesarr(nwnh,npfp))
ALLOCATE(pslgreen(nwnh,kloop))
ALLOCATE(bprgreen(nwnh,kprobe))

ALLOCATE(vesgreen(kloop,npfp))
ALLOCATE(vesprobe(kprobe,npfp))

ALLOCATE(pfgreen(kloop,nact))
ALLOCATE(pfprobe(kprobe,nact))

ALLOCATE(pfind(nact,nact))
ALLOCATE(pmj(npfp,npfp))
ALLOCATE(pfc(npfp,nact))

ALLOCATE(pfres(nact))
ALLOCATE(rcam(npfp))


  print*, 'nact =', nact
  print*, 'ncirc(1:npfa) =', (ncirc(i),i=1,npfa)
  print*, 'dircirc(1:npfa) =', (dircirc(i),i=1,npfa)

write(*,*) 'Entering DINA_IMAS, loop_count, tt = ', loop_count, tt
flush(6)


! Greens

vesgreen(1:kloop,1:npfp) = em_coupling0%mutual_loops_passive(1:kloop,1:npfp)
vesprobe(1:kprobe,1:npfp) = em_coupling0%field_probes_passive(1:kprobe,1:npfp)

write(*,*) 'vesgreen, vesprobe set OK'
flush(6)

vesarr = em_coupling0%mutual_grid_passive
if (associated(em_coupling0%mutual_loops_grid)) pslgreen = transpose(em_coupling0%mutual_loops_grid)
if (associated(em_coupling0%field_probes_grid)) bprgreen = transpose(em_coupling0%field_probes_grid)

write(*,*) 'pslgreen, bprgreen set OK'
flush(6)

pmj(:,:) = em_coupling0%mutual_passive_passive(:,:)


allocate(pf_turns(npfa))
pf_turns(1:npfa) = 1.d0
do i=1,npfa
    !pf_turns(i) = dabs(pf_active0%coil(i)%element(1)%turns_with_sign)
enddo


pfind(:,:) = 0.d0
pfgreen(:,:) = 0.d0
pfprobe(:,:) = 0.d0
pfc(:,:) = 0.d0
fluxarr(:,:) = 0.d0


do i=1,npfa
  do j=1,npfa
    pfind(ncirc(i),ncirc(j)) = pfind(ncirc(i),ncirc(j)) + dircirc(i)*dircirc(j)*em_coupling0%mutual_active_active(i,j)/(pf_turns(i)*pf_turns(j))
  enddo

  pfgreen(:,ncirc(i)) = pfgreen(:,ncirc(i)) + dircirc(i)*em_coupling0%mutual_loops_active(:,i)/pf_turns(i)
  pfprobe(:,ncirc(i)) = pfprobe(:,ncirc(i)) + dircirc(i)*em_coupling0%field_probes_active(:,i)/pf_turns(i)
  pfc(:,ncirc(i)) = pfc(:,ncirc(i)) + dircirc(i)*em_coupling0%mutual_passive_active(:,i)/pf_turns(i)
  fluxarr(:,ncirc(i)) = fluxarr(:,ncirc(i)) + dircirc(i)*em_coupling0%mutual_grid_active(:,i)/pf_turns(i)
enddo


print*, 'kpr =', kpr
if (kpr.eq.1) then
  print*, 'pfind'
  do i=1,nact
    print*, i, pfind(i,:)
  enddo
endif
flush(6)

! Resistances
pfres(1:nact) = 0.d0
do i=1,npfa
  pfres(ncirc(i)) = pfres(ncirc(i)) + pf_active0%coil(i)%resistance/(pf_turns(i)*pf_turns(i))
enddo


rcam(1:npfp) = pf_passive0%loop(1:npfp)%resistance


if (kpr.eq.1) then
  print *,'nact, pfres',nact
  print *,pfres

  print *,'npfp, rcam',npfp
  print *,rcam
endif


! Grid
x(1:nr)=equilibrium0%time_slice(1)%profiles_2d(1)%grid%dim1(1:nr) ![m]
y(1:nz)=equilibrium0%time_slice(1)%profiles_2d(1)%grid%dim2(1:nz) ![m]

gridrange(1)=y(1)
gridrange(2)=y(nz)
gridrange(3)=x(1)
gridrange(4)=x(nr)


! Limiter
if (.NOT.associated(wall0%description_2d)) then
  print*, 'wall0%description_2d is NULL. STOP'
  stop
endif
if (.NOT.associated(wall0%description_2d(1)%limiter%unit)) then
  print*, 'wall0%description_2d(1)%limiter%unit is NULL. STOP'
  stop
endif

nu = size(wall0%description_2d(1)%limiter%unit)
ke = 0
do i = 1, nu
  nlim = size(wall0%description_2d(1)%limiter%unit(i)%outline%r,1)
  if (wall0%description_2d(1)%limiter%unit(i)%closed.eq.1) nlim = nlim-1
  ke = ke + nlim
enddo
print *,'Limiter: ke, nu =', ke, nu

ALLOCATE(xu(ke))
ALLOCATE(yu(ke))

k = 0

nu = size(wall0%description_2d(1)%limiter%unit)
allocate(limunits(nu))
do i=1,nu
  limunits(i) = i
enddo

nlim = size(wall0%description_2d(1)%limiter%unit(limunits(1))%outline%r)
if (wall0%description_2d(1)%limiter%unit(limunits(1))%closed.eq.1) nlim = nlim-1
do j=1,nlim
  k = k + 1
  xu(k) = wall0%description_2d(1)%limiter%unit(limunits(1))%outline%r(j)
  yu(k) = wall0%description_2d(1)%limiter%unit(limunits(1))%outline%z(j)
enddo
limunits(1) = 0


do i=2,nu
  dst = 1.d10
  ju = 0

  do j=1,nu
    if (limunits(j).lt.1) cycle

    print*, 'j, limunits(j) =', j, limunits(j)

    nlim = size(wall0%description_2d(1)%limiter%unit(limunits(j))%outline%r)
    if (wall0%description_2d(1)%limiter%unit(limunits(j))%closed.eq.1) nlim = nlim-1

    x1 = wall0%description_2d(1)%limiter%unit(limunits(j))%outline%r(1)
    y1 = wall0%description_2d(1)%limiter%unit(limunits(j))%outline%z(1)
    dst1 = (x1 - xu(k))**2 + (y1 - yu(k))**2

    x2 = wall0%description_2d(1)%limiter%unit(limunits(j))%outline%r(nlim)
    y2 = wall0%description_2d(1)%limiter%unit(limunits(j))%outline%z(nlim)
    dst2 = (x2 - xu(k))**2 + (y2 - yu(k))**2 

    if (dst1.lt.dst) then
      dst = dst1
      ju = j
      jdir = 1
    endif

    if (dst2.lt.dst) then
      dst = dst2
      ju = j
      jdir = -1
    endif
  enddo

  
  nlim = size(wall0%description_2d(1)%limiter%unit(limunits(ju))%outline%r)
  if (wall0%description_2d(1)%limiter%unit(limunits(ju))%closed.eq.1) nlim = nlim-1
  
  if (jdir.gt.0) then
    do j=1,nlim
      k = k + 1
      xu(k) = wall0%description_2d(1)%limiter%unit(limunits(ju))%outline%r(j)
      yu(k) = wall0%description_2d(1)%limiter%unit(limunits(ju))%outline%z(j)
    enddo
  else
    do j=nlim,1,-1
      k = k + 1
      xu(k) = wall0%description_2d(1)%limiter%unit(limunits(ju))%outline%r(j)
      yu(k) = wall0%description_2d(1)%limiter%unit(limunits(ju))%outline%z(j)
    enddo
  endif
  limunits(ju) = 0

enddo


if(ke.ne.k)then
  print *,'Limiter ke, k =', ke, k
  print*, 'Limiter reading error. STOP'
  stop
end if
do i=1,ke
  print *, xu(i), yu(i)
enddo



write(*,*) 'Shapes of locally allocated arrays'
write(*,100) shape(fluxarr),shape(vesarr),shape(pslgreen),shape(bprgreen)
write(*,100) shape(pfgreen),shape(vesgreen),shape(pfprobe),shape(vesprobe)
write(*,100) shape(pfind),shape(pmj),shape(pfc)
write(*,100) shape(pfres),shape(rcam),shape(xu),shape(yu)


write(*,*) "fluxarr(1:3)=",fluxarr(1,1:3)
write(*,*) "vesarr(1:3)=",vesarr(1,1:3)
write(*,*) "pslgreen(1:3)=",pslgreen(1,1:3)
write(*,*) "bprgreen(1:3)=",bprgreen(1,1:3)
write(*,*) "pfres(1:3)=",pfres(1:3)
write(*,*) "rcam(1:3)=",rcam(1:3)

write(*,*) "gridrange=",gridrange



flush(6)


write(*,*) "End of static data extraction"

  
call write_cputime(0.d0, 0.d0, 1)


100 format (2I5, 4x,2I5, 4x, 2I5, 4x,2I5)


     


     call  dina_v96_in(npfp,nact,kloop,kprobe,&
& 	gridrange,nact,npfp,&
&	fluxarr,vesarr, pslgreen,bprgreen,&
&	pfind,pmj,pfc, pfres,rcam,&
&	xu,yu,ke,key,&
&   pfgreen,vesgreen,pfprobe,&
&   vesprobe,nwnh)

  
  
  write(*,*) "DINA green initialized"
  flush(6)
  
  

  !call dina_data_read()
  !call dina_data_read_imas(pulse_schedule, codeparam)

  
  
     CurTimeStep = 1

  if (associated(equilibrium0%vacuum_toroidal_field%b0)) then
      bt0 = equilibrium0%vacuum_toroidal_field%b0(1)
      rs0 = equilibrium0%vacuum_toroidal_field%r0
      print*, 'Toroidal field is assigned from equilibrium'
  else if(associated(core_profiles0%vacuum_toroidal_field%b0)) then
      bt0 = core_profiles0%vacuum_toroidal_field%b0(1)
      rs0 = core_profiles0%vacuum_toroidal_field%r0
      print*, 'Toroidal field is assigned from core_profiles'
  else
      print*, 'Toroidal field is not found'
   stop
  endif
  
  pf(1:nact) = 0.d0
  
  if (associated(pf_active0%coil(1)%current%data)) then 
  
    print*, 'PF currents are assigned from pf_active'
  do i=1,npfa
    if (associated(pf_active0%coil(i)%current%data)) then
      pf(ncirc(i)) = dircirc(i)*pf_active0%coil(i)%current%data(1)
      print *,' i pfa==',i,pf_active0%coil(i)%current%data(1)
    endif
  enddo

  else
  
  print*, 'PF currents are assigned from pulse_schedule'
  do i=1,npfa
    if (associated(pulse_schedule%pf_active%coil(i)%current%reference%data)) then
      pf(ncirc(i)) = dircirc(i)*pulse_schedule%pf_active%coil(i)%current%reference%data(1)
      print *,' i pfa==',i,pulse_schedule%pf_active%coil(i)%current%reference%data(1)
    endif
  enddo

  endif
  
  print *,'Active currents are assigned to:'
  do i=1,nact
    print *,' i pf==',i,pf(i)
  enddo

  tokc=0.d0
  if (associated(pf_passive0%loop(1)%current)) then  
    do i=1,npfp
      tcam(i) = pf_passive0%loop(i)%current(CurTimeStep)
      tokc=tokc+tcam(i)
    enddo
    print *,'Passive currents are assigned, tokc=', tokc
  else 
    do i=1,npfp
      tcam(i) = 0.d0
    enddo
    print *,'Passive currents are set to zero'
  endif
  
  
  tt = 0.d0
  call dina_input0(tt,pf,tcam,rs0,bt0)
  call ONE2()
  
  
if (associated(equilibrium0%time_slice)) then
if (associated(equilibrium0%time_slice(CurTimeStep)%profiles_1d%dpressure_dpsi)) then
if (associated(core_profiles0%profiles_1d)) then
if (associated(core_profiles0%profiles_1d(CurTimeStep)%grid%rho_tor_norm)) then

  print*, 'Applying restart...'

	if(equilibrium0%ids_properties%homogeneous_time.eq.1) then 
    tt = equilibrium0%time(CurTimeStep)
  else 
    tt = equilibrium0%time_slice(CurTimeStep)%time
  endif 
	tpl = equilibrium0%time_slice(CurTimeStep)%global_quantities%ip
        
	rmag=equilibrium0%time_slice(CurTimeStep)%global_quantities%magnetic_axis%r ![m]
        zmag=equilibrium0%time_slice(CurTimeStep)%global_quantities%magnetic_axis%z ![m]
        
        print *,' ++tt tpl==',tt,tpl
        
	n_tr = size(core_profiles0%profiles_1d(CurTimeStep)%grid%rho_tor_norm)
        n = n_tr
  if (n_tr.gt.npo) then
    print*, 'Input profile length is too large, n_tr, npo =', n_tr, npo
    stop
  endif

	a_tr(1:n) = core_profiles0%profiles_1d(CurTimeStep)%grid%rho_tor_norm(1:n)
	psi_tr(1:n) = cocos_psi * core_profiles0%profiles_1d(CurTimeStep)%grid%psi(1:n)

	n_eq = size(equilibrium0%time_slice(CurTimeStep)%profiles_1d%psi)
        n = n_eq
  if (n_eq.gt.npo) then
    print*, 'Input profile length is too large, n_eq, npo =', n_eq, npo
    stop
  endif

	!a(1:n) = equilibrium0%time_slice(CurTimeStep)%profiles_1d%rho_tor_norm(1:n)
  
        write(*,*) 'DINA_IMAS - equilibrium poloidal flux'
        psi_eq(1:n) = cocos_psi * equilibrium0%time_slice(CurTimeStep)%profiles_1d%psi(1:n)
  
	pptab(1:n) = cocos_psi * equilibrium0%time_slice(CurTimeStep)%profiles_1d%dpressure_dpsi(1:n)
	fptab(1:n) = cocos_psi * equilibrium0%time_slice(CurTimeStep)%profiles_1d%f_df_dpsi(1:n)
  
   
    i_restart=1
    
    
    call dina_input2(tt,tpl,rmag,zmag,  &
  &  n_eq,pptab,fptab,psi_eq, &
  &  n_tr,a_tr,psi_tr)
    
endif
endif
endif
endif ! end of restart assignment
    
end if ! end of first_call


if (associated(core_profiles0%profiles_1d)) then

write(*,*) 'dina_input prepare...'

 n1 = size(core_profiles0%profiles_1d(1)%grid%rho_tor_norm)
 if (n1.gt.npo) then
   print*, 'Input profile length is too large, n1, npo =', n1, npo
   stop
 endif



print *,'n1 i_restart ==',n1,i_restart


 a_xx(1:n1) =core_profiles0%profiles_1d(1)%grid%rho_tor_norm(1:n1)



! Transp1
 te0(1:n1) = core_profiles0%profiles_1d(1)%electrons%temperature(1:n1)
 tq0(1:n1) = core_profiles0%profiles_1d(1)%t_i_average(1:n1)

      apr='--te0-' 
      print 71,apr,(te0(i),i=1,n1) 
      apr='--tq0-' 
      print 71,apr,(tq0(i),i=1,n1) 

! if (associated(bndcond_in%profiles_1d)) then
!     write(*,*) 'dina_imas : boundary conditions are found'
!  te0(n1) = bndcond_in%profiles_1d(1)%electrons%energy%boundary_condition%value(1)
!  tq0(n1) = bndcond_in%profiles_1d(1)%energy_ion_total%boundary_condition%value(1)
!  
!      write(*,*) 'te0(n1) tq0(n1)= ', &
!     & te0(n1),tq0(n1)
! 
!       call solpsza_example_in(te0(n1),tq0(n1))
! 
! 
! end if

i_bnd=0
if (i_bnd.eq.1) then
!if (associated(bndcond_in%solver_1d)) then
    write(*,*) 'dina_imas : boundary conditions are found'
 te0(n1) = bndcond_in%solver_1d(1)%equation(1)%boundary_condition(1)%value(1)
 tq0(n1) = bndcond_in%solver_1d(1)%equation(3)%boundary_condition(1)%value(1)
 
     write(*,*) 'te0(n1) tq0(n1)= ', &
    & te0(n1),tq0(n1)

      call solpsza_example_in(te0(n1),tq0(n1))

     write(*,*) '++ te0(n1) tq0(n1)= ', &
    & te0(n1),tq0(n1)


end if

!Transp2
 pne(1:n1) = core_profiles0%profiles_1d(1)%electrons%density(1:n1)
 pd0(1:n1) = core_profiles0%profiles_1d(1)%ion(1)%density(1:n1)

 n_ions_in = size(core_profiles0%profiles_1d(1)%ion)
 if(n_ions_in.gt.1) then
  pt0(1:n1) = core_profiles0%profiles_1d(1)%ion(2)%density(1:n1)
 else
  pt0(1:n1) = 1.d0
 endif
      apr='--&pne-' 
      print 71,apr,(pne(i),i=1,n1) 
      apr='--&pd0-' 
      print 71,apr,(pd0(i),i=1,n1) 
      apr='--&pt0-' 
      print 71,apr,(pt0(i),i=1,n1) 

!Transp3
if (associated(core_profiles0%profiles_1d(1)%j_bootstrap)) then
  jbut(1:n1) = core_profiles0%profiles_1d(1)%j_bootstrap(1:n1)
else
  jbut(1:n1) = 0.d0
endif

apr='--&jbut-' 
print 71,apr,(jbut(i),i=1,n1) 

if (associated(core_profiles0%profiles_1d(1)%conductivity_parallel)) then
  sigma(1:n1) = core_profiles0%profiles_1d(1)%conductivity_parallel(1:n1)
else
  sigma(1:n1) = 1480.d0*te0(1:n1)**1.5d0
endif

apr='--&sigma-' 
print 71,apr,(sigma(i),i=1,n1) 

 !Transp4
 if (associated(core_profiles0%profiles_1d(1)%j_non_inductive).AND.associated(core_profiles0%profiles_1d(1)%j_bootstrap)) then
   aj0(1:n1) = core_profiles0%profiles_1d(1)%j_non_inductive(1:n1) - core_profiles0%profiles_1d(1)%j_bootstrap(1:n1)
 else
   aj0(1:n1) = 0.d0
 endif

 !Sources
 if (associated(core_sources0%source)) then
   qe0(1:n1) = core_sources0%source(1)%profiles_1d(1)%electrons%energy(1:n1)
   qq0(1:n1) = core_sources0%source(1)%profiles_1d(1)%total_ion_energy(1:n1)
 else
   qe0(1:n1) = 0.d0
   qq0(1:n1) = 0.d0
 endif

      apr='--qe0-' 
      print 71,apr,(qe0(i),i=1,n1) 
      apr='--qq0-' 
      print 71,apr,(qq0(i),i=1,n1) 

!  If we will use external IDS we will need dina_input(
!write(*,*) 'dina_input enter...'


    print *,'++ i_restart ==',i_restart
    

	call dina_input(n1,a_xx,te0,tq0,pne, &
     & pd0,pt0,sigma,jbut,aj0,qe0,qq0)


end if



loop_count = loop_count + 1 ! number of times the iterative routine was entered

write(*,*) 'dina_imas loop_count = ', loop_count



vchopper(1:nact) = 0.d0
do i=1,npfa
  if (associated(pf_active0%coil(i)%voltage%data)) then
    vchopper(ncirc(i)) = vchopper(ncirc(i)) + dircirc(i)*pf_active0%coil(i)%voltage%data(1)
  endif
enddo


call get_contr_signals(vchopper)


write(*,*) '!!!dina_0 enter'
	call dina_0()



write(*,*) '!!!dina_outp enter'
	call dina_outp_eq(n, tpl, tt, &
     & rs0,bt0,&
     & vchopper,pf,tcam,&
     & x,y,psi,curr_d,&
     & a,psi_eq,phi_1D,&
     & fpol,pptab,fptab,&
     & tok1,q,press,&
     & surface_1d,volume_1d,area_1d,&
     & bprobe,psloop,&
     & psi_ax, psi_bnd, psi_sep, psi_sep2,&
     & ksepa,&
     & n_bnd,xbound,ybound,&
     & n_sep,x_sep,y_sep,&
     & n_sep2,x_sep2,y_sep2,&
     & n_gaps,gaps,&
     & betap,betat)
     

  call dina_wr_output(wr_imas)



  call ids_copy(pf_active0, pf_active)
  call ids_copy(pf_passive0, pf_passive)
  call ids_copy(magnetics0, magnetics)
  !call ids_copy(equilibrium0, equilibrium)
  !call ids_copy(core_profiles0, core_profiles)
  !call ids_copy(core_sources0, core_sources)

        

write(*,*) '!!!solpsza enter'
      call solpsza_example(yfluxd_xx,yfluxt_xx,yfluxe_xx,yfluxi_xx,ysbound_xx)

    write(*,*) 'yfluxd_xx,yfluxt_xx,yfluxe_xx,yfluxi_xx,ysbound_xx= ', &
    & yfluxd_xx,yfluxt_xx,yfluxe_xx,yfluxi_xx,ysbound_xx
 
    pec = wr_imas(21)

    write(*,*) 'dina_outp_eq call n n1 tpl tt= ', n,n1,tpl,tt
    


    flush(6)
    
    
    
    psi_ax = psi_ax*cocos_psi
    psi_bnd = psi_bnd*cocos_psi
    psi_sep = psi_sep*cocos_psi
    psi_sep2 = psi_sep2*cocos_psi
    psi_ext = wr_imas(32)*cocos_psi
    psi = psi*cocos_psi
    psi_eq = psi_eq*cocos_psi
    psloop = psloop*cocos_psi
    pptab = pptab*cocos_psi
    fptab = fptab*cocos_psi
    
    if (wr_imas(13) .gt. 0.d0) then
      rmag = wr_imas(13)
    else 
      rmag = rs0
    endif


    if (abs(fpol(1)).gt.0.d0) then
      if (a(n).gt.a(1)) then
      b_field_ax = fpol(1)/rmag
      else
      b_field_ax = fpol(n)/rmag
      endif
    else
      b_field_ax = bt0*rs0/rmag
    endif
      


    betan = 100.d0*betat*dabs(wr_imas(4)*bt0/(tpl*1.d-6))



	call cpu_time(cpu_new)

	write(*,*) 'CPUTime = ', cpu_new-cpu_old

	call write_cputime(cpu_new-cpu_old, cpu_new, 0)

	cpu_old = cpu_new
	
	


! Magnetics

magnetics%ids_properties%homogeneous_time = 1

if (.NOT.associated(magnetics%time)) allocate(magnetics%time(1))
magnetics%time(1) = tt

! Loops
do i=1,kloop
  if (.NOT.associated(magnetics%flux_loop(i)%flux%data)) allocate(magnetics%flux_loop(i)%flux%data(1))
  magnetics%flux_loop(i)%flux%data(1) = psloop(i)
end do

! Probes
do i=1,kprobe
  if (.NOT.associated(magnetics%b_field_pol_probe(i)%field%data)) allocate(magnetics%b_field_pol_probe(i)%field%data(1))
  magnetics%b_field_pol_probe(i)%field%data(1) = bprobe(i)
end do

  

! PF Active

pf_active%ids_properties%homogeneous_time = 1
if (.NOT.associated(pf_active%time)) allocate(pf_active%time(1))
pf_active%time(1) = tt

do i=1,npfa
  if (.NOT.associated(pf_active%coil(i)%current%data)) allocate(pf_active%coil(i)%current%data(1))
    pf_active%coil(i)%current%data(1) = dircirc(i)*pf(ncirc(i))
enddo


!VS3
  !pf_active%coil(12)%current%data(1) = wr_imas(59)
  !pf_active%coil(12)%voltage%data(1) = wr_imas(62)



! Suppliers could be here
! pf_active%supply(1)%current%data(1) = wr_imas(35) ! CS3U
! pf_active%supply(1)%voltage%data(1) = wr_imas(46) ! CS3U
! 
! pf_active%supply(2)%current%data(1) = wr_imas(36) ! CS2U
! pf_active%supply(2)%voltage%data(1) = wr_imas(47) ! CS2U
! 
! pf_active%supply(3)%current%data(1) = wr_imas(37) ! CS1
! pf_active%supply(3)%voltage%data(1) = wr_imas(48) ! CS1
! 
! pf_active%supply(4)%current%data(1) = wr_imas(38) ! CS2L
! pf_active%supply(4)%voltage%data(1) = wr_imas(49) ! CS2L
! 
! pf_active%supply(5)%current%data(1) = wr_imas(39) ! CS3L
! pf_active%supply(5)%voltage%data(1) = wr_imas(50) ! CS3L
! 
! pf_active%supply(6)%current%data(1) = wr_imas(40) ! PF1
! pf_active%supply(6)%voltage%data(1) = wr_imas(51) ! PF1
! 
! pf_active%supply(7)%current%data(1) = wr_imas(41) ! PF2
! pf_active%supply(7)%voltage%data(1) = wr_imas(52) ! PF2
! 
! pf_active%supply(8)%current%data(1) = wr_imas(42) ! PF3
! pf_active%supply(8)%voltage%data(1) = wr_imas(53) ! PF3
! 
! pf_active%supply(9)%current%data(1) = wr_imas(43) ! PF4
! pf_active%supply(9)%voltage%data(1) = wr_imas(54) ! PF4
! 
! pf_active%supply(10)%current%data(1) = wr_imas(44) ! PF5
! pf_active%supply(10)%voltage%data(1) = wr_imas(55) ! PF5
! 
! pf_active%supply(11)%current%data(1) = wr_imas(45) ! PF6
! pf_active%supply(11)%voltage%data(1) = wr_imas(56) ! PF6
! 
! 
! 
! pf_active%supply(12)%current%data(1) = wr_imas(59) ! VS3
! pf_active%supply(12)%voltage%data(1) = wr_imas(62) ! VS3


!pf_active%global_quantities%psi_coils_list(:)
!if(.NOT.associated(pf_active%global_quantities%psi_coils_average)) allocate(pf_active%global_quantities%psi_coils_average(1))
!if(.NOT.associated(pf_active%global_quantities%time)) allocate(pf_active%global_quantities%time(1))
!pf_active%global_quantities%psi_coils_average(1) = wr_imas(33)
!pf_active%global_quantities%time(1) = tt




pf_passive%ids_properties%homogeneous_time = 1
if (.NOT.associated(pf_passive%time)) allocate(pf_passive%time(1))
pf_passive%time(1) = tt

do j=1,npfp
  if (.NOT.associated(pf_passive%loop(j)%current)) allocate(pf_passive%loop(j)%current(1))
    pf_passive%loop(j)%current(1) = tcam(j)
end do



flush(6)
   

  TimeSteps = 1 ! One time step filled for put_slice function
  CurTimeStep = 1



! Filling equilibrium
equilibrium%ids_properties%homogeneous_time = 1
allocate(equilibrium%time_slice(TimeSteps))
equilibrium%time_slice(CurTimeStep)%time = tt
allocate(equilibrium%time(TimeSteps))
equilibrium%time(CurTimeStep) = tt
  
! 0D Quantities
        equilibrium%time_slice(CurTimeStep)%global_quantities%ip = tpl ![A]
        equilibrium%time_slice(CurTimeStep)%global_quantities%li_3 = wr_imas(19)
        equilibrium%time_slice(CurTimeStep)%global_quantities%beta_pol = betap
        equilibrium%time_slice(CurTimeStep)%global_quantities%beta_tor = betat
        equilibrium%time_slice(CurTimeStep)%global_quantities%beta_normal = betan

        equilibrium%time_slice(CurTimeStep)%global_quantities%volume = wr_imas(7) ![m3]
        equilibrium%time_slice(CurTimeStep)%global_quantities%area = wr_imas(8) ![m2]
        equilibrium%time_slice(CurTimeStep)%global_quantities%surface = wr_imas(9) ! [m²]
        equilibrium%time_slice(CurTimeStep)%global_quantities%psi_axis= psi_ax ![Wb]
        equilibrium%time_slice(CurTimeStep)%global_quantities%psi_boundary = psi_bnd ![Wb]

        equilibrium%time_slice(CurTimeStep)%global_quantities%magnetic_axis%r = wr_imas(13) ![m]
        equilibrium%time_slice(CurTimeStep)%global_quantities%magnetic_axis%z = wr_imas(14) ![m]
        equilibrium%time_slice(CurTimeStep)%global_quantities%magnetic_axis%b_field_tor = b_field_ax

        equilibrium%time_slice(CurTimeStep)%global_quantities%current_centre%r = wr_imas(10) ![m]
        equilibrium%time_slice(CurTimeStep)%global_quantities%current_centre%z = wr_imas(11) ![m]       
        equilibrium%time_slice(CurTimeStep)%global_quantities%current_centre%velocity_z = wr_imas(12) ![m]

        equilibrium%time_slice(CurTimeStep)%global_quantities%q_axis = wr_imas(18)
        equilibrium%time_slice(CurTimeStep)%global_quantities%q_95 = wr_imas(17)
        equilibrium%time_slice(CurTimeStep)%global_quantities%energy_mhd = wr_imas(76) ![J]
        equilibrium%time_slice(CurTimeStep)%global_quantities%psi_external_average = psi_ext ! [Wb]
        equilibrium%time_slice(CurTimeStep)%global_quantities%plasma_inductance = wr_imas(75) ! [H]
        equilibrium%time_slice(CurTimeStep)%global_quantities%plasma_resistance= wr_imas(77) ! [Ohm]


        equilibrium%vacuum_toroidal_field%r0 = rs0 ![m]
        allocate(equilibrium%vacuum_toroidal_field%b0(TimeSteps))
          equilibrium%vacuum_toroidal_field%b0(CurTimeStep) = bt0 ![T]
  
  
        
        ! Plasma boundary
        equilibrium%time_slice(CurTimeStep)%boundary%type = ksepa ! 0 is limiter, 1 is diverted
        equilibrium%time_slice(CurTimeStep)%boundary%psi = psi_bnd ![Wb]
        equilibrium%time_slice(CurTimeStep)%boundary%geometric_axis%r = wr_imas(3)
        !equilibrium%time_slice(CurTimeStep)%boundary%geometric_axis%z = wr_imas()
        equilibrium%time_slice(CurTimeStep)%boundary%minor_radius = wr_imas(4)
        equilibrium%time_slice(CurTimeStep)%boundary%elongation = wr_imas(5)
        equilibrium%time_slice(CurTimeStep)%boundary%triangularity = wr_imas(6)
        !equilibrium%time_slice(CurTimeStep)%boundary%triangularity_upper = wr_imas()
        !equilibrium%time_slice(CurTimeStep)%boundary%triangularity_lower = wr_imas()
        !equilibrium%time_slice(CurTimeStep)%boundary%triangularity_left = wr_imas()
        !equilibrium%time_slice(CurTimeStep)%boundary%triangularity_right = wr_imas()
        allocate(equilibrium%time_slice(CurTimeStep)%boundary%outline%r(n_bnd))
        allocate(equilibrium%time_slice(CurTimeStep)%boundary%outline%z(n_bnd))
          equilibrium%time_slice(CurTimeStep)%boundary%outline%r(1:n_bnd) = xbound(1:n_bnd)
          equilibrium%time_slice(CurTimeStep)%boundary%outline%z(1:n_bnd) = ybound(1:n_bnd)       
        
        
        ! Main separatrix
        equilibrium%time_slice(CurTimeStep)%boundary_separatrix%psi = psi_sep ! [Wb]
        equilibrium%time_slice(CurTimeStep)%boundary_separatrix%type = ksepa ! 0 is limiter, 1 is diverted
        allocate(equilibrium%time_slice(CurTimeStep)%boundary_separatrix%outline%r(n_sep))
        allocate(equilibrium%time_slice(CurTimeStep)%boundary_separatrix%outline%z(n_sep))
          equilibrium%time_slice(CurTimeStep)%boundary_separatrix%outline%r(1:n_sep) = x_sep(1:n_sep)
          equilibrium%time_slice(CurTimeStep)%boundary_separatrix%outline%z(1:n_sep) = y_sep(1:n_sep)
       
       
        if (ksepa.eq.0) then
          ! Limiter plasma
          equilibrium%time_slice(CurTimeStep)%boundary_separatrix%active_limiter_point%r = wr_imas(15)
          equilibrium%time_slice(CurTimeStep)%boundary_separatrix%active_limiter_point%z = wr_imas(16)

          equilibrium%time_slice(CurTimeStep)%boundary%active_limiter_point%r = wr_imas(15)
          equilibrium%time_slice(CurTimeStep)%boundary%active_limiter_point%z = wr_imas(16)
                   
        else
          ! Diverted plasma
          equilibrium%time_slice(CurTimeStep)%boundary_separatrix%active_limiter_point%r = wr_imas(102) ! Closest wall point
          equilibrium%time_slice(CurTimeStep)%boundary_separatrix%active_limiter_point%z = wr_imas(103)

          equilibrium%time_slice(CurTimeStep)%boundary%active_limiter_point%r = wr_imas(102)
          equilibrium%time_slice(CurTimeStep)%boundary%active_limiter_point%z = wr_imas(103)
          
          allocate(equilibrium%time_slice(CurTimeStep)%boundary_separatrix%x_point(1))
            equilibrium%time_slice(CurTimeStep)%boundary_separatrix%x_point(1)%r = wr_imas(15)
            equilibrium%time_slice(CurTimeStep)%boundary_separatrix%x_point(1)%z = wr_imas(16)

        endif
        
      
        equilibrium%time_slice(CurTimeStep)%boundary_separatrix%closest_wall_point%distance = wr_imas(101)
        equilibrium%time_slice(CurTimeStep)%boundary_separatrix%closest_wall_point%r = wr_imas(102)
        equilibrium%time_slice(CurTimeStep)%boundary_separatrix%closest_wall_point%z = wr_imas(103)
       
       
        ! Gaps
        ! 24 - fiducial ITER gaps
        ! n_gaps=6 - Gaps for Kavin's controller
        ! 1 - dsep
        allocate(equilibrium%time_slice(CurTimeStep)%boundary_separatrix%gap(24+n_gaps))
        do i=1,24
          equilibrium%time_slice(CurTimeStep)%boundary_separatrix%gap(i)%value = wr_imas(105+i)
        enddo
        do i=1,n_gaps
          equilibrium%time_slice(CurTimeStep)%boundary_separatrix%gap(24+i)%value = gaps(i)
        enddo
       
        ! Outer separatrix
        equilibrium%time_slice(CurTimeStep)%boundary_secondary_separatrix%psi = psi_sep2
        equilibrium%time_slice(CurTimeStep)%boundary_secondary_separatrix%distance_inner_outer = wr_imas(96)

        allocate(equilibrium%time_slice(CurTimeStep)%boundary_secondary_separatrix%outline%r(n_sep2))
        allocate(equilibrium%time_slice(CurTimeStep)%boundary_secondary_separatrix%outline%z(n_sep2))
          equilibrium%time_slice(CurTimeStep)%boundary_secondary_separatrix%outline%r(1:n_sep2) = x_sep2(1:n_sep2)
          equilibrium%time_slice(CurTimeStep)%boundary_secondary_separatrix%outline%z(1:n_sep2) = y_sep2(1:n_sep2)
       
        allocate(equilibrium%time_slice(CurTimeStep)%boundary_secondary_separatrix%x_point(1))
          equilibrium%time_slice(CurTimeStep)%boundary_secondary_separatrix%x_point(1)%r = wr_imas(94)
          equilibrium%time_slice(CurTimeStep)%boundary_secondary_separatrix%x_point(1)%z = wr_imas(95)
        
        allocate(equilibrium%time_slice(CurTimeStep)%boundary_secondary_separatrix%strike_point(1))
          equilibrium%time_slice(CurTimeStep)%boundary_secondary_separatrix%strike_point(1)%r = wr_imas(97)
          equilibrium%time_slice(CurTimeStep)%boundary_secondary_separatrix%strike_point(1)%z = wr_imas(98)
        

! 1D Profiles

    allocate(equilibrium%time_slice(CurTimeStep)%profiles_1d%rho_tor_norm(n))
    allocate(equilibrium%time_slice(CurTimeStep)%profiles_1d%psi(n))

    allocate(equilibrium%time_slice(CurTimeStep)%profiles_1d%pressure(n))
    allocate(equilibrium%time_slice(CurTimeStep)%profiles_1d%dpressure_dpsi(n))
    allocate(equilibrium%time_slice(CurTimeStep)%profiles_1d%f_df_dpsi(n))
    allocate(equilibrium%time_slice(CurTimeStep)%profiles_1d%f(n))
      equilibrium%time_slice(CurTimeStep)%profiles_1d%f(1:n) = fpol(1:n)
    
!    equilibrium%time_slice(CurTimeStep)%profiles_1d%rho_tor_norm(1:n) = ai(1:n)
    equilibrium%time_slice(CurTimeStep)%profiles_1d%rho_tor_norm(1:n) = a(1:n)


    equilibrium%time_slice(CurTimeStep)%profiles_1d%psi(1:n) = psi_eq(1:n)

    equilibrium%time_slice(CurTimeStep)%profiles_1d%pressure(1:n) = press(1:n) ![Pa]

    
    
    
!       pptab_dina =-1./(rs0*1.d-2)*pptab*10./pmu0 
!       fptab_dina=-fptab*0.5d0*(rs0*1.d-2)*10./pmu0

!       pptab_iter =-pptab_dina/(2*pi)
!       fptab_iter=-fptab_dina/(2*pi)

!       pptab_iter =pptab/(2*pi)/(rs0*1.d-2)*10./pmu0
!       fptab_iter=fptab/(2*pi)*0.5d0*(rs0*1.d-2)*10./pmu0

    
    !pmu0=4.d0*pi*1.d-7
    !coef_ppx=1./(2*pi)/(rs0)*10./pmu0
    !coef_pffx=1./(2*pi)*0.5d0*(rs0)*10.   
    !print *,' coef_ppx coef_pffx rs0 pmu0=',coef_ppx,coef_pffx,rs0,pmu0    
    !equilibrium%time_slice(CurTimeStep)%profiles_1d%dpressure_dpsi(1:n) = coef_ppx*pptab(1:n)
    !equilibrium%time_slice(CurTimeStep)%profiles_1d%f_df_dpsi(1:n) = coef_pffx*fptab(1:n)        
           
    equilibrium%time_slice(CurTimeStep)%profiles_1d%dpressure_dpsi(1:n) = pptab(1:n)
    equilibrium%time_slice(CurTimeStep)%profiles_1d%f_df_dpsi(1:n) = fptab(1:n)  

    AllocArr(equilibrium%time_slice(CurTimeStep)%profiles_1d%phi,phi_1D,n)
    AllocArr(equilibrium%time_slice(CurTimeStep)%profiles_1d%q, q, n)
    AllocArr(equilibrium%time_slice(CurTimeStep)%profiles_1d%j_tor, tok1, n)

    AllocArr(equilibrium%time_slice(CurTimeStep)%profiles_1d%volume, volume_1d, n)
    AllocArr(equilibrium%time_slice(CurTimeStep)%profiles_1d%area, area_1d, n)
    AllocArr(equilibrium%time_slice(CurTimeStep)%profiles_1d%surface, surface_1d, n)
   
    
    ! 2D Profiles
    allocate(equilibrium%time_slice(CurTimeStep)%profiles_2d(1))
    equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%type%index = 0
    ! Grid dimensions
    equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%grid_type%index = 1 ! Rectangular a la eqdsk
    allocate(equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%grid%dim1(nr))
    allocate(equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%grid%dim2(nz))
      equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%grid%dim1(1:nr)=x(1:nr)
      equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%grid%dim2(1:nz)=y(1:nz)
    
    !allocate(equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%grid%volume_element(nr-1,nz-1))   
    !do i=1,nr-1
    !do j=1,nz-1
    !  equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%grid%volume_element(i,j)=dabs((x(i+1)-x(i))*(y(j+1)-y(j)))
    !enddo
    !enddo
    
    ! Profiles
    allocate(equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%psi(nr,nz))
    allocate(equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%j_tor(nr,nz))     
    
    
    allocate(equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%r(nr,nz))
    allocate(equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%z(nr,nz))        
    do i=1,nz
      equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%r(1:nr,i)=x(1:nr)
    enddo
    do i=1,nr
      equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%z(i,1:nz)=y(1:nz)
    enddo
    

  !  call write_graf_imas0(nr,nz,ke, &
  !   &	0.01d0,0.01d0,tt,&
  !   &  psi,x,y,xu,yu,&
  !   &  psi_ax,psi_bnd,psi_bnd,0.d0,0.d0) 



!     do i=1,nz
!     do j=1,nr
!       equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%psi(i,j)=psi(j,i)
!       equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%j_tor(i,j)=curr_d(j,i)
!     enddo
!     enddo
!     
! 
!     do i=1,nz
!     do j=1,nr
!       psi1(j,i) = equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%psi(i,j)
!     enddo
!     enddo

    equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%psi = psi
    equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%j_tor = curr_d
    
    
           
    i_wr=0
    if(i_wr.eq.1)then
    psi1 = equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%psi

    call write_graf_imas(nr,nz,ke, &
     &	0.01d0,0.01d0,tt,&
     &  psi1,x,y,xu,yu,&
     &  psi_ax,psi_bnd,psi_bnd,0.d0,0.d0) 

    end if
    







write(*,*) '!!!dina_outp_tr enter'
	call dina_outp_tr(n, tpl, tt, &
     & a,psi_tr,q,&
     & sigma,tok1,jbut,aj0,ajae,&
     & surface_1d,volume_1d,area_1d,&
     & te0,tq0,press,zeff,&
     & qe0,qq0,&
     & pne,pd0,pt0,&
     & psi_ax,psi_bnd,&
     & ksepa,key_lh,&
     & betap,betat,&
     & tene,teit_98)



    psi_ax = psi_ax*cocos_psi
    psi_bnd = psi_bnd*cocos_psi
    psi_tr = psi_tr*cocos_psi
    


! Filling summary
summary%ids_properties%homogeneous_time = 1
allocate(summary%time(TimeSteps))
summary%time(CurTimeStep) = tt;

print *,' teit_98 tene tqc==',teit_98,tene


AllocIfNull1(summary%global_quantities%ip%value, tpl)
AllocIfNull1(summary%global_quantities%v_loop%value, wr_imas(29))
AllocIfNull1(summary%global_quantities%li%value, wr_imas(19))
AllocIfNull1(summary%global_quantities%resistance%value, wr_imas(77))
AllocIfNull1(summary%global_quantities%psi_external_average%value, wr_imas(32))
AllocIfNull1(summary%global_quantities%greenwald_fraction%value, wr_imas(22))

AllocIfNull1(summary%global_quantities%beta_pol%value, betap)
AllocIfNull1(summary%global_quantities%beta_tor%value, betat)
AllocIfNull1(summary%global_quantities%beta_tor_norm%value, betan)

AllocIfNull1(summary%global_quantities%energy_thermal%value, wr_imas(76))
AllocIfNull1(summary%global_quantities%energy_b_field_pol%value, wr_imas(74))

AllocIfNull1(summary%global_quantities%tau_energy%value, wr_imas(93))
AllocIfNull1(summary%global_quantities%tau_energy_98%value, teit_98)
AllocIfNull1(summary%global_quantities%tau_resistive%value, wr_imas(78))

AllocIfNull1(summary%global_quantities%fusion_gain%value, wr_imas(70))
AllocIfNull1(summary%global_quantities%fusion_fluence%value, wr_imas(69))

AllocIfNull1(summary%global_quantities%volume%value, wr_imas(7))
AllocIfNull1(summary%global_quantities%h_mode%value, key_lh)

summary%global_quantities%r0%value = rs0
AllocIfNull1(summary%global_quantities%b0%value, bt0)

AllocIfNull1(summary%global_quantities%q_95%value, wr_imas(17))
AllocIfNull1(summary%global_quantities%power_ohm%value, wr_imas(65))
AllocIfNull1(summary%global_quantities%power_radiated_inside_lcfs%value, wr_imas(91))
AllocIfNull1(summary%global_quantities%power_bremsstrahlung%value, wr_imas(84))
!AllocIfNull1(summary%global_quantities%power_synchrotron%value, wr_imas(85)) !Should be cyclotron
AllocIfNull1(summary%global_quantities%power_loss%value, wr_imas(92))



AllocIfNull1(summary%local%magnetic_axis%position%r, wr_imas(13))
AllocIfNull1(summary%local%magnetic_axis%position%z, wr_imas(14))

AllocIfNull1(summary%local%magnetic_axis%position%psi, psi_ax)
AllocIfNull1(summary%local%magnetic_axis%position%rho_tor_norm, a(1))
AllocIfNull1(summary%local%magnetic_axis%b_field%value, b_field_ax)

AllocIfNull1(summary%local%magnetic_axis%q%value, wr_imas(18))
AllocIfNull1(summary%local%magnetic_axis%zeff%value, zeff(1))
AllocIfNull1(summary%local%magnetic_axis%t_e%value, te0(1))
AllocIfNull1(summary%local%magnetic_axis%t_i_average%value, tq0(1))
AllocIfNull1(summary%local%magnetic_axis%n_e%value, pne(1))
AllocIfNull1(summary%local%magnetic_axis%n_i%deuterium%value, pd0(1))
AllocIfNull1(summary%local%magnetic_axis%n_i%tritium%value, pt0(1))
AllocIfNull1(summary%local%magnetic_axis%n_i%helium_4%value, wr_imas(79)*pne(1))
AllocIfNull1(summary%local%magnetic_axis%n_i%beryllium%value, wr_imas(80)*pne(1))
AllocIfNull1(summary%local%magnetic_axis%n_i%tungsten%value, wr_imas(81)*pne(1))
AllocIfNull1(summary%local%magnetic_axis%n_i%argon%value, wr_imas(82)*pne(1))
AllocIfNull1(summary%local%magnetic_axis%n_i%neon%value, wr_imas(83)*pne(1))

AllocIfNull1(summary%local%separatrix%position%psi, psi_sep)
AllocIfNull1(summary%local%separatrix%position%rho_tor_norm, a(n))


AllocIfNull1(summary%local%separatrix%q%value, wr_imas(17))
AllocIfNull1(summary%local%separatrix%zeff%value, zeff(n))
AllocIfNull1(summary%local%separatrix%t_e%value, te0(n))
AllocIfNull1(summary%local%separatrix%t_i_average%value, tq0(n))
AllocIfNull1(summary%local%separatrix%n_e%value, pne(n))
AllocIfNull1(summary%local%separatrix%n_i%deuterium%value, pd0(n))
AllocIfNull1(summary%local%separatrix%n_i%tritium%value, pt0(n))
AllocIfNull1(summary%local%separatrix%n_i%helium_4%value, wr_imas(79)*pne(n))
AllocIfNull1(summary%local%separatrix%n_i%beryllium%value, wr_imas(80)*pne(n))
AllocIfNull1(summary%local%separatrix%n_i%tungsten%value, wr_imas(81)*pne(n))
AllocIfNull1(summary%local%separatrix%n_i%argon%value, wr_imas(82)*pne(n))
AllocIfNull1(summary%local%separatrix%n_i%neon%value, wr_imas(83)*pne(n))


AllocIfNull1(summary%boundary%type%value, ksepa)
AllocIfNull1(summary%boundary%gap_limiter_wall%value, wr_imas(101))
AllocIfNull1(summary%boundary%magnetic_axis_r%value, wr_imas(13))
AllocIfNull1(summary%boundary%magnetic_axis_z%value, wr_imas(14))
AllocIfNull1(summary%boundary%geometric_axis_r%value, wr_imas(3))
!AllocIfNull1(summary%boundary%geometric_axis_z%value, wr_imas())
AllocIfNull1(summary%boundary%minor_radius%value, wr_imas(4))
AllocIfNull1(summary%boundary%elongation%value, wr_imas(5))
!AllocIfNull1(summary%boundary%triangularity_upper%value, wr_imas())
!AllocIfNull1(summary%boundary%triangularity_lower%value, wr_imas())
AllocIfNull1(summary%boundary%gap_limiter_wall%value, wr_imas(101))
AllocIfNull1(summary%boundary%distance_inner_outer_separatrices%value, wr_imas(96))
if (ksepa.ne.0) then
  AllocIfNull1(summary%boundary%x_point_main%r, wr_imas(15))
  AllocIfNull1(summary%boundary%x_point_main%z, wr_imas(16))
  !AllocIfNull1(summary%boundary%strike_point_inner_r%value, wr_imas())
  !AllocIfNull1(summary%boundary%strike_point_inner_z%value, wr_imas())
  !AllocIfNull1(summary%boundary%strike_point_outer_r%value, wr_imas())
  !AllocIfNull1(summary%boundary%strike_point_outer_z%value, wr_imas())
else
  AllocIfNull1(summary%boundary%x_point_main%r, 0.d0)
  AllocIfNull1(summary%boundary%x_point_main%z, 0.d0)
endif


AllocIfNull1(summary%volume_average%zeff%value, wr_imas(28))
AllocIfNull1(summary%volume_average%t_e%value, wr_imas(24))
AllocIfNull1(summary%volume_average%t_i_average%value, wr_imas(26))
AllocIfNull1(summary%volume_average%n_e%value, wr_imas(21))
AllocIfNull1(summary%volume_average%n_i_total%value, wr_imas(23))
AllocIfNull1(summary%volume_average%n_i%helium_4%value, wr_imas(79)*pec)
AllocIfNull1(summary%volume_average%n_i%beryllium%value, wr_imas(80)*pec)
AllocIfNull1(summary%volume_average%n_i%tungsten%value, wr_imas(81)*pec)
AllocIfNull1(summary%volume_average%n_i%argon%value, wr_imas(82)*pec)
AllocIfNull1(summary%volume_average%n_i%neon%value, wr_imas(83)*pec)

write(*,*) 'summary%volume_average%n_i_total%value... ',summary%volume_average%n_i_total%value(CurTimeStep)


AllocIfNull1(summary%fusion%power%value, wr_imas(68))
!summary%fusion%neutron_power_total%value(CurTimeStep) = ???

AllocIfNull1(summary%heating_current_drive%power_additional%value, wr_imas(66))




    
! Starting core_profiles    
    core_profiles%ids_properties%homogeneous_time = 1
    allocate(core_profiles%profiles_1d(TimeSteps))
    core_profiles%profiles_1d(CurTimeStep)%time = tt
    allocate(core_profiles%time(TimeSteps))
    core_profiles%time(CurTimeStep) = tt ![s]
    
write(*,*) 'Allocate core_profiles... '

    
! Filling 0D

    AllocIfNull1(core_profiles%global_quantities%resistive_psi_losses, wr_imas(30))
    AllocIfNull1(core_profiles%global_quantities%ejima, wr_imas(31))

    AllocIfNull1(core_profiles%global_quantities%ip, tpl)
    AllocIfNull1(core_profiles%global_quantities%beta_pol, betap)
    AllocIfNull1(core_profiles%global_quantities%beta_tor, betat)
    AllocIfNull1(core_profiles%global_quantities%beta_tor_norm, betan)
    AllocIfNull1(core_profiles%global_quantities%li_3, wr_imas(19))
    AllocIfNull1(core_profiles%global_quantities%v_loop, wr_imas(29))

    core_profiles%vacuum_toroidal_field%r0 = rs0
    AllocIfNull1(core_profiles%vacuum_toroidal_field%b0, bt0)

    
! Filling 1D

    AllocArr(core_profiles%profiles_1d(CurTimeStep)%grid%rho_tor_norm, a, n)
    AllocArr(core_profiles%profiles_1d(CurTimeStep)%grid%psi, psi_tr, n)
    AllocArr(core_profiles%profiles_1d(CurTimeStep)%grid%volume, volume_1d, n)
    AllocArr(core_profiles%profiles_1d(CurTimeStep)%grid%area, area_1d, n)
    AllocArr(core_profiles%profiles_1d(CurTimeStep)%grid%surface, surface_1d, n)
    core_profiles%profiles_1d(CurTimeStep)%grid%psi_magnetic_axis = psi_ax
    core_profiles%profiles_1d(CurTimeStep)%grid%psi_boundary = psi_bnd


    AllocArr(core_profiles%profiles_1d(CurTimeStep)%j_tor, tok1, n) ![A/m2]
    AllocArr(core_profiles%profiles_1d(CurTimeStep)%q, q, n)
    
    AllocArr(core_profiles%profiles_1d(CurTimeStep)%zeff, zeff, n)
    AllocArr(core_profiles%profiles_1d(CurTimeStep)%pressure_thermal, press, n) 



write(*,*) 'Write core_profiles transp... '
flush(6)
! Transp1 - energy transport
 AllocArr(core_profiles%profiles_1d(CurTimeStep)%electrons%temperature, te0, n)
 AllocIfNull1(core_profiles%global_quantities%t_e_volume_average, wr_imas(24))
 AllocIfNull1(core_profiles%global_quantities%n_e_volume_average, wr_imas(21))
 AllocIfNull1(core_profiles%global_quantities%t_e_peaking, wr_imas(25))

 AllocArr(core_profiles%profiles_1d(CurTimeStep)%t_i_average, tq0, n)
 AllocIfNull1(core_profiles%global_quantities%t_i_average_peaking, wr_imas(27))

write(*,*) 'Write core_profiles transp..1. '
flush(6)


!Transp2 - particle transport
!Electrons
 AllocArr(core_profiles%profiles_1d(1)%electrons%density, pne, n)

 core_profiles%global_quantities%ion_time_slice = CurTimeStep

if (.not. associated(core_profiles%profiles_1d(1)%ion)) then
   allocate(core_profiles%profiles_1d(1)%ion(n_ions))
end if
if (.not. associated(core_profiles%global_quantities%ion)) then
   allocate(core_profiles%global_quantities%ion(n_ions))
end if
ion = 0

! Deuterium
ion = ion + 1
  core_profiles%profiles_1d(1)%ion(ion)%z_ion = 1
!core_profiles%profiles_1d(1)%ion(ion)%label = 'D'
allocate(core_profiles%profiles_1d(1)%ion(ion)%element(1))
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%a = 2
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%z_n = 1
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%atoms_n = 1
 AllocArr(core_profiles%profiles_1d(1)%ion(ion)%density, pd0, n)
      apr='++00pd0-' 
      print 71,apr,(pd0(i),i=1,n)
 AllocIfNull1(core_profiles%global_quantities%ion(ion)%t_i_volume_average, wr_imas(26))
! AllocIfNull1(core_profiles%global_quantities%ion(ion)%n_i_volume_average, ???))

! Tritium
ion = ion + 1
 core_profiles%profiles_1d(1)%ion(ion)%z_ion = 1
!core_profiles%profiles_1d(1)%ion(ion)%label = 'T'
allocate(core_profiles%profiles_1d(1)%ion(ion)%element(1))
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%a = 3
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%z_n = 1
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%atoms_n = 1
 AllocArr(core_profiles%profiles_1d(1)%ion(ion)%density, pt0, n)
      apr='++00pt0-' 
      print 71,apr,(pt0(i),i=1,n)
 AllocIfNull1(core_profiles%global_quantities%ion(ion)%t_i_volume_average, wr_imas(26))
! AllocIfNull1(core_profiles%global_quantities%ion(ion)%n_i_volume_average, ???))

! Helium
ion = ion + 1
 core_profiles%profiles_1d(1)%ion(ion)%z_ion = 2
!core_profiles%profiles_1d(1)%ion(ion)%label = 'He'
allocate(core_profiles%profiles_1d(1)%ion(ion)%element(1))
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%a = 4
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%z_n = 2
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%atoms_n = 1
 AllocArr(core_profiles%profiles_1d(1)%ion(ion)%density, wr_imas(79)*pne, n)
 AllocIfNull1(core_profiles%global_quantities%ion(ion)%t_i_volume_average, wr_imas(26))
 AllocIfNull1(core_profiles%global_quantities%ion(ion)%n_i_volume_average, wr_imas(79)*pec)

! Beryllium
ion = ion + 1
 core_profiles%profiles_1d(1)%ion(ion)%z_ion = 4
!core_profiles%profiles_1d(1)%ion(ion)%label = 'Be'
allocate(core_profiles%profiles_1d(1)%ion(ion)%element(1))
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%a = 9
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%z_n = 4
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%atoms_n = 1
 AllocArr(core_profiles%profiles_1d(1)%ion(ion)%density, wr_imas(80)*pne, n)
 AllocIfNull1(core_profiles%global_quantities%ion(ion)%t_i_volume_average, wr_imas(26))
 AllocIfNull1(core_profiles%global_quantities%ion(ion)%n_i_volume_average, wr_imas(80)*pec)

! Tungsten
ion = ion + 1
 core_profiles%profiles_1d(1)%ion(ion)%z_ion = 74
!core_profiles%profiles_1d(1)%ion(ion)%label = 'W'
allocate(core_profiles%profiles_1d(1)%ion(ion)%element(1))
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%a = 183.84d0
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%z_n = 74
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%atoms_n = 1
 AllocArr(core_profiles%profiles_1d(1)%ion(ion)%density, wr_imas(81)*pne, n)
 AllocIfNull1(core_profiles%global_quantities%ion(ion)%t_i_volume_average, wr_imas(26))
 AllocIfNull1(core_profiles%global_quantities%ion(ion)%n_i_volume_average, wr_imas(81)*pec)

! Argon
ion = ion + 1
 core_profiles%profiles_1d(1)%ion(ion)%z_ion = 18
!core_profiles%profiles_1d(1)%ion(ion)%label = 'Ar'
allocate(core_profiles%profiles_1d(1)%ion(ion)%element(1))
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%a = 40
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%z_n = 18
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%atoms_n = 1
 AllocArr(core_profiles%profiles_1d(1)%ion(ion)%density, wr_imas(82)*pne, n)
 AllocIfNull1(core_profiles%global_quantities%ion(ion)%t_i_volume_average, wr_imas(26))
 AllocIfNull1(core_profiles%global_quantities%ion(ion)%n_i_volume_average, wr_imas(82)*pec)

! Neon
ion = ion + 1
 core_profiles%profiles_1d(1)%ion(ion)%z_ion = 10
!core_profiles%profiles_1d(1)%ion(ion)%label = 'Ne'
allocate(core_profiles%profiles_1d(1)%ion(ion)%element(1))
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%a = 20
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%z_n = 10
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%atoms_n = 1
 AllocArr(core_profiles%profiles_1d(1)%ion(ion)%density, wr_imas(83)*pne, n)
 AllocIfNull1(core_profiles%global_quantities%ion(ion)%t_i_volume_average, wr_imas(26))
 AllocIfNull1(core_profiles%global_quantities%ion(ion)%n_i_volume_average, wr_imas(83)*pec)


!Transp3
 AllocArr(core_profiles%profiles_1d(1)%j_bootstrap, jbut, n)
 AllocArr(core_profiles%profiles_1d(1)%conductivity_parallel, sigma, n)


!Transp4
 AllocIfNull(core_profiles%profiles_1d(1)%j_non_inductive, n)
   core_profiles%profiles_1d(1)%j_non_inductive(1:n) = aj0(1:n) + ajae(1:n) + jbut(1:n)



!Sources
write(*,*) 'Allocate and write core_sources...'

    core_sources%ids_properties%homogeneous_time = 1
    
       
    allocate(core_sources%time(TimeSteps))
    core_sources%time(CurTimeStep) = tt ![s]

    core_sources%vacuum_toroidal_field%r0 = rs0
    AllocIfNull1(core_sources%vacuum_toroidal_field%b0, bt0)
    
    allocate(core_sources%source(15))
isrc = 0
   

isrc = isrc+1 
  core_sources%source(isrc)%identifier%index = 1 ! Total
allocate(core_sources%source(isrc)%profiles_1d(TimeSteps))

  !core_sources%source(isrc)%profiles_1d(CurTimeStep)%time = tt
  
allocate(core_sources%source(isrc)%profiles_1d(CurTimeStep)%grid%rho_tor_norm(n))

  core_sources%source(isrc)%profiles_1d(CurTimeStep)%grid%rho_tor_norm(1:n) = ai_xx(1:n)

allocate(core_sources%source(isrc)%profiles_1d(CurTimeStep)%electrons%energy(n))
allocate(core_sources%source(isrc)%profiles_1d(CurTimeStep)%total_ion_energy(n))
 core_sources%source(isrc)%profiles_1d(CurTimeStep)%electrons%energy(1:n) = qe0(1:n)
 core_sources%source(isrc)%profiles_1d(CurTimeStep)%total_ion_energy(1:n) = qq0(1:n)

allocate(core_sources%source(isrc)%profiles_1d(CurTimeStep)%j_parallel(n))
 core_sources%source(isrc)%profiles_1d(CurTimeStep)%j_parallel(1:n) = aj0(1:n)+ajae(1:n)+jbut(1:n)


isrc = isrc+1 
  core_sources%source(isrc)%identifier%index = 13 ! Bootstrap current
allocate(core_sources%source(isrc)%profiles_1d(TimeSteps))

  !core_sources%source(isrc)%profiles_1d(CurTimeStep)%time = tt
  
allocate(core_sources%source(isrc)%profiles_1d(CurTimeStep)%grid%rho_tor_norm(n))
  core_sources%source(isrc)%profiles_1d(CurTimeStep)%grid%rho_tor_norm(1:n) = ai_xx(1:n)

allocate(core_sources%source(isrc)%profiles_1d(CurTimeStep)%j_parallel(n))
 core_sources%source(isrc)%profiles_1d(CurTimeStep)%j_parallel(1:n) = jbut(1:n)


isrc = isrc+1
  core_sources%source(isrc)%identifier%index = 2 ! NBI
allocate(core_sources%source(isrc)%profiles_1d(TimeSteps))

  !core_sources%source(isrc)%profiles_1d(CurTimeStep)%time = tt
  
allocate(core_sources%source(isrc)%profiles_1d(CurTimeStep)%grid%rho_tor_norm(n))
  core_sources%source(isrc)%profiles_1d(CurTimeStep)%grid%rho_tor_norm(1:n) = ai_xx(1:n)

allocate(core_sources%source(isrc)%profiles_1d(CurTimeStep)%j_parallel(n))
 core_sources%source(isrc)%profiles_1d(CurTimeStep)%j_parallel(1:n) = aj0(1:n) 
 

isrc = isrc+1 
  core_sources%source(isrc)%identifier%index = 3 ! ECRH
allocate(core_sources%source(isrc)%profiles_1d(TimeSteps))

  !core_sources%source(isrc)%profiles_1d(CurTimeStep)%time = tt
  
allocate(core_sources%source(isrc)%profiles_1d(CurTimeStep)%grid%rho_tor_norm(n))
  core_sources%source(isrc)%profiles_1d(CurTimeStep)%grid%rho_tor_norm(1:n) = ai_xx(1:n)
  
allocate(core_sources%source(isrc)%profiles_1d(CurTimeStep)%j_parallel(n))
 core_sources%source(isrc)%profiles_1d(CurTimeStep)%j_parallel(1:n) = ajae(1:n)
 

! Power
 isrc = isrc+1
 core_sources%source(isrc)%identifier%index = 7 ! Ohmic heating
allocate(core_sources%source(isrc)%global_quantities(TimeSteps))
  !core_sources%source(isrc)%global_quantities(CurTimeStep)%time = tt
  core_sources%source(isrc)%global_quantities(CurTimeStep)%power = wr_imas(65) !Pohm


 isrc = isrc+1
 core_sources%source(isrc)%identifier%index = 100 ! Auxiliary systems
allocate(core_sources%source(isrc)%global_quantities(TimeSteps))
  !core_sources%source(isrc)%global_quantities(CurTimeStep)%time = tt
  core_sources%source(isrc)%global_quantities(CurTimeStep)%power = wr_imas(66) !wdop
allocate(core_sources%source(isrc)%profiles_1d(TimeSteps))
  AllocArr(core_sources%source(isrc)%profiles_1d(CurTimeStep)%grid%rho_tor_norm, ai, n)
allocate(core_sources%source(isrc)%profiles_1d(CurTimeStep)%j_parallel(n))
  core_sources%source(isrc)%profiles_1d(CurTimeStep)%j_parallel(1:n) = aj0(1:n)+ajae(1:n)


 isrc = isrc+1
 core_sources%source(isrc)%identifier%index = 6 ! Alfa particles heating
allocate(core_sources%source(isrc)%global_quantities(TimeSteps))
  !core_sources%source(isrc)%global_quantities(CurTimeStep)%time = tt
  core_sources%source(isrc)%global_quantities(CurTimeStep)%power = wr_imas(67) !w_alfa  
  

 isrc = isrc+1
 core_sources%source(isrc)%identifier%index = 200 ! Total radiation
allocate(core_sources%source(isrc)%global_quantities(TimeSteps))
  !core_sources%source(isrc)%global_quantities(CurTimeStep)%time = tt
  core_sources%source(isrc)%global_quantities(CurTimeStep)%power = -wr_imas(91) !w_rad 
 

 isrc = isrc+1
 core_sources%source(isrc)%identifier%index = 203 ! Impurity radiation
allocate(core_sources%source(isrc)%global_quantities(TimeSteps))
  !core_sources%source(isrc)%global_quantities(CurTimeStep)%time = tt
  core_sources%source(isrc)%global_quantities(CurTimeStep)%power = -wr_imas(90) !w_imp 
 

 isrc = isrc+1
 core_sources%source(isrc)%identifier%index = 201 ! Cyclotron radiation
allocate(core_sources%source(isrc)%global_quantities(TimeSteps))
  !core_sources%source(isrc)%global_quantities(CurTimeStep)%time = tt
  core_sources%source(isrc)%global_quantities(CurTimeStep)%power = -wr_imas(85)
 

 isrc = isrc+1
 core_sources%source(isrc)%identifier%index = 8 ! Bremsstrahlung radiation
allocate(core_sources%source(isrc)%global_quantities(TimeSteps))
  !core_sources%source(isrc)%global_quantities(CurTimeStep)%time = tt
  core_sources%source(isrc)%global_quantities(CurTimeStep)%power = -wr_imas(84) !wtor   


! Radiation by species
 isrc = isrc+1
 core_sources%source(isrc)%identifier%index = 203 ! Impurity radiation
allocate(core_sources%source(isrc)%global_quantities(TimeSteps))
  !core_sources%source(isrc)%global_quantities(CurTimeStep)%time = tt
  core_sources%source(isrc)%global_quantities(CurTimeStep)%power = -wr_imas(86) !w_Be  
  core_sources%source(isrc)%species%type%index = 2 ! Ion
  core_sources%source(isrc)%species%ion%z_ion = 4
  !core_sources%source(isrc)%species%ion%label = 'Be'
  allocate(core_sources%source(isrc)%species%ion%element(1))
  core_sources%source(isrc)%species%ion%element(1)%z_n = 4
  core_sources%source(isrc)%species%ion%element(1)%a = 9
  core_sources%source(isrc)%species%ion%element(1)%atoms_n = 1



 isrc = isrc+1
 core_sources%source(isrc)%identifier%index = 203 ! Impurity radiation
allocate(core_sources%source(isrc)%global_quantities(TimeSteps))
  !core_sources%source(isrc)%global_quantities(CurTimeStep)%time = tt
  core_sources%source(isrc)%global_quantities(CurTimeStep)%power = -wr_imas(87) !w_W  
  core_sources%source(isrc)%species%type%index = 2 ! Ion
  core_sources%source(isrc)%species%ion%z_ion = 74
  !core_sources%source(isrc)%species%ion%label = 'W'
  allocate(core_sources%source(isrc)%species%ion%element(1))
  core_sources%source(isrc)%species%ion%element(1)%z_n = 74
  core_sources%source(isrc)%species%ion%element(1)%a = 183.84d0
  core_sources%source(isrc)%species%ion%element(1)%atoms_n = 1
 

 isrc = isrc+1
 core_sources%source(isrc)%identifier%index = 203 ! Impurity radiation
allocate(core_sources%source(isrc)%global_quantities(TimeSteps))
  !core_sources%source(isrc)%global_quantities(CurTimeStep)%time = tt
  core_sources%source(isrc)%global_quantities(CurTimeStep)%power = -wr_imas(88) !w_Ar 
  core_sources%source(isrc)%species%type%index = 2 ! Ion
  core_sources%source(isrc)%species%ion%z_ion = 18
  !core_sources%source(isrc)%species%ion%label = 'Ar'
  allocate(core_sources%source(isrc)%species%ion%element(1))
  core_sources%source(isrc)%species%ion%element(1)%z_n = 18
  core_sources%source(isrc)%species%ion%element(1)%a = 40
  core_sources%source(isrc)%species%ion%element(1)%atoms_n = 1
 

 isrc = isrc+1
 core_sources%source(isrc)%identifier%index = 203 ! Impurity radiation
allocate(core_sources%source(isrc)%global_quantities(TimeSteps))
  !core_sources%source(isrc)%global_quantities(CurTimeStep)%time = tt
  core_sources%source(isrc)%global_quantities(CurTimeStep)%power = -wr_imas(89) !w_Ne 
  core_sources%source(isrc)%species%type%index = 2 ! Ion
  core_sources%source(isrc)%species%ion%z_ion = 10
  !core_sources%source(isrc)%species%ion%label = 'Ne'
  allocate(core_sources%source(isrc)%species%ion%element(1))
  core_sources%source(isrc)%species%ion%element(1)%z_n = 10
  core_sources%source(isrc)%species%ion%element(1)%a = 20
  core_sources%source(isrc)%species%ion%element(1)%atoms_n = 1



 !core_sources%source(isrc)%identifier%index = 108 ! Gas puffing
 !core_sources%source(isrc)%identifier%index = 14 ! Pellet

 
 
!SOLPS
write(*,*) 'Allocate core_transport... '
allocate(core_transport%model(1))
  allocate(core_transport%model(1)%profiles_1d(TimeSteps))
  allocate(core_transport%time(TimeSteps))

  allocate(core_transport%model(1)%profiles_1d(CurTimeStep)%grid_d%rho_tor_norm(n))
  allocate(core_transport%model(1)%profiles_1d(CurTimeStep)%grid_flux%rho_tor_norm(n))
    
  allocate(core_transport%model(1)%profiles_1d(CurTimeStep)%ion(2))


  core_transport%ids_properties%homogeneous_time = 1
  
    
  core_transport%model(1)%profiles_1d(CurTimeStep)%grid_d%rho_tor_norm(1:n) = ai(1:n)
  core_transport%model(1)%profiles_1d(CurTimeStep)%grid_flux%rho_tor_norm(1:n) = ai(1:n)
    
  core_transport%model(1)%profiles_1d(CurTimeStep)%time = tt
  core_transport%time(CurTimeStep) = tt ![s]




write(*,*) 'Write core_transport... '
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
    
    
  !  write(*,*) "psi = ", (equilibrium%profiles_2d(1)%psi(i,1:n2,CurTimeStep),i=1,n)

flush(6)

      apr='++te0-' 
      print 71,apr,(te0(i),i=1,n) 
      apr='++tq0-' 
      print 71,apr,(tq0(i),i=1,n) 
      apr='++pne-' 
      print 71,apr,(pne(i),i=1,n) 
      apr='++pd0-' 
      print 71,apr,(pd0(i),i=1,n) 
      apr='++pt0-' 
      print 71,apr,(pt0(i),i=1,n) 
       apr='++zeff-' 
!      print 71,apr,(zeff(i),i=1,n) 
       apr='++sigma-' 
!      print 71,apr,(sigma(i),i=1,n) 
   
    print *,' end dina_imas'
flush(6)
      
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))


    
error_flag = 0



FillCodeParametersDINA(equilibrium)
FillCodeParametersDINA(magnetics)
FillCodeParametersDINA(pf_active)
FillCodeParametersDINA(pf_passive)
FillCodeParametersDINA(core_profiles)
FillCodeParametersDINA(core_transport)
FillCodeParametersDINA(core_sources)
FillCodeParametersDINA(summary)

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
	
	
	end module dina_imas






