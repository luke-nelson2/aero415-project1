module SolveMesh
    use DefineMesh
    implicit none
    private
    public :: solve_mesh
contains
    subroutine solve_mesh(msh,iterations)
        type(Mesh), intent(inout) :: msh
        integer, intent(in) :: iterations
        real(dp), dimension(8,msh%num_points) :: grid_coeffs
        real(dp), dimension(8,2) :: point_vals
        integer :: n,i,j,idx
        point_vals = 0.0
        do n=1, iterations
            call get_grid_coeffs(msh,grid_coeffs)
            do j=2,msh%j_max-1
                do i=2,msh%i_max-1
                    call get_surrounding_points(i,j,msh,point_vals)
                    idx = mesh_index(i,j,msh)
                    msh%x(idx) = dot_product(grid_coeffs(:,idx),point_vals(:,1))
                    msh%y(idx) = dot_product(grid_coeffs(:,idx),point_vals(:,2))
                end do
            end do
        end do

    end subroutine solve_mesh

    ! takes surrounding x and y values as paramter
    ! left, right, lower, upper
    ! returns coefficients for each surrounding point
    function abg(x_vals, y_vals, d_zeta, d_eta) result(coeffs)
        real(dp), intent(in), dimension(4) :: x_vals, y_vals
        real(dp), intent(in) :: d_zeta, d_eta
        real(dp), dimension(8) :: coeffs
        real(dp) :: alpha, beta, gamma
        real(dp) :: a, b, c
        alpha = ((x_vals(4)-x_vals(3))**2 + (y_vals(4)-y_vals(3))**2)/4.0_dp/d_eta**2
        beta = ((x_vals(2)-x_vals(1))*(x_vals(4)-x_vals(3)) + &
        (y_vals(2)-y_vals(1))*(y_vals(4)-y_vals(3)))/4/d_zeta/d_eta
        gamma = ((x_vals(2)-x_vals(1))**2 + (y_vals(2)-y_vals(1))**2)/4.0_dp/d_zeta**2
        
        a = alpha / d_zeta**2
        b = beta / 2.0_dp / d_zeta / d_eta
        c = gamma / d_eta**2


        coeffs = (/-b,c,b,a,a,b,c,-b/) / (2*(alpha/d_zeta**2 + gamma/d_eta**2))

    end function abg

    subroutine get_grid_coeffs(msh,grid_coeffs)
        type(Mesh), intent(in) :: msh
        real(dp), intent(out), dimension(8,msh%num_points) :: grid_coeffs
        integer :: i,j,left,right,lower,upper
        real(dp), dimension(4) :: x_vals, y_vals
        
        do j=2, msh%j_max-1
            do i=2, msh%i_max-1
                left = mesh_index(i-1,j,msh)
                right = mesh_index(i+1,j,msh)
                lower = mesh_index(i,j-1,msh)
                upper = mesh_index(i,j+1,msh)
                x_vals = (/msh%x(left), msh%x(right), msh%x(lower), msh%x(upper)/)
                y_vals = (/msh%y(left), msh%y(right), msh%y(lower), msh%y(upper)/)
                grid_coeffs(:,mesh_index(i,j,msh)) = abg(x_vals,y_vals,msh%d_zeta,msh%d_eta)
            end do
        end do
    end subroutine get_grid_coeffs

    ! returns an 2d array with x and y values of surrounding points
    subroutine get_surrounding_points(i,j,msh,vals)
        type(Mesh), intent(in) :: msh
        integer, intent(in) :: i,j
        real(dp), intent(out), dimension(8,2) :: vals
        integer :: di,dj,k,idx
        k = 1
        do dj=-1,1
            do di=-1,1
                if (di == 0 .and. dj == 0) cycle
                idx = mesh_index(i+di,j+dj,msh)
                vals(k,1) = msh%x(idx)
                vals(k,2) = msh%y(idx)
                k = k+1
            end do
        end do
    end subroutine get_surrounding_points
end module SolveMesh