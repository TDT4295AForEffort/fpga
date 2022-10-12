`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2022 04:07:36 PM
// Design Name: 
// Module Name: sram_controller
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

// Manages a 100MHz memory module (10ns), with currently 2, could do up to 4, ports @ 25MHz
// each port has a 10ns window of access out of 40ns, they can write to their port for the full 40ns,
// or they can try to perfectly time their writes to the 10ns window they own the ram,
// but the former would be more flexible.
// Currently used by pixel reading, and pixel writing.
// Pixel reading is synced to a 10ns window of reading,
// pixel writing could be either 10ns or 40ns.
module sram_controller(
        // ~100mhz clock, needs to be synced to ~25mhz vga
        input wire clk100,
        input wire [1:0] clk100_4state,

        // read 16bit pixels from framebuffer to vga out, by x and y coordinates, with signal/'clock' for when it returns
        input wire [9:0] pixread_x, pixread_y,
        output wire [15:0] pixread_data,
        output wire pixread_valid,

        // write 16bit pixels to framebuffer, by x and y coordinates, with write-enable bit.
        input wire [9:0] pixwrite_x, pixwrite_y, 
        input wire [15:0] pixwrite_data, 
        input wire pixwrite_enable,

        // connection to actual ram module
        output wire [19:0] sram_addr,
        input wire [15:0] sram_data_out,
        output wire [15:0] sram_data_in,
        output wire sram_write
    );
    
    // temporary wrap mapping for the 25's limited bram
    reg [9:0] pixread_x_half = 0;
    reg [9:0] pixread_y_half = 0;
    wire [19:0] addr_pix_read = pixread_y_half * 320 + pixread_x_half;
    wire [19:0] addr_pix_write = pixwrite_y * 320 + pixwrite_x;
    
    always @(posedge clk100) begin
        pixread_x_half = pixread_x >= 320 ? pixread_x-320 : pixread_x;
        pixread_y_half = pixread_y >= 240 ? pixread_y-240 : pixread_y;
    end
    
    
    // which of 4 states the read address should be read during
    localparam pix_read_addr_state = 2;
    // which of 4 states the read result comes back for
    localparam pix_read_return_state = 0;
    
    localparam pix_write_addr_state = 0;

    // address select, which "port" controls the address this cycle.
    assign sram_addr = 
        (clk100_4state == pix_read_addr_state ? addr_pix_read :
        (clk100_4state == pix_write_addr_state ? addr_pix_write : 0)
        );

    // read data is currently always pixel read, it is valid after a delay
    assign pixread_data = sram_data_out;
    assign pixread_valid = clk100_4state == pix_read_return_state;

    // write if it's the pixel write port's turn, and it is writing
    assign sram_write = (clk100_4state == pix_write_addr_state) && pixwrite_enable;
    assign sram_data_in = pixwrite_data;

endmodule : sram_controller
