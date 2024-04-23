Sujal's Attempts
================

**lineBuffer.v** : Module that stores all the incoming pixel data in a line buffer. It keeps its 3 pixels as output ready to be read by the external driver. (PREFETCHING)

**lineController.v** : This module controls reading and writing of the line buffers. It also controls which line buffer is which line in the image. It always has 9 pixels ready to be read by the convolution module. It also has a FSM to control the reading of the line buffers. It only reads the line buffers when there are enough pixels in the line buffers. This is to ensure that we have enough pixels to read from the line buffers.

**lineController9.v** : This module controls reading and writing of a smaller version of the line buffer to test the reading and writing mechanisms.

**convolution.v** : 3 line buffer data will be fed to this module and it will perform convolution operation on it and output a single pixel data

**topModuleAbhinav** : The top module that tried to incorporate a complete pipeline of line buffer and convolution module and run its implementation on the FPGA. It was not successful.
