!> dina_green is the subroutine to calculate electromagnetic coupling matrices
!> Inputs: 
!>   pf_active0, pf_passive0, magnetics0 - contain geometry data
!> Outputs: 
!>   em_coupling contains coupling matrices
!>   equilibrium contains r(nr),z(nz) arrays of used 2D grid


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

#define FillCodeParametersGreen(ids) FillCodeParameters(ids, error_flag, codeparam%parameters_value, 'get_em_coupling', 'DINA actor for calculation of the electromagnetic coupling matrices.')


module dina_green

integer :: code_state

contains

subroutine get_em_coupling(&
  & pf_active0, pf_passive0, magnetics0, equilibrium0, &
  & em_coupling, &
  & codeparam,error_flag,error_message)


use ids_schemas
use ids_routines

!implicit none
include 'double.inc'

 type(ids_parameters_input) :: codeparam
 integer, intent(out) :: error_flag
 character(len=:), pointer, intent(out) :: error_message


type (ids_pf_active), INTENT(IN)   :: pf_active0
type (ids_pf_passive), INTENT(IN)  :: pf_passive0
type (ids_magnetics), INTENT(IN)   :: magnetics0
type (ids_equilibrium), INTENT(IN) :: equilibrium0
type (ids_em_coupling), INTENT(OUT) :: em_coupling


include 'parf1'
include 'parf_mike'
include 'parf2'


integer:: i, j, k

integer:: kloop, kprobe, ke=57, ngrid2=-1
!integer,parameter:: nr = 65, nz = 129, nwnh = nr*nz ! parf2
integer:: nact = -1, npass = -1 ! parf1 - kf, mu

real(ids_real) :: x(nr),y(nz)
real(ids_real), dimension(:,:), ALLOCATABLE :: fluxarr,vesarr,pslgreen,bprgreen,pfind,pmj
real(ids_real), dimension(:,:), ALLOCATABLE :: pfc,pfgreen,vesgreen,pfprobe,vesprobe
real(ids_real), dimension(:), ALLOCATABLE :: pfres, rcam, xu, yu
real(ids_real)::  gridrange(4)
real(ids_real), dimension(:), allocatable::  pf_turns

	character *20 apr
	
  interface
    subroutine tokamakdata_read_ids(pf_active, pf_passive, magnetics, equilibrium)
      use ids_schemas
  
      type (ids_pf_active), INTENT(IN)   :: pf_active
      type (ids_pf_passive), INTENT(IN)  :: pf_passive
      type (ids_magnetics), INTENT(IN)   :: magnetics
      type (ids_equilibrium), INTENT(IN) :: equilibrium

    end subroutine
  end interface
                                              

    common /c_tokamak_config1/&
     & npf_c,&
     & npf_res_c,&
     & ncam_c,&
     & kloop_c,&
     & kprobe_c,kpb_c,&
     & ke_c

    common /c_tokamak_config2/&
     & nr_c(mu),nz_c(mu),nt_c(mu),n_pf_num_c(mu),&
     & R_c_c(mu),Z_c_c(mu),dr_c(mu),dz_c(mu),alpha_c(mu),beta_c(mu),&
     & pfres_c(mu),&
     & ndl_ves_c(mu),ndh_ves_c(mu),nt_ves_c(mu),n_ves_num_c(mu),&
     & Rc_c(mu),Zc_c(mu),dl_c(mu),hl_c(mu),alpha_ves_c(mu),&
     & beta_ves_c(mu),&
     & rcam_c(mu),&
     & Rl_c(mu),Zl_c(mu),&
     & R_prob_c(mu),Z_prob_c(mu),anglep_c(mu),smp_c(mu),&
     & xu_c(mu),yu_c(mu),&
     & r00_c,rk_c,&
     & z00_c,zk_c




common &
&  /ge5/kpr

integer:: kpr

!kpr = 1

print *,'DINA GREEN: read tokamak data...'
flush(6)
 !call tokamakdata_read_1()
 call tokamakdata_read_ids(pf_active0, pf_passive0, magnetics0, equilibrium0)

 print *,'DINA GREEN: Calculation...'
 flush(6)
 call congig_calc()

 print *,'DINA GREEN: Mapping matrices...'
 flush(6)
 call read_green_params(npass,nact,kloop,kprobe,ke,ngrid2)


print *,'DINA GREEN:'
print *,'nact, npass =', nact,npass
print *,'kloop, kprobe =', kloop,kprobe
print *,'nwnh ngrid2 =', nwnh,ngrid2
print *,'ke =', ke


ALLOCATE(fluxarr(nwnh,nact))
ALLOCATE(vesarr(nwnh,npass))
ALLOCATE(pslgreen(nwnh,kloop))
ALLOCATE(bprgreen(nwnh,kprobe))

ALLOCATE(vesgreen(kloop,npass))
ALLOCATE(vesprobe(kprobe,npass))

ALLOCATE(pfgreen(kloop,nact))
ALLOCATE(pfprobe(kprobe,nact))

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


