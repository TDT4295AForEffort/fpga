`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2022 03:17:04 PM
// Design Name: 
// Module Name: vga_test
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


module toplevel
	(
		input wire clk,
		input wire [2:0] sw,
		output wire hsync, vsync,
		output wire [3:0] r,
		output wire [3:0] g,
		output wire [3:0] b
	);
	wire reset;
	wire clk100;
	assign clk100 = clk;
	
	// channel toggle todo remove
	reg [2:0] rgb_reg = 0;
    always @(posedge clk100)
        rgb_reg <= sw;
        
    // state register for 4 state operations in sync
	reg [1:0] clk100_4state = 0;
	
	always @(posedge(clk100))
	   clk100_4state = clk100_4state + 1;
	
	
	// vga_sync setup
	wire video_on;
    wire [9:0] x;
    wire [9:0] y;
    wire [19:0] cur_pix, next_pix;
    
    // instantiate vga_sync
    vga_sync vga_sync_unit (.clk100(clk100), .clk100_4state(clk100_4state),
                            .hsync(hsync), .vsync(vsync),
                            .video_on(video_on), .p_tick(), .x(x), .y(y), 
                            .cur_pix(cur_pix), .next_pix(next_pix));


//    always @(posedge clk100)
//    begin
//        if (reset) time_reg <= 0;
//        else if (y == 1 & x==1) time_reg <= time_reg + 1;
//        else time_reg <= time_reg;
//    end

    // output
    wire [3:0] red;
    wire [3:0] green;
    wire [3:0] blue;
    wire [15:0] pixel;
    wire [15:0] gen_pixel;
    reg [15:0] pixelreg = 0;
    wire pixel_read_valid;
    
    assign red =   (rgb_reg[0]) ? (next_pix[3:0]) : 4'b0;
    assign green = (rgb_reg[1]) ? (next_pix[7:4]) : 4'b0;
    assign blue =  (rgb_reg[2]) ? (next_pix[11:8]) : 4'b0;
    assign gen_pixel[3:0] = red;
    assign gen_pixel[7:4] = green;
    assign gen_pixel[11:8] = blue;
    assign gen_pixel[15:12] = 0;
    assign r = video_on ? pixelreg[3:0] : 0;
    assign g = video_on ? pixelreg[7:4] : 0;
    assign b = video_on ? pixelreg[11:8] : 0;

    always @(posedge clk100) begin
        pixelreg = pixel_read_valid ? pixel : pixelreg;
    end 
    wire [19:0] ram_addr;
    wire [15:0] ram_data_out;
    wire [15:0] ram_data_in;
    wire ram_write;
    sram_controller sram_controller(.clk100(clk100), .sram_addr(ram_addr), .sram_data_in(ram_data_in), .sram_data_out(ram_data_out), .sram_write(ram_write), 
                                    .portA_addr(cur_pix), .portA_data(pixel), .portA_valid(pixel_read_valid),
                                    .portB_addr(next_pix), .portB_data(gen_pixel)
                                    );
    bram ram(.clk(clk100), .addr(ram_addr), .dout(ram_data_out), .di(ram_data_in), .we(ram_write));

endmodule : toplevel