`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.04.2024 01:37:45
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


module topmodule(input clk,
input recieve,                  //input to start recieving the data
input Rx,                       //Rx pin of UART reciever, connected to B18
input transmit,                 //input to start transmitting data
input pad,                      //input to pad the original image
input pad_2,                    //input to pad the porcessed image
input conv,                     //input to convolve the padded image(smoothen)
input conv_2,                   //input to convolve the padded image(sharpen)
input add,                      //input to add the image in the processed and original brams
output Tx,                      //Tx pin of UART transmitter, connected to A18
output [7:0]dataout_topmodule,  //Output of the top bram, storing image data
output imrxcomplete,            //flag for completion of recieve
output padded_complete,         //flag for completion of padder
output padded2_complete,        //flag for completion of padder 2
output conv_complete,           //flag for completion of convolution (smoothen)
output conv_complete_2,         //flag for completion of convolution (sharpen)
output adder_done);             //flag for completion of adding and normalising

//initialising bram top to store the original image
reg ena_top;
reg wea_top;
reg [13:0]addr_top;
reg [7:0]din_top;
wire [7:0] dout_top;
blk_mem_gen_0 original(.clka(clk), .ena(ena_top), .wea(wea_top), .addra(addr_top), .dina(din_top), .douta(dout_top));


//initialising bram padded to store the padded image
reg ena_padded;
reg wea_padded;
reg [14:0]addr_padded;
reg [7:0]din_padded;
wire [7:0]dout_padded;
blk_mem_gen_1 padded(.clka(clk), .ena(ena_padded), .wea(wea_padded), .addra(addr_padded), .dina(din_padded), .douta(dout_padded));


//initialising bram processed to store the processed image
reg ena_processed;
reg wea_processed;
reg [13:0]addr_processed;
reg [7:0]din_processed;
wire [7:0] dout_processed;
blk_mem_gen_0 processed(.clka(clk), .ena(ena_processed), .wea(wea_processed), .addra(addr_processed), .dina(din_processed), .douta(dout_processed));


//initialising imrx and the wires for imrx
wire ena_imrx;
wire wea_imrx;
wire [13:0] addr_imrx;
wire [7:0] din_imrx;
reg [7:0] dout_imrx;

imrx uut1(.clk(clk), //input clock
.reset(~recieve), //input reset 
.ena(1),
.RxD(Rx), //input receving data line
.addr(addr_imrx), //address to infer
.dout(dout_imrx),
.ImRxComplete(imrxcomplete),
.ena_imrx(ena_imrx),
.wea_imrx(wea_imrx),
.din_imrx(din_imrx),
.addr_imrx(addr_imrx));


//initialising imtx and the wires for imtx
wire [7:0]data_tx;
wire ena_imtx;
wire wea_imtx;
wire [13:0]addr_imtx;
wire [7:0]din_imtx;
reg [7:0]dout_imtx;

imtx uut2(.clk(clk), //UART input clock
.reset(~transmit), // reset signal
.transmit(transmit), //btn signal to trigger the UART communication
.data(data_tx), // data transmitted
.TxD(Tx), // Transmitter serial output. TxD will be held high during reset, or when no transmissions aretaking place 
//output reg done
.ena_tx(ena_imtx),
.wea_tx(wea_imtx),
.addr_tx(addr_imtx),
.din_tx(din_imtx),
.dout_tx(dout_imtx));


//initialising padder and the wires for padder
//wire go, replaced by pad in the topmodule input 
reg [14:0]address = 0;
wire [7:0] out1;
wire [7:0]out2;
//reg flag, replaced by padded_complete in the topmodule output
wire ena_pad_0;
wire ena_pad_1;
wire wea_pad_0;
wire wea_pad_1;
wire [13:0]addr_pad_0;
wire [14:0]addr_pad_1;
wire [7:0]din_pad_0;
wire [7:0]din_pad_1;
reg [7:0]dout_pad_0;
reg [7:0]dout_pad_1;

padder uut3(.clk(clk),
.go(pad),
.address(address),
.out1(out1),
.out2(out2),
.flag(padded_complete),
.ena_pad_0(ena_pad_0),
.ena_pad_1(ena_pad_1),
.wea_pad_0(wea_pad_0),
.wea_pad_1(wea_pad_1),
.addr_pad_0(addr_pad_0),
.addr_pad_1(addr_pad_1),
.din_pad_0(din_pad_0),
.din_pad_1(din_pad_1),
.dout_pad_0(dout_pad_0),
.dout_pad_1(dout_pad_1));



//initialising pad2 and the wires of the pad2
//wire go_2, replaced by pad2 in the topmodule input 
reg [14:0]address_2 = 0;
wire [7:0] out1_2;
wire [7:0]out2_2;
//reg flag, replaced by padded_complete in the topmodule output
wire ena_pad2_0;
wire ena_pad2_1;
wire wea_pad2_0;
wire wea_pad2_1;
wire [13:0]addr_pad2_0;
wire [14:0]addr_pad2_1;
wire [7:0]din_pad2_0;
wire [7:0]din_pad2_1;
reg [7:0]dout_pad2_0;
reg [7:0]dout_pad2_1;

pad2 uut5(.clk(clk),
.go_2(pad_2),
.address_2(address_2),
.out1_2(out1_2),
.out2_2(out2_2),
.flag_2(padded2_complete),
.ena_pad2_0(ena_pad2_0),
.ena_pad2_1(ena_pad2_1),
.wea_pad2_0(wea_pad2_0),
.wea_pad2_1(wea_pad2_1),
.addr_pad2_0(addr_pad2_0),
.addr_pad2_1(addr_pad2_1),
.din_pad2_0(din_pad2_0),
.din_pad2_1(din_pad2_1),
.dout_pad2_0(dout_pad2_0),
.dout_pad2_1(dout_pad2_1));



//initialising conv and the wires for conv
reg rst;
reg infer = 1;
reg [14:0]addr = 0;
wire [7:0]out;
//wire conv_done;
wire ena_conv_1;
wire ena_conv_0;
wire wea_conv_1;
wire wea_conv_0;
wire [14:0]addr_conv_1;
wire [13:0]addr_conv_0;
wire [7:0]din_conv_1;
wire [7:0]din_conv_0;
reg [7:0]dout_conv_1_;
reg [7:0]dout_conv_0_;

conv uut4(.clk(clk),.rst(~conv),.infer(infer),.addr(addr),.out(out),.conv_done(conv_complete),
.ena_conv_1(ena_conv_1),
.ena_conv_0(ena_conv_0),
.wea_conv_1(wea_conv_1),
.wea_conv_0(wea_conv_0),
.addr_conv_1(addr_conv_1),
.addr_conv_0(addr_conv_0),
.din_conv_1(din_conv_1),
.din_conv_0(din_conv_0),
.dout_conv_1(dout_conv_1_),
.dout_conv_0(dout_conv_0_));




//initialising conv2 and the wires for conv2
reg rst_2;
reg infer_2 = 1;
reg [14:0]addr_2 = 0;
wire [7:0]out_2;
//wire conv_done;
wire ena_conv2_1;
wire ena_conv2_0;
wire wea_conv2_1;
wire wea_conv2_0;
wire [14:0]addr_conv2_1;
wire [13:0]addr_conv2_0;
wire [7:0]din_conv2_1;
wire [7:0]din_conv2_0;
reg [7:0]dout_conv2_1_;
reg [7:0]dout_conv2_0_;

conv2 uut6(.clk(clk),.rst_2(~conv_2),.infer_2(infer_2),.addr_2(addr_2),.out_2(out_2),.conv_done_2(conv_complete_2),
.ena_conv2_1(ena_conv2_1),
.ena_conv2_0(ena_conv2_0),
.wea_conv2_1(wea_conv2_1),
.wea_conv2_0(wea_conv2_0),
.addr_conv2_1(addr_conv2_1),
.addr_conv2_0(addr_conv2_0),
.din_conv2_1(din_conv2_1),
.din_conv2_0(din_conv2_0),
.dout_conv2_1(dout_conv2_1_),
.dout_conv2_0(dout_conv2_0_));



//initialising image adder and the wires for image adder
//output reg adder_done, replaced by the output  
//input begin_adding,   replaced by input of topmodule 
wire ena_add_1;
wire ena_add_2;
wire wea_add_1;
wire wea_add_2;
wire [13:0]addr_add_1;
wire [13:0]addr_add_2;
wire [7:0]din_add_1;
wire [7:0]din_add_2;
reg [7:0]dout_add_1;
reg [7:0]dout_add_2;

IM_Adder uut7(.clk(clk),.adder_done(adder_done),.begin_adding(add), 
.ena_add_1(ena_add_1),
.ena_add_2(ena_add_2),
.wea_add_1(wea_add_1),
.wea_add_2(wea_add_2),
.addr_add_1(addr_add_1),
.addr_add_2(addr_add_2),
.din_add_1(din_add_1),
.din_add_2(din_add_2),
.dout_add_1(dout_add_1),
.dout_add_2(dout_add_2));





//final logic for controlling the block rams according to the input
assign dout_topmodule = dout_top;
always@(posedge clk)begin
if (recieve) begin  //if recieve, then control the top bram by imrx
ena_top <= ena_imrx;
wea_top <= wea_imrx;
addr_top <= addr_imrx;
din_top <= din_imrx; 
dout_imrx <= dout_top;
end

else if (transmit) begin    //if transmit, then control the processed bram by imtx
ena_processed <= ena_imtx;
wea_processed <= wea_imtx;
addr_processed <= addr_imtx+1;
din_processed <= din_imtx; 
dout_imtx <= dout_processed;
end

else if (pad) begin     //if pad, control the top and padded bram by padder
ena_top <= ena_pad_0;
wea_top <= wea_pad_0;
addr_top <= addr_pad_0;
din_top <= din_pad_0; 
dout_pad_0 <= dout_top;
ena_padded <= ena_pad_1;
wea_padded <= wea_pad_1;
addr_padded <= addr_pad_1;
din_padded <= din_pad_1; 
dout_pad_1 <= dout_padded;
end

else if (conv) begin    //if conv, control the processed and the padded bram by convolution
ena_processed <= ena_conv_0;
wea_processed <= wea_conv_0;
addr_processed <= addr_conv_0;
din_processed <= din_conv_0; 
dout_conv_0_ <= dout_processed;
ena_padded <= ena_conv_1;
wea_padded <= wea_conv_1;
addr_padded <= addr_conv_1+1;
din_padded <= din_conv_1; 
dout_conv_1_ <= dout_padded;
end

else if (pad_2) begin   //if pad2, control processed and padded bram by pad2
ena_processed <= ena_pad2_0;
wea_processed <= wea_pad2_0;
addr_processed <= addr_pad2_0+1;
din_processed <= din_pad2_0; 
dout_pad2_0 <= dout_processed;
ena_padded <= ena_pad2_1;
wea_padded <= wea_pad2_1;
addr_padded <= addr_pad2_1;
din_padded <= din_pad2_1; 
dout_pad2_1 <= dout_padded;
end

else if (conv_2) begin  //if conv2, control the processed and padded bram by conv2
ena_processed <= ena_conv2_0;
wea_processed <= wea_conv2_0;
addr_processed <= addr_conv2_0;
din_processed <= din_conv2_0; 
dout_conv2_0_ <= dout_processed;
ena_padded <= ena_conv2_1;
wea_padded <= wea_conv2_1;
addr_padded <= addr_conv2_1+1;
din_padded <= din_conv2_1; 
dout_conv2_1_ <= dout_padded;
end


else if (add) begin     //if add, control the top and processed bram by add
ena_top<=ena_add_1;
wea_top<=wea_add_1;
addr_top<=addr_add_1;
din_top<=din_add_1;
dout_add_1<=dout_top;
ena_processed<=ena_add_2;
wea_processed<=wea_add_2;
addr_processed<=addr_add_2+1;
din_processed<=din_add_2;
dout_add_2<=dout_processed;
end

end
endmodule
