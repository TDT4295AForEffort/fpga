`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2022 12:10:49 PM
// Design Name: 
// Module Name: vga_sync2
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


// new, written by odderikf instead of copied from online, vga synchronization module.
// will take a 100HMz clock, and subdivision of that clock into 4 states,
// and output the next desired x,y position of a pixel to vga out,
// as well as a hsync, vsync, and video_on signal for vga timing.
// set tickstate and delay for phase alignment issues,
// though this should ideally be the source-of-truth on those?
//
// reset wire hasn't been thoroughly tested, but should reset vga_sync2 to fresh-boot conditions.
// Idk that this is needed, because we can just write black screen from framebuffer until video is up?
// maybe if there's a setup period for the ram.
module vga_sync2(
        input wire reset,
        input wire clk100,
        input wire [1:0] clk100_4state,
        output wire hsync, vsync, video_on,
        output wire [9:0] x, y
    );
    
    
    // constant declarations for VGA sync parameters
    localparam H_DISPLAY       = 640; // horizontal display area
    localparam H_L_BORDER      =  40; // horizontal left border
    localparam H_R_BORDER      =  24; // horizontal right border
    localparam H_RETRACE       =  96; // horizontal retrace
    localparam H_MAX           = H_DISPLAY + H_L_BORDER + H_R_BORDER + H_RETRACE;
    localparam START_H_RETRACE = H_DISPLAY + H_R_BORDER;
    localparam END_H_RETRACE   = H_DISPLAY + H_R_BORDER + H_RETRACE;

    localparam V_DISPLAY       = 480; // vertical display area
    localparam V_T_BORDER      =  10; // vertical top border
    localparam V_B_BORDER      =  33; // vertical bottom border
    localparam V_RETRACE       =   2; // vertical retrace
    localparam V_MAX           = V_DISPLAY + V_T_BORDER + V_B_BORDER + V_RETRACE;
    localparam START_V_RETRACE = V_DISPLAY + V_B_BORDER;
    localparam END_V_RETRACE   = V_DISPLAY + V_B_BORDER + V_RETRACE;
        
    
    localparam tickstate = 0;
    localparam delay = 1;
    
    reg [9:0] xpos = 0;
    reg [9:0] ypos = 0;
    
    reg [9:0] hpos = 0;
    reg [9:0] vpos = 0;
    
    reg [10:0] delaycntr = 0;
    wire delay_done = delaycntr >= delay;
    
    assign hsync = hpos >= START_H_RETRACE && hpos <= END_H_RETRACE;
    assign vsync = vpos >= START_V_RETRACE && vpos <= END_V_RETRACE;
    assign x = xpos;
    assign y = ypos;
    assign video_on = (~reset) && (hpos < H_DISPLAY) && (vpos < V_DISPLAY);
    
    always @(posedge clk100) begin
        if (reset) begin
            xpos = 0;
            ypos = 0;
            hpos = 0;
            vpos = 0;
            delaycntr = 0;
        end else begin
            if (clk100_4state == tickstate) begin
                if (xpos + 1 >= H_MAX) begin
                    xpos = 0;
                    if (ypos + 1 >= V_MAX) begin
                        ypos = 0;
                    end else begin                     
                        ypos = ypos + 1;
                    end
                end else begin
                    xpos = xpos + 1;
                end
                if (delay_done) begin
                    if (hpos + 1 >= H_MAX) begin
                        hpos = 0;
                        if (vpos + 1 >= V_MAX) begin
                            vpos = 0;
                        end else begin
                            vpos = vpos + 1;
                        end                         
                    end else begin
                        hpos = hpos + 1;
                    end
                end else begin
                    delaycntr = delaycntr + 1;
                end
            end
        end
    end
    
    
endmodule
