! This fortran module is based on the simple sound library (written in C)
! for CSE 20211 by Douglas Thain (dthain@nd.edu).
! Both original library and this module are  made available under
! the Creative Commons Attribution license.
! https://creativecommons.org/licenses/by/4.0/
! For complete documentation of the original library, see:
! http://www.nd.edu/~dthain/courses/cse20211/fall2013/wavfile

! All bugs are my own. 


module mod_wavfile
  use iso_fortran_env
  implicit none

  type wavfile_header
     character(kind=1, len=4 )       :: riff_tag
     integer(int32)                  :: riff_length
     character(kind=1, len=4)        :: wave_tag
     character(kind=1, len=4 )       :: fmt_tag 
     integer(int32)                  :: fmt_length
     integer(int16)                  :: audio_format
     integer(int16)                  :: num_channels
     integer(int32)                  :: sample_rate
     integer(int32)                  :: byte_rate
     integer(int16)                  :: block_align
     integer(int16)                  :: bits_per_sample
     character(kind=1, len=4)        :: data_tag
     integer(int32)                  :: data_length
  end type wavfile_header

  type wavfile
     type(wavfile_header)            :: header
     integer                         :: payload_length
     integer                         :: unit = 100
     contains
       procedure, pass(self)         :: wf_write
       procedure, pass(self)         :: wf_close
  end type wavfile
  

  integer(int32), parameter          :: SAMPLES_PER_SECOND = 44100_int32
  integer(int32), parameter          :: HEADER_SIZE = 44_int32
  integer(int16), parameter          :: BITS_PER_SAMPLE = 16_int16
  real(real64),   parameter          :: c_pi = 3.14159265359_real64
  
  interface wavfile
     module procedure wavfile_open
  end interface wavfile
  
contains
  
  type(wavfile) function wavfile_open(filename) result(self)

    implicit none
    
    character(len=*), intent(in)     :: filename
    type(wavfile_header)             :: header

    self % header % riff_tag         = 'RIFF'
    self % header % wave_tag         = 'WAVE'
    self % header % fmt_tag          = 'fmt '         ! Leerzeichen notwendig
    self % header % data_tag         = 'data'
    self % header % riff_length      =  0_int32
    self % header % fmt_length       =  16_int32
    self % header % audio_format     =  1_int16
    self % header % num_channels     =  1_int16
    self % header % sample_rate      =  SAMPLES_PER_SECOND
    self % header % bits_per_sample  =  BITS_PER_SAMPLE
    self % header % block_align      =  BITS_PER_SAMPLE/8
    self % header % byte_rate        =  self % header % sample_rate * (self % header % bits_per_sample / 8_int16)
    self % header % data_length      =  0_int32

    open (newunit = self % unit, file=filename,  form='unformatted',  access = 'stream')
    write(self % unit) header

    self % payload_length = 0_int32
    
  end function wavfile_open

  subroutine wf_write(self, data, length)

    implicit none

    class(wavfile)                            :: self
    integer(int16), dimension(:), intent(in)  :: data
    integer(int32)                            :: length
 
    write(self % unit) data(1:length)
    self % payload_length=self % payload_length + 2 * length

  end subroutine wf_write

  subroutine wf_close(self)

    implicit none
    
    class(wavfile)                  :: self

    self % header % riff_tag         = 'RIFF'
    self % header % wave_tag         = 'WAVE'
    self % header % fmt_tag          = 'fmt '         ! Leerzeichen notwendig
    self % header % data_tag         = 'data'

    self % header % riff_length      =  HEADER_SIZE + self % payload_length - 8
    self % header % fmt_length       =  16_int32
    self % header % audio_format     =  1_int16
    self % header % num_channels     =  1_int16
    self % header % sample_rate      =  SAMPLES_PER_SECOND
    self % header % bits_per_sample  =  BITS_PER_SAMPLE
    self % header % block_align      =  BITS_PER_SAMPLE / 8
    self % header % byte_rate        =  self % header % sample_rate*(self % header % bits_per_sample / 8_int16)
    self % header % data_length      =  self % payload_length
    
    rewind(unit = self % unit)

    write(self % unit) self % header
    
    close(self % unit)
  end subroutine wf_close
  
end module mod_wavfile