flush(6)


	call read_greens(npass,nact,kloop,kprobe,nwnh,&
& 	x,y,&
&	fluxarr,vesarr, pslgreen,bprgreen,&
&	pfind,pmj,pfc, pfres,rcam,&
&	xu,yu,ke,&
&   pfgreen,vesgreen,pfprobe,&
&   vesprobe)
  
  
    
  
  write(*,*) "fluxarr(1:3)=",fluxarr(1,1:3)
  write(*,*) "vesarr(1:3)=",vesarr(1,1:3)
  write(*,*) "pslgreen(1:3)=",pslgreen(1,1:3)
  write(*,*) "bprgreen(1:3)=",bprgreen(1,1:3)
  write(*,*) "pfres(1:3)=",pfres(1:3)
  write(*,*) "rcam(1:3)=",rcam(1:3)

gridrange(1)=y(1)
gridrange(2)=y(nz)
gridrange(3)=x(1)
gridrange(4)=x(nr)

  write(*,*) "gridrange=", gridrange

flush(6)



i=size(pf_active0%coil)
print *,'pf_active0%coil%resistance',i
print *,pf_active0%coil(1:i)%resistance

i=size(pf_passive0%loop)
print *,'pf_passive0%loop%resistance',i
print *,pf_passive0%loop(1:i)%resistance

write(*,100) shape(pf_active0%coil),shape(pf_passive0%loop)

100 format (2I5, 4x,2I5, 4x, 2I5, 4x,2I5)
    
    
    
! Allocation em_coupling

allocate(em_coupling%mutual_passive_passive(npass,npass))
allocate(em_coupling%mutual_plasma_passive(nwnh,npass))
allocate(em_coupling%mutual_loops_passive(kloop,npass))
allocate(em_coupling%b_field_pol_probes_passive(kprobe,npass))

allocate(em_coupling%mutual_active_active(nact,nact))
allocate(em_coupling%mutual_plasma_active(nwnh,nact))
allocate(em_coupling%mutual_loops_active(kloop,nact))
allocate(em_coupling%b_field_pol_probes_active(kprobe,nact))

allocate(em_coupling%mutual_passive_active(npass,nact))

allocate(em_coupling%mutual_loops_plasma(kloop,nwnh))
allocate(em_coupling%b_field_pol_probes_plasma(kprobe,nwnh))



em_coupling%ids_properties%homogeneous_time = 2

print *,' end allocation em_coupling'

flush(6)
  


em_coupling%mutual_passive_passive(1:npass,1:npass) = pmj(1:npass,1:npass)
em_coupling%mutual_plasma_passive(1:nwnh,1:npass) = vesarr(1:nwnh,1:npass)
em_coupling%mutual_loops_passive(1:kloop,1:npass) = vesgreen(1:kloop,1:npass)
em_coupling%b_field_pol_probes_passive(1:kprobe,1:npass) = vesprobe(1:kprobe,1:npass)
do j=1,kloop
  em_coupling%mutual_loops_plasma(j,1:nwnh)=pslgreen(1:nwnh,j)
end do
do j=1,kprobe
  em_coupling%b_field_pol_probes_plasma(j,1:nwnh)=bprgreen(1:nwnh,j)
end do



allocate(pf_turns(nact))
pf_turns(1:nact) = 0.d0
do i=1,nact
  pf_turns(i) = dabs(pf_active0%coil(i)%element(1)%turns_with_sign)
enddo


do i=1,nact
  do j=1,nact
    em_coupling%mutual_active_active(i,j) = pfind(i,j)*pf_turns(i)*pf_turns(j)
  enddo

  em_coupling%mutual_plasma_active(:,i) = fluxarr(1:nwnh,i)*pf_turns(i)
  em_coupling%mutual_loops_active(1:kloop,i) = pfgreen(1:kloop,i)*pf_turns(i)
  em_coupling%b_field_pol_probes_active(1:kprobe,i) = pfprobe(1:kprobe,i)*pf_turns(i)
  em_coupling%mutual_passive_active(:,i) = pfc(1:npass,i)*pf_turns(i)
enddo

allocate(character(len=132):: em_coupling%active_coils(nact))
do i=1,nact
  write(em_coupling%active_coils(i),*) 'coil', i
  !em_coupling%active_coils(i) = 'coil '
enddo

allocate(character(len=132):: em_coupling%passive_loops(npass))
do i=1,npass
  write(em_coupling%passive_loops(i),*) 'loop', i
  !em_coupling%passive_loops(i) = 'loop '
enddo

allocate(character(len=132):: em_coupling%b_field_pol_probes(kprobe))
do i=1,kprobe
  write(em_coupling%b_field_pol_probes(i),*) 'probe', i
enddo

allocate(character(len=132):: em_coupling%flux_loops(kloop))
do i=1,kloop
  write(em_coupling%flux_loops(i),*) 'loop', i
enddo

allocate(character(len=132):: em_coupling%plasma_elements(nwnh))
do i=1,nwnh
  write(em_coupling%plasma_elements(i),*) 'ngrid', i
enddo

print *,' em_coupling filled'
flush(6)

error_flag = 0

FillCodeParametersGreen(em_coupling)

return
end


subroutine get_status(state_str, status_code, status_message)
  implicit none
  character(len=:), allocatable, intent(out) :: state_str
  integer, intent(out) :: status_code
  character(len=:), pointer, intent(out) :: status_message

  status_message = 'OK'
  status_code = 0
  allocate(character(50):: state_str)
  write(state_str,*) code_state
end subroutine get_status


end module dina_green



