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


module mult_fixedfull(
        input wire [31:0] a,
        input wire [31:0] b,
        output wire [31:0] c
    );

    wire [63:0] mult;
    assign mult = a*b;
    assign c = mult[47:16] + mult[15];

endmodule
