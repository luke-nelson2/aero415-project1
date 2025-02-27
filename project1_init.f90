program Project1Init
    use MeshInitialziation
    use Boundaries
    use DefineMesh
    implicit none


    
    real(dp) :: y_lower,y_upper
    real(dp) :: x_left, x_right
    integer :: num_args, ios
    integer :: i_max, j_max
    type(Mesh) :: m1

    ! 2 arguments, i_max and j_max
    character(len=40) :: arg1, arg2, arg3
    character(len=40) :: file_name
    num_args = command_argument_count()
    if (num_args /= 3) then
        print *, "Please enter 2 integers and a filename: i_max, j_max, file_name.csv"
        stop
    end if

    call get_command_argument(1, arg1)
    read(arg1, *, IOSTAT=ios) i_max
    if (ios /= 0) then
        print *, "Error: First argument is not a valid integer!"
        stop
    end if

    call get_command_argument(2, arg2)
    read(arg2, *, IOSTAT=ios) j_max
    if (ios /= 0) then
        print *, "Error: Second argument is not a valid integer!"
        stop
    end if

    call get_command_argument(3, arg3)
    read(arg3, *, IOSTAT=ios) file_name
    
    y_lower = 0.0_dp
    y_upper = 1.0_dp
    x_left = 0.0_dp
    x_right = 5.0_dp

    call define_mesh_shape(m1, i_max, j_max)
    call apply_leftright(m1,left,y_lower,y_upper,0)
    call apply_leftright(m1,right,y_lower,y_upper,1)
    call apply_upperlower(m1,lower,x_left, x_right,0)
    call apply_upperlower(m1,upper,x_left, x_right,1)
    call apply_algebraic_center(m1)
    call file_output(m1,file_name)

end program