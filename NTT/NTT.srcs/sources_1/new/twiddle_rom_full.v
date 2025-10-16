module twiddle_rom( 
    input clk, 
    input [8:0] addr, 
    output reg [11:0] data 
); 

always @(posedge clk) begin 
    case(addr) 

// ========== 正向NTT旋转因子 ==========

// Stage 0: 1 twiddles
9'd  0: data <= 12'h001; //    1 - Stage 0, index 0

// Stage 1: 2 twiddles
9'd  1: data <= 12'h001; //    1 - Stage 1, index 0
9'd  2: data <= 12'h6c1; // 1729 - Stage 1, index 1

// Stage 2: 4 twiddles
9'd  3: data <= 12'h001; //    1 - Stage 2, index 0
9'd  4: data <= 12'ha14; // 2580 - Stage 2, index 1
9'd  5: data <= 12'h6c1; // 1729 - Stage 2, index 2
9'd  6: data <= 12'hcd9; // 3289 - Stage 2, index 3

// Stage 3: 8 twiddles
9'd  7: data <= 12'h001; //    1 - Stage 3, index 0
9'd  8: data <= 12'ha52; // 2642 - Stage 3, index 1
9'd  9: data <= 12'ha14; // 2580 - Stage 3, index 2
9'd 10: data <= 12'h769; // 1897 - Stage 3, index 3
9'd 11: data <= 12'h6c1; // 1729 - Stage 3, index 4
9'd 12: data <= 12'h276; //  630 - Stage 3, index 5
9'd 13: data <= 12'hcd9; // 3289 - Stage 3, index 6
9'd 14: data <= 12'h350; //  848 - Stage 3, index 7

// Stage 4: 16 twiddles
9'd 15: data <= 12'h001; //    1 - Stage 4, index 0
9'd 16: data <= 12'h426; // 1062 - Stage 4, index 1
9'd 17: data <= 12'ha52; // 2642 - Stage 4, index 2
9'd 18: data <= 12'hae2; // 2786 - Stage 4, index 3
9'd 19: data <= 12'ha14; // 2580 - Stage 4, index 4
9'd 20: data <= 12'h0c1; //  193 - Stage 4, index 5
9'd 21: data <= 12'h769; // 1897 - Stage 4, index 6
9'd 22: data <= 12'h239; //  569 - Stage 4, index 7
9'd 23: data <= 12'h6c1; // 1729 - Stage 4, index 8
9'd 24: data <= 12'h77f; // 1919 - Stage 4, index 9
9'd 25: data <= 12'h276; //  630 - Stage 4, index 10
9'd 26: data <= 12'hcbc; // 3260 - Stage 4, index 11
9'd 27: data <= 12'hcd9; // 3289 - Stage 4, index 12
9'd 28: data <= 12'h31d; //  797 - Stage 4, index 13
9'd 29: data <= 12'h350; //  848 - Stage 4, index 14
9'd 30: data <= 12'h6d2; // 1746 - Stage 4, index 15

