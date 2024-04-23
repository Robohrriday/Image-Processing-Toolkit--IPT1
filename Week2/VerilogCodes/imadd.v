`timescale 1ns / 1ps

module IM_Adder(input clk, output reg adder_done, input begin_adding, 
output ena_add_1,
output ena_add_2,
output wea_add_1,
output wea_add_2,
output [13:0]addr_add_1,
output [13:0]addr_add_2,
output [7:0]din_add_1,
output [7:0]din_add_2,
input [7:0]dout_add_1,
input [7:0]dout_add_2);

// Parameters
parameter N = 128;

reg ena1;
reg wea1 = 0;
reg [7:0] din1 = 0;
wire [7:0] outa;

reg ena2;
reg wea2 = 0;
reg [7:0] din2 = 0;
wire [7:0] outb;

reg [13:0] addr = 0;

// Uncomment the BRAM codes for standalone implementation.
//blk_mem_gen_0 a1(.clka(clk), .ena(ena1), .wea(wea1), .addra(addr), .dina(din1), .douta(outa));
//blk_mem_gen_0 a2(.clka(clk), .ena(ena2), .wea(wea2), .addra(addr), .dina(din2), .douta(outb));


// BRAM Signals
assign ena_add_1 = ena1;
assign ena_add_2 = ena2;
assign wea_add_1 = wea1;
assign wea_add_2 = wea2;
assign addr_add_1 = addr;
assign addr_add_2 = addr;
assign din_add_1 = din1;
assign din_add_2 = din2;
assign outa = dout_add_1;
assign outb = dout_add_2;

reg [2:0] slow_clk = 0;
reg [8:0] sum = 1;
reg [2:0] state = 0;

// Image Addition and Normalization FSM
always @ (posedge clk) 
begin
    if (slow_clk == 7 & begin_adding == 1)
    begin
        case(state)
        0: begin                                // Simply enabling BRAM
            ena1 <= 1;
            ena2 <= 1;
            wea1 <= 0;
            wea2 <= 0;
            state <= 1;
        end
        1: begin                                // Adding and Normalizing
            state <= 2;
            sum <= (outa + outb)/2;
        end
        2: begin                                // Simply enabling write enable into BRAM 2; Data gets written
            state <= 3;
            wea1 <= 0;
            wea2 <= 1;
            din2 <= sum;
            
        end
        3: begin                                // Changing addr only after data is written
            if (addr == N*N-1) state <= 4;
            else begin
            addr <= addr + 1;
            state <= 0;
            end
            wea1 <= 0;
            wea2 <= 0;
        end           
        4: begin                                // Sink state
            state <= 4;
            adder_done <= 1;
        end
        endcase
        slow_clk <= 0;    
    end
    else
    begin
        slow_clk <= slow_clk + 1;
    end     
end
endmodule