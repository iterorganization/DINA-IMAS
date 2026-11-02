************************************************************
cNAKA 12/10/'99
c
c	subroutine SCEN_CONTROL
c	
c		USER ROUTINE FOR SCENARIO SIMULATIONS BY
c		MARIO CAVINATO
c			E-MAIL cavinam@itergps.naka.jaeri.go.jp
c
c	IMPLEMENTATION of centroid controller for limiter plasma;
c	shape controller for diverted plasma and switching
c	between the two.
c	
c	COILS order: PF1->PF6 CS3L CS2L CS1(series L+U) CS2U CS3U


        subroutine SCEN_CONTROL_fil()
	include 'double.inc'
        include 'new_com.inc'

        call SCEN_CONTROL_fil_c(
     &       tpl,cip1,zref,rref,
     &       npf,vchopper,r_cur,z_cur,
     &       u_1,u_kd,d_gaps,zvel,elong,tt,gaps,gaps0,
     &       pf,pf_p,ksepa,
     &       state,state_old,pf_turns,zvconverter,zvresist,
     &       u_ffw,state_vert,state_old_vert,rmag,zmag,pf_lim,
     &       r_tok,z_tok,zvel_tok)


        return
        end

        subroutine SCEN_CONTROL_fil_c(
     &       tpl,cip1,zref,rref,
     &       npf,vchopper,r_cur,z_cur,
     &       u_1,u_kd,error,zvel,elong,tt,gaps,gaps_ref_p,
     &       pf,curr_ref_p,klim,
     &       state,state_old,pf_turns,zvconverter,zvresist,
     &       u_help,state_vert,state_old_vert,rmag,zmag,pf_lim,
     &       r_tok,z_tok,zvel_tok)

c	SET PARAMETERS AND VARIABLES

	include 'double.inc'
        include 'parf1'
        include 'parf_mario'
        include 'parf8'

ccc	parameter(num_coils=11) (inside of parf_mario)
	parameter(num_inputs_lim=14, num_states_lim=14)
ccc	parameter(num_inputs_lim=3, num_states_lim=3)
c mario	parameter(num_inputs_div=18,num_states_div=39)
c kavin_1         parameter(num_inputs_div=18,num_states_div=28)
        parameter(num_inputs_div=18,num_states_div=18)
	parameter(num_gaps=6)
	parameter(num_states_vert=4)


	dimension a_lim(num_states_lim,num_states_lim),
     &  b_lim(num_states_lim,num_inputs_lim),
     &  c_lim(num_coils,num_states_lim),
     &  d_lim(num_coils,num_inputs_lim)

	dimension a_div(num_states_div, num_states_div),
     &  b_div(num_states_div, num_inputs_div),
     &  c_div(num_coils,num_states_div),
     &  d_div(num_coils,num_inputs_div)

	dimension a_vert(num_states_vert,num_states_vert),
     &  b_vert(num_states_vert,1),
     &  c_vert(num_coils,num_states_vert),
     &  d_vert(num_coils,1)


	dimension error(kf_c)
	dimension a_gz(num_coils)
	dimension u_1(*),u_kd(*),pf_lim(*),coef_pf_lim(kf)

	dimension gaps(*),gaps_ref_p(*),gaps_refXPF(num_gaps)
	dimension pf(*),curr_ref_p(*),curr_refXPF(kf)

        dimension gaps_ref(kf),curr_ref(kf)

	dimension vchopper(*),u_help(kf)

	dimension state(*),state_old(*),pf_turns(*)
	dimension state_vert(*),state_old_vert(*)

        dimension zresist(kf),zvboost(kf),zvresist(kf),
     *zsatpf(kf),ztotsat(kf),zvconverter(kf)

        dimension curr_max(kf),curr_gain(kf)

	LOGICAL diverted,using_lim,using_div,on_transition
	real XPFtime,V_sat_imb(kf)
	real ak(kf_c,kf_c),bk(kf_c,kf_c),ck(kf_c,kf_c),dk(kf_c,kf_c)
	integer num_states,num_inputs

	character *20 apr


	if(kpr.eq.1)print *,' scen_control'


	t_zvel=100.
	zvel_in=zvel_tok
