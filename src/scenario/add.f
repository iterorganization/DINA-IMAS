	subroutine graphic(it1_x,nrad_x)
	return
	end
	subroutine n_diag(xx,zz)
	return
	end
	subroutine graphic_2(it1,n)
	return
	end
      
	subroutine  disp(y11,x11,mcurve,x_0)
	return
	end
     
		 
	subroutine  redraw
	return
	end

	subroutine c_time()
	return
	end

	subroutine initvm(x,x1,x2,x3)

	return
	end
	subroutine GR_DIR_FIL(it1_x,nrad_x)
	return
	end
      function rand(a)
      real *8 rand,a
      rand=0.5
      end

	subroutine print1(apr1,ygr)
		
	include 'double.inc'

	character apr1(*)
	character apr(30)

	dimension a_print(200)

	num=25
	do i=1,25
	apr(i)= apr1(i)
	if(apr1(i).eq.'=')then
	num=i
	goto 1
	end if
	end do

1	continue

c	print *,' num ygr',num,ygr

	a_print(1)=ygr

	n_pr=1
	
	call out42(n_pr,a_print,num,apr)

	return
      END


	subroutine print2(apr1,ygr1,ygr2)
		
	include 'double.inc'

	character apr1(*)
	character apr(30)
	dimension a_print(200)

	num=25
	do i=1,25
	apr(i)= apr1(i)
c	print *,apr1(i)
	if(apr1(i).eq.'=')then
	num=i
	goto 1
	end if
	end do

1	continue

c	print *,' num ygr1 ygr2',num,ygr1,ygr2

	a_print(1)=ygr1
	a_print(2)=ygr2

	n_pr=2

	call out42(n_pr,a_print,num,apr)

	return
      END

	subroutine print3(apr1,ygr1,ygr2,ygr3)
		
	include 'double.inc'

	character apr1(*)
	character apr(30)
	dimension a_print(200)

	num=25
	do i=1,25
	apr(i)= apr1(i)
	if(apr1(i).eq.'=')then
	num=i
	goto 1
	end if
	end do

1	continue

c	print *,' num ygr1 ygr2 ygr3',num,ygr1,ygr2,ygr3

	a_print(1)=ygr1
	a_print(2)=ygr2
	a_print(3)=ygr3

	n_pr=3

	call out42(n_pr,a_print,num,apr)

	return
      END


	subroutine print4(apr1,ygr1,ygr2,ygr3,ygr4)
		
	include 'double.inc'

	character apr1(*)
	character apr(30)
	dimension a_print(200)

	num=25
	do i=1,25
	apr(i)= apr1(i)
	if(apr1(i).eq.'=')then
	num=i
	goto 1
	end if
	end do

1	continue

c	print *,' num ygr1 ygr2 ygr3 ,ygr4',num,ygr1,ygr2,ygr3,ygr4

	a_print(1)=ygr1
	a_print(2)=ygr2
	a_print(3)=ygr3
	a_print(4)=ygr4

	n_pr=4

	call out42(n_pr,a_print,num,apr)

	return
      END

	subroutine printa(apr1,ygr,n)
		
	include 'double.inc'

	character apr1(*)
	character apr(30)
	dimension a_print(200),ygr(*)

	num=25
	do i=1,25
	apr(i)= apr1(i)
	if(apr1(i).eq.'=')then
	num=i
	goto 1
	end if
	end do

1	continue

c	print *,' num n ',num,n

	do i=1,n
	a_print(i)=ygr(i)
	end do

	n_pr=n

	call out42(n_pr,a_print,num,apr)

	return
      END

	subroutine  cur_prof_data()                                            
      	include 'double.inc'

	include 'new_com.inc'                                                  

      
	return
      END



      subroutine tcam_corr()
      
	return
      END
      
      subroutine PSL_CORR()
      
	return
      END


      subroutine write_data_in_time_kav()

      include 'double.inc'
      include 'new_com.inc'
      include 'br_com.inc'

        include 'par_imp.inc'
        include 'new_imp.inc'

      call write_data_in_time_kav_c(
     *	tt,tpl,betj,eu,uli,rmag,zmag,T_e,
     * T_i,tay_ee,sel,v_p,P_oh,ratio_imp,
     * z_eff,n_e,n0,n_d,q_ech,
     * q,uact,v_n,n)

	return
	end

      subroutine write_data_in_time_kav_c(
     *	tt,tpl,betj,eu,uli,rmag,zmag,T_e,
     * T_i,tay_ee,sel,v_p,P_oh,ratio_imp,
     * z_eff,n_e,n0,n_d,q_ech,
     * q,uact,v_n,n)

	include 'double.inc'
      include 'double_break1.inc'

	common /c_imp_out1/den_imp_neut(10)
	common /c_imp_out4/p_ohm0,p_loss0,qen2_0

      include 'parf0'

	dimension dens_imp(npo),q(*),sel(*)

	call imp_outp(dens_imp)

	i_en=i_en+1
      if(i_en.eq.1)then

	   open (unit=65,file='plasma_start.dat',
     *	form='formatted')
	else

	   open (unit=65,file='plasma_start.dat',
     *	access='append',form='formatted')
	end if

c*************************************************


 	x_x=v_n/v_p

      if(i_en.eq.1)then

	   write(65,*)
     *'t,tpl/1000.,betj,eu,uli,rmag,zmag,T_e,T_i, 
     * tay_ee,P_loss,P_oh,ratio_imp,n_z0,
     * Zeff,ne(20),n0(20),nd(20),n i1(20),n i2(20),
     * n i3(20) ,n i4(20),n i5(20) ,n i6(20) 
     * q(n),q(2),uact,x_x'

	end if

	p_ohm0=P_oh*v_p
	p_loss0=(sel(1)*0.1)*v_p
	qen2_0=p_ohm0+q_ech-p_loss0

!	call print4(' qen2_0 q_ech p_ohm0 p_loss0==',
!     *  qen2_0,q_ech,p_ohm0,p_loss0)


        write(65,5002)
     * tt*1.e-3,tpl*1.e-3,betj,eu*0.01,uli,rmag*0.01,zmag*0.01,
     * T_e*1.e3,
     * T_i*1.e3,tay_ee,(sel(1)*0.1)*v_p,P_oh*v_p,ratio_imp,
     * den_imp_neut(1)*0.1,z_eff,n_e,n0,n_d,dens_imp(1)*0.1,
     * dens_imp(2)*0.1,dens_imp(3)*0.1,dens_imp(4)*0.1,
     * dens_imp(5)*0.1,dens_imp(6)*0.1,q(n),q(2),uact,x_x
                                            
 5002   format (50(1pe15.6e3))
 
	close (65)


	return
	end
c****************************************

                                                                        
	subroutine pet_tab_old()       
	include 'double.inc'
	include 'new_com.inc'                                                   
                                                                        
         call pet_tab_old_c(                                                
     *   nutab,rs0,                                                     
     *   pstab,pptab,fptab,                                             
     *   n,ppx,pffx,a,kpr,pi)                                              
                                                                        
         return                                                         
         end                                                            
                                                                        
         subroutine pet_tab_old_c(                                          
     *   nutab,rs0,                                                     
     *   pstab,pptab,fptab,                                             
     *   n,ppx,pffx,a,kpr,pi)                                              
        include 'double.inc'                                                                        
                                                                        
         dimension pstab(*),pptab(*),fptab(*),                          
     *   ppx(*),pffx(*),a(*)                                            
                                                                        
      	character *20 apr                                                      
                                                                        
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))                                      
                                                                  
         open (unit=41,file='tabppf.dat',form='formatted')              
         read (41,*)nutab                                               
                                                                        
         do i=1,nutab                                                   
            read (41,*)pstab(i),pptab(i),fptab(i)                       
         enddo                                                          
                           
						                                              
         close (41) 

	amu0=4.*pi*1.d-7


	kpr_help=kpr
