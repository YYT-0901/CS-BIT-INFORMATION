`timescale 1ns / 1ps

module testbench(
	);
	reg [2:0] S; //��Ӧex2 ģ�������
	wire [5:0] Y; //��Ӧex2 ģ������

initial begin
	S[2]=1'b0; //��ʼ��
	#20 S[2]=1'b1; //֮��ÿ20ns S[2]�仯һ�Σ���һλ�仯һ��
end

initial begin
	S[1]=1'b0;
	#10 S[1]=1'b1;
	#10 S[1]=1'b0;
	#10 S[1]=1'b1;//ÿ10ns S[1]�仯һ�Σ��ڶ�λ�仯һ��
end

initial begin
	S[0]=1'b0;
	#5 S[0]=1'b1;
	#5 S[0]=1'b0;
	#5 S[0]=1'b1;
	#5 S[0]=1'b0;
	#5 S[0]=1'b1;
	#5 S[0]=1'b0;
	#5 S[0]=1'b1;//ÿ 5ns S[0]�仯һ�Σ�����λ�仯һ��
end

ex2 ex2 (
    .S(S),
    .Y(Y)
);

endmodule