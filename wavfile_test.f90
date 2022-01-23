program wavfile_test
  
  use mod_wavfile
  
  implicit none
  
  real(real32), parameter                     :: frequency1 = 440
  real(real32), parameter                     :: frequency2 = 432
  integer(int16), dimension(:,:), allocatable :: payload_stereo, payload_mono
  integer                                     :: counter
  real(real64)                                :: t             ! time
  type(wavfile)                               :: my_wav_stereo, my_wav_mono

  allocate(payload_stereo(1:2,0:10*SAMPLES_PER_SECOND))
  allocate(payload_mono(1:1,0:10*SAMPLES_PER_SECOND))
  

  do counter=0,10*SAMPLES_PER_SECOND
     t =real(counter,real32)/SAMPLES_PER_SECOND
     payload_stereo(1,counter) = int(20000*sin(2*c_pi*frequency1*t), kind=int16)
     payload_stereo(2,counter) = int(20000*sin(2*c_pi*frequency2*t), kind=int16)

     payload_mono(1,counter) = int(20000*sin(2*c_pi*frequency1*t), kind=int16)     
  enddo


  my_wav_stereo =  wavfile('test_stereo.wav', stereo = .true.)
  call my_wav_stereo % wf_write(payload_stereo, 2*SAMPLES_PER_SECOND+1 )
  call my_wav_stereo % wf_close

  my_wav_mono =  wavfile('test_mono.wav')
  call my_wav_mono % wf_write(payload_mono, 2*SAMPLES_PER_SECOND+1 )
  call my_wav_mono % wf_close
  
  
end program wavfile_test
