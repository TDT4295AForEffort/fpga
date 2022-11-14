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
    output wire [31:0] y_pos,
    output wire [31:0] y_dir,
    output wire [7:0] map_state     [63:0][63:0],
    output wire [7:0] block_tex_ids [63:0][63:0],
    output wire [13:0] count
    );

    reg [15:0] pack_size_reg;
    assign pack_size = pack_size_reg;
    reg [15:0] pack_size_im_reg;
    reg [7:0]  pack_mode = 8'b0;
    reg [7:0]  free_byte = 8'b0;
    reg [31:0] x_pos_im_reg;
    reg [31:0] x_pos_out_reg;
    reg [31:0] x_dir_im_reg;
    reg [31:0] x_dir_out_reg;
    reg [31:0] y_pos_im_reg ;
    reg [31:0] y_pos_out_reg;
    reg [31:0] y_dir_im_reg ;
    reg [31:0] y_dir_out_reg;
    reg [7:0]  map_state_im_reg [63:0][63:0];
    reg [7:0]  map_state_out_reg [63:0][63:0];
    reg [7:0]  block_tex_im_reg [63:0][63:0];
    reg [7:0]  block_tex_out_reg [63:0][63:0];
    reg [13:0] byte_count = 14'b0;
    assign count = byte_count;

    assign x_pos = x_pos_out_reg;
    assign x_dir = x_dir_out_reg;
    assign y_pos = y_pos_out_reg;
    assign y_dir = y_dir_out_reg;
    // assign map_state = map_state_out_reg;
    // assign block_tex_ids = block_tex_out_reg;

    always @(posedge clk)
    if (ss_fall)
        byte_count <= 0; // reset byte count when ss goes low
    else if (spi_byte_ready)
        byte_count <= byte_count + 1;

    always @(posedge clk)
    if (byte_count <= 2) // we're at the start of the game state
        pack_size_im_reg[(15 - (byte_count)*8)-:8] <= byte_in;
    else if (byte_count == 3) begin
        pack_size_reg <= pack_size_im_reg;
        pack_mode <= byte_in;
    end
    else if (byte_count == 4) begin
        free_byte <= byte_in;
    end
    else if (byte_count <= 8)
        x_pos_im_reg[31 - (byte_count % 4)*8-:8] <= byte_in;
    else if (byte_count <= 12) begin
        x_pos_out_reg <= x_pos_im_reg;
        x_dir_im_reg[31 - (byte_count % 8)*8-:8] <= byte_in;
    end
    else if (byte_count <= 16) begin
        x_dir_out_reg <= x_dir_im_reg;
        y_pos_im_reg[31 - (byte_count % 12)*8-:8] <= byte_in;
    end
    else if (byte_count <= 20) begin
        y_pos_out_reg <= y_pos_im_reg;
        y_dir_im_reg[31 - (byte_count % 16)*8-:8] <= byte_in;
    end
    else if (byte_count <= 4116) begin
        y_dir_out_reg <= y_dir_im_reg;
        if (byte_count == 4116)
            map_state_out_reg <= map_state_im_reg;
        else
            map_state_im_reg[(byte_count - 20) % 64][(byte_count - 20) >> 6] <= byte_in;
    end
    else if (byte_count < 8212) begin
        if (byte_count == 8212)
            block_tex_out_reg <= block_tex_im_reg;
        else
            block_tex_im_reg[(byte_count - 4116) % 64][(byte_count - 4116) >> 6] <= byte_in;
    end

endmodule
