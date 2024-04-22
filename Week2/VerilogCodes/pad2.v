
`timescale 1ns / 1ps

module pad2(input clk,
input go_2,
input [14:0]address_2,
output [7:0] out1_2,
output [7:0]out2_2,
output reg flag_2,
output ena_pad2_0,
output ena_pad2_1,
output wea_pad2_0,
output wea_pad2_1,
output [13:0]addr_pad2_0,
output [14:0]addr_pad2_1,
output [7:0]din_pad2_0,
output [7:0]din_pad2_1,
input [7:0]dout_pad2_0,
input [7:0]dout_pad2_1);
parameter N = 128;
//reg data_loaded;
//reg move1;
//reg clear;
wire [7:0] dout1,dout2;
wire [7:0] din1,din2;
reg [13:0] address1;
reg [14:0] address2;
reg wea2;
wire [14:0]addr1,addr2;
reg [3:0] counter = 1'b0;
reg slowclk = 1'b0;

//blk_mem_gen_0 topad(.clka(clk), .ena(1), .wea(0), .addra(addr1), .dina(din1), .douta(dout1));
//blk_mem_gen_1 padded(.clka(clk), .ena(1), .wea(wea2), .addra(addr2), .dina(din2), .douta(dout2));

assign ena_pad2_0 = 1;
assign ena_pad2_1 = 1;
assign wea_pad2_0 = 0;
assign wea_pad2_1 = wea2;
assign addr_pad2_0 = addr1;
assign addr_pad2_1 = addr2;
assign din_pad2_0 = din1;
assign din_pad2_1 = din2;
assign dout1 = dout_pad2_0;
assign dout2 = dout_pad2_1;


assign out1=dout1;
assign out2=dout2;
assign din2=dout1;

assign addr2 = (go_2)?address2:(address_2+1);
assign addr1 = (go_2)?address1:address_2[13:0];

always@(posedge clk)begin
if (counter<10) counter <= counter+1;
else begin slowclk<=~slowclk; counter<=0; end
end

always@(posedge slowclk)begin
wea2<=0;
flag_2 <= 0;
if(go_2)begin
    if(address_2 >= ((N+2)*(N+2))) begin wea2<=0; flag_2 <=1; end
    else if(address2 == ((N+2)*(N+2))-1) begin address1<=(N*N)-1;wea2<=1;address2<=address2+1; end//bottom right
    else if(address2 == 0) begin address1<=0;wea2<=1; address2<=address2+1; end //top left
    else if(address2 == (N+2)-1) begin address1<=N-1;wea2<=1; address2<=address2+1; end //top right
    else if(address2 == (N+2)*(N+1)) begin address1<=(N*(N-1));wea2<=1; address2<=address2+1; end //bottom left
    else if(address2>0 && address2<N+1) begin address1<=address2-1;wea2<=1; address2<=address2+1; end //top row
    else if(address2%(N+2)==0) begin address1<=(((address2/(N+2))-1)*N);wea2<=1; address2<=address2+1; end //left column
    else if(address2%(N+2)==N+1) begin address1<=(((address2/(N+2))-1)*N)+N-1;wea2<=1; address2<=address2+1; end //right column
    else if(address2>(N+2)*(N+1) && address2<((N+2)*(N+2))-1) begin address1<=(N*(N-1))+address2%(N+2)-1;wea2<=1; address2<=address2+1; end //bottom row
    else if(address2>(N+2) && address2<((N+2)*(N+1))-1) begin address1<=(((address2/(N+2))-1)*N)+(address2%(N+2))-1;wea2<=1; address2<=address2+1; end //everything else
end
    else begin address2<=0;wea2<=0;end
end
endmodule


