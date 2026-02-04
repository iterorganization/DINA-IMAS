!> dina_data_read is the main subroutine to read the input code parameters

subroutine dina_data_read_imas(psch)

use ids_schemas, only: ids_pulse_schedule

use f90_file_reader, only: file2buffer
use xml2eg_mdl, only: xml2eg_parse_memory, xml2eg_get, type_xml2eg_document, xml2eg_free_doc

	include 'double.inc'

!	implicit real*8 (a-h,o-z)
	include 'parf1'
 	include 'parf_mike'
        
include 'imas_interface.inc'

type (ids_pulse_schedule)   :: psch

        COMMON /pf1/npf,pf(kf),pf0(kf)
        common /ge5/kpr
	common /n_m/n,m,mp


      common /c_tt_kavin/tt_kavin_c
      
      common /c_kpr/kpr_c

      common /c_for002_kav/tay_c,rs0_c,bt0_c,key_t11_c
      common /c_for002_kav2/n_c

      common /c_gaps_data_ramp/x_gaps_c(mu),y_gaps_c(mu),n_ga_c

      common /c_tran_times/tt_dina_c

      common /c_pfres/t_t_c1(ntime),pf_t_c1(kf,ntime),n_t_c1,npf_c1


      common /c_ech_c2/t_t_c2(ntime),udd_sol_t_c2(ntime),n_t_c2

      common /c_nd_c3/t_t_c3(ntime),pn_d_t_c3(ntime),n_t_c3


      common /c_gamma_z_c4/t_t_c4(ntime),pn_d_t_c4(ntime), n_t_c4,nz_imp_c4

      common /c_gamma_z2_c5/t_t_c5(ntime),pn_d_t_c5(ntime), n_t_c5,nz_imp2_c5

      common /c_init_c6/p_c6,T_e_c6,T_i_c6,gam_c6,g_gain_c6


      common /c_emo_c7/t_t_c7(ntime),emoe_t_c7(ntime),emoq_t_c7(ntime), n_t_c7

      common /c_dens_c8/t_t_c8(ntime),den_t_c8(ntime),n_t_c8

      common /c_gamma_z1_c9/t_t_c9(ntime),pn_d_t_c9(ntime), n_t_c9,nz_imp1_c9

      common /c_gamma_z3_c10/t_t_c10(ntime),pn_d_t_c10(ntime), n_t_c10,nz_imp3_c10

      common /c_gamma_z4_c11/t_t_c11(ntime),pn_d_t_c11(ntime), n_t_c11,nz_imp4_c11



      common /c_bohm_gbohm_c12/k_Bohm_c12
      common /c_tay_simul_c13/tay_simul_c13
      common /c_dw_c14/tay_dw_c14
      common /c_pcchp_end_c15/pcchp_end_c15
      common /c_ext_c16/k_ener_ext_c16,k_dens_ext_c16,k_ajb_ext_c16

      common /c_tt_kavin2_c1/tt_rampup_c1,dt_end_sim_c1,&
     & dtpl_term_l_c1,cIp_end_c1,CS1_eob_c1,rms_noise_c1
     
     
     common /v_turn/pf_turns(kf)

     common /c_one2d/alf,ro_alf
     common /c_q_test/q_test

     
character(len=30) :: ConfigFile = 'DINA_Parameters.xml'
type(type_xml2eg_document) :: doc
character(len=132), pointer :: buffer(:) => NULL()
integer :: io_unit = 1
logical :: errorflag
character(len=200):: gaps_r_str, gaps_z_str
character(len=200):: ncircuit_str, dircircuit_str

common /pf_circuit/ ncirc, dircirc
integer :: ncirc(kf), dircirc(kf)

! ! ITER
!data ncirc(1:14) /1, 2, 3, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 12/
!data dircirc(1:14) /1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1/

! ! MAST-U
! data ncirc(1:25) /1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25/
! data dircirc(1:25) /1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1/



integer :: grid_n
real*8 :: grid_rho, grid_alpha

