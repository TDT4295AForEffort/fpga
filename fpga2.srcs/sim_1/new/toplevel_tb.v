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
    reg hw_clk = 0;
    reg [2:0] sw = 0'b101;
    wire hsync, vsync;
    wire [3:0] r;
    wire [3:0] g;
    wire [3:0] b;
    wire [3:0] btn = 4'b0101;

    reg [15:0] ram[16:0];
    integer i = 0;

    wire [19:0] hw_sram_addr;
    wire hw_sram_we;
    wire hw_sram_ce;
    wire hw_sram_oe;
    wire hw_sram_lb;
    wire hw_sram_ub;
    wire [15:0] hw_sram_data;

    toplevel top
	(
		.hw_clk(hw_clk),
		.hw_sw(sw),
		.hw_hsync(hsync), .hw_vsync(vsync),
		.hw_vga_out_red(r),
		.hw_vga_out_green(g),
		.hw_vga_out_blue(b),

        .hw_sram_addr(),
        .hw_sram_cWE(hw_sram_we), // active-low
        .hw_sram_cCE(hw_sram_ce), // active-low
        .hw_sram_cOE(hw_sram_oe), // active-low
        .hw_sram_cLB(hw_sram_lb), // active-low
        .hw_sram_cUB(hw_sram_ub), // active-low
        .hw_sram_data(hw_sram_data),

		.hw_btn(btn)
	);
	
    parameter PERIOD = 10;
    parameter HPERIOD = PERIOD/2;
    localparam hperiod = 5;
    initial begin
        for (i = 0; i < 76801; i = i + 1) begin
            ram[i] = 0;
        end
        repeat(20000000) begin
            clk100 <= ~clk100;
            #HPERIOD;
            hw_clk <= ~hw_clk;
            clk100 <= ~clk100;
            #HPERIOD;
        end     
    end

    wire [15:0] sram_read = ram[hw_sram_addr];
    wire [15:0] sram_write;
    assign hw_sram_data = hw_sram_we ? sram_read : 16'hz;
    assign sram_write = hw_sram_we ? 0 : hw_sram_data;

    always @(posedge clk100) begin
        if (hw_sram_we) begin
            ram[hw_sram_addr] <= sram_write;
        end else begin
//            hw_sram_data = ram[hw_sram_addr];
        end
    end
	
endmodule
