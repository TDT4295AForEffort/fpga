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
		.clk(clk100),
		.sw(sw),
		.hsync(hsync), .vsync(vsync),
		.r(r),
		.g(g),
		.b(b)
	);
	
    parameter PERIOD = 10;
    parameter HPERIOD = PERIOD/2;
    localparam hperiod = 5;
    initial begin
        repeat(1000000) begin
            clk100 <= ~clk100;
            $display(r);
            #HPERIOD;
        end     
    end
	
endmodule
