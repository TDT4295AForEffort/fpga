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


module invq18_14(
        input wire clk,
        input wire signed [31:0] a,
        output wire signed [31:0] inv
    );
    // c = a/b
    wire firstnegw = a < 0;
    wire [31:0] abs = firstnegw ? ~a+1 : a;
    wire [3:0] shiftamnt = $log2()
    // find 1/b

    // implicitly shift 7 right, by moving dot 7 left.
    // 11.21

    reg [31:0] firstguess = 0;
    reg [31:0] firstabs = 0;
    wire [63:0] firstmultres = 3947580*abs;
    reg firstneg = 0;

    always @(posedge clk) begin
        // 2.82352941 - 1.88235284 b'
        firstguess = 5921370 - firstmultres[52:21];
        firstneg = firstnegw;
        firstabs = abs;
    end

    reg [31:0] secondguess = 0;
    reg [31:0] secondabs = 0;
    reg secondneg = 0;
    wire [63:0] second_absyguess = firstabs * firstguess;
    wire [63:0] second_product = firstguess * ((1<<21) - second_absyguess[52:21]);

    always @(posedge clk) begin
        secondguess = firstguess + second_product[52:21];
        secondneg = firstneg;
        secondabs = firstabs;
    end

    reg [31:0] thirdguess = 0;
    reg [31:0] thirdabs = 0;
    reg thirdneg = 0;
    wire [63:0] third_absyguess = secondabs * secondguess;
    wire [63:0] third_product = secondguess * ((1<<21) - third_absyguess[52:21]);

    always @(posedge clk) begin
        thirdguess = secondguess + third_product[52:21];
        thirdneg = secondneg;
        thirdabs = secondabs;
    end


    reg [31:0] fourthguess = 0;
    reg [31:0] fourthabs = 0;
    reg fourthneg = 0;
    wire [63:0] fourth_absyguess = thirdabs * thirdguess;
    wire [63:0] fourth_product = thirdguess * ((1<<21) - fourth_absyguess[52:21]);

    always @(posedge clk) begin
        fourthguess = thirdguess + fourth_product[52:21];
        fourthneg = thirdneg;
        fourthabs = thirdabs;
    end

    wire signed [31:0] res = fourthguess[31:14];
    assign inv = fourthneg ? -res : res;

endmodule
