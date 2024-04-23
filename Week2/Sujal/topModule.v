`timescale 1ns / 1ps

module topModule(
    input clk,
    input reset,
    input [7:0] in_data, // The incoming pixel data
    input in_valid_data, // Signal that says that the incoming data is valid. You should write it.
    input ready_data, // Signal that says that data is ready to be read
    output [7:0] final_out_data
    );

.lineController u0(.clk(clk), .reset(reset), .in_pixel_data(in_data), .in_pixel_data_valid(in_valid_data), .out_pixel_data(final_out_data), .out_pixel_data_valid(ready_data));

// Store the data in a register
reg [8:0] line [128:0] image [128:0];







endmodule
