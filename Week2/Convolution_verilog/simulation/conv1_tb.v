`timescale 1ns / 1ps

module conv1_tb();
reg clk; 
reg rst; 
reg infer;
reg [3:0] addr;
wire [11:0] out;

conv2 uut (clk, rst, infer, addr, out);

initial begin
    clk = 0;  
    forever begin
    #1 clk = ~clk;
    end
end

initial begin
    rst = 1; infer = 0; addr = 0;
    #3;
    rst = 0;
    #10;
    rst = 0; addr = 1;
    #900;
    infer = 1; rst = 0; addr = 0;
    #10;
    infer = 1; rst = 0; addr = 1;
    #10;
    infer = 1; rst = 0; addr = 2;
    #10;
    infer = 1; rst = 0; addr = 3;
    #10;
    infer = 1; rst = 0; addr = 4;
    #10;
    infer = 1; rst = 0; addr = 5;
    #10;
    infer = 1; rst = 0; addr = 6;
    #10;
    infer = 1; rst = 0; addr = 7;
    #10;
    infer = 1; rst = 0; addr = 8;
    #10;
    $finish();
end
endmodule
