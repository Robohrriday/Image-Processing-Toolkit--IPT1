`timescale 1ns / 1ps

// This module reads 9 pixels from the bram and feeds it to the convolution module. It then reads the output of the convolution module and sends it to the top module

module topModuleAbhinav(
    input clk,
    input reset,
    input ready_to_recieve, // Signal that says that you are ready to recieve data. Start processing.
    output ready_to_send, // Signal that says that data is ready to be sent. It has done the convolution and now is ready to take the next input
    output [7:0] convolvedPixel
    );


reg [6:0] i, j; // Counters that index the image stored in the bram
reg [13:0] pixelCounter; 
reg [3:0] clkCycleCounter;

reg [71:0] input_to_convolution;

reg[7:0] out0, out1, out2, out3, out4, out5, out6, out7, out8;
reg [13:0] addr;
reg change_variable;

// Increasing i and j
always @(posedge clk) begin
    if(reset) begin
        i <= 0;
        j <= 0;
        change_variable <= 0;
        clkCycleCounter <= 0;
        pixelCounter <= 0;
    end
    else if(change_variable) begin // We're constantly checking to see if we should accept the incoming data. If we should, we start the FSM and wait for the data to be ready to be read
        pixelCounter <= pixelCounter + 1;
        clkCycleCounter <= 0;
        change_variable <= 0;
        if(i == 127) begin
            i <= 0;
            if(j == 127)
                j <= j + 1; 
        end
        else
            i <= i + 1;
    end
end

reg start_processing;
wire [7:0] dout;
blk_mem_gen_0 image(.clka(clk), .ena(1), .wea(0), .addra(addr), .dina(din), .douta(dout));

always @(posedge clk) begin
    case (clkCycleCounter)
        0 : begin
            if(ready_to_recieve) begin
                start_processing <= 1;
            end
            if(start_processing) begin
                if((i==0) && (j==0))
                    addr <= 0;
                else if((i==0) && (j==127))
                    addr <= 126;
                else if((i==127) && (j==0))
                    addr <= 16128;
                else if((i==127) && (j==127))
                    addr <= 16254;
                else if(i==0)
                    addr <= j-1;
                else if(i==127)
                    addr <= (128*(127-1))+j;
                else if(j==0)
                    addr <= (128*(i-1));
                else if(j==127)
                    addr <= (128*(i-1))+127-1;
                else
                    addr <= (128*(i-1))+j-1;

                out0 <= dout;
                start_processing <= 0;
                clkCycleCounter <= clkCycleCounter + 1;
            end
        end
        1:  begin
            if((i==0) && (j==0))
                addr <= 0;
            else if((i==0) && (j==127))
                addr <= 127;
            else if((i==127) && (j==0))
                addr <= 16128;
            else if((i==127) && (j==127))
                addr <= 16255;
            else if(i==0)
                addr <= j;
            else if(i==127)
                addr <= (128*(127-1))+j;
            else if(j==0)
                addr <= (128*(i-1));
            else if(j==127)
                addr <= (128*(i-1))+127;
            else
                addr <= (128*(i-1))+j;
            
            out1 <= dout;
            clkCycleCounter <= clkCycleCounter + 1;
        end
        2:  begin
            if((i==0) && (j==0))
                addr <= 1;
            else if((i==0) && (j==127))
                addr <= 127;
            else if((i==127) && (j==0))
                addr <= 16129;
            else if((i==127) && (j==127))
                addr <= 16255;
            else if(i==0)
                addr <= j+1;
            else if(i==127)
                addr <= (128*(127-1))+j+1;
            else if(j==0)
                addr <= (128*(i-1))+1;
            else if(j==127)
                addr <= (128*(i-1))+127;
            else
                addr <= (128*(i-1))+j+1;

            out2 <= dout;
            clkCycleCounter <= clkCycleCounter + 1;
        end
        3:  begin
            if((i==0) && (j==0))
                addr <= 0;
            else if((i==0) && (j==127))
                addr <= 126;
            else if((i==127) && (j==0))
                addr <= 16256;
            else if((i==127) && (j==127))
                addr <= 16382;
            else if(i==0)
                addr <= j-1;
            else if(i==127)
                addr <= (128*(127))+j-1;
            else if(j==0)
                addr <= (128*(i));
            else if(j==127)
                addr <= (128*(i))+127-1;
            else
                addr <= (128*(i))+j-1;

            out3 <= dout;
            clkCycleCounter <= clkCycleCounter + 1;
        end
        4:  begin
            if((i==0) && (j==0))
                addr <= 0;
            else if((i==0) && (j==127))
                addr <= 127;
            else if((i==127) && (j==0))
                addr <= 16256;
            else if((i==127) && (j==127))
                addr <= 16383;
            else if(i==0)
                addr <= j;
            else if(i==127)
                addr <= (128*(127))+j;
            else if(j==0)
                addr <= (128*(i));
            else if(j==127)
                addr <= (128*(i))+127;
            else
                addr <= (128*(i))+j;

            out4 <= dout;
            clkCycleCounter <= clkCycleCounter + 1;
        end
        5:  begin
            if((i==0) && (j==0))
                addr <= 1;
            else if((i==0) && (j==127))
                addr <= 127;
            else if((i==127) && (j==0))
                addr <= 16257;
            else if((i==127) && (j==127))
                addr <= 16383;
            else if(i==0)
                addr <= j+1;
            else if(i==127)
                addr <= (128*(127))+j+1;
            else if(j==0)
                addr <= (128*(i))+1;
            else if(j==127)
                addr <= (128*(i))+127;
            else
                addr <= (128*(i))+j+1;

            out5 <= dout;
            clkCycleCounter <= clkCycleCounter + 1;
        end
        6:  begin 
            if((i==0) && (j==0))
                addr <= 128;
            else if((i==0) && (j==127))
                addr <= 254;
            else if((i==127) && (j==0))
                addr <= 16256;
            else if((i==127) && (j==127))
                addr <= 16382;
            else if(i==0)
                addr <= 128+j-1;
            else if(i==127)
                addr <= (128*(127))+j-1;
            else if(j==0)
                addr <= (128*(i+1));
            else if(j==127)
                addr <= (128*(i+1))+127-1;
            else
                addr <= (128*(i+1))+j-1;

            out6 <= dout;
            clkCycleCounter <= clkCycleCounter + 1;
        end
        7:  begin 
            if((i==0) && (j==0))
                addr <= 128;
            else if((i==0) && (j==127))
                addr <= 255;
            else if((i==127) && (j==0))
                addr <= 16256;
            else if((i==127) && (j==127))
                addr <= 16383;
            else if(i==0)
                addr <= 128+j;
            else if(i==127)
                addr <= (128*(127))+j;
            else if(j==0)
                addr <= (128*(i+1));
            else if(j==127)
                addr <= (128*(i+1))+127;
            else
                addr <= (128*(i+1))+j;

            out7 <= dout;
            clkCycleCounter <= clkCycleCounter + 1;
        end
        8:  begin 
            if((i==0) && (j==0))
                addr <= 129;
            else if((i==0) && (j==127))
                addr <= 255;
            else if((i==127) && (j==0))
                addr <= 16257;
            else if((i==127) && (j==127))
                addr <= 16383;
            else if(i==0)
                addr <= 128+j+1;
            else if(i==127)
                addr <= (128*(127))+j+1;
            else if(j==0)
                addr <= (128*(i+1))+1;
            else if(j==127)
                addr <= (128*(i+1))+127;
            else
                addr <= (128*(i+1))+j+1;

            out8 <= dout;
            clkCycleCounter <= clkCycleCounter + 1;
            change_variable <= 1;
        end
        9:  begin 
            input_to_convolution <= {out0, out1, out2, out3, out4, out5, out6, out7, out8};
        end
    endcase
end

convolution C(.clk(clk), .in_pixels_data(input_to_convolution), .in_pixels_valid(counter == 9), .out_pixel_data(convolvedPixel), .out_pixel_data_ready(ready_to_send));

wire [7:0] random;
blk_mem_gen_0 results(.clka(clk), .ena(1), .wea(ready_to_send), .addra((128*i)+j), .dina(convolvedPixel), .douta(random));


endmodule

// // Assigning of input data
// always @(posedge clk) begin

//     if((i == 0) && (j == 0))
//         input_to_convolution <= {out1, out2, out3, out4, out5, out6, out7, out8, out9};
//         input_to_convolution <= {bram[0], bram[0], bram[1], bram[0], bram[0], bram[1], bram[128], bram[128], bram[129]};
//     else if((i == 0) && (j == 127))
//         input_to_convolution <= {bram[126], bram[127], bram[127], bram[126], bram[127], bram[127], bram[254], bram[255], bram[255]};
//     else if((i == 127) && (j == 0))
//         input_to_convolution <= {bram[16128], bram[16128], bram[16129], bram[16256], bram[16256], bram[16257], bram[16256], bram[16256], bram[16257]};
//     else if((i == 127) && (j == 127))
//         input_to_convolution <= {bram[16254], bram[16255], bram[16255], bram[16382], bram[16383], bram[16383], bram[16382], bram[16383], bram[16383]};
//     else if(i == 0)
//         input_to_convolution <= {bram[j-1], bram[j], bram[j+1], bram[j-1], bram[j], bram[j+1], bram[(j-1)+128], bram[j+128], bram[(j+1)+128]};
//     else if(i == 127)
//         input_to_convolution <= {bram[(128*(127-1))+j-1], bram[(128*(127-1))+j], bram[(128*(127-1))+j+1], bram[(128*(127)+j-1)], bram[(128*(127)+j)], bram[(128*(127)+j+1)], bram[(128*(127))+j-1], bram[(128*(127))+j], bram[(128*(127))+j+1]};
//     else if(j == 0)
//         input_to_convolution <= {bram[(128*(i-1))], bram[(128*(i-1))], bram[(128*(i-1))+1], bram[128*(i)], bram[128*(i)], bram[128*(i)+1], bram[(128*(i+1))], bram[(128*(i+1))], bram[(128*(i+1))+1]};
//     else if(j == 127)
//         input_to_convolution <= {bram[(128*(i-1))+127-1], bram[(128*(i-1))+127], bram[(128*(i-1))+127], bram[(128*(i)+127-1)], bram[(128*(i)+127)], bram[(128*(i)+127)], bram[(128*(i+1)+127-1)], bram[(128*(i+1)+127)], bram[(128*(i+1)+127)]};
//     else
//         input_to_convolution <= {bram[(128*(i-1))+j-1], bram[(128*(i-1))+j], bram[(128*(i-1))+j+1], bram[(128*(i)+j-1)], bram[(128*(i)+j)], bram[(128*(i)+j+1)], bram[(128*(i+1))+j-1], bram[(128*(i+1))+j], bram[(128*(i+1))+j+1]};
// end