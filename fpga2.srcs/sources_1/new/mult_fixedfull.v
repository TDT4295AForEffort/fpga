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


module mulq18_14(
        input wire signed [31:0] a,
        input wire signed [31:0] b,
        output wire signed [31:0] c,
        output wire overflow
    );
    // todo add rounding
    wire signed [63:0] mult;
    assign mult = a*b;
    assign c[30:0] = mult[44:14];
    assign c[31] = mult[63];
    localparam mask = 'b11111_11111_11111; // 15 ones
    assign overflow = mult[63] == 0 ? mult[62:48] != 0 : mult[62:48] != mask;
endmodule
