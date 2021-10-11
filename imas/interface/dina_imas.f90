!> dina_imas is the main subroutine to connect DINA input-output data with IMAS
!> As a result of call dina_v96_in the Green Functions are being transmitted to DINA from IDSs
!> After call dina_input the initial kinetic profiles are being transmitted to DINA from IDSs   
!> As a result of call dina_0 and then call dina2 the DINA modeling in one time step is being produced
!> After call dina_outp the output data are being recorded to IDS and dat files

#ifdef __GFORTRAN__


#define AllocIfNull(array, size)  if (.NOT.associated(array)) allocate(array(size))

#define AllocIfNull1(array, value)  if (.NOT.associated(array)) allocate(array(1)) ; \
                                    array(1) = value

#define AllocArr(array, value, size)  if (.NOT.associated(array)) allocate(array(size)) ; \
                                    array(1:size) = value(1:size)
                                    
                                    
#else


#define AllocIfNull(array, size)  if (.NOT.associated(#array)) allocate(#array(#size))

#define AllocIfNull1(array, value)  if (.NOT.associated(#array)) allocate(#array(1)) ; \
                                    #array(1) = #value

#define AllocArr(array, value, size)  if (.NOT.associated(#array)) allocate(#array(#size)) ; \
                                    #array(1:#size) = #value(1:#size)
                                    
                                    
#endif



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


!integer, parameter :: DP = kind(1.0d0)
real (ids_real) :: arr_in1(*), arr_out1(*)


! define local fixed size variables
integer,save :: i, k, j, isrc, ion
integer,save :: first_call = 1, loop_count = 0, ntime = 0

integer,save :: kloop,kprobe, ke=57, ngrid2

integer,save :: nact=30, npass=300 , nelem = 1

integer,save :: n_input1, n_input2, ng
integer,save :: n_output1, n_output2

          
integer ::  kpr

      common /ge5/kpr

integer   ::  ih_imas
     common /c_imas_is/ih_imas
integer   ::  ih_imas_c
     common /c_k_jetto/ih_imas_c


integer,save :: key(27)=(/ (0,i=1,27) /)

! static and prescribed data expressed in DINA terms
real (ids_real),save :: dina_time=0
real (ids_real),save :: time_8,tt_8,tay_8

real(ids_real) ::time_eq

     common /c_imas_time_eq/time_eq
      common /c_time_eq/time_eq_c
      
      
real(ids_real) ::time_eq_c

! DINA parameters
    integer,parameter :: npo = 310, ntet = 134 ! parf0
    integer,parameter :: mu1 = 1500 ! parf2
    integer,parameter :: nr = 65, nz = 129, ngrid = nr*nz ! parf2
    integer,parameter :: npf = 15, ncam = 100 ! parf1 - kf, mu
    integer,parameter :: npfa = 12, npfx = npf-npfa, npfp = npfx+ncam
    integer,parameter :: nflux=41, nbpol=60 ! parf4
    integer,parameter ::  n_gaps=6
    
    integer :: ksepa,n_bnd,n_sep,n_sep2


real (ids_real),save :: vec(npo) = (/ (0,i=1,npo) /)

! dynamic inputs and outputs groups
real (ids_real),save :: input_1(npo) = (/ (0,i=1,npo) /)
real (ids_real),save :: input_2(npo) = (/ (0,i=1,npo) /)
real (ids_real),save :: input_3(npo) = (/ (0,i=1,npo) /)

real (ids_real),save :: output_1(npo) = (/ (0,i=1,npo) /)
real (ids_real),save :: output_2(npo) = (/ (0,i=1,npo) /)
real (ids_real),save :: output_3(npo) = (/ (0,i=1,npo) /)
real (ids_real),save :: output_4(npo) = (/ (0,i=1,npo) /)

    
    real(ids_real) :: tpl=1000.0,uli=1000.0,v=1000.0,parea=1000.0,psi_ax=1000.0,rmag=1000.0,zmag=1000.0 &
  & ,q_ax=1000.0,q_95=1000.0,rs0=1000.0,bt0=1000.0,wen2=1000.0,tt = 1.0,psi_bnd = 1000.0,psi_sep, psi_sep2 &
  & ,rmajor,rminor,elong,tri
  

    real(ids_real) :: betap,betat,tec,tqc,pec,pic,palf,zeff0,vloop,tene,teit_98,wfus,emag

    real(ids_real) :: x(nr),y(nz),psi(nr,nz),psi1(nr,nz),curr_d(nr,nz)

    real(ids_real) :: ai(npo),psi_1D(npo),te0(npo),tq0(npo),pne(npo),tok1(npo),q(npo)

    real(ids_real) :: pd0(npo),pt0(npo),sigk(npo),jbut(npo),aj0(npo),ajae(npo),zeff(npo),press(npo),qe0(npo),qq0(npo)
    
    real(ids_real) :: xbound(ntet),ybound(ntet),x_sep(mu1),y_sep(mu1),x_sep2(mu1),y_sep2(mu1), gaps(n_gaps),dsep
    
    real(ids_real) :: vchopper(npf),pf(npf),tcam(ncam)

    real(ids_real) :: fpol(npo),pptab(npo),fptab(npo),phi_1D(npo)

    !real(ids_real) :: Pohm,wdop,w_alfa,wtor, w_Be,w_W,w_Ar,w_Ne, w_imp,w_rad,w_heat
    real(ids_real) :: wr_imas(150)
    
    real(ids_real) :: p_sep,greenwald,gfus,qtep
    
    real(ids_real),parameter :: pi = 3.14159265358979323846
    
    real(ids_real) :: coef_ppx,coef_pffx,pmu0
    
    real(ids_real) :: bprobe(nbpol), psloop(nflux)
    
    real(ids_real) :: surface_1d(npo),volume_1d(npo),area_1d(npo)
    
    real(ids_real) :: dsep_ref


  integer :: TimeSteps, CurTimeStep
  
  integer :: n1, n2, n ,i_wr

real (ids_real),save ::  gridrange(4)
real(ids_real), dimension(:,:), ALLOCATABLE,save :: fluxarr,vesarr,pslgreen,bprgreen,pfind,pmj
real(ids_real), dimension(:,:), ALLOCATABLE,save :: pfc,pfgreen,vesgreen,pfprobe,vesprobe
real(ids_real), dimension(:), ALLOCATABLE,save :: pfres, rcam, xu, yu

real(ids_real),save :: cpu_old = 0.d0, cpu_new

real(ids_real) :: yfluxd_xx,yfluxt_xx,yfluxe_xx,yfluxi_xx,ysbound_xx

