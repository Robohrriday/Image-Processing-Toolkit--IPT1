# import random
import serial          # import the module
import struct
from time import sleep
ComPort = serial.Serial('COM12') # open COM16, please change the com port name as per your device.
ComPort.baudrate = 9600 # set Baud rate to 9600
ComPort.bytesize = 8    # Number of data bits = 8
ComPort.parity   = 'N'  # No parity
ComPort.stopbits = 1    # Number of Stop bits = 1
arr = []
for i in range(16384):
    ComPort.flushOutput()
    ComPort.flushInput()
    x = input()
    x = int(x,2)
    print(f"{i}: {x}")
    if x>127:
        x = x - 256
    ot= ComPort.write(struct.pack('b', x))    
    sleep(0.0009)
print("completed transmission")
# for i in range(16384):
#     ComPort.flushOutput()
#     ComPort.flushInput()
#     # x = input()
#     # x = int(x,2)
#     # print(f"{i}: {x}")
#     # if x>127:
#     #     x = x - 256
#     ot= ComPort.read(struct.pack('b'))    
#     arr.append(ot)
#     # sleep(0.0009)
# print("completed transmission")