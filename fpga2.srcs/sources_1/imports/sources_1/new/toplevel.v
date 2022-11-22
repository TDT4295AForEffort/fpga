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
		input wire hw_sclk,
		input wire hw_mosi,
		input wire hw_ss,
		output wire hw_miso,
		input wire [2:0] hw_sw,
		output wire hw_hsync, hw_vsync,
		output wire [4:0] hw_vga_out_red,
		output wire [5:0] hw_vga_out_green,
		output wire [4:0] hw_vga_out_blue,

		//inout wire [7:0] hw_gpio,
		output wire [3:0] hw_led
//        output wire [7:0] hw_rgb
	);

    // Are you compiling for devboard or for pcb 
//    `define ISDEV
	// possible universal reset signal for future
	wire reset = 0;
	// 100mhz clock, bc things are written with this assumption and it should be explicit
	wire clk100;
    `ifdef ISDEV
        assign clk100 = hw_clk;
    `else 
        clk_wiz_0 clkwiz(.clk_in1(hw_clk), .clk_out1(clk100));
    `endif

	assign hw_led[2] = clk100;
	assign hw_led[1] = hw_clk;
	assign hw_led[0] = 1;

    // spi wires
	wire spi_byte_ready;    // let's spite know that we've received a byte
	wire [7:0] spi_out;
	wire [31:0] x_pos;
	wire [31:0] y_pos;
	wire [31:0] x_dir;
	wire [31:0] y_dir;
	wire [31:0] far_l_x;
	wire [31:0] far_l_y;
	wire [31:0] far_r_x;
	wire [31:0] far_r_y;
    wire [31:0] en_1_x;
    wire [31:0] en_1_y;
    wire [31:0] en_2_x;
    wire [31:0] en_2_y;
    wire [4095:0] world_map;
	wire ss_fall;           // propagate ss falling edge to spite so that it can reset its byte count

    // TODO: remove. these two are just for debugging/verifying that we receive the correct data
	wire [13:0] byte_count;
	wire [15:0] pack_size;

    //ila for debugging spi -> spite interaction, uncomment when you need it
	// ila_0 ila (
	//    .clk(clk100),
    //    .probe0(world_map[4095-:256])
    // );
    

    spi_slave slav (
        .clk(clk100),
        .sclk(hw_sclk),
        .miso(hw_miso),
        .mosi(hw_mosi),
        .ss(hw_ss),
        .byte_ready(spi_byte_ready),
        .out(spi_out),
        .ss_fall(ss_fall)
    );

	spite spit (
	   .clk(clk100),
	   .spi_byte_ready(spi_byte_ready),
	   .ss_fall(ss_fall),
	   .byte_in(spi_out),
	   .x_pos(x_pos),
	   .y_pos(y_pos),
	   .x_dir(x_dir),
	   .y_dir(y_dir),
       .map_arr(world_map[4095:0]),
       .x_45_left(far_l_x),
       .y_45_left(far_l_y),
       .x_45_right(far_r_x),
       .y_45_right(far_r_y),
       .en_1_x(en_1_x),
       .en_1_y(en_1_y),
       .en_2_x(en_2_x),
       .en_2_y(en_2_y),
	   .count(byte_count),   // TODO: remove unless we find a use for it
	   .pack_size(pack_size) // TODO: same as above
	);

    // state register for 4-state operations in sync with 25MHz VGA out
	reg [1:0] clk100_4state = 0;
	always @(posedge(clk100))
	   clk100_4state = clk100_4state + 1;
	
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
    wire [9:0] raycaster_output_ray_hit_type;
    wire signed [31:0] texture_index;
    wire send_new_ray;
    wire read_ray_ready;

    ray_caster rays(
        .clk100(clk100), .fourstate(clk100_4state),
        .send_new_ray(send_new_ray),
        .output_ray(raycaster_output_ray),
        .output_xpos(raycaster_output_xpos),
        .output_hit_type(raycaster_output_ray_hit_type),
        .read_ray_ready(read_ray_ready),
        .texture_index(texture_index),
        .player_pos_x(x_pos),
        .player_pos_y(y_pos),
        .player_direction_x(x_dir),
        .player_direction_y(y_dir),
        .en_1_x(en_1_x),
        .en_1_y(en_1_y),
        .en_2_x(en_2_x),
        .en_2_y(en_2_y),
        .world_map(world_map[4095:3840])
    );

    pixel_generator pixels(
        .clk100(clk100), .fourstate(clk100_4state),
        .in_ray(raycaster_output_ray),
        .in_xpos(raycaster_output_xpos),
        .hit_type(raycaster_output_ray_hit_type),
        .texture_index(texture_index),   
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
    assign hw_vga_out_red = video_on ? pixel[4:0] : 0;
    assign hw_vga_out_green = video_on ? pixel[10:5] : 0;
    assign hw_vga_out_blue = video_on ? pixel[15:11] : 0;

    // connections from ram controller to ram
    wire [19:0] ram_addr;
    wire [15:0] ram_data_out;
    wire [15:0] ram_data_in;
    wire ram_write;
    
    // controller for accessing ram
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
    `ifdef ISDEV
        blk_mem_gen_0 ram(.clka(clk100), .addra(ram_addr), .douta(ram_data_out), .dina(ram_data_in), .wea(ram_write));
    `else
        blk_mem_gen_pcb ram(.clka(clk100), .addra(ram_addr), .douta(ram_data_out), .dina(ram_data_in), .wea(ram_write));
    `endif
endmodule