!      n=n_c
      n_c=50
      n=n_c
      
      if(kpr.eq.1)print *,'n n_c ',n,n_c
      
      
      print*, 'DINA_PARAMS_IMAS'
      print*, 'npf =', npf
      print*, 'PF_TURNS =', pf_turns
      
      
      ! Initializing 1D grid
 !     call one2d()
     
     
        !open(unit=49,file='dina_data.dat', form='formatted')
     
call file2buffer(ConfigFile, io_unit, buffer)
call xml2eg_parse_memory(buffer, doc)

         
         call xml2eg_get(doc, 'grid_n', grid_n)
         call xml2eg_get(doc, 'grid_rho', grid_rho)
         call xml2eg_get(doc, 'grid_alpha', grid_alpha)


      call xml2eg_get(doc, 'tpl_dir', tpl_dir, errorflag)
if (errorflag) then
   print*, 'tpl_dir reading error'
   tpl_dir = 1.d0
end if
      

      bt0_dir = -1.d0



      if(kpr.eq.1)print *,' tpl_dir, bt0_dir ==', tpl_dir, bt0_dir

      n=grid_n
      n_c=n
      
      if(kpr.eq.1)print *,'n grid_n n_c ',n,grid_n,n_c
      
      ro_alf=grid_rho 
      alf=grid_alpha
      
      if(kpr.eq.1)print *,'alf ro_alf ',alf,ro_alf
   
         
! 	open (unit=40,file='tt_kavin.dat',form='formatted') 
        !read (49,*) 
        !read (49,*)time_eq_c
          
        call xml2eg_get(doc, 'tt_kavin', tt_kavin_c)
          
!        open (unit=1,file='kpr.dat',form='formatted')

        !read (49,*)
        !read (49,*)kpr_c
        
        call xml2eg_get(doc, 'kpr', kpr_c)

!     	open(unit=2,file='for002_kav',form='formatted')

	!read (49,*)
	!read (49,*)tay_c,rs0_c,key_t11_c,bt0_c
        
call xml2eg_get(doc, 'tau', tay_c)
!call xml2eg_get(doc, 'rs0', rs0_c)
call xml2eg_get(doc, 'key_t11', key_t11_c)
!call xml2eg_get(doc, 'bt0', bt0_c)

call xml2eg_get(doc, 'q_swth', q_test, errorflag)
if (errorflag) then
   print*, 'q_swth reading error'
   q_test = 0.97
end if

print*, 'q_swth=q_test=', q_test




	!open(unit=49,status='old',file='gaps_data_ramp',form='formatted')
	!read (49,*)
	!read (49,*)n_ga_c
	!read (49,*)
	!read (49,*)(x_gaps_c(i),i=1,n_ga_c)
	!read (49,*)
	!read (49,*)(y_gaps_c(i),i=1,n_ga_c)
        !close(49)

call xml2eg_get(doc, 'gaps/ngaps', n_ga_c)
call xml2eg_get(doc, 'gaps/gaps_r', gaps_r_str)
call xml2eg_get(doc, 'gaps/gaps_z', gaps_z_str)
    read(gaps_r_str,*)(x_gaps_c(i),i=1,n_ga_c)
    read(gaps_z_str,*)(y_gaps_c(i),i=1,n_ga_c)

  print*, 'x gaps =', (x_gaps_c(i),i=1,n_ga_c)
  print*, 'y gaps =', (y_gaps_c(i),i=1,n_ga_c)


call xml2eg_get(doc, 'circuit/ncirc', n_pfa)
call xml2eg_get(doc, 'circuit/connection', ncircuit_str)
call xml2eg_get(doc, 'circuit/direction', dircircuit_str)
   
   read(ncircuit_str,*)(ncirc(i),i=1,n_pfa)
   read(dircircuit_str,*)(dircirc(i),i=1,n_pfa)
   npf = maxval(ncirc)

  print*, 'npf=', npf
  print*, 'ncirc(i) =', (ncirc(i),i=1,n_pfa)
  print*, 'dircirc(i) =', (dircirc(i),i=1,n_pfa)

!        open (unit=1,file='tran_times.dat',form='formatted')
        !read (49,*)
        !read (49,*)tt_dina_c
call xml2eg_get(doc, 'tt_dina', tt_dina_c)

