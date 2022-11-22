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
        input wire [1:0] clk1004state,
        input wire reset,

        output wire [19:0] hw_sram_addr,
        output wire hw_sram_we, // active-low
        output wire hw_sram_ce, // active-low
        output wire hw_sram_oe, // active-low
        output wire hw_sram_lb, // active-low
        output wire hw_sram_ub, // active-low
        inout wire [15:0] hw_sram_data,

        input wire we,
        input wire [19:0] addr,
        input wire [15:0] di,
        output wire [15:0] dout
    );

    localparam active = 0;
    localparam inactive = 1;
    reg [19:0] sram_addr_reg = 0;
    reg sram_we_reg = inactive; // active-low
    reg sram_ce_reg = inactive; // active-low
    reg sram_oe_reg = inactive; // active-low
    reg sram_lb_reg = inactive; // active-low
    reg sram_ub_reg = inactive; // active-low
    reg [15:0] sram_dataout_reg = 0;
    reg [15:0] sram_datain_reg = 0;

    always @(posedge clk) begin
        if (reset) begin
            sram_addr_reg = 0;
            sram_dataout_reg = 0;
            sram_datain_reg = 0;
        end
        else if (clk1004state == 0) begin
            sram_addr_reg = addr; // write addr
        end
        else if (clk1004state == 1) begin
            sram_datain_reg = di;
            sram_dataout_reg = hw_sram_data;
        end
        else if (clk1004state == 2) begin
            sram_addr_reg = addr; //read addr

        end
        else if (clk1004state == 3) begin

        end

    end
    always @(negedge clk) begin
        if (reset) begin
            sram_ub_reg = inactive;
            sram_we_reg = inactive;
            sram_ce_reg = inactive;
            sram_oe_reg = inactive;
            sram_lb_reg = inactive;
        end
        else if (clk1004state == 0) begin
            sram_we_reg = active && we;
            sram_oe_reg = active;
        end
        else if (clk1004state == 1) begin
            sram_we_reg = inactive;
            sram_ce_reg = inactive;
            sram_lb_reg = inactive;
            sram_ub_reg = inactive;
        end
        else if (clk1004state == 2) begin
            sram_ce_reg = active;
            sram_lb_reg = active;
            sram_ub_reg = active;
        end
    end

    assign hw_sram_addr = sram_addr_reg;
    assign hw_sram_we = sram_we_reg;
    assign hw_sram_ce = sram_ce_reg;
    assign hw_sram_oe = sram_oe_reg;
    assign hw_sram_lb = sram_lb_reg;
    assign hw_sram_ub = sram_ub_reg;
    assign hw_sram_data = sram_we_reg == active ? sram_datain_reg : 16'hz;
    assign dout = sram_dataout_reg;

endmodule
