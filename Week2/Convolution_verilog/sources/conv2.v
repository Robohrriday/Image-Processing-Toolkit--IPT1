`timescale 1ns / 1ps

module conv2(clk, rst, infer, addr, out, Anode_Activate, LED_out, reset);

parameter N = 16;
parameter p = 3;
input [7:0] addr;                       // Address in convolved image ***** [ floor(2 * log2(N)) : 0 ]
input clk;                              // Clock (100 MHz)
input rst;                              // Reset
input infer;                            // Used for inferring Convolved Image entries at addr
output reg [11:0] out;                  // Entry of Convolved Image at addr *****
output [3:0] Anode_Activate;
output [6:0] LED_out;
input reset;
reg [15:0] slow_clk = 0;

seven_seg_display inst1(.clock_100Mhz(clk), .reset(reset), .prod(out), .Anode_Activate(Anode_Activate), .LED_out(LED_out));

(* ram_style = "bram" *) reg [0:0] filter [0:(p*p)-1];           // p x p Filter
(* ram_style = "bram" *) reg [7:0] data [0:(N*N)-1];             // N x N Image
(* ram_style = "bram" *) reg [11:0] conv [0:(N-p+1)*(N-p+1)-1];  // (N-p+1) x (N-p+1) Convolved Image

reg [1:0] col_counter;                  // ***** [ floor(log2(p)) : 0 ]
reg [1:0] row_counter;                  // ***** [ floor(log2(p)) : 0 ]
reg [7:0] w_addr;                       // ***** [ floor(2 * log2(N)) : 0 ]
reg [3:0] offset;                       // ***** [ floor(log2(N-p+1)) : 0 ]
reg [11:0] sum;                         // *****
reg [1:0] state = 0;                        

initial begin
    $readmemb("F:/D/IITGN/ES_204_Digital_Systems/Week2Conv/Week2Conv.srcs/sources_1/new/filter.txt", filter);
    $readmemb("F:/D/IITGN/ES_204_Digital_Systems/Week2Conv/Week2Conv.srcs/sources_1/new/data1.txt", data);
end

always @ (posedge clk)
begin
    if (slow_clk == 15) begin    
        $display("Clk\n");
        case (state)
            0: begin
                $display("State 0");
                if (rst) begin
                    $display("(0.1) rst = %d\n",rst);
                    state <= 0;
                    col_counter <= 0;
                    w_addr <= 0;
                    sum <= 0;
                    row_counter <= 0;
                    offset <= 0;
                end
                else begin
                    $display("(0.2) rst = %d\n",rst);
                    state <= 1;
                end
                out <= 0;
            end
            1: begin
                    $display("State = 1");        
                    $display("Filter = %d",filter[col_counter + p*row_counter]);
                    $display("Data = %d",data[w_addr + (p-1)* offset + row_counter*N + col_counter]);
                    $display("Sum = %d",sum);  
                if ((col_counter == p-1) && (row_counter == p-1)) begin
                    $display("(1.1a) col_counter = %d",col_counter);
                    $display("(1.1b) row = %d\n",row_counter);
                    state <= 2;
                    col_counter <= 0;
                    row_counter <= 0;
                end
                else if (col_counter == p-1) begin
                    $display("(1.2a) col_counter = %d",col_counter);
                    $display("(1.2b) row = %d\n",row_counter);
                    state <= 1;
                    col_counter <= 0;
                    row_counter <= row_counter + 1;
                end
                else begin
                    $display("(1.3a) col_counter = %d",col_counter);
                    $display("(1.3b) row = %d\n",row_counter);
                    state <= 1;
                    col_counter <= col_counter + 1;
                end
                sum <= sum + filter[col_counter + p*row_counter] * data[w_addr + (p-1)* offset + row_counter*N + col_counter];
                out <= 0;
            end
            2: begin
                $display("  State = 2");
                $display("  Sum = %d",sum); 
                if (w_addr == (N-p+1)*(N-p+1)-1) begin
                    $display("      (2.1) W_addr = %d\n",w_addr);
                    state <= 3;
                    col_counter <= 0;
                    w_addr <= 0;
                    row_counter <= 0;
                end
                else if (w_addr % (N-p+1) == N-p) begin
                    $display("      (2.1) W_addr = %d\n",w_addr);
                    state <= 1;
                    col_counter <= 0;
                    w_addr <= w_addr + 1;
                    sum <= 0;
                    offset <= offset + 1;
                end
                else begin
                    $display("      (2.1) W_addr = %d\n",w_addr);
                    state <= 1;
                    col_counter <= 0;
                    w_addr <= w_addr + 1;
                    sum <= 0;
    
                end
                conv[w_addr] <= sum;   
                out <= 0;
            end
            3:begin
                $display("State = 3");
                if (infer & ~rst) begin
                    $display("              (3.1a) infer = %d", infer);
                    $display("              (3.1b) rst = %d\n", rst);
                    
                    out <= conv[addr];
                    state <= 3;
                    col_counter <= 0;
                    w_addr <= 0;
                    sum <= 0;
                    row_counter <= 0;
                end
                else if(rst) begin
                    $display("              (3.2a) infer = %d", infer);
                    $display("              (3.2b) rst = %d\n", rst);
                    out <= 0;
                    state <= 0;
                    col_counter <= 0;
                    w_addr <= 0;
                    sum <= 0;
                    row_counter <= 0;
                    offset <= 0;
                end
                else begin
                    $display("              (3.3a) infer = %d", infer);
                    $display("              (3.3b) rst = %d\n", rst);
                    state <= 3;
                    col_counter <= 0;
                    w_addr <= 0;
                    sum <= 0;
                    row_counter <= 0;
                end
            end        
        endcase
    slow_clk <= 0;
    end    
    else begin
        slow_clk <= slow_clk + 1;
    end
end

endmodule
