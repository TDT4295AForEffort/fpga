`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2022 04:18:42 PM
// Design Name: 
// Module Name: math_tb
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


module math_tb(

    );
    reg clk100 = 0;
    parameter PERIOD = 10;
    parameter HPERIOD = PERIOD/2;
    localparam hperiod = 5;
    reg [31:0] ar = 0'h0001_0000;
    reg [31:0] br = 0'h0001_0001;
    reg [31:0] cr = 0;

    wire [31:0] a = ar;
    wire [31:0] b = br;
    wire [31:0] c;
    
    always @(posedge clk100) begin
        cr = c;
        ar = ar + 32;
    end
    mult_fixedfull c_ab_mult(a,b,c);
    initial begin
        repeat(10000) begin
            clk100 <= ~clk100;
            #HPERIOD;
        end
    end
endmodule