!           open (unit=41,file='pfres.dat',form='formatted') 
           !read (49,*) 
           !read (49,*)n_t_c1 

           !read (49,*) 

          npf_c1=npf
           !do i=1,n_t_c1 
              !read (49,*)t_t_c1(i),(pf_t_c1(k,i),k=1,npf_c1)
           !end do 

          !npf_c1 = size(ps%pf_active%coil)
          !print*,'ncoil =', size(psch%pf_active%coil)
          n_t_c1 = size(psch%pf_active%coil(1)%resistance_additional%reference%time)
          t_t_c1(1:n_t_c1) = psch%pf_active%coil(1)%resistance_additional%reference%time(1:n_t_c1)

          do i=1,kf
                pf_t_c1(i,1:n_t_c1) = 0.d0
          enddo

          do i=1,size(psch%pf_active%coil)
                pf_t_c1(ncirc(i),1:n_t_c1) = pf_t_c1(ncirc(i),1:n_t_c1) + psch%pf_active%coil(i)%resistance_additional%reference%data(1:n_t_c1)
          enddo
        
        
        do k=1,npf_c1
          pf_t_c1(k,1:n_t_c1) = pf_t_c1(k,1:n_t_c1)/(pf_turns(k)*pf_turns(k))
        enddo
        
        do i=1,n_t_c1
          print*, 'pfres', pf_t_c1(:,i)
        enddo
        
!           do k=1,npf_c1
!             pf_t_c1(k,1:n_t_c1) = psch%pf_active%coil(k)%resistance_additional%reference%data(1:n_t_c1)
!           enddo


!           open (unit=41,file='ech.dat',form='formatted')
           !read (49,*) 
           !read (49,*)n_t_c2 
           !read (49,*) 


           !do i=1,n_t_c2 
           !   read (49,*)t_t_c2(i),udd_sol_t_c2(i)
           !end do 

           n_t_c2 = size(psch%ec%launcher(1)%power%reference%time)
           t_t_c2(1:n_t_c2) = psch%ec%launcher(1)%power%reference%time(1:n_t_c2)
           udd_sol_t_c2(1:n_t_c2) = psch%ec%launcher(1)%power%reference%data(1:n_t_c2)*1.d-6
        
        
        
!           open (unit=41,file='n_d.dat',form='formatted')
           !read (49,*) 
           !read (49,*)n_t_c3 
           !read (49,*) 
           
           
           !do i=1,n_t_c3 
           !   read (49,*)t_t_c3(i),pn_d_t_c3(i)
           !end do 
        
           ion = 1
           n_t_c3 = size(psch%density_control%ion(ion)%n_i_volume_average%reference%time)
           t_t_c3(1:n_t_c3) = psch%density_control%ion(ion)%n_i_volume_average%reference%time(1:n_t_c3)
           pn_d_t_c3(1:n_t_c3) = psch%density_control%ion(ion)%n_i_volume_average%reference%data(1:n_t_c3)*1.d-19

!           open (unit=41,file='gamma_z.dat',form='formatted')
           !read (49,*) 
           !read (49,*)n_t_c4,nz_imp_c4 
           !read (49,*) 
           
           !do i=1,n_t_c4 
           !   read (49,*)t_t_c4(i),pn_d_t_c4(i)
           !end do 

           ion = 3
           nz_imp_c4 = psch%density_control%ion(ion)%element(1)%z_n
           n_t_c4 = size(psch%density_control%ion(ion)%n_i_volume_average%reference%time)
           t_t_c4(1:n_t_c4) = psch%density_control%ion(ion)%n_i_volume_average%reference%time(1:n_t_c4)*1.d3
           pn_d_t_c4(1:n_t_c4) = psch%density_control%ion(ion)%n_i_volume_average%reference%data(1:n_t_c4)*1.d-19
        
        
