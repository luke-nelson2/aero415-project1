module MeshInitialization
    use DefineMesh
    implicit none
    
    abstract interface
        function f_interface(x) result(y)
            import :: dp
            real(dp), intent(in) :: x
            real(dp) :: y
        end function f_interface
    end interface
contains
    ! subroutine apply_upper(msh,f)
    !     type(Mesh), intent(inout) :: msh
    !     interface
    !         function f(x) result(y)
    !             real, intent(in) :: x
    !             real :: y
    !         end function f
    !     end interface
    ! end subroutine apply_upper

    ! applies boundary conditions based on function of x that outputs y
    ! x values are linearly interpolated
    ! upperlower should be entered as 0 or 1. 0: lower, 1: upper
    subroutine apply_upperlower(msh,f,start_x,end_x,upperlower)
        type(Mesh), intent(inout) :: msh
        real(dp), intent(in) :: start_x, end_x
        integer :: i,j,idx
        integer :: upperlower
        procedure(f_interface) :: f

        if (upperlower == 0) then
            j = 1
        else if (upperlower == 1) then
            j = msh%j_max
        end if

        do i = 1,msh%i_max
            idx = mesh_index(i,j,msh)
            msh%x(idx) = (end_x-start_x) / real(msh%i_max-1,dp) * (i-1) + start_x
            msh%y(idx) = f(msh%x(idx))
        end do
    end subroutine apply_upperlower

    ! function of y that returns x
    subroutine apply_leftright(msh, f, start_y, end_y,leftright)
        type(Mesh), intent(inout) :: msh
        real(dp), intent(in) :: start_y, end_y
        integer :: i,j,idx
        integer :: leftright
        procedure(f_interface) :: f

        if (leftright == 0) then
            i = 1
        else if (leftright == 1) then
            i = msh%i_max
        end if

        do j = 1, msh%j_max
            idx = mesh_index(i,j,msh)
            msh%y(idx) = (end_y-start_y) / (msh%j_max-1) * (j-1) + start_y
            msh%x(idx) = f(msh%y(idx))
        end do
    end subroutine apply_leftright

    ! arbitrary but theoretically should set to algebraic grid
    ! for now we'll do an arbitrary square grid
    subroutine apply_center(msh)
        type(Mesh), intent(inout) :: msh
        integer :: i,j,idx
        do j = 2, msh%j_max-1
            do i = 2, msh%i_max-1
                idx = mesh_index(i,j,msh)
                msh%x(idx) = real(i-1,dp) / real(msh%i_max-1,dp) + 2
                msh%y(idx) = real(j-1,dp) / real(msh%j_max-1,dp)
            end do
        end do

    end subroutine apply_center

    ! assumes right left bounds are vertical
    ! currently it assumes length=5
    ! will change later
    subroutine apply_algebraic_center(msh)
        type(Mesh), intent(inout) :: msh
        integer i,j,idx,uidx,lidx
        do j = 2, msh%j_max-1
            do i = 2, msh%i_max-1
                uidx = mesh_index(i,msh%j_max,msh)
                lidx = mesh_index(i,1,msh)
                idx = mesh_index(i,j,msh)
                msh%x(idx) = (i-1)/(real(msh%i_max,dp)-1) * 5
                msh%y(idx) = (j-1)/(real(msh%j_max,dp)-1) * (msh%y(uidx)-msh%y(lidx)) + msh%y(lidx)
            end do
        end do
    end subroutine

end module
