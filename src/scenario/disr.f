	subroutine bet_li_dat()
	include 'double.inc'
	include 'new_com.inc'

	call bet_li_dat_c(t_beta,alf_beta,t_li,delta_time,kpr)

	return
	end


	subroutine bet_li_dat_c(t_beta,alf_beta,t_li,delta_time,kpr)
	include 'double.inc'

	open ( unit=41,file='bet_li.dat',form='formatted')

	read (41,*)
	read (41,*)t_beta,alf_beta
	read (41,*)
	read (41,*)t_li
	read (41,*)
	read (41,*)delta_time

	if(kpr.eq.1)print *,' ** t_beta,alf_beta,t_li ',t_beta,alf_beta,t_li
        if(kpr.eq.1)print*,'delta_time',delta_time

	return
	end


	subroutine tem_con2()
	include 'double.inc'
	include 'new_com.inc'

	call tem_con2_c(
     *  n,tt,t_beta,te0,tq0,ten,tqn,alf_beta,delta_time)

	return
	end


	subroutine tem_con2_c(
     *  n,tt,t_beta,te0,tq0,ten,tqn,alf_beta,delta_time)

	include 'double.inc'
	dimension te0(*),tq0(*),ten(*),tqn(*)

        common
     *  /ge5/kpr
	character *20 apr
c--------------------------------------------------------


	if(kpr.eq.1)print *,' tt t_beta ',tt,t_beta

ccccc        if(tt.ge.t_beta)i_en=i_en+1

ccccc        if(i_en.eq.1)then
c        if(tt.ge.t_beta)then
        if(tt.ge.t_beta.and.i_en.le.1)then

           i_en=i_en+1
           
           t_beta=t_beta+delta_time
	apr='-te0-'
	if(kpr.eq.1)print 71,apr,(te0(i),i=1,n)

	apr='-tq0-'
	if(kpr.eq.1)print 71,apr,(tq0(i),i=1,n)

	te_a=alf_beta*te0(1)
	ti_a=alf_beta*tq0(1)

	te_b=te0(n)
	ti_b=tq0(n)


	al1=(te_a-te_b)/(te0(1)-te_b)
	do i=1,n
           te0(i)=(te0(i)-te_b)*al1+te_b
	end do

	apr='-te0-'
	if(kpr.eq.1)print 71,apr,(te0(i),i=1,n)

	al1=(ti_a-ti_b)/(tq0(1)-ti_b)
	do i=1,n
           tq0(i)=(tq0(i)-ti_b)*al1+ti_b
	end do

	apr='-tq0-'
	if(kpr.eq.1)print 71,apr,(tq0(i),i=1,n)

	if(kpr.eq.1)print *,' te_a te_b --',te_a,te_b
	if(kpr.eq.1)print *,' ti_a ti_b --',ti_a,ti_b

	do i=1,n
           ten(i)=te0(i)
           tqn(i)=tq0(i)
	end do

	apr='-ten-'
	if(kpr.eq.1)print 71,apr,(ten(i),i=1,n)
	apr='-tqn-'
	if(kpr.eq.1)print 71,apr,(tqn(i),i=1,n)

	end if


71	FORMAT(5X,A10/,(2x,6(1PE11.3)))

	return
	end

	subroutine li_d()
	include 'double.inc'

	include 'new_com.inc'

	call li_d_c(
     *  ntay,li_drop,n_dif,tt,t_li,delta_time,kpr)



	return
	end

	subroutine li_d_c(
     *  ntay,li_drop,n_dif,tt,t_li,delta_time,kpr)

	include 'double.inc'
cccccccc	if(tt.ge.t_li)i_en=i_en+1

cccccccc        if(i_en.eq.1)then


c        if(tt.ge.t_li)then


        if(tt.ge.t_li.and.i_en.le.1)then

           i_en=i_en+1

           t_li=t_li+delta_time

	   li_drop=ntay

	   n_dif=1
	else
	   n_dif=0
	end if
	

        if(ntay.eq.li_drop)then
	   n_dif=1
	else
	   n_dif=0
	end if


	return
	end

	subroutine delr_filter()
	include 'double.inc'
	include 'new_com.inc'

	call delr_filter_c(
     *  del_r,ntay,tay,tt)

	return
	end

	subroutine delr_filter_c(
     *  del_r,ntay,tay,tt)

	include 'double.inc'
c	print *,' tt tay del_r----',tt,tay,del_r

	if(time.lt.tt-0.5*tay)then
