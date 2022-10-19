`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2022 04:21:03 PM
// Design Name: 
// Module Name: mult_fixedfull
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


module divq18_14(
        input wire clk,
        input wire signed [31:0] a,
        input wire signed [31:0] b,
        output reg signed [31:0] c,
        output reg overflow
    );
    // todo does not match timing, rewrite entirely
    // todo add rounding
    wire signed [45:0] ashift = {a, a[31] ? 14'b1 : 14'b0};
    wire signed [45:0] div;
    assign div = ashift/b;
    localparam mask = 'b11111_11111_1111; // 14 ones

    always @(posedge clk) begin
        c[30:0] = div[31:0];
        c[31] = div[45];
        overflow = div[45] == 0 ? div[45:31] != 0 : div[45:31] != mask;
    end
endmodule
