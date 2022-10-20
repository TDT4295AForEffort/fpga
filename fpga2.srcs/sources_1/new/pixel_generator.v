`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2022 01:13:37 PM
// Design Name: 
// Module Name: pixel_generator
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


module pixel_generator(
        input wire clk100,
        input wire [1:0] fourstate,
        input wire [31:0] in_ray,
        input wire [9:0] in_xpos,
        output wire send_new_ray,
        output wire [9:0] x, y,
        output wire [15:0] data,
        output wire pixwrite_enable
    );    
    reg [15:0] data_reg = 0;
    reg [9:0] ypos = 0;
    reg [31:0] bar_border_from_center = 0;
    reg [31:0] in_ray_reg = 0;
    reg [9:0] in_xpos_reg = 0;
    reg pix_gen_busy = 0;
    reg send_new_ray_reg = 0;
    assign data = data_reg;
    assign x = in_xpos_reg;
    assign y = ypos;
    assign pixwrite_enable = pix_gen_busy;
    assign send_new_ray = send_new_ray_reg;
    

    always @(posedge clk100) begin

        if(pix_gen_busy == 0) begin
            send_new_ray_reg = 1;
            pix_gen_busy = 1;
        end else begin 
            send_new_ray_reg = 0;
        end

        in_ray_reg = in_ray;
        in_xpos_reg = in_xpos;
        bar_border_from_center = 663500/in_ray_reg;

        // make one pixel per 4 cycles, because that's how often you can write to a single slot.
        if (fourstate == 0 && pix_gen_busy == 1) begin
            if( (ypos > (240 + bar_border_from_center)) || (ypos < (240 - bar_border_from_center)) ) begin
                data_reg = 16'hFFFF;
            end else begin 
                data_reg = {5'b0, 128 - in_ray_reg[17:12], 6'b0};
                //data_reg = {5'b00111, 6'b0, in_ray_reg[14:11]};
            end

            if (ypos+1 >= 480) begin
                ypos = 0;
                pix_gen_busy = 0;
            end else begin
                ypos = ypos + 1;
            end 
        end
    end
endmodule
