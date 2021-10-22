!> dina_equil is the main subroutine to reproduce DANA equilibrium
!> As a result of call dina_v96_in the Green Functions are being transmitted to DINA from IDSs
!> After call dina_input the initial kinetic profiles are being transmitted to DINA from IDSs   
!> As a result of call dina2 the DINA modeling in one time step is being produced
!> After call dina_outp the output data are being recorded to IDS and dat files


subroutine dina_equil(&
  &  em_coupling0, equilibrium0, pf_active0, pf_passive0 &
  & ,equilibrium)


use ids_schemas
use ids_routines
implicit none


! trees are static or dynamic; if not defined, they are static
type (ids_em_coupling)  :: em_coupling0
type (ids_equilibrium) :: equilibrium0, equilibrium
type (ids_pf_active)   :: pf_active0
type (ids_pf_passive)   :: pf_passive0


! define local fixed size variables
integer,save :: i, k,  j, its
integer,save :: first_call = 1, loop_count = 0, ntime = 0

integer,save :: kloop,kprobe, ke=57, ngrid2

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

real(ids_real) ::time_eq

     common /c_imas_time_eq/time_eq

! DINA parameters
    integer,parameter :: npo = 500
    integer,parameter :: ntet = 134
    integer,parameter :: nr = 65, nz = 129, ngrid = nr*nz
    integer,parameter :: npf = 15, ncam = 100
    integer,parameter :: npfa = 12, npfx = npf-npfa, npfp = npfx+ncam
    integer :: npf0, ncam0
    
      integer,parameter :: kint=200      
      real (ids_real),dimension(:) :: c_input1(kint),c_input2(kint)
      real (ids_real),dimension(:) :: c_output1(kint),c_output2(kint),c_output3(kint)
      
      
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
  & ,q_ax=1000.0,q_95=1000.0,rs0=1000.0,bt0=1000.0,wen2=1000.0,tt = 1.0,psi_bnd = 1000.0 &
  & ,rmajor,rminor,elong,tri
    real(ids_real) :: betap,betat,tec,tqc,pec,pic,zeff,vloop,tene,wfus,emag

    real(ids_real) :: x(nr),y(nz),psi(nr,nz),psi1(nr,nz),curr_d(nr,nz)

    real(ids_real) :: ai(npo),te0(npo),tq0(npo),pne(npo),tok1(npo),q(npo)

    real(ids_real) :: pd0(npo),pt0(npo),sigk(npo),jbut(npo),aj0(npo),qe0(npo),qq0(npo)
    
    real(ids_real) :: xbound(ntet),ybound(ntet)
    
    real(ids_real) :: vchopper(npf),pf(npf),tcam(ncam)
    
    real(ids_real) :: pstab(npo), pptab(npo),fptab(npo)

    real(ids_real),parameter :: pi = 3.14159265358979323846

    real(ids_real) :: coef_ppx,coef_pffx,pmu0

  integer :: TimeSteps=1, CurTimeStep=1
  
  integer :: n1, n2, n ,i_wr

real (ids_real),save ::  gridrange(4)
real(ids_real), dimension(:,:), ALLOCATABLE,save :: fluxarr,vesarr,pslgreen,bprgreen,pfind,pmj
real(ids_real), dimension(:,:), ALLOCATABLE,save :: pfc,pfgreen,vesgreen,pfprobe,vesprobe
real(ids_real), dimension(:), ALLOCATABLE,save :: pfres, rcam, xu, yu

real(ids_real),save :: cpu_old = 0.d0, cpu_new

real(ids_real) :: yfluxd_xx,yfluxt_xx,yfluxe_xx,yfluxi_xx,ysbound_xx

kpr=1

print *,'DINA_EQUIL Enter'
flush(6)


if (first_call == 1) then 



100 format (2I5, 4x,2I5, 4x, 2I5, 4x,2I5)



first_call = first_call+1 ! cancel the initialisation for the next call

else


end if ! end of first_call



loop_count = loop_count + 1 ! number of times the iterative routine was entered

write(*,*) 'dina_imas loop, first_call = ', first_call, loop_count

print *,' Ip==',equilibrium0%time_slice(1)%global_quantities%ip

