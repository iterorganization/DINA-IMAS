!> dina_data_read is the main subroutine to read the input code parameters

subroutine contr_data_read_imas(psch, psch_dw, codeparam)

use ids_schemas, only: ids_pulse_schedule, ids_real, ids_parameters_input

use f90_file_reader, only: file2buffer
use xml2eg_mdl, only: xml2eg_parse_memory, xml2eg_get, type_xml2eg_document, xml2eg_free_doc


     include 'double.inc'
     include 'imas_interface.inc'


type (ids_pulse_schedule)   :: psch, psch_dw
type(ids_parameters_input) :: codeparam

integer :: kpr
  common /ge5/kpr

!character(len=30) :: ConfigFile = 'KMC_Parameters.xml'
type(type_xml2eg_document) :: doc
!character(len=132), pointer :: buffer(:) => NULL()
integer :: io_unit = 1
logical :: errorflag
      
      real (ids_real) Ip_div, Ip_rd, max_VS_lim, c_a_tpl2_lim
      
      real (ids_real) pf_turn
      dimension pf_turn(17)
      DATA (pf_turn(I), I=1,17)/554., 554., 554. ,554., 554. ,248.6, 115.2, 185.9, 169.9, 216.8, 459.4, 1., 1., 1., 1., 1., 1./
      
      
      
      open(unit=49,file='control_init_1.dat', form='formatted')
      
      !call file2buffer(ConfigFile, io_unit, buffer)
      call xml2eg_parse_memory(codeparam%parameters_value, doc)

      call xml2eg_get(doc, 'kpr', kpr)
      call xml2eg_get(doc, 'tcont2', tcont2)
      call xml2eg_get(doc, 'dtcont2', dtcont2)
      call xml2eg_get(doc, 'Ip_div', Ip_div)
      Ip_div = Ip_div * 1.d-6 * tpl_dir
      call xml2eg_get(doc, 'ref_ramp', ref_ramp)
      call xml2eg_get(doc, 'Ip_rd', Ip_rd)
      Ip_rd = Ip_rd * 1.d-6 * tpl_dir
      call xml2eg_get(doc, 'trd_ref', trd_ref)
      call xml2eg_get(doc, 'max_VS_lim', max_VS_lim)
      call xml2eg_get(doc, 'c_a_tpl2_lim', c_a_tpl2_lim)
      call xml2eg_get(doc, 'time_stop', time_stop)
      write (49,'(20(1X,A))') 'tcont2', 'dtcont2', 'Ip_div', 'ref_ramp', 'Ip_rd', 'trd_ref', 'max_VS_lim', 'c_a_tpl2_lim', 'time_stop'
      write (49,*) tcont2, dtcont2, Ip_div, ref_ramp, Ip_rd, trd_ref, max_VS_lim, c_a_tpl2_lim, time_stop


      call xml2eg_get(doc, 'c_a_tpl1', c_a_tpl1)
      call xml2eg_get(doc, 'c_a_tpl1_eob', c_a_tpl1_eob)
      call xml2eg_get(doc, 'c_a_tpl2', c_a_tpl2)
      call xml2eg_get(doc, 'c_a_tpl_min', c_a_tpl_min)
      call xml2eg_get(doc, 'y0', y0)
      call xml2eg_get(doc, 'c1_y0', c1_y0)
      call xml2eg_get(doc, 'c2_y0', c2_y0)
      write (49,'(20(1X,A))') 'c_a_tpl1', 'c_a_tpl1_eob', 'c_a_tpl2', 'c_a_tpl_min', 'y0', 'c1_y0', 'c2_y0'
      write (49,*) c_a_tpl1, c_a_tpl1_eob, c_a_tpl2, c_a_tpl_min, y0, c1_y0, c2_y0


      call xml2eg_get(doc, 't_tran2D', t_tran2D)
      t_tran2D = t_tran2D * 1.d3
      write (49,*) 't_tran2D'
      write (49,*) t_tran2D
      
      ktime = size(psch%position_control%elongation%reference%time)
      write (49,*) 'ktime   !elong_ref.dat'
      write (49,*) ktime
      write (49,*) 'time[S]   elong_ref '
      do i=1,ktime
        write (49,*) psch%position_control%elongation%reference%time(i), psch%position_control%elongation%reference%data(i)
      enddo
      
      ig = 1
      ktime = size(psch%position_control%gap(ig)%value%reference%time)
      write (49,*) 'ktime   !g1.dat'
      write (49,*) ktime
      write (49,*) 'time   '
      do i=1,ktime
        write (49,*) psch%position_control%gap(ig)%value%reference%time(i), psch%position_control%gap(ig)%value%reference%data(i)*1.d2
      enddo
      
      ktime = size(psch_dw%position_control%gap(ig)%value%reference%time)
      write (49,*) 'ktime   !g1_term.dat'
      write (49,*) ktime
      write (49,*) 'time   '
      do i=1,ktime
        write (49,*) psch_dw%position_control%gap(ig)%value%reference%time(i), psch_dw%position_control%gap(ig)%value%reference%data(i)*1.d2
      enddo
      
      
      ig = 2
      ktime = size(psch%position_control%gap(ig)%value%reference%time)
      write (49,*) 'ktime   !g2.dat'
      write (49,*) ktime
      write (49,*) 'time   '
      do i=1,ktime
        write (49,*) psch%position_control%gap(ig)%value%reference%time(i), psch%position_control%gap(ig)%value%reference%data(i)*1.d2
      enddo
      
      ktime = size(psch_dw%position_control%gap(ig)%value%reference%time)
      write (49,*) 'ktime   !g2_term.dat'
      write (49,*) ktime
      write (49,*) 'time   '
      do i=1,ktime
        write (49,*) psch_dw%position_control%gap(ig)%value%reference%time(i), psch_dw%position_control%gap(ig)%value%reference%data(i)*1.d2
      enddo
      
      
      !ig = 3
      ktime = size(psch%position_control%geometric_axis%r%reference%time)
      write (49,*) 'ktime   !g3.dat'
      write (49,*) ktime
      write (49,*) 'time   '
      do i=1,ktime
        write (49,*) psch%position_control%geometric_axis%r%reference%time(i), (psch%position_control%geometric_axis%r%reference%data(i) + psch%position_control%minor_radius%reference%data(i))*1.d2
      enddo
      
      ktime = size(psch_dw%position_control%geometric_axis%r%reference%time)
      write (49,*) 'ktime   !g3_term.dat'
      write (49,*) ktime
      write (49,*) 'time   '
      do i=1,ktime
        write (49,*) psch_dw%position_control%geometric_axis%r%reference%time(i), (psch_dw%position_control%geometric_axis%r%reference%data(i) + psch_dw%position_control%minor_radius%reference%data(i))*1.d2
      enddo
      
      
      ig = 3
      ktime = size(psch%position_control%gap(ig)%value%reference%time)
      write (49,*) 'ktime   !g4.dat'
      write (49,*) ktime
      write (49,*) 'time   '
      do i=1,ktime
        write (49,*) psch%position_control%gap(ig)%value%reference%time(i), psch%position_control%gap(ig)%value%reference%data(i)*1.d2
      enddo
      
      ktime = size(psch_dw%position_control%gap(ig)%value%reference%time)
      write (49,*) 'ktime   !g4_term.dat'
      write (49,*) ktime
      write (49,*) 'time   '
      do i=1,ktime
        write (49,*) psch_dw%position_control%gap(ig)%value%reference%time(i), psch_dw%position_control%gap(ig)%value%reference%data(i)*1.d2
      enddo
      
      
      ig = 4
      ktime = size(psch%position_control%gap(ig)%value%reference%time)
      write (49,*) 'ktime   !g5.dat'
      write (49,*) ktime
      write (49,*) 'time   '
      do i=1,ktime
        write (49,*) psch%position_control%gap(ig)%value%reference%time(i), psch%position_control%gap(ig)%value%reference%data(i)*1.d2
      enddo
      
      ktime = size(psch_dw%position_control%gap(ig)%value%reference%time)
      write (49,*) 'ktime   !g5_term.dat'
      write (49,*) ktime
      write (49,*) 'time   '
      do i=1,ktime
        write (49,*) psch_dw%position_control%gap(ig)%value%reference%time(i), psch_dw%position_control%gap(ig)%value%reference%data(i)*1.d2
      enddo
      
      
      !ig = 6
      ktime = size(psch%position_control%geometric_axis%r%reference%time)
      write (49,*) 'ktime   !g6.dat'
      write (49,*) ktime
      write (49,*) 'time   '
      do i=1,ktime
        write (49,*) psch%position_control%geometric_axis%r%reference%time(i), (psch%position_control%geometric_axis%r%reference%data(i) - psch%position_control%minor_radius%reference%data(i))*1.d2
      enddo
      
      ktime = size(psch_dw%position_control%geometric_axis%r%reference%time)
      write (49,*) 'ktime   !g6_term.dat'
      write (49,*) ktime
      write (49,*) 'time   '
      do i=1,ktime
        write (49,*) psch_dw%position_control%geometric_axis%r%reference%time(i), (psch_dw%position_control%geometric_axis%r%reference%data(i) - psch_dw%position_control%minor_radius%reference%data(i))*1.d2
      enddo
        
        
        
      call xml2eg_get(doc, 'tt_rampup', tt_rampup)
      tt_rampup = tt_rampup * 1.d3
      write (49,*) 'tt_rampup   !tt_kavin2.dat'
      write (49,*) tt_rampup
      
      call xml2eg_get(doc, 'dt_end_sim', dt_end_sim)
      call xml2eg_get(doc, 'dtpl_term_l', dtpl_term_l)
      call xml2eg_get(doc, 'cIp_end', cIp_end)
      cIp_end = cIp_end * 1.d-6 * tpl_dir
      write (49,*) 'dt_end_sim   dtpl_term_l   cIp_end'
      write (49,*) dt_end_sim, dtpl_term_l, cIp_end

      call xml2eg_get(doc, 'Ics1_eob', CS1_eob)
      CS1_eob = CS1_eob * 1.d-3 * tpl_dir
      call xml2eg_get(doc, 'rms_noise', rms_noise)
      write (49,*) 'Ics1_eob(kA)   rms_noise(m/s)'
      write (49,*) CS1_eob, rms_noise
      
      
      write (49,*) 'VS1_max(V)   VS3_max(V)   CS3U_max(V)   CS2U_max(V)   CS1_max(V)   CS2L_max(V)   CS3L_max(V)   PF1_max(V)   PF2_max(V)   PF3_max(V)   PF4_max(V)   PF5_max(V)   PF6_max(V)   Tu(s)   !control_data.dat'
      write (49,*) '6000.0   575.0   2100.0   2100.0   4200.0   2100.0   2100.0   2100.0   3150.0   3150.0   3150.0   3150.0   2100.0   0.04'
      write (49,*) 'c_cur_max   CS3U_max(kA)   CS2U_max(kA)   CS1_max(kA)   CS2L_max(kA)   CS3L_max(kA)   PF1_max(kA)   PF2_max(kA)   PF3_max(kA)   PF4_max(kA)   PF5_max(kA)   PF6_max(kA) '
      write (49,*) '0.98   45.0   45.0   45.0   45.0   45.0   48.0   55.0   55.0   55.0   52.0   52.0 '
      write (49,*) 'CS3U   CS2U   CS1   CS2L   CS3L   PF1   PF2   PF3   PF4   PF5   PF6   VS3   Virt1   Virt2   Virt3   Virt4   Virt5   !n_turn'
      write (49,*) (pf_turn(i),i=1,17)
      write (49,*) ''
      
      
      close(49)
      
      
