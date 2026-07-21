`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2026 02:30:11 PM
// Design Name: 
// Module Name: inst_mem
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


module inst_mem(
    input  logic [31:0] pc,
    output logic [31:0] instruction
);

    // each location is 8-bit wide (byte-addressable)
    logic [7:0] inst_memory [0:359];
        
    initial begin
    
//        // 0x00500093
//        inst_memory[0]   = 8'h93;
//        inst_memory[1]   = 8'h00;
//        inst_memory[2]   = 8'h50;
//        inst_memory[3]   = 8'h00;
        
//        // 0x00300113
//        inst_memory[4]   = 8'h13;
//        inst_memory[5]   = 8'h01;
//        inst_memory[6]   = 8'h30;
//        inst_memory[7]   = 8'h00;
        
//        // 0x002081B3
//        inst_memory[8]   = 8'hB3;
//        inst_memory[9]   = 8'h81;
//        inst_memory[10]  = 8'h20;
//        inst_memory[11]  = 8'h00;
        
//        // 0x40208233
//        inst_memory[12]  = 8'h33;
//        inst_memory[13]  = 8'h82;
//        inst_memory[14]  = 8'h20;
//        inst_memory[15]  = 8'h40;
        
//        // 0x7FF00293
//        inst_memory[16]  = 8'h93;
//        inst_memory[17]  = 8'h02;
//        inst_memory[18]  = 8'hF0;
//        inst_memory[19]  = 8'h7F;
        
//        // 0x7FF28293
//        inst_memory[20]  = 8'h93;
//        inst_memory[21]  = 8'h82;
//        inst_memory[22]  = 8'hF2;
//        inst_memory[23]  = 8'h7F;
        
//        // 0x00228293
//        inst_memory[24]  = 8'h93;
//        inst_memory[25]  = 8'h82;
//        inst_memory[26]  = 8'h22;
//        inst_memory[27]  = 8'h00;
        
//        // 0x00002303
//        inst_memory[28]  = 8'h03;
//        inst_memory[29]  = 8'h23;
//        inst_memory[30]  = 8'h00;
//        inst_memory[31]  = 8'h00;
        
//        // 0x0062A023
//        inst_memory[32]  = 8'h23;
//        inst_memory[33]  = 8'hA0;
//        inst_memory[34]  = 8'h62;
//        inst_memory[35]  = 8'h00;
        
//        // 0x00402303
//        inst_memory[36]  = 8'h03;
//        inst_memory[37]  = 8'h23;
//        inst_memory[38]  = 8'h40;
//        inst_memory[39]  = 8'h00;
        
//        // 0x0062A223
//        inst_memory[40]  = 8'h23;
//        inst_memory[41]  = 8'hA2;
//        inst_memory[42]  = 8'h62;
//        inst_memory[43]  = 8'h00;
        
//        // 0x00802303
//        inst_memory[44]  = 8'h03;
//        inst_memory[45]  = 8'h23;
//        inst_memory[46]  = 8'h80;
//        inst_memory[47]  = 8'h00;
        
//        // 0x0062A423
//        inst_memory[48]  = 8'h23;
//        inst_memory[49]  = 8'hA4;
//        inst_memory[50]  = 8'h62;
//        inst_memory[51]  = 8'h00;
        
//        // 0x00C02303
//        inst_memory[52]  = 8'h03;
//        inst_memory[53]  = 8'h23;
//        inst_memory[54]  = 8'hC0;
//        inst_memory[55]  = 8'h00;
        
//        // 0x0062A623
//        inst_memory[56]  = 8'h23;
//        inst_memory[57]  = 8'hA6;
//        inst_memory[58]  = 8'h62;
//        inst_memory[59]  = 8'h00;
        
//        // 0x01002303
//        inst_memory[60]  = 8'h03;
//        inst_memory[61]  = 8'h23;
//        inst_memory[62]  = 8'h00;
//        inst_memory[63]  = 8'h01;
        
//        // 0x0062A823
//        inst_memory[64]  = 8'h23;
//        inst_memory[65]  = 8'hA8;
//        inst_memory[66]  = 8'h62;
//        inst_memory[67]  = 8'h00;
        
//        // 0x01402303
//        inst_memory[68]  = 8'h03;
//        inst_memory[69]  = 8'h23;
//        inst_memory[70]  = 8'h40;
//        inst_memory[71]  = 8'h01;
        
//        // 0x0062AA23
//        inst_memory[72]  = 8'h23;
//        inst_memory[73]  = 8'hAA;
//        inst_memory[74]  = 8'h62;
//        inst_memory[75]  = 8'h00;
        
//        // 0x00100413
//        inst_memory[76]  = 8'h13;
//        inst_memory[77]  = 8'h04;
//        inst_memory[78]  = 8'h10;
//        inst_memory[79]  = 8'h00;
        
//        // 0x00200493
//        inst_memory[80]  = 8'h93;
//        inst_memory[81]  = 8'h04;
//        inst_memory[82]  = 8'h20;
//        inst_memory[83]  = 8'h00;
        
//        // 0x01C2A383
//        inst_memory[84]  = 8'h83;
//        inst_memory[85]  = 8'hA3;
//        inst_memory[86]  = 8'hC2;
//        inst_memory[87]  = 8'h01;
        
//        // 0x00938463
//        inst_memory[88]  = 8'h63;
//        inst_memory[89]  = 8'h84;
//        inst_memory[90]  = 8'h93;
//        inst_memory[91]  = 8'h00;
        
//        // 0x0002AC23
//        inst_memory[92]  = 8'h23;
//        inst_memory[93]  = 8'hAC;
//        inst_memory[94]  = 8'h02;
//        inst_memory[95]  = 8'h00;
        
//        // 0x01C2A383
//        inst_memory[96]  = 8'h83;
//        inst_memory[97]  = 8'hA3;
//        inst_memory[98]  = 8'hC2;
//        inst_memory[99]  = 8'h01;
        
//        // 0x00838463
//        inst_memory[100] = 8'h63;
//        inst_memory[101] = 8'h84;
//        inst_memory[102] = 8'h83;
//        inst_memory[103] = 8'h00;
        
//        // 0xFF9FF06F
//        inst_memory[104] = 8'h6F;
//        inst_memory[105] = 8'hF0;
//        inst_memory[106] = 8'h9F;
//        inst_memory[107] = 8'hFF;
        
//        // 0x00028A13
//        inst_memory[108] = 8'h13;
//        inst_memory[109] = 8'h8A;
//        inst_memory[110] = 8'h02;
//        inst_memory[111] = 8'h00;
        
//        // 0x7FFA0A13
//        inst_memory[112] = 8'h13;
//        inst_memory[113] = 8'h0A;
//        inst_memory[114] = 8'hFA;
//        inst_memory[115] = 8'h7F;
        
//        // 0x7FFA0A13
//        inst_memory[116] = 8'h13;
//        inst_memory[117] = 8'h0A;
//        inst_memory[118] = 8'hFA;
//        inst_memory[119] = 8'h7F;
        
//        // 0x002A0A13
//        inst_memory[120] = 8'h13;
//        inst_memory[121] = 8'h0A;
//        inst_memory[122] = 8'h2A;
//        inst_memory[123] = 8'h00;
        
//        // 0x02028793
//        inst_memory[124] = 8'h93;
//        inst_memory[125] = 8'h87;
//        inst_memory[126] = 8'h02;
//        inst_memory[127] = 8'h02;
        
//        // 0x00000513
//        inst_memory[128] = 8'h13;
//        inst_memory[129] = 8'h05;
//        inst_memory[130] = 8'h00;
//        inst_memory[131] = 8'h00;
        
//        // 0x00900593
//        inst_memory[132] = 8'h93;
//        inst_memory[133] = 8'h05;
//        inst_memory[134] = 8'h90;
//        inst_memory[135] = 8'h00;
        
//        // 0x02000813
//        inst_memory[136] = 8'h13;
//        inst_memory[137] = 8'h08;
//        inst_memory[138] = 8'h00;
//        inst_memory[139] = 8'h02;
        
//        // 0x00100993
//        inst_memory[140] = 8'h93;
//        inst_memory[141] = 8'h09;
//        inst_memory[142] = 8'h10;
//        inst_memory[143] = 8'h00;
        
//        // 0x0007A883
//        inst_memory[144] = 8'h83;
//        inst_memory[145] = 8'hA8;
//        inst_memory[146] = 8'h07;
//        inst_memory[147] = 8'h00;
        
//        // 0x008A2903
//        inst_memory[148] = 8'h03;
//        inst_memory[149] = 8'h29;
//        inst_memory[150] = 8'h8A;
//        inst_memory[151] = 8'h00;
        
//        // 0x01397933
//        inst_memory[152] = 8'h33;
//        inst_memory[153] = 8'h79;
//        inst_memory[154] = 8'h39;
//        inst_memory[155] = 8'h01;
        
//        // 0x00090463
//        inst_memory[156] = 8'h63;
//        inst_memory[157] = 8'h04;
//        inst_memory[158] = 8'h09;
//        inst_memory[159] = 8'h00;
        
//        // 0xFF5FF06F
//        inst_memory[160] = 8'h6F;
//        inst_memory[161] = 8'hF0;
//        inst_memory[162] = 8'h5F;
//        inst_memory[163] = 8'hFF;
        
//        // 0x011A2023
//        inst_memory[164] = 8'h23;
//        inst_memory[165] = 8'h20;
//        inst_memory[166] = 8'h1A;
//        inst_memory[167] = 8'h01;
        
//        // 0x00478793
//        inst_memory[168] = 8'h93;
//        inst_memory[169] = 8'h87;
//        inst_memory[170] = 8'h47;
//        inst_memory[171] = 8'h00;
        
//        // 0x00150513
//        inst_memory[172] = 8'h13;
//        inst_memory[173] = 8'h05;
//        inst_memory[174] = 8'h15;
//        inst_memory[175] = 8'h00;
        
//        // 0x00B52633
//        inst_memory[176] = 8'h33;
//        inst_memory[177] = 8'h26;
//        inst_memory[178] = 8'hB5;
//        inst_memory[179] = 8'h00;
        
//        // 0x00060E63
//        inst_memory[180] = 8'h63;
//        inst_memory[181] = 8'h0E;
//        inst_memory[182] = 8'h06;
//        inst_memory[183] = 8'h00;
        
//        // 0x008A2903
//        inst_memory[184] = 8'h03;
//        inst_memory[185] = 8'h29;
//        inst_memory[186] = 8'h8A;
//        inst_memory[187] = 8'h00;
        
//        // 0x01397933
//        inst_memory[188] = 8'h33;
//        inst_memory[189] = 8'h79;
//        inst_memory[190] = 8'h39;
//        inst_memory[191] = 8'h01;
        
//        // 0x00090463
//        inst_memory[192] = 8'h63;
//        inst_memory[193] = 8'h04;
//        inst_memory[194] = 8'h09;
//        inst_memory[195] = 8'h00;
        
//        // 0xFF5FF06F
//        inst_memory[196] = 8'h6F;
//        inst_memory[197] = 8'hF0;
//        inst_memory[198] = 8'h5F;
//        inst_memory[199] = 8'hFF;
        
//        // 0x010A2023
//        inst_memory[200] = 8'h23;
//        inst_memory[201] = 8'h20;
//        inst_memory[202] = 8'h0A;
//        inst_memory[203] = 8'h01;
        
//        // 0xFC5FF06F
//        inst_memory[204] = 8'h6F;
//        inst_memory[205] = 8'hF0;
//        inst_memory[206] = 8'h5F;
//        inst_memory[207] = 8'hFC;
        
//        // 0x0000006F
//        inst_memory[208] = 8'h6F;
//        inst_memory[209] = 8'h00;
//        inst_memory[210] = 8'h00;
//        inst_memory[211] = 8'h00;

inst_memory[0] = 8'h93;
inst_memory[1] = 8'h00;
inst_memory[2] = 8'h50;
inst_memory[3] = 8'h00;
inst_memory[4] = 8'h13;
inst_memory[5] = 8'h01;
inst_memory[6] = 8'h30;
inst_memory[7] = 8'h00;
inst_memory[8] = 8'hB3;
inst_memory[9] = 8'h81;
inst_memory[10] = 8'h20;
inst_memory[11] = 8'h00;
inst_memory[12] = 8'h33;
inst_memory[13] = 8'h82;
inst_memory[14] = 8'h20;
inst_memory[15] = 8'h40;
inst_memory[16] = 8'h93;
inst_memory[17] = 8'h02;
inst_memory[18] = 8'hF0;
inst_memory[19] = 8'h7F;
inst_memory[20] = 8'h93;
inst_memory[21] = 8'h82;
inst_memory[22] = 8'hF2;
inst_memory[23] = 8'h7F;
inst_memory[24] = 8'h93;
inst_memory[25] = 8'h82;
inst_memory[26] = 8'h22;
inst_memory[27] = 8'h00;
inst_memory[28] = 8'h03;
inst_memory[29] = 8'h23;
inst_memory[30] = 8'h00;
inst_memory[31] = 8'h00;
inst_memory[32] = 8'h23;
inst_memory[33] = 8'hA0;
inst_memory[34] = 8'h62;
inst_memory[35] = 8'h00;
inst_memory[36] = 8'h03;
inst_memory[37] = 8'h23;
inst_memory[38] = 8'h40;
inst_memory[39] = 8'h00;
inst_memory[40] = 8'h23;
inst_memory[41] = 8'hA2;
inst_memory[42] = 8'h62;
inst_memory[43] = 8'h00;
inst_memory[44] = 8'h03;
inst_memory[45] = 8'h23;
inst_memory[46] = 8'h80;
inst_memory[47] = 8'h00;
inst_memory[48] = 8'h23;
inst_memory[49] = 8'hA4;
inst_memory[50] = 8'h62;
inst_memory[51] = 8'h00;
inst_memory[52] = 8'h03;
inst_memory[53] = 8'h23;
inst_memory[54] = 8'hC0;
inst_memory[55] = 8'h00;
inst_memory[56] = 8'h23;
inst_memory[57] = 8'hA6;
inst_memory[58] = 8'h62;
inst_memory[59] = 8'h00;
inst_memory[60] = 8'h03;
inst_memory[61] = 8'h23;
inst_memory[62] = 8'h00;
inst_memory[63] = 8'h01;
inst_memory[64] = 8'h23;
inst_memory[65] = 8'hA8;
inst_memory[66] = 8'h62;
inst_memory[67] = 8'h00;
inst_memory[68] = 8'h03;
inst_memory[69] = 8'h23;
inst_memory[70] = 8'h40;
inst_memory[71] = 8'h01;
inst_memory[72] = 8'h23;
inst_memory[73] = 8'hAA;
inst_memory[74] = 8'h62;
inst_memory[75] = 8'h00;
inst_memory[76] = 8'h13;
inst_memory[77] = 8'h04;
inst_memory[78] = 8'h10;
inst_memory[79] = 8'h00;
inst_memory[80] = 8'h93;
inst_memory[81] = 8'h04;
inst_memory[82] = 8'h20;
inst_memory[83] = 8'h00;
inst_memory[84] = 8'h83;
inst_memory[85] = 8'hA3;
inst_memory[86] = 8'hC2;
inst_memory[87] = 8'h01;
inst_memory[88] = 8'h63;
inst_memory[89] = 8'h84;
inst_memory[90] = 8'h93;
inst_memory[91] = 8'h00;
inst_memory[92] = 8'h23;
inst_memory[93] = 8'hAC;
inst_memory[94] = 8'h02;
inst_memory[95] = 8'h00;
inst_memory[96] = 8'h83;
inst_memory[97] = 8'hA3;
inst_memory[98] = 8'hC2;
inst_memory[99] = 8'h01;
inst_memory[100] = 8'h63;
inst_memory[101] = 8'h84;
inst_memory[102] = 8'h83;
inst_memory[103] = 8'h00;
inst_memory[104] = 8'h6F;
inst_memory[105] = 8'hF0;
inst_memory[106] = 8'h9F;
inst_memory[107] = 8'hFF;
inst_memory[108] = 8'h13;
inst_memory[109] = 8'h8A;
inst_memory[110] = 8'h02;
inst_memory[111] = 8'h00;
inst_memory[112] = 8'h13;
inst_memory[113] = 8'h0A;
inst_memory[114] = 8'hFA;
inst_memory[115] = 8'h7F;
inst_memory[116] = 8'h13;
inst_memory[117] = 8'h0A;
inst_memory[118] = 8'hFA;
inst_memory[119] = 8'h7F;
inst_memory[120] = 8'h13;
inst_memory[121] = 8'h0A;
inst_memory[122] = 8'h2A;
inst_memory[123] = 8'h00;
inst_memory[124] = 8'h93;
inst_memory[125] = 8'h87;
inst_memory[126] = 8'h02;
inst_memory[127] = 8'h02;
inst_memory[128] = 8'h13;
inst_memory[129] = 8'h05;
inst_memory[130] = 8'h00;
inst_memory[131] = 8'h00;
inst_memory[132] = 8'h93;
inst_memory[133] = 8'h05;
inst_memory[134] = 8'h90;
inst_memory[135] = 8'h00;
inst_memory[136] = 8'h13;
inst_memory[137] = 8'h08;
inst_memory[138] = 8'h00;
inst_memory[139] = 8'h02;
inst_memory[140] = 8'h93;
inst_memory[141] = 8'h09;
inst_memory[142] = 8'h10;
inst_memory[143] = 8'h00;
inst_memory[144] = 8'h83;
inst_memory[145] = 8'hA8;
inst_memory[146] = 8'h07;
inst_memory[147] = 8'h00;
inst_memory[148] = 8'h93;
inst_memory[149] = 8'h0A;
inst_memory[150] = 8'h00;
inst_memory[151] = 8'h00;
inst_memory[152] = 8'h13;
inst_memory[153] = 8'h0C;
inst_memory[154] = 8'h40;
inst_memory[155] = 8'h06;
inst_memory[156] = 8'hB3;
inst_memory[157] = 8'hAC;
inst_memory[158] = 8'h88;
inst_memory[159] = 8'h01;
inst_memory[160] = 8'h63;
inst_memory[161] = 8'h84;
inst_memory[162] = 8'h0C;
inst_memory[163] = 8'h00;
inst_memory[164] = 8'h6F;
inst_memory[165] = 8'h00;
inst_memory[166] = 8'h00;
inst_memory[167] = 8'h01;
inst_memory[168] = 8'hB3;
inst_memory[169] = 8'h88;
inst_memory[170] = 8'h88;
inst_memory[171] = 8'h41;
inst_memory[172] = 8'h93;
inst_memory[173] = 8'h8A;
inst_memory[174] = 8'h1A;
inst_memory[175] = 8'h00;
inst_memory[176] = 8'h6F;
inst_memory[177] = 8'hF0;
inst_memory[178] = 8'hDF;
inst_memory[179] = 8'hFE;
inst_memory[180] = 8'h13;
inst_memory[181] = 8'h0B;
inst_memory[182] = 8'h00;
inst_memory[183] = 8'h00;
inst_memory[184] = 8'h13;
inst_memory[185] = 8'h0C;
inst_memory[186] = 8'hA0;
inst_memory[187] = 8'h00;
inst_memory[188] = 8'hB3;
inst_memory[189] = 8'hAC;
inst_memory[190] = 8'h88;
inst_memory[191] = 8'h01;
inst_memory[192] = 8'h63;
inst_memory[193] = 8'h84;
inst_memory[194] = 8'h0C;
inst_memory[195] = 8'h00;
inst_memory[196] = 8'h6F;
inst_memory[197] = 8'h00;
inst_memory[198] = 8'h00;
inst_memory[199] = 8'h01;
inst_memory[200] = 8'hB3;
inst_memory[201] = 8'h88;
inst_memory[202] = 8'h88;
inst_memory[203] = 8'h41;
inst_memory[204] = 8'h13;
inst_memory[205] = 8'h0B;
inst_memory[206] = 8'h1B;
inst_memory[207] = 8'h00;
inst_memory[208] = 8'h6F;
inst_memory[209] = 8'hF0;
inst_memory[210] = 8'hDF;
inst_memory[211] = 8'hFE;
inst_memory[212] = 8'hB3;
inst_memory[213] = 8'h8B;
inst_memory[214] = 8'h08;
inst_memory[215] = 8'h00;
inst_memory[216] = 8'h13;
inst_memory[217] = 8'h0D;
inst_memory[218] = 8'h00;
inst_memory[219] = 8'h00;
inst_memory[220] = 8'h63;
inst_memory[221] = 8'h80;
inst_memory[222] = 8'h0A;
inst_memory[223] = 8'h02;
inst_memory[224] = 8'h93;
inst_memory[225] = 8'h8D;
inst_memory[226] = 8'h0A;
inst_memory[227] = 8'h03;
inst_memory[228] = 8'h03;
inst_memory[229] = 8'h29;
inst_memory[230] = 8'h8A;
inst_memory[231] = 8'h00;
inst_memory[232] = 8'h33;
inst_memory[233] = 8'h79;
inst_memory[234] = 8'h39;
inst_memory[235] = 8'h01;
inst_memory[236] = 8'h63;
inst_memory[237] = 8'h04;
inst_memory[238] = 8'h09;
inst_memory[239] = 8'h00;
inst_memory[240] = 8'h6F;
inst_memory[241] = 8'hF0;
inst_memory[242] = 8'h5F;
inst_memory[243] = 8'hFF;
inst_memory[244] = 8'h23;
inst_memory[245] = 8'h20;
inst_memory[246] = 8'hBA;
inst_memory[247] = 8'h01;
inst_memory[248] = 8'h13;
inst_memory[249] = 8'h0D;
inst_memory[250] = 8'h10;
inst_memory[251] = 8'h00;
inst_memory[252] = 8'h63;
inst_memory[253] = 8'h04;
inst_memory[254] = 8'h0D;
inst_memory[255] = 8'h00;
inst_memory[256] = 8'h6F;
inst_memory[257] = 8'h00;
inst_memory[258] = 8'h80;
inst_memory[259] = 8'h00;
inst_memory[260] = 8'h63;
inst_memory[261] = 8'h00;
inst_memory[262] = 8'h0B;
inst_memory[263] = 8'h02;
inst_memory[264] = 8'h93;
inst_memory[265] = 8'h0D;
inst_memory[266] = 8'h0B;
inst_memory[267] = 8'h03;
inst_memory[268] = 8'h03;
inst_memory[269] = 8'h29;
inst_memory[270] = 8'h8A;
inst_memory[271] = 8'h00;
inst_memory[272] = 8'h33;
inst_memory[273] = 8'h79;
inst_memory[274] = 8'h39;
inst_memory[275] = 8'h01;
inst_memory[276] = 8'h63;
inst_memory[277] = 8'h04;
inst_memory[278] = 8'h09;
inst_memory[279] = 8'h00;
inst_memory[280] = 8'h6F;
inst_memory[281] = 8'hF0;
inst_memory[282] = 8'h5F;
inst_memory[283] = 8'hFF;
inst_memory[284] = 8'h23;
inst_memory[285] = 8'h20;
inst_memory[286] = 8'hBA;
inst_memory[287] = 8'h01;
inst_memory[288] = 8'h13;
inst_memory[289] = 8'h0D;
inst_memory[290] = 8'h10;
inst_memory[291] = 8'h00;
inst_memory[292] = 8'h93;
inst_memory[293] = 8'h8D;
inst_memory[294] = 8'h0B;
inst_memory[295] = 8'h03;
inst_memory[296] = 8'h03;
inst_memory[297] = 8'h29;
inst_memory[298] = 8'h8A;
inst_memory[299] = 8'h00;
inst_memory[300] = 8'h33;
inst_memory[301] = 8'h79;
inst_memory[302] = 8'h39;
inst_memory[303] = 8'h01;
inst_memory[304] = 8'h63;
inst_memory[305] = 8'h04;
inst_memory[306] = 8'h09;
inst_memory[307] = 8'h00;
inst_memory[308] = 8'h6F;
inst_memory[309] = 8'hF0;
inst_memory[310] = 8'h5F;
inst_memory[311] = 8'hFF;
inst_memory[312] = 8'h23;
inst_memory[313] = 8'h20;
inst_memory[314] = 8'hBA;
inst_memory[315] = 8'h01;
inst_memory[316] = 8'h93;
inst_memory[317] = 8'h87;
inst_memory[318] = 8'h47;
inst_memory[319] = 8'h00;
inst_memory[320] = 8'h13;
inst_memory[321] = 8'h05;
inst_memory[322] = 8'h15;
inst_memory[323] = 8'h00;
inst_memory[324] = 8'h33;
inst_memory[325] = 8'h26;
inst_memory[326] = 8'hB5;
inst_memory[327] = 8'h00;
inst_memory[328] = 8'h63;
inst_memory[329] = 8'h0E;
inst_memory[330] = 8'h06;
inst_memory[331] = 8'h00;
inst_memory[332] = 8'h03;
inst_memory[333] = 8'h29;
inst_memory[334] = 8'h8A;
inst_memory[335] = 8'h00;
inst_memory[336] = 8'h33;
inst_memory[337] = 8'h79;
inst_memory[338] = 8'h39;
inst_memory[339] = 8'h01;
inst_memory[340] = 8'h63;
inst_memory[341] = 8'h04;
inst_memory[342] = 8'h09;
inst_memory[343] = 8'h00;
inst_memory[344] = 8'h6F;
inst_memory[345] = 8'hF0;
inst_memory[346] = 8'h5F;
inst_memory[347] = 8'hFF;
inst_memory[348] = 8'h23;
inst_memory[349] = 8'h20;
inst_memory[350] = 8'h0A;
inst_memory[351] = 8'h01;
inst_memory[352] = 8'h6F;
inst_memory[353] = 8'hF0;
inst_memory[354] = 8'h1F;
inst_memory[355] = 8'hF3;
inst_memory[356] = 8'h6F;
inst_memory[357] = 8'h00;
inst_memory[358] = 8'h00;
inst_memory[359] = 8'h00;
        
    end
    
    always_comb begin      
        instruction = {inst_memory[pc+3], inst_memory[pc+2], inst_memory[pc+1], inst_memory[pc]};
    end

endmodule