c	kpr=1
      if(kpr.eq.1)print *,' rs0 amu0 n nutab==',rs0,amu0,n,nutab               
	apr='-pstab-'                                                              
	if(kpr.eq.1)print 71,apr,(pstab(i),i=1,nutab)
	apr='-pptab-'                                                              
	if(kpr.eq.1)print 71,apr,(pptab(i),i=1,nutab)
	apr='-fptab-'                                                              
	if(kpr.eq.1)print 71,apr,(fptab(i),i=1,nutab)
                                                                        
	do i=2,n-1                                                             
	   psn=a(i)*a(i)                                                       
	   call feeti(nutab,pptab,ppx(i),pstab,psn)                            
	   call feeti(nutab,fptab,pffx(i),pstab,psn)                           

c	   call linear(nutab,pptab,ppx(i),pstab,psn)
c	   call linear(nutab,fptab,pffx(i),pstab,psn)
	end do                                                                 
                                                                        
	ppx(n)=pptab(nutab)                                                    
	ppx(1)=pptab(1)                                                        
                                                                        
	pffx(n)=fptab(nutab)                                                   
	pffx(1)=fptab(1)                                                       
                                                                        
                                                                        
	do i=1,n                                                               
	ppx(i)=-ppx(i)*(rs0*1.d-2)*amu0                                         
	pffx(i)=-2.*pffx(i)/(rs0*1.d-2)                                      
	end do                                                                 


	apr='-a-'                                                              
	if(kpr.eq.1)print 71,apr,(a(i),i=1,n)
	apr='-ppx-'                                                              
	if(kpr.eq.1)print 71,apr,(ppx(i),i=1,n)
	apr='-pffx-'                                                              
	if(kpr.eq.1)print 71,apr,(pffx(i),i=1,n)

	kpr=kpr_help


c	read (*,*)
                                                                        
	return                                                                 
	end                                                                    
                                                                        


	subroutine pet_tab_read()
	include 'double.inc'
c	implicit real *8 (a-h,o-z)
	include 'new_com.inc'

         call pet_tab_read_c(
     *   nutab,rs0,
     *   pstab,pptab,fptab,
     *   n,ppx,pffx,a,pi,kpr)

         return
         end

         subroutine pet_tab_read_c(
     *   nutab,rs0,
     *   pstab,pptab,fptab,
     *   n,ppx,pffx,a,pi,kpr)

	include 'double.inc'
c	 implicit real *8 (a-h,o-z)

         dimension pstab(*),pptab(*),fptab(*),
     *   ppx(*),pffx(*),a(*)

	character *20 apr

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))


c-------------------------------------------------------------

         open (unit=41,file='tabppf.txt',form='formatted')
         read (41,*)nutab

         do i=1,nutab
            read (41,*)pstab(i),pptab(i),fptab(i)
         enddo

         close (41)

	coef_ff=1.
	do i=1,nutab
! OLD 	   pptab(i)=-pptab(i)*(rs0*1.e-2)*4.e-7*pi

  	pstab(i)=dsqrt(pstab(i))
	   pptab(i)=-pptab(i)*(rs0*1.d-2)*0.1d0
	   fptab(i)=-2.d0*fptab(i)/(rs0*1.d-2)*0.1d0
	end do


	do i=2,n-1
c	   psn=a(i)**2
	psn=a(i)
	   call linear(nutab,pptab,ppx(i),pstab,psn)
	   call linear(nutab,fptab,pffx(i),pstab,psn)

c	   call feeti(nutab,pptab,ppx(i),pstab,psn)
c	   call feeti(nutab,fptab,pffx(i),pstab,psn)

	end do

	ppx(n)=pptab(nutab)
	ppx(1)=pptab(1)

	pffx(n)=fptab(nutab)
	pffx(1)=fptab(1)

	pffx(n)=0.
	ppx(n)=0.


        if(kpr.eq.1)print *,' rs0 n nutab==',rs0,n,nutab

	apr=' ppx'
	if(kpr.eq.1)print 71,apr,(ppx(i),i=1,n)

	apr=' pffx'
	if(kpr.eq.1)print 71,apr,(pffx(i),i=1,n)

	return
	end



	subroutine pet_tab_contin()
	include 'double.inc'
c	implicit real *8 (a-h,o-z)
	include'new_com.inc'

         call pet_tab_contin_c(
     *   nutab,rs0,
     *   pstab,pptab,fptab,
     *   n,ppx,pffx,a,pi,kpr)

         return
         end

         subroutine pet_tab_contin_c(
     *   nutab,rs0,
     *   pstab,pptab,fptab,
     *   n,ppx,pffx,a,pi,kpr)

	include 'double.inc'
c	 implicit real *8 (a-h,o-z)

         dimension pstab(*),pptab(*),fptab(*),
     *   ppx(*),pffx(*),a(*)

	character *20 apr

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))

         open (unit=41,file='tabppf.con',form='formatted')
         read (41,*)nutab

         do i=1,nutab
            read (41,*)pstab(i),pptab(i),fptab(i)
         enddo

         close (41)

	do i=1,n
c	   psn=a(i)**2
	psn=a(i)
	   call linear(nutab,pptab,ppx(i),pstab,psn)
	   call linear(nutab,fptab,pffx(i),pstab,psn)

c	   call feeti(nutab,pptab,ppx(i),pstab,psn)
c	   call feeti(nutab,fptab,pffx(i),pstab,psn)

	end do

	ppx(n)=pptab(nutab)
	ppx(1)=pptab(1)

	pffx(n)=fptab(nutab)
	pffx(1)=fptab(1)

        if(kpr.eq.1)print *,' rs0 n nutab==',rs0,n,nutab

	apr=' ppx'
	if(kpr.eq.1)print 71,apr,(ppx(i),i=1,n)

	apr=' pffx'
	if(kpr.eq.1)print 71,apr,(pffx(i),i=1,n)

	return
	end
                                                                        
	subroutine ppx_pffx_tab()      
	include 'double.inc'
	include 'new_com.inc'                                                   
                                                                        
         call ppx_pffx_tab_c(                                           
     *   nutab,                                                         
     *   pstab,pptab,fptab,                                             
     *   n,ppx,pffx,a,kpr)                                              
                                                                        
         return                                                         
         end                                                            
                                                                        
         subroutine ppx_pffx_tab_c(                                     
     *   nutab,                                                         
     *   pstab,pptab,fptab,                                             
     *   n,ppx,pffx,a,kpr)                                              
        include 'double.inc'              
                                                                        
         dimension pstab(*),pptab(*),fptab(*),                          
     *   ppx(*),pffx(*),a(*)                                            
                
                
       	character *30 apr 

      	dimension a_print(200)
                                                        
	 nutab=n                                                               
                
      a_print(1)=n
      n_pr=1      
      num=20
      apr='n=='
      
!	call out42(n_pr,a_print,num,apr)
             
                                                                        
!	 if(kpr.eq.1)print *,' n nutab==',n,nutab                             
                                                                        
	do i=1,n                                                               
	   pstab(i)=a(i)                                                       
	   pptab(i)=ppx(i)                                                     
	   fptab(i)=pffx(i)                                                    
	end do                                                                 
                                                                        
	return                                                                 
	end                                                                    
	subroutine lim_mesh() 
    	include 'double.inc'
	include 'new_com.inc'                                                  
                                                                        
	call lim_mesh_c(                                                       
     *  kex,xue,yue,                                                    
     *  nr,nz,x,y)                                                      
                                                                        
        return                                                          
        end                                                             
                                                                        
	subroutine lim_mesh_c(                                                 
     *  kex,xue,yue,                                                    
     *  nr,nz,x,y)                                                      
          include 'double.inc'                                                              
        dimension xue(*),yue(*),x(*),y(*)                               
                                                                        
