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

    subroutine file_output2(msh, file_name)
        implicit none
        character(len=*), intent(in) :: file_name
        type(Mesh), intent(in) :: msh
        integer :: unit
        
        open(newunit=unit, file=file_name)
        
        write(unit, *) msh%i_max, msh%j_max
    
        write(unit, *) msh%x, msh%y  
    
        close(unit)
    end subroutine file_output2
end module DefineMesh