// Stage 5: 32 twiddles
9'd 31: data <= 12'h001; //    1 - Stage 5, index 0
9'd 32: data <= 12'h128; //  296 - Stage 5, index 1
9'd 33: data <= 12'h426; // 1062 - Stage 5, index 2
9'd 34: data <= 12'h592; // 1426 - Stage 5, index 3
9'd 35: data <= 12'ha52; // 2642 - Stage 5, index 4
9'd 36: data <= 12'hbe6; // 3046 - Stage 5, index 5
9'd 37: data <= 12'hae2; // 2786 - Stage 5, index 6
9'd 38: data <= 12'h959; // 2393 - Stage 5, index 7
9'd 39: data <= 12'ha14; // 2580 - Stage 5, index 8
9'd 40: data <= 12'h53b; // 1339 - Stage 5, index 9
9'd 41: data <= 12'h0c1; //  193 - Stage 5, index 10
9'd 42: data <= 12'h217; //  535 - Stage 5, index 11
9'd 43: data <= 12'h769; // 1897 - Stage 5, index 12
9'd 44: data <= 12'h8c0; // 2240 - Stage 5, index 13
9'd 45: data <= 12'h239; //  569 - Stage 5, index 14
9'd 46: data <= 12'h7b6; // 1974 - Stage 5, index 15
9'd 47: data <= 12'h6c1; // 1729 - Stage 5, index 16
9'd 48: data <= 12'h98f; // 2447 - Stage 5, index 17
9'd 49: data <= 12'h77f; // 1919 - Stage 5, index 18
9'd 50: data <= 12'h82e; // 2094 - Stage 5, index 19
9'd 51: data <= 12'h276; //  630 - Stage 5, index 20
9'd 52: data <= 12'h038; //   56 - Stage 5, index 21
9'd 53: data <= 12'hcbc; // 3260 - Stage 5, index 22
9'd 54: data <= 12'hb3f; // 2879 - Stage 5, index 23
9'd 55: data <= 12'hcd9; // 3289 - Stage 5, index 24
9'd 56: data <= 12'h5c4; // 1476 - Stage 5, index 25
9'd 57: data <= 12'h31d; //  797 - Stage 5, index 26
9'd 58: data <= 12'hb42; // 2882 - Stage 5, index 27
9'd 59: data <= 12'h350; //  848 - Stage 5, index 28
9'd 60: data <= 12'h535; // 1333 - Stage 5, index 29
9'd 61: data <= 12'h6d2; // 1746 - Stage 5, index 30
9'd 62: data <= 12'h335; //  821 - Stage 5, index 31

// Stage 6: 64 twiddles
9'd 63: data <= 12'h001; //    1 - Stage 6, index 0
9'd 64: data <= 12'h121; //  289 - Stage 6, index 1
9'd 65: data <= 12'h128; //  296 - Stage 6, index 2
9'd 66: data <= 12'h90f; // 2319 - Stage 6, index 3
9'd 67: data <= 12'h426; // 1062 - Stage 6, index 4
9'd 68: data <= 12'h28a; //  650 - Stage 6, index 5
9'd 69: data <= 12'h592; // 1426 - Stage 6, index 6
9'd 70: data <= 12'ha57; // 2647 - Stage 6, index 7
9'd 71: data <= 12'ha52; // 2642 - Stage 6, index 8
9'd 72: data <= 12'h4ad; // 1197 - Stage 6, index 9
9'd 73: data <= 12'hbe6; // 3046 - Stage 6, index 10
9'd 74: data <= 12'h59e; // 1438 - Stage 6, index 11
9'd 75: data <= 12'hae2; // 2786 - Stage 6, index 12
9'd 76: data <= 12'hb31; // 2865 - Stage 6, index 13
9'd 77: data <= 12'h959; // 2393 - Stage 6, index 14
9'd 78: data <= 12'h9aa; // 2474 - Stage 6, index 15
9'd 79: data <= 12'ha14; // 2580 - Stage 6, index 16
9'd 80: data <= 12'hcb5; // 3253 - Stage 6, index 17
9'd 81: data <= 12'h53b; // 1339 - Stage 6, index 18
9'd 82: data <= 12'h327; //  807 - Stage 6, index 19
9'd 83: data <= 12'h0c1; //  193 - Stage 6, index 20
9'd 84: data <= 12'h9d1; // 2513 - Stage 6, index 21
9'd 85: data <= 12'h217; //  535 - Stage 6, index 22
9'd 86: data <= 12'h5c9; // 1481 - Stage 6, index 23
9'd 87: data <= 12'h769; // 1897 - Stage 6, index 24
9'd 88: data <= 12'h8e5; // 2277 - Stage 6, index 25
9'd 89: data <= 12'h8c0; // 2240 - Stage 6, index 26
9'd 90: data <= 12'h5fe; // 1534 - Stage 6, index 27
9'd 91: data <= 12'h239; //  569 - Stage 6, index 28
9'd 92: data <= 12'h528; // 1320 - Stage 6, index 29
9'd 93: data <= 12'h7b6; // 1974 - Stage 6, index 30
9'd 94: data <= 12'h4cb; // 1227 - Stage 6, index 31
9'd 95: data <= 12'h6c1; // 1729 - Stage 6, index 32
9'd 96: data <= 12'h14b; //  331 - Stage 6, index 33
9'd 97: data <= 12'h98f; // 2447 - Stage 6, index 34
9'd 98: data <= 12'h59b; // 1435 - Stage 6, index 35
9'd 99: data <= 12'h77f; // 1919 - Stage 6, index 36
9'd100: data <= 12'h7b9; // 1977 - Stage 6, index 37
9'd101: data <= 12'h82e; // 2094 - Stage 6, index 38
9'd102: data <= 12'ha39; // 2617 - Stage 6, index 39
9'd103: data <= 12'h276; //  630 - Stage 6, index 40
9'd104: data <= 12'h900; // 2304 - Stage 6, index 41
9'd105: data <= 12'h038; //   56 - Stage 6, index 42
9'd106: data <= 12'hb34; // 2868 - Stage 6, index 43
9'd107: data <= 12'hcbc; // 3260 - Stage 6, index 44
9'd108: data <= 12'h021; //   33 - Stage 6, index 45
9'd109: data <= 12'hb3f; // 2879 - Stage 6, index 46
9'd110: data <= 12'hc26; // 3110 - Stage 6, index 47
9'd111: data <= 12'hcd9; // 3289 - Stage 6, index 48
9'd112: data <= 12'h6dc; // 1756 - Stage 6, index 49
9'd113: data <= 12'h5c4; // 1476 - Stage 6, index 50
9'd114: data <= 12'h1c4; //  452 - Stage 6, index 51
9'd115: data <= 12'h31d; //  797 - Stage 6, index 52
9'd116: data <= 12'h278; //  632 - Stage 6, index 53
9'd117: data <= 12'hb42; // 2882 - Stage 6, index 54
9'd118: data <= 12'h288; //  648 - Stage 6, index 55
9'd119: data <= 12'h350; //  848 - Stage 6, index 56
9'd120: data <= 12'h807; // 2055 - Stage 6, index 57
9'd121: data <= 12'h535; // 1333 - Stage 6, index 58
9'd122: data <= 12'h962; // 2402 - Stage 6, index 59
9'd123: data <= 12'h6d2; // 1746 - Stage 6, index 60
9'd124: data <= 12'h77b; // 1915 - Stage 6, index 61
9'd125: data <= 12'h335; //  821 - Stage 6, index 62
9'd126: data <= 12'h38e; //  910 - Stage 6, index 63

