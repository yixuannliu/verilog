module flipflop(input D, clk, reset, output reg Q);
	always @(posedge clk)
		if(reset)
			Q <= 1'b0;
		else
			Q <= D;
endmodule

module mux2to1(input x, y, s, output f);

	assign f = (~s & x)|(s & y);

endmodule

module rotating_register(input [9:0]SW, input [3:0]KEY, output [7:0]LEDR);
	wire [7:0]Q, D, R;
	wire w;
	
	// ASRight mux
	mux2to1 ASRight(Q[0], Q[7], KEY[3], w);
	
	// rotate right mux
	mux2to1 R0(Q[7], Q[1], KEY[2], R[0]);
	mux2to1 R1(Q[0], Q[2], KEY[2], R[1]);
	mux2to1 R2(Q[1], Q[3], KEY[2], R[2]);
	mux2to1 R3(Q[2], Q[4], KEY[2], R[3]);
	mux2to1 R4(Q[3], Q[5], KEY[2], R[4]);
	mux2to1 R5(Q[4], Q[6], KEY[2], R[5]);
	mux2to1 R6(Q[5], Q[7], KEY[2], R[6]);
	mux2to1 R7(Q[6],    w, KEY[2], R[7]);
	
	// parallel loadin mux
	mux2to1 L0(SW[0], R[0], KEY[1], D[0]);
	mux2to1 L1(SW[1], R[1], KEY[1], D[1]);
	mux2to1 L2(SW[2], R[2], KEY[1], D[2]);
	mux2to1 L3(SW[3], R[3], KEY[1], D[3]);
	mux2to1 L4(SW[4], R[4], KEY[1], D[4]);
	mux2to1 L5(SW[5], R[5], KEY[1], D[5]);
	mux2to1 L6(SW[6], R[6], KEY[1], D[6]);
	mux2to1 L7(SW[7], R[7], KEY[1], D[7]);
	
	// 8 bits register
   flipflop M0(D[0], KEY[0], SW[9], Q[0]);
	flipflop M1(D[1], KEY[0], SW[9], Q[1]);
	flipflop M2(D[2], KEY[0], SW[9], Q[2]);
	flipflop M3(D[3], KEY[0], SW[9], Q[3]);
	flipflop M4(D[4], KEY[0], SW[9], Q[4]);
	flipflop M5(D[5], KEY[0], SW[9], Q[5]);
	flipflop M6(D[6], KEY[0], SW[9], Q[6]);
	flipflop M7(D[7], KEY[0], SW[9], Q[7]);
	
	assign LEDR = Q;

endmodule
