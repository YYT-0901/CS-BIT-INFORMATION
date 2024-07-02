`timescale 1ns/1ps

module ex2(S,Y);
	input [2:0] S;
	output [5:0] Y;
	wire temp_41, temp_42;  // 中间变量
	wire temp_31, temp_32;  // 中间变量
	wire not3, not4;  // 中间变量,~Y[3],~Y[4]
	
nor  // 或非门运算
	nor5(Y[5], ~S[2], ~S[1]),  // Y[5]
	nor2(Y[2], ~S[1], S[0]),  // Y[2]
	
	nor41(temp_41, ~S[2], S[1]),
	nor42(temp_42, ~S[2], ~S[0]),
	nor4(not4, temp_41, temp_42),
	
	nor31(temp_31, ~S[2], S[1], ~S[0]),
	nor32(temp_32, S[2], ~S[1], ~S[0]),
	nor3(not3, temp_31, temp_32); 
	
not  // 非门运算
	no3(Y[3], not3),  // Y[3]
	no4(Y[4], not4);  // Y[4]
	
assign Y[1]=0;  // Y[1]
assign Y[0]=S[0];  // Y[0]

endmodule