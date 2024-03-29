`timescale 1ns / 1ps

module conv1(clk, rst, infer, addr, out);

parameter N = 5;
parameter p = 3;
input [3:0] addr;                       // Address in convolved image *****
input clk;                              // Clock (100 MHz)
input rst;                              // Reset
input infer;                            // Used for inferring Convolved Image entries at addr
output reg [11:0] out;                  // Entry of Convolved Image at addr *****


reg [2:0] filter [0:(p*p)-1];           // p x p Filter
reg [7:0] data [0:(N*N)-1];             // N x N Image
reg [11:0] conv [0:(N-p+1)*(N-p+1)-1];  // (N-p+1) x (N-p+1) Convolved Image

reg [2:0] counter;                      // *****
reg [3:0] w_addr;                       // *****
reg [1:0] state = 0;                        
reg [1:0] nextstate = 0;
reg [11:0] sum;                         // *****
reg [2:0]  row_counter;                  // *****


// Flags
reg clear_counter;
reg inc_counter;
reg clear_w_addr;
reg inc_w_addr;
reg clear_sum;
reg clear_row_counter;
reg inc_row_counter;
reg compute;

initial begin
    $readmemb("F:/D/IITGN/ES_204_Digital_Systems/Week2Conv/Week2Conv.srcs/sources_1/new/filter.txt", filter);
    $readmemb("F:/D/IITGN/ES_204_Digital_Systems/Week2Conv/Week2Conv.srcs/sources_1/new/data.txt", data);
end
 
always @ (posedge clk)
begin
    if (clear_counter) counter <= 0;
    if (inc_counter) counter <= counter + 1;
    if (clear_w_addr) w_addr <= 0;
    if (inc_w_addr) w_addr <= w_addr + 1;
    if (clear_sum) sum <= 0;
    if (clear_row_counter) row_counter <= 0;
    if (inc_row_counter) row_counter <= row_counter + 1;
    if (compute) sum <= sum + filter[row_counter * p + counter] * data[w_addr + row_counter*N + counter];
    state <= nextstate;
    $display("%d, %d",state, nextstate);
end 


always @ (posedge clk)
begin
    $display("Clk\n");
    case (state)
        0: begin
            $display("State 0");
            if (rst) begin
                $display("(0.1) rst = %d\n",rst);
                nextstate = 0;
                clear_counter <= 1;
                inc_counter <= 0;
                clear_w_addr <= 1;
                inc_w_addr <= 0;
                clear_sum <= 1;
                clear_row_counter <= 1;
                inc_row_counter <= 0;
            end
            else begin
                $display("(0.2) rst = %d\n",rst);
                nextstate = 1;
            end
            out <= 0;
        end
        1: begin
                $display("State = 1");        
                $display("Filter = %d",filter[counter + p*row_counter]);
                $display("Data = %d",data[w_addr + row_counter*N + counter]);
                $display("Sum = %d",sum);  
            if ((counter == p-1) && (row_counter == p-1)) begin
                $display("(1.1a) counter = %d",counter);
                $display("(1.1b) row = %d\n",row_counter);
                nextstate <= 2;
                clear_counter <= 1;
                inc_counter <= 0;
                clear_w_addr <= 0;
                inc_w_addr <= 0;
                clear_sum <= 0;
                clear_row_counter <= 1;
                inc_row_counter <= 0;
                compute <= 0;
            end
            else if (counter == p-1) begin
                $display("(1.2a) counter = %d",counter);
                $display("(1.2b) row = %d\n",row_counter);
                nextstate <= 1;
                clear_counter <= 1;
                inc_counter <= 0;
                clear_w_addr <= 0;
                inc_w_addr <= 0;
                clear_sum <= 0;
                clear_row_counter <= 0;
                inc_row_counter <= 1;
                compute <= 0;
            end
            else begin
                $display("(1.3a) counter = %d",counter);
                $display("(1.3b) row = %d\n",row_counter);
                nextstate <= 1;
                clear_counter <= 0;
                inc_counter <= 1;
                clear_w_addr <= 0;
                inc_w_addr <= 0;
                clear_sum <= 0;
                clear_row_counter <= 0;
                inc_row_counter <= 0;
                compute <= 1;
            end
            out <= 0;
        end
        2: begin
            $display("  State = 2");
            $display("  Sum = %d",sum); 
            if (w_addr == (N-p+1)*(N-p+1)-1) begin
                $display("  (2.1) Nxt= %d\n",nextstate);
                nextstate <= 3;
                clear_counter <= 1;
                inc_counter <= 0;
                clear_w_addr <= 1;
                inc_w_addr <= 0;
                clear_sum <= 0;
                clear_row_counter <= 1;
                inc_row_counter <= 0;
                compute <= 0;
            end
            else begin
                $display("  (2.1) Nxt= %d\n",nextstate);
                nextstate <= 1;
                clear_counter <= 1;
                inc_counter <= 0;
                clear_w_addr <= 0;
                inc_w_addr <= 1;
                clear_sum <= 1;
                clear_row_counter <= 1;
                inc_row_counter <= 0;
                compute <= 0;

            end
            conv[w_addr] <= sum;   
            out <= 0;
        end
        3:begin
            $display("State = 3");
            if (infer & ~rst) begin
                $display("      (3.1a) infer = %d", infer);
                $display("      (3.1b) rst = %d\n", rst);
                
                out <= conv[addr];
                nextstate <= 3;
                clear_counter <= 1;
                inc_counter <= 0;
                clear_w_addr <= 1;
                inc_w_addr <= 0;
                clear_sum <= 1;
                clear_row_counter <= 1;
                inc_row_counter <= 0;
                compute <= 0;
            end
            else if(rst) begin
                $display("      (3.2a) infer = %d", infer);
                $display("      (3.2b) rst = %d\n", rst);
                out <= 0;
                nextstate <= 0;
                clear_counter <= 1;
                inc_counter <= 0;
                clear_w_addr <= 1;
                inc_w_addr <= 0;
                clear_sum <= 1;
                clear_row_counter <= 1;
                inc_row_counter <= 0;
                compute <= 0;
            end
            else begin
                $display("      (3.3a) infer = %d", infer);
                $display("      (3.3b) rst = %d\n", rst);
                nextstate <= 3;
                clear_counter <= 1;
                inc_counter <= 0;
                clear_w_addr <= 1;
                inc_w_addr <= 0;
                clear_sum <= 1;
                clear_row_counter <= 1;
                inc_row_counter <= 0; 
            end
        end        
    endcase
end

endmodule
