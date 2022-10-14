`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2022 01:13:37 PM
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
        output wire [9:0] x, y,
        output wire [15:0] data 
    );
    
    reg [31:0] input_ray [319:0];
    reg [31:0] bar_border_from_center [319:0];
    integer i = 0;
    initial begin
        input_ray[0] = 14000;
        input_ray[1] = 14500;
        input_ray[2] = 14499;
        input_ray[3] = 14499;
        input_ray[4] = 14499;
        input_ray[5] = 14999;
        input_ray[6] = 14999;
        input_ray[7] = 14999;
        input_ray[8] = 15500;
        input_ray[9] = 15499;
        input_ray[10] = 15999;
        input_ray[11] = 16000;
        input_ray[12] = 16000;
        input_ray[13] = 16500;
        input_ray[14] = 16499;
        input_ray[15] = 17000;
        input_ray[16] = 17000;
        input_ray[17] = 16999;
        input_ray[18] = 17499;
        input_ray[19] = 17499;
        input_ray[20] = 17999;
        input_ray[21] = 18000;
        input_ray[22] = 18500;
        input_ray[23] = 18499;
        input_ray[24] = 18999;
        input_ray[25] = 19499;
        input_ray[26] = 19499;
        input_ray[27] = 19999;
        input_ray[28] = 19999;
        input_ray[29] = 20500;
        input_ray[30] = 21000;
        input_ray[31] = 20999;
        input_ray[32] = 21500;
        input_ray[33] = 22000;
        input_ray[34] = 22500;
        input_ray[35] = 22499;
        input_ray[36] = 23000;
        input_ray[37] = 23499;
        input_ray[38] = 23999;
        input_ray[39] = 24500;
        input_ray[40] = 24999;
        input_ray[41] = 25499;
        input_ray[42] = 25999;
        input_ray[43] = 26499;
        input_ray[44] = 27000;
        input_ray[45] = 27500;
        input_ray[46] = 28500;
        input_ray[47] = 29000;
        input_ray[48] = 29500;
        input_ray[49] = 30499;
        input_ray[50] = 31000;
        input_ray[51] = 31999;
        input_ray[52] = 32999;
        input_ray[53] = 33499;
        input_ray[54] = 34500;
        input_ray[55] = 35499;
        input_ray[56] = 37000;
        input_ray[57] = 37999;
        input_ray[58] = 38999;
        input_ray[59] = 40500;
        input_ray[60] = 42000;
        input_ray[61] = 43000;
        input_ray[62] = 45000;
        input_ray[63] = 46500;
        input_ray[64] = 48499;
        input_ray[65] = 50499;
        input_ray[66] = 52500;
        input_ray[67] = 54999;
        input_ray[68] = 57500;
        input_ray[69] = 60500;
        input_ray[70] = 63500;
        input_ray[71] = 66999;
        input_ray[72] = 70499;
        input_ray[73] = 70499;
        input_ray[74] = 70500;
        input_ray[75] = 70500;
        input_ray[76] = 70500;
        input_ray[77] = 70499;
        input_ray[78] = 70500;
        input_ray[79] = 70499;
        input_ray[80] = 70500;
        input_ray[81] = 70500;
        input_ray[82] = 70499;
        input_ray[83] = 70500;
        input_ray[84] = 70500;
        input_ray[85] = 70499;
        input_ray[86] = 70500;
        input_ray[87] = 70499;
        input_ray[88] = 70500;
        input_ray[89] = 70500;
        input_ray[90] = 70499;
        input_ray[91] = 70499;
        input_ray[92] = 70500;
        input_ray[93] = 70500;
        input_ray[94] = 70500;
        input_ray[95] = 70500;
        input_ray[96] = 70500;
        input_ray[97] = 70500;
        input_ray[98] = 70499;
        input_ray[99] = 70499;
        input_ray[100] = 70500;
        input_ray[101] = 70499;
        input_ray[102] = 70499;
        input_ray[103] = 60000;
        input_ray[104] = 55999;
        input_ray[105] = 52500;
        input_ray[106] = 50499;
        input_ray[107] = 50499;
        input_ray[108] = 50500;
        input_ray[109] = 50500;
        input_ray[110] = 39999;
        input_ray[111] = 38500;
        input_ray[112] = 36499;
        input_ray[113] = 35000;
        input_ray[114] = 34000;
        input_ray[115] = 32500;
        input_ray[116] = 31499;
        input_ray[117] = 30500;
        input_ray[118] = 30500;
        input_ray[119] = 30499;
        input_ray[120] = 30499;
        input_ray[121] = 30499;
        input_ray[122] = 30499;
        input_ray[123] = 30999;
        input_ray[124] = 30999;
        input_ray[125] = 30999;
        input_ray[126] = 30999;
        input_ray[127] = 30999;
        input_ray[128] = 31000;
        input_ray[129] = 30999;
        input_ray[130] = 30999;
        input_ray[131] = 20499;
        input_ray[132] = 19999;
        input_ray[133] = 19499;
        input_ray[134] = 19000;
        input_ray[135] = 18500;
        input_ray[136] = 18499;
        input_ray[137] = 17999;
        input_ray[138] = 17499;
        input_ray[139] = 16999;
        input_ray[140] = 16999;
        input_ray[141] = 16499;
        input_ray[142] = 16500;
        input_ray[143] = 16000;
        input_ray[144] = 15499;
        input_ray[145] = 15499;
        input_ray[146] = 15000;
        input_ray[147] = 15000;
        input_ray[148] = 14500;
        input_ray[149] = 14499;
        input_ray[150] = 14000;
        input_ray[151] = 13999;
        input_ray[152] = 13999;
        input_ray[153] = 13500;
        input_ray[154] = 13500;
        input_ray[155] = 12999;
        input_ray[156] = 13000;
        input_ray[157] = 13000;
        input_ray[158] = 12500;
        input_ray[159] = 12500;
        input_ray[160] = 12500;
        input_ray[161] = 11999;
        input_ray[162] = 12000;
        input_ray[163] = 12000;
        input_ray[164] = 11499;
        input_ray[165] = 11500;
        input_ray[166] = 11499;
        input_ray[167] = 11500;
        input_ray[168] = 10999;
        input_ray[169] = 11000;
        input_ray[170] = 10999;
        input_ray[171] = 11000;
        input_ray[172] = 11000;
        input_ray[173] = 11499;
        input_ray[174] = 11500;
        input_ray[175] = 11499;
        input_ray[176] = 11500;
        input_ray[177] = 11499;
        input_ray[178] = 11500;
        input_ray[179] = 11499;
        input_ray[180] = 11500;
        input_ray[181] = 11499;
        input_ray[182] = 11500;
        input_ray[183] = 11499;
        input_ray[184] = 11499;
        input_ray[185] = 11499;
        input_ray[186] = 11500;
        input_ray[187] = 11499;
        input_ray[188] = 11500;
        input_ray[189] = 11499;
        input_ray[190] = 11500;
        input_ray[191] = 11499;
        input_ray[192] = 12000;
        input_ray[193] = 11999;
        input_ray[194] = 11999;
        input_ray[195] = 12000;
        input_ray[196] = 12000;
        input_ray[197] = 11999;
        input_ray[198] = 12000;
        input_ray[199] = 11999;
        input_ray[200] = 11999;
        input_ray[201] = 12000;
        input_ray[202] = 12000;
        input_ray[203] = 11999;
        input_ray[204] = 12000;
        input_ray[205] = 12000;
        input_ray[206] = 12500;
        input_ray[207] = 12500;
        input_ray[208] = 12499;
        input_ray[209] = 12499;
        input_ray[210] = 12500;
        input_ray[211] = 12499;
        input_ray[212] = 12500;
        input_ray[213] = 12499;
        input_ray[214] = 12499;
        input_ray[215] = 12499;
        input_ray[216] = 12499;
        input_ray[217] = 12500;
        input_ray[218] = 13000;
        input_ray[219] = 13000;
        input_ray[220] = 12999;
        input_ray[221] = 13000;
        input_ray[222] = 13000;
        input_ray[223] = 13000;
        input_ray[224] = 12999;
        input_ray[225] = 12999;
        input_ray[226] = 13000;
        input_ray[227] = 12999;
        input_ray[228] = 13000;
        input_ray[229] = 13500;
        input_ray[230] = 13499;
        input_ray[231] = 13500;
        input_ray[232] = 13500;
        input_ray[233] = 13500;
        input_ray[234] = 13500;
        input_ray[235] = 13499;
        input_ray[236] = 13500;
        input_ray[237] = 13499;
        input_ray[238] = 13999;
        input_ray[239] = 13999;
        input_ray[240] = 14000;
        input_ray[241] = 14000;
        input_ray[242] = 13999;
        input_ray[243] = 13999;
        input_ray[244] = 14000;
        input_ray[245] = 13999;
        input_ray[246] = 14500;
        input_ray[247] = 14499;
        input_ray[248] = 14499;
        input_ray[249] = 14499;
        input_ray[250] = 14500;
        input_ray[251] = 14500;
        input_ray[252] = 14499;
        input_ray[253] = 15000;
        input_ray[254] = 15000;
        input_ray[255] = 15000;
        input_ray[256] = 14999;
        input_ray[257] = 15000;
        input_ray[258] = 14999;
        input_ray[259] = 15500;
        input_ray[260] = 15500;
        input_ray[261] = 15500;
        input_ray[262] = 15500;
        input_ray[263] = 15500;
        input_ray[264] = 15500;
        input_ray[265] = 16000;
        input_ray[266] = 16000;
        input_ray[267] = 15999;
        input_ray[268] = 16000;
        input_ray[269] = 16000;
        input_ray[270] = 15999;
        input_ray[271] = 16499;
        input_ray[272] = 16500;
        input_ray[273] = 16500;
        input_ray[274] = 16499;
        input_ray[275] = 16500;
        input_ray[276] = 17000;
        input_ray[277] = 16999;
        input_ray[278] = 16999;
        input_ray[279] = 17000;
        input_ray[280] = 17500;
        input_ray[281] = 42499;
        input_ray[282] = 42500;
        input_ray[283] = 42000;
        input_ray[284] = 41999;
        input_ray[285] = 42000;
        input_ray[286] = 41500;
        input_ray[287] = 41499;
        input_ray[288] = 41500;
        input_ray[289] = 41500;
        input_ray[290] = 40999;
        input_ray[291] = 40999;
        input_ray[292] = 41000;
        input_ray[293] = 40999;
        input_ray[294] = 40500;
        input_ray[295] = 40500;
        input_ray[296] = 40499;
        input_ray[297] = 40500;
        input_ray[298] = 40000;
        input_ray[299] = 39999;
        input_ray[300] = 39999;
        input_ray[301] = 39999;
        input_ray[302] = 39499;
        input_ray[303] = 39499;
        input_ray[304] = 39500;
        input_ray[305] = 39499;
        input_ray[306] = 39500;
        input_ray[307] = 38999;
        input_ray[308] = 39000;
        input_ray[309] = 38999;
        input_ray[310] = 39000;
        input_ray[311] = 38499;
        input_ray[312] = 38500;
        input_ray[313] = 38500;
        input_ray[314] = 38499;
        input_ray[315] = 38500;
        input_ray[316] = 38500;
        input_ray[317] = 38000;
        input_ray[318] = 38000;
        input_ray[319] = 37999;
         
    end 

        // count up x and y, to fill individual pixels
    reg [9:0] xpos = 0;
    reg [9:0] ypos = 0;
    
    reg [9:0] column = 0;
    reg [15:0] data_reg = 0;
    assign data = data_reg;
    //reg [9:0] row = 0;
    
    assign x = xpos;
    assign y = ypos;
    // red (5bit) is the lowest bits of x, so loops fast
    //assign data[4:0] = xpos[4:0];
    // green (6bit) is the lowest bits of y, so loops fast
    //assign data[10:5] = ypos[5:0];
    // blue (5bit) is the high bits of x + y, so loops slow.
    // losing the lowest y bit to keep it from double-carrying to overflow at all-ones both?
    //assign data[15:11] = xpos[9:5] + ypos[9:6];
    reg [31:0] debug1 = 0;
    reg [31:0] debug2 = 0;
    
    always @(posedge clk100) begin
    
        for (i = 0; i < 320; i = i + 1) begin
            // = 240*2500(1 + 1.3270448/input_ray[i])
            bar_border_from_center[i] = 464450/input_ray[i];
        end
    
        // make one pixel per 4 cycles, because that's how often you can write to a single slot.
        if (fourstate == 0) begin
            // loop for y for x, to prove a point, because vga output is x then y
            // count y up to 240, then reset to 0.
            // count x when y loops, up to 320, then reset to 0.
            if (ypos+1 >= 240) begin
                ypos = 0;
                if (xpos+1 >= 320) begin
                    xpos = 0;
                end else begin
                    xpos = xpos + 1;
                end
            end else begin

                // Code
                column = xpos;
                debug1 = 120 + bar_border_from_center[column];
                debug2 = 120 - bar_border_from_center[column];
                if( (ypos > (120 + bar_border_from_center[column])) || (ypos < (120 - bar_border_from_center[column])) ) begin
                    data_reg = 16'hFFFF;
                end else begin 
                    data_reg = {5'b00111, 6'b0, input_ray[column][15:11]};
                end

                ypos = ypos + 1;
            end
        end
    end
endmodule
