`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2022 02:33:51 PM
// Design Name: 
// Module Name: toplevel_tb
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


module toplevel_tb(

    );
    
    
    reg clk100 = 0;
    reg [2:0] sw = 0'b101;
    wire hsync, vsync;
    wire [3:0] r;
    wire [3:0] g;
    wire [3:0] b;
    toplevel top
	(
		.hw_clk(clk100),
		.hw_sw(sw),
		.hw_hsync(hsync), .hw_vsync(vsync),
		.hw_vga_out_red(r),
		.hw_vga_out_green(g),
		.hw_vga_out_blue(b)
	);
	
    parameter PERIOD = 10;
    parameter HPERIOD = PERIOD/2;
    localparam hperiod = 5;
    initial begin
        repeat(10000000) begin
            clk100 <= ~clk100;
            $display(r);
            #HPERIOD;
        end     
    end
	
endmodule
