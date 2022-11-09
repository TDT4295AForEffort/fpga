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
        input wire [9:0] hit_type,
        input wire signed [31:0] texture_index,
        input wire read_ray_ready,
        output wire send_new_ray,
        output wire [9:0] x, y,
        output wire [15:0] data,
        output wire pixwrite_enable
    );    
    reg [15:0] data_reg = 0;
    reg signed [10:0] ypos = 0;
    reg signed [31:0] bar_border_from_center = 0;
    reg [31:0] in_ray_reg = 0;
    reg signed [10:0] in_xpos_reg = 0;
    reg [9:0] hit_type_reg = 0;
    reg signed [31:0] texture_index_reg;
    reg pix_gen_busy = 0;
    reg send_new_ray_reg = 1;
    assign data = data_reg;
    assign x = in_xpos_reg;
    assign y = ypos;
    assign pixwrite_enable = pix_gen_busy;
    assign send_new_ray = send_new_ray_reg;

    wire [31:0] bar_border_from_center_wire;

    divq18_14 div_bar_border_from_center(clk100, 32'h35147a, in_ray_reg, bar_border_from_center_wire);

    always @(posedge clk100) begin

        if(pix_gen_busy == 0 && read_ray_ready == 1) begin
            in_ray_reg <= in_ray;
            in_xpos_reg <= in_xpos;
            hit_type_reg <= hit_type;
            texture_index_reg <= texture_index;
            pix_gen_busy <= 1;
            send_new_ray_reg <= 1;
        end else begin
            send_new_ray_reg <= 0;
        end

//        bar_border_from_center = 32'h35147a/in_ray_reg;

        // todo check timings and stuff bc this might off-by-one y position results or smth
        // todo like, y-positions 0-6 read prev x value's in_ray_reg
        bar_border_from_center = bar_border_from_center_wire;

        // make one pixel per 4 cycles, because that's how often you can write to a single slot.
        if (fourstate == 0 && pix_gen_busy == 1) begin
            if( (ypos > (240 + bar_border_from_center[31:15])) || (ypos < (240 - bar_border_from_center[31:15])) ) begin
                data_reg <= 16'hFFFF;
            end else begin
                if(hit_type_reg == 0) begin  
                    data_reg <= {texture_index_reg[13:9], 6'd127 - in_ray_reg[17:12], 5'b0};
                end else if(hit_type_reg == 1) begin 
                    data_reg <= {5'b0, 6'b0 ,6'd127 - in_ray_reg[17:12]};
                end
            end

            if (ypos+1 >= 480) begin
                ypos <= 0;
                pix_gen_busy <= 0;
            end else begin
                ypos <= ypos + 1;
            end 
        end
    end
endmodule
