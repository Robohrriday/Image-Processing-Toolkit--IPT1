`timescale 1ns / 1ps

// This module reads 9 pixels from the bram and feeds it to the convolution module. It then reads the output of the convolution module and sends it to the top module

module topModuleAbhinav(
    input clk,
    input reset,
    input inferMode,
    input [13:0] inferAddr,
    input start_processing, // Signal that says that you are ready to recieve data. Start processing.
    output [7:0] convolvedPixel,
    output [7:0] inferResult
    // output reg finished_processing // Signal that says that data is ready to be sent. It has done the convolution and now is ready to take the next input
    );

reg finished_processing;
reg start_FSM;
reg [3:0] clkCycleCounter;
reg [13:0] pixelCounter;

initial begin
    finished_processing <= 0;
    start_FSM = 0;
    clkCycleCounter = 0;
    pixelCounter = 0;
end

always @(posedge clk) begin
    if(reset) begin
        start_FSM <= 0;
    end
    else if(start_processing)
        start_FSM <= 1;
end

reg [6:0] i, j; // Counters that index the image stored in the bram
reg change_variable;
always @(posedge clk) begin
    if(reset) begin
        i <= 0;
        j <= 0;
    end
    else if(change_variable) begin
        j <= j + 1;
        if(j == 127) begin
            j <= 0;
            i <= i + 1;
        end
    end
end


reg [13:0] addr;
wire [7:0] dout;
blk_mem_gen_0 image(.clka(clk), .ena(1), .wea(0), .addra(addr), .dina(din), .douta(dout));



reg addr0_ready, addr1_ready, addr2_ready, addr3_ready, addr4_ready, addr5_ready, addr6_ready, addr7_ready, addr8_ready;
always @(*) begin // Always checking. If start_FSM signal is given just after a posedge. This always block already presets the address.
    if(start_FSM) begin
        case (clkCycleCounter)
            0 : begin
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

                addr0_ready <= 1;
            end
            1:  begin
                addr0_ready <= 0;
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
                
                addr1_ready <= 1;
            end
            2:  begin
                addr1_ready <= 0;
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

                addr2_ready <= 1;
            end
            3:  begin
                addr2_ready <= 0;
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

                addr3_ready <= 1;
            end
            4:  begin
                addr3_ready <= 0;
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

                addr4_ready <= 1;
            end
            5:  begin
                addr4_ready <= 0;
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

                addr5_ready <= 1;
            end
            6:  begin 
                addr5_ready <= 0;
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

                addr6_ready <= 1;
            end
            7:  begin 
                addr6_ready <= 0;
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

                addr7_ready <= 1;
            end
            8:  begin 
                addr7_ready <= 0;
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

                addr8_ready <= 1;
            end
            9:  begin
                addr8_ready <= 0;
            end
            
        endcase
    end
end


reg [71:0] input_to_convolution;
reg [7:0] in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7, in_8;
reg start_convolution;

always @(posedge clk) begin
    if(reset) begin
        clkCycleCounter <= 0;
        pixelCounter <= 0;
        start_convolution <= 0;
        change_variable <= 0;
    end
    else begin
        case (clkCycleCounter)
            0: begin
                if(start_FSM) begin
                    clkCycleCounter <= clkCycleCounter + 1;
                    start_convolution <= 0;
                end
            end
            1: begin
                clkCycleCounter <= clkCycleCounter + 1;
            end
            2: begin
                in_0 <= dout;
                addr0_ready <= 0;
                clkCycleCounter <= clkCycleCounter + 1;
            end
            3: begin
                in_1 <= dout;
                addr1_ready <= 0;
                clkCycleCounter <= clkCycleCounter + 1;
            end
            4: begin
                in_2 <= dout;
                addr2_ready <= 0;
                clkCycleCounter <= clkCycleCounter + 1;
            end
            5: begin
                in_3 <= dout;
                addr3_ready <= 0;
                clkCycleCounter <= clkCycleCounter + 1;
            end
            6: begin
                in_4 <= dout;
                addr4_ready <= 0;
                clkCycleCounter <= clkCycleCounter + 1;
            end
            7: begin
                in_5 <= dout;
                addr5_ready <= 0;
                clkCycleCounter <= clkCycleCounter + 1;
            end
            8: begin
                in_6 <= dout;
                addr6_ready <= 0;
                clkCycleCounter <= clkCycleCounter + 1;
            end
            9: begin
                in_7 <= dout;
                addr7_ready <= 0;
                clkCycleCounter <= clkCycleCounter + 1;
                
            end
            10: begin
                in_8 <= dout;
                addr8_ready <= 0;
                clkCycleCounter <= clkCycleCounter + 1;
                change_variable <= 1;
            end
            11: begin
                input_to_convolution <= {in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7, in_8};
                start_convolution <= 1;
                pixelCounter <= pixelCounter + 1;
                if(pixelCounter != 16384) 
                    clkCycleCounter <= 0;
                else
                    clkCycleCounter <= 12;
                change_variable <= 0;

            end
            12: begin
                start_convolution <= 0;
                finished_processing <= 1;
            end

        endcase
    end
end

wire ready_to_send;
convolution C(.clk(clk), .in_pixels_data(input_to_convolution), .in_pixels_valid(start_convolution), .out_pixel_data(convolvedPixel), .out_pixel_data_ready(ready_to_send));

reg [6:0] i_write, j_write;
always @(posedge clk) begin
    if(reset) begin
        i_write <= 0;
        j_write <= 0;
    end
    else if(ready_to_send) begin
        if(j_write == 127) begin
            j_write <= 0;
            i_write <= i_write + 1;
        end
        else begin
            j_write <= j_write + 1;
        end
    end

end


wire [13:0] finalAddress;
reg [13:0] nonInferAddr;
always @(*) begin
    nonInferAddr = i_write*128 + j_write;
end

assign finalAddress = (inferMode) ? inferAddr : nonInferAddr; // Assign to the reg instead of a wire

blk_mem_gen_0 results(.clka(clk), .ena(1), .wea((ready_to_send)), .addra(finalAddress), .dina(convolvedPixel), .douta(inferResult));


endmodule
