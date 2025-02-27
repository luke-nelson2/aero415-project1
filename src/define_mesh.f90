module DefineMesh
    use iso_fortran_env, only: dp => real64
    implicit none
    type :: Mesh
        integer :: i_max,j_max ! Grid size
        integer :: num_points ! i*j
        real(dp) :: d_zeta, d_eta
        real(dp), allocatable :: x(:)
        real(dp), allocatable :: y(:)
    end type Mesh
contains
    subroutine define_mesh_shape(msh, i_size,j_size)
        type(Mesh), intent(inout) :: msh
        integer, intent(in) :: i_size, j_size
        
        msh%i_max = i_size
        msh%j_max = j_size
        msh%d_zeta = 1.0_dp / real(i_size-1,dp)
        msh%d_eta = 1.0_dp / real(j_size-1,dp)
        msh%num_points = i_size * j_size

        allocate(msh%x(msh%num_points))
        allocate(msh%y(msh%num_points))
    
    end subroutine define_mesh_shape

    ! returns l mesh index based on i_max, j_max, and point i,j on the mesh
    function mesh_index(i,j,msh) result(idx)
        type(Mesh), intent(in) :: msh
        integer, intent(in) :: i,j
        integer :: idx
        idx = (j-1)*msh%i_max + i
    end function mesh_index

    subroutine file_output(msh, file_name)
        implicit none
        character(len=*), intent(in) :: file_name
        type(Mesh), intent(in) :: msh
        integer :: unit
        
        open(newunit=unit, file=file_name, form="unformatted", access="stream", action="write", status="replace")
        
        ! Write metadata
        write(unit) msh%i_max, msh%j_max, msh%num_points, msh%d_zeta, msh%d_eta
    
        ! Write x and y arrays in bulk (fast!)
        write(unit) msh%x, msh%y  
    
        close(unit)
    end subroutine file_output

    subroutine file_output2(msh, file_name)
        implicit none
        character(len=*), intent(in) :: file_name
        type(Mesh), intent(in) :: msh
        integer :: unit
        
        open(newunit=unit, file=file_name)
        
        ! Write metadata
        write(unit, *) msh%i_max, msh%j_max
    
        ! Write x and y arrays in bulk (fast!)
        write(unit, *) msh%x, msh%y  
    
        close(unit)
    end subroutine file_output2

    subroutine file_input(msh, file_name)
        implicit none
        character(len=*), intent(in) :: file_name
        type(Mesh), intent(out) :: msh
        integer :: unit
    
        open(newunit=unit, file=file_name, form="unformatted", access="stream", action="read")
    
        ! Read metadata
        read(unit) msh%i_max, msh%j_max, msh%num_points, msh%d_zeta, msh%d_eta
    
        ! Allocate arrays based on num_points
        allocate(msh%x(msh%num_points), msh%y(msh%num_points))
    
        ! Read x and y arrays in bulk
        read(unit) msh%x, msh%y  
    
        close(unit)
    end subroutine file_input
    
    

    ! subroutine file_output(msh, file_name)
    !     type(Mesh), intent(in) :: msh
    !     character(len=*), intent(in) :: file_name 
    !     integer :: i, unit
    !     open(unit, file=file_name, status="replace", action="write")
    !     write(unit, "(I0,',',I0)") msh%i_max, msh%j_max
    !     write(unit, "(I0)") msh%num_points
    !     write(unit, "(F9.7,',',F9.7)") msh%d_zeta, msh%d_eta
    !     write(unit, '(A)') "x,y"
    !     do i=1, msh%num_points
    !         write(unit, "(G0,',',G0)") msh%x(i), msh%y(i)
    !     end do
    !     close(unit)
    ! end subroutine file_output

    ! subroutine file_input(msh, file_name)
    !     character(len=*), intent(in) :: file_name
    !     type(Mesh), intent(out) :: msh
    !     integer :: i
    !     character(len=100) :: dummy  ! To skip lines
    !     integer :: unit  ! File unit number
        
    !     ! Assign a unit number and open the file
    !     unit = 20
    !     open(unit, file=file_name, status="old", action="read")
    
    !     ! Read first three lines (not needed for arrays)
    !     read(unit, *) msh%i_max, msh%j_max
    !     read(unit, *) msh%num_points
    !     read(unit, *) msh%d_zeta, msh%d_eta
    
    !     ! Skip the fourth line (x,y header)
    !     read(unit, '(A)') dummy  
    
    !     ! Allocate arrays based on num_points
    !     allocate(msh%x(msh%num_points), msh%y(msh%num_points))
    
    !     ! Read x, y coordinates
    !     do i = 1, msh%num_points
    !         read(unit, *) msh%x(i), msh%y(i)
    !     end do
    
    !     ! Close file
    !     close(unit)
    
    ! end subroutine file_input
    
    
end module DefineMesh