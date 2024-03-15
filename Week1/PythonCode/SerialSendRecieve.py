# Python
import serial           # import the module
import struct
import time

ComPort = serial.Serial('COM16') # open COM24
ComPort.baudrate = 9600 # set Baud rate to 9600
ComPort.bytesize = 8    # Number of data bits = 8
ComPort.parity   = 'N'  # No parity
ComPort.stopbits = 1    # Number of Stop bits = 1

# print("Enter 1 eight bit numbers.\nThe sum will be printed")
# print("Press 'q' to exit infinite loop at any time")

for i in range(31):
    x=(input(f"Enter number {i+1}: "))
    ComPort.flushOutput()
    ComPort.flushInput()
    if x == 'add':
        break
    x = int(x)
    y = x
    if x>127:
        x = x - 256
    ot= ComPort.write(struct.pack('b', x))    #for sending data to FPGA
ComPort.flushOutput()
ComPort.flushInput()
it=(ComPort.read(size=1))                #for receiving data from FPGA
print(f"Sum = {int.from_bytes(it, byteorder='little')}")
ComPort.close()         # Close the Com port