c  new quasy limiter kex, xue, yue ...                                  
                                                                        
	xue(1)=x(nr-2)                                                         
	yue(1)=y(nz-2)                                                         
	xue(2)=x(3)                                                            
	yue(2)=y(nz-2)                                                         
	xue(3)=x(3)                                                            
	yue(3)=y(3)                                                            
	xue(4)=x(nr-2)                                                         
	yue(4)=y(3)                                                            
	xue(5)=xue(1)                                                          
	yue(5)=yue(1)                                                          
                                                                        
	kex=5                                                                  
                                                                        
        return                                                          
        end                                                             
	subroutine trian()
	include 'double.inc'
	include 'new_com.inc'                                                  
                                                                        
	call trian_c(                                                  
     *  n,mp,npo,pi,                                                    
     *  xpl,ypl,                                                        
     *  tri,tri_up,tri_dw,el_up,el_dw)                            
                                                                                         
	return                                                                 
	end                                                                    

	SUBROUTINE trian_c(                                                  
     *  n,mp,npo,pi,                                                    
     *  xpl,ypl,                                                        
     *  tri,tri_up,tri_dw,el_up,el_dw)                            
        include 'double.inc'                                                     
        parameter(nk=2,nn=2*nk+1)
                                                                        
        dimension xpl(npo,*),ypl(npo,*)
	  dimension a_print(100)
	  dimension x(nn),y(nn)
	  character*30 apr              
                                                                        
        rmag=xpl(1,1)                                                   
        zmag=ypl(1,1)                                                   

	  if(in.eq.-1) then
		open(unit=62,file='a.dat')
		do i=1,n
			do j=1,mp	
				write(62,*) xpl(i,j),ypl(i,j)
			enddo
		enddo
		close(62)
	  endif
	  in=in+1
                                                                        
        i=n                                                 

	  
	     zmax=-1.e5                                                   
           zmin=1.e5                                                    
                                                                        
           rmax=-1.e5                                                   
           rmin=1.e5                                                    
                                                                        
           xleft=1.e8                                                   
           xright=-1.e8                                                 
                                                                        
           do j=2,mp-1                                                  
                                                                        
             if(ypl(i,j).ge.zmax)then                                   
                zmax=ypl(i,j)                                           
                rmax=xpl(i,j) 
			  j_zmax=j                                          
             end if                                                    
                            						                                              
             if(ypl(i,j).le.zmin)then                                  
                zmin=ypl(i,j)                                          
                rmin=xpl(i,j)
			  j_zmin=j                                          
             end if                                                    
                                                                        
              xleft=dmin1(xleft,xpl(i,j))                               
              xright=dmax1(xright,xpl(i,j))                             
                                                                        
           end do        

c$	searching r_min by spline procedure
c**********************************************
c		 a_print(1)=j_zmin
c	     n_pr=1
c	     apr='j_zmin'
c	     num=20
c	     call out42(n_pr,a_print,num,apr)

		 
		 j2=1
		 do j=j_zmin-nk,j_zmin+nk
			x(j2)=xpl(i,j)
			y(j2)=ypl(i,j)
			j2=j2+1
		 enddo

		 call triang(x,y,nn,x_g1,y_g1)
		                                                
c		 a_print(1)=x_g1
c		 a_print(2)=y_g1
c	     n_pr=2
c	     apr='dw: x_g1 y_g1='
c	     num=20
c	     call out42(n_pr,a_print,num,apr)

		 rmin=x_g1
		 zmin=y_g1
                                               
c$	searching r_max by spline procedure
c**********************************************
c		 a_print(1)=j_zmax
c	     n_pr=1
c	     apr='j_zmax='
c	     num=20
c	     call out42(n_pr,a_print,num,apr)

		 
		 j2=1
		 do j=j_zmax-nk,j_zmax+nk
			x(j2)=-xpl(i,j)
			y(j2)=-ypl(i,j)
			j2=j2+1
		 enddo

		 call triang(x,y,nn,x_g2,y_g2)
		                                                
c		 a_print(1)=-x_g2
c		 a_print(2)=-y_g2
c	     n_pr=2
c	     apr='up: x_g2 y_g2='
c	     num=20
c	     call out42(n_pr,a_print,num,apr)

		 rmax=-x_g2
           zmax=-y_g2                                    
											                          
           eu=0.5*(xright-xleft)                                        
           bheight=0.5*(zmax-zmin)                                      
           zout=0.5*(zmax+zmin)                                         
           rout=0.5*(xleft+xright)                                      
           elong=bheight/eu                                             
                                                                        
           asp=rout/eu                                                  
           el_up=(zmax-zmag)/eu                                         
           el_dw=(zmag-zmin)/eu                                         
           tri_up=(rout-rmax)/eu                                        
           tri_dw=(rout-rmin)/eu 
	  

	  if((tri_up.gt.0.5.or.tri_dw.gt.0.5).and.inn.eq.-1)then
		open(unit=62,file='aa.dat')
		do i=1,n
			do j=1,mp	
				write(62,*) xpl(i,j),ypl(i,j)
			enddo
		enddo
		close(62)
	    inn=inn+1
	  endif
	  

		 
		 a_print(1)=rmax
		 a_print(2)=rmin
		 a_print(3)=tri_up
		 a_print(4)=tri_dw
	     n_pr=4
	     apr='xmax xmin tri_up_dw'
	     num=20
c	     call out42(n_pr,a_print,num,apr)
		                                        
                                                                        
           tri=0.5*(tri_up+tri_dw)                                      
                                                                        
	return                                                                 
	end                                                                    


      subroutine get_data_in_time(pne_xx,tene_xx,p_dop_xx,
     *  p_tot_xx,p_loss_xx)

      include 'double.inc'
      include 'new_com.inc'
      include 'br_com.inc'

        include 'par_imp.inc'
        include 'new_imp.inc'

	pne_xx=n_e*10.d0
	tene_xx=tay_ee
	p_dop_xx=q_ech
	p_tot_xx=P_oh*v_p+q_ech
	p_loss_xx=(sel(1)+sel(2))*0.1*v_p
	qlos_imp=(sel(1)+sel(2))*0.1
!	print *,' qlos_imp v_p=',qlos_imp,v_p
	return
	end


	subroutine dfmax_calc()
	include 'double.inc'
	include 'parf0'                                                        
	common                                                                 
     *	/n_m/n,m,mp                                                      
	common                                                                 
     *	/ge1/pi                                                          
     *  /ge2/NTAY,TAY,TT                                                
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)                     
	common                                                                 
     *	/efit4/coef                                                      
	common                                                                 
     *  /eq4/xpl(npo,ntet),ypl(npo,ntet)                                
	common                                                                 
     *	/ge1e/rs0,tpl                                                    
     *  /ge5/kpr                                                        
	common                                                                 
     *  /pol1/RO(npo,ntet),AJ(npo,ntet)                                 
     *  /pol2/Qx(npo),ANUx(npo),Px(npo),Fx(npo),                        
     *   PPxx(npo),PFFxx(npo)                                           
     *  /pol4/UM,VM,UK(ntet),VK(ntet)                                   
     *  /pol5/psend                                                     
     *  /pol5e/um1,vm1,um2,vm2                                          
     *  /pol6/ppx(npo),pffx(npo)                                        
	common                                                                 
     *  /DFM2/PSI(npo),PFI(npo),DM0(npo),DMN(npo)                       
     *  /dfm3/dfmax(npo),dfmax0(npo)                                    
     *  /dfm3e/dfmaxc(npo),dfmaxh(npo)                                  
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)            
     *  /dfm7/bt0,uind                                                  
     *  /dfm7e/bt0_0,f_na                                               
        COMMON                                                          
     *  /mid1/C1(npo),C2(npo),C3(npo)                                   
     *  /mid2/vi(npo),spo(npo)                                          
     *  /mid2e/vol(npo),spov(npo),pcur(npo)                             
     *  /mid3/GRA1(npo),GRA2(npo)                                       
	common                                                                 
     *  /en1/PNE(npo),PD0(npo),PT0(npo),PH0(npo),PDN(npo),              
     *  PTN(npo),PHN(npo)                                               
     *  /en1e/te_a,ti_a,te_b,ti_b,pw_e                                  
     *  /en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),WE0(npo),              
     *  WQ0(npo)                                                        
     *  /en33/anom_e,anom_i,key_t11,kcchp                               
	common                                                                 
     *  /halo4/expfg,avalb,w_h,del_r,al0                                
     *  /halo5/q_vde,q_95,del_f,i_halo                                  
     *  /halo9/fluxt,fluxt0                                             
     *  /halo9e/dfmax_h                                                 
     *  /halo10/fves,fves0,self_v                                       
     *  /halo11/fmaxv,fmaxv0                                            
                                                                        
	dimension qz(npo),poa(npo),aiz(npo)                                    
	dimension dfmax_help(npo)                                              
                                                                        
	dimension a_print(200)
	character*30 apr
	                                                                  
