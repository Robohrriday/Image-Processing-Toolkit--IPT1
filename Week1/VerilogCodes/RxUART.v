`timescale 1ns / 1ps

module RxUART(clk, //W5 clock of fpga
reset, //reset the whole module 
RxD, //serial 1 bit input mapped from the recieve pin of basys3
RxData, // output for 8 bits data
bhejdo); //flag representing the reception of 8bits)

input clk,RxD,reset;
output reg bhejdo;
output [7:0]RxData;

reg shift; // shift signal to trigger shifting data
reg [1:0] state, nextstate;
reg [3:0] bitcounter; // 4 bits counter to count upto 10 for 8 data bits 1 start bit and 1 stop bit
reg [1:0] samplecounter; // 2 bits sample counter to count up to 4 for oversampling
reg [13:0] counter; // 14 bits counter to produce slow clock at baud
reg [9:0] rxshiftreg; //right shift reg
reg clear_bitcounter,inc_bitcounter,inc_samplecounter,clear_samplecounter; //clear or increment the counter
reg flag;

parameter clk_freq = 100_000_000;  // system clock frequency
parameter baud_rate = 9_600; //baud rate
parameter div_sample = 4; //oversampling
parameter div_counter = clk_freq/(baud_rate*div_sample);  // this is the number we have to divide the system clock frequency to get a frequency (div_sample) time higher than (baud_rate)
parameter mid_sample = (div_sample/2);  // this is the middle point of a bit where you want to sample it
parameter div_bit = 10; // 1 start, 8 data, 1 stop


assign RxData = rxshiftreg [8:1]; // assign the RxData from the shiftregister

//UART receiver logic
always @ (posedge clk)
    begin 
        if (reset)begin // reset the whole module
            state <=0; 
            bitcounter <=0; 
            counter <=0;
            samplecounter <=0; 
            bhejdo <= 0;
        end else begin
            counter <= counter +1; // start counting for slow clock imitation
            if (counter >= div_counter-1) begin // if counter reaches the count of 2063, i.e. freq/(baud*oversampling)
                counter <=0; //reset the counter and follow the command variables
                state <= nextstate;
                if (shift)rxshiftreg <= {RxD,rxshiftreg[9:1]};
                if (clear_samplecounter) samplecounter <=0; 
                if (inc_samplecounter) samplecounter <= samplecounter +1;
                if (clear_bitcounter) bitcounter <=0;
                if (inc_bitcounter)bitcounter <= bitcounter +1;
                if(flag) begin  bhejdo <= 1; end
                else begin bhejdo <= 0; end
            end
        end
    end
   
//state machine

always @ (posedge clk) //trigger by clock
begin
// initialising the commanding variables
    flag <=0;
    shift <= 0;  
    clear_samplecounter <=0;
    inc_samplecounter <=0;
    clear_bitcounter <=0; 
    inc_bitcounter <=0; 
    nextstate <=0; 
    case (state)
        0: begin // idle state
            if (RxD) // if RxD is 1. i.e. the uart communication is idle
              begin
              nextstate <=0; // back to idle state because RxD needs to be low to start transmission    
              end
            else begin // this is when RxD is 0. i.e. stop bit is recieved
                nextstate <=1; //start receiving 
                clear_bitcounter <=1; //clear the bit counter
                clear_samplecounter <=1; // clear the sample counter
            end
        end
        1: begin // receiving state
            nextstate <= 1; // initialising
            if (samplecounter== mid_sample - 1) shift <= 1; // collect the data when sample counter is at the middle 
            if (samplecounter== div_sample - 1) //if all the samples are counted, see next bit
			begin 
                    if (bitcounter == div_bit - 1)  // if all data bits are recieved go back to idle state
					begin
                			nextstate <= 0;
                			flag <= 1;
                	 end 
                	 inc_bitcounter <=1; // one more bit is recieved
                	 clear_samplecounter <=1; // reset the sample counter, even if the sample counter is not reset, the module works as the counter is itself 2 bits
                	 
            	end 
		  else inc_samplecounter <=1;
        	 end
//        2: begin //recieve remain idle till reset, but keep the flag high. this state is not needed for our adder implementation
//            if (reset) begin
//                bhejdo <= 0;
//                nextstate <= 0;
//            end
//            else begin
//                flag <= 1;
//                nextstate <= 2;
//            end
//           end
                
                
       default: nextstate <=0; //default idle state
     endcase
end         
endmodule
