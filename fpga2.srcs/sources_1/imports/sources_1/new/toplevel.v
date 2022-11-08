`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2022 03:17:04 PM
// Design Name: 
// Module Name: vga_test
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

// top level access to pins, composition of parts, for TDT4295 2022 group A, raycasting
// this file should mostly just be wires, to connect overarching parts together,
// like pins to spi, spi to raycast, raycast to framebuf, framebuf to vga, vga to pins,
// maybe spi to ram.

// feel free to copy this file with a new name, set that as top in your local project,
// and mess with it for demos, or just mess with it as a branch or local-only demo,
// but git repo version of this file is for stuff mostly compatible with final product
module toplevel
	(
		input wire hw_clk,
		input wire [2:0] hw_sw,
		output wire hw_hsync, hw_vsync,
		output wire [3:0] hw_vga_out_red,
		output wire [3:0] hw_vga_out_green,
		output wire [3:0] hw_vga_out_blue,

		input wire [3:0] hw_btn
	);
	// possible universal reset signal for future
	wire reset = 0;
	// 100mhz clock, bc things are written with this assumption and it should be explicit
	wire clk100;
	// currently master clock is 100mhz.
	assign clk100 = hw_clk;
	
    // state register for 4-state operations in sync with 25MHz VGA out
	reg [1:0] clk100_4state = 0;
	always @(posedge(clk100))
	   clk100_4state = clk100_4state + 1;
	
    // // Trolling
    // reg [1:0] hw_vsync_4state = 0;
	// always @(posedge(hw_vsync))
	//    hw_vsync_4state = hw_vsync_4state + 1;
	
	
	// vga out synchronization and indexing logic
	wire video_on;
    wire [9:0] pixread_x;
    wire [9:0] y;    
    wire vgasync_reset = 0;
    vga_sync2 vgasync2 (vgasync_reset, clk100, clk100_4state,
        hw_hsync, hw_vsync, video_on,
        pixread_x, y);
        
    // wires for writing pixels to framebuffer.
    wire [15:0] pixwrite_data;
    wire pixwrite_enable;
    wire [9:0] pixwrite_x, pixwrite_y;
    
    // frame buffer write test
    wire [31:0] raycaster_output_ray;
    wire [9:0] raycaster_output_xpos;
    wire send_new_ray;
    wire read_ray_ready;

    // todo actual input from mcu instead of this
    // buttons control player position
    reg signed [63:0] player_pos_x;
    reg signed [63:0] player_pos_y;

    initial begin
        player_pos_x = 64'h8000<<32;
        player_pos_y = 64'h18000<<32;
    end
    always @(posedge clk100) begin
        if      (hw_btn[0]) player_pos_x = player_pos_x + (1<<21);
        else if (hw_btn[1]) player_pos_x = player_pos_x - (1<<21);
        if      (hw_btn[2]) player_pos_y = player_pos_y + (1<<21);
        else if (hw_btn[3]) player_pos_y = player_pos_y - (1<<21);
    end
    // endtodo

    ray_caster rays(
        .clk100(clk100), .fourstate(clk100_4state),
        .send_new_ray(send_new_ray),
        .output_ray(raycaster_output_ray),
        .output_xpos(raycaster_output_xpos),
        .read_ray_ready(read_ray_ready),
        .player_pos_x(player_pos_x[63:32]),
        .player_pos_y(player_pos_y[63:32])
    );
    pixel_generator pixels(
        .clk100(clk100), .fourstate(clk100_4state),
        .in_ray(raycaster_output_ray),
        .in_xpos(raycaster_output_xpos),
        .read_ray_ready(read_ray_ready),
        .send_new_ray(send_new_ray),
        .x(pixwrite_x), .y(pixwrite_y), .data(pixwrite_data), .pixwrite_enable(pixwrite_enable)
    );


    // ram controller to output pixel wires
    reg [15:0] pixel = 0;
    wire [15:0] pixelread;
    wire pixel_read_valid;
    always @(posedge clk100) begin
        if (pixel_read_valid) pixel = pixelread;
    end

    // vga output colors
    // currently outs are 4bit, final product will be 5-6-5 hopefully
    assign hw_vga_out_red = video_on ? pixel[4:1] : 0;
    assign hw_vga_out_green = video_on ? pixel[10:7] : 0;
    assign hw_vga_out_blue = video_on ? pixel[15:12] : 0;

    // connections from ram controller to ram
    wire [19:0] ram_addr;
    wire [15:0] ram_data_out;
    wire [15:0] ram_data_in;
    wire ram_write;
    
    // controller for accessing ram
    // todo pixel write is currently always-on,
    // feel free to assign a wire to pixwrite_enable and connect it to your raycaster or whatever,
    // if you end up having dead time where you wait for frame end or smth.
    sram_controller sram_controller(.clk100(clk100), .clk100_4state(clk100_4state), 
                                    .sram_addr(ram_addr), .sram_data_in(ram_data_in), .sram_data_out(ram_data_out), .sram_write(ram_write), 
                                    .pixread_x(pixread_x), .pixread_y(y), .pixread_data(pixelread), .pixread_valid(pixel_read_valid),
                                    .pixwrite_x(pixwrite_x), .pixwrite_y(pixwrite_y), .pixwrite_data(pixwrite_data), .pixwrite_enable(pixwrite_enable)
                                    );

    // stand-in for sram, block ram ip module, with one port set to 16bit rw access, 320*240 = 76800 depth
    // results in 2 cycle delay
    // todo implement external sram access
    blk_mem_gen_0 ram(.clka(clk100), .addra(ram_addr[16:0]), .douta(ram_data_out), .dina(ram_data_in), .wea(ram_write));

endmodule : toplevel