if (equilibrium0%time_slice(1)%global_quantities%ip .gt. 1.e5) then

      n_input1=2
!      n_input2=15
      n_input2=38


     its = 1
     
	tt = equilibrium0%time_slice(its)%time
	tpl = equilibrium0%time_slice(its)%global_quantities%ip
	n = size(equilibrium0%time_slice(its)%profiles_1d%rho_tor_norm)
	pstab(1:n) = equilibrium0%time_slice(its)%profiles_1d%rho_tor_norm(1:n)
	
	rs0=equilibrium0%vacuum_toroidal_field%r0
	
	
	pmu0=4.d0*pi*1.d-7
    coef_ppx=1./(2*pi)/(rs0)*10./pmu0
    coef_pffx=1./(2*pi)*0.5d0*(rs0)*10.
    
    print *,' coef_ppx coef_pffx rs0 pmu0=',coef_ppx,coef_pffx,rs0,pmu0
    
!    equilibrium%time_slice(CurTimeStep)%profiles_1d%dpressure_dpsi(1:n) = coef_ppx*pptab(1:n)
!    equilibrium%time_slice(CurTimeStep)%profiles_1d %f_df_dpsi(1:n) = coef_pffx*fptab(1:n)

	pptab(1:n) = equilibrium0%time_slice(its)%profiles_1d%dpressure_dpsi(1:n)/coef_ppx
	
	fptab(1:n) = equilibrium0%time_slice(its)%profiles_1d%f_df_dpsi(1:n)/coef_pffx
	
	npf0 = size(pf_active0%coil, 1)
	do i=1,npf0
	  pf(i) =  pf_active0%coil(i)%current%data(1)
	enddo
	
 	ncam0 = size(pf_passive0%loop, 1)
 	!first 3 passive --> last 3 active
	do i=1,npfx
	  pf(npf0+i) = pf_passive0%loop(i)%current(1)
	enddo
	do i=1,ncam0-npfx
	  tcam(i) = pf_passive0%loop(npfx+i)%current(1)
	enddo	
 
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
	
     
allocate(fluxarr(ngrid,nact))
allocate(vesarr(ngrid,npass))

allocate(vesgreen(nflux,npass))  
allocate(vesprobe(nbpol,npass)) 

allocate(pfgreen(nflux,nact)) 
allocate(pfprobe(nbpol,nact))  

allocate(pfind(nact,nact)) 
allocate(pmj(npass,npass))
allocate(pfc(npass,nact))

allocate(pslgreen(ngrid,nflux))
allocate(bprgreen(ngrid,nbpol)) 
  
     
 fluxarr(1:ngrid,1:nact) = em_coupling0%mutual_grid_active
 vesarr(1:ngrid,1:npass) = em_coupling0%mutual_grid_passive

 vesgreen(1:nflux,1:npass) = em_coupling0%mutual_loops_passive  
 vesprobe(1:nbpol,1:npass) = em_coupling0%field_probes_passive 

 pfgreen(1:nflux,1:nact) = em_coupling0%mutual_loops_active  
 pfprobe(1:nbpol,1:nact) = em_coupling0%field_probes_active  

 pfind(1:nact,1:nact) = em_coupling0%mutual_active_active 
 pmj(1:npass,1:npass) = em_coupling0%mutual_passive_passive
 pfc(1:npass,1:nact) = em_coupling0%mutual_passive_active 

do j=1,nflux
  pslgreen(1:ngrid,j) = em_coupling0%mutual_loops_grid(j,1:ngrid)
end do
do j=1,nbpol
  bprgreen(1:ngrid,j) = em_coupling0%field_probes_grid(j,1:ngrid)
end do     

!        npf=nact
!        ncam=npass
        kloop=nflux
        kprobe=nbpol  
    
allocate(pfres(nact))
allocate(rcam(npass))
allocate(xu(ke))
allocate(yu(ke))    
   
pfres(1:nact) = pf_active0%coil(1:nact)%resistance
rcam(1:npass) = pf_passive0%loop(1:npass)%resistance

xu(1:ke)=equilibrium0%time_slice(1)%coordinate_system%r(1:ke,1)
yu(1:ke)=equilibrium0%time_slice(1)%coordinate_system%z(1:ke,1)

