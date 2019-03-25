module ALU_register(SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	
	input [9:0]SW;
	input [3:0]KEY;
	
	output [7:0]LEDR;
	output [6:0]HEX0;
	output [6:0]HEX1;
	output [6:0]HEX2;
	output [6:0]HEX3;
	output [6:0]HEX4;
	output [6:0]HEX5;
	
	reg [7:0]f;
	
	wire [3:0]A, B;
	wire [2:0]s;

	reg [7:0]Q;

	assign B[3:0] =  Q[3:0];
	assign A[3:0] = SW[3:0];
	assign s[2:0] = KEY[3:1];
	assign LEDR = Q;
	
	wire c1, c2, c3, cout;
	wire w0, w1, w2, w3;
	
	fulladder M0(A[0], B[0],  0, w0, c1);
	fulladder M1(A[1], B[1], c1, w1, c2);
	fulladder M2(A[2], B[2], c2, w2, c3);
	fulladder M3(A[3], B[3], c3, w3, cout);
	
	always @(*)
	begin
		case(s)
			3'b000:
			begin
				f[0] = w0;
				f[1] = w1;
				f[2] = w2;
				f[3] = w3;
				f[4] = cout;
				f[5] = 0;
				f[6] = 0;
				f[7] = 0;
			end
			
			3'b001: f = A + B;
			
			3'b010: f = {A | B , A ^ B};	
					  
			3'b011:
			begin	
				if (A | B)
					f = 8'b00011000;
				else
					f = 8'b00000000;
			end
			
			3'b100: 
			begin
				if ((A & B) == 4'b1111)
					f = 8'b11100111;
				else
					f = 8'b00000000;
			end
			
			3'b101: f = A << B;
			
			3'b110: f = A * B;

			3'b111: f = Q;

			default: f = 8'b00000000;
			
		endcase
	end

	//register8bits B0(f, KEY[0], SW[9], Q);
	always @(posedge KEY[0])
		if(SW[9] == 0)
			Q <= 8'b00000000;
		else
			Q <= f;
	
	seg7 H0(A, HEX0);
	seg7 H4(Q[3:0], HEX4);
	seg7 H5(Q[7:4], HEX5);
	
	assign HEX1 = 7'b1000000;
	assign HEX2 = 7'b1000000;
	assign HEX3 = 7'b1000000;
	
endmodule

module register8bits(input [7:0]D, clk, resetn, output reg [7:0]Q);
	always @(posedge clk)
		if(!resetn)
			Q <= 8'b00000000;
		else
			Q <= D;
endmodule

module hex(input c3,c2,c1,c0, output f0,f1,f2,f3,f4,f5,f6);

	assign f0=(~c3&~c2&~c1&c0)|(~c3&c2&~c1&~c0)|(c3&~c2&c1&c0)|(c3&c2&~c1&c0);
	
	assign f1=(~c3&c2&~c1&c0)|(~c3&c2&c1&~c0)|(c3&~c2&c1&c0)|(c3&c2&~c1&~c0)|(c3&c2&c1&~c0)|(c3&c2&c1&c0);
	
	assign f2=(~c3&~c2&c1&~c0)|(c3&c2&~c1&~c0)|(c3&c2&c1&~c0)|(c3&c2&c1&c0);
	
	assign f3=(~c3&~c2&~c1&c0)|(~c3&c2&~c1&~c0)|(~c3&c2&c1&c0)|(c3&~c2&c1&~c0)|(c3&c2&c1&c0);
	
	assign f4=(~c3&~c2&~c1&c0)|(~c3&~c2&c1&c0)|(~c3&c2&~c1&~c0)|(~c3&c2&~c1&c0)|(~c3&c2&c1&c0)|(c3&~c2&~c1&c0);
	
	assign f5=(~c3&~c2&~c1&c0)|(~c3&~c2&c1&~c0)|(~c3&~c2&c1&c0)|(~c3&c2&c1&c0)|(c3&c2&~c1&c0);
	
	assign f6=(~c3&~c2&~c1&~c0)|(~c3&~c2&~c1&c0)|(~c3&c2&c1&c0)|(c3&c2&~c1&~c0);
	
	endmodule
	
module seg7(SW, HEX0);

	input [3:0] SW;
	output [6:0] HEX0;
	
	hex uf(.c3(SW[3]), .c2(SW[2]), .c1(SW[1]), .c0(SW[0]), .f0(HEX0[0]), .f1(HEX0[1]), .f2(HEX0[2]), .f3(HEX0[3]), .f4(HEX0[4]), .f5(HEX0[5]), .f6(HEX0[6]));
	
endmodule


module fulladder(input a,b,cin, output s,cout);

	assign s = cin ^ a ^ b; //XOR
	assign cout = (a & b)|(cin & a)|(cin & b);
	
endmodule