c  saving for the next time_step...
	e1 = f9a
	v1 = f9af
	time1 = time
	end if


	time=tt

	f9a=del_r

        i_en=i_en+1
	if(i_en.eq.1)then
           e1 = f9a
           f9af=e1
           v1 = f9af
           time1 = time
        end if

	taup=5.*tay

	qqp = 0.5 * (time - time1)/taup

c    ;  /* 1/taup = 1/1. = 1. */

	f9af =(qqp * (f9a + e1) - (qqp - 1.0) * v1) / (qqp + 1.0)

c	print *,' qqp e1 v1 ----',qqp,e1,v1
c	print *,'   f9a f9af----',f9a,f9af

	del_r=f9af


	return
	end

	subroutine tem_feed()

	include 'double.inc'
	include 'new_com.inc'

	call tem_feed_c(
     *  te_a,te_b,tpl,tpl_exp,te_a0)

	return
	end

	subroutine tem_feed_c(
     *  te_a,te_b,tpl,tpl_exp,te_a0)

	include 'double.inc'
	character *12 apr


	print *,' tpl tpl_exp from tem_feed',tpl,tpl_exp

	al1=tpl_exp/tpl

	
	te_a=te_a*al1
	te_b=te_b*al1
	te_a0=te_a

	print *,' te_a te_b al1 =',te_a,te_b,al1

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))

	return
	end

	subroutine den_profiles()
	include 'double.inc'

	include 'new_com.inc'

	call den_profiles_c(
     *  n,pd0,pt0,pne,
     *  pd0_a,pd0_b,pw_p,
     *  a)

	return
	end

	subroutine den_profiles_c(
     *  n,pd0,pt0,pne,
     *  pd0_a,pd0_b,pw_p,
     *  a)

	include 'double.inc'
	character *12 apr
	dimension pd0(*),pt0(*),pne(*),a(*)


	call pd0_a_read()
	call pd0_b_read()

	call pw_p_read()

	do i=1,n

	psix=a(i)+1.e-8

	pd0(i)=pd0_b+(1.-psix**pw_p)*(pd0_a-pd0_b)
	pt0(i)=pd0(i)
	pne(i)=pd0(i)+pt0(i)
	end do

	apr='-pd0-'
	print 71,apr,(pd0(i),i=1,n)


71	FORMAT(5X,A10/,(2x,6(1PE11.3)))

	return
	end

	subroutine tem_profiles()
	include 'double.inc'

	include 'new_com.inc'

	call tem_profiles_c(
     *  n,te0,tq0,
     *  te_a,te_b,pw_e,
     *  a)

	return
	end

	subroutine tem_profiles_c(
     *  n,te0,tq0,
     *  te_a,te_b,pw_e,
     *  a)

	include 'double.inc'
	character *12 apr
	dimension te0(*),tq0(*),a(*)


	call te_a_read()
	call te_b_read()

	call pw_e_read()



	do i=1,n
	psix=a(i)
	te0(i)=te_b+(1.-psix**pw_e)*(te_a-te_b)
	tq0(i)=te0(i)
	end do

	apr='-te0-'
	print 71,apr,(te0(i),i=1,n)


71	FORMAT(5X,A10/,(2x,6(1PE11.3)))

	return
	end

	subroutine profiles()

	include 'double.inc'
	include 'new_com.inc'

	call profiles_c(
     *  n,pd0,pt0,pne,te0,tq0,
     *  pd0_a,pd0_b,pw_p,
     *  te_a,te_b,pw_e,
     *  a)

	return
	end

	subroutine profiles_c(
     *  n,pd0,pt0,pne,te0,tq0,
     *  pd0_a,pd0_b,pw_p,
     *  te_a,te_b,pw_e,
     *  a)

	include 'double.inc'
	character *12 apr
	dimension pd0(*),pt0(*),pne(*),te0(*),tq0(*),a(*)


	call pd0_a_read()
	call pd0_b_read()

	call te_a_read()
	call te_b_read()

	call pw_p_read()
	call pw_e_read()



	do i=1,n
	psix=a(i)
	pd0(i)=pd0_b+(1.-psix**pw_p)*(pd0_a-pd0_b)
	pt0(i)=pd0(i)
	pne(i)=pd0(i)+pt0(i)
	te0(i)=te_b+(1.-psix**pw_e)*(te_a-te_b)
	tq0(i)=te0(i)
	end do

	apr='-te0-'
	print 71,apr,(te0(i),i=1,n)
	apr='-pd0-'
	print 71,apr,(pd0(i),i=1,n)
	apr='-pne-'
	print 71,apr,(pne(i),i=1,n)


