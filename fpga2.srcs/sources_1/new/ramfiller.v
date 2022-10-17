`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2022 06:07:47 PM
// Design Name: 
// Module Name: ramfiller
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

// Module to fill ram with a color test pattern,
// currently just fills a 320x240 screen, not full 640x480,
// because the A7-35 doesnt have enough blockram and we're not setting up ddr when our A7-100 won't have ddr.
// fills a small repeating box of red rightwards, green downwards,
// and a bigger full 320x240 screen box of blue downwards and rightwards. (slightly more rightwards)
module ramfiller(
        input wire clk100,
        input wire [1:0] fourstate,
        output wire [9:0] x, y,
        output wire [15:0] data 
    );
    // count up x and y, to fill individual pixels
    reg [9:0] xpos = 0;
    reg [9:0] ypos = 0;
    
    assign x = xpos;
    assign y = ypos;
    // red (5bit) is the lowest bits of x, so loops fast
    assign data[4:0] = xpos[4:0];
    // green (6bit) is the lowest bits of y, so loops fast
    assign data[10:5] = ypos[5:0];
    // blue (5bit) is the high bits of x + y, so loops slow.
    // losing the lowest y bit to keep it from double-carrying to overflow at all-ones both?
//    assign data[15:11] = xpos[9:5] + ypos[9:6];
    wire [31:0] c;
    assign data[15:11] = c[20:16];
    mulq18_14 bmulter({2, 16'b0}, {6'b0, xpos, 16'b0}, c);

    always @(posedge clk100) begin
        // make one pixel per 4 cycles, because that's how often you can write to a single slot.
        if (fourstate == 0) begin
            // loop for y for x, to prove a point, because vga output is x then y
            // count y up to 240, then reset to 0.
            // count x when y loops, up to 320, then reset to 0.
            if (ypos+1 >= 240) begin
                ypos = 0;
                if (xpos+1 >= 320) begin
                    xpos = 0;
                end else begin
                    xpos = xpos + 1;
                end
            end else begin
                ypos = ypos + 1;
            end
        end
    end
endmodule
