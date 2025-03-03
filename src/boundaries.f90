module Boundaries
    use DefineMesh, only : dp
    implicit none
    private :: dp
    real(dp), parameter :: pi = 3.141592653589793_dp
    contains
        function upper(x) result(y)
            real(dp), intent(in) :: x
            ! integer, intent(in) :: i,j
            real(dp) :: y
            if ((x>2) .and. (x<3)) then
                y = 1 - 0.17*sin((x-2)*pi)
            else
                y = 1.0_dp
            end if
        end function upper

        function lower(x) result(y)
            real(dp), intent(in) :: x
            real(dp) :: y
            if ((x>2) .and. (x<3)) then
                y = 0.17*sin((x-2)*pi)
            else
                y = 0.0_dp
            end if
        end function lower

        function left(y) result(x)
            real(dp), intent(in) :: y
            real(dp) :: x
            x = 0.0_dp
        end function left

        function right(y) result(x)
            real(dp), intent(in) :: y
            real(dp) :: x
            x = 5.0_dp
        end function right

end module Boundaries