71	FORMAT(5X,A10/,(2x,6(1PE11.3)))

	return
	end

	subroutine maj_d3d_new()
	include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *	/efit6/tpl_p
	common
     *  /keys5/next
	common
     *	/ge1e/rs0,tpl
     *  /ge2/NTAY,TAY,TT
     *  /ge5/kpr
     *  /ge7/eu,rs,zout,elong
     *  /ge7e/eu_u
	common
     *  /dfm3/dfmax(npo),dfmax0(npo)
	common
     *  /halo1/c_h,d_halo,fmax_in,tpl_in
     *  /halo2/kmaj,k_q,k_d,kaxis,ndisrup
     *  /halo2e/next0,li_drop,n_li,n_dif,nmix
     *  /halo3/tay_00,tay_th,t_disr,d_tpl,tpl_end
     *  /halo4/expfg,avalb,w_h,del_r,al0
     *  /halo4e/w_h0,delaval0,pshalo0,te_h0
     *  /halo5/q_vde,q_95,del_f,i_halo
     *  /halo5e/pshalo
     *  /halo9e/dfmax_h
     *  /halo12/te_h
        common
     *	/fluxc6/pmag,pbound,psep,p_s,delaval,dr_h
	common
     *  /en1e/te_a,ti_a,te_b,ti_b,pw_e
     *  /en1d/te_a0
     *  /en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),WE0(npo),
     *  WQ0(npo)

	character *20 apr
c--------------------------------------------------------
	if(ntay.lt.ndisrup)return
c-------------------------------------------
c!!!	kaxis=0
	if(ntay.eq.ndisrup)then
	print *,' ntay delta -- disruption--',ntay,delta
	tay=tay_th
	print *,' **  tay=TAY_th ',tay
        print*,'ntay=',ntay
	call cam_t()
	call inv()
	end if
c---------------------

	print *,' tt time_disr t_disr-',tt,time_disr,t_disr

	if(tt.gt.time_disr+t_disr)i_dis=i_dis+1

	if(i_dis.eq.1)then
	kaxis=1
	k_d=1
	tpl_in=tpl
	fmax_in=dfmax(n)
	eu_in=eu
	el_in=elong
	print *,' ==== k_d kaxis te_a te_b',k_d,kaxis,te_a,te_b
	end if

c--------------------------------------
	if(k_d.gt.0)then
	fmax_avr=dfmax(n)

c	del_r1=c_h*d_halo*(1.-(fmax_avr/
c     *  fmax_in)**(1.+tpl/tpl_in) )

        del_r1=c_h*tay

	eu_m=amax1(eu,eu_u)

ccc!!!	del_r1=c_h*(sqrt(el_in)*eu_in-sqrt(elong)*eu_m)

 	print *,' eu_in eu_u eu_m',eu_in,eu_u,eu_m
 	print *,' el_in elong del_r1',el_in,elong,del_r1

	if(del_r1.lt.0.)del_r1=0.

        pshalo=del_r*dr_h
        print *,' PSHALO PSHALO0',pshalo,pshalo0

ccc!!!        if(pshalo.ge.pshalo0)del_r1=0.

	del_r=del_r+del_r1

	if(del_r.gt.d_halo)del_r=d_halo

 	print *,'fmax_avr fmax_in',fmax_avr*1.e-5,fmax_in*1.e-5
 	print *,'d_halo tpl_in',d_halo,tpl_in
 	print *,'ntay del_r1 del_r',ntay,del_r1,del_r
	if(del_r.lt.0.)del_r=0.
 	print *,' tt tay  q_95 c_h',tt,tay,q_95,c_h


c--------------------------
c        do i=2,n
c        if(dfmax(i).ge.dfmax_h)then
c           te0(i)=te_h0
c           tq0(i)=te0(i)
c        end if
c        end do
c----------------------------

	end if

	apr='-te0-'
	print 71,apr,(te0(i),i=1,n)


