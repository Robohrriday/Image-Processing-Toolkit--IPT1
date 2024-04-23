`timescale 1ns / 1ps

module lineController9(
    input clk,
    input reset,
    input [7:0] incoming_pixel_data, // The incoming pixel data
    input incoming_pixel_data_valid, // Signal that says that the incoming data is valid. You should write it. Can also think of it as write enable.
    output reg [71:0] output_pixels_data, // Since we are going to output 9 pixels at a time, we need 72 bits to store them
    output reg output_pixels_data_ready    
    );

// The first 9 pixels will be stored in the first line buffer
// The next 9 pixels will be stored in the second line buffer and so on
wire [23:0] LB0_data;
wire [23:0] LB1_data;
wire [23:0] LB2_data;
wire [23:0] LB3_data;

// WRITING PORTION
reg [3:0] writeCounter; // 4-bit counter to count up to 9 pixels
reg [1:0] currentWriteLineBuffer; // 2-bit counter to count up to 4 line buffers
reg [3:0] writeLineBufferDataValid;
// Counter to count the number of pixels received.
always @(posedge clk) begin
    if(reset) begin
        writeCounter <= 0;
    end
    else if(in_pixel_data_valid) begin
        if(writeCounter == 8) // The current pixel will be read. And for the next cycle, writeCounter will be 0 again.
            writeCounter <= 0;
        else
            writeCounter <= writeCounter + 1;
    end 
end

// Logic to control the valid signals of the line buffers. We want this to be available as soon as possible
always @(*) begin
    case (currentWriteLineBuffer)
        0: writeLineBufferDataValid = 4'b1000;
        1: writeLineBufferDataValid = 4'b0100;
        2: writeLineBufferDataValid = 4'b0010;
        3: writeLineBufferDataValid = 4'b0001;
        default: writeLineBufferDataValid = 4'b0000;
    endcase
end

// Logic to control which line buffer to write to
always @(posedge clk) begin
    if(reset) begin
        currentWriteLineBuffer <= 0;
    end
    else begin
        if(writeCounter == 8 & incoming_pixel_data_valid) begin // That means we have received 8 pixels. Now if we receive one more pixel, take that one, write it and move it to the next line buffer
            if(currentWriteLineBuffer == 3) // At the last pixel, if it was in the last buffer, we change it to buffer 0
                currentWriteLineBuffer <= 0;
            else
                currentWriteLineBuffer <= currentWriteLineBuffer + 1;     
        end
    end
end

// Now the actual writing logic is handled by the lineBuffer module. We just present the data to the line buffer module and tell that it is valid data. You can write it. That we handled in the second small always block    
lineBuffer9 b0(.clk(clk), .reset(reset), .incoming_pixel_data(incoming_pixel_data), .incoming_pixel_data_valid(writeLineBufferDataValid[0]), .output_pixels_data(LB0_data), .going_to_read_data(readLineBufferDataGoingToBeRead[0]));
lineBuffer9 b1(.clk(clk), .reset(reset), .incoming_pixel_data(incoming_pixel_data), .incoming_pixel_data_valid(writeLineBufferDataValid[1]), .output_pixels_data(LB1_data), .going_to_read_data(readLineBufferDataGoingToBeRead[1]));
lineBuffer9 b2(.clk(clk), .reset(reset), .incoming_pixel_data(incoming_pixel_data), .incoming_pixel_data_valid(writeLineBufferDataValid[2]), .output_pixels_data(LB2_data), .going_to_read_data(readLineBufferDataGoingToBeRead[2]));
lineBuffer9 b3(.clk(clk), .reset(reset), .incoming_pixel_data(incoming_pixel_data), .incoming_pixel_data_valid(writeLineBufferDataValid[3]), .output_pixels_data(LB3_data), .going_to_read_data(readLineBufferDataGoingToBeRead[3]));




// READ PORTION
reg [6:0] globali, globalj;
reg [3:0] readCounter; // 4-bit counter to count up to 9 pixels IN THE CURRENT LINE BUFFER
reg [1:0] currentReadLineBuffer; // 2-bit counter to count up to 4 line buffers
reg [3:0] readLineBufferDataGoingToBeRead; // 4-bit signal to control the ready signals of the line buffers
reg readLineBuffer; // Signal to know whether to actually read the line buffers or not as we cant start reading till we fill at least 3 lines.

// Counter to count the number of pixels read
always @(posedge clk) begin
    if(reset) begin
        readCounter <= 0;
        globali <= 0;
        globalj <= 0;
    end
    else begin
        if(readLineBufferDataGoingToBeRead[currentReadLineBuffer]) begin // The read permission for the current line buffer is given. So we can read the data. By our design, 3 line buffers will have the ready signal high at a time. So we can read 3 X 3 = 9 pixels at a time.
            if(readCounter == 8) begin // The current pixel will be read. And for the next cycle, readCounter will be 0.
                readCounter <= 0;
                globali <= globali + 1;
            end
            else begin
                readCounter <= readCounter + 1;
                globalj <= globalj + 1;
            end
        end
    end
end

// Logic to control which line buffer to read from
always @(posedge clk) begin
    if(reset)
        currentReadLineBuffer <= 0;
    else begin
        if(readCounter == 8 & readLineBufferDataGoingToBeRead[currentReadLineBuffer]) begin // That means we have received 8 pixels. Now if we receive one more pixel, take that one, write it and move it to the next line buffer
            if(currentReadLineBuffer == 3) // We are at the last pixel in the last buffer. So we move to the first buffer.
                currentReadLineBuffer <= 0;
            else
                currentReadLineBuffer <= currentReadLineBuffer + 1;     
        end
    end
end

reg [23:0] tempData1, tempData2, tempData3;
// Logic to control which order are the line buffers are read in
always @(*) begin
    case (currentReadLineBuffer)
        0: begin
            if((globali == 0) && (globalj == 0))
                tempData1

        end
        1: output_pixels_data = {LB1_data, LB2_data, LB3_data};
        2: output_pixels_data = {LB2_data, LB3_data, LB0_data};      
        3: output_pixels_data = {LB3_data, LB0_data, LB1_data};

    endcase
end

// The variable readLineBuffer is used in our FSM to control the reading of the line buffers. We want to read the line buffers only when we reach a minimum amount of pixels in the line buffers. This is to ensure that we have enough pixels to read from the line buffers. We don't want to read the line buffers when they are empty. This is handled by the FSM below.
always @(*) begin // Writing as combinational block because we want to read the data as soon as it is available
    case (currentReadLineBuffer)
        0:begin
            readLineBufferDataGoingToBeRead[0] = readLineBuffer;
            readLineBufferDataGoingToBeRead[1] = readLineBuffer;
            readLineBufferDataGoingToBeRead[2] = readLineBuffer;
            readLineBufferDataGoingToBeRead[3] = 0;
        end 
        1:begin
            readLineBufferDataGoingToBeRead[0] = 0;
            readLineBufferDataGoingToBeRead[1] = readLineBuffer;
            readLineBufferDataGoingToBeRead[2] = readLineBuffer;
            readLineBufferDataGoingToBeRead[3] = readLineBuffer;
        end
        2:begin
            readLineBufferDataGoingToBeRead[0] = readLineBuffer;
            readLineBufferDataGoingToBeRead[1] = 0;
            readLineBufferDataGoingToBeRead[2] = readLineBuffer;
            readLineBufferDataGoingToBeRead[3] = readLineBuffer;
        end
        3:begin
            readLineBufferDataGoingToBeRead[0] = readLineBuffer;
            readLineBufferDataGoingToBeRead[1] = readLineBuffer;
            readLineBufferDataGoingToBeRead[2] = 0;
            readLineBufferDataGoingToBeRead[3] = readLineBuffer;
        end
        default:begin
            readLineBufferDataGoingToBeRead[0] = 0;
            readLineBufferDataGoingToBeRead[1] = 0;
            readLineBufferDataGoingToBeRead[2] = 0;
            readLineBufferDataGoingToBeRead[3] = 0;
        end
    endcase
end

// FSM CODE
reg [12:0] totalPixelCounter; // Counter to count the total number of pixels in the line buffers
reg readState;
parameter IDLE = 0;
parameter READING = 1;
always @(posedge clk) begin
    if(reset)
        totalPixelCounter <= 0;
    else begin
        if(incoming_pixel_data_valid & !readLineBuffer)
            totalPixelCounter <= totalPixelCounter + 1;
        else if(!incoming_pixel_data_valid & readLineBuffer)
            totalPixelCounter <= totalPixelCounter - 1;
        else // If both are on or both are off, then totalPixelCounter remains the same
            totalPixelCounter <= totalPixelCounter;
    end
end

always @(posedge clk) begin
    if(reset) begin
        readState <= IDLE;
        readLineBuffer <= 0;
    end
    else begin
        case (readState)
            IDLE: begin
                if(totalPixelCounter >= 27) begin // Adjusted for 9 pixels per buffer
                    readLineBuffer <= 1;
                    readState <= READING;
                    output_pixels_data_ready <= 1;
                end
            end
            READING: begin
                if(totalPixelCounter == 0) begin
                    readLineBuffer <= 0;
                    readState <= IDLE;
                end
            end

        endcase
    end
end

endmodule
