`timescale 1ns/1ps

module ex3(X,Z,CLK,RESET);
    input X;
    input CLK;
    input RESET;
    output Z;
    reg[1:0] state, next_state;
    parameter A=2'b00, B=2'b01, C=2'b10, D=2'b11;  // 每一个状态对应的二进制码
    reg Z;
    
    // 只有时钟输入或复位输入才触发
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
            D: Z = X ? 1'b1 : 1'b0;  // 只有当第四枚硬币放入时才有饮料
        endcase
    end
    
    // 调整下一个状态
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