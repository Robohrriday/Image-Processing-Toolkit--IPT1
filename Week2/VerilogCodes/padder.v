
`timescale 1ns / 1ps

module padder(input clk,
input go,
input [14:0]address,
output [7:0] out1,
output [7:0]out2,
output reg flag,
output ena_pad_0,
output ena_pad_1,
output wea_pad_0,
output wea_pad_1,
output [13:0]addr_pad_0,
output [14:0]addr_pad_1,
output [7:0]din_pad_0,
output [7:0]din_pad_1,
input [7:0]dout_pad_0,
input [7:0]dout_pad_1);


//parameter for the padder
parameter N = 128;


wire [7:0] dout1,dout2;
wire [7:0] din1,din2;
reg [13:0] address1;
reg [14:0] address2;
reg wea2;
wire [14:0]addr1,addr2;
reg [3:0] counter = 1'b0;
reg slowclk = 1'b0;

//uncomment the following brams if you intend to use padder as a standalone module
//blk_mem_gen_0 topad(.clka(clk), .ena(1), .wea(0), .addra(addr1), .dina(din1), .douta(dout1));
//blk_mem_gen_1 padded(.clka(clk), .ena(1), .wea(wea2), .addra(addr2), .dina(din2), .douta(dout2));

//the following assignments are as per the controlling logic of the brams
assign ena_pad_0 = 1;
assign ena_pad_1 = 1;
assign wea_pad_0 = 0;
assign wea_pad_1 = wea2;
assign addr_pad_0 = addr1;
assign addr_pad_1 = addr2;
assign din_pad_0 = din1;
assign din_pad_1 = din2;
assign dout1 = dout_pad_0;
assign dout2 = dout_pad_1;


assign out1=dout1;
assign out2=dout2;
assign din2=dout1;

//padder logic
assign addr2 = (go)?address2:(address+1);
assign addr1 = (go)?address1:address[13:0];

always@(posedge clk)begin
if (counter<10) counter <= counter+1;
else begin slowclk<=~slowclk; counter<=0; end
end

always@(posedge slowclk)begin
wea2<=0;
if(go)begin         //padding logic.
    if(address >= ((N+2)*(N+2))) begin wea2<=0; flag <=1; end
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
    else begin address2<=0;wea2<=0;flag<=0;end
end
endmodule