71	FORMAT(5X,A10/,(2x,6(1PE11.3)))
	return
	end

	subroutine maj_d3d()
	include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *	/efit6/tpl_p
	common
     *  /keys5/next
	common
     *	/ge1e/rs0,tpl
     *  /ge2/NTAY,TAY,TT
     *  /ge5/kpr
     *  /ge7/eu,rs,zout,elong
     *  /ge7e/eu_u
	common
     *  /dfm3/dfmax(npo),dfmax0(npo)
	common
     *  /halo1/c_h,d_halo,fmax_in,tpl_in
     *  /halo2/kmaj,k_q,k_d,kaxis,ndisrup
     *  /halo2e/next0,li_drop,n_li,n_dif,nmix
     *  /halo3/tay_00,tay_th,t_disr,d_tpl,tpl_end
     *  /halo4/expfg,avalb,w_h,del_r,al0
     *  /halo4e/w_h0,delaval0,pshalo0,te_h0
     *  /halo5/q_vde,q_95,del_f,i_halo
     *  /halo5e/pshalo
     *  /halo9e/dfmax_h
     *  /halo12/te_h
        common
     *	/fluxc6/pmag,pbound,psep,p_s,delaval,dr_h
	common
     *  /en1e/te_a,ti_a,te_b,ti_b,pw_e
     *  /en1d/te_a0
     *  /en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),WE0(npo),
     *  WQ0(npo)

	character *20 apr

c--------------------------------------------------------
	if(ntay.lt.ndisrup)return
c-------------------------------------------
	kaxis=0
	if(ntay.eq.ndisrup)then
	te_b=te_h
	delta=(te_a-te_b)/t_disr
	print *,' ntay delta -- disruption--',ntay,delta

	tay=tay_th
	print *,' **  tay=TAY_th ',tay
        print*,'ntay=',ntay
	call cam_t()
	call inv()
	end if
c---------------------
	print *,' k_feed== -- disruption--',k_feed

c!!!	if(k_feed.gt.0)call tem_feed()

c-------------


	te_a=te_a-delta*tay

	if(te_a.lt.te_a0)then
	te_a=te_a0
	delta=0.
	kaxis=1
	k_feed=1
	k_d=1
	tpl_in=tpl
	fmax_in=dfmax(n)
	eu_in=eu
	el_in=elong
	print *,' ==== k_d kaxis te_a te_b',k_d,kaxis,te_a,te_b
	end if

	apr='-te0-'
	print 71,apr,(te0(i),i=1,n)

	al1=te_b/te0(n)

	do i=1,n
           te0(i)=te0(i)*al1
           tq0(i)=te0(i)
	end do

	al1=(te_a-te_b)/(te0(1)-te_b)

	print *,' te_a te_b --',te_a,te_b

	do i=1,n
           te0(i)=(te0(i)-te_b)*al1+te_b
           tq0(i)=te0(i)
	end do

	print *,' al1  delta k_d--',
     *  al1,delta,k_d

	print *,' te_a te_b --',te_a,te_b

	apr='-te0-'
	print 71,apr,(te0(i),i=1,n)
	apr='-tq0-'
c!!!	print 71,apr,(tq0(i),i=1,n)
c--------------------------------------
	if(k_d.gt.0)then
	fmax_avr=dfmax(n)

c	del_r1=c_h*d_halo*(1.-(fmax_avr/
c     *  fmax_in)**(1.+tpl/tpl_in) )


c for test purposes...        del_r1=c_h*tay
c!!!        del_r1=c_h*tay

	eu_m=amax1(eu,eu_u)

	del_r1=c_h*tay*(sqrt(el_in)*eu_in-sqrt(elong)*eu_m)

 	print *,' eu_in eu_u eu_m',eu_in,eu_u,eu_m
 	print *,' el_in elong del_r1',el_in,elong,del_r1

	if(del_r1.lt.0.)del_r1=0.

        pshalo=del_r*dr_h
        print *,' PSHALO PSHALO0',pshalo,pshalo0

ccc!!!        if(pshalo.ge.pshalo0)del_r1=0.

	del_r=del_r+del_r1

	call delr_filter()

	if(del_r.gt.d_halo)del_r=d_halo

 	print *,'fmax_avr fmax_in',fmax_avr*1.e-5,fmax_in*1.e-5
 	print *,'d_halo tpl_in',d_halo,tpl_in
 	print *,'ntay del_r1 del_r',ntay,del_r1,del_r
	if(del_r.lt.0.)del_r=0.
 	print *,' tt tay  q_95 c_h',tt,tay,q_95,c_h


c--------------------------
c        do i=2,n
c        if(dfmax(i).ge.dfmax_h)then
c           te0(i)=te_h0
c           tq0(i)=te0(i)
c        end if
c        end do
c----------------------------
	end if