c---------------------                                                  
                                                                        
	do i=1,n                                                               
	do j=1,mp                                                              
	xpl(i,j)=um+ro(i,j)*(uk(j)-um)                                         
	ypl(i,j)=vm+ro(i,j)*(vk(j)-vm)                                         
	end do                                                                 
	end do                                                                 
                                                                        
	call midc(n,mp,rs0)

	do i=2,n                                                               
      fx(i)=f(i)                                                      
	pfi(i)=2.*pi*rs0*c3(I)*fx(i)                                           
	psi(i)=(dm0(i)-dm0(i-1))/ha(i)                                           
	end do                                                                 
                                                                        
c--- transref to toroidal coordinates---                                
c                                                                       
	dfmaxc(1)=0.                                                           
	do i=2,n                                                               
	dfmaxc(i)=dfmaxc(i-1)+pfi(i)*ha(i)                                     
	end do                                                                 
c                                                                       
	fmax=dfmaxc(n)                                                         
	dfmax(1)=0.                                                            
	do i=2,n                                                               
	dfmax(i)=dfmaxc(i)  
	q(i)=-pfi(i)/psi(i)
	end do

	tok=0.                                                                 
	co_n=1.                                                                
	do i=2,n                                                               
	if(i.eq.n)co_n=0.5                                                     
        TOK=tok-co_n*coef*( PP(I)*VI(I)/RS0 +                           
     *  0.5*PFF(I)*RS0*2.*PI*c3(i) )*ha(i)                              
	end do
	tpl_1=-coef*c2(n)*psi(n) 
	                                              
	if(kpr.eq.1)print *,'tpl tok tpl_1 ',tpl,tok,tpl_1                    

	a_print(1)=tpl
	a_print(2)=it_int
	a_print(3)=tpl_1
	n_pr=3
	apr=' **  tpl tok tpl_1   **'

	num=25

c	if(kpr.eq.3)call out42(n_pr,a_print,num,apr)

71	FORMAT(20X,A8/,(6(1X,1PE14.7)))                                      

	return                                                                 
	end                                                                    

  	subroutine pow_emo1()
  	include 'double.inc'
	include 'new_com.inc'

	call pow_emo1_c(
     *  n,psval,dm0,
     *  p_e1,z_e1,r_e1,dz_e1,dr_e1,
     *  ro_ech,del_ech,del_ech0,
     *  power_ech1,
     *  kpr)

	return
	end

  	subroutine pow_emo1_c(
     *  n,psval,dm0,
     *  p_e1,z_e1,r_e1,dz_e1,dr_e1,
     *  ro_ech,del_ech,del_ech0,
     *  power_ech1,
     *  kpr)
        include 'double.inc'
	dimension psval(*),dm0(*)

	include 'parf0'

	dimension pdd(6),po1(npo),po2(npo)

	character *20 apr


	if(p_e1.le.1.e-5)go to 1 

	apr='-psval-' 
c	print 71,apr,(psval(i),i=1,n) 

	apr='-dm0-' 
c	print 71,apr,(dm0(i),i=1,n) 

	do i=1,n
	po1(i)=(psval(i)-psval(1))/(psval(n)-psval(1))
	po2(i)=(dm0(i)-dm0(1))/(dm0(n)-dm0(1))
	
	end do

c---
	apr='-po1-' 
c	print 71,apr,(po1(i),i=1,n) 
	apr='-po2-' 
c	print 71,apr,(po2(i),i=1,n) 
c-----

	urr=r_e1
	vrr=z_e1
	call boxd(urr,vrr,pdd,ier)
	pdd_1=pdd(1)
	po_pdd1=(pdd_1-psval(1))/(psval(n)-psval(1))

	urr=r_e1-0.5*dr_e1
	vrr=z_e1-0.5*dz_e1
	call boxd(urr,vrr,pdd,ier)
	pdd_2=pdd(1)
	po_pdd2=(pdd_2-psval(1))/(psval(n)-psval(1))

	urr=r_e1-0.5*dr_e1
	vrr=z_e1+0.5*dz_e1
	call boxd(urr,vrr,pdd,ier)
	pdd_3=pdd(1)
	po_pdd3=(pdd_3-psval(1))/(psval(n)-psval(1))

	urr=r_e1+0.5*dr_e1
	vrr=z_e1+0.5*dz_e1
	call boxd(urr,vrr,pdd,ier)
	pdd_4=pdd(1)
	po_pdd4=(pdd_4-psval(1))/(psval(n)-psval(1))

	urr=r_e1+0.5*dr_e1
	vrr=z_e1-0.5*dz_e1
	call boxd(urr,vrr,pdd,ier)
	pdd_5=pdd(1)
	po_pdd5=(pdd_5-psval(1))/(psval(n)-psval(1))

c	print *,' pdd 1-5',pdd_1,pdd_2,pdd_3,pdd_4,pdd_5
c	print *,' po_pdd 1-5',po_pdd1,po_pdd2,po_pdd3,
c     *  po_pdd4,po_pdd5


c	   call linear(nrad,ppx,pprime,poa,psix)

	call linear(n,po2,psix,po1,po_pdd1)
	po_pdd1=psix
	po_max=psix
	po_min=psix

	call linear(n,po2,psix,po1,po_pdd2)
	po_pdd2=psix
	po_max=dmax1(po_max,psix)
	po_min=dmin1(po_min,psix)
	call linear(n,po2,psix,po1,po_pdd3)
	po_pdd3=psix
	po_max=dmax1(po_max,psix)
	po_min=dmin1(po_min,psix)
	call linear(n,po2,psix,po1,po_pdd4)
	po_pdd4=psix
	po_max=dmax1(po_max,psix)
	po_min=dmin1(po_min,psix)
	call linear(n,po2,psix,po1,po_pdd5)
	po_pdd5=psix
	po_max=dmax1(po_max,psix)
	po_min=dmin1(po_min,psix)

c	print *,' po_pdd 1-5',po_pdd1,po_pdd2,po_pdd3,
c     *  po_pdd4,po_pdd5	

	if(kpr.eq.1)print *,' p_e1 po_max po_min',p_e1,po_max,po_min

	ro_ech=0.5*(po_min+po_max)

	del_ech=ro_ech-po_min

c	del_ech=0.25

	if(dabs(del_ech).le.del_ech0)del_ech=del_ech0

	power_ech1=p_e1

	call p_ech1()

 1	continue


