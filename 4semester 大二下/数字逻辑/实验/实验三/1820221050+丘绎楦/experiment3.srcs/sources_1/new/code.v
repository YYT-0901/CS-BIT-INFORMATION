`timescale 1ns/1ps

module ex3(X,Z,CLK,RESET);
    input X;
    input CLK;
    input RESET;
    output Z;
    reg[1:0] state, next_state;
    parameter A=2'b00, B=2'b01, C=2'b10, D=2'b11;  // ÿһ��״̬��Ӧ�Ķ�������
    reg Z;
    
    // ֻ��ʱ�������λ����Ŵ���
    always @(posedge CLK or posedge RESET)
    begin
        if(RESET)
            state <= A;
        else
            state <= next_state;
    end
    
    always @(X or state)
    begin
        case(state)
            A: Z = 1'b0;
            B: Z = 1'b0;
            C: Z = 1'b0;
            D: Z = X ? 1'b1 : 1'b0;  // ֻ�е�����öӲ�ҷ���ʱ��������
        endcase
    end
    
    // ������һ��״̬
    always @(X or state)
    begin
        case(state)
            A: next_state <= X ? B : A;
            B: next_state <= X ? C : B;
            C: next_state <= X ? D : C;
            D: next_state <= X ? A : D;
        endcase
    end
endmodule