71	FORMAT(5X,A10/,(2x,6(1PE11.3)))
	return
	end
	subroutine maj_dis()
	include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *	/efit6/tpl_p
	common
     *  /keys5/next
	common
     *	/ge1e/rs0,tpl
     *  /ge2/NTAY,TAY,TT
     *  /ge5/kpr
	common
     *  /dfm3/dfmax(npo),dfmax0(npo)
	common
     *  /halo1/c_h,d_halo,fmax_in,tpl_in
     *  /halo2/kmaj,k_q,k_d,kaxis,ndisrup
     *  /halo2e/next0,li_drop,n_li,n_dif,nmix
     *  /halo3/tay_00,tay_th,t_disr,d_tpl,tpl_end
     *  /halo4/expfg,avalb,w_h,del_r,al0
     *  /halo4e/w_h0,delaval0,pshalo0,te_h0
     *  /halo5/q_vde,q_95,del_f,i_halo
     *  /halo5e/pshalo
     *  /halo9e/dfmax_h
     *  /halo12/te_h
        common
     *	/fluxc6/pmag,pbound,psep,p_s,delaval,dr_h
	common
     *  /en1e/te_a,ti_a,te_b,ti_b,pw_e
     *  /en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),WE0(npo),
     *  WQ0(npo)

	character *20 apr

	dimension al1(npo)

c--------------------------------------------------------
	if(ntay.lt.ndisrup)return
c-------------------------------------------
	kaxis=0
	next=next0
	if(ntay.eq.ndisrup)then
	te_b=te_h
	delta=(te_a-te_b)/t_disr
	print *,' ntay delta -- disruption--',ntay,delta
	end if
c---------------------
	if(ntay.gt.0)then
	te_a=te_a-delta
c	if(te_a.lt.1.1*te_b)then
c	te_a=1.1*te_b
	if(te_a.lt.12.*te_b)then
	te_a=12.*te_b
	delta=0.
	kaxis=1
	k_d=1
	tpl_in=tpl
	fmax_in=dfmax(n)
	print *,' ==== k_d kaxis te_a te_b',k_d,kaxis,te_a,te_b
	end if

	al1_a=te_a/te0(1)
	al1_b=te_b/te0(n)

	do i=1,n
	al1(i)=al1_a+(i-1.)/(n-1.)*(al1_b-al1_a)
	end do


	apr='-tq0-'
c	print 71,apr,(tq0(i),i=1,n)

	print *,' al1_a al1_b  delta k_d--',
     *  al1_a,al1_b,delta,k_d
	print *,' te_a te_b --',te_a,te_b

	do i=1,n
           te0(i)=te0(i)*al1(i)
           tq0(i)=te0(i)
	end do
      end if
	apr='-te0-'
	print 71,apr,(te0(i),i=1,n)
	apr='-tq0-'
	print 71,apr,(tq0(i),i=1,n)
c--------------------------------------
	if(k_d.gt.0)then
	fmax_avr=dfmax(n)

	del_r1=c_h*d_halo*(1.-(fmax_avr/
     *  fmax_in)**(1.+tpl/tpl_in) )

cccccc        del_r1=c_h

	if(del_r1.lt.0.)del_r1=0.

        pshalo=del_r*dr_h
        print *,' PSHALO PSHALO0',pshalo,pshalo0
        if(pshalo.ge.pshalo0)del_r1=0.

	del_r=del_r+del_r1

 	print *,'fmax_avr fmax_in',fmax_avr*1.e-5,fmax_in*1.e-5
 	print *,'d_halo tpl_in',d_halo,tpl_in
 	print *,'ntay del_r1 del_r',ntay,del_r1,del_r
	if(del_r.lt.0.)del_r=0.
 	print *,' tt tay  q_95 c_h',tt,tay,q_95,c_h


c--------------------------
        do i=2,n
        if(dfmax(i).ge.dfmax_h)then
           te0(i)=te_h0
           tq0(i)=te0(i)
        end if
        end do
