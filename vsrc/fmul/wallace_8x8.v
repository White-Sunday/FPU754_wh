`include "./vsrc/fmul/csa.v"

module wallace_8x8 (a,b,x,y,z);	// test 8*8 wallace tree generated by tool/generate_wallace.py
	input [7:0] a;	// input a
	input [7:0] b;	// input b
	output [15:5] x;	// sum high
	output [15:5] y;	// carry high
	output [4:0] z;	// sum low
	
	reg [7:0] p [7:0];	// p[i][j]
	parameter zero  = 1'b0;	// constant 0
	integer i,j;
	always @ * begin
		for(i=0;i<8;i=i+1)
			for(j=0;j<8;j=j+1)
				p[i][j] = a[i]&b[j];	// p[i][j]=a[i]&b[j]	
	end
	wire [0:0] c_overflow;  // storing the carry_out of highest level csa

	// level 1
	wire [2:0] s1 [15:1];
	wire [2:0] c1 [15:2];
	// 15:
	// 14: p[7][7]
	csa a1_13_0 (p[6][7],p[7][6],zero,s1[13][0],c1[14][0]);
	csa a1_12_0 (p[5][7],p[6][6],p[7][5],s1[12][0],c1[13][0]);
	csa a1_11_0 (p[4][7],p[5][6],p[6][5],s1[11][0],c1[12][0]);
	// 11: p[7][4]
	csa a1_10_1 (p[3][7],p[4][6],p[5][5],s1[10][1],c1[11][1]);
	csa a1_10_0 (p[6][4],p[7][3],zero,s1[10][0],c1[11][0]);
	csa a1_9_1 (p[2][7],p[3][6],p[4][5],s1[9][1],c1[10][1]);
	csa a1_9_0 (p[5][4],p[6][3],p[7][2],s1[9][0],c1[10][0]);
	csa a1_8_1 (p[1][7],p[2][6],p[3][5],s1[8][1],c1[9][1]);
	csa a1_8_0 (p[4][4],p[5][3],p[6][2],s1[8][0],c1[9][0]);
	// 8: p[7][1]
	csa a1_7_2 (p[0][7],p[1][6],p[2][5],s1[7][2],c1[8][2]);
	csa a1_7_1 (p[3][4],p[4][3],p[5][2],s1[7][1],c1[8][1]);
	csa a1_7_0 (p[6][1],p[7][0],zero,s1[7][0],c1[8][0]);
	csa a1_6_1 (p[0][6],p[1][5],p[2][4],s1[6][1],c1[7][1]);
	csa a1_6_0 (p[3][3],p[4][2],p[5][1],s1[6][0],c1[7][0]);
	// 6: p[6][0]
	csa a1_5_1 (p[0][5],p[1][4],p[2][3],s1[5][1],c1[6][1]);
	csa a1_5_0 (p[3][2],p[4][1],p[5][0],s1[5][0],c1[6][0]);
	csa a1_4_1 (p[0][4],p[1][3],p[2][2],s1[4][1],c1[5][1]);
	csa a1_4_0 (p[3][1],p[4][0],zero,s1[4][0],c1[5][0]);
	csa a1_3_0 (p[0][3],p[1][2],p[2][1],s1[3][0],c1[4][0]);
	// 3: p[3][0]
	csa a1_2_0 (p[0][2],p[1][1],p[2][0],s1[2][0],c1[3][0]);
	csa a1_1_0 (p[0][1],p[1][0],zero,s1[1][0],c1[2][0]);
	// 0: p[0][0]
	// level 2
	wire [1:0] s2 [15:2];
	wire [1:0] c2 [15:3];
	// 15:
	csa a2_14_0 (p[7][7],c1[14][0],zero,s2[14][0],c2[15][0]);
	csa a2_13_0 (s1[13][0],c1[13][0],zero,s2[13][0],c2[14][0]);
	csa a2_12_0 (s1[12][0],c1[12][0],zero,s2[12][0],c2[13][0]);
	csa a2_11_0 (p[7][4],s1[11][0],c1[11][1],s2[11][0],c2[12][0]);
	// 11: c1[11][0]
	csa a2_10_0 (s1[10][0],s1[10][1],c1[10][1],s2[10][0],c2[11][0]);
	// 10: c1[10][0]
	csa a2_9_0 (s1[9][0],s1[9][1],c1[9][1],s2[9][0],c2[10][0]);
	// 9: c1[9][0]
	csa a2_8_1 (p[7][1],s1[8][0],s1[8][1],s2[8][1],c2[9][1]);
	csa a2_8_0 (c1[8][2],c1[8][1],c1[8][0],s2[8][0],c2[9][0]);
	csa a2_7_1 (s1[7][0],s1[7][1],s1[7][2],s2[7][1],c2[8][1]);
	csa a2_7_0 (c1[7][1],c1[7][0],zero,s2[7][0],c2[8][0]);
	csa a2_6_1 (p[6][0],s1[6][0],s1[6][1],s2[6][1],c2[7][1]);
	csa a2_6_0 (c1[6][1],c1[6][0],zero,s2[6][0],c2[7][0]);
	csa a2_5_0 (s1[5][0],s1[5][1],c1[5][1],s2[5][0],c2[6][0]);
	// 5: c1[5][0]
	csa a2_4_0 (s1[4][0],s1[4][1],c1[4][0],s2[4][0],c2[5][0]);
	csa a2_3_0 (p[3][0],s1[3][0],c1[3][0],s2[3][0],c2[4][0]);
	csa a2_2_0 (s1[2][0],c1[2][0],zero,s2[2][0],c2[3][0]);
	// 1: s1[1][0]
	// 0: p[0][0]
	// level 3
	wire [0:0] s3 [15:3];
	wire [0:0] c3 [15:4];
	// 15: c2[15][0]
	csa a3_14_0 (s2[14][0],c2[14][0],zero,s3[14][0],c3[15][0]);
	csa a3_13_0 (s2[13][0],c2[13][0],zero,s3[13][0],c3[14][0]);
	csa a3_12_0 (s2[12][0],c2[12][0],zero,s3[12][0],c3[13][0]);
	csa a3_11_0 (c1[11][0],s2[11][0],c2[11][0],s3[11][0],c3[12][0]);
	csa a3_10_0 (c1[10][0],s2[10][0],c2[10][0],s3[10][0],c3[11][0]);
	csa a3_9_0 (c1[9][0],s2[9][0],c2[9][1],s3[9][0],c3[10][0]);
	// 9: c2[9][0]
	csa a3_8_0 (s2[8][0],s2[8][1],c2[8][1],s3[8][0],c3[9][0]);
	// 8: c2[8][0]
	csa a3_7_0 (s2[7][0],s2[7][1],c2[7][1],s3[7][0],c3[8][0]);
	// 7: c2[7][0]
	csa a3_6_0 (s2[6][0],s2[6][1],c2[6][0],s3[6][0],c3[7][0]);
	csa a3_5_0 (c1[5][0],s2[5][0],c2[5][0],s3[5][0],c3[6][0]);
	csa a3_4_0 (s2[4][0],c2[4][0],zero,s3[4][0],c3[5][0]);
	csa a3_3_0 (s2[3][0],c2[3][0],zero,s3[3][0],c3[4][0]);
	// 2: s2[2][0]
	// 1: s1[1][0]
	// 0: p[0][0]
	// level 4
	wire [0:0] s4 [15:4];
	wire [0:0] c4 [15:5];
	csa a4_15_0 (c2[15][0],c3[15][0],zero,s4[15][0],c_overflow);
	csa a4_14_0 (s3[14][0],c3[14][0],zero,s4[14][0],c4[15][0]);
	csa a4_13_0 (s3[13][0],c3[13][0],zero,s4[13][0],c4[14][0]);
	csa a4_12_0 (s3[12][0],c3[12][0],zero,s4[12][0],c4[13][0]);
	csa a4_11_0 (s3[11][0],c3[11][0],zero,s4[11][0],c4[12][0]);
	csa a4_10_0 (s3[10][0],c3[10][0],zero,s4[10][0],c4[11][0]);
	csa a4_9_0 (c2[9][0],s3[9][0],c3[9][0],s4[9][0],c4[10][0]);
	csa a4_8_0 (c2[8][0],s3[8][0],c3[8][0],s4[8][0],c4[9][0]);
	csa a4_7_0 (c2[7][0],s3[7][0],c3[7][0],s4[7][0],c4[8][0]);
	csa a4_6_0 (s3[6][0],c3[6][0],zero,s4[6][0],c4[7][0]);
	csa a4_5_0 (s3[5][0],c3[5][0],zero,s4[5][0],c4[6][0]);
	csa a4_4_0 (s3[4][0],c3[4][0],zero,s4[4][0],c4[5][0]);
	// 3: s3[3][0]
	// 2: s2[2][0]
	// 1: s1[1][0]
	// 0: p[0][0]

	assign x[15] = s4[15][0]; assign y[15] = c4[15][0];
	assign x[14] = s4[14][0]; assign y[14] = c4[14][0];
	assign x[13] = s4[13][0]; assign y[13] = c4[13][0];
	assign x[12] = s4[12][0]; assign y[12] = c4[12][0];
	assign x[11] = s4[11][0]; assign y[11] = c4[11][0];
	assign x[10] = s4[10][0]; assign y[10] = c4[10][0];
	assign x[9] = s4[9][0]; assign y[9] = c4[9][0];
	assign x[8] = s4[8][0]; assign y[8] = c4[8][0];
	assign x[7] = s4[7][0]; assign y[7] = c4[7][0];
	assign x[6] = s4[6][0]; assign y[6] = c4[6][0];
	assign x[5] = s4[5][0]; assign y[5] = c4[5][0];
	assign z[4] = s4[4][0];
	assign z[3] = s3[3][0];
	assign z[2] = s2[2][0];
	assign z[1] = s1[1][0];
	assign z[0] = p[0][0];

endmodule