c	call zvel_filter_c(zvel_tok,t_zvel)


c*** tt is DINA time in ms
        time=tt*1.e-3

	i_en=i_en+1
c************************************
c PART DONE AT FIRST ITERATION ONLY *
c************************************
        if(i_en.eq.1)then
c************************************


           open (unit=41,file='XPF_time_data',form='formatted')
           read (41,*)
           read (41,*)switch_delay,refval_ramptime
           close (41)

c	Read Controller Matrices
c
c LIMITER phase CONTROLLER

           open (unit=41,file='a_lim.flat',form='formatted')
           do i = 1, num_states_lim
              read(41,*)(a_lim(i,j),j=1,num_states_lim)
           end do
           close (41)
           open (unit=41,file='b_lim.flat',form='formatted')
           do i = 1, num_states_lim
              read(41,*)(b_lim(i,j),j=1,num_inputs_lim)
           end do
           close (41)
           open (unit=41,file='c_lim.flat',form='formatted')
           do i = 1, num_coils
              read(41,*)(c_lim(i,j),j=1,num_states_lim)
           end do
           close (41)
           open (unit=41,file='d_lim.flat',form='formatted')
           do i = 1, num_coils
              read(41,*)( d_lim(i,j),j=1,num_inputs_lim)
           end do
           close (41)

c DIVERTOR phase CONTROLLER


           open (unit=41,file='a_div.flat',form='formatted')
           do i = 1, num_states_div
              read(41,*)(a_div(i,j),j=1,num_states_div)
           end do
           close (41)
           open (unit=41,file='b_div.flat',form='formatted')
           do i = 1, num_states_div
              read(41,*)(b_div(i,j),j=1,num_inputs_div)
           end do
           close (41)
           open (unit=41,file='c_div.flat',form='formatted')
           do i = 1, num_coils
              read(41,*)(c_div(i,j),j=1,num_states_div)
           end do
           close (41)
           open (unit=41,file='d_div.flat',form='formatted')
           do i = 1, num_coils
              read(41,*)(d_div(i,j),j=1,num_inputs_div)
           end do
           close (41)

c	STABILIZING CONTROLLER (always on)
	open (unit=41, file='gz.flat',form='formatted')
	do i=1,num_coils
	  read (41,*)a_gz(i)
	end do
	close (41)

	open (unit=41, file='Avert.flat',form='formatted')
	do i=1,num_states_vert
	read(41,*)(a_vert(i,j),j=1,num_states_vert)
	end do
	close (41)
	open (unit=41, file='Bvert.flat',form='formatted')
	do i=1,num_states_vert
	read(41,*)(b_vert(i,j),j=1,1)
	end do
	close (41)
	open (unit=41, file='Cvert.flat',form='formatted')
	do i=1, num_coils
	read(41,*)(c_vert(i,j),j=1,num_states_vert)
	end do
	close (41)
	open (unit=41, file='Dvert.flat',form='formatted')
	do i=1, num_coils
	read(41,*)(d_vert(i,j),j=1,1)
	end do
	close (41)


        
c        if(kpr.eq.1)print*,'rref zref',rref,zref

c        pause '!!!!!!!! from con_mario'


c    VOLTAGE SATURATIONS

      do i=1,num_coils
        V_sat_imb(i)=abs(a_gz(i)*56.6)
      end do