call xml2eg_free_doc(doc)
!deallocate(buffer)



      open(unit=49,file='scr_data.dat', form='formatted')
      ktime = size(psch%pf_active%coil(1)%current%reference%data)
      write(49,*) 'Time(s),Ip,I(CSU3),I(CSU2),I(CS1),I(CSL2)  '
      do i=1,ktime
        write(49,*) psch%pf_active%coil(1)%current%reference%time(i), &
        & psch%flux_control%i_plasma%reference%data(i)*(tpl_dir*1.d-6), &
        & psch%pf_active%coil(1)%current%reference%data(i)*(tpl_dir*1.d-6*pf_turn(1)), &
        & psch%pf_active%coil(2)%current%reference%data(i)*(tpl_dir*1.d-6*pf_turn(2)), &
        & psch%pf_active%coil(3)%current%reference%data(i)*(tpl_dir*1.d-6*pf_turn(3)), &
        & psch%pf_active%coil(5)%current%reference%data(i)*(tpl_dir*1.d-6*pf_turn(4)), &
        & psch%pf_active%coil(6)%current%reference%data(i)*(tpl_dir*1.d-6*pf_turn(5)), &
        & psch%pf_active%coil(7)%current%reference%data(i)*(tpl_dir*1.d-6*pf_turn(6)), &
        & psch%pf_active%coil(8)%current%reference%data(i)*(tpl_dir*1.d-6*pf_turn(7)), &
        & psch%pf_active%coil(9)%current%reference%data(i)*(tpl_dir*1.d-6*pf_turn(8)), &
        & psch%pf_active%coil(10)%current%reference%data(i)*(tpl_dir*1.d-6*pf_turn(9)), &
        & psch%pf_active%coil(11)%current%reference%data(i)*(tpl_dir*1.d-6*pf_turn(10)), &
        & psch%pf_active%coil(12)%current%reference%data(i)*(tpl_dir*1.d-6*pf_turn(11))
      enddo
      write(49,*) ''
      close(49)
      
      
      open(unit=49,file='volt.dat', form='formatted')
      ktime = size(psch%pf_active%supply(1)%voltage%reference%data)
      write(49,*) '!!!!!!!!!!!!'
      do i=1,ktime
        write(49,*) psch%pf_active%supply(1)%voltage%reference%time(i)*1.d3, &
        & psch%pf_active%supply(1)%voltage%reference%data(i)*(tpl_dir/pf_turn(1)), &
        & psch%pf_active%supply(2)%voltage%reference%data(i)*(tpl_dir/pf_turn(2)), &
        & (psch%pf_active%supply(3)%voltage%reference%data(i) + psch%pf_active%supply(4)%voltage%reference%data(i))*(tpl_dir/pf_turn(3)), &
        & psch%pf_active%supply(5)%voltage%reference%data(i)*(tpl_dir/pf_turn(4)), &
        & psch%pf_active%supply(6)%voltage%reference%data(i)*(tpl_dir/pf_turn(5)), &
        & psch%pf_active%supply(7)%voltage%reference%data(i)*(tpl_dir/pf_turn(6)), &
        & psch%pf_active%supply(8)%voltage%reference%data(i)*(tpl_dir/pf_turn(7)), &
        & psch%pf_active%supply(9)%voltage%reference%data(i)*(tpl_dir/pf_turn(8)), &
        & psch%pf_active%supply(10)%voltage%reference%data(i)*(tpl_dir/pf_turn(9)), &
        & psch%pf_active%supply(11)%voltage%reference%data(i)*(tpl_dir/pf_turn(10)), &
        & psch%pf_active%supply(13)%voltage%reference%data(i)*(tpl_dir/pf_turn(11))
      enddo
      write(49,*) ''
      close(49)
      
      
      
      
      
2	FORMAT(/,2(2x,1PE10.3))
71 	format (20x,a6/,(6(1pe10.3)))
      RETURN
      END
      
      
      
