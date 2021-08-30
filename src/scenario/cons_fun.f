
      module IfwinW
    !missing unicode interfaces from IFWIN +  other missing interfaces
         use ifwinty
       !DEC$OBJCOMMENT LIB:"USER32.LIB"
       !DEC$OBJCOMMENT LIB:"KERNEL32.LIB"
        interface 
        function AttachConsole(dwProcessId)
        import !if intel add this missing inteface we should then get an error
        integer(bool)  :: AttachConsole
            !DEC$ ATTRIBUTES DEFAULT, STDCALL, DECORATE, 
     &  ALIAS:'AttachConsole' :: AttachConsole
            integer(dword) :: dwProcessId
            !DEC$ ATTRIBUTES VALUE :: dwProcessId
        end function AttachConsole
       end interface
      END MODULE IfwinW
      
      subroutine OpenCloseConsole(Iopen) !iopen=1 open, iopen=0 close
         use ifwin
       use IfwinW  !: AttachConsole
       use ifport  !: sleep, getlasterror
    
        implicit none
        integer, intent(in)     :: iopen
       integer(bool)           :: bret, bret2
        integer(handle)  :: fhandle,hNewScreenBuffer,hFile,hFile0
        integer(handle)         :: Pipe_Rd,Pipe_Wr
        integer(handle),save :: hFile1
       integer(dword)          :: dwX, dwY, dwXSize, dwYSize ! initial size and position of console (pix/screen)
       Type(T_COORD)           :: wpos
       type (T_STARTUPINFO)               :: StartupInfo
       type (T_PROCESS_INFORMATION), save :: ProcessInfo
       
       TYPE (T_SECURITY_ATTRIBUTES) lpPipeAttributes
       

      integer i, iy
      
      parameter ( iy=100)
      
      
      character *14 a_vv(iy)    





!       structure struc
       


      
!      fhandle =freopen( "CON", "w", stdout ) 


!        bret = AttachConsole(ProcessInfo%dwProcessId)
!        bret = AttachConsole(ATTACH_PARENT_PROCESS)

!	call print1( 'bret==',dfloat(bret))

!        fhandle = GetStdHandle(STD_OUTPUT_HANDLE)
      
!      hFile=DeleteFile("a")

      
!      hFile=OpenFile("a1", Buf, 
!     &  OF_READWRITE)

      !bret=FreeConsole()

      if(Iopen.eq.0)then
!            print *,' hFile=============',hFile
!            return
      end if
      
      
      !write(*,*), 'hFile saved =', hFile

      !bret=AllocConsole() 

!      i=1
!      write(a_vv(i),'(a,i2)') 'a.',i      

      hFile0 = GetStdHandle(STD_OUTPUT_HANDLE)
      if (hFile0.gt.10) then        

         hFile = hFile0
         bret = SetFilePointer(hFile0,0,0,0)
         bret2 = SetEndOfFile(hFile0)
         print *,' Set to start of old log file, ret ==',bret,
     *   'Clear old log file, ret ==',bret2
         
         
         
      else
      
        hFile=CreateFile('a',GENERIC_WRITE,
     *  FILE_SHARE_READ,NULL,CREATE_ALWAYS,
     *  FILE_ATTRIBUTE_NORMAL,0)         
     
        bret=SetStdHandle(STD_OUTPUT_HANDLE,hFile) 
        print *,' New log file, SetStdHandle ret == ', bret     
         
      endif
      
      
      print *,' hFile0 ==',hFile0
      
      print *,' hFile1 ==',hFile1
      hFile1 = hFile
            
      if(hFile.lt.0)then
       hFile = GetStdHandle(STD_OUTPUT_HANDLE)
       print*, 'hFile < 0'
      end if

      print*, 'Iopen = ', Iopen
      print *,' hFile = ',hFile
      print *, 'StdHandle = ', GetStdHandle(STD_OUTPUT_HANDLE)


 !     bret=SetFilePointer(hFile, 0, 0, FILE_BEGIN)

  !    print *,' bret==',bret
      
 !     bret=FreeConsole()

!      print *,' 2 bret==',bret
     
!      read (*,*)
      
!      bret=SetStdHandle("CONOUT$",hFile)

 
!        fhandle = GetStdHandle(STD_OUTPUT_HANDLE)

!	call print1( 'fhandle==',dfloat(fhandle))


!        hNewScreenBuffer = CreateConsoleScreenBuffer( 
!     &   GENERIC_WRITE, 
!     &   FILE_SHARE_WRITE,
!     & NULL,            
!     & CONSOLE_TEXTMODE_BUFFER,
!     & NULL);              
     
     
!       bret =SetConsoleActiveScreenBuffer(hNewScreenBuffer)
!       bret =SetConsoleActiveScreenBuffer(fhandle)
       
       print *,' hello'
      
      end subroutine OpenCloseConsole


          subroutine OpenCloseConsole2(Iopen) !iopen=1 open, iopen=0 close
         use ifwin
       use IfwinW, only: AttachConsole
       use ifport, only: sleep, getlasterror
    
        implicit none
        integer, intent(in)     :: iopen
       integer(bool)           :: bret
        integer(handle)         :: fhandle,hNewScreenBuffer,hFile
       integer(dword)          :: dwX, dwY, dwXSize, dwYSize ! 
       Type(T_COORD)           :: wpos
       type (T_STARTUPINFO)               :: StartupInfo
       type (T_PROCESS_INFORMATION), save :: ProcessInfo
      
!       structure struc
       


      
!      fhandle =freopen( "CON", "w", stdout ) 


!        bret = AttachConsole(ProcessInfo%dwProcessId)
!        bret = AttachConsole(ATTACH_PARENT_PROCESS)

!	call print1( 'bret==',dfloat(bret))

!        fhandle = GetStdHandle(STD_OUTPUT_HANDLE)

      if(Iopen.eq.0)then
      bret=FreeConsole()
      hFile= GetStdHandle(STD_OUTPUT_HANDLE)
      bret=CloseHandle(hFile)
      bret=DeleteFile("a2")     
      return
      end if
      

!      bret=FreeConsole()
!      hFile= GetStdHandle(STD_OUTPUT_HANDLE)
!      bret=CloseHandle(hFile)
!      hFile=DeleteFile("a")
      
      hFile=CreateFile("a2",GENERIC_WRITE,
     & FILE_SHARE_READ,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0)

 !     hFile=CreateFile("a",GENERIC_WRITE,
 !    & FILE_SHARE_READ,NULL,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,0);


!      hFile=OpenFile("a",OFSTRUCT,
!     & OF_READWRITE);

 
!      hFile=CreateFile("a",GENERIC_WRITE,
!     & FILE_SHARE_READ,NULL,TRUNCATE_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
     
      bret=AllocConsole() 

      bret=SetStdHandle(STD_OUTPUT_HANDLE,hFile)


      print *,' hFile==',hFile

      print *,' bret==',bret

      bret=FreeConsole()

      print *,' bret==',bret

!        fhandle = GetStdHandle(STD_OUTPUT_HANDLE)

!	call print1( 'fhandle==',dfloat(fhandle))


!        hNewScreenBuffer = CreateConsoleScreenBuffer( 
!     &   GENERIC_WRITE, 
!     &   FILE_SHARE_WRITE,
!     & NULL,            
!     & CONSOLE_TEXTMODE_BUFFER,
!     & NULL);              
     
     
!       bret =SetConsoleActiveScreenBuffer(hNewScreenBuffer)
!       bret =SetConsoleActiveScreenBuffer(fhandle)
       
       print *,' hello'
      
      end subroutine OpenCloseConsole2

    