C First controller: limiter

           diverted=.false.
           on_transition=.false.
           using_lim=.true.
           using_div=.false.
           num_states=num_states_lim
           num_inputs=num_inputs_lim

         do i=1,num_states
           state_old(i)=0.00
         end do

        do  i = 1,num_states
           do j=1,num_states
              ak(i,j)=a_lim(i,j)
           end do
        end do

        do  i = 1,num_states
           do j=1,num_inputs
              bk(i,j)=b_lim(i,j)
           end do
        end do

        do  i = 1,num_coils
           do j=1,num_states
              ck(i,j)=c_lim(i,j)
           end do
        end do

        do  i = 1,num_coils
           do j=1,num_inputs
              dk(i,j)=d_lim(i,j)
           end do
        end do



      end if

c*******************************************
c END OF PART DONE AT FIRST ITERATION ONLY *
c*******************************************

	elong_min=1.
	elong_max=1.9


c ==> Get Feedforward Voltages (u_help)
	v_coef=0.5
	  npf2=npf-4
        do i=1,npf2
c*** Change in PF3 and PF4 !!!
c	if(i.eq.3.or.i.eq.4)then
c	if(time.lt.5)u_help(i)=vchopper(i)	
c	if(time.ge.5.and.time.lt.10)u_help(i)=vchopper(i)*0.25	
c	if(time.ge.10)u_help(i)=vchopper(i)*v_coef
c	end if	
c	if(i.ne.3.and.i.ne.4)u_help(i)=vchopper(i)*v_coef
c	if(i.eq.3.or.i.eq.4)u_help(i)=vchopper(i)*v_coef
c	if(i.ne.3.and.i.ne.4)u_help(i)=vchopper(i)
           u_help(i)=vchopper(i)
c           u_help(i)=vchopper(i)*v_coef
c!!!	u_help(i)=0.	
        end do

c ==> SWITCHING BETWEEN CONTROLLERS
c at the first transition from limiter to diverted plasma
	if (.not.diverted.and.klim.eq.1) then
           XPFtime=time
	end if

	if (klim.eq.1) then
           diverted=.true.
	end if


c        if(kpr.eq.1)print*,'klim=',klim
c        if(kpr.eq.1)print*,'using_lim=',using_lim
c        if(kpr.eq.1)print*,'diverted=',diverted
c        if(kpr.eq.1)print*,'time=',time
c        if(kpr.eq.1)print*,'XPFtime=',XPFtime
c        if(kpr.eq.1)print*,'switch_delay=',switch_delay



c switch controller with delay after XPF
	if(using_lim.and.diverted.and.time.ge.
     *       (XPFtime+switch_delay))then

           using_div=.true.
           using_lim=.false.
           num_inputs=num_inputs_div
           num_states=num_states_div



c        if(kpr.eq.1)print*,'klim=',klim
c        if(kpr.eq.1)print*,'using_lim=',using_lim
c        if(kpr.eq.1)print*,'diverted=',diverted
c        if(kpr.eq.1)print*,'time=',time
c        if(kpr.eq.1)print*,'XPFtime=',XPFtime
c        if(kpr.eq.1)print*,'switch_delay=',switch_delay
c        if(kpr.eq.1)print*,'inside of loop'

           do i=1,num_gaps
              gaps_refXPF(i)=gaps(i)
           end do
c!!!!!!           do i=1,num_coils
           do i=1,num_coils+1
              curr_refXPF(i)=pf(i)
           end do

         do i=1,num_states
           state_old(i)=0.00
         end do

        do  i = 1,num_states
           do j=1,num_states
              ak(i,j)=a_div(i,j)
           end do
        end do

        do  i = 1,num_states
           do j=1,num_inputs
              bk(i,j)=b_div(i,j)
           end do
        end do

        do  i = 1,num_coils
           do j=1,num_states
              ck(i,j)=c_div(i,j)
           end do
        end do

        do  i = 1,num_coils
           do j=1,num_inputs
              dk(i,j)=d_div(i,j)
           end do
        end do

        end if

c Signal of transient in controller switching
	if(using_div.and.
     &       time.lt.(XPFtime+switch_delay+refval_ramptime))then
           on_transition=.true.
        else
           on_transition=.false.
        end if

c  ==> COMPUTE ERROR VECTOR
c  reference values rref;zref;cip1:Ip_ref;Gap_ref