// ========== 逆NTT旋转因子 ==========

// Stage 6 (inverse): 64 twiddles
9'd127: data <= 12'h001; //    1 - Inv Stage 6, index 0
9'd128: data <= 12'h973; // 2419 - Inv Stage 6, index 1
9'd129: data <= 12'h9cc; // 2508 - Inv Stage 6, index 2
9'd130: data <= 12'h586; // 1414 - Inv Stage 6, index 3
9'd131: data <= 12'h62f; // 1583 - Inv Stage 6, index 4
9'd132: data <= 12'h39f; //  927 - Inv Stage 6, index 5
9'd133: data <= 12'h7cc; // 1996 - Inv Stage 6, index 6
9'd134: data <= 12'h4fa; // 1274 - Inv Stage 6, index 7
9'd135: data <= 12'h9b1; // 2481 - Inv Stage 6, index 8
9'd136: data <= 12'ha79; // 2681 - Inv Stage 6, index 9
9'd137: data <= 12'h1bf; //  447 - Inv Stage 6, index 10
9'd138: data <= 12'ha89; // 2697 - Inv Stage 6, index 11
9'd139: data <= 12'h9e4; // 2532 - Inv Stage 6, index 12
9'd140: data <= 12'hb3d; // 2877 - Inv Stage 6, index 13
9'd141: data <= 12'h73d; // 1853 - Inv Stage 6, index 14
9'd142: data <= 12'h625; // 1573 - Inv Stage 6, index 15
9'd143: data <= 12'h028; //   40 - Inv Stage 6, index 16
9'd144: data <= 12'h0db; //  219 - Inv Stage 6, index 17
9'd145: data <= 12'h1c2; //  450 - Inv Stage 6, index 18
9'd146: data <= 12'hce0; // 3296 - Inv Stage 6, index 19
9'd147: data <= 12'h045; //   69 - Inv Stage 6, index 20
9'd148: data <= 12'h1cd; //  461 - Inv Stage 6, index 21
9'd149: data <= 12'hcc9; // 3273 - Inv Stage 6, index 22
9'd150: data <= 12'h401; // 1025 - Inv Stage 6, index 23
9'd151: data <= 12'ha8b; // 2699 - Inv Stage 6, index 24
9'd152: data <= 12'h2c8; //  712 - Inv Stage 6, index 25
9'd153: data <= 12'h4d3; // 1235 - Inv Stage 6, index 26
9'd154: data <= 12'h548; // 1352 - Inv Stage 6, index 27
9'd155: data <= 12'h582; // 1410 - Inv Stage 6, index 28
9'd156: data <= 12'h766; // 1894 - Inv Stage 6, index 29
9'd157: data <= 12'h372; //  882 - Inv Stage 6, index 30
9'd158: data <= 12'hbb6; // 2998 - Inv Stage 6, index 31
9'd159: data <= 12'h640; // 1600 - Inv Stage 6, index 32
9'd160: data <= 12'h836; // 2102 - Inv Stage 6, index 33
9'd161: data <= 12'h54b; // 1355 - Inv Stage 6, index 34
9'd162: data <= 12'h7d9; // 2009 - Inv Stage 6, index 35
9'd163: data <= 12'hac8; // 2760 - Inv Stage 6, index 36
9'd164: data <= 12'h703; // 1795 - Inv Stage 6, index 37
9'd165: data <= 12'h441; // 1089 - Inv Stage 6, index 38
9'd166: data <= 12'h41c; // 1052 - Inv Stage 6, index 39
9'd167: data <= 12'h598; // 1432 - Inv Stage 6, index 40
9'd168: data <= 12'h738; // 1848 - Inv Stage 6, index 41
9'd169: data <= 12'haea; // 2794 - Inv Stage 6, index 42
9'd170: data <= 12'h330; //  816 - Inv Stage 6, index 43
9'd171: data <= 12'hc40; // 3136 - Inv Stage 6, index 44
9'd172: data <= 12'h9da; // 2522 - Inv Stage 6, index 45
9'd173: data <= 12'h7c6; // 1990 - Inv Stage 6, index 46
9'd174: data <= 12'h04c; //   76 - Inv Stage 6, index 47
9'd175: data <= 12'h2ed; //  749 - Inv Stage 6, index 48
9'd176: data <= 12'h357; //  855 - Inv Stage 6, index 49
9'd177: data <= 12'h3a8; //  936 - Inv Stage 6, index 50
9'd178: data <= 12'h1d0; //  464 - Inv Stage 6, index 51
9'd179: data <= 12'h21f; //  543 - Inv Stage 6, index 52
9'd180: data <= 12'h763; // 1891 - Inv Stage 6, index 53
9'd181: data <= 12'h11b; //  283 - Inv Stage 6, index 54
9'd182: data <= 12'h854; // 2132 - Inv Stage 6, index 55
9'd183: data <= 12'h2af; //  687 - Inv Stage 6, index 56
9'd184: data <= 12'h2aa; //  682 - Inv Stage 6, index 57
9'd185: data <= 12'h76f; // 1903 - Inv Stage 6, index 58
9'd186: data <= 12'ha77; // 2679 - Inv Stage 6, index 59
9'd187: data <= 12'h8db; // 2267 - Inv Stage 6, index 60
9'd188: data <= 12'h3f2; // 1010 - Inv Stage 6, index 61
9'd189: data <= 12'hbd9; // 3033 - Inv Stage 6, index 62
9'd190: data <= 12'hbe0; // 3040 - Inv Stage 6, index 63