c----------------------------

	end if

	apr='-te0-'
	print 71,apr,(te0(i),i=1,n)

	if(n_li.eq.1)then
           tpl_p=tpl_p+d_tpl*tay
           next=9999
           if(tpl_p.le.tpl_end)then
              tpl=tpl_p
              print *,' tpl_p d_tpl tay==',tpl_p,d_tpl,tay
           end if
	end if


	if(kaxis.eq.1)then
           n_li=1
           tpl_p=tpl
           next=9999
	end if

	if(tpl_p.gt.tpl_end.and.n_li.eq.1)then
        n_li=0
        next=next0
	tay=tay_th
	print *,' **  tay=TAY_th ',tay
        print*,'ntay=',ntay
	call cam_t()

	end if

        n_dif=0
        if(n_li.eq.1)n_dif=1

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))
	return
	end

	subroutine tem_br()
	include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
     *  /ge2/NTAY,TAY,TT
     *  /ge5/kpr
        common
     *  /dfm12/betpj,dlint,bett,bet2,betpc,tk,tkp,tkf
     *  /dfm12e/beta
        common
     *  /keys4/k_ener,k_uv
     *  /keys14/i_beta,i_gap5
	common
     *  /halo3/tay_00,tay_th,t_disr,d_tpl,tpl_end
	common
     *  /en1e/te_a,ti_a,te_b,ti_b,pw_e
     *  /en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),WE0(npo),
     *  WQ0(npo)

	character *20 apr
c--------------------------------------------------------


           tay=tay_00
           call cam_t()
           call inv()
           print *,' TAY=========',tay

        return

        if(ntay.le.2)then
           beta=betpj
        end if

c        if(ntay.eq.15)then
        if(ntay.eq.50)then
           beta=0.8*betpj
        end if

	if(ntay.gt.0)then
	print *,' betpj beta--',betpj,beta
	te_a=te_a*beta/betpj
	end if

	al1=(te_a-te_b)/(te0(1)-te_b)
	apr='-te0-'
	print 71,apr,(te0(i),i=1,n)
	apr='-tq0-'
	print 71,apr,(tq0(i),i=1,n)

	print *,' te_a te_b --',te_a,te_b

	do i=1,n
           te0(i)=(te0(i)-te_b)*al1+te_b
           tq0(i)=te0(i)
	end do

	apr='-te0-'
	print 71,apr,(te0(i),i=1,n)
	apr='-tq0-'
	print 71,apr,(tq0(i),i=1,n)

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))
	return
	end
	subroutine tem_con()
	include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
     *  /ge2/NTAY,TAY,TT
     *  /ge5/kpr
        common
     *  /dfm12/betpj,dlint,bett,bet2,betpc,tk,tkp,tkf
     *  /dfm12e/beta
        common
     *  /keys4/k_ener,k_uv
     *  /keys14/i_beta,i_gap5
	common
     *  /halo3/tay_00,tay_th,t_disr,d_tpl,tpl_end
	common
     *  /en1e/te_a,ti_a,te_b,ti_b,pw_e
     *  /en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),WE0(npo),
     *  WQ0(npo)

	character *20 apr
c--------------------------------------------------------

c        if(ntay.eq.6)then
c           tay=tay_00
c           call cam_t()
c        end if

        if(k_ener.eq.1)return

        if(i_beta.eq.0)return

        if(ntay.le.2)then
           beta=betpj
        end if

c        if(ntay.eq.15)then
        if(ntay.eq.50)then
           beta=0.8*betpj
        end if

	if(ntay.gt.0)then
	print *,' betpj beta--',betpj,beta
	te_a=te_a*beta/betpj
	end if

	al1=(te_a-te_b)/(te0(1)-te_b)
	apr='-te0-'
	print 71,apr,(te0(i),i=1,n)
	apr='-tq0-'
	print 71,apr,(tq0(i),i=1,n)

	print *,' te_a te_b --',te_a,te_b

	do i=1,n
           te0(i)=(te0(i)-te_b)*al1+te_b
           tq0(i)=te0(i)
	end do

	apr='-te0-'
	print 71,apr,(te0(i),i=1,n)
	apr='-tq0-'
	print 71,apr,(tq0(i),i=1,n)

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))
	return
	end


	subroutine tem_v()
	include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
     *  /ge2/NTAY,TAY,TT
     *  /ge5/kpr
        common
     *  /dfm12/betpj,dlint,bett,bet2,betpc,tk,tkp,tkf
     *  /dfm12e/beta
        common
     *  /keys4/k_ener,k_uv
	common
     *  /halo3/tay_00,tay_th,t_disr,d_tpl,tpl_end
	common
     *  /en1e/te_a,ti_a,te_b,ti_b,pw_e
     *  /en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),WE0(npo),
     *  WQ0(npo)

	character *20 apr
