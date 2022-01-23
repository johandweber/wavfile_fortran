This fortran module is based on the simple sound library (written in C)
for CSE 20211 by Douglas Thain and writes WAV audfio files.

Currently, only mono and stereo files with a sampling rate of 44100 samples/s and
a sample size of 16 bit per channel are supported.

Both the original library and this module are  made available under
the Creative Commons Attribution license.

[https://creativecommons.org/licenses/by/4.0/](https://creativecommons.org/licenses/by/4.0/)

For the complete documentation of the original library, see:

[http://www.nd.edu/~dthain/cse20211/fall2013/wavfile](http://www.nd.edu/~dthain/courses/cse20211/fall2013/wavfile)

An example for the usage in Fortran is provided in the file
wavfile_test.f90   .

All bugs are purely my own. 