// Stage 5 (inverse): 32 twiddles
9'd191: data <= 12'h001; //    1 - Inv Stage 5, index 0
9'd192: data <= 12'h9cc; // 2508 - Inv Stage 5, index 1
9'd193: data <= 12'h62f; // 1583 - Inv Stage 5, index 2
9'd194: data <= 12'h7cc; // 1996 - Inv Stage 5, index 3
9'd195: data <= 12'h9b1; // 2481 - Inv Stage 5, index 4
9'd196: data <= 12'h1bf; //  447 - Inv Stage 5, index 5
9'd197: data <= 12'h9e4; // 2532 - Inv Stage 5, index 6
9'd198: data <= 12'h73d; // 1853 - Inv Stage 5, index 7
9'd199: data <= 12'h028; //   40 - Inv Stage 5, index 8
9'd200: data <= 12'h1c2; //  450 - Inv Stage 5, index 9
9'd201: data <= 12'h045; //   69 - Inv Stage 5, index 10
9'd202: data <= 12'hcc9; // 3273 - Inv Stage 5, index 11
9'd203: data <= 12'ha8b; // 2699 - Inv Stage 5, index 12
9'd204: data <= 12'h4d3; // 1235 - Inv Stage 5, index 13
9'd205: data <= 12'h582; // 1410 - Inv Stage 5, index 14
9'd206: data <= 12'h372; //  882 - Inv Stage 5, index 15
9'd207: data <= 12'h640; // 1600 - Inv Stage 5, index 16
9'd208: data <= 12'h54b; // 1355 - Inv Stage 5, index 17
9'd209: data <= 12'hac8; // 2760 - Inv Stage 5, index 18
9'd210: data <= 12'h441; // 1089 - Inv Stage 5, index 19
9'd211: data <= 12'h598; // 1432 - Inv Stage 5, index 20
9'd212: data <= 12'haea; // 2794 - Inv Stage 5, index 21
9'd213: data <= 12'hc40; // 3136 - Inv Stage 5, index 22
9'd214: data <= 12'h7c6; // 1990 - Inv Stage 5, index 23
9'd215: data <= 12'h2ed; //  749 - Inv Stage 5, index 24
9'd216: data <= 12'h3a8; //  936 - Inv Stage 5, index 25
9'd217: data <= 12'h21f; //  543 - Inv Stage 5, index 26
9'd218: data <= 12'h11b; //  283 - Inv Stage 5, index 27
9'd219: data <= 12'h2af; //  687 - Inv Stage 5, index 28
9'd220: data <= 12'h76f; // 1903 - Inv Stage 5, index 29
9'd221: data <= 12'h8db; // 2267 - Inv Stage 5, index 30
9'd222: data <= 12'hbd9; // 3033 - Inv Stage 5, index 31

