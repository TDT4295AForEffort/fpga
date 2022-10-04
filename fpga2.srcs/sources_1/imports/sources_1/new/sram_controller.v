`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2022 04:07:36 PM
// Design Name: 
// Module Name: sram_controller
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


module sram_controller(
        input clk100,
        input wire [19:0] portA_addr, 
        output wire [15:0] portA_data, 
        output wire portA_valid,
        
        input wire [19:0] portB_addr, 
        input wire [15:0] portB_data, 
        
        output wire [19:0] sram_addr,
        input wire [15:0] sram_data_out,
        output wire [15:0] sram_data_in,
        output wire sram_write
    );

    reg [19:0] next_addr = 0;
    reg [1:0] cycle = 0;
    assign sram_addr = 
        (cycle == 0 ? portA_addr : (
         cycle == 1 ? portA_addr : (
         cycle == 2 ? portA_addr : (
         cycle == 3 ? portB_addr : 0
         ))));
     
    assign sram_write = cycle == 3; 
    assign sram_data_in = portB_data;
    assign portA_data = sram_data_out;
    assign portA_valid = cycle == 0;    
    always @(posedge clk100) begin
        cycle <= cycle + 1;
    end
endmodule : sram_controller
