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


module sram_tb(

    );


    reg clk100 = 0;

    wire clk;
    wire hw_sram_we;
    wire [19:0] hw_sram_addr;
    wire [15:0] hw_sram_data;
    wire hw_sram_ce; // active-low
    wire hw_sram_we; // active-low
    wire hw_sram_oe; // active-low
    wire hw_sram_lb; // active-low
    wire hw_sram_ub; // active-low

    input wire we;
    input wire [19:0] addr;
    input wire [15:0] di;
    output wire [15:0] dout;
    sram_manager sram(clk,
        hw_sram_addr, hw_sram_data, hw_sram_we, hw_sram_ce, hw_sram_oe, hw_sram_lb, hw_sram_ub,
        we, addr, di, dout
    );

    parameter PERIOD = 10;
    parameter HPERIOD = PERIOD/2;
    localparam hperiod = 5;
    initial begin
        repeat(10000000) begin
            clk100 <= ~clk100;
            #HPERIOD;
        end
    end

endmodule
