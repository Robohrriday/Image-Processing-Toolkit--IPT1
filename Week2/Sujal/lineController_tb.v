`timescale 1ns / 1ps

module lineController_tb();

reg clk;
reg reset;
reg [7:0] in_pixel_data;
reg in_pixel_data_valid;
wire [71:0] out_pixel_data; 
wire out_pixel_data_valid; 

lineController9 uut(.clk(clk),.reset(reset),.in_pixel_data(in_pixel_data), 
    .in_pixel_data_valid(in_pixel_data_valid), 
    .out_pixel_data(out_pixel_data), .out_pixel_data_valid(out_pixel_data_valid));

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    reset = 1;
    #10
    reset = 0;
    in_pixel_data = 8'b10101100;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11011010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01110100;
    in_pixel_data_valid = 0;
    #10
    in_pixel_data = 8'b01011101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00010111;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11101001;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10010011;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00100110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01001001;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10101101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10011001;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01100110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11100011;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10100100;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01001110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00101110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11001101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10011010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10101110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00010101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11001011;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01110010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00111001;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11101010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01010111;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10001011;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01011001;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11010011;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01111000;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00110111;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11000101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10100010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11100001;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00011011;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10010110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01011100;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10110001;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01110001;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00011110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10100111;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01001011;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10001001;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01111101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00110101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11011000;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00010110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11100100;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10011101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01101001;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11000111;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00001110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11101110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10110110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01010010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00100111;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10001100;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01100101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11010000;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00011010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10111010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01111100;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11101101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00101100;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10001110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01011110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11011001;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00011101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11110011;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10101011;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01101010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00111000;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11111001;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10000111;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00010101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11111010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01111011;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10010100;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01000111;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11010111;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00001010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11101111;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10001101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00110010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11010101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01010001;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10100001;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01110101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11100111;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00001001;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11000100;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10101001;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00101001;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10011111;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01101110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11110110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00110110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10010111;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01101011;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11101100;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00011111;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10011000;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01001010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11000010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00111101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10111101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01100111;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11110111;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00001011;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10010010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01010110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11001000;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00100011;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10111000;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01100010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11011100;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00001101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11101011;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10000000;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00111100;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11011111;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01101101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10011100;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01000101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10111011;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00110001;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11010110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01011111;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10100110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01110011;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11100010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00011000;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11010010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10011011;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01000000;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10110010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01110111;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11110100;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00000101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10001111;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01100100;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11011110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00101111;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10111100;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01010000;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11100110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10010101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00010000;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11000110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01111010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10011110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01011000;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10100000;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00101010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11110000;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00001111;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10000110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01101111;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11001001;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00000110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11111011;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10110011;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01101100;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11010100;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00111011;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10010000;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01001000;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11100101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00111110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10001010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01100011;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11001100;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00010011;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11111100;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10111111;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01011010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10000010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00110011;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11001110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01110001;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10001110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00001000;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11000001;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10101000;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01010011;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11101000;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00100010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10110101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01100110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10010100;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00101101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11011101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00011001;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11110010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10110001;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01001001;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10000101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01100001;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11001011;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00110000;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11101110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00010100;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10101010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01111001;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10011010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00100101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11010111;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00010010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11111110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10000001;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01101000;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11011011;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00101110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10100101;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01110110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11001111;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b00001010;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b11101100;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10010110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01000001;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b10101110;
    in_pixel_data_valid = 1;
    #10
    in_pixel_data = 8'b01111111;
    in_pixel_data_valid = 1;
    #10
    
   















    $finish();
end

endmodule