!           open (unit=41,file='gamma_z2.dat',form='formatted') 
           !read (49,*) 
           !read (49,*)n_t_c5,nz_imp2_c5 
           !read (49,*) 
           
           !do i=1,n_t_c5 
           !   read (49,*)t_t_c5(i),pn_d_t_c5(i)
           !end do
           
           ion = 5
           nz_imp2_c5 = psch%density_control%ion(ion)%element(1)%z_n
           n_t_c5 = size(psch%density_control%ion(ion)%n_i_volume_average%reference%time)
           t_t_c5(1:n_t_c5) = psch%density_control%ion(ion)%n_i_volume_average%reference%time(1:n_t_c5)*1.d3
           pn_d_t_c5(1:n_t_c5) = psch%density_control%ion(ion)%n_i_volume_average%reference%data(1:n_t_c5)*1.d-19
        
        
!	open (unit=41,file='init.dat',form='formatted')
        !read (49,*)p_c6
        !read (49,*)T_e_c6
        !read (49,*)T_i_c6
        !read (49,*)gam_c6
        !read (49,*)g_gain_c6

call xml2eg_get(doc, 'p', p_c6)
call xml2eg_get(doc, 'T_e', T_e_c6)
call xml2eg_get(doc, 'T_i', T_i_c6)
call xml2eg_get(doc, 'gam', gam_c6)
call xml2eg_get(doc, 'gain_puff', g_gain_c6)

!           open (unit=41,file='emo.dat',form='formatted') 
           !read (49,*) 
           !read (49,*)n_t_c7 
           
           !read (49,*) 
           !do i=1,n_t_c7 
           !   read (49,*)t_t_c7(i),emoe_t_c7(i),emoq_t_c7(i)
           !end do 

           n_t_c7 = size(psch%ec%power%reference%time)
           t_t_c7(1:n_t_c7) = psch%ec%power%reference%time(1:n_t_c7)
           emoe_t_c7(1:n_t_c7) = psch%ec%power%reference%data(1:n_t_c7)*1.d-6
           emoq_t_c7(1:n_t_c7) = psch%ic%power%reference%data(1:n_t_c7)*1.d-6
        
        
!           open (unit=41,file='dens.dat',form='formatted')
           !read (49,*) 
           !read (49,*)n_t_c8 
           !read (49,*) 

           !do i=1,n_t_c8 
           !   read (49,*)t_t_c8(i),den_t_c8(i)
           !end do

           ion = 2
           n_t_c8 = size(psch%density_control%ion(ion)%n_i_volume_average%reference%time)
           t_t_c8(1:n_t_c8) = psch%density_control%ion(ion)%n_i_volume_average%reference%time(1:n_t_c8)
           den_t_c8(1:n_t_c8) = psch%density_control%ion(ion)%n_i_volume_average%reference%data(1:n_t_c8)*1.d-19

!           open (unit=41,file='gamma_z1.dat',form='formatted')
           !read (49,*) 
           !read (49,*)n_t_c9,nz_imp1_c9 
           !read (49,*) 
           
           !do i=1,n_t_c9 
           !   read (49,*)t_t_c9(i),pn_d_t_c9(i)
           !end do 
           
           ion = 4
           nz_imp1_c9 = psch%density_control%ion(ion)%element(1)%z_n
           n_t_c9 = size(psch%density_control%ion(ion)%n_i_volume_average%reference%time)
           t_t_c9(1:n_t_c9) = psch%density_control%ion(ion)%n_i_volume_average%reference%time(1:n_t_c9)*1.d3
           pn_d_t_c9(1:n_t_c9) = psch%density_control%ion(ion)%n_i_volume_average%reference%data(1:n_t_c9)*1.d-19
        
!           open (unit=41,file='gamma_z3.dat',form='formatted') 
           !read (49,*) 
           !read (49,*)n_t_c10,nz_imp3_c10 
           !read (49,*) 
           
           !do i=1,n_t_c10 
           !   read (49,*)t_t_c10(i),pn_d_t_c10(i)
           !end do 
        
           ion = 6
           nz_imp3_c10 = psch%density_control%ion(ion)%element(1)%z_n
           n_t_c10 = size(psch%density_control%ion(ion)%n_i_volume_average%reference%time)
           t_t_c10(1:n_t_c10) = psch%density_control%ion(ion)%n_i_volume_average%reference%time(1:n_t_c10)*1.d3
           pn_d_t_c10(1:n_t_c10) = psch%density_control%ion(ion)%n_i_volume_average%reference%data(1:n_t_c10)*1.d-19
        
        
