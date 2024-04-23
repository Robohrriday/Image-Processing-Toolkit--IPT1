`timescale 1ns / 1ps

module Convolution_tb();

reg clk;
reg [71:0] in_pixel_data; 
reg in_pixel_valid;
wire [7:0] out_pixel_data; 
wire out_pixel_valid;

convolutionOperation uut(.clk(clk),.in_pixel_data(in_pixel_data), .in_pixel_valid(in_pixel_valid), 
    .out_pixel_data(out_pixel_data), .out_pixel_valid(out_pixel_valid));

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    
    in_pixel_data = 72'b111111111111111100000000000000000000000000000000000000000000000000000000;
    in_pixel_valid = 1;
    #10
    in_pixel_valid = 0;
    // in_pixel_data = 72'b110000001100000011000000110000001100000011000000110000001100000011000000;
    // in_pixel_valid = 0;
    // #10
    // in_pixel_data = 72'b111100001111000011110000111100001111000011110000111100001111000011110000;
    // in_pixel_valid = 1;
    // #10
    // in_pixel_data = 72'b
    // in_pixel_valid = 1;





    #50









    $finish();
end

endmodule
