`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2022 03:53:37 PM
// Design Name: 
// Module Name: line_intersection
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


module line_intersection(
    
    input clk100,
    input wire signed [31:0] x1,
    input wire signed [31:0] y1,
    input wire signed [31:0] x2,
    input wire signed [31:0] y2,
    input wire signed [31:0] x3,
    input wire signed [31:0] y3,
    input wire signed [31:0] x4,
    input wire signed [31:0] y4,
    input wire start,
    output wire collision,
    output wire signed [31:0] col_point_x,
    output wire signed [31:0] col_point_y,
    output wire read_ready
    );

    //Output
    reg collision_reg = 0;
    assign collision = collision_reg;
    reg read_ready_reg = 0;
    assign read_ready = read_ready_reg;
    reg col_point_x_reg = 0;
    assign col_point_x = col_point_x_reg;
    reg col_point_y_reg = 0;
    assign col_point_y = col_point_y_reg;

    reg [9:0] state = 0;
    reg signed [31:0] s = 0;
    reg signed [31:0] t = 0;

    always @(posedge clk100) begin
        if(state == 0 && start == 1) begin
            read_ready_reg <= 0;
            s <= ((y3-y1)*(x4-x3) - (x3-x1)*(y4-y3))/((x4-x3)*(y2-y1) - (x2-x1)*(y4-y3)) << 14;
            t <= ((x2-x1)*(y3-y1)-(y2-y1)*(x3-x1))/((x4-x3)*(y2-y1)-(x2-x1)*(y4-y3)) << 14;
            state <= 1;
        end

        if(state >= 1 && state <= 5) begin 
            state <= state + 1;
        end

        if(state == 6) begin 
            if(0 <= s && t <= 1) begin
                collision_reg <= 1;
                col_point_x_reg <= x1 + (s*(x2-x1) >> 14);
                col_point_y_reg <= y1 + (s*(y2-y1) >> 14);
            end else begin 
                collision_reg <= 0;
                col_point_x_reg <= 0;
                col_point_y_reg <= 0;
            end
            read_ready_reg <= 1;
            state <= 0;
        end
    end
endmodule
