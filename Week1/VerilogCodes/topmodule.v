`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2024 16:29:43
// Design Name: 
// Module Name: topmodule
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


module topmodule(clk,RxReset,TxReset,RxD,tx, stored, bhejdo, Master_Rst);
input RxD,clk,RxReset,TxReset, Master_Rst;//various resets, clock and RxD is mapped to recieve pin of the basys3
output tx;//mapped to transmitting pin of basys3
output reg [7:0] stored;//summed data for transmitter to transmit
output bhejdo;//flag signal transmitter
//input Mreset;
//output bhejdiya;

parameter n = 32; //parameter for how many numbers to be added
integer i = 0; //iterator
wire [7:0]RxData; //reciever output
//reg state,nextstate; //for fsm implementation, not needed in our adder for now
reg flag;//flag for transmitter to send data

RxUART inst1(.clk(clk),.reset(RxReset),.RxD(RxD),.RxData(RxData),.bhejdo(bhejdo)); //instantiate reciever module
    
    
always @(posedge bhejdo, posedge Master_Rst) begin
    if (Master_Rst)begin //reset the adder if master reset is asserted. set iterator to 0 and flush the sum, make flag low
        stored <= 0;
        i <= 0;
        flag <= 0;
    end
    
    else if (i<n) begin
    stored <= stored+RxData;//sum the data
    flag <= 1;//for transmitter
    i <= i+1;//iterator update
    end
    
end

TxUART inst2(.data(stored),.TxD(tx),.clk(clk),.transmit(flag),.reset(TxReset)); /* instantiate transmitter module and always 
transmit the stored sum, this sum is only read when the input is fully completed from the computer side*/

endmodule


//this is FSM implementation of the topmodule, which is not needed for our adder for now.

//case(state)
//    0:begin//summing
//        if(i==0)begin
//            stored <= RxData;
//            i <= i+1;
//        end
//        else if (i == 1)begin
//            stored <= stored + RxData;
//            i <=0;
//        end
//    end
//endcase
//end


//module topmodule(clk,RxD,tx,RxData,bhejdo,bhejdiya);
//input RxD,clk;
//output tx;
//output [7:0] RxData;
//output bhejdo;
//output bhejdiya;

////parameter n = 2;
////integer i = 0;
////wire RxData;
//reg RxReset = 0;
//reg TxReset = 1;

//uart_rx_instrict inst1(.clk(clk),.reset(RxReset),.RxD(RxD),.RxData(RxData),.bhejdo(bhejdo));
//TxUART inst2(.data(stored),.TxD(tx),.clk(clk),.transmit(bhejdo),.reset(TxReset),.bhejdiya(bhejdiya));

//always @(posedge clk)begin
//    if (bhejdo)begin 
//        TxReset <= 0;
//        RxReset <= 1;
//    end
    
//    else if (bhejdiya)begin
//        TxReset <= 1;
//        RxReset <= 0;
//    end
//    else begin
//        TxReset <= 1;
//        RxReset <= 0;
//    end
//end
//endmodule