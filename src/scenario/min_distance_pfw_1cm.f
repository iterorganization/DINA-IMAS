        subroutine min_dist_pfw(dNB_xx)
	include 'double.inc'
	include 'new_com.inc'
      
      dimension dNB_xx(*)
c!!!	common
c!!!     *  /eq8/jbound,xbound(ntet),ybound(ntet),alfa0_xx

        call min_dist_c_pfw(jbound,xbound,ybound,
     &       dNB_xx,psep,
     *  rp1,zp1,dist1,rp2,zp2,dist2)

        return
        end
    

        subroutine min_dist_c_pfw(NB,Rbound,Zbound,dNB,psep,
     *  rp1,zp1,dist1,rp2,zp2,dist2)
	include 'double.inc'

	dimension Rbound(NB),Zbound(NB),
     &	dNB(24),Rlim2(24),Zlim2(24)


c	data Rlim2/413.8,409.7,408.2,406.7,407.6,410.1,
c     &	617.0,699.4,765.2,808.7,827.0,728.3,677.5,626.7/
c	data Rlim2/417.8,413.8,409.7,408.2,406.7,405.6,
c     &  404.6,404.6,404.6,406.1,407.6,410.1,
c     &	617.0,699.4,765.2,808.7,827.0,833.2,835.0,810.3,759.1,
c!!!     &  728.3,677.5,626.7/
c     &  728.3,677.5,640./
	data Rlim2/408.53,408.53,408.53,408.53,408.53,408.53,
     &  408.53,408.53,408.53,408.53,408.53,410.53,
     &	615.29,697.7,765.39,808.79,826.97,833.17,834.98,810.29,759.13,
     &  728.24,677.42,626.61/

c	data Zlim2/-250.6,-200.3,-150.0,-99.2,-48.4,2.5,
c     &  53.3,104.1,154.9,205.7,256.6,307.4,
c     &	421.3,353.6,282.1,207.3,168.1,115.7,10.6,-88.1,-179.9,
c!!!     &  -225.7,-265.2,-304.6/
c     &  -225.7,-265.2,-295./
	data Zlim2/-250.37,-199.75,-149.14,-98.37,-47.61,3.21,
     &  54.02,104.84,155.66,206.42,257.19,307.85,
     &	423.0,355.26,282.22,207.47,168.47,116.0,10.77,-87.86,-179.58,
     &  -225.44,-264.89,-304.34/


      include 'parf2'                                                 
      common /sep_points/n_sep,x_sep(mu1),y_sep(mu1)

      dimension pdd(6),rpoints(mu1),zpoints(mu1),psip(mu1)



5000	format(4(1x,1pe14.7))


        ds=1.d0
        
        n_fw=24
        do j=1,n_fw

           dNB(j)=1e8

         do i=1,NB-1
           d=sqrt((Rbound(i+1)-Rbound(i))**2+(Zbound(i+1)-Zbound(i))**2)
           nd=d/ds
           pnd=float(nd)
           
!           print*,'!!!i nd d ds',i,nd,d,ds
           
           do jj=1,nd
           Rbb=Rbound(i)+(Rbound(i+1)-Rbound(i))*float(jj-1)/pnd
           Zbb=Zbound(i)+(Zbound(i+1)-Zbound(i))*float(jj-1)/pnd
              d=sqrt( (Rbb-Rlim2(j))**2+(Zbb-Zlim2(j))**2 )
              if(d .lt. dNB(j)) then 
              dNB(j)=d
              jj_min=jj
              ii_min=i
              Rbb_min=Rbb
              zbb_min=zbb
              end if
           enddo  ! jj
           
        enddo  ! i
        

!        print *,' j jj_min ii_min dNB(j) rbb r rb zbb z zb',
!     *  j,jj_min,ii_min,dNB(j),
!     *  rbb_min,rlim2(j),rbound(ii_min),zbb_min,zlim2(j),zbound(ii_min)


        enddo  ! j

      rp1=99999.
      zp1=0.
      d1=rp1
      
      rp2=99999.
      zp2=0.
      d2=rp2

      R2=5.5642e2
      Z2= -3.924e2
      R1=5.5642e2
      Z1=-4.5743e2           

           d=sqrt((R2-R1)**2+(Z2-Z1)**2)
           nd=d/ds
           pnd=float(nd)
           
c           print*,'!!!nd1 d1 ds',nd,d,ds
           
           do jj=1,nd
           rpoints(jj)=R1+(R2-R1)*float(jj-1)/pnd
           zpoints(jj)=Z1+(Z2-Z1)*float(jj-1)/pnd
           urr=rpoints(jj)
           vrr=zpoints(jj)
           call boxd(urr,vrr,pdd,ier)
           psip(jj)=pdd(1)	
!           print*,'!!!jj psep  psip',jj,psep,psip(jj)
           end do

       ind_p=0
       do jj=2,nd
       
       if( (psip(jj-1)-psep)*(psip(jj)-psep).le.0.d0)then
       ind_p=ind_p+1
       t_coef=(psep-psip(jj-1))/( psip(jj)-psip(jj-1) )       
       rp=rpoints(jj-1)+t_coef*(rpoints(jj)-rpoints(jj-1))
       zp=zpoints(jj-1)+t_coef*(zpoints(jj)-zpoints(jj-1))       
       end if
      end do

