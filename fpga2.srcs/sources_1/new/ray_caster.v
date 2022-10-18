`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2022 02:44:53 PM
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
        input wire send_new_ray,
        output wire [31:0] output_ray,
        output wire [9:0] output_xpos
    );

    reg [31:0] output_rays [319:0];
    
    // Inits fake output data
        initial begin
        output_rays[0] = 14000;
        output_rays[1] = 14500;
        output_rays[2] = 14499;
        output_rays[3] = 14499;
        output_rays[4] = 14499;
        output_rays[5] = 14999;
        output_rays[6] = 14999;
        output_rays[7] = 14999;
        output_rays[8] = 15500;
        output_rays[9] = 15499;
        output_rays[10] = 15999;
        output_rays[11] = 16000;
        output_rays[12] = 16000;
        output_rays[13] = 16500;
        output_rays[14] = 16499;
        output_rays[15] = 17000;
        output_rays[16] = 17000;
        output_rays[17] = 16999;
        output_rays[18] = 17499;
        output_rays[19] = 17499;
        output_rays[20] = 17999;
        output_rays[21] = 18000;
        output_rays[22] = 18500;
        output_rays[23] = 18499;
        output_rays[24] = 18999;
        output_rays[25] = 19499;
        output_rays[26] = 19499;
        output_rays[27] = 19999;
        output_rays[28] = 19999;
        output_rays[29] = 20500;
        output_rays[30] = 21000;
        output_rays[31] = 20999;
        output_rays[32] = 21500;
        output_rays[33] = 22000;
        output_rays[34] = 22500;
        output_rays[35] = 22499;
        output_rays[36] = 23000;
        output_rays[37] = 23499;
        output_rays[38] = 23999;
        output_rays[39] = 24500;
        output_rays[40] = 24999;
        output_rays[41] = 25499;
        output_rays[42] = 25999;
        output_rays[43] = 26499;
        output_rays[44] = 27000;
        output_rays[45] = 27500;
        output_rays[46] = 28500;
        output_rays[47] = 29000;
        output_rays[48] = 29500;
        output_rays[49] = 30499;
        output_rays[50] = 31000;
        output_rays[51] = 31999;
        output_rays[52] = 32999;
        output_rays[53] = 33499;
        output_rays[54] = 34500;
        output_rays[55] = 35499;
        output_rays[56] = 37000;
        output_rays[57] = 37999;
        output_rays[58] = 38999;
        output_rays[59] = 40500;
        output_rays[60] = 42000;
        output_rays[61] = 43000;
        output_rays[62] = 45000;
        output_rays[63] = 46500;
        output_rays[64] = 48499;
        output_rays[65] = 50499;
        output_rays[66] = 52500;
        output_rays[67] = 54999;
        output_rays[68] = 57500;
        output_rays[69] = 60500;
        output_rays[70] = 63500;
        output_rays[71] = 66999;
        output_rays[72] = 70499;
        output_rays[73] = 70499;
        output_rays[74] = 70500;
        output_rays[75] = 70500;
        output_rays[76] = 70500;
        output_rays[77] = 70499;
        output_rays[78] = 70500;
        output_rays[79] = 70499;
        output_rays[80] = 70500;
        output_rays[81] = 70500;
        output_rays[82] = 70499;
        output_rays[83] = 70500;
        output_rays[84] = 70500;
        output_rays[85] = 70499;
        output_rays[86] = 70500;
        output_rays[87] = 70499;
        output_rays[88] = 70500;
        output_rays[89] = 70500;
        output_rays[90] = 70499;
        output_rays[91] = 70499;
        output_rays[92] = 70500;
        output_rays[93] = 70500;
        output_rays[94] = 70500;
        output_rays[95] = 70500;
        output_rays[96] = 70500;
        output_rays[97] = 70500;
        output_rays[98] = 70499;
        output_rays[99] = 70499;
        output_rays[100] = 70500;
        output_rays[101] = 70499;
        output_rays[102] = 70499;
        output_rays[103] = 60000;
        output_rays[104] = 55999;
        output_rays[105] = 52500;
        output_rays[106] = 50499;
        output_rays[107] = 50499;
        output_rays[108] = 50500;
        output_rays[109] = 50500;
        output_rays[110] = 39999;
        output_rays[111] = 38500;
        output_rays[112] = 36499;
        output_rays[113] = 35000;
        output_rays[114] = 34000;
        output_rays[115] = 32500;
        output_rays[116] = 31499;
        output_rays[117] = 30500;
        output_rays[118] = 30500;
        output_rays[119] = 30499;
        output_rays[120] = 30499;
        output_rays[121] = 30499;
        output_rays[122] = 30499;
        output_rays[123] = 30999;
        output_rays[124] = 30999;
        output_rays[125] = 30999;
        output_rays[126] = 30999;
        output_rays[127] = 30999;
        output_rays[128] = 31000;
        output_rays[129] = 30999;
        output_rays[130] = 30999;
        output_rays[131] = 20499;
        output_rays[132] = 19999;
        output_rays[133] = 19499;
        output_rays[134] = 19000;
        output_rays[135] = 18500;
        output_rays[136] = 18499;
        output_rays[137] = 17999;
        output_rays[138] = 17499;
        output_rays[139] = 16999;
        output_rays[140] = 16999;
        output_rays[141] = 16499;
        output_rays[142] = 16500;
        output_rays[143] = 16000;
        output_rays[144] = 15499;
        output_rays[145] = 15499;
        output_rays[146] = 15000;
        output_rays[147] = 15000;
        output_rays[148] = 14500;
        output_rays[149] = 14499;
        output_rays[150] = 14000;
        output_rays[151] = 13999;
        output_rays[152] = 13999;
        output_rays[153] = 13500;
        output_rays[154] = 13500;
        output_rays[155] = 12999;
        output_rays[156] = 13000;
        output_rays[157] = 13000;
        output_rays[158] = 12500;
        output_rays[159] = 12500;
        output_rays[160] = 12500;
        output_rays[161] = 11999;
        output_rays[162] = 12000;
        output_rays[163] = 12000;
        output_rays[164] = 11499;
        output_rays[165] = 11500;
        output_rays[166] = 11499;
        output_rays[167] = 11500;
        output_rays[168] = 10999;
        output_rays[169] = 11000;
        output_rays[170] = 10999;
        output_rays[171] = 11000;
        output_rays[172] = 11000;
        output_rays[173] = 11499;
        output_rays[174] = 11500;
        output_rays[175] = 11499;
        output_rays[176] = 11500;
        output_rays[177] = 11499;
        output_rays[178] = 11500;
        output_rays[179] = 11499;
        output_rays[180] = 11500;
        output_rays[181] = 11499;
        output_rays[182] = 11500;
        output_rays[183] = 11499;
        output_rays[184] = 11499;
        output_rays[185] = 11499;
        output_rays[186] = 11500;
        output_rays[187] = 11499;
        output_rays[188] = 11500;
        output_rays[189] = 11499;
        output_rays[190] = 11500;
        output_rays[191] = 11499;
        output_rays[192] = 12000;
        output_rays[193] = 11999;
        output_rays[194] = 11999;
        output_rays[195] = 12000;
        output_rays[196] = 12000;
        output_rays[197] = 11999;
        output_rays[198] = 12000;
        output_rays[199] = 11999;
        output_rays[200] = 11999;
        output_rays[201] = 12000;
        output_rays[202] = 12000;
        output_rays[203] = 11999;
        output_rays[204] = 12000;
        output_rays[205] = 12000;
        output_rays[206] = 12500;
        output_rays[207] = 12500;
        output_rays[208] = 12499;
        output_rays[209] = 12499;
        output_rays[210] = 12500;
        output_rays[211] = 12499;
        output_rays[212] = 12500;
        output_rays[213] = 12499;
        output_rays[214] = 12499;
        output_rays[215] = 12499;
        output_rays[216] = 12499;
        output_rays[217] = 12500;
        output_rays[218] = 13000;
        output_rays[219] = 13000;
        output_rays[220] = 12999;
        output_rays[221] = 13000;
        output_rays[222] = 13000;
        output_rays[223] = 13000;
        output_rays[224] = 12999;
        output_rays[225] = 12999;
        output_rays[226] = 13000;
        output_rays[227] = 12999;
        output_rays[228] = 13000;
        output_rays[229] = 13500;
        output_rays[230] = 13499;
        output_rays[231] = 13500;
        output_rays[232] = 13500;
        output_rays[233] = 13500;
        output_rays[234] = 13500;
        output_rays[235] = 13499;
        output_rays[236] = 13500;
        output_rays[237] = 13499;
        output_rays[238] = 13999;
        output_rays[239] = 13999;
        output_rays[240] = 14000;
        output_rays[241] = 14000;
        output_rays[242] = 13999;
        output_rays[243] = 13999;
        output_rays[244] = 14000;
        output_rays[245] = 13999;
        output_rays[246] = 14500;
        output_rays[247] = 14499;
        output_rays[248] = 14499;
        output_rays[249] = 14499;
        output_rays[250] = 14500;
        output_rays[251] = 14500;
        output_rays[252] = 14499;
        output_rays[253] = 15000;
        output_rays[254] = 15000;
        output_rays[255] = 15000;
        output_rays[256] = 14999;
        output_rays[257] = 15000;
        output_rays[258] = 14999;
        output_rays[259] = 15500;
        output_rays[260] = 15500;
        output_rays[261] = 15500;
        output_rays[262] = 15500;
        output_rays[263] = 15500;
        output_rays[264] = 15500;
        output_rays[265] = 16000;
        output_rays[266] = 16000;
        output_rays[267] = 15999;
        output_rays[268] = 16000;
        output_rays[269] = 16000;
        output_rays[270] = 15999;
        output_rays[271] = 16499;
        output_rays[272] = 16500;
        output_rays[273] = 16500;
        output_rays[274] = 16499;
        output_rays[275] = 16500;
        output_rays[276] = 17000;
        output_rays[277] = 16999;
        output_rays[278] = 16999;
        output_rays[279] = 17000;
        output_rays[280] = 17500;
        output_rays[281] = 42499;
        output_rays[282] = 42500;
        output_rays[283] = 42000;
        output_rays[284] = 41999;
        output_rays[285] = 42000;
        output_rays[286] = 41500;
        output_rays[287] = 41499;
        output_rays[288] = 41500;
        output_rays[289] = 41500;
        output_rays[290] = 40999;
        output_rays[291] = 40999;
        output_rays[292] = 41000;
        output_rays[293] = 40999;
        output_rays[294] = 40500;
        output_rays[295] = 40500;
        output_rays[296] = 40499;
        output_rays[297] = 40500;
        output_rays[298] = 40000;
        output_rays[299] = 39999;
        output_rays[300] = 39999;
        output_rays[301] = 39999;
        output_rays[302] = 39499;
        output_rays[303] = 39499;
        output_rays[304] = 39500;
        output_rays[305] = 39499;
        output_rays[306] = 39500;
        output_rays[307] = 38999;
        output_rays[308] = 39000;
        output_rays[309] = 38999;
        output_rays[310] = 39000;
        output_rays[311] = 38499;
        output_rays[312] = 38500;
        output_rays[313] = 38500;
        output_rays[314] = 38499;
        output_rays[315] = 38500;
        output_rays[316] = 38500;
        output_rays[317] = 38000;
        output_rays[318] = 38000;
        output_rays[319] = 37999; 
    end 

    reg [9:0] xpos = 0;
    
    reg [31:0] output_ray_reg = 0;
    reg [9:0] output_xpos_reg = 0;
    assign output_ray = output_ray_reg;
    assign output_xpos = output_xpos_reg;

    //reg write_done = 0;
    always @(posedge clk100) begin 
        
        if (send_new_ray == 1) begin
            output_ray_reg = output_rays[xpos];
            output_xpos_reg = xpos;
            xpos = xpos + 1;
        end

        if (xpos+1 >= 320) begin
            xpos = 0;
        end
    end
    
endmodule
