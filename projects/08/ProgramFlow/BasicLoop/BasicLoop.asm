//Bootstrap code
    @256
    D=A
    @SP
    M=D
//push constant 0
    @0
    D=A
    @SP
    A=M
    M=D
    @SP
    M=M+1
//pop local 0
    @0
    D=A
    @LCL
    D=D+M
    @R15
    M=D
    @SP
    AM=M-1
    D=M
    @R15
    A=M
    M=D
(LOOP_START)
//push argument 0
    @0
    D=A
    @ARG
    A=D+M
    D=M
    @SP
    A=M
    M=D
    @SP
    M=M+1
//push local 0
    @0
    D=A
    @LCL
    A=D+M
    D=M
    @SP
    A=M
    M=D
    @SP
    M=M+1
//add
    @SP
    AM=M-1
    D=M
    @SP
    AM=M-1
    D=D+M
    @SP
    A=M
    M=D
    @SP
    M=M+1
//pop local 0	
    @0	
    D=A
    @LCL
    D=D+M
    @R15
    M=D
    @SP
    AM=M-1
    D=M
    @R15
    A=M
    M=D
//push argument 0
    @0
    D=A
    @ARG
    A=D+M
    D=M
    @SP
    A=M
    M=D
    @SP
    M=M+1
//push constant 1
    @1
    D=A
    @SP
    A=M
    M=D
    @SP
    M=M+1
//sub
    @SP
    AM=M-1
    D=M
    @SP
    AM=M-1
    D=M-D
    @SP
    A=M
    M=D
    @SP
    M=M+1
//pop argument 0
    @0
    D=A
    @ARG
    D=D+M
    @R15
    M=D
    @SP
    AM=M-1
    D=M
    @R15
    A=M
    M=D
//push argument 0
    @0
    D=A
    @ARG
    A=D+M
    D=M
    @SP
    A=M
    M=D
    @SP
    M=M+1
    @SP
    AM=M-1
    D=M
    @LOOP_START
    D;JNE
//push local 0
    @0
    D=A
    @LCL
    A=D+M
    D=M
    @SP
    A=M
    M=D
    @SP
    M=M+1
(END)
    @END
    0;JMP