71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

	return
	end
        subroutine p_ech1()
        include 'double.inc'
	include 'new_com.inc'

        call p_ech1_c(n,
     *  sb_ech1,ai,power_ech1,
     *  vi,ha,pi,
     *  ro_ech,del_ech,
     *  kpr)

	return
	end

        subroutine p_ech1_c(n,
     *  sb_ech1,ai,power_ech1,
     *  vi,ha,pi,
     *  ro_ech,del_ech,
     *  kpr)
        include 'double.inc'
	dimension sb_ech1(*),ai(*),vi(*),ha(*)

	character *20 apr


        if(kpr.eq.1)print *,'ro_ech del_ech power_ech1 ',
     *  ro_ech,del_ech,power_ech1

	yp_v=0.
 
	do i=2,n

	sb_ech1(i)=exp( -( (ai(i)-ro_ech)/del_ech )**2 )

	yp_v=yp_v+sb_ech1(i)*2.*pi*vi(i)*ha(i)

	end do

c-- transition to our units
	yq=power_ech1
c--------------

	p_ech=0.
	do i=2,n
	sb_ech1(i)=sb_ech1(i)/yp_v*yq
	p_ech=p_ech+sb_ech1(i)*2.*pi*vi(i)*ha(i)
	end do

	PNOR=6.25E8

	do i=2,n
	sb_ech1(i)=sb_ech1(i)*pnor
	end do

	apr='sb_ech1='
c	print 71,apr,(sb_ech1(i),i=1,n)

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))

        if(kpr.eq.1)print *,'ro_ech del_ech power_ech1 ',
     *  ro_ech,del_ech,p_ech


	return
	end
        subroutine pow_emo()
        include 'double.inc'
	include 'new_com.inc'

        call pow_emo_c(n,
     *  sb_ech1,sb_ech2,power_ech1,
     *  power_ech2,pi,spo,vi,ha,
     *  p_e1,z_e1,r_e1,dz_e1,dr_e1,
     *  p_e2,z_e2,r_e2,dz_e2,dr_e2,
     *  num_ech,
     *  aj0_ech1,aj0_ech2,
     *  tpl_ech1,tpl_ech2,
     *  kpr,c_e2,eff_cd)

	return
	end

        subroutine pow_emo_c(n,
     *  sb_ech1,sb_ech2,power_ech1,
     *  power_ech2,pi,spo,vi,ha,
     *  p_e1,z_e1,r_e1,dz_e1,dr_e1,
     *  p_e2,z_e2,r_e2,dz_e2,dr_e2,
     *  num_ech,
     *  aj0_ech1,aj0_ech2,
     *  tpl_ech1,tpl_ech2,
     *  kpr,c_e2,eff_cd)
        include 'double.inc'
	dimension sb_ech1(*),sb_ech2(*),spo(*),vi(*),ha(*),
     *  aj0_ech1(*),aj0_ech2(*),c_e2(*)

	dimension p_e2(*),z_e2(*),r_e2(*),dz_e2(*),dr_e2(*)
	
	character *20 apr

	PNOR=6.25d8

	do i=2,n
	aj0_ech2(i)=0.
	sb_ech2(i)=0.
	end do

c!	num_ech=2

	num_ech=9

	do kk=1,num_ech

	tpl_ech1=eff_cd*c_e2(kk)*1.d-3

c	tpl_ech1=5.*c_e2(kk)*1.e-3

c	tpl_ech1=c_e2(kk)*1.e-3



	p_e1=p_e2(kk)
	z_e1=z_e2(kk)
	r_e1=r_e2(kk)
	dz_e1=dz_e2(kk)
	dr_e1=dr_e2(kk)

	do i=2,n
	aj0_ech1(i)=0.
	sb_ech1(i)=0.
	end do

	call pow_emo1()
 
	call ip_ech_1()

	apr='sb_ech1='
c	print 71,apr,(sb_ech1(i),i=1,n)

	do i=2,n
	aj0_ech2(i)=aj0_ech2(i)+aj0_ech1(i)
	sb_ech2(i)=sb_ech2(i)+sb_ech1(i)
	end do

	end do

	do i=2,n
	aj0_ech1(i)=0.
	sb_ech1(i)=0.
	end do
	tpl_ech1=0.
	power_ech1=0.

	p_ech=0.
	tok_ech=0.
	do i=2,n
	tok_ech=tok_ech+aj0_ech2(i)*spo(i)*ha(i)
	p_ech=p_ech+sb_ech2(i)*2.*pi*vi(i)*ha(i)/pnor
	end do

	power_ech2=p_ech
	tpl_ech2=tok_ech

	apr='aj0_ech2='
!	if(kpr.eq.1)print 71,apr,(aj0_ech2(i),i=1,n)
	apr='sb_ech2='
!	if(kpr.eq.1)print 71,apr,(sb_ech2(i),i=1,n)

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))

        if(kpr.eq.1)print *,' p_ech tok_ech ',p_ech,tok_ech


	return
	end

  	subroutine volt_prog() 
	include 'double.inc'
	include 'new_com.inc'

	call volt_prog_c(
     *  npf,vchopper,tt,kpr)

	return
	end

c

	subroutine volt_prog_c(
     *  npf,v_ful,tt,kpr)
	include 'double.inc'

	dimension v_ful(*)

        include 'parf1'
        include 'parf_mike'
c        include 'parf_mike'

	dimension t_exp(ntime),v_t(kf,ntime)


	character *12 apr

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))


c-----------------------------

        if(kpr.eq.1)print *,' tt npf==',tt,npf

	i_en=i_en+1
	if(i_en.eq.1)then
	   open (unit=40,file='volts.txt',form='formatted')


	   read (40,*)
	   read (40,*)n_t
	   read (40,*)

	   do j=1,n_t
         
	   read (40,*)t_exp(j)

	   t_exp(j)=t_exp(j)*1.d3

         read (40,*)(v_t(k,j),k=1,npf)

         end do

 1	   continue

	   if(kpr.eq.1)print *,' n_t= ntime =',n_t,ntime

	   close (40)

c--------------------------

	apr='-t_exp-' 
	if(kpr.eq.1)print 71,apr,(t_exp(i),i=1,n_t) 

	end if

c---------------------------

	do i=2,n_t

	   if( (tt-t_exp(i-1))*(tt-t_exp(i)).le.0.)then
c==================
	      t_coef=(tt-t_exp(i-1))/( t_exp(i)-t_exp(i-1) )

	  if(kpr.eq.1) print *,' i tt  t_coef ',i,tt,t_coef
	 
	      do k=1,npf
		  v_ful(k)=v_t(k,i-1)+t_coef*(v_t(k,i)-v_t(k,i-1))
	      end do
	   end if

	end do

c---------------------------

	apr='-v_ful-' 
	if(kpr.eq.1)print 71,apr,(v_ful(i),i=1,npf) 


	return
	end

	subroutine tpl_read()
	include 'double.inc'
	include 'new_com.inc'

	call tpl_read_c(
     *  tt,tpl,kpr)
	
	return
	end

	subroutine tpl_read_c(
     *  tt,tpl,kpr)

	include 'double.inc'
 	include 'parf_mike' 

	dimension t_t(ntime),tpl_t(ntime)


	character *12 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='tpl.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 
           read (41,*) 

 	if(kpr.eq.1) print *,'  tt n_t===',tt,n_t 

           do i=1,n_t 
              read (41,*)t_t(i),tpl_t(i)
              t_t(i)=t_t(i)*1000. 
           end do 
           
           apr='-t_t-' 
      if(kpr.eq.1)     print 71,apr,(t_t(i),i=1,n_t) 

           apr='-tpl_t-' 
      if(kpr.eq.1)     print 71,apr,(tpl_t(i),i=1,n_t) 

           close (unit=41) 
        end if