c       print*,'!!!ind_p1',ind_p
     
      if(ind_p.ne.0)then
      rp1=rp
      zp1=zp
      d1=sqrt((rp1-R1)**2+(zp1-Z1)**2)
      end if
      
      if(ind_p.eq.0)then
      
      alf=100./d
      
      R3=R1+(R1-R2)*alf
      Z3=Z1+(Z1-Z2)*alf
      
c      print*,'!!!R3 Z3',R3,Z3

      R2=R3
      Z2=Z3

           d=sqrt((R2-R1)**2+(Z2-Z1)**2)
           nd=d/ds
           pnd=float(nd)
           
c           print*,'!!!nd1 d1 ds',nd,d,ds
           
           do jj=1,nd
           rpoints(jj)=R1+(R2-R1)*float(jj-1)/pnd
           zpoints(jj)=Z1+(Z2-Z1)*float(jj-1)/pnd
           urr=rpoints(jj)
           vrr=zpoints(jj)
           call boxd(urr,vrr,pdd,ier)
           psip(jj)=pdd(1)	
!           print*,'!!!jj psep  psip',jj,psep,psip(jj)
           end do

       ind_p=0
       do jj=2,nd
       
       if( (psip(jj-1)-psep)*(psip(jj)-psep).le.0.d0)then
       ind_p=ind_p+1
       t_coef=(psep-psip(jj-1))/( psip(jj)-psip(jj-1) )       
       rp=rpoints(jj-1)+t_coef*(rpoints(jj)-rpoints(jj-1))
       zp=zpoints(jj-1)+t_coef*(zpoints(jj)-zpoints(jj-1))       
       end if
      end do

c      print*,'!!!ind_p2',ind_p
      
      if(ind_p.ne.0)then
      rp1=rp
      zp1=zp
      d1=-sqrt((rp1-R1)**2+(zp1-Z1)**2)
      end if
            
      end if ! ind_p =0

        

      R2=4.4745e2     
      Z2=-3.2775e2
      R1=4.1624e2
      Z1=-3.9175e2

           d=sqrt((R2-R1)**2+(Z2-Z1)**2)
           nd=d/ds
           pnd=float(nd)
           
c           print*,'!!!nd2 d2 ds',nd,d,ds
           
           do jj=1,nd
           rpoints(jj)=R1+(R2-R1)*float(jj-1)/pnd
           zpoints(jj)=Z1+(Z2-Z1)*float(jj-1)/pnd
           urr=rpoints(jj)
           vrr=zpoints(jj)
           call boxd(urr,vrr,pdd,ier)
           psip(jj)=pdd(1)	
!           print*,'!!!jj psep  psip',jj,psep,psip(jj)
           end do

       ind_p=0
       do jj=2,nd
       
       if( (psip(jj-1)-psep)*(psip(jj)-psep).le.0.d0)then
       ind_p=ind_p+1
       t_coef=(psep-psip(jj-1))/( psip(jj)-psip(jj-1) )       
       rp=rpoints(jj-1)+t_coef*(rpoints(jj)-rpoints(jj-1))
       zp=zpoints(jj-1)+t_coef*(zpoints(jj)-zpoints(jj-1))       
       end if
      end do

c       print*,'!!!ind_p1',ind_p
      if(ind_p.ne.0)then
      rp2=rp
      zp2=zp
      d2=sqrt((rp2-R1)**2+(zp2-Z1)**2)
      end if
      
      if(ind_p.eq.0)then

       alf=100./d
      
      R3=R1+(R1-R2)*alf
      Z3=Z1+(Z1-Z2)*alf
      
c      print*,'!!!R3 Z3',R3,Z3

      R2=R3
      Z2=Z3

           d=sqrt((R2-R1)**2+(Z2-Z1)**2)
           nd=d/ds
           pnd=float(nd)
           
c           print*,'!!!nd2 d2 ds',nd,d,ds
           
           do jj=1,nd
           rpoints(jj)=R1+(R2-R1)*float(jj-1)/pnd
           zpoints(jj)=Z1+(Z2-Z1)*float(jj-1)/pnd
           urr=rpoints(jj)
           vrr=zpoints(jj)
           call boxd(urr,vrr,pdd,ier)
           psip(jj)=pdd(1)	
!           print*,'!!!jj psep  psip',jj,psep,psip(jj)
           end do

        ind_p=0
       do jj=2,nd
       
       if( (psip(jj-1)-psep)*(psip(jj)-psep).le.0.d0)then
       ind_p=ind_p+1
       t_coef=(psep-psip(jj-1))/( psip(jj)-psip(jj-1) )       
       rp=rpoints(jj-1)+t_coef*(rpoints(jj)-rpoints(jj-1))
       zp=zpoints(jj-1)+t_coef*(zpoints(jj)-zpoints(jj-1))       
       end if
       end do
 
c       print*,'!!!ind_p2',ind_p
      
      if(ind_p.ne.0)then
      rp2=rp
      zp2=zp
      d2=-sqrt((rp2-R1)**2+(zp2-Z1)**2)
      end if
      
       end if ! ind_p=0
      
      dist1=d1
      dist2=d2
         
c      print*,'!!!rp1 zp1 d1 ',rp1,zp1,dist1
c      print*,'!!!rp2 zp2 d2',rp2,zp2,dist2
          
        return
        end
