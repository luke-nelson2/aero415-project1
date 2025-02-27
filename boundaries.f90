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

        function upper1(x) result(y)
            real(dp), intent(in) :: x
            real(dp) :: y
            if (x<1.5) then
                y = 1.0_dp
            else if (x<3.5) then
                y = 0.5_dp * (x-1.5_dp) + 1.0_dp
            else
                y = 2.0_dp
            end if
        end function upper1

        function lower(x) result(y)
            real(dp), intent(in) :: x
            real(dp) :: y
            if ((x>2) .and. (x<3)) then
                y = 0.17*sin((x-2)*pi)
            else
                y = 0.0_dp
            end if
        end function lower

        function lower1(x) result(y)
            real(dp), intent(in) :: x
            real(dp) :: y
            y = upper1(x) -1.0_dp
        end function lower1

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
