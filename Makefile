FC = gfortran
FFLAGS = -Wall -Wextra -O3
EXE1 = project1_init.exe 
EXE2 = project1_solve.exe 
src1 = define_mesh.f90 mesh_init.f90 boundaries.f90 project1_init.f90
src2 = define_mesh.f90 solve_mesh.f90 project1_solve.f90
OBJ1 = $(src1:.f90=.o)
OBJ2 = $(src2:.f90=.o)
all: $(EXE1) $(EXE2)
$(EXE1): $(OBJ1)
	$(FC) $(FFLAGS) -o $(EXE1) $(OBJ1)

$(EXE2): $(OBJ2)
	$(FC) $(FFLAGS) -o $(EXE2) $(OBJ2)
%.o: %.f90
	$(FC) $(FFLAGS) -c $< -o $@
clean:
	rm -f $(OBJ1) $(OBJ2) $(EXE1) $(EXE2)
