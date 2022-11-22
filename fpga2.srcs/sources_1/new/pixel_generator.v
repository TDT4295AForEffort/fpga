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

    initial begin
        creeper_face[0] = 8'b00000000;
        creeper_face[1] = 8'b01100110;
        creeper_face[2] = 8'b01100110;
        creeper_face[3] = 8'b00011000;
        creeper_face[4] = 8'b00111100;
        creeper_face[5] = 8'b00111100;
        creeper_face[6] = 8'b00100100;
        creeper_face[7] = 8'b00000000;

        block_face[0] = 8'b11111111;
        block_face[1] = 8'b10001001;
        block_face[2] = 8'b10100001;
        block_face[3] = 8'b10000011;
        block_face[4] = 8'b10000101;
        block_face[5] = 8'b11010001;
        block_face[6] = 8'b10100011;
        block_face[7] = 8'b11111111;

    end

    reg [15:0] data_reg = 0;
    reg signed [10:0] ypos = 0;
    reg signed [31:0] bar_border_from_center = 0;
    reg [31:0] in_ray_reg = 0;
    reg signed [10:0] in_xpos_reg = 0;
    reg [9:0] hit_type_reg = 0;
    reg signed [31:0] texture_index_reg;
    reg pix_gen_busy = 0;
    reg send_new_ray_reg = 1;
    reg [31:0] ytex_creeper = 0;
    reg [31:0] ytex_block = 0;
    reg [7:0] creeper_face [7:0];
    reg [7:0] block_face [7:0];
    // wire dark_black = 00100_001000_00100; // 0
    // wire light_black = 00101_001010_00101; // 1
    // wire medium_green = 01010_101100_01001; // 2
    // wire dark_green = 00100_010111_00011; // 3
    assign data = data_reg;
    assign x = in_xpos_reg;
    assign y = ypos;
    assign pixwrite_enable = pix_gen_busy;
    assign send_new_ray = send_new_ray_reg;

    wire [31:0] bar_border_from_center_wire;
    divq18_14 div_bar_border_from_center(clk100, 32'h9f3d6e, in_ray_reg, bar_border_from_center_wire);
    wire signed [31:0] border0 = 240 - (bar_border_from_center >> 14);
    wire signed [31:0] border1_16 = 240 - (bar_border_from_center >> 14) + ((bar_border_from_center >> 14) >> 3);
    wire signed [31:0] border2_16 = 240 - (bar_border_from_center >> 14) + ((bar_border_from_center >> 14) >> 2);
    wire signed [31:0] border3_16 = 240 - (bar_border_from_center >> 14) + ((bar_border_from_center >> 14) >> 2) + ((bar_border_from_center >> 14) >> 3);
    wire signed [31:0] border4_16 = 240 - ((bar_border_from_center >> 14) >> 1);
    wire signed [31:0] border5_16 = 240 - ((bar_border_from_center >> 14) >> 1) + ((bar_border_from_center >> 14) >> 3);
    wire signed [31:0] border6_16 = 240 - ((bar_border_from_center >> 14) >> 2);
    wire signed [31:0] border7_16 = 240 - ((bar_border_from_center >> 14) >> 2) + ((bar_border_from_center >> 14) >> 3);
    wire signed [31:0] border1 = 240 + (bar_border_from_center >> 14);

    // For blocks only 
    wire signed [31:0] border4_8 = 240;
    wire signed [31:0] border5_8 = 240 + ((bar_border_from_center >> 14) >> 2);
    wire signed [31:0] border6_8 = 240 + ((bar_border_from_center >> 14) >> 1);
    wire signed [31:0] border7_8 = 240 + ((bar_border_from_center >> 14) >> 1) + ((bar_border_from_center >> 14) >> 2);

    // ila_0 ila (
    //     .clk(clk100),
    //        .probe0(in_xpos_reg),
    //        .probe1(ypos),
    //        .probe2(data_reg),
    //        .probe3(in_ray_reg),
    //        .probe4(border1)
    //     );


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
        bar_border_from_center <= bar_border_from_center_wire;

        // Creeper borders
        if(ypos < border1_16) begin 
            ytex_creeper <= 0;
        end else if(ypos < border2_16) begin 
            ytex_creeper <= 1;
        end else if(ypos < border3_16) begin 
            ytex_creeper <= 2;
        end else if (ypos < border4_16) begin 
            ytex_creeper <= 3;
        end else if(ypos < border5_16) begin 
            ytex_creeper <= 4;
        end else if (ypos < border6_16) begin 
            ytex_creeper <= 5;
        end else if(ypos < border7_16) begin 
            ytex_creeper <= 6;
        end else begin //ypos above 1/2
            ytex_creeper <= 7;
        end

        // Block border 
        if(ypos < border2_16) begin 
            ytex_block <= 0;
        end else if(ypos < border4_16) begin 
            ytex_block <= 1;
        end else if(ypos < border6_16) begin 
            ytex_block <= 2;
        end else if (ypos < border4_8) begin 
            ytex_block <= 3;
        end else if(ypos < border5_8) begin 
            ytex_block <= 4;
        end else if (ypos < border6_8) begin 
            ytex_block <= 5;
        end else if(ypos < border7_8) begin 
            ytex_block <= 6;
        end else begin //ypos above 1/2
            ytex_block <= 7;
        end 

        // make one pixel per 4 cycles, because that's how often you can write to a single slot.
        if (fourstate == 0 && pix_gen_busy == 1) begin
            if((ypos > border1) && (border1 <= 480)) begin // If on floor
                data_reg <= 16'b00110_011001_00000;
            end else if((ypos < border0) && border0 >= 0) begin // If on ceiling
                data_reg <= 16'b11111_111111_10101;
            end else begin
                if(hit_type_reg == 0) begin  // block hit
                    if(block_face[ytex_block][texture_index_reg[13:11]] == 0) begin 
                        data_reg <= 16'b00000_010011_10011; // dark
                    end else begin 
                        data_reg <= 16'b00000_011000_10010; // light
                    end
                    //data_reg <= {texture_index_reg[13:9], 6'd127 - in_ray_reg[17:12], 5'b0};
                end else if(hit_type_reg == 1) begin // Monster
                    if(creeper_face[ytex_creeper][texture_index_reg[13:11]] == 0) begin 
                        data_reg <= 16'b01010_101100_01001; // greenish
                    end else begin 
                        data_reg <= 16'b00100_001000_00100; // dark
                    end
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
