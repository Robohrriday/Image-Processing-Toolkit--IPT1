`timescale 1ns / 1ps

module conv(input clk,input rst,input infer,input [14:0]addr, output [7:0]out, output reg conv_done,
output ena_conv_1,
output ena_conv_0,
output wea_conv_1,
output wea_conv_0,
output [14:0]addr_conv_1,
output [13:0]addr_conv_0,
output [7:0]din_conv_1,
output [7:0]din_conv_0,
input [7:0]dout_conv_1,
input [7:0]dout_conv_0);

parameter N = 130;
parameter p = 3;
//input [14:0] addr;                      // Address in convolved image ***** [ ceil(2 * log2(N-p+1)) - 1: 0 ]
//input clk;                              // Clock (100 MHz)
//input rst;                              // Reset
//input infer;                            // Used for inferring Convolved Image entries at addr
//output [7:0] out;                       // Entry of Convolved Image at addr *****
// the above inputs and outputs were commented out by me(abhinav) as i wanted input output defined in the module def.

//output [3:0] Anode_Activate;
//output [6:0] LED_out;
//output reg conv_done;
reg [2:0] slow_clk = 0;                 // *****

//seven_seg_display inst1(.clock_100Mhz(clk), .reset(1'b0), .prod(out), .Anode_Activate(Anode_Activate), .LED_out(LED_out));

reg signed [3:0] filter [0:(p*p)-1];                                       // p x p Filter

//(* ram_style = "block" *) reg [7:0] data [0:(N*N)-1];               // N x N Image
//(* ram_style = "block" *) reg [11:0] conv [0:(N-p+1)*(N-p+1)-1];    // (N-p+1) x (N-p+1) Convolved Image

reg [1:0] col_counter;                  // ***** [ floor(log2(p)) : 0 ]
reg [1:0] row_counter;                  // ***** [ floor(log2(p)) : 0 ]
reg [14:0] w_addr;                      // ***** [ ceil(2 * log2(N-p+1)) - 1: 0 ]
reg [7:0] offset;                       // ***** [ floor(log2(N-p+1)) : 0 ]
reg signed [15:0] sum;                  // *****
reg [1:0] state = 0;                        

reg wea2;
wire [7:0] out1;         // *****
wire [14:0] addr1;              // *****
reg [7:0] conv;          // *****

wire signed [8:0] signed_out1;
assign signed_out1 = out1;

assign addr1 = w_addr + (p-1)* offset + row_counter * N + col_counter;

//blk_mem_gen_1 padded(.clka(clk), .ena(1), .wea(0), .addra(addr1), .dina(8'd0), .douta(out1));
//blk_mem_gen_0 convolved(.clka(clk), .ena(1), .wea(wea2), .addra(w_addr), .dina(conv), .douta(out));


assign ena_conv_1 = 1;
assign ena_conv_0 = 1;
assign wea_conv_1 = 0;
assign wea_conv_0 = wea2;
assign addr_conv_1 = addr1;
assign addr_conv_0 = w_addr;
assign din_conv_1 = 8'd0;
assign din_conv_0 = conv;
assign out1 = dout_conv_1;
assign out = dout_conv_0;


initial begin
    $readmemb("F:/D/IITGN/ES_204_Digital_Systems/DS_project_IPT/DS_project_IPT.srcs/sources_1/smooth_filter.txt", filter);
end

always @ (posedge clk)
begin
    if (slow_clk == 5) begin    
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
                    wea2 <= 0;
                    conv <= 0;
                end
                else begin
                    $display("(0.2) rst = %d\n",rst);
                    state <= 1;
                end
                conv_done <= 0;
            end
            1: begin
                $display("State = 1");        
                $display("Filter = %d",filter[col_counter + p*row_counter]);
                $display("Data = %d",signed_out1);
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
                sum <= sum + filter[col_counter +  row_counter*p] * signed_out1;
                conv_done <= 0;
                wea2 <= 0; 
            end
            2: begin
                $display("  State = 2");
                $display("  Sum = %d",sum);
                $display("  Conv = %d", conv);  
                $display("  wea2 = %d", wea2);  
                if (w_addr == (N-p+1)*(N-p+1)) begin
                    $display("      (2.1) W_addr = %d\n",w_addr);
                    state <= 3;
                    col_counter <= 0;
                    row_counter <= 0;
                end
                else if (w_addr == (N-p+1)*(N-p+1) - 1) begin
                    state <= 1;
                    col_counter <= 0;
                    w_addr <= w_addr + 1;
                    sum <= 0;
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
                wea2 <= 1;
                conv <= sum / 9;
                conv_done <= 0;
            end
            3:begin
                $display("State = 3");
                if (infer & ~rst) begin
                    $display("              (3.1a) infer = %d", infer);
                    $display("              (3.1b) rst = %d\n", rst);
                    wea2 <= 0;
                    w_addr <= addr + 1;
                    state <= 3;
                    col_counter <= 0;
                    sum <= 0;
                    row_counter <= 0;
                end
                else if(rst) begin
                    $display("              (3.2a) infer = %d", infer);
                    $display("              (3.2b) rst = %d\n", rst);
                    state <= 0;
                    col_counter <= 0;
                    w_addr <= 0;
                    sum <= 0;
                    row_counter <= 0;
                    offset <= 0;
                    wea2 <= 0;
                    conv <= 0;
                end
                else begin
                    $display("              (3.3a) infer = %d", infer);
                    $display("              (3.3b) rst = %d\n", rst);
                    state <= 3;
                    col_counter <= 0;
                    w_addr <= 0;
                    sum <= 0;
                    row_counter <= 0;
                    wea2 <= 0;
                end
                conv_done <= 1;
            end        
        endcase
    slow_clk <= 0;
    end    
    else begin
        slow_clk <= slow_clk + 1;
    end
end

endmodule