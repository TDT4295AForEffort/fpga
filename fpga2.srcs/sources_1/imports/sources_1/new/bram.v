`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/22/2022 12:31:57 PM
// Design Name: 
// Module Name: bram
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


module bram (
        input wire clk,
        input wire we,
        input wire [19:0] addr,
        input wire [15:0] di,
        output reg [15:0] dout
    );
    
    localparam ramsize = 1024;
    reg [15:0] ram [ramsize-1:0];
    integer i;
    initial begin
        for(i = 0; i < ramsize; i = i + 1) 
            ram[i] = 0;
    end

    always @(posedge clk) begin
        if (we)
            ram[addr] <= di;
        dout <= ram[addr];
    end
endmodule