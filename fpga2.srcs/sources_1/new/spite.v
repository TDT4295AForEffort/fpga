`timescale 1ns / 1ps
`default_nettype none

// spite: spi state manager
// reads bytes from the spi module and distributes them
// author: @olepbr
module spite(
    input wire clk,
    input wire spi_byte_ready,
    input wire ss_fall,
    input  wire [7:0]  byte_in,
    output wire [15:0] pack_size,
    output wire [31:0] x_pos,
    output wire [31:0] x_dir,
    output wire [31:0] x_90_left,
    output wire [31:0] x_90_right,
    output wire [31:0] x_45_left,
    output wire [31:0] x_45_right,
    output wire [31:0] y_pos,
    output wire [31:0] y_dir,
    output wire [31:0] y_90_left,
    output wire [31:0] y_90_right,
    output wire [31:0] y_45_left,
    output wire [31:0] y_45_right,
    output wire [31:0] en_1_x,
    output wire [31:0] en_1_y,
    output wire [31:0] en_2_x,
    output wire [31:0] en_2_y,
    output wire [4095:0] map_arr,
    output wire [13:0] count
    );

    reg [15:0] pack_size_out_reg = 0;
    reg [15:0] pack_size_im_reg = 0;
    reg [7:0]  pack_mode = 8'b0;
    reg [7:0]  free_byte = 8'b0;
    reg [31:0] x_pos_im_reg = 0;
    reg [31:0] x_pos_out_reg = 0;
    reg [31:0] x_dir_im_reg = 0;
    reg [31:0] x_dir_out_reg = 0;
    reg [31:0] x_90_left_im_reg = 0;
    reg [31:0] x_90_left_out_reg = 0;
    reg [31:0] x_90_right_im_reg = 0;
    reg [31:0] x_90_right_out_reg = 0;
    reg [31:0] x_45_left_im_reg = 0;
    reg [31:0] x_45_left_out_reg = 0;
    reg [31:0] x_45_right_im_reg = 0;
    reg [31:0] x_45_right_out_reg = 0;
    reg [31:0] y_pos_im_reg = 0;
    reg [31:0] y_pos_out_reg = 0;
    reg [31:0] y_dir_im_reg = 0;
    reg [31:0] y_dir_out_reg = 0;
    reg [31:0] y_90_left_im_reg = 0;
    reg [31:0] y_90_left_out_reg = 0;
    reg [31:0] y_90_right_im_reg = 0;
    reg [31:0] y_90_right_out_reg = 0;
    reg [31:0] y_45_left_im_reg = 0;
    reg [31:0] y_45_left_out_reg = 0;
    reg [31:0] y_45_right_im_reg = 0;
    reg [31:0] y_45_right_out_reg = 0;
    reg [31:0] en_1_x_im_reg = 0;
    reg [31:0] en_1_x_out_reg = 0;
    reg [31:0] en_1_y_im_reg = 0;
    reg [31:0] en_1_y_out_reg = 0;
    reg [31:0] en_2_x_im_reg = 0;
    reg [31:0] en_2_x_out_reg = 0;
    reg [31:0] en_2_y_im_reg = 0;
    reg [31:0] en_2_y_out_reg = 0;
    reg [4095:0] map_arr_im_reg = 0;
    reg [4095:0] map_arr_out_reg = 0;
    reg [13:0] byte_count = 14'b0;

    assign pack_size   = pack_size_out_reg;
    assign x_pos       = x_pos_out_reg;
    assign x_dir       = x_dir_out_reg;
    assign x_90_left   = x_90_left_out_reg;
    assign x_90_right  = x_90_right_out_reg;
    assign x_45_left   = x_45_left_out_reg;
    assign x_45_right  = x_45_right_out_reg;
    assign y_pos       = y_pos_out_reg;
    assign y_dir       = y_dir_out_reg;
    assign y_90_left   = y_90_left_out_reg;
    assign y_90_right  = y_90_right_out_reg;
    assign y_45_left   = y_45_left_out_reg;
    assign y_45_right  = y_45_right_out_reg;
    assign en_1_x      = en_1_x_out_reg;
    assign en_1_y      = en_1_y_out_reg;
    assign en_2_x      = en_2_x_out_reg;
    assign en_2_y      = en_2_y_out_reg;
    assign map_arr     = map_arr_out_reg;
    assign count       = byte_count;

    always @(posedge clk)
    if (ss_fall)
        byte_count <= 0; // reset byte count when ss goes low
    else if (spi_byte_ready)
        byte_count <= byte_count + 1;

    always @(posedge clk)
        if (byte_count < 2) begin // we're at the start of the game state
        pack_size_im_reg[(15 - (byte_count)*8)-:8] <= byte_in;
    end
    else if (byte_count == 2) begin
        pack_size_out_reg <= pack_size_im_reg;
        pack_mode <= byte_in;
    end
    else if (byte_count == 3) begin
        free_byte <= byte_in;
    end
    else if (byte_count < 8)
        x_pos_im_reg[31 - (byte_count - 4)*8-:8] <= byte_in;
    else if (byte_count < 12) begin
        x_pos_out_reg <= x_pos_im_reg;
        y_pos_im_reg[31 - (byte_count - 8)*8-:8] <= byte_in;
    end
    else if (byte_count < 16) begin
        y_pos_out_reg <= y_pos_im_reg;
        x_dir_im_reg[31 - (byte_count - 12)*8-:8] <= byte_in;
    end
    else if (byte_count < 20) begin
        x_dir_out_reg <= x_dir_im_reg;
        y_dir_im_reg[31 - (byte_count - 16)*8-:8] <= byte_in;
    end
    else if (byte_count < 532) begin
        map_arr_im_reg[(4095 - ((byte_count - 20)*8))-:8] <= byte_in;
    end
    else if (byte_count < 536) begin
        map_arr_out_reg <= map_arr_im_reg;
        x_90_left_im_reg[31 - (byte_count - 532)*8-:8] <= byte_in;
    end
    else if (byte_count < 540) begin
        x_90_left_out_reg <= x_90_left_im_reg;
        y_90_left_im_reg[31 - (byte_count - 536)*8-:8] <= byte_in;
    end
    else if (byte_count < 544) begin
        y_90_left_out_reg <= y_90_left_im_reg;
        x_45_left_im_reg[31 - (byte_count - 540)*8-:8] <= byte_in;
    end
    else if (byte_count < 548) begin
        x_45_left_out_reg <= x_45_left_im_reg;
        y_45_left_im_reg[31 - (byte_count - 544)*8-:8] <= byte_in;
    end
    else if (byte_count < 552) begin
        y_45_left_out_reg <= y_45_left_im_reg;
        x_45_right_im_reg[31 - (byte_count - 548)*8-:8] <= byte_in;
    end
    else if (byte_count < 556) begin
        x_45_right_out_reg <= x_45_right_im_reg;
        y_45_right_im_reg[31 - (byte_count - 552)*8-:8] <= byte_in;
    end
    else if (byte_count < 560) begin
        y_45_right_out_reg <= y_45_right_im_reg;
        x_90_right_im_reg[31 - (byte_count - 556)*8-:8] <= byte_in;
    end
    else if (byte_count < 564) begin
        x_90_right_out_reg <= x_90_right_im_reg;
        y_90_right_im_reg[31 - (byte_count - 560)*8-:8] <= byte_in;
    end
    else if (byte_count < 568) begin
        y_90_right_out_reg <= y_90_right_im_reg;
        en_1_x_im_reg[31 - (byte_count - 564)*8-:8] <= byte_in;
    end
    else if (byte_count < 572) begin
        en_1_x_out_reg <= en_1_x_im_reg;
        en_1_y_im_reg[31 - (byte_count - 568)*8-:8] <= byte_in;
    end
    else if (byte_count < 576) begin
        en_1_y_out_reg <= en_1_y_im_reg;
        en_2_x_im_reg[31 - (byte_count - 572)*8-:8] <= byte_in;
    end
    else if (byte_count < 580) begin
        en_2_x_out_reg <= en_2_x_im_reg;
        en_2_y_im_reg[31 - (byte_count - 576)*8-:8] <= byte_in;
    end
    else
        en_2_y_out_reg <= en_2_y_im_reg;

endmodule
