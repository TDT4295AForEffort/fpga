`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2022 03:53:37 PM
// Design Name: 
// Module Name: line_intersection
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


module line_intersection(
    input wire signed [31:0] o_a[1:0],
    input wire signed [31:0] o_b[1:0],
    input wire signed [31:0] o_c[1:0],
    input wire signed [31:0] o_d[1:0],
    input wire start,
    output wire collision,
    output wire signed [31:0] col_point[1:0],
    output wire read_ready
    );

    wire signed [31:0] v_ab[1:0];
    assign v_ab[0] = o_b[0] - o_a[0];
    assign v_ab[1] = o_b[1] - o_a[1];

    wire signed [31:0] v_ac[1:0];
    assign v_ac[0] = o_c[0] - o_a[0];
    assign v_ac[1] = o_c[1] - o_a[1];

    wire signed [31:0] v_ad[1:0];
    assign v_ad[0] = o_d[0] - o_a[0];
    assign v_ad[1] = o_d[1] - o_a[1];

    wire signed [31:0] v_cd[1:0];
    assign v_cd[1] = o_d[1] - o_c[1];
    assign v_cd[0] = o_d[0] - o_c[0];

    wire signed [31:0] v_ca[1:0];
    assign v_ca[0] = o_a[0] - o_c[0];
    assign v_ca[1] = o_a[1] - o_c[1];

    // Output
    reg signed [31:0] scale_factor = 0;
    reg signed [31:0] x_out[1:0];
    reg collision_reg = 0;
    reg read_ready_reg = 0;
    assign col_point[0] = x_out[0] = 0;
    assign col_point[1] = x_out[1] = 0;
    assign collision = collision_reg;
    assign read_ray_ready = read_ray_ready_reg;

    reg signed [31:0] ab_dot_ac;
    reg signed [31:0] ab_dot_ad;
    reg signed [31:0] ac_dot_ad;

    reg [9:0] state = 0;
    always @(posedge clk100) begin
        if(state == 0 && start == 1) begin
            scale_factor <= (v_ab[0]*v_ac[0] + v_ab[1]*v_ac[1])/(v_ab[0]*v_ab[0] + v_ab[0]*v_ab[0]);
            ab_dot_ac = v_ab[0]*v_ac[0] + v_ab[1]*v_ac[1];
            ab_dot_ad = v_ab[0]*v_ad[0] + v_ab[1]*v_ad[1];
            ac_dot_ad = v_ac[0]*v_ad[0] + v_ac[1]*v_ad[1];
            state <= 1;
        end

        if(state >= 1 && state =< 4) begin // Wait for div
            state <= state + 1;
        end

        if(state == 5) begin 
            x_out[0] <= scale_factor*v_ab[0];
            x_out[1] <= scale_factor*v_ab[1];
            state <= 6;
        end
        
        // This math is gonna break
        // Check out this: https://en.wikipedia.org/wiki/Intersection_(geometry)#Two_line_segments
        // and this: https://en.wikipedia.org/wiki/Cramer%27s_rule
        // Try it in python
        if(state == 6) begin                                                                // Condition for intersection
            if( ab_dot_ac > 0 &&                                                            // 0 < v_ab * v_ac < v_ac * v_ad
                ab_dot_ac < ac_dot_ad &&                                                    //
                ab_dot_ad > 0 &&                                                            // 0 < v_ab * v_ad < v_ac * v_ad
                ab_dot_ad < ac_dot_ad &&                                                    //
                v_ab[0]*v_ab[0] + v_ab[1]*v_ab[1] >= x_out[0]*x_out[0] + x_out[1]*x_out[1]) // |v_ab| >= |x_out|
                begin 
                    
                end
        end
        
    end
endmodule
