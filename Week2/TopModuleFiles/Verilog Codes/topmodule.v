`timescale 1ns / 1ps

module topmodule(clk, ren, RxD, addr, pixel, flag, receiving, wea_temp_img);
input clk;
input ren;
input RxD;
input [13:0] addr;
input wea_temp_img;
output [9:0] pixel;
output flag;
output reg receiving;

reg [13:0] orig_img_addr;
reg [13:0] processed_img_addr = 8'b00000010;
wire [13:0] temp_img_addr;

wire [7:0] orig_img_pixel;
wire [7:0] processed_img_pixel;
wire [7:0] temp_img_pixel;

reg wea_processed_img = 1'b0;

reg [7:0] dina_processed_img = 8'b00000011;
reg [7:0] dina_temp_img = 8'b00000001;


assign temp_img_addr = addr;

image img(.clk(clk),.reset(ren),.ena(1),.RxD(RxD),.addr(addr),.dout(orig_img_pixel),.ImRxComplete(flag));
blk_mem_gen_0 processed_img(.clka(clk), .ena(1), .wea(wea_processed_img), .addra(processed_img_addr ), .dina(dina_processed_img), .douta(processed_img_pixel));
blk_mem_gen_0 temp_img(.clka(clk), .ena(1), .wea(wea_temp_img), .addra(temp_img_addr), .dina(dina_temp_img), .douta(temp_img_pixel));

assign pixel = orig_img_pixel + processed_img_pixel + temp_img_pixel;


always @ (posedge clk) begin
    if (ren & flag) begin
        receiving <= 0;
    end
    else begin
        receiving <= 1;
    end
end

endmodule
