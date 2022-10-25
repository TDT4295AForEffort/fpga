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
    reg signed [31:0] ar = {18'd0, 14'd128};
    reg signed [31:0] br = {18'd1, 2'd1,12'b0};
    reg signed [31:0] cr = 0;
    wire [31:0] a = ar;
    wire [31:0] b = br;
    wire [31:0] c;
    integer fd;
    initial fd = $fopen("/home/odderikf/code/compdes/fpga2/mult.txt", "w");

    invq18_14 inverter(clk100, a, c);
    always @(posedge clk100) begin
        cr = c;
        ar = ar + 4;
        $fwrite(fd, ar, br, c);
        $fwrite(fd, "\n");
    end
    initial begin
        repeat(20000000) begin
            clk100 <= ~clk100;
            #HPERIOD;
        end
        $fclose(fd);
        $finish;
    end
endmodule
