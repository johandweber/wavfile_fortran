program wavfile_test
  
  use mod_wavfile
  
  implicit none
  
  real(real32), parameter                   :: frequency1 = 440
  real(real32), parameter                   :: frequency2 = 220
  integer(int16), dimension(:), allocatable :: payload
  integer                                   :: counter
  real(real64)                              :: t             ! time
  type(wavfile)                             :: my_wav

  allocate(payload(0:10*SAMPLES_PER_SECOND))

  do counter=0,10*SAMPLES_PER_SECOND
     t =real(counter,real32)/SAMPLES_PER_SECOND
     payload(counter) = int(20000*sin(2*c_pi*frequency1*t), kind=int16) + &
                        int(10000*sin(2*c_pi*frequency2*t), kind=int16) 
  enddo


  my_wav =  wavfile('test.wav')
  
  call my_wav % wf_write(payload, 2*SAMPLES_PER_SECOND+1 )

  call my_wav % wf_close
  
end program wavfile_test
