`timescale 1ns / 1ps

module testbench(
	);
	reg [2:0] S; //对应ex2 模块的输入
	wire [5:0] Y; //对应ex2 模块的输出

initial begin
	S[2]=1'b0; //初始化
	#20 S[2]=1'b1; //之后每20ns S[2]变化一次，第一位变化一次
end

initial begin
	S[1]=1'b0;
	#10 S[1]=1'b1;
	#10 S[1]=1'b0;
	#10 S[1]=1'b1;//每10ns S[1]变化一次，第二位变化一次
end

initial begin
	S[0]=1'b0;
	#5 S[0]=1'b1;
	#5 S[0]=1'b0;
	#5 S[0]=1'b1;
	#5 S[0]=1'b0;
	#5 S[0]=1'b1;
	#5 S[0]=1'b0;
	#5 S[0]=1'b1;//每 5ns S[0]变化一次，第三位变化一次
end

ex2 ex2 (
    .S(S),
    .Y(Y)
);

endmodule