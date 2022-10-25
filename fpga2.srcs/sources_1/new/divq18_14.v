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
        output wire signed [31:0] c,
        output wire overflow
    );

    wire fourthb;
    reg signed [31:0] firsta = 0;
    reg signed [31:0] seconda = 0;
    reg signed [31:0] thirda = 0;
    reg signed [31:0] fourtha = 0;
    invq18_14 inverter(clk, b, fourthb);

    mulq18_14 multer(fourtha, fourthb, c);

    always @(posedge clk) begin
        firsta = a;
        seconda = firsta;
        thirda = seconda;
        fourtha = thirda;
    end
endmodule
