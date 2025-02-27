# Directories
SRCDIR = src
BUILDDIR = build
BINDIR = bin
# Compiler and flags
FC = gfortran
FFLAGS = -O2 -J$(BUILDDIR) -I$(BUILDDIR)

# Source files for modules and main program
MODULES = definemesh.f90 boundaries.f90 meshinitialization.f90 solvemesh.f90
MODULE_SRCS = $(patsubst %, $(SRCDIR)/%, $(MODULES))
PROGRAM = project1_solve.f90
PROGRAM_SRC = $(SRCDIR)/$(PROGRAM)

# Object files: for modules, use the same base names; for the main program, likewise.
MODULE_OBJS = $(patsubst %.f90,$(BUILDDIR)/%.o,$(MODULES))
PROGRAM_OBJ = $(BUILDDIR)/project1_solve.o

# Final executable
EXEC = project1_solve
BINEXEC = $(BINDIR)/$(EXEC)

# Default target
all: $(BINEXEC)

# Ensure bin and build directories exist
$(BINDIR):
	mkdir -p $(BINDIR)

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

# Linking: combine module and main program object files to produce the executable.
$(BINEXEC): $(MODULE_OBJS) $(PROGRAM_OBJ) | $(BINDIR)
	$(FC) $(FFLAGS) -o $(BINEXEC) $(MODULE_OBJS) $(PROGRAM_OBJ)

# Generic pattern rule for compiling .f90 files into .o files (for modules)
$(BUILDDIR)/%.o: $(SRCDIR)/%.f90 | $(BUILDDIR)
	$(FC) $(FFLAGS) -c $< -o $@

# Explicit rule for the main program to ensure its dependencies (module object files) are built first.
$(BUILDDIR)/project1_solve.o: $(SRCDIR)/project1_solve.f90 $(MODULE_OBJS) | $(BUILDDIR)
	$(FC) $(FFLAGS) -c $< -o $@

# Clean up generated files and directories.
clean:
	rm -rf $(BUILDDIR) $(BINDIR)

.PHONY: all clean
