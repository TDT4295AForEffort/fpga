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

        input wire [31:0] player_pos_x,
        input wire [31:0] player_pos_y,

        output wire [31:0] output_ray,
        output wire [9:0] output_xpos,
        output wire read_ray_ready
    );

    // Output
    reg [9:0] xpos = 0; 
    reg signed [31:0] output_ray_reg = 0;
    reg [9:0] output_xpos_reg = 0;
    reg read_ray_ready_reg = 0;

    assign output_ray = output_ray_reg;
    assign output_xpos = output_xpos_reg;
    assign read_ray_ready = read_ray_ready_reg;

    initial begin
        bit_map[0] = 8'b11111111;
        bit_map[1] = 8'b10000001;
        bit_map[2] = 8'b10000001;
        bit_map[3] = 8'b10000001;
        bit_map[4] = 8'b10000001;
        bit_map[5] = 8'b10000001;
        bit_map[6] = 8'b10000001;
        bit_map[7] = 8'b11111111;

        player_direction[0] = 32'h2d41;
        player_direction[1] = 32'h2d41;

        r_d_far_left[0] = 32'h0;
        r_d_far_left[1] = -32'h0400; 

        r_d_far_right[0] = 32'h0400;
        r_d_far_right[1] = 32'h0;

    end 

    // Internals
    reg signed [7:0] bit_map [7:0];
    reg signed [31:0] player_direction [1:0]; // [x,y] normalized
    reg signed [31:0] player_pos [1:0]; // [x, y]
    reg signed [31:0] hfov = 90 << 14;
    reg signed [31:0] r_now [1:0];
    reg signed [31:0] r_prev [1:0];
    reg signed [31:0] r_d_far_left [1:0];
    reg signed [31:0] r_d_far_right [1:0];
    reg signed [31:0] r_d [1:0];
    //reg signed [31:0] r_d_temp [1:0];
    //reg signed [31:0] r_d_temp_change [1:0];
    reg [9:0] ray_cast_state = 0; 
    reg signed [31:0] r_now_floored [1:0];
    reg signed [31:0] r_prev_floored [1:0];
    reg signed [31:0] player_positions [19:0];

    reg signed [31:0] abs_dx = 0;
    reg signed [31:0] abs_dy = 0;
    wire signed [31:0] r_d0_init;
    wire signed [31:0] r_d1_init;
    mulq18_14 r_d0_generator((r_d_far_right[0] - r_d_far_left[0]),((1 + xpos) * 32'h19),  r_d0_init);
    mulq18_14 r_d1_generator((r_d_far_right[1] - r_d_far_left[1]),((1 + xpos) * 32'h19),  r_d1_init);

    reg signed [31:0] texture_index = 0;

    
    always @(posedge clk100) begin 

        player_pos[0] <= player_pos_x;
        player_pos[1] <= player_pos_y;
        if (ray_cast_state == 0) begin // init stuff
            r_prev[0] <= player_pos[0]; // init prev
            r_prev[1] <= player_pos[1];
            r_now[0] <= player_pos[0]; // init r_now
            r_now[1] <= player_pos[1];
            r_d[0] <= r_d_far_left[0] + r_d0_init; // init r_d
            r_d[1] <= r_d_far_left[1] + r_d1_init;
            if(r_d[0] != 0 && r_d[1] != 0) begin
                ray_cast_state <= 2;
            end
        end

        if (ray_cast_state == 1) begin // Check collision
                if(bit_map[r_now_floored[1] >> 14][r_now_floored[0] >> 14] == 1) begin
                    ray_cast_state <= 3;
                end else begin 
                    ray_cast_state <= 2;
            end
        end

        if (ray_cast_state == 2) begin // Normal Increment rays, update r_now_floored
            r_prev[0] <= r_now[0];
            r_prev[1] <= r_now[1];
            r_now[0] <= r_now[0] + r_d[0];
            r_now[1] <= r_now[1] + r_d[1];
            r_now_floored[0] <= (r_now[0] + r_d[0]) & 32'b11111111111111111100000000000000;
            r_now_floored[1] <= (r_now[1] + r_d[1]) & 32'b11111111111111111100000000000000;
            r_prev_floored[0] <= r_now[0] & 32'b11111111111111111100000000000000;
            r_prev_floored[1] <= r_now[1] & 32'b11111111111111111100000000000000;
            ray_cast_state <= 1;
        end

        if (ray_cast_state == 3) begin 
            abs_dx <= player_pos[0] - r_now[0] >= 0 ? player_pos[0] - r_now[0] : r_now[0] - player_pos[0];
            abs_dy <= player_pos[1] - r_now[1] >= 0 ? player_pos[1] - r_now[1] : r_now[1] - player_pos[1];
            ray_cast_state <= 4;
        end
        

        if (ray_cast_state == 4) begin // Calculate distance
            //Output
            output_ray_reg <= abs_dx < abs_dy ? (32'h1a3d*abs_dx >> 14) + (32'h3c3d*abs_dy >> 14) : (32'h1a3d*abs_dy >> 14) + (32'h3c3d*abs_dx >> 14); // Magic number = 0.41, 0.941246
            output_xpos_reg <= xpos;
            read_ray_ready_reg <= 1;
            
            // reset
            r_d[0] <= 0;
            r_d[1] <= 0;

            // increment
            if (xpos+1 >= 640) begin
                xpos <= 0;
            end else begin 
                xpos <= xpos + 1;
            end
            ray_cast_state <= 5;
        end

        if (ray_cast_state == 5) begin
            if (send_new_ray == 1) begin 
                ray_cast_state <= 0;
                read_ray_ready_reg <= 0;
            end
        end

    end
    

endmodule
