`timescale  1ns / 1ps

// 3 line buffer data will be fed to this module and it will perform convolution operation on it and output a single pixel data
module convolution(
    input clk,
    input [71:0] in_pixels_data,  // 9 pixels data
    input in_pixels_valid,
    output reg [7:0] out_pixel_data, // A single pixel data
    output reg out_pixel_data_ready       // A valid signal that says data is ready to be read
);

integer i;
reg [7:0] kernel [8:0];  // 3x3 kernel
reg [11:0] convAns[8:0]; // 9 convolution results, which can go maximum for 12 bits for this kernel. (255 * 9 = 2295)
reg [15:0] tempSum; // Temporary sum of the convolution results
reg [15:0] sum; // Sum of the convolution results
reg convValid; // Convolution valid signal
reg sumValid; // Sum valid signal



initial begin
    kernel[0] <= 1; kernel[1] <= 1; kernel[2] <= 1; kernel[3] <= 1; kernel[4] <= 1; kernel[5] <= 1; kernel[6] <= 1; kernel[7] <= 1; kernel[8] <= 1;
end

// Logic to calculate the convolution results
always @(posedge clk) begin
    for(i=0; i<9; i=i+1) begin
        convAns[i] = kernel[i] * in_pixels_data[i*8 +: 8]; // This syntax means 
    end

    convValid <= in_pixels_valid;
end

always @(*) begin // This will behave like a combinational block which we want because we want to calculate the convolution results as soon as the data is available
    tempSum = 0;
    for(i=0; i<9; i=i+1) begin
        tempSum = tempSum + convAns[i];
    end
end

always @(posedge clk) begin // This will behave like a sequential block which we want because we want to output the data only when the data is valid
    sum <= tempSum;

    sumValid <= convValid;
end

always @(posedge clk) begin
    out_pixel_data <= sum/9;
    out_pixel_data_ready <= sumValid;
end













endmodule