c RAMPING OF REFERENCE VALUES FOR SMOOTH CONTROLLER SWITCHING
	if(on_transition) then
           alfa=(time-XPFtime-switch_delay)/refval_ramptime
           do i=1,num_gaps
              gaps_ref(i)=alfa*gaps_ref_p(i)+(1-alfa)*gaps_refXPF(i)
           end do
c!!!!!!!!!           do i=1,num_coils
           do i=1,num_coils+1
              curr_ref(i)=alfa*curr_ref_p(i)+(1-alfa)*curr_refXPF(i)
           end do
	end if

c*********
        if(.not.on_transition)then
           do i=1,num_gaps
              gaps_ref(i)=gaps_ref_p(i)
           end do
           do i=1,num_coils+1
              curr_ref(i)=curr_ref_p(i)              
           end do
        end if
c*********

	if(using_lim) then
c           error(1)=(r_cur-rref)/1.e2
c           error(2)=(z_cur-zref)/1.e2

c	coef_lim=4.
c	coef_lim=2.
	coef_lim=1.
c           error(1)=(rmag-rref)/1.e2

!!!           error(1)=(rmag-rref)/1.e2*coef_lim
           error(1)=(r_tok-rref)/1.e2*coef_lim
c           error(2)=(zmag-zref)/1.e2


c           error(2)=(zmag-zref)/1.e2*coef_lim
           error(2)=(z_tok-zref)/1.e2*coef_lim

c           error(3)=(tpl-cip1)/1.e3
           error(3)=(tpl-cip1)/1.e3*coef_lim
	do i=1,num_coils
              if(i.le.9)error(3+i)=(pf(i)-curr_ref(i))/1.e3
              if(i.eq.10)error(3+i)=(pf(11)-curr_ref(11))/1.e3
              if(i.eq.11)error(3+i)=(pf(12)-curr_ref(12))/1.e3
           end do
	end if

	if(using_div) then
           do i=1,num_gaps
              error(i)=(gaps(i)-gaps_ref(i))/1.e2
           end do
           error(num_gaps+1)=(tpl-cip1)/1.e3
           do i=1,num_coils
              if(i.le.9)error(num_gaps+1+i)=(pf(i)-curr_ref(i))/1.e3
              if(i.eq.10)error(num_gaps+1+i)=(pf(11)-curr_ref(11))/1.e3
              if(i.eq.11)error(num_gaps+1+i)=(pf(12)-curr_ref(12))/1.e3

              coef_1=1.
              coef_2=1.
              if(i.le.6)error(num_gaps+1+i)=coef_1*error(num_gaps+1+i)
              if(i.gt.6)error(num_gaps+1+i)=coef_2*error(num_gaps+1+i)

           end do

	end if

c ==> Scaling of stabilizing controller gains

	g_d=150.*10.*(tpl/(15.*1.e3))



        if(kpr.eq.1)print*,'rmag rref',rmag,rref
        if(kpr.eq.1)print*,'zmag z_tok zref',zmag,z_tok,zref
        if(kpr.eq.1)print*,'tpl cip1',tpl,cip1
        if(kpr.eq.1)print*,'zvel zvel_tok ',zvel,zvel_tok

c ===>  CONTROLLER IMPLEMENTATION

c STABILIZING CONTROLLER
c The centroid velocity is in cm/ms in Dina => is needed 
c to multiply by ten to get m/s

	do i=1,num_coils
c!!!           u_kd(i)=g_d*a_gz(i)*zvel
        end do

c  ===> zeroing internal variables ...

        do i=1,num_coils
           u_kd(i)=0.00
        end do


        do i=1,num_states_vert
           state_vert(i)=0.00
        end do

c  ===> compute state vector ...

        do i=1,num_states_vert
           do j=1,num_states_vert
              state_vert(i)=state_vert(i)+a_vert(i,j)*state_old_vert(j)
           end do
        end do
        do i=1,num_states_vert
           do j=1,1