// Stage 4 (inverse): 16 twiddles
9'd223: data <= 12'h001; //    1 - Inv Stage 4, index 0
9'd224: data <= 12'h62f; // 1583 - Inv Stage 4, index 1
9'd225: data <= 12'h9b1; // 2481 - Inv Stage 4, index 2
9'd226: data <= 12'h9e4; // 2532 - Inv Stage 4, index 3
9'd227: data <= 12'h028; //   40 - Inv Stage 4, index 4
9'd228: data <= 12'h045; //   69 - Inv Stage 4, index 5
9'd229: data <= 12'ha8b; // 2699 - Inv Stage 4, index 6
9'd230: data <= 12'h582; // 1410 - Inv Stage 4, index 7
9'd231: data <= 12'h640; // 1600 - Inv Stage 4, index 8
9'd232: data <= 12'hac8; // 2760 - Inv Stage 4, index 9
9'd233: data <= 12'h598; // 1432 - Inv Stage 4, index 10
9'd234: data <= 12'hc40; // 3136 - Inv Stage 4, index 11
9'd235: data <= 12'h2ed; //  749 - Inv Stage 4, index 12
9'd236: data <= 12'h21f; //  543 - Inv Stage 4, index 13
9'd237: data <= 12'h2af; //  687 - Inv Stage 4, index 14
9'd238: data <= 12'h8db; // 2267 - Inv Stage 4, index 15