! x(1:nr)=equilibrium0%time_slice(1)%coordinate_system%grid%dim1(1:nr) ![m]
! y(1:nz)=equilibrium0%time_slice(1)%coordinate_system%grid%dim2(1:nz) ![m]
x(1:nr)=equilibrium0%time_slice(1)%profiles_2d(1)%grid%dim2(1:nr) ![m]
y(1:nz)=equilibrium0%time_slice(1)%profiles_2d(1)%grid%dim1(1:nz) ![m]

gridrange(1)=y(1)
gridrange(2)=y(nz)
gridrange(3)=x(1)
gridrange(4)=x(nr)    
    
    
    
     call  dina_v96_in(ncam,npf,kloop,kprobe,&
&       gridrange,nact,npass,&
&       fluxarr,vesarr, pslgreen,bprgreen,&
&       pfind,pmj,pfc, pfres,rcam,&
&       xu,yu,ke,key,&
&   pfgreen,vesgreen,pfprobe,&
&   vesprobe,ngrid)     
     
     
     
     
     
     call dina_input(tt,tpl, n,pstab, pptab,fptab &
     & , ncam,tcam, npf,pf)
     
     call read_equil()
     
     call dina2(&
!-----------------------------------  inputs---
     &  c_input1,c_input2,&
!------------------------------------outputs
     &  c_output1,c_output2,c_output3)
     
     
write(*,*) '!!!dina_outp enter'
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
 
    write(*,*) 'dina_outp call n tpl tt= ', n,tpl,tt


    flush(6)
    

	!call cpu_time(cpu_new)
	!write(*,*) 'CPUTime = ', cpu_new-cpu_old
	!call write_cputime1(cpu_new-cpu_old, cpu_new, 0)
	!cpu_old = cpu_new

write(*,*) 'Allocations equilibrium...'
! Allocations equilibrium

    allocate(equilibrium%time_slice(TimeSteps))
    allocate(equilibrium%time(TimeSteps))
  
    
    n1 = nz
    n2 = nr

    !allocate(equilibrium%coordinate_system%grid%dim1(n1,TimeSteps))
    !allocate(equilibrium%coordinate_system%grid%dim2(n2,TimeSteps))
    !allocate(equilibrium%time_slice(CurTimeStep)%coordinate_system%r(ke,1))
    !allocate(equilibrium%time_slice(CurTimeStep)%coordinate_system%z(ke,1))


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

write(*,*) 'Filling equilibrium...'    
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


  !  call write_graf_imas1(nr,nz,ke, &
  !   &	0.01d0,0.01d0,tt,&
  !   &  psi,x,y,xu,yu,&
  !   &  psi_ax,psi_bnd,psi_bnd,0.d0,0.d0) 

write(*,*) 'Filling 2d profiles...'


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

    
    
    i_wr=0
    if(i_wr.eq.1)then


    call write_graf_imas(nr,nz,ke, &
     &	0.01,0.01,tt,&
     &  psi1,x,y,xu,yu,&
     &  psi_ax,psi_bnd,psi_bnd,0.,0.) 

    end if
    
write(*,*) 'Filling limiter...'
    
    !equilibrium%time_slice(CurTimeStep)%coordinate_system%r(1:ke,1) = xu(1:ke)
    !equilibrium%time_slice(CurTimeStep)%coordinate_system%z(1:ke,1) = yu(1:ke)


    equilibrium%time_slice(CurTimeStep)%time = tt
    equilibrium%time(CurTimeStep) = tt ![s]
    

    
flush(6)


else

call ids_copy(equilibrium0, equilibrium)

endif

    
return
end subroutine



	subroutine write_graf_imas(nr,nz,ke,&
     &	dx,dy,ttt,&
     &  psi,x,y,xu,yu,&
     &  pmag,pbound,p_s,um,vm) 

        integer :: nr,nz,ke
	real*8,dimension(:,:) :: psi(nr,nz)
	real*8,dimension(:) :: x(nr),y(nz),xu(ke),yu(ke)

	real (8) :: dx,dy,ttt,pmag,pbound,p_s,um,vm
	

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

	
	subroutine write_graf_imas1(nr,nz,ke,&
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


	subroutine write_cputime1(deltatime, time, flag_start)

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

