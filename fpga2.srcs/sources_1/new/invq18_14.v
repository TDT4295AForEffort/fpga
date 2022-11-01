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
        input wire signed [31:0] x,
        output wire signed [31:0] inv
    );
    // delay: 3 cycles.
    // (cycle 0: input, cycle 1: first pass, cycle 2: third pass, cycle 3: output
    // inv = 1/a
    // 1/a = 1/n * n/a = 1/n * 1/(a/n)
    // select n so a/n € [0.5,1]
    // make linear guess at a/n
    // refine with newton's

    // internal 3.29 precision, because 1/0.5 is 2, so don't need higher than 4.
    // this means saying shifted = a is an implicit shift right 29-14=15
    wire isneg = x < 0;
    wire [31:0] abs = isneg ? -x : x;
    wire [6:0] shift = //$clog2(a) is constant only;
        abs[30] ? 30 :
        abs[29] ? 30 :
        abs[28] ? 28-28 :
        abs[27] ? 28-27 :
        abs[26] ? 28-26 :
        abs[25] ? 28-25 :
        abs[24] ? 28-24 :
        abs[23] ? 28-23 :
        abs[22] ? 28-22 :
        abs[21] ? 28-21 :
        abs[20] ? 28-20 :
        abs[19] ? 28-19 :
        abs[18] ? 28-18 :
        abs[17] ? 28-17 :
        abs[16] ? 28-16 :
        abs[15] ? 28-15 :
        abs[14] ? 28-14 :
        abs[13] ? 28-13 :
        abs[12] ? 28-12 :
        abs[11] ? 28-11 :
        abs[10] ? 28-10 :
        abs[9]  ? 28-9 :
        abs[8]  ? 28-8 :
        abs[7]  ? 28-7 :
        abs[6]  ? 28-6 :
        abs[5]  ? 28-5 :
        abs[4]  ? 28-4 :
        abs[3]  ? 28-3 :
        abs[2]  ? 28-2 :
        abs[1]  ? 28-1 :
        abs[0]  ? 28 : 31;
    wire [64:0] shifted = abs<<shift;

    wire immediate_divbyzero = shift == 31;
    wire immediate_numwaytoobig = shift == 30;
    // find 1/b

    localparam c_1d88235284 = 1010580486;
    localparam c_2d82352941 = 1515870809;
    localparam c_1d0 = {1, 29'd0};

    reg [31:0] first_guess = 0;
    reg [31:0] first_x = 0;
    wire [63:0] firstmultres = c_1d88235284*shifted;
    reg first_isneg = 0;
    reg [4:0] first_shift = 0;

    always @(posedge clk) begin
        // 2.82352941 - 1.88235284 b'
        first_guess = c_2d82352941 - firstmultres[63:29];
        first_isneg = isneg;
        first_x = shifted;
        first_shift = shift;
    end

    reg [31:0] second_guess = 0;
    reg [31:0] second_x = 0;
    reg second_isneg = 0;
    wire [63:0] second_xy = first_x * first_guess;
    wire [63:0] second_dx = first_guess * (c_1d0 - second_xy[63:29]);
    reg [6:0] second_shift = 0;

    always @(negedge clk) begin
        second_guess = first_guess + second_dx[63:29];
        second_isneg = first_isneg;
        second_x = first_x;
        second_shift = first_shift;
    end

    reg [31:0] third_guess = 0;
    reg [31:0] third_x = 0;
    reg third_isneg = 0;
    wire [63:0] third_xy = second_x * second_guess;
    wire [63:0] third_dx = second_guess * (c_1d0 - third_xy[63:29]);
    reg [6:0] third_shift = 0;

    always @(posedge clk) begin
        third_guess = second_guess + third_dx[63:29];
        third_isneg = second_isneg;
        third_x = second_x;
        third_shift = second_shift;
    end


    reg [31:0] fourth_guess = 0;
    reg [31:0] fourth_x = 0;
    reg fourth_isneg = 0;
    wire [63:0] fourth_xy = third_x * third_guess;
    wire [63:0] fourth_dx = third_guess * (c_1d0 - fourth_xy[63:29]);
    reg [6:0] fourth_shift = 0;

    always @(negedge clk) begin
        fourth_guess = third_guess + fourth_dx[63:29];
        fourth_isneg = third_isneg;
        fourth_x = third_x;
        fourth_shift = third_shift;
    end

    // this is now Qx.44
    reg signed [63:0] res = 0;
    always @(posedge clk) begin
        res = fourth_guess << fourth_shift;
    end
    assign inv = fourth_isneg ? -res[62:30] : res[62:30];

endmodule