// Stage 3 (inverse): 8 twiddles
9'd239: data <= 12'h001; //    1 - Inv Stage 3, index 0
9'd240: data <= 12'h9b1; // 2481 - Inv Stage 3, index 1
9'd241: data <= 12'h028; //   40 - Inv Stage 3, index 2
9'd242: data <= 12'ha8b; // 2699 - Inv Stage 3, index 3
9'd243: data <= 12'h640; // 1600 - Inv Stage 3, index 4
9'd244: data <= 12'h598; // 1432 - Inv Stage 3, index 5
9'd245: data <= 12'h2ed; //  749 - Inv Stage 3, index 6
9'd246: data <= 12'h2af; //  687 - Inv Stage 3, index 7

// Stage 2 (inverse): 4 twiddles
9'd247: data <= 12'h001; //    1 - Inv Stage 2, index 0
9'd248: data <= 12'h028; //   40 - Inv Stage 2, index 1
9'd249: data <= 12'h640; // 1600 - Inv Stage 2, index 2
9'd250: data <= 12'h2ed; //  749 - Inv Stage 2, index 3

// Stage 1 (inverse): 2 twiddles
9'd251: data <= 12'h001; //    1 - Inv Stage 1, index 0
9'd252: data <= 12'h640; // 1600 - Inv Stage 1, index 1

// Stage 0 (inverse): 1 twiddles
9'd253: data <= 12'h001; //    1 - Inv Stage 0, index 0