71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

      do i=2,n_t
      if( (tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
	t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )

	tpl=tpl_t(i-1)+t_coef*(tpl_t(i)-tpl_t(i-1))
c
       end if

       end do

       if(kpr.eq.1)print *,' from tpl_read tpl ',tpl

       return 
       end 
c********************************************************


        subroutine ip_ech()
        	include 'double.inc'
	include 'new_com.inc'

        call ip_ech_c(n,
     *  aj0_ech,sb_ech,ai,power_ech,tt,pne,tpl_ech,
     *  te0,spo,vi,ha,rs0,pi,a_m,yr0,gam_eccd)

	return
	end

        subroutine ip_ech_c(n,
     *  aj0_ech,sb_ech,ai,power_ech,tt,pne,tpl_ech,
     *  te0,spo,vi,ha,rs0,pi,a_m,yr0,gam_eccd)
    	include 'double.inc'
	dimension aj0_ech(*),sb_ech(*),ai(*),pne(*),te0(*),
     *  spo(*),vi(*),ha(*),a_m(*)

	character *20 apr

c  Modified for DINA by Khayrutdinov--------------

C-----------------------------------------Polevoy 27-JUL-99

C	ECR Heating for ITER by Zvonkov (Programmed by Polevoy)

C	YR0 	distance from plasma centre [m]

C	YDR	half width [m]	~0.085 for edge 140GHz IAM 

C		(0.25 for central 170GHz IAM)

C	YQ	ECH Power [MW]

C	YP(r)	ECR power density [MW/m3] ~ Q*exp(-((r-r0)/Dr)**2)

C	YC(r)	ECR current density [MA/m2]

C	YEFF	ECR current drive efficiency [A/W]

c YQ[MW], YP[MW/m3], YC[MA/m2] 
c TE[keV], ne[19], AMETR[m]



c*** Input of yr0 is in vic_yr0_read subroutine in time 
c	i_en=i_en+1
c	if(i_en.eq.1)then

c	 open (unit=41,file='ech.dat',form='formatted')
c	 read (41,*)
c	 read (41,*)yr0,tt_uv


c         print *,'yr0 tt_uv',yr0,tt_uv

c	end if

c	if(tt.le.tt_uv)return


	yq=power_ech

	JRES=1

	NA1=n-1

 	DO  J=2,NA1

	J1=J-1

	IF((a_m(J)-YR0)*(a_m(J1)-YR0).LE.0.) JRES=J

	end do

	IF(JRES.GE.NA1) JRES=N

	te_res=TE0(JRES)*1.e-3
	pne_res=pne(JRES)

c        print *,' == te_res pne_res yq na1 ===',te_res,pne_res,yq,na1

c### 	YEFF	=.042*TE_RES/50.*10./PNE_RES*YQ

c OLD 	YEFF	=.042*TE_RES/50.*10./PNE_RES

 	YEFF	=gam_eccd*TE_RES/50.*10./PNE_RES

	YDR	=

     *  (4.95+37.6*EXP(-TE_RES/10.2)+10.76/PNE_RES)/100.

c--- in cm---
	ydr=ydr*100.

c        print *,' == jres yr0 yeff ydr ===',jres,yr0,yeff,ydr

	yp_v=0.
	yp_s=0.

	apr='a_m='
c	print 71,apr,(a_m(i),i=1,n)

	DO  J	=1,NA1

c!!!!	YP(J)=exp(-((a_m(J)-YR0)/YDR)**2)

	sb_ech(J)=exp(-((a_m(J)-YR0)/YDR)**2)

	yp_v=yp_v+sb_ech(j)*2.*pi*vi(j)*ha(j)

	yp_s=yp_s+sb_ech(j)*spo(j)*ha(j)

c	print *,' j sb_ech yp_v yp_s',j,sb_ech(j),yp_v,yp_s

	end do

c-----------------------------

c        print *,' == yp_v yp_s pi  rs0 ===',yp_v,yp_s,pi,rs0

	tok_ech=0.
	do i=2,n
	   aj0_ech(i)=sb_ech(i)*yeff/yp_s*yq*1.e3
	   sb_ech(i)=sb_ech(i)/yp_v*yq
	   tok_ech=tok_ech+aj0_ech(i)*spo(i)*ha(i)
	end do

	apr='aj0_ech='
c	print 71,apr,(aj0_ech(i),i=1,n)

	p_ech=0.
	do i=2,n
	p_ech=p_ech+sb_ech(i)*2.*pi*vi(i)*ha(i)
	end do

	PNOR=6.25E8


	do i=2,n
	sb_ech(i)=sb_ech(i)*pnor
	end do

	apr='sb_ech='
c	print 71,apr,(sb_ech(i),i=1,n)

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))

c        print *,' == power_ech tok_ech===',p_ech,tok_ech

	tpl_ech=tok_ech

c	stop

	return
	end

        subroutine ip_ech_1()
        	include 'double.inc'
	include 'new_com.inc'

        call ip_ech_1_c(n,
     *  aj0_ech1,sb_ech1,ai,power_ech1,tt,pne,tpl_ech1,
     *  te0,spo,vi,ha,rs0,pi,tpl_cd,p_e1,kpr)

	return
	end

        subroutine ip_ech_1_c(n,
     *  aj0_ech1,sb_ech1,ai,power_ech1,tt,pne,tpl_ech1,
     *  te0,spo,vi,ha,rs0,pi,tpl_cd,p_e1,kpr)
    	include 'double.inc'
	dimension aj0_ech1(*),sb_ech1(*),ai(*),pne(*),te0(*),
     *  spo(*),vi(*),ha(*)

	character *20 apr

	i_en=i_en+1
	if(i_en.eq.-1)then

	 open (unit=41,file='eff_x2.dat',form='formatted')
	 read (41,*)
	 read (41,*)alfa_ech1

	close (41)


        if(kpr.eq.1)print *,'alfa_ech1',alfa_ech1

	end if

	if(p_e1.le.1.e-5)return
	if(abs(tpl_ech1).le.1.e-5)return

	PNOR=6.25E8

	yp_v=0.

	yp_s=0.

	do i=2,n

	yp_v=yp_v+sb_ech1(i)*2.*pi*vi(i)*ha(i)

	yp_s=yp_s+sb_ech1(i)*spo(i)*ha(i)

	end do

c-----------------------------


	alfa_ech1=1.e15
	yeff=alfa_ech1*1.e-19

        if(kpr.eq.1)print *,' == yp_v  yeff rs0 ===',yp_v,yeff,rs0
c--------------

 	tok_ech=0.

	do i=2,n

	   aj0_ech1(i)=0.1*(sb_ech1(i)*1.e6)*yeff*te0(i)/pne(i)
c TCV definition 
	   aj0_ech1(i)=aj0_ech1(i)*yp_v/yp_s*1.e-2

	   aj0_ech1(i)=aj0_ech1(i)/pnor

	   tok_ech=tok_ech+aj0_ech1(i)*spo(i)*ha(i)
	end do

c********************

	al1=tpl_ech1/tok_ech
	tok_ech1=tok_ech

 	tok_ech=0.
	do i=2,n
	   aj0_ech1(i)=aj0_ech1(i)*al1
	   tok_ech=tok_ech+aj0_ech1(i)*spo(i)*ha(i)
	end do

	if(kpr.eq.1)print*,' tpl_ech1 tok_ech tok_ech1',
     *  tpl_ech1,tok_ech,tok_ech1

c********************

	apr='aj0_ech1='
c	print 71,apr,(aj0_ech1(i),i=1,n)

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))


	return
	end


c*******************************
  	subroutine p_emo1()
  	include 'double.inc'
	include 'new_com.inc'

	call p_emo1_c(
     *  tt,p_e2(1),z_e2(1),r_e2(1),dz_e2(1),dr_e2(1),
     *  kpr)


	return
	end

  	subroutine p_emo1_c(
     *  tt,p_e1,z_e1,r_e1,dz_e1,dr_e1,
     *  kpr)
        include 'double.inc'
        include 'parf_mike'

	dimension t_t(ntime),p_e1_t(ntime),
     *  z_e1_t(ntime),r_e1_t(ntime),dz_e1_t(ntime),dr_e1_t(ntime)

	character *20 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='p_e1.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 
           
           read (41,*) 
           do i=1,n_t 
              read (41,*)t_t(i),p_e1_t(i),
     *  z_e1_t(i),r_e1_t(i),dz_e1_t(i),dr_e1_t(i)

              t_t(i)=t_t(i)*1000. 

           end do 
           
           apr='-t_t-' 