c--------------------------------------------------------

        if(ntay.eq.6)then
           tay=tay_00
           call cam_t()
        end if

        return

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))
	return
	end
	subroutine tem_ramp()
	include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
     *  /ge2/NTAY,TAY,TT
     *  /ge5/kpr
        common
     *  /dfm12/betpj,dlint,bett,bet2,betpc,tk,tkp,tkf
     *  /dfm12e/beta
        common
     *  /keys4/k_ener,k_uv
	common
     *  /halo3/tay_00,tay_th,t_disr,d_tpl,tpl_end
	common
     *  /en1e/te_a,ti_a,te_b,ti_b,pw_e
     *  /en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),WE0(npo),
     *  WQ0(npo)

	character *20 apr
c--------------------------------------------------------

        if(ntay.eq.6)then
           tay=tay_00
           call cam_t()
        end if

        if(k_ener.eq.1)return

	if(ntay.gt.0)then
	print *,' betpj beta--',betpj,beta
	te_a=te_a*beta/betpj
	end if

	al1=(te_a-te_b)/(te0(1)-te_b)
	apr='-te0-'
	print 71,apr,(te0(i),i=1,n)
	apr='-tq0-'
	print 71,apr,(tq0(i),i=1,n)

	print *,' te_a te_b --',te_a,te_b

	do i=1,n
           te0(i)=(te0(i)-te_b)*al1+te_b
           tq0(i)=te0(i)
	end do

	apr='-te0-'
	print 71,apr,(te0(i),i=1,n)
	apr='-tq0-'
	print 71,apr,(tq0(i),i=1,n)

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))
	return
	end

	subroutine vde()
	include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *	/efit6/tpl_p
	common
     *  /keys5/next
	common
     *	/ge1e/rs0,tpl
     *  /ge2/NTAY,TAY,TT
     *  /ge5/kpr
	common
     *  /dfm3/dfmax(npo),dfmax0(npo)
	common
     *  /halo1/c_h,d_halo,fmax_in,tpl_in
     *  /halo2/kmaj,k_q,k_d,kaxis,ndisrup
     *  /halo2e/next0,li_drop,n_li,n_dif,nmix
     *  /halo3/tay_00,tay_th,t_disr,d_tpl,tpl_end
     *  /halo4/expfg,avalb,w_h,del_r,al0
     *  /halo5/q_vde,q_95,del_f,i_halo
     *  /halo12/te_h
	common
     *  /en1e/te_a,ti_a,te_b,ti_b,pw_e
     *  /en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),WE0(npo),
     *  WQ0(npo)

	character *20 apr
c--------------------------------------------------------

        if(ntay.eq.20)then
           tay=tay_00
           call cam_t()
        end if

	if(q_95.lt.q_vde.and.ntay.gt.5.and.k_q.eq.0)then
	k_q=k_q+1
	ndisrup=ntay
	end if
c-------------------------------------------

	kaxis=0
	if(ntay.eq.ndisrup)then
	tay=tay_th
	print *,' **  tay=TAY_th ',tay
        print*,'ntay=',ntay
	call cam_t()
	te_b=te_h
	delta=(te_a-te_b)/t_disr
	print *,' ntay delta -- VDE--',ntay,delta
	end if
c---------------------
	if(ntay.gt.0)then
	te_a=te_a-delta
	if(te_a.lt.1.01*te_b)then
	te_a=1.01*te_b
	delta=0.
	kaxis=1
	k_d=1
	tpl_in=tpl
	fmax_in=dfmax(n)
	print *,' ==== k_d kaxis te_a te_b',k_d,kaxis,te_a,te_b
	end if

	al1=(te_a-te_b)/(te0(1)-te_b)
	apr='-te0-'
	print 71,apr,(te0(i),i=1,n)
	apr='-tq0-'
	print 71,apr,(tq0(i),i=1,n)

	print *,' al1 delta k_d--',al1,delta,k_d
	print *,' te_a te_b --',te_a,te_b

	do i=1,n
           te0(i)=(te0(i)-te_b)*al1+te_b
           tq0(i)=te0(i)
	end do
      end if
	apr='-te0-'
	print 71,apr,(te0(i),i=1,n)
	apr='-tq0-'
	print 71,apr,(tq0(i),i=1,n)
