`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2022 01:24:47 PM
// Design Name: 
// Module Name: vga_sync_tb
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


module vga_sync_tb(

    );
    reg clk100 = 0;
    reg [1:0] clk100_4state = 0;
    wire hsync, vsync, video_on, p_tick;
	wire [9:0] x, y;
	wire [19:0] cur_pix, next_pix;
    vga_sync vga(
        .clk100(clk100),
		.hsync(hsync), .vsync(vsync), .video_on(video_on), .p_tick(p_tick),
		.x(x), .y(y),
		.cur_pix(cur_pix), .next_pix(next_pix)
    );
    
    always @(posedge clk100) begin
        clk100_4state = clk100_4state + 1;
    end
    parameter PERIOD = 10;
    parameter HPERIOD = PERIOD/2;
    localparam hperiod = 5;
    initial begin
        repeat(1) begin
            clk100 <= ~clk100;
            #HPERIOD;
        end     
    end
endmodule
