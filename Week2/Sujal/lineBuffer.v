`timescale 1ns / 1ps

//parameter img_h = 128;
//parameter img_w = 128;

// Module that stores all the incoming pixel data in a line buffer. It keeps its 3 pixels as output ready to be read by the external driver. (PREFETCHING)

module lineBuffer (
    input clk,
    input reset,
    input [7:0] incoming_pixel_data, // The incoming pixel data
    input incoming_pixel_data_valid, // Signal that says that the incoming data is valid. You should write it.
    input going_to_read_data, // Signal that says that data is ready to be read
    output [23:0] output_pixels_data // Our buffer will constantly read 3 pixels at a time // instead of [7:0] out_data [2:0] as in verilog, we cant have multidimensional arrays in module input, output ports.
);

reg [7:0] line [127:0];
reg [6:0] wrPtr; // You only need a 7 bit pointer to point to 128 locations (log2(128) = 7)
reg [6:0] rdPtr; 

// Logic for writing data
always @(posedge clk) begin
    if(incoming_pixel_data_valid)
        line[wrPtr] <= incoming_pixel_data;
end

// Logic for shifting the write pointer to different memory locations
always @(posedge clk) begin
    if(reset)
        wrPtr <= 0;
    else if(incoming_pixel_data_valid) // We're constantly checking to see if we should accept the incoming data. If we should, we increment the write pointer. The data is written to the memory location pointed by the write pointer in the above always block
        if(wrPtr == 127)
            wrPtr <= 0;
        else
            wrPtr <= wrPtr + 1;
end

assign output_pixels_data = {line[rdPtr+2], line[rdPtr+1], line[rdPtr]}; 

// Logic for shifting the read pointer
always @(posedge clk) begin
    if(reset)
        rdPtr <= 0;
    else if(going_to_read_data)   // We're constantly checking to see if the data is ready to be read by the external driver, if yes, we increment the read pointer. The data is read from the memory location pointed by the read pointer in the above assign block
        if(rdPtr == 127)
            rdPtr <= 0;
        else
            rdPtr <= rdPtr + 1;
end


endmodule