# please adapt the variables of this Makefile to fit your needs

FORTRAN = gfortran
OBJEXT  = .o
EXEEXT  =
MODEXT  = .mod
WAVEXT  = .wav
NOCOMPILE = -c
MAKEEXE = -o
REMOVE  = rm

WAVFILE_TEST = wavfile_test$(EXEEXT)
WAVFILE_OBJ = wavfile$(OBJEXT)

DEBUG = -Wall -Wextra -fcheck=all -fbacktrace -O0 -g3

WAVFILE_TEST: $(WAVFILE_OBJ)
	$(FORTRAN) $(DEBUG) $(MAKEEXE) $(WAVFILE_TEST) wavfile_test.f90 $(WAVFILE_OBJ)

$(WAVFILE_OBJ): wavfile.f90
	$(FORTRAN) $(DEBUG) $(NOCOMPILE) wavfile.f90

clean:
	$(REMOVE) *$(OBJEXT) *$(MODEXT) *$(WAVEXT) wavfile_test$(EXEXT)

