`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2022 02:44:53 PM
// Design Name: 
// Module Name: ray_caster
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


module ray_caster(
        input wire clk100,
        input wire [1:0] fourstate,
        input wire send_new_ray,
        output wire [31:0] output_ray,
        output wire [9:0] output_xpos
    );

    initial begin
        bit_map[0] = 8'b11111111;
        bit_map[1] = 8'b10101011;
        bit_map[2] = 8'b10000001;
        bit_map[3] = 8'b11010101;
        bit_map[4] = 8'b10000001;
        bit_map[5] = 8'b10001011;
        bit_map[6] = 8'b10000001;
        bit_map[7] = 8'b11111111;

        player_direction[0] = 32'h2d41;
        player_direction[1] = 32'h2d41;

        player_pos[0] = 32'ha000; // = 2.5
        player_pos[1] = 32'h16000; // = 5.5
    end 

    // Internals
    reg [7:0] bit_map [7:0];
    reg [31:0] player_direction [1:0]; // [x,y] normalized
    reg [31:0] player_pos [1:0]; // [x, y]
    reg [31:0] hfov = 90 << 14;

    // Output
    reg [9:0] xpos = 0; 
    reg [31:0] output_ray_reg = 0;
    reg [9:0] output_xpos_reg = 0;

    assign output_ray = output_ray_reg;
    assign output_xpos = output_xpos_reg;

    //reg write_done = 0;
    always @(posedge clk100) begin 
        
        if (send_new_ray == 1) begin
            output_ray_reg = output_rays[xpos];
            output_xpos_reg = xpos;
            xpos = xpos + 1;
        end

        if (xpos+1 >= 640) begin
            xpos = 0;
        end
    end
    

endmodule