c              state_vert(i)=state_vert(i)+b_vert(i,j)*10*zvel
              state_vert(i)=state_vert(i)+b_vert(i,j)*10*zvel_tok
c              state_vert(i)=state_vert(i)+b_vert(i,j)*20*zvel_tok

           end do
        end do


c  ===> compute control vector (without saturation)...


        do i=1,num_coils
           do j=1,num_states_vert
              u_kd(i)=u_kd(i)+c_vert(i,j)*(tpl/15.e3)*state_vert(j)
           end do
        end do

        do i=1,num_coils
           do j=1,1
c              u_kd(i)=u_kd(i)+d_vert(i,j)*(tpl/15.e3)*10*zvel
              u_kd(i)=u_kd(i)+d_vert(i,j)*(tpl/15.e3)*10*zvel_tok
c              u_kd(i)=u_kd(i)+d_vert(i,j)*(tpl/15.e3)*20*zvel_tok


           end do
        end do

c  ===> update state vector ...
c We are doing it outside
c		do i=1,num_states_vert
c		  state_old_vert(i)=state_vert(i)
c		end do


c POSITION/SHAPE CONTROLLER
c  ===> zeroing internal variables ...

        do i=1,num_coils
           u_1(i)=0.00
        end do


        do i=1,num_states
           state(i)=0.00
        end do

c  ===> compute state vector ...

        do i=1,num_states
           do j=1,num_states
              state(i)=state(i)+ak(i,j)*state_old(j)
           end do
        end do


        do i=1,num_states
           do j=1,num_inputs
              state(i)=state(i)+bk(i,j)*error(j)
           end do
        end do


c  ===> compute control vector (without saturation)...


        do i=1,num_coils
           do j=1,num_states
	if(using_lim) then
              u_1(i)=u_1(i)+ck(i,j)*(tpl/15.e3)*state(j)
	else
              u_1(i)=u_1(i)+ck(i,j)*state(j)
	end if
           end do
        end do

        do i=1,num_coils
           do j=1,num_inputs
	if(using_lim) then
              u_1(i)=u_1(i)+dk(i,j)*(tpl/15.e3)*error(j)
	else
              u_1(i)=u_1(i)+dk(i,j)*error(j)
	end if
           end do
        end do

c  ===> update state vector ...
c We are doing it outside
c		do i=1,num_states
c		  state_old(i)=state(i)
c		end do

c        if(kpr.eq.1)print*,'state'
c        if(kpr.eq.1)print*,(state(i),i=1,39)
c        if(kpr.eq.1)print*,'state_old'
c        if(kpr.eq.1)print*,(state_old(i),i=1,39)
c        pause 'form con_mario'



c	SATURATION ON IMBALANCE CONVERTER

        apr='u_kd'
        if(kpr.eq.1)print 71,apr,(u_kd(i),i=1,num_coils)

       do j=2,5
         if(abs(u_kd(j)).gt.V_sat_imb(j))then
           u_kd(j)=(u_kd(j)/abs(u_kd(j)))*V_sat_imb(j)
         end if
       end do

	do i=1,num_coils
c           u_kd(i)=g_d*a_gz(i)*zvel_tok
        end do


        apr='u_kd'
        if(kpr.eq.1)print 71,apr,(u_kd(i),i=1,num_coils)






c	SNU RESISTORS AND BOOSTERS

       do i=1,npf
	   zvresist(i)=0
           zresist(i)=0.
           zvboost(i)=0.
           zsatpf(i)=1500./pf_turns(i)
        end do
        
