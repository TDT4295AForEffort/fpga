`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2022 01:39:11 PM
// Design Name: 
// Module Name: sram_manager
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


module sram_manager(
        input wire clk,
        output wire [19:0] hw_sram_addr,
        inout wire [15:0] hw_sram_data,
        output wire hw_sram_we, // active-low
        output wire hw_sram_ce, // active-low
        output wire hw_sram_we, // active-low
        output wire hw_sram_oe, // active-low
        output wire hw_sram_lb, // active-low
        output wire hw_sram_ub, // active-low

        input wire we,
        input wire [19:0] addr,
        input wire [15:0] di,
        output wire [15:0] dout
    );
endmodule
