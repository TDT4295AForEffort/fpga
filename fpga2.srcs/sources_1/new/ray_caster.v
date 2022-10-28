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
        bit_map[3] = 8'b10001001;
        bit_map[4] = 8'b10000001;
        bit_map[5] = 8'b10000001;
        bit_map[6] = 8'b10000001;
        bit_map[7] = 8'b11111111;

        player_direction[0] = 32'h2d41;
        player_direction[1] = 32'h2d41;

        player_pos[0] = 32'ha000; // = 2.5
        player_pos[1] = 32'h16000; // = 5.5

        r_d_far_left[0] = 32'h0; //(0,0.5)
        r_d_far_left[1] = -32'h2000; 

        r_d_far_right[0] = 32'h2000; //(-0.5, 0)
        r_d_far_right[1] = 32'h0;


        player_positions[0] = 32'h8000;
        player_positions[1] = 32'h18000;
        player_positions[2] = 32'h8666;
        player_positions[3] = 32'h17999;
        player_positions[4] = 32'h8ccc;
        player_positions[5] = 32'h17333;
        player_positions[6] = 32'h9333;
        player_positions[7] = 32'h16ccc;
        player_positions[8] = 32'h9999;
        player_positions[9] = 32'h16666;
        player_positions[10] = 32'ha000;
        player_positions[11] = 32'h16000;
        player_positions[12] = 32'ha666;
        player_positions[13] = 32'h15999;
        player_positions[14] = 32'haccc;
        player_positions[15] = 32'h15333;
        player_positions[16] = 32'hb333;
        player_positions[17] = 32'h14ccc;
        player_positions[18] = 32'hb999;
        player_positions[19] = 32'h14666;

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
    reg [9:0] ray_cast_state = 0; 
    reg signed [31:0] r_now_floored [1:0];
    reg [9:0] counter = 0;
    reg signed [31:0] player_positions [19:0];


    reg signed [31:0] abs_dx; 
    reg signed [31:0] abs_dy;
    wire signed [31:0] r_d0_init;
    wire signed [31:0] r_d1_init;
    mulq18_14 r_d0_generator((r_d_far_right[0] - r_d_far_left[0]),((1 + xpos) * 32'h19),  r_d0_init);
    mulq18_14 r_d1_generator((r_d_far_right[1] - r_d_far_left[1]),((1 + xpos) * 32'h19),  r_d1_init);

    always @(posedge clk100) begin 

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
            if(bit_map[r_now_floored[1]][r_now_floored[0]] == 1) begin
                ray_cast_state <= 3;
            end else begin 
                ray_cast_state <= 2;
            end
        end

        if (ray_cast_state == 2) begin // Increment rays, update r_now_floored
            r_prev[0] <= r_now[0];
            r_prev[1] <= r_now[1];
            r_now[0] <= r_now[0] + r_d[0];
            r_now[1] <= r_now[1] + r_d[1];
            r_now_floored[0] <= r_now[0] >> 14;
            r_now_floored[1] <= r_now[1] >> 14;
            ray_cast_state <= 1;
        end
        
        abs_dx <= player_pos[0] - r_now[0] >= 0 ? player_pos[0] - r_now[0] : r_now[0] - player_pos[0];
        abs_dy <= player_pos[1] - r_now[1] >= 0 ? player_pos[1] - r_now[1] : r_now[1] - player_pos[1];

        if (ray_cast_state == 3) begin // Calculate distance
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
                counter <= counter + 1; // Code to handle shifting perspective
                if(counter >= 0 && counter <= 60) begin
                    player_pos[0] <= player_positions[0];
                    player_pos[1] <= player_positions[1];
                end else if(counter >= 60 && counter <= 120) begin
                    player_pos[0] <= player_positions[2];
                    player_pos[1] <= player_positions[3];
                end else if(counter >= 120 && counter <= 180) begin
                    player_pos[0] <= player_positions[4];
                    player_pos[1] <= player_positions[5];
                end else if(counter >= 180 && counter <= 240) begin
                    player_pos[0] <= player_positions[6];
                    player_pos[1] <= player_positions[7];
                end else if(counter >= 240 && counter <= 300) begin
                    player_pos[0] <= player_positions[8];
                    player_pos[1] <= player_positions[9];
                end else if(counter >= 300 && counter <= 360) begin
                    player_pos[0] <= player_positions[10];
                    player_pos[1] <= player_positions[11];
                end else if(counter >= 360 && counter <= 420) begin
                    player_pos[0] <= player_positions[12];
                    player_pos[1] <= player_positions[13];
                end else if(counter >= 420 && counter <= 480) begin
                    player_pos[0] <= player_positions[14];
                    player_pos[1] <= player_positions[15];
                end else if(counter >= 480 && counter <= 540) begin
                    player_pos[0] <= player_positions[16];
                    player_pos[1] <= player_positions[17];
                end else if(counter >= 540 && counter <= 600) begin
                    player_pos[0] <= player_positions[18];
                    player_pos[1] <= player_positions[19];
                    counter <= 0;
                end

            end else begin 
                xpos <= xpos + 1;
            end
            ray_cast_state <= 4;
        end

        if (ray_cast_state == 4) begin
            if (send_new_ray == 1) begin 
                ray_cast_state <= 0;
                read_ray_ready_reg <= 0;
            end
        end


        
        //end


    end
    

endmodule