c*** Resistors ***
	if(time.le.126.)zresist(1)=7.18e-3
	if(time.le.4.27)zresist(6)=5.14e-2
	if(time.le.126.)zresist(7)=1.35e-2
	if(time.le.49.3)zresist(8)=4.5e-2
	if(time.le.24.2)zresist(9)=9.255e-2
	zresist(10)=zresist(9)
	if(time.le.52.)zresist(11)=4.44e-2
	if(time.le.100.)zresist(12)=3.22e-2

        do i=1,npf
           zvresist(i)=-(zresist(i)/pf_turns(i))*
     *          (pf(i)*1.e3/pf_turns(i))
           if(zvresist(i).gt.0)zvresist(i)=0.00
        end do

c*** Boosters ***
        do i=2,5
           if(abs(pf(i)/pf_turns(i)).le.10.)zvboost(i)=4.2e3/pf_turns(i)
        end do


C	CALCULATE FEEDFORWARD + FEEDBACK (SLOW LOOP ONLY)
        
cc        do i=1,npf
cc           if(time.ge.65.)u_help(i)=0.
cc        end do


        do i=1,npf
           if(i.le.8)vchopper(i)=u_1(i)+u_help(i)
           if(i.eq.9)vchopper(i)=u_1(i)/2+(u_help(i)+u_help(i+1))/2
           if(i.eq.10)vchopper(i)=vchopper(9)
           if(i.eq.11)vchopper(i)=u_1(10)+u_help(11)
           if(i.eq.12)vchopper(i)=u_1(11)+u_help(12)
        end do

C	SATURATIONS ON MAIN CONVERTERS

	do i=1,npf

c*******
c           coef_pf_lim(i)=1.
c           if(abs(pf(i)).gt.pf_lim(i))coef_pf_lim(i)=0.
           curr_max(i)=45.*pf_turns(i)
           if(i.eq.2)curr_max(i)=41.*pf_turns(i)
           curr_gain(i)=curr_max(i)*0.95
           if(abs(pf(i)).ge.curr_gain(i))then
              coef_pf_lim(i)=((curr_max(i)-abs(pf(i)))/
     &        (curr_max(i)-curr_gain(i)))**3
           else
              coef_pf_lim(i)=1.
           end if
c*******

           ztotsat(i)=zsatpf(i)+zvboost(i)
           zvconverter(i)=vchopper(i)-zvresist(i)
           if(abs(zvconverter(i)).gt.ztotsat(i))
     * zvconverter(i)=(zvconverter(i)/abs(zvconverter(i)))*ztotsat(i)
           zvconverter(i)=coef_pf_lim(i)*zvconverter(i)


           if(i.le.8)vchopper(i)=zvconverter(i)+zvresist(i)+u_kd(i)
           if(i.eq.9)vchopper(i)=zvconverter(i)+zvresist(i)+u_kd(i)/2
           if(i.eq.10)vchopper(i)=vchopper(9)
           if(i.eq.11)vchopper(i)=zvconverter(i)+zvresist(i)+u_kd(10)
           if(i.eq.12)vchopper(i)=zvconverter(i)+zvresist(i)+u_kd(11)
        end do


        apr='u_1'
c        if(kpr.eq.1)print 71,apr,(u_1(i),i=1,num_coils)
        apr='u_kd'
c        if(kpr.eq.1)print 71,apr,(u_kd(i),i=1,num_coils)
        apr='u_1'
c       if(kpr.eq.1)print 71,apr,(u_help(i),i=1,num_coils+1)
        apr='error'
c        if(kpr.eq.1)print 71,apr,(error(i),i=1,3)
        apr='V_sat_imb'
c        if(kpr.eq.1)print 71,apr,(V_sat_imb(i),i=1,num_coils)

c        pause 'from mario'


        if(kpr.eq.1)print*,'r_cur z_cur',r_cur,z_cur
        if(kpr.eq.1)print*,'r_tok z_tok',r_tok,z_tok

        write(6,'("zvel zvel_in zvel_tok", 6(1pe12.5))'),
     *  zvel,zvel_in,zvel_tok


        if(kpr.eq.1)print*,'zvel zvel_in zvel_tok',zvel_in,zvel_tok





71	FORMAT(5X,A20/,(2x,6(1PE11.3)))

        return
        end

