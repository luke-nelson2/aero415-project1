program Project1Solve
    use DefineMesh
    use SolveMesh
    implicit none
    character(len=40) :: arg1, arg2, arg3
    character(len=40) :: in_filename, out_filename
    integer :: iterations, ios
    type(Mesh) :: msh

    call get_command_argument(1, arg1)
    read(arg1, *, IOSTAT=ios) in_filename

    call get_command_argument(2, arg2)
    read(arg2, *, IOSTAT=ios) out_filename

    call get_command_argument(3, arg3)
    read(arg3, *, IOSTAT=ios) iterations
    if (ios /= 0) then
        print *, "Please enter valid integer number of iterations"
        stop
    end if

    call file_input(msh, in_filename)
    call solve_mesh(msh, iterations)
    ! call file_output(msh, out_filename)
    call file_output2(msh, out_filename)
end program Project1Solve