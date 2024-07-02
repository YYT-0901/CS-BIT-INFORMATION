`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/10 20:18:14
// Design Name: �����
// Module Name: testbench
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


module testbench(
    );
    reg x,clock,reset;
    wire z;
    
    integer i=0;
    reg[0:21] test_coin=22'b1010100010100010101000;
    //���������Ӳ�������� 1 ��ʾͶ��һöӲ�� 0��ʾû��Ͷ��Ӳ�� 
    //Ҫ��������Ͷ����öӲ�Һ�Z=1
    //��������1����ض�����һ��0����Ϊ1Ӳ��Ͷ���ʱ�䲻�������������ϵ�Ͷ��
    parameter period = 10;
    
initial begin
    reset=1'b1;
    x =1'b0;
    //��֤��ʼ״̬
    #(period);
    reset=1'b0;
    for(i=0;i<22;i=i+1)
    begin
        x = test_coin[i];
        //����x�ӵ�ǰ��Ӳ�����к�ת������һӲ�����к�
        #period;
    end
end
    //clock��ʾtestbench�е�ʱ���ź�
    always 
    begin
        clock=1'b1;
        #(period);
        clock=1'b0;
        #(period);
    end
    
ex3 u_ex3(
    .X(x),
    .CLK(clock),
    .RESET(reset),
    .Z(z)
);
endmodule