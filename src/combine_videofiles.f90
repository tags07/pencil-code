! $Id: read_videofiles.f90 10335 2009-02-05 23:24:22Z pencilsteve $

!***********************************************************************
      program combine_videofiles
!
!  combine slices for two different frequencies and combine
!  using a suitable color table layout.
!
!  24-feb-09/axel: adapted from read_videofiles.x
!
      use Cparam
      use General
!
      implicit none
!
      real, dimension (nxgrid,nygrid) :: xy,xy1,xy2
      real, dimension (nxgrid,nzgrid) :: xz,xz1,xz2
      real, dimension (nygrid,nzgrid) :: yz,yz1,yz2
!
      integer :: it
      integer :: lun0,lun1,lun2
      logical :: eof=.false.
      real :: t,fac1,fac2,maxval1,maxval2
!
      character (len=120) :: dir='',wfile='',rfile1='',rfile2=''
      character (len=20) :: field='Jrad'
!
!  read name of the field (must coincide with file extension)
!
      write(*,'(a)',ADVANCE='NO') 'enter name of variable (Jrad): '
      read*,fac1,fac2
!     read*,field
!
      dir='data/slice_'
      dir='data/proc0/slice_'
      eof=.false.
!
!  loop through all times and convert xy, xz, and yz files
!  reset the lun to 10 every time. This guarantees unique luns every time round
!
      it=0
      do while (.true.)
        it=it + 1
        lun0=0
        lun1=10
        lun2=20
        call safe_character_assign(rfile1,trim(dir)//trim(field)//'1'//'.xy2')
        call safe_character_assign(rfile2,trim(dir)//trim(field)//'2'//'.xy2')
        call rslice(trim(rfile1),xy1,nxgrid,nygrid,t,it,lun1,eof); if (eof) goto 999
        call rslice(trim(rfile2),xy2,nxgrid,nygrid,t,it,lun2,eof); if (eof) goto 999
        maxval1=max(maxval1,maxval(fac1*xy1))
        maxval2=max(maxval2,maxval(fac2*xy2))
        xy=int(16*fac1*xy1)+16*int(16*fac2*xy2)
        xy=16*int(16*fac1*xy1)+int(16*fac2*xy2)
        call safe_character_assign(wfile,trim(dir)//trim(field)//'.xy2')
        call wslice(trim(wfile),xy,nxgrid,nygrid,t,it,lun0)
!
        call safe_character_assign(rfile1,trim(dir)//trim(field)//'1'//'.xy')
        call safe_character_assign(rfile2,trim(dir)//trim(field)//'2'//'.xy')
        call rslice(trim(rfile1),xy1,nxgrid,nygrid,t,it,lun1,eof); if (eof) goto 999
        call rslice(trim(rfile2),xy2,nxgrid,nygrid,t,it,lun2,eof); if (eof) goto 999
        maxval1=max(maxval1,maxval(fac1*xy1))
        maxval2=max(maxval2,maxval(fac2*xy2))
        xy=int(16*fac1*xy1)+16*int(16*fac2*xy2)
        xy=16*int(16*fac1*xy1)+int(16*fac2*xy2)
        call safe_character_assign(wfile,trim(dir)//trim(field)//'.xy')
        call wslice(trim(wfile),xy,nxgrid,nygrid,t,it,lun0)
!
        call safe_character_assign(rfile1,trim(dir)//trim(field)//'1'//'.xz')
        call safe_character_assign(rfile2,trim(dir)//trim(field)//'2'//'.xz')
        call rslice(trim(rfile1),xz1,nxgrid,nzgrid,t,it,lun1,eof); if (eof) goto 999
        call rslice(trim(rfile2),xz2,nxgrid,nzgrid,t,it,lun2,eof); if (eof) goto 999
        maxval1=max(maxval1,maxval(fac1*xz1))
        maxval2=max(maxval2,maxval(fac2*xz2))
        xz=int(16*fac1*xz1)+16*int(16*fac2*xz2)
        xz=16*int(16*fac1*xz1)+int(16*fac2*xz2)
        call safe_character_assign(wfile,trim(dir)//trim(field)//'.xz')
        call wslice(trim(wfile),xz,nxgrid,nzgrid,t,it,lun0)
!
        call safe_character_assign(rfile1,trim(dir)//trim(field)//'1'//'.yz')
        call safe_character_assign(rfile2,trim(dir)//trim(field)//'2'//'.yz')
        call rslice(trim(rfile1),yz1,nygrid,nzgrid,t,it,lun1,eof); if (eof) goto 999
        call rslice(trim(rfile2),yz2,nygrid,nzgrid,t,it,lun2,eof); if (eof) goto 999
        maxval1=max(maxval1,maxval(fac1*yz1))
        maxval2=max(maxval2,maxval(fac2*yz2))
        yz=int(16*fac1*yz1)+16*int(16*fac2*yz2)
        yz=16*int(16*fac1*yz1)+int(16*fac2*yz2)
        call safe_character_assign(wfile,trim(dir)//trim(field)//'.yz')
        call wslice(trim(wfile),yz,nygrid,nzgrid,t,it,lun0)
!
      enddo
!
999     continue
!
print*,'maxval1=',maxval1
print*,'maxval2=',maxval2
      end
!***********************************************************************
    subroutine rslice(file,a,ndim1,ndim2,t,it,lun,eof)
!
!  appending to an existing slice file
!
!  12-nov-02/axel: coded
!
      integer :: ndim1,ndim2
      character (len=*) :: file
      real, dimension (ndim1,ndim2) :: a
      integer :: it,lun
      logical :: eof
      real :: t
!
      if (it==1) open(lun,file=file,status='old',form='unformatted')
      read(lun,end=999) a,t
      lun=lun+1
      goto 900
!
!  when end of file
!
999   eof=.true.
!
900   continue
!
    endsubroutine rslice
!***********************************************************************
    subroutine wslice(file,a,ndim1,ndim2,t,it,lun)
!
!  appending to an existing slice file
!
!  12-nov-02/axel: coded
!
      integer :: ndim1,ndim2
      character (len=*) :: file
      real, dimension (ndim1,ndim2) :: a
      integer :: it,lun
      real :: t, pos=0.
!
      if (it==1) open(lun,file=file,form='unformatted')
      write(lun) a,t,pos
      lun=lun+1
!
    endsubroutine wslice
!***********************************************************************