// ========== Psi幂次 (用于PWM) ==========
9'd254: data <= 12'h001; // psi^0
9'd255: data <= 12'h03e; // psi^1
9'd256: data <= 12'h203; // psi^2
9'd257: data <= 12'h7b1; // psi^3
9'd258: data <= 12'h8ba; // psi^4
9'd259: data <= 12'h7e3; // psi^5
9'd260: data <= 12'h7d5; // psi^6
9'd261: data <= 12'h471; // psi^7
9'd262: data <= 12'h249; // psi^8
9'd263: data <= 12'hba4; // psi^9
9'd264: data <= 12'h681; // psi^10
9'd265: data <= 12'h01f; // psi^11
9'd266: data <= 12'h782; // psi^12
9'd267: data <= 12'ha59; // psi^13
9'd268: data <= 12'h45d; // psi^14
9'd269: data <= 12'ha72; // psi^15
9'd270: data <= 12'ha6b; // psi^16
9'd271: data <= 12'h8b9; // psi^17
9'd272: data <= 12'h7a5; // psi^18
9'd273: data <= 12'h5d2; // psi^19
9'd274: data <= 12'h9c1; // psi^20
9'd275: data <= 12'h690; // psi^21
9'd276: data <= 12'h3c1; // psi^22
9'd277: data <= 12'hbad; // psi^23
9'd278: data <= 12'h8af; // psi^24
9'd279: data <= 12'h539; // psi^25
9'd280: data <= 12'hbb6; // psi^26
9'd281: data <= 12'hadd; // psi^27
9'd282: data <= 12'ha53; // psi^28
9'd283: data <= 12'h2e9; // psi^29
9'd284: data <= 12'hb61; // psi^30
9'd285: data <= 12'h348; // psi^31
9'd286: data <= 12'h861; // psi^32
9'd287: data <= 12'hc57; // psi^33
9'd288: data <= 12'had8; // psi^34
9'd289: data <= 12'h91d; // psi^35
9'd290: data <= 12'h5db; // psi^36
9'd291: data <= 12'hbef; // psi^37
9'd292: data <= 12'hbaa; // psi^38
9'd293: data <= 12'h7f5; // psi^39
9'd294: data <= 12'hc31; // psi^40
9'd295: data <= 12'h1a4; // psi^41
9'd296: data <= 12'hab1; // psi^42
9'd297: data <= 12'hcac; // psi^43
9'd298: data <= 12'h56c; // psi^44
9'd299: data <= 12'hb0f; // psi^45
9'd300: data <= 12'h96e; // psi^46
9'd301: data <= 12'hc78; // psi^47
9'd302: data <= 12'h5d5; // psi^48
9'd303: data <= 12'ha7b; // psi^49
9'd304: data <= 12'hc99; // psi^50
9'd305: data <= 12'h0d2; // psi^51
9'd306: data <= 12'hbd9; // psi^52
9'd307: data <= 12'h656; // psi^53
9'd308: data <= 12'h2b6; // psi^54
9'd309: data <= 12'hc08; // psi^55
9'd310: data <= 12'h4b7; // psi^56
9'd311: data <= 12'h63c; // psi^57
9'd312: data <= 12'h96b; // psi^58
9'd313: data <= 12'hbbe; // psi^59
9'd314: data <= 12'hccd; // psi^60
9'd315: data <= 12'h069; // psi^61
9'd316: data <= 12'hc6d; // psi^62
9'd317: data <= 12'h32b; // psi^63
9'd318: data <= 12'h15b; // psi^64
9'd319: data <= 12'h604; // psi^65
9'd320: data <= 12'h8dc; // psi^66
9'd321: data <= 12'h31e; // psi^67
9'd322: data <= 12'hb36; // psi^68
9'd323: data <= 12'h5df; // psi^69
9'd324: data <= 12'hce7; // psi^70
9'd325: data <= 12'h6b5; // psi^71
9'd326: data <= 12'hcb7; // psi^72
9'd327: data <= 12'h816; // psi^73
9'd328: data <= 12'h72e; // psi^74
9'd329: data <= 12'h302; // psi^75
9'd330: data <= 12'h46e; // psi^76
9'd331: data <= 12'h18f; // psi^77
9'd332: data <= 12'h59b; // psi^78
9'd333: data <= 12'h970; // psi^79
9'd334: data <= 12'hcf4; // psi^80
9'd335: data <= 12'h9db; // psi^81
9'd336: data <= 12'hcdc; // psi^82
9'd337: data <= 12'h40b; // psi^83
9'd338: data <= 12'h397; // psi^84
9'd339: data <= 12'h181; // psi^85
9'd340: data <= 12'h237; // psi^86
9'd341: data <= 12'h748; // psi^87
9'd342: data <= 12'h94e; // psi^88
9'd343: data <= 12'h4b8; // psi^89
9'd344: data <= 12'h67a; // psi^90
9'd345: data <= 12'hb6e; // psi^91
9'd346: data <= 12'h66e; // psi^92
9'd347: data <= 12'h886; // psi^93
9'd348: data <= 12'h84c; // psi^94
9'd349: data <= 12'h741; // psi^95
9'd350: data <= 12'h79c; // psi^96
9'd351: data <= 12'h3a4; // psi^97
9'd352: data <= 12'h4a7; // psi^98
9'd353: data <= 12'h25c; // psi^99
9'd354: data <= 12'h33d; // psi^100
9'd355: data <= 12'h5b7; // psi^101
9'd356: data <= 12'h337; // psi^102
9'd357: data <= 12'h443; // psi^103
9'd358: data <= 12'h426; // psi^104
9'd359: data <= 12'ha21; // psi^105
9'd360: data <= 12'h3ce; // psi^106
9'd361: data <= 12'h1d2; // psi^107
9'd362: data <= 12'h8d4; // psi^108
9'd363: data <= 12'h12e; // psi^109
9'd364: data <= 12'h81f; // psi^110
9'd365: data <= 12'h95c; // psi^111
9'd366: data <= 12'h81c; // psi^112
9'd367: data <= 12'h8a2; // psi^113
9'd368: data <= 12'h213; // psi^114
9'd369: data <= 12'hb91; // psi^115
9'd370: data <= 12'h1e7; // psi^116
9'd371: data <= 12'h0e9; // psi^117
9'd372: data <= 12'h46a; // psi^118
9'd373: data <= 12'h097; // psi^119
9'd374: data <= 12'ha90; // psi^120
9'd375: data <= 12'h4ae; // psi^121
9'd376: data <= 12'h40e; // psi^122
9'd377: data <= 12'h451; // psi^123
9'd378: data <= 12'h78a; // psi^124
9'd379: data <= 12'hc49; // psi^125
9'd380: data <= 12'h774; // psi^126
9'd381: data <= 12'h6f5; // psi^127

        default: data <= 12'h001; // 默认返回1 
    endcase 
end 

endmodule 