c           if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 
           close (unit=41) 
        end if
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

      do i=2,n_t
      if( (tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
	 t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )
c
	 p_e1=p_e1_t(i-1)+t_coef*(p_e1_t(i)-p_e1_t(i-1))

	 z_e1=z_e1_t(i-1)+t_coef*(z_e1_t(i)-z_e1_t(i-1))
	 r_e1=r_e1_t(i-1)+t_coef*(r_e1_t(i)-r_e1_t(i-1))

	 dz_e1=dz_e1_t(i-1)+t_coef*(dz_e1_t(i)-dz_e1_t(i-1))
	 dr_e1=dr_e1_t(i-1)+t_coef*(dr_e1_t(i)-dr_e1_t(i-1))

	pnor=1.e6

c
	 end if

	 end do

	if(kpr.eq.1)print *,' from SHAPE p_e1 r_e1 z_e1 ',p_e1,r_e1,z_e1

       return 
       end 
c*******************************
  	subroutine p_emo2()
  	include 'double.inc'
	include 'new_com.inc'

	call p_emo2_c(
     *  tt,p_e2(2),z_e2(2),r_e2(2),dz_e2(2),dr_e2(2),
     *  kpr)

	return
	end

  	subroutine p_emo2_c(
     *  tt,p_e2,z_e2,r_e2,dz_e2,dr_e2,
     *  kpr)
        include 'double.inc'
        include 'parf_mike'

	dimension t_t(ntime),p_e2_t(ntime),
     *  z_e2_t(ntime),r_e2_t(ntime),dz_e2_t(ntime),dr_e2_t(ntime)

	character *20 apr

	i_sh=i_sh+1

	if(i_sh.eq.1)then
c-------
           open (unit=41,file='p_e3.dat',form='formatted') 
           read (41,*) 
           read (41,*)n_t 

 	 if(kpr.eq.1)print *,' tt n_t===',tt,n_t 
           
           read (41,*) 
           do i=1,n_t 
              read (41,*)t_t(i),p_e2_t(i),
     *  z_e2_t(i),r_e2_t(i),dz_e2_t(i),dr_e2_t(i)

              t_t(i)=t_t(i)*1000. 

           end do 
           
           apr='-t_t-' 
c           if(kpr.eq.1)print 71,apr,(t_t(i),i=1,n_t) 
           close (unit=41) 
        end if
71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

      do i=2,n_t
      if( (tt-t_t(i-1))*(tt-t_t(i)).le.0.)then
c==================
	 t_coef=(tt-t_t(i-1))/( t_t(i)-t_t(i-1) )
c
	 p_e2=p_e2_t(i-1)+t_coef*(p_e2_t(i)-p_e2_t(i-1))

	 z_e2=z_e2_t(i-1)+t_coef*(z_e2_t(i)-z_e2_t(i-1))
	 r_e2=r_e2_t(i-1)+t_coef*(r_e2_t(i)-r_e2_t(i-1))

	 dz_e2=dz_e2_t(i-1)+t_coef*(dz_e2_t(i)-dz_e2_t(i-1))
	 dr_e2=dr_e2_t(i-1)+t_coef*(dr_e2_t(i)-dr_e2_t(i-1))

	pnor=1.e6

c
	 end if

	 end do

	if(kpr.eq.1)print *,' from SHAPE p_e2 r_e2 z_e2 ',p_e2,r_e2,z_e2

       return 
       end 

c********************************************************
	subroutine tri_filter(wen2_xx)
	include 'double.inc'
	include 'new_com.inc'

	call tri_filter_c(
     *  wen2_xx,ntay,tay,tt,kpr)

	return
	end

	subroutine tri_filter_c(
     *  wen2,ntay,tay,tt,kpr)
	include 'double.inc'


	if(time.lt.tt-0.5*tay)then
c  saving for the next time_step...
	e1 = f9a
	v1 = f9af
	time1 = time
	end if


	time=tt

	f9a=wen2

        i_en=i_en+1
	if(i_en.eq.1)then
           e1 = f9a
           f9af=e1
           v1 = f9af
           time1 = time
        end if

	taup=5.*tay

	qqp = 0.5 * (time - time1)/taup

	f9af =(qqp * (f9a + e1) - (qqp - 1.0) * v1) / (qqp + 1.0)


	wen2=f9af


	return
	end



c********************************************************

	subroutine r_filter(wen2_xx)
	include 'double.inc'
	include 'new_com.inc'

	call r_filter_c(
     *  wen2_xx,ntay,tay,tt,kpr)

	return
	end

	subroutine r_filter_c(
     *  wen2,ntay,tay,tt,kpr)
	include 'double.inc'


	if(time.lt.tt-0.5*tay)then
c  saving for the next time_step...
	e1 = f9a
	v1 = f9af
	time1 = time
	end if


	time=tt

	f9a=wen2

        i_en=i_en+1
	if(i_en.eq.1)then
           e1 = f9a
           f9af=e1
           v1 = f9af
           time1 = time
        end if

	taup=5.*tay

	qqp = 0.5 * (time - time1)/taup

	f9af =(qqp * (f9a + e1) - (qqp - 1.0) * v1) / (qqp + 1.0)


	wen2=f9af


	return
	end
c********************************************************
	subroutine a_filter(wen2_xx)
	include 'double.inc'
	include 'new_com.inc'

	call a_filter_c(
     *  wen2_xx,ntay,tay,tt,kpr)

	return
	end

	subroutine a_filter_c(
     *  wen2,ntay,tay,tt,kpr)
	include 'double.inc'


	if(time.lt.tt-0.5*tay)then
c  saving for the next time_step...
	e1 = f9a
	v1 = f9af
	time1 = time
	end if


	time=tt

	f9a=wen2

        i_en=i_en+1
	if(i_en.eq.1)then
           e1 = f9a
           f9af=e1
           v1 = f9af
           time1 = time
        end if

	taup=5.*tay

	qqp = 0.5 * (time - time1)/taup

	f9af =(qqp * (f9a + e1) - (qqp - 1.0) * v1) / (qqp + 1.0)


	wen2=f9af


	return
	end



	subroutine n0_filter(wen2_xx)
	include 'double.inc'
	include 'new_com.inc'

	call n0_filter_c(
     *  wen2_xx,ntay,tay,tt,kpr)

	return
	end

	subroutine n0_filter_c(
     *  wen2,ntay,tay,tt,kpr)
	include 'double.inc'


	if(time.lt.tt-0.5*tay)then
c  saving for the next time_step...
	e1 = f9a
	v1 = f9af
	time1 = time
	end if


	time=tt

	f9a=wen2

        i_en=i_en+1
	if(i_en.eq.1)then
           e1 = f9a
           f9af=e1
           v1 = f9af
           time1 = time
        end if

	taup=5.*tay

	qqp = 0.5 * (time - time1)/taup

	f9af =(qqp * (f9a + e1) - (qqp - 1.0) * v1) / (qqp + 1.0)


	wen2=f9af


	return
	end



c********************************************************

	subroutine n_i_filter(wen2_xx)
	include 'double.inc'
	include 'new_com.inc'

	call n_i_filter_c(
     *  wen2_xx,ntay,tay,tt,kpr)

	return
	end

	subroutine n_i_filter_c(
     *  wen2,ntay,tay,tt,kpr)
	include 'double.inc'


	if(time.lt.tt-0.5*tay)then
c  saving for the next time_step...
	e1 = f9a
	v1 = f9af
	time1 = time
	end if


	time=tt

	f9a=wen2

        i_en=i_en+1
	if(i_en.eq.1)then
           e1 = f9a
           f9af=e1
           v1 = f9af
           time1 = time
        end if

	taup=5.*tay

	qqp = 0.5 * (time - time1)/taup

	f9af =(qqp * (f9a + e1) - (qqp - 1.0) * v1) / (qqp + 1.0)


	wen2=f9af


	return
	end
	
	subroutine wr_tpl()
	include 'double.inc'
	include 'new_com.inc'

	call wr_tpl_c(
     * tpl,tt)

	return
	end

	subroutine wr_tpl_c(
     * tpl,tt)
	include 'double.inc'

	
	i_en=i_en+1
	if(i_en.eq.1)then
	ntime=9999
      open (unit=43,file='tpl.txt',form='formatted')
      write (43,*)' ktime'
      write (43,*)ntime
      write (43,*)'tt tpl'

	else
      open (unit=43,file='tpl.txt',access='append',
     * form='formatted')
	end if


5000    format (6(1pe14.6))
        write (43,*)tt*1.e-3,tpl*1.e-3,i_en

	close(43)

!      print *,' tt tpl =',tt,tpl

	return
	end
	subroutine dens_prof()
        include 'double.inc'
	include 'parf0'
	common
     *	/n_m/n,m,mp
	common
     *	/ge1e/rs0,tpl
     *	/ge3/AI(npo),A0(npo),HA2(npo),a(npo),ha(npo)
     *  /ge5/kpr
     *  /ge6/zeff(npo),qpr(npo),ppr(npo),pr0,prg,zar
     *  /ge6e/zeff_a,zeff_b
	common
     *  /pol6/ppx(npo),pffx(npo)
	common
     *	/efit0/kefit
     *	/efit1/alfax(2),betax(2)
     *	/efit2/alfa0,beta,alfa1
     *	/efit3/pw_1,pw_2
	common
     *  /dfm4/Q(npo),ANU(npo),P(npo),F(npo),PP(npo),PFF(npo)
	common
     *  /en1/PNE(npo),PD0(npo),PT0(npo),PH0(npo),PDN(npo),
     *  PTN(npo),PHN(npo)
     *  /en1e/te_a,ti_a,te_b,ti_b,pw_e
     *  /en2e/pd0_a,pt0_a,pd0_b,pt0_b,pw_p
     *  /en2/TE0(npo),TQ0(npo),TEN(npo),TQN(npo),WE0(npo),
     *  WQ0(npo)

	character *20 yy,apr

	if(kpr.eq.1)print *,' alfa0 beta alfa1 rs0',alfa0,beta,alfa1,rs0

	if(kpr.eq.1)print *,' KEFIT++++++++++++++++',kefit

	do i=1,n
	psix=a(i)
c	pd0(i)=pd0_b+(1.-psix**pw_p)*(pd0_a-pd0_b)
c	pt0(i)=pt0_b+(1.-psix**pw_p)*(pt0_a-pt0_b)
        ppp=1.
!	pd0(i)=pd0_b+((1.-psix**pw_p))**ppp*(pd0_a-pd0_b)
	pt0(i)=pt0_b+((1.-psix**pw_p))**ppp*(pt0_a-pt0_b)
	pne(i)=pd0(i)+pt0(i)
	end do


71	FORMAT(20X,A8/,(6(1X,1PE10.3)))

	return
	end

	subroutine pau()
	include 'double.inc'

	return
	end
	subroutine zz_filter(wen2_xx)
	include 'double.inc'
	include 'new_com.inc'

	call zz_filter_c(
     *  wen2_xx,ntay,tay,tt,kpr)

	return
	end

	subroutine zz_filter_c(
     *  wen2,ntay,tay,tt,kpr)
	include 'double.inc'


	if(time.lt.tt-0.5*tay)then
c  saving for the next time_step...
	e1 = f9a
	v1 = f9af
	time1 = time
	end if


	time=tt

	f9a=wen2

        i_en=i_en+1
	if(i_en.eq.1)then
           e1 = f9a
           f9af=e1
           v1 = f9af
           time1 = time
        end if

	taup=5.*tay

	qqp = 0.5 * (time - time1)/taup

	f9af =(qqp * (f9a + e1) - (qqp - 1.0) * v1) / (qqp + 1.0)


	wen2=f9af


	return
	end


      subroutine ip_lh()
	include 'double.inc'
	include 'new_com.inc'

        call ip_lh_c(n,
     *  aj0_lh,sb_lh,ai,power_lh,tt,pcch,s,vi,ha,rs0,pi,
     *  tpl_lh,kpr)

	return
	end

        subroutine ip_lh_c(n,
     *  aj0_lh,sb_lh,ai,power_lh,tt,pcch,spo,vi,ha,rs0,pi,
     *  tpl_lh,kpr)
	include 'double.inc'

	dimension aj0_lh(*),sb_lh(*),ai(*),spo(*),vi(*),ha(*)

	character *20 apr

	i_en=i_en+1
	if(i_en.eq.1)then

	 open (unit=41,file='lh.dat',form='formatted')
	 read (41,*)
	 read (41,*)ro_uv,del_uv,pow_uv
	 read (41,*)
	 read (41,*)gam_uv,tt_uv

         if(kpr.eq.1)print *,'ro_uv,del_uv,pow_uv',ro_uv,del_uv,pow_uv
         if(kpr.eq.1)print *,'gam_uv tt_uv',gam_uv,tt_uv

	end if

	if(tt.le.tt_uv)return

      if(kpr.eq.1)print *,' == pi pcch rs0 ===',pi,pcch,rs0

	
	tpl_lh=power_lh*1.e6*gam_uv/(pcch*0.1*rs0*1.e-2)
	
	tpl_lh=tpl_lh*1.e-3

	do i=2,n	   
	   aj0_lh(i)=0.
	   sb_lh(i)=0.
	enddo


        if(kpr.eq.1)print*,'from ip_lh'
        if(kpr.eq.1)print*,'tt tpl_lh power_lh gam_uv pcch rs0'
        if(kpr.eq.1)print*,tt,tpl_lh,power_lh,gam_uv,pcch,rs0


	do i=2,n

           if(abs(ro_uv-ai(i)).le.del_uv)then
              aj0_lh(i)=abs(1.-abs(ai(i)-ro_uv)/
     *  del_uv)**pow_uv

	      sb_lh(i)=aj0_lh(i)

           end if

        end do
	
	tok_lh=0.
	do i=2,n
	tok_lh=tok_lh+aj0_lh(i)*spo(i)*ha(i)
	end do

	al1=tpl_lh/tok_lh

	tok_lh=0.
	do i=2,n
	aj0_lh(i)=aj0_lh(i)*al1
	tok_lh=tok_lh+aj0_lh(i)*spo(i)*ha(i)
	end do

	apr='aj0_lh='
c	if(kpr.eq.1)print 71,apr,(aj0_lh(i),i=1,n)

	p_lh=0.
	do i=2,n
	p_lh=p_lh+sb_lh(i)*2.*pi*vi(i)*ha(i)
	end do

	al1=power_lh/p_lh
	PNOR=6.25E8

	p_lh=0.
	do i=2,n
	sb_lh(i)=sb_lh(i)*al1
	p_lh=p_lh+sb_lh(i)*2.*pi*vi(i)*ha(i)

	sb_lh(i)=sb_lh(i)*pnor

	end do

	apr='sb_lh='
c	if(kpr.eq.1)print 71,apr,(sb_lh(i),i=1,n)

71	FORMAT(5X,A10/,(2x,6(1PE11.3)))

        if(kpr.eq.1)print *,' == power_lh tok_lh===',p_lh,tok_lh

	return
	end
