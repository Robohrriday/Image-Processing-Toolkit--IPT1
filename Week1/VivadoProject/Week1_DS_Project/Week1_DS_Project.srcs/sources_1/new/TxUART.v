`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2024 1:16:02 AM
// Design Name: 
// Module Name: TxUART
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TxUART(clk,reset,transmit,data,TxD);
input clk; // W5 clock
input reset;    //reset the transmission module
input transmit;  // signal to the transmit module to transmit the data
input [7:0] data; //the data that is to be transmitted
output reg TxD; //mapped to the serial output port of fpga for uart
//output reg bhejdiya; // this is the flag signalling the end of transmission. Not needed for adder implementation 

reg [3:0] bitcounter; //to count the 8 transmitted bits
reg [13:0] counter; //to count upto 10415 i.e. baud clock
reg state,nextstate; //state logic
reg [9:0] rightshiftreg; //right shift register for 8 bit data with a start bit and a stop bit
reg shift;//command for right shift
reg load;//command for load
reg clear;

always @ (posedge clk)//logic for fsm 
begin 
    if (reset) 
	   begin
        state <=0; 
        counter <=0;  
        bitcounter <=0;
       end
    else begin
         counter <= counter + 1;  
            if (counter >= 10415)
               begin 
                  state <= nextstate; 
                  counter <=0; 
            	  if (load) rightshiftreg <= {1'b1,data,1'b0}; 
		          if (clear) bitcounter <=0; 
                  if (shift) 
                     begin 
                        rightshiftreg <= rightshiftreg >> 1; 
                        bitcounter <= bitcounter + 1; 
                     end
               end
         end
end 

//state definitions for fsm
always @ (posedge clk) 
begin
//initialising
//    bhejdiya <= 0;
    load <=0; 
    shift <=0;
    clear <=0;
    TxD <=1;
    case (state)
        0: begin //idle
             if (transmit && ~reset) begin  
             nextstate <= 1;
             load <=1; 
             shift <=0;
             clear <=0;
             end
		     else begin 
             nextstate <= 0;
             TxD <= 1; 
             end
           end
        1: begin //transmit
             if (bitcounter >=9) begin //transmission complete
             clear <=1;
             nextstate <= 0;
//             bhejdiya <= 1;
             end 
		     else begin   //transmission
             nextstate <= 1; 
             TxD <= rightshiftreg[0]; 
             shift <=1; 
             end
           end
//        2: begin
//             if(reset)begin
//                nextstate <= 0;
//                bhejdiya <= 0;
//             end
//             else begin
//                bhejdiya <= 1;
//                nextstate <= 2;
//             end
//           end 
         default: nextstate <= 0;                      
    endcase
end


endmodule