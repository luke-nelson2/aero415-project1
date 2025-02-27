Hello. This is my repository for my CFD project.

It's in Fortran and right now it just creates a mesh using Laplace's equation.
Maybe later I will make a full cfd repository

How to use:
1. Clone the repository 
2. Run make in bash
3. Navigate to the executable
4. Run in terminal ./project1_solve.exe with arguments: initial mesh file name, output mesh filename, i_max, j_max,iterations

Example Usage:

./project1_solve in.x out.x 101 21 1000

A data file will be created with your files

Files are currently formatted for Tecplot 360
