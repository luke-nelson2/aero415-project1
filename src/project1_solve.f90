program Project1Solve
    use DefineMesh
    use SolveMesh
    use Boundaries
    use MeshInitialization

    implicit none
    character(len=40) :: arg1, arg2, arg3, arg4, arg5
    character(len=40) :: init_filename, out_filename
    integer :: iterations, ios
    type(Mesh) :: init_msh
    real(dp) :: y_lower, y_upper, x_left, x_right
    integer :: i_max, j_max, status
    call execute_command_line("mkdir data", wait = .true., exitstat = status)
    if (status /= 0) then
        print *, "Error creating directory. Exit status:", status
    end if

    ! 5 arguments for the command line
    ! initial mesh file, solved mesh file, i_max, j_max, num_iterations
    call get_command_argument(1, arg1)
    read(arg1, *, IOSTAT=ios) init_filename

    call get_command_argument(2, arg2)
    read(arg2, *, IOSTAT=ios) out_filename

    call get_command_argument(3, arg3)
    read(arg3, *, IOSTAT=ios) i_max

    call get_command_argument(4, arg4)
    read(arg4, *, IOSTAT=ios) j_max

    call get_command_argument(5, arg5)
    read(arg5, *, IOSTAT=ios) iterations
    y_lower = 0.0_dp
    y_upper = 1.0_dp
    x_left = 0.0_dp
    x_right = 5.0_dp
    call define_mesh_shape(init_msh, i_max, j_max)
    call apply_leftright(init_msh,left,y_lower,y_upper,0)
    call apply_leftright(init_msh,right,y_lower,y_upper,1)
    call apply_upperlower(init_msh,lower,x_left,x_right,0)
    call apply_upperlower(init_msh,upper,x_left,x_right,1)
    call apply_algebraic_center(init_msh)
    call file_output2(init_msh,"data/" // init_filename)
    
    call solve_mesh(init_msh, iterations)
    ! call file_output(msh, out_filename)
    call file_output2(init_msh,"data/" // out_filename)
end program Project1Solve
