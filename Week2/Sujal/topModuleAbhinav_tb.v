`timescale 1ns / 1ps
 
module topModuleAbhinav_tb();

reg clk, reset, start_processing, inferMode;
reg [13:0] inferAddr;
wire finished_processing;
wire [7:0] convolvedPixel, inferResult;

topModuleAbhinav u0(.clk(clk), .reset(reset), .start_processing(start_processing),
    .inferMode(inferMode), .inferAddr(inferAddr), .finished_processing(finished_processing), 
    .inferResult(inferResult), .convolvedPixel(convolvedPixel));

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    reset = 1;
    start_processing = 0;
    inferMode = 0;
    inferAddr = 0;
    
    #10 
    reset = 0;
    start_processing = 1;
    #10
    start_processing = 0;
    #400











    $finish();
end
endmodule