real(ids_real) :: pne_cop(npo),pd0_cop(npo),pt0_cop(npo)
 
	character *20 apr

	
real(ids_real) :: cocos_psi = -1.d0



print *,'DINA_IMAS Enter'
flush(6)



call ids_copy(pf_active0, pf_active)
call ids_copy(pf_passive0, pf_passive)
call ids_copy(magnetics0, magnetics)
!call ids_copy(equilibrium0, equilibrium)
!call ids_copy(core_profiles0, core_profiles)
!call ids_copy(core_sources0, core_sources)
!call ids_copy(em_coupling0, em_coupling)



if (first_call == 1) then ! convert input trees to local variables before calling dina

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
call system(" pwd")



!call schedulefiles(pulse_schedule,equilibrium0)
!print *,'schedulefiles written!'


!call fp_test()

 call dina_data_read()
 call general_data_read()

 call congig_calc()

       call  read_green_params(&
&      npass,nact,kloop,kprobe,ke,ngrid2)

        

print *,'nact',nact
print *,'npass',npass
print *,'kprobe',kprobe
print *,'ngrid ngrid2',ngrid,ngrid2

if(ngrid .ne.ngrid2)then
print *,'ngrid NE ngrid2',ngrid,ngrid2
stop
end if


!nact=size(em_coupling0%mutual_grid_active,2)
!print *,'size em_coupling0%mutual_grid_active',nact
!npass=size(em_coupling0%mutual_grid_passive,2)
!print *,'size em_coupling0%mutual_grid_passive',npass

!kloop=size(em_coupling0%mutual_loops_grid,1)
!print *,'em_coupling0%mutual_loops_grid 1',kloop
!kprobe=size(em_coupling0%field_probes_grid,1)
!print *,'em_coupling0%field_probes_grid 1',kprobe

!ke=size(equilibrium0%time_slice(1)%coordinate_system%r,1)
!print *,'equilibrium0%coordinate_system%r 1',ke


ALLOCATE(fluxarr(ngrid,nact))
ALLOCATE(vesarr(ngrid,npass))
ALLOCATE(pslgreen(ngrid,kloop))
ALLOCATE(bprgreen(ngrid,kprobe))

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


write(*,*) 'Entering DINA_IMAS, first_call = ', first_call, loop_count, dina_time