!           open (unit=41,file='gamma_z4.dat',form='formatted') 
           !read (49,*) 
           !read (49,*)n_t_c11,nz_imp4_c11 
           !read (49,*) 
           
           !do i=1,n_t_c11 
           !   read (49,*)t_t_c11(i),pn_d_t_c11(i)
           !end do 

           ion = 7
           nz_imp4_c11 = psch%density_control%ion(ion)%element(1)%z_n
           n_t_c11 = size(psch%density_control%ion(ion)%n_i_volume_average%reference%time)
           t_t_c11(1:n_t_c11) = psch%density_control%ion(ion)%n_i_volume_average%reference%time(1:n_t_c11)*1.d3
           pn_d_t_c11(1:n_t_c11) = psch%density_control%ion(ion)%n_i_volume_average%reference%data(1:n_t_c11)*1.d-19
        
!                 open (unit=41,file='bohm_gbohm.dat',form='formatted')
                !read (49,*)
                !read (49,*) k_Bohm_c12
call xml2eg_get(doc, 'bohm_gbohm', k_Bohm_c12)
                
!           open (unit=41,file='tay_simul.dat',form='formatted') 
           !read (49,*) 
           !read (49,*)tay_simul_c13
call xml2eg_get(doc, 'tau_sim', tay_simul_c13)

!          open (unit=40,file='dw.dat',form='formatted') 
          !read (49,*) 
!          read (40,*)tt_dw,tay_dw
          !read (49,*)tay_dw_c14
call xml2eg_get(doc, 'tau_dw', tay_dw_c14)


!           open (unit=40,file='pcchp_end.dat',form='formatted') 
        !read (49,*)
        !read (49,*)pcchp_end_c15
call xml2eg_get(doc, 'pcchp_end', pcchp_end_c15)


          !read (49,*) 
          !read (49,*)k_ener_ext_c16, k_dens_ext_c16,k_ajb_ext_c16
call xml2eg_get(doc, 'ener_ext', k_ener_ext_c16)
call xml2eg_get(doc, 'dens_ext', k_dens_ext_c16)
call xml2eg_get(doc, 'ajb_ext', k_ajb_ext_c16)

!          open (unit=40,file='tt_kavin2.dat',form='formatted') 
          !read (49,*) 
          !read (49,*)tt_rampup
          !read (49,*) 
          !read (49,*)dt_end_sim,dtpl_term_l,cIp_end
call xml2eg_get(doc, 'tt_rampup', tt_rampup)
call xml2eg_get(doc, 'dt_end_sim', dt_end_sim)
call xml2eg_get(doc, 'dtpl_term_l', dtpl_term_l)
call xml2eg_get(doc, 'cIp_end', cIp_end)

          tt_rampup_c1=tt_rampup
          dt_end_sim_c1=dt_end_sim
          dtpl_term_l_c1=dtpl_term_l
          cIp_end_c1=cIp_end

          dtpl_term_h=0
          
          !read (49,*) 
          !read (49,*)CS1_eob,rms_noise
call xml2eg_get(doc, 'Ics1_eob', CS1_eob)
call xml2eg_get(doc, 'rms_noise', rms_noise)

          CS1_eob_c1=CS1_eob
          rms_noise_c1=rms_noise
          
          
call xml2eg_free_doc(doc)
deallocate(buffer)
	!close(49)
        
        

!         pf(1:npf) = 0.d0
! 
!         do i=1,size(psch%pf_active%coil)
!                 if (associated(psch%pf_active%coil(i)%current%reference%data)) then
!                         pf(ncirc(i)) = dircirc(i)*psch%pf_active%coil(i)%current%reference%data(1)*tpl_dir*1.d-3*pf_turns(ncirc(i))
!                 endif
!         enddo
! 
! 	do i=1,npf
! 
! 	  pf0(i)=pf(i)
!           pf_c1(i)=pf(i)
! 
! 	end do
        
        
2	FORMAT(/,2(2x,1PE10.3))


71 	format (20x,a6/,(6(1pe10.3)))
      RETURN
      END
      
      
      
