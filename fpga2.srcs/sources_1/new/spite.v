`timescale 1ns / 1ps
`default_nettype none

// spite: spi state manager
// reads bytes from the spi module and distributes them
// author: @olepbr
module spite(
    input wire clk,
    input wire spi_byte_ready,
    input  wire [7:0] byte_in,
    output wire [31:0] x_pos,
    output wire [31:0] x_dir,
    output wire [31:0] y_pos,
    output wire [31:0] y_dir,
    output wire [7:0] map_state     [63:0][63:0],
    output wire [7:0] block_tex_ids [63:0][63:0]
    );

    reg [7:0]  pack_size [1:0]; 
    reg [7:0]  pack_mode = 8'b0;
    reg [7:0]  free_byte = 8'b0;
    reg [7:0]  x_pos_im_reg  [3:0];
    reg [7:0]  x_pos_out_reg [3:0];
    reg [7:0]  x_dir_im_reg  [3:0];
    reg [7:0]  x_dir_out_reg [3:0];
    reg [7:0]  y_pos_im_reg  [3:0];
    reg [7:0]  y_pos_out_reg [3:0];
    reg [7:0]  y_dir_im_reg  [3:0];
    reg [7:0]  y_dir_out_reg [3:0];
    reg [7:0]  map_state_im_reg [63:0][63:0];
    reg [7:0]  map_state_out_reg [63:0][63:0];
    reg [7:0]  block_tex_im_reg [63:0][63:0];
    reg [7:0]  block_tex_out_reg [63:0][63:0];
    reg [13:0] byte_count = 14'b0;

    assign x_pos = {x_pos_out_reg[3], x_pos_out_reg[2], x_pos_out_reg[1], x_pos_out_reg[0]};
    assign x_dir = {x_dir_out_reg[3], x_dir_out_reg[2], x_dir_out_reg[1], x_dir_out_reg[0]};
    assign y_pos = {y_pos_out_reg[3], y_pos_out_reg[2], y_pos_out_reg[1], y_pos_out_reg[0]};
    assign y_dir = {y_dir_out_reg[3], y_dir_out_reg[2], y_dir_out_reg[1], y_dir_out_reg[0]};
    // assign map_state = map_state_out_reg;
    // assign block_tex_ids = block_tex_out_reg;

    always @(posedge clk)
    if (spi_byte_ready)
        if (byte_count < 2) begin // we're at the start of the game state
            byte_count <= byte_count + 1; // count the byte
            pack_size[byte_count] <= byte_in;
            end
        else begin 
            if (byte_count < 3)
            byte_count <= byte_count + 1;
            pack_mode <= byte_in;
            end
        else if (byte_count < 4) begin
            byte_count <= byte_count + 1;
            free_byte <= byte_in;
            end
        else if (byte_count < 8) begin
            byte_count <= byte_count + 1;
            if (byte_count == 8)
                x_pos_out_reg <= x_pos_im_reg;
            else
                x_pos_im_reg[byte_count % 4] <= byte_in;
        end
        else if (byte_count < 12) begin
            byte_count <= byte_count + 1;
            if (byte_count == 12)
                x_dir_out_reg <= x_dir_im_reg;
            else
                x_dir_im_reg[byte_count % 4] <= byte_in;
        end
        else if (byte_count < 16) begin
            byte_count <= byte_count + 1;
            if (byte_count == 16)
                y_pos_out_reg <= y_pos_im_reg;
            else
                y_pos_im_reg[byte_count % 4] <= byte_in;
        end
        else if (byte_count < 20) begin
            byte_count <= byte_count + 1;
            if (byte_count == 20)
                y_dir_out_reg <= y_dir_im_reg;
            else
                y_dir_im_reg[byte_count % 4] <= byte_in;
        end
        else if (byte_count < 4116) begin
            byte_count <= byte_count + 1;
            if (byte_count == 4116)
                map_state_out_reg <= map_state_im_reg;
            else
                map_state_im_reg[(byte_count - 20) % 64][(byte_count - 20) >> 6] <= byte_in;
        end
        else if (byte_count < 8212) begin
            byte_count <= byte_count + 1;
            if (byte_count == 8212)
                block_tex_out_reg <= block_tex_im_reg;
            else
                block_tex_im_reg[(byte_count - 4116) % 64][(byte_count - 4116) >> 6] <= byte_in;
        end
        else
            byte_count <= 0;

endmodule