flush(6)


	call read_greens(npass,nact,kloop,kprobe,ngrid2,&
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

  flush(6)


if(.NOT.associated(pf_active%time)) then
    allocate(pf_active%time(1))
endif
pf_active%ids_properties%homogeneous_time = 1

if(.NOT.associated(pf_active%coil)) then
    allocate(pf_active%coil(npfa))
    do i=1,npfa

        allocate(pf_active%coil(i)%current%data(1))
!         allocate(pf_active%coil(i)%current%time(1))

        allocate(pf_active%coil(i)%voltage%data(1))
!         allocate(pf_active%coil(i)%voltage%time(1))
    enddo
endif



if(.NOT.associated(pf_passive%time)) then
    allocate(pf_passive%time(1))
endif
pf_passive%ids_properties%homogeneous_time = 1


if(.NOT.associated(pf_passive%loop)) then
    allocate(pf_passive%loop(npfp))
    do i=1,npfp

	allocate(pf_passive%loop(i)%current(1))

    enddo
endif



print*, 'npfa, npfp =', npfa, npfp
print *,' pf_active%coil size ', size(pf_active%coil)
print *,' pf_passive%loop size ', size(pf_passive%loop)
flush(6)

print *,' pfs resistances...'
flush(6)

pf_active%coil(1:npfa)%resistance = pfres(1:npfa)
pf_passive%loop(1:npfx)%resistance = pfres(npfa+1:nact)
pf_passive%loop(npfx+1:npfp)%resistance = rcam(1:npass)  

print *,' pfs filled'
flush(6)


! equilibrium0%ids_properties%homogeneous_time = 1
! 
! equilibrium0%time_slice(1)%time = 0.0
! equilibrium0%time(1) = equilibrium0%time_slice(1)%time
! 
! allocate(equilibrium0%time_slice(1)%coordinate_system%grid%dim1(nr))
! allocate(equilibrium0%time_slice(1)%coordinate_system%grid%dim2(nz))
! 
! allocate(equilibrium0%time_slice(1)%coordinate_system%r(ke, 1))
! allocate(equilibrium0%time_slice(1)%coordinate_system%z(ke, 1))
! 
!     equilibrium0%time_slice(1)%coordinate_system%grid%dim1(1:nr)=x(1:nr) ![m]
!     equilibrium0%time_slice(1)%coordinate_system%grid%dim2(1:nz)=y(1:nz) ![m]
! 
! 
!     equilibrium0%time_slice(1)%coordinate_system%r(1:ke,1)=xu(1:ke)
!     equilibrium0%time_slice(1)%coordinate_system%z(1:ke,1)=yu(1:ke)
! 
! 
! print *,' equilibrium filled'
! flush(6)

    
i=size(em_coupling%mutual_loops_grid,1)
print *,'em_coupling%mutual_loops_grid',i

i=size(em_coupling%field_probes_grid,1)
print *,'em_coupling%field_probes_grid',i



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


  write(*,*) "limiterxu(1:3)=", xu(1:3)
  write(*,*) "limiteryu(1:3)=", yu(1:3)
  write(*,*) "gridrange=",gridrange

flush(6)

! stop



i=size(pf_active%coil%resistance)
print *,'pf_active%coil%resistance',i

print *,pf_active%coil(1:npfa)%resistance

i=size(pf_passive%loop%resistance)
print *,'pf_passive%loop%resistance',i
print *,pf_passive%loop(1:npfp)%resistance

write(*,100) shape(pf_active%coil%resistance),shape(pf_passive%loop%resistance)



 write(*,*) 'DINAIMAS - CoreProfiles Elements: '
    allocate(core_profiles0%profiles_1d(1))
    allocate(core_profiles0%time(1))
    core_profiles0%ids_properties%homogeneous_time = 1
    core_profiles0%time(1) = 0.d0

write(*,*) "End of static data extraction"

call write_cputime(0.d0, 0.d0, 1)

  write(*,*) "pfres(1:3)=",pfres(1:3)
  write(*,*) "rcam(1:3)=",rcam(1:3)
  write(*,*) "limiterxu(1:3)=", xu(1:3)
  write(*,*) "limiteryu(1:3)=", yu(1:3)
  write(*,*) "gridrange=",gridrange

100 format (2I5, 4x,2I5, 4x, 2I5, 4x,2I5)





     call  dina_v96_in(ncam,npf,kloop,kprobe,&
& 	gridrange,nact,npass,&
&	fluxarr,vesarr, pslgreen,bprgreen,&
&	pfind,pmj,pfc, pfres,rcam,&
&	xu,yu,ke,key,&
&   pfgreen,vesgreen,pfprobe,&
&   vesprobe,ngrid)



first_call = first_call+1 ! cancel the initialisation for the next call

!    kpr=1
! 		 open (unit=41,file='k_jetto.dat',form='formatted') 
! 		 open (unit=49,file='dina_data.dat',form='formatted') 
!          read (49,*) 
!          read (49,*)ih_imas
          ih_imas=ih_imas_c
 !        close (49)
         
        print *,'from k_jetto.dat  ih_imas =',ih_imas

! 		 open (unit=40,file='time_eq.dat',form='formatted') 
!          read (49,*) 
!          read (49,*)time_eq
          time_eq=time_eq_c
!         close (41)
         
        print *,'from time_eq.dat  time_eq =',time_eq

!    ih_imas=1
!    if (ih_imas.eq.1) then
	call ids_prof_jetto()
!   end if
!stop

else

write(*,*) 'dina_input prepare...'

n1 = size(core_profiles0%profiles_1d(1)%grid%rho_tor_norm)

n=n1

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

if (associated(bndcond_in%solver_1d)) then
    write(*,*) 'dina_imas : boundary conditions are found'
 te0(n1) = bndcond_in%solver_1d(1)%equation(1)%boundary_condition(1)%value(1)
 tq0(n1) = bndcond_in%solver_1d(1)%equation(3)%boundary_condition(1)%value(1)
 
     write(*,*) 'te0(n1) tq0(n1)= ', &
    & te0(n1),tq0(n1)

      call solpsza_example_in(te0(n1),tq0(n1))


end if

!Transp2
 pne(1:n1) = core_profiles0%profiles_1d(1)%electrons%density(1:n1)
 pd0(1:n1) = core_profiles0%profiles_1d(1)%ion(1)%density(1:n1)
 pt0(1:n1) = core_profiles0%profiles_1d(1)%ion(2)%density(1:n1)
 
 pne_cop(1:n1) = pne(1:n1) 
 pd0_cop(1:n1) = pd0(1:n1) 
 pt0_cop(1:n1) = pt0(1:n1) 
 
      apr='--&pne-' 
      print 71,apr,(pne(i),i=1,n1) 
      apr='--&pd0-' 
      print 71,apr,(pd0(i),i=1,n1) 
      apr='--&pt0-' 
      print 71,apr,(pt0(i),i=1,n1) 
!Transp3
 jbut(1:n1) = core_profiles0%profiles_1d(1)%j_bootstrap(1:n1)
 sigk(1:n1) = core_profiles0%profiles_1d(1)%conductivity_parallel(1:n1)
!Transp4
 aj0(1:n1) = core_profiles0%profiles_1d(1)%j_non_inductive(1:n1) - core_profiles0%profiles_1d(1)%j_bootstrap(1:n1)
!Sources
 qe0(1:n1) = core_sources0%source(1)%profiles_1d(1)%electrons%energy(1:n1)
 qq0(1:n1) = core_sources0%source(1)%profiles_1d(1)%total_ion_energy(1:n1)

      apr='--qe0-' 
      print 71,apr,(qe0(i),i=1,n1) 
      apr='--qq0-' 
      print 71,apr,(qq0(i),i=1,n1) 

!  If we will use external IDS we will need dina_input(
!write(*,*) 'dina_input enter...'

	call dina_input(te0,tq0,pne, &
     & pd0,pt0,sigk,jbut,aj0,qe0,qq0)


end if ! end of first_call



loop_count = loop_count + 1 ! number of times the iterative routine was entered

write(*,*) 'dina_imas first_call, loop = ', first_call, loop_count



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


write(*,*) '!!!dina0 enter'
	call dina_0(time_8,tt_8,tay_8,key,vec, &
     &	input_1,input_2,input_3, &
     &	output_1,output_2,output_3,output_4,ng)


        !print *,' teit_98==',teit_98
        

write(*,*) '!!!dina_outp enter'
	call dina_outp(n,  &
     & tpl,uli,v,parea,psi_ax,rmag,zmag,  &
     & q_ax,q_95,rs0,bt0,wen2,tt,  &
     & ai,psi_1D,te0,tq0,pne,tok1,q,  &
     & x,y,psi,psi_bnd,psi_sep,curr_d,  &
     & ksepa,rmajor,rminor,elong,tri,gaps,dsep, &
     & pd0,pt0,sigk,jbut,aj0,ajae,zeff,press,qe0,qq0, &
     & betap,betat,tec,tqc,pec,pic,palf,zeff0,vloop,tene,teit_98,wfus,emag, &
     & vchopper,pf,tcam, &
     & fpol,pptab,fptab,phi_1D, &
     & n_bnd,xbound,ybound, n_sep,x_sep,y_sep, n_sep2,x_sep2,y_sep2, &
     & bprobe,psloop,&
     & surface_1d,volume_1d,area_1d, &
     & psi_sep2)
     

        call dina_wr_output(wr_imas)
        
       
        

write(*,*) '!!!solpsza enter'
      call solpsza_example(yfluxd_xx,yfluxt_xx,yfluxe_xx,yfluxi_xx,ysbound_xx)

    write(*,*) 'yfluxd_xx,yfluxt_xx,yfluxe_xx,yfluxi_xx,ysbound_xx= ', &
    & yfluxd_xx,yfluxt_xx,yfluxe_xx,yfluxi_xx,ysbound_xx

    dina_time=tt
 
    write(*,*) 'dina_outp call n tpl tt= ', n,tpl,tt


    flush(6)
    
    
    
    psi_ax = psi_ax*cocos_psi
    psi_bnd = psi_bnd*cocos_psi
    psi_sep = psi_sep*cocos_psi
    psi_sep2 = psi_sep2*cocos_psi
    psi = psi*cocos_psi
    psi_1D = psi_1D*cocos_psi
    psloop = psloop*cocos_psi
    pptab = pptab*cocos_psi
    fptab = fptab*cocos_psi
    
    
!write(*,*) "output_1",output_1

      n_output1=15

      do i=1,n_output1
	  arr_out1(i)=output_1(i)
      end do


      n_output2=n_gaps+npf+ncam

      
      
      ! dsep control
      if ((tt.gt.70.d0).and.(dabs(tpl).gt.14.5d6)) then
        dsep_ref = 3.6d-2
        !output_2(4) = output_2(4) - 10.d0*(dsep-dsep_ref)
      end if
      
      
      
      do i=1,n_output2
	  arr_out1(n_output1+i)=output_2(i)
      end do


!write(*,*) "-dina inp=",arr_in1(1:n_input1+n_input2)
!write(*,*) "dina out=",arr_out1(1:n_output1+n_output2)
    


	call cpu_time(cpu_new)

	write(*,*) 'CPUTime = ', cpu_new-cpu_old

	call write_cputime(cpu_new-cpu_old, cpu_new, 0)

	cpu_old = cpu_new



! Allocation em_coupling

allocate(em_coupling%mutual_passive_passive(npass,npass))
allocate(em_coupling%mutual_grid_passive(ngrid,npass))
allocate(em_coupling%mutual_loops_passive(kloop,npass))
allocate(em_coupling%field_probes_passive(kprobe,npass))

allocate(em_coupling%mutual_active_active(nact,nact))
allocate(em_coupling%mutual_grid_active(ngrid,nact))
allocate(em_coupling%mutual_loops_active(kloop,nact))
allocate(em_coupling%field_probes_active(kprobe,nact))

allocate(em_coupling%mutual_passive_active(npass,nact))

allocate(em_coupling%mutual_loops_grid(kloop,ngrid))
allocate(em_coupling%field_probes_grid(kprobe,ngrid))



em_coupling%ids_properties%homogeneous_time = 1
allocate(em_coupling%time(1))
em_coupling%time(1) = dina_time

print *,' end allocation em_coupling'

flush(6)


!Rearrange nact to npfa, npass to npfp



em_coupling%mutual_passive_passive = pmj(1:npass,1:npass)
em_coupling%mutual_grid_passive = vesarr(1:ngrid,1:npass)
em_coupling%mutual_loops_passive = vesgreen(1:kloop,1:npass)
em_coupling%field_probes_passive = vesprobe(1:kprobe,1:npass)

em_coupling%mutual_active_active = pfind(1:nact,1:nact) 
em_coupling%mutual_grid_active = fluxarr(1:ngrid,1:nact)
em_coupling%mutual_loops_active = pfgreen(1:kloop,1:nact)
em_coupling%field_probes_active = pfprobe(1:kprobe,1:nact)

em_coupling%mutual_passive_active = pfc(1:npass,1:nact)

do j=1,kloop
  em_coupling%mutual_loops_grid(j,1:ngrid)=pslgreen(1:ngrid,j)
end do
do j=1,kprobe
  em_coupling%field_probes_grid(j,1:ngrid)=bprgreen(1:ngrid,j)
end do




print *,' em_coupling filled'
flush(6)	
	
	


! Magnetics

magnetics%ids_properties%homogeneous_time = 1

if (.NOT.associated(magnetics%time)) allocate(magnetics%time(1))
magnetics%time(1) = dina_time

! Loops
if (.NOT.associated(magnetics%flux_loop)) allocate(magnetics%flux_loop(kloop))
do i=1,kloop
  if (.NOT.associated(magnetics%flux_loop(i)%flux%data)) allocate(magnetics%flux_loop(i)%flux%data(1))
  magnetics%flux_loop(i)%flux%data(1) = psloop(i)
end do

  
! Probes  
if (.NOT.associated(magnetics%b_field_pol_probe)) allocate(magnetics%b_field_pol_probe(kprobe))
do i=1,kprobe
  if (.NOT.associated(magnetics%b_field_pol_probe(i)%field%data)) allocate(magnetics%b_field_pol_probe(i)%field%data(1))
  magnetics%b_field_pol_probe(i)%field%data(1) = bprobe(i)
end do

  

!write(*,*) '!!!ids_copy pf_active0 enter'
!call ids_copy(pf_active0,pf_active)
!write(*,*) '!!!ids_copy pf_active0 exit'
!write(*,*) '!!!ids_copy pf_passive0 enter'
!call ids_copy(pf_passive0,pf_passive)
!write(*,*) '!!!ids_copy pf_passive0 exit'



print *,' nact=',nact
! do i=1,npfa
! 
!         allocate(pf_active%coil(i)%current%data(1))
! !        allocate(pf_active%coil(i)%current%time(1))
! 
!         allocate(pf_active%coil(i)%voltage%data(1))
! !        allocate(pf_active%coil(i)%voltage%time(1))
! enddo
! 
! allocate(pf_active%time(1))


pf_active%ids_properties%homogeneous_time = 1
!if (.NOT.associated(pf_active%time)) allocate(pf_active%time(1))
  pf_active%time(1) = dina_time

  
  
!pf_active%global_quantities%psi_coils_list(:)
if(.NOT.associated(pf_active%global_quantities%psi_coils_average)) allocate(pf_active%global_quantities%psi_coils_average(1))
if(.NOT.associated(pf_active%global_quantities%time)) allocate(pf_active%global_quantities%time(1))

pf_active%global_quantities%psi_coils_average(1) = wr_imas(33)
pf_active%global_quantities%time(1) = dina_time
  
  
  
  
!if (.NOT.associated(pf_active%coil)) allocate(pf_active%coil(npfa))
do i=1,npfa
  !if (.NOT.associated(pf_active%coil(i)%current%data)) allocate(pf_active%coil(i)%current%data(1))
    pf_active%coil(i)%current%data(1) = pf(i)
  !if (.NOT.associated(pf_active%coil(i)%voltage%data)) allocate(pf_active%coil(i)%voltage%data(1))
    pf_active%coil(i)%voltage%data(1) = vchopper(i)
enddo


!VS3
  pf_active%coil(12)%current%data(1) = wr_imas(59)
  pf_active%coil(12)%voltage%data(1) = wr_imas(62)



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





print *,' npass=',npass
    
! do i=1,npfp
!     allocate(pf_passive%loop(i)%current(1))
! end do
! 
! allocate(pf_passive%time(1))


pf_passive%ids_properties%homogeneous_time = 1
!if (.NOT.associated(pf_passive%time)) allocate(pf_passive%time(1))
pf_passive%time(1) = dina_time

!if (.NOT.associated(pf_passive%loop)) allocate(pf_passive%loop(npfp))
do i=1,npfx
  j = i
  !if (.NOT.associated(pf_passive%loop(j)%current)) allocate(pf_passive%loop(j)%current(1))
    pf_passive%loop(j)%current(1) = pf(npfa+i)
end do
do i=1,ncam
  j = npfx+i
  !if (.NOT.associated(pf_passive%loop(j)%current)) allocate(pf_passive%loop(j)%current(1))
    pf_passive%loop(j)%current(1) = tcam(i)
end do



flush(6)
   
! Work with IDS

    TimeSteps = 1 ! One time step filled for put_slice function
    CurTimeStep = 1


! Allocations summary
if(.NOT.associated(summary%time)) then 
  allocate(summary%time(TimeSteps))
  print *,'dina_imas summary reallocation, loop_count = ', loop_count
endif



! Filling summary
summary%ids_properties%homogeneous_time = 1
summary%time(CurTimeStep) = tt;

print *,' teit_98 tene tqc==',teit_98,tene, tqc


AllocIfNull1(summary%global_quantities%ip%value, tpl)
AllocIfNull1(summary%global_quantities%v_loop%value, wr_imas(29))
AllocIfNull1(summary%global_quantities%li%value, uli)
AllocIfNull1(summary%global_quantities%greenwald_fraction%value, wr_imas(22))

AllocIfNull1(summary%global_quantities%beta_pol%value, betap)
AllocIfNull1(summary%global_quantities%beta_tor%value, betat)

AllocIfNull1(summary%global_quantities%energy_thermal%value, wr_imas(76))
AllocIfNull1(summary%global_quantities%energy_b_field_pol%value, wr_imas(74))

AllocIfNull1(summary%global_quantities%tau_energy%value, wr_imas(93))
AllocIfNull1(summary%global_quantities%tau_energy_98%value, teit_98)

AllocIfNull1(summary%global_quantities%fusion_gain%value, wr_imas(70))
AllocIfNull1(summary%global_quantities%fusion_fluence%value, wr_imas(69))

AllocIfNull1(summary%global_quantities%volume%value, v)
!AllocIfNull1(summary%global_quantities%h_mode%value, v)

summary%global_quantities%r0%value = rs0
AllocIfNull1(summary%global_quantities%b0%value, bt0)

AllocIfNull1(summary%global_quantities%resistance%value, wr_imas(77))
AllocIfNull1(summary%global_quantities%q_95%value, wr_imas(17))
AllocIfNull1(summary%global_quantities%power_ohm%value, wr_imas(65))
AllocIfNull1(summary%global_quantities%power_radiated_inside_lcfs%value, wr_imas(91))
AllocIfNull1(summary%global_quantities%power_bremsstrahlung%value, wr_imas(84))
!AllocIfNull1(summary%global_quantities%power_synchrotron%value, wr_imas(85)) !Should be cyclotron
AllocIfNull1(summary%global_quantities%power_loss%value, wr_imas(92))



AllocIfNull1(summary%local%magnetic_axis%position%r, rmag)
AllocIfNull1(summary%local%magnetic_axis%position%z, zmag)

AllocIfNull1(summary%local%magnetic_axis%position%psi, psi_ax)
AllocIfNull1(summary%local%magnetic_axis%position%rho_tor_norm, ai(1))
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
AllocIfNull1(summary%local%magnetic_axis%n_i%argon%value, wr_imas(88)*pne(1))
AllocIfNull1(summary%local%magnetic_axis%n_i%neon%value, wr_imas(89)*pne(1))

AllocIfNull1(summary%local%separatrix%position%psi, psi_sep)
AllocIfNull1(summary%local%separatrix%position%rho_tor_norm, ai(n))
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
AllocIfNull1(summary%local%separatrix%n_i%argon%value, wr_imas(88)*pne(n))
AllocIfNull1(summary%local%separatrix%n_i%neon%value, wr_imas(89)*pne(n))


AllocIfNull1(summary%boundary%type%value, ksepa)
AllocIfNull1(summary%boundary%gap_limiter_wall%value, wr_imas(101))
AllocIfNull1(summary%boundary%magnetic_axis_r%value, wr_imas(13))
AllocIfNull1(summary%boundary%magnetic_axis_z%value, wr_imas(14))
AllocIfNull1(summary%boundary%minor_radius%value, rminor)
AllocIfNull1(summary%boundary%elongation%value, elong)


AllocIfNull1(summary%volume_average%zeff%value, zeff0)
AllocIfNull1(summary%volume_average%t_e%value, wr_imas(24))
AllocIfNull1(summary%volume_average%t_i_average%value, wr_imas(26))
AllocIfNull1(summary%volume_average%n_e%value, pec)
AllocIfNull1(summary%volume_average%n_i_total%value, pic)
AllocIfNull1(summary%volume_average%n_i%helium_4%value, palf)
AllocIfNull1(summary%volume_average%n_i%beryllium%value, wr_imas(80)*pec)
AllocIfNull1(summary%volume_average%n_i%tungsten%value, wr_imas(81)*pec)
AllocIfNull1(summary%volume_average%n_i%argon%value, wr_imas(88)*pec)
AllocIfNull1(summary%volume_average%n_i%neon%value, wr_imas(89)*pec)

write(*,*) 'summary%volume_average%n_i_total%value... ',summary%volume_average%n_i_total%value(CurTimeStep)


AllocIfNull1(summary%fusion%power%value, wfus)
!summary%fusion%neutron_power_total%value(CurTimeStep) = ???

AllocIfNull1(summary%heating_current_drive%power_additional%value, wr_imas(66))




! Filling equilibrium
    allocate(equilibrium%time_slice(TimeSteps))
    allocate(equilibrium%time(TimeSteps))
    equilibrium%ids_properties%homogeneous_time = 1
    equilibrium%time_slice(CurTimeStep)%time = tt
    equilibrium%time(CurTimeStep) = tt ![s]  
  
! 0D Quantities
        equilibrium%time_slice(CurTimeStep)%global_quantities%ip = tpl ![A]
        equilibrium%time_slice(CurTimeStep)%global_quantities%li_3 = uli
        equilibrium%time_slice(CurTimeStep)%global_quantities%beta_pol = betap
        equilibrium%time_slice(CurTimeStep)%global_quantities%beta_tor = betat

        equilibrium%time_slice(CurTimeStep)%global_quantities%volume = v ![m3]
        equilibrium%time_slice(CurTimeStep)%global_quantities%area = parea ![m2]
        equilibrium%time_slice(CurTimeStep)%global_quantities%surface = ysbound_xx ! [m²]
        equilibrium%time_slice(CurTimeStep)%global_quantities%psi_axis= psi_ax ![Wb]
        equilibrium%time_slice(CurTimeStep)%global_quantities%psi_boundary = psi_bnd ![Wb]

        equilibrium%time_slice(CurTimeStep)%global_quantities%magnetic_axis%r = wr_imas(13) ![m]
        equilibrium%time_slice(CurTimeStep)%global_quantities%magnetic_axis%z = wr_imas(14) ![m]
        equilibrium%time_slice(CurTimeStep)%global_quantities%current_centre%r = wr_imas(10) ![m]
        equilibrium%time_slice(CurTimeStep)%global_quantities%current_centre%z = wr_imas(11) ![m]       
        equilibrium%time_slice(CurTimeStep)%global_quantities%current_centre%velocity_z = wr_imas(12) ![m]

        equilibrium%time_slice(CurTimeStep)%global_quantities%q_axis = wr_imas(18)
        equilibrium%time_slice(CurTimeStep)%global_quantities%q_95 = wr_imas(17)
        equilibrium%time_slice(CurTimeStep)%global_quantities%energy_mhd = wr_imas(76) ![J]
        equilibrium%time_slice(CurTimeStep)%global_quantities%psi_external_average = wr_imas(32) ! [Wb]
        equilibrium%time_slice(CurTimeStep)%global_quantities%plasma_inductance = wr_imas(75) ! [H]


        equilibrium%vacuum_toroidal_field%r0 = rs0 ![m]
        allocate(equilibrium%vacuum_toroidal_field%b0(TimeSteps))
          equilibrium%vacuum_toroidal_field%b0(CurTimeStep) = bt0 ![T]
  
  
        
        ! Plasma boundary
        equilibrium%time_slice(CurTimeStep)%boundary%type = ksepa ! 0 is limiter, 1 is diverted
        equilibrium%time_slice(CurTimeStep)%boundary%psi = psi_bnd ![Wb]
        equilibrium%time_slice(CurTimeStep)%boundary%geometric_axis%r = rmajor
        equilibrium%time_slice(CurTimeStep)%boundary%minor_radius = rminor
        equilibrium%time_slice(CurTimeStep)%boundary%elongation = elong
        equilibrium%time_slice(CurTimeStep)%boundary%triangularity = tri
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
                   
        else
          ! Diverted plasma
          equilibrium%time_slice(CurTimeStep)%boundary_separatrix%active_limiter_point%r = wr_imas(102) ! Closest wall point
          equilibrium%time_slice(CurTimeStep)%boundary_separatrix%active_limiter_point%z = wr_imas(103)
          
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
        allocate(equilibrium%time_slice(CurTimeStep)%boundary_separatrix%gap(24+n_gaps+1))
        do i=1,24
          equilibrium%time_slice(CurTimeStep)%boundary_separatrix%gap(i)%value = wr_imas(105+i)
        enddo
        do i=1,n_gaps
          equilibrium%time_slice(CurTimeStep)%boundary_separatrix%gap(24+i)%value = gaps(i)
        enddo
        !equilibrium%time_slice(CurTimeStep)%boundary_separatrix%gap(24+n_gaps+1)%value = dsep
       
        ! Outer separatrix
        equilibrium%time_slice(CurTimeStep)%boundary_secondary_separatrix%psi = psi_sep2
        equilibrium%time_slice(CurTimeStep)%boundary_secondary_separatrix%distance_inner_outer = dsep

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
    
    equilibrium%time_slice(CurTimeStep)%profiles_1d%rho_tor_norm(1:n) = ai(1:n)
    equilibrium%time_slice(CurTimeStep)%profiles_1d%psi(1:n) = psi_1D(1:n)

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
    ! Grid dimensions
    equilibrium%time_slice(CurTimeStep)%profiles_2d(1)%grid_type%index = 1 ! Rectangular ala eqdsk   
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
    

    
! Starting core_profiles    
    core_profiles%ids_properties%homogeneous_time = 1
    allocate(core_profiles%profiles_1d(TimeSteps))
    core_profiles%profiles_1d(CurTimeStep)%time = tt
    allocate(core_profiles%time(TimeSteps))
    core_profiles%time(CurTimeStep) = tt ![s]
    
write(*,*) 'Allocate core_profiles... '

    
! Filling 0D

    AllocIfNull1(core_profiles%global_quantities%t_e_peaking, wr_imas(25))
    AllocIfNull1(core_profiles%global_quantities%t_i_average_peaking, wr_imas(27))
    AllocIfNull1(core_profiles%global_quantities%resistive_psi_losses, wr_imas(30))
    AllocIfNull1(core_profiles%global_quantities%ejima, wr_imas(31))

    AllocIfNull1(core_profiles%global_quantities%ip, tpl)
    AllocIfNull1(core_profiles%global_quantities%beta_pol, betap)
    AllocIfNull1(core_profiles%global_quantities%beta_tor, betat)
    AllocIfNull1(core_profiles%global_quantities%li_3, uli)
    AllocIfNull1(core_profiles%global_quantities%v_loop, wr_imas(29))

    core_profiles%vacuum_toroidal_field%r0 = rs0
    AllocIfNull1(core_profiles%vacuum_toroidal_field%b0, bt0)

    
! Filling 1D

    AllocArr(core_profiles%profiles_1d(CurTimeStep)%grid%rho_tor_norm, ai, n)
    AllocArr(core_profiles%profiles_1d(CurTimeStep)%grid%psi, psi_1D, n)
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
 AllocArr(core_profiles%profiles_1d(CurTimeStep)%t_i_average, tq0, n)

write(*,*) 'Write core_profiles transp..1. '
flush(6)


!Transp2 - particle transport
!Electrons
 AllocArr(core_profiles%profiles_1d(1)%electrons%density, pne, n)

if (.not. associated(core_profiles%profiles_1d(1)%ion)) then
   allocate(core_profiles%profiles_1d(1)%ion(7))
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


! Helium
ion = ion + 1
 core_profiles%profiles_1d(1)%ion(ion)%z_ion = 2
!core_profiles%profiles_1d(1)%ion(ion)%label = 'He'
allocate(core_profiles%profiles_1d(1)%ion(ion)%element(1))
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%a = 4
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%z_n = 2
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%atoms_n = 1
 AllocArr(core_profiles%profiles_1d(1)%ion(ion)%density, wr_imas(79)*pne, n)


! Beryllium
ion = ion + 1
 core_profiles%profiles_1d(1)%ion(ion)%z_ion = 4
!core_profiles%profiles_1d(1)%ion(ion)%label = 'Be'
allocate(core_profiles%profiles_1d(1)%ion(ion)%element(1))
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%a = 9
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%z_n = 4
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%atoms_n = 1
 AllocArr(core_profiles%profiles_1d(1)%ion(ion)%density, wr_imas(80)*pne, n)


! Tungsten
ion = ion + 1
 core_profiles%profiles_1d(1)%ion(ion)%z_ion = 74
!core_profiles%profiles_1d(1)%ion(ion)%label = 'W'
allocate(core_profiles%profiles_1d(1)%ion(ion)%element(1))
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%a = 183.84d0
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%z_n = 74
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%atoms_n = 1
 AllocArr(core_profiles%profiles_1d(1)%ion(ion)%density, wr_imas(81)*pne, n)


! Argon
ion = ion + 1
 core_profiles%profiles_1d(1)%ion(ion)%z_ion = 18
!core_profiles%profiles_1d(1)%ion(ion)%label = 'Ar'
allocate(core_profiles%profiles_1d(1)%ion(ion)%element(1))
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%a = 40
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%z_n = 18
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%atoms_n = 1
 AllocArr(core_profiles%profiles_1d(1)%ion(ion)%density, wr_imas(82)*pne, n)


! Neon
ion = ion + 1
 core_profiles%profiles_1d(1)%ion(ion)%z_ion = 10
!core_profiles%profiles_1d(1)%ion(ion)%label = 'Ne'
allocate(core_profiles%profiles_1d(1)%ion(ion)%element(1))
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%a = 20
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%z_n = 10
 core_profiles%profiles_1d(1)%ion(ion)%element(1)%atoms_n = 1
 AllocArr(core_profiles%profiles_1d(1)%ion(ion)%density, wr_imas(83)*pne, n)



!Transp3
 AllocArr(core_profiles%profiles_1d(1)%j_bootstrap, jbut, n)
 AllocArr(core_profiles%profiles_1d(1)%conductivity_parallel, sigk, n)


!Transp4
 AllocIfNull(core_profiles%profiles_1d(1)%j_non_inductive, n)
   core_profiles%profiles_1d(1)%j_non_inductive(1:n) = aj0(1:n) + core_profiles%profiles_1d(1)%j_bootstrap(1:n)



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

  core_sources%source(isrc)%profiles_1d(CurTimeStep)%time = tt
  
allocate(core_sources%source(isrc)%profiles_1d(CurTimeStep)%grid%rho_tor_norm(n))
  core_sources%source(isrc)%profiles_1d(CurTimeStep)%grid%rho_tor_norm(1:n) = ai(1:n)

allocate(core_sources%source(isrc)%profiles_1d(CurTimeStep)%electrons%energy(n))
allocate(core_sources%source(isrc)%profiles_1d(CurTimeStep)%total_ion_energy(n))
 core_sources%source(isrc)%profiles_1d(CurTimeStep)%electrons%energy(1:n) = qe0(1:n)
 core_sources%source(isrc)%profiles_1d(CurTimeStep)%total_ion_energy(1:n) = qq0(1:n)

allocate(core_sources%source(isrc)%profiles_1d(CurTimeStep)%j_parallel(n))
 core_sources%source(isrc)%profiles_1d(CurTimeStep)%j_parallel(1:n) = aj0(1:n)+jbut(1:n)


isrc = isrc+1 
  core_sources%source(isrc)%identifier%index = 13 ! Bootstrap current
allocate(core_sources%source(isrc)%profiles_1d(TimeSteps))

  core_sources%source(isrc)%profiles_1d(CurTimeStep)%time = tt
  
allocate(core_sources%source(isrc)%profiles_1d(CurTimeStep)%grid%rho_tor_norm(n))
  core_sources%source(isrc)%profiles_1d(CurTimeStep)%grid%rho_tor_norm(1:n) = ai(1:n)

allocate(core_sources%source(isrc)%profiles_1d(CurTimeStep)%j_parallel(n))
 core_sources%source(isrc)%profiles_1d(CurTimeStep)%j_parallel(1:n) = jbut(1:n)


isrc = isrc+1
  core_sources%source(isrc)%identifier%index = 2 ! NBI
allocate(core_sources%source(isrc)%profiles_1d(TimeSteps))

  core_sources%source(isrc)%profiles_1d(CurTimeStep)%time = tt
  
allocate(core_sources%source(isrc)%profiles_1d(CurTimeStep)%grid%rho_tor_norm(n))
  core_sources%source(isrc)%profiles_1d(CurTimeStep)%grid%rho_tor_norm(1:n) = ai(1:n)

allocate(core_sources%source(isrc)%profiles_1d(CurTimeStep)%j_parallel(n))
 core_sources%source(isrc)%profiles_1d(CurTimeStep)%j_parallel(1:n) = aj0(1:n) 
 

isrc = isrc+1 
  core_sources%source(isrc)%identifier%index = 3 ! ECRH
allocate(core_sources%source(isrc)%profiles_1d(TimeSteps))

  core_sources%source(isrc)%profiles_1d(CurTimeStep)%time = tt
  
allocate(core_sources%source(isrc)%profiles_1d(CurTimeStep)%grid%rho_tor_norm(n))
  core_sources%source(isrc)%profiles_1d(CurTimeStep)%grid%rho_tor_norm(1:n) = ai(1:n)
  
allocate(core_sources%source(isrc)%profiles_1d(CurTimeStep)%j_parallel(n))
 core_sources%source(isrc)%profiles_1d(CurTimeStep)%j_parallel(1:n) = ajae(1:n)
 

! Power
 isrc = isrc+1
 core_sources%source(isrc)%identifier%index = 7 ! Ohmic heating
allocate(core_sources%source(isrc)%global_quantities(TimeSteps))
  core_sources%source(isrc)%global_quantities(CurTimeStep)%time = tt
  core_sources%source(isrc)%global_quantities(CurTimeStep)%power = wr_imas(65) !Pohm

 isrc = isrc+1
 core_sources%source(isrc)%identifier%index = 100 ! Auxiliary heating
allocate(core_sources%source(isrc)%global_quantities(TimeSteps))
  core_sources%source(isrc)%global_quantities(CurTimeStep)%time = tt
  core_sources%source(isrc)%global_quantities(CurTimeStep)%power = wr_imas(66) !wdop
  
 isrc = isrc+1
 core_sources%source(isrc)%identifier%index = 6 ! Alfa particles heating
allocate(core_sources%source(isrc)%global_quantities(TimeSteps))
  core_sources%source(isrc)%global_quantities(CurTimeStep)%time = tt
  core_sources%source(isrc)%global_quantities(CurTimeStep)%power = wr_imas(67) !w_alfa  
  
 isrc = isrc+1
 core_sources%source(isrc)%identifier%index = 200 ! Total radiation
allocate(core_sources%source(isrc)%global_quantities(TimeSteps))
  core_sources%source(isrc)%global_quantities(CurTimeStep)%time = tt
  core_sources%source(isrc)%global_quantities(CurTimeStep)%power = wr_imas(91) !w_rad 
 
 isrc = isrc+1
 core_sources%source(isrc)%identifier%index = 203 ! Impurity radiation
allocate(core_sources%source(isrc)%global_quantities(TimeSteps))
  core_sources%source(isrc)%global_quantities(CurTimeStep)%time = tt
  core_sources%source(isrc)%global_quantities(CurTimeStep)%power = wr_imas(90) !w_imp 
 
 isrc = isrc+1
 core_sources%source(isrc)%identifier%index = 201 ! Cyclotron radiation
allocate(core_sources%source(isrc)%global_quantities(TimeSteps))
  core_sources%source(isrc)%global_quantities(CurTimeStep)%time = tt
  core_sources%source(isrc)%global_quantities(CurTimeStep)%power = wr_imas(85)
 
 isrc = isrc+1
 core_sources%source(isrc)%identifier%index = 8 ! Bremsstrahlung radiation
allocate(core_sources%source(isrc)%global_quantities(TimeSteps))
  core_sources%source(isrc)%global_quantities(CurTimeStep)%time = tt
  core_sources%source(isrc)%global_quantities(CurTimeStep)%power = wr_imas(84) !wtor   


! Radiation by species
 isrc = isrc+1
 core_sources%source(isrc)%identifier%index = 203 ! Impurity radiation
allocate(core_sources%source(isrc)%global_quantities(TimeSteps))
  core_sources%source(isrc)%global_quantities(CurTimeStep)%time = tt
  core_sources%source(isrc)%global_quantities(CurTimeStep)%power = wr_imas(86) !w_Be  
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
  core_sources%source(isrc)%global_quantities(CurTimeStep)%time = tt
  core_sources%source(isrc)%global_quantities(CurTimeStep)%power = wr_imas(87) !w_W  
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
  core_sources%source(isrc)%global_quantities(CurTimeStep)%time = tt
  core_sources%source(isrc)%global_quantities(CurTimeStep)%power = wr_imas(88) !w_Ar 
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
  core_sources%source(isrc)%global_quantities(CurTimeStep)%time = tt
  core_sources%source(isrc)%global_quantities(CurTimeStep)%power = wr_imas(89) !w_Ne 
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
    
allocate(core_transport%model(1)%profiles_1d(CurTimeStep)%ion(2))


    core_transport%ids_properties%homogeneous_time = 1
    
    
    core_transport%model(1)%profiles_1d(CurTimeStep)%grid_d%rho_tor_norm(1:n) = ai(1:n)

    
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
    
    
  !  write(*,*) "psi = ", (equilibrium%profiles_2d(1)%psi(i,1:n2,CurTimeStep),i=1,n1)

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
!      print 71,apr,(zeff(i),i=1,n1) 
       apr='++sigk-' 
!      print 71,apr,(sigk(i),i=1,n1) 
   flush(6)
    print *,' end dina_imas'
flush(6)
      
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

    

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
integer :: i,nt,io,iv, n_z
real(8) :: t, v, u

integer :: n1,n2,n3,n4,n5,n6,n7,n8
real(8) :: x1,x2,x3,x4,x5,x6,x7,x8

7000	format(4(1x,1pe14.7))


open(unit=44,file='ech.dat',action='write',access='sequential')
nt=size(schedule%ec%launcher(1)%power%reference%time)

print *,' nt==',nt

write(44,*) 'Time points'
write(44,*) nt
write(44,*) 'Time  Power'
do i=1,nt
t = schedule%ec%launcher(1)%power%reference%time(i)
print *,'i t',i,t
v = schedule%ec%launcher(1)%power%reference%data(i)*1.d-6
print *,' v==',v
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
write(44,*) nt
write(44,*) 'Time  Density'
do i=1,nt
t = schedule%density_control%valve(7)%flow_rate%reference%time(i)
v = schedule%density_control%valve(7)%flow_rate%reference%data(i)
write(44,*) t, v
enddo
close(44)


iv = 2
open(unit=44,file='gamma_z.dat',action='write',access='sequential')
nt=size(schedule%density_control%valve(iv)%flow_rate%reference%time)
n_z=schedule%density_control%valve(iv)%species(1)%element(1)%z_n
write(44,*) 'Time_points  t_bar'
write(44,*) nt, n_z
write(44,*) 'Time  Density'
do i=1,nt
t = schedule%density_control%valve(iv)%flow_rate%reference%time(i)
v = schedule%density_control%valve(iv)%flow_rate%reference%data(i)
write(44,*) t, v
enddo
close(44)


iv = 3
open(unit=44,file='gamma_z1.dat',action='write',access='sequential')
nt=size(schedule%density_control%valve(iv)%flow_rate%reference%time)
n_z=schedule%density_control%valve(iv)%species(1)%element(1)%z_n
write(44,*) 'Time_points  t_bar'
write(44,*) nt, n_z
write(44,*) 'Time  Density'
do i=1,nt
t = schedule%density_control%valve(iv)%flow_rate%reference%time(i)
v = schedule%density_control%valve(iv)%flow_rate%reference%data(i)
write(44,*) t, v
enddo
close(44)


iv = 4
open(unit=44,file='gamma_z2.dat',action='write',access='sequential')
nt=size(schedule%density_control%valve(iv)%flow_rate%reference%time)
n_z=schedule%density_control%valve(iv)%species(1)%element(1)%z_n
write(44,*) 'Time_points  t_bar'
write(44,*) nt, n_z
write(44,*) 'Time  Density'
do i=1,nt
t = schedule%density_control%valve(iv)%flow_rate%reference%time(i)
v = schedule%density_control%valve(iv)%flow_rate%reference%data(i)
write(44,*) t, v
enddo
close(44)


iv = 5
open(unit=44,file='gamma_z3.dat',action='write',access='sequential')
nt=size(schedule%density_control%valve(iv)%flow_rate%reference%time)
n_z=schedule%density_control%valve(iv)%species(1)%element(1)%z_n
write(44,*) 'Time_points  t_bar'
write(44,*) nt, n_z
write(44,*) 'Time  Density'
do i=1,nt
t = schedule%density_control%valve(iv)%flow_rate%reference%time(i)
v = schedule%density_control%valve(iv)%flow_rate%reference%data(i)
write(44,*) t, v
enddo
close(44)


iv = 6
open(unit=44,file='gamma_z4.dat',action='write',access='sequential')
nt=size(schedule%density_control%valve(iv)%flow_rate%reference%time)
n_z=schedule%density_control%valve(iv)%species(1)%element(1)%z_n
write(44,*) 'Time_points  t_bar'
write(44,*) nt, n_z
write(44,*) 'Time  Density'
do i=1,nt
t = schedule%density_control%valve(iv)%flow_rate%reference%time(i)
v = schedule%density_control%valve(iv)%flow_rate%reference%data(i)
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
	read (2,*) ; write (44,*) 'zeff0_a    zeff0_b'
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