c--------------------------------------
	if(k_d.gt.0)then
	fmax_avr=dfmax(n)
	del_r1=c_h*d_halo*(1.-(fmax_avr/
     *  fmax_in)**(1.+tpl/tpl_in) )
	if(del_r1.lt.0.)del_r1=0.
	del_r=del_r+del_r1
 	print *,'fmax_avr fmax_in',fmax_avr*1.e-5,fmax_in*1.e-5
 	print *,'d_halo tpl_in',d_halo,tpl_in
 	print *,'ntay del_r1 del_r',ntay,del_r1,del_r
	if(del_r.lt.0.)del_r=0.
 	print *,' tt tay  q_95 c_h',tt,tay,q_95,c_h
	end if

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))
	return
	end

	subroutine disr1()
	include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *  /keys5/next
	common
     *	/ge1e/rs0,tpl
     *  /ge2/NTAY,TAY,TT
     *  /ge5/kpr
	common
     *  /dfm3/dfmax(npo),dfmax0(npo)
	common
     *  /halo1/c_h,d_halo,fmax_in,tpl_in
     *  /halo2/kmaj,k_q,k_d,kaxis,ndisrup
     *  /halo2e/next0,li_drop,n_li,n_dif,nmix
     *  /halo3/tay_00,tay_th,t_disr,d_tpl,tpl_end
     *  /halo4/expfg,avalb,w_h,del_r,al0
     *  /halo5/q_vde,q_95,del_f,i_halo
	common
     *  /en1e/te_a,ti_a,te_b,ti_b,pw_e
     *  /en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),WE0(npo),
     *  WQ0(npo)

	character *20 apr

        if(ntay.eq.12)then
           tay=tay_00
           call cam_t()
        end if

	if(q_95.lt.q_vde.and.ntay.gt.5)k_q=k_q+1
	if(k_q.eq.1)ndisrup=ntay
c
	kaxis=0
	next=next0
	if(ntay.eq.ndisrup)then
	delta=(te_a-te_b)/t_disr
	print *,' ntay delta -- disruption--',ntay,delta
	end if
c---------------------
	if(ntay.gt.0)then
	te_a=te_a-delta
	if(te_a.lt.1.01*te_b)then
	te_a=1.01*te_b
	delta=0.
	kaxis=1
	k_d=1
	tpl_in=tpl
	fmax_in=dfmax(n)
	print *,' ==== kaxis te_a te_b',kaxis,te_a,te_b
	end if
c
	if(kaxis.eq.1.and.kmaj.eq.1)then
           n_li=1
           tpl_p=tpl
	end if
	if(n_li.eq.1)then
           tpl_p=tpl_p+d_tpl*tay
           next=9999
           if(tpl_p.le.tpl_end)then
              tpl=tpl_p
              print *,' tpl_p d_tpl tay==',tpl_p,d_tpl,tay
           end if
	end if

	if(tpl_p.gt.tpl_end)then
           n_li=0
           next=next0
	end if

	al1=(te_a-te_b)/(te0(1)-te_b)
	apr='-te0-'
	print 71,apr,(te0(i),i=1,n)

	print *,' al1 delta --',al1,delta
	print *,' te_a te_b --',te_a,te_b

	do i=1,n
           te0(i)=(te0(i)-te_b)*al1+te_b
           tq0(i)=te0(i)
	end do
      end if
	apr='-te0-'
	print 71,apr,(te0(i),i=1,n)

	read (*,*)
c
	if(ntay.eq.ndisrup)then
	tay=tay_th
	print *,' **  TAY k_q',tay,k_q
        print*,'ntay=',ntay
	call cam_t()
	end if

	if(k_q.gt.0)k_q=k_q+1

	if(k_d.gt.0)then
	fmax_avr=dfmax(n)
	del_r1=c_h*d_halo*(1.-(fmax_avr/
     *  fmax_in)**(1.+tpl/tpl_in) )
	if(del_r1.lt.0.)del_r1=0.
	del_r=del_r+del_r1
 	print *,'ntay del_r1 del_r',ntay,del_r1,del_r
	if(del_r.lt.0.)del_r=0.
 	print *,' tt tay del_r q_95 c_h',tt,tay,del_r,q_95,c_h
	end if
	next=next0
c  test of n_li----
        if(ntay.eq.li_drop)then
           n_li=1
           tpl_p=tpl
        print *,' n_li===tpl_p ',n_li,tpl_p
        end if

        print *,' n_li===',n_li

        n_dif=0
        if(n_li.eq.1.or.n_li.eq.1)n_dif=1

        if(n_li.eq.1)then
           tpl_p=tpl_p+d_tpl*tay
           next=9999
           if(tpl_p.le.tpl_end)then
              tpl=tpl_p
              print *,' tpl_p d_tpl tay==',tpl_p,d_tpl,tay
           end if
	end if

	if(tpl_p.gt.tpl_end)then
           n_li=0
           next=next0
	end if
c--- end of test---
71	FORMAT(5X,A10/,(2x,6(1PE11.3)))
	return
	end




