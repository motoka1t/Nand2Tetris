//Bootstrap code
    @256
    D=A
    @SP
    M=D
//call Sys.init 0
    @return-address$Sys.init1
    D=A
    @SP
    A=M
    M=D
    @SP
    M=M+1
    @LCL
    D=M
    @SP
    A=M
    M=D
    @SP
    M=M+1
    @ARG
    D=M
    @SP
    A=M
    M=D
    @SP
    M=M+1
    @THIS
    D=M
    @SP
    A=M
    M=D
    @SP
    M=M+1
    @THAT
    D=M
    @SP
    A=M
    M=D
    @SP
    M=M+1
    @SP
    D=M
    @0
    D=D-A
    @5
    D=D-A
    @ARG
    M=D
    @SP
    D=M
    @LCL
    M=D
    @Sys.init
    0;JMP
(return-address$Sys.init1)
(Main.fibonacci)
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
//push constant 2
    @2
    D=A
    @SP
    A=M
    M=D
    @SP
    M=M+1
//lt
    @SP
    AM=M-1
    D=M
    @SP
    AM=M-1
    D=M-D
    @TRUELT0
    D;JLT
(Main.fibonacci$FALSELT0)
    D=0
    @Main.fibonacci$ENDLT0
    0;JMP
(Main.fibonacci$TRUELT0)
    D=-1
    @Main.fibonacci$ENDLT0
    0;JMP
(Main.fibonacci$ENDLT0)
    @SP
    A=M
    M=D
    @SP
    A=M
    M=D
    @SP
    M=M+1
    @SP
    AM=M-1
    D=M
    @Main.fibonacci$IF_TRUE
    D;JNE
    @Main.fibonacci$IF_FALSE
    0;JMP
(Main.fibonacci$IF_TRUE)
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
    @LCL
    D=M
    @R13
    M=D
    @5
    D=A
    @R13
    A=M-D
    D=M
    @R14
    M=D
    @SP
    AM=M-1
    D=M
    @ARG
    A=M
    M=D
    @ARG
    D=M+1
    @SP
    M=D
    @R13
    AM=M-1
    D=M
    @THAT
    M=D
    @R13
    AM=M-1
    D=M
    @THIS
    M=D
    @R13
    AM=M-1
    D=M
    @ARG
    M=D
    @R13
    AM=M-1
    D=M
    @LCL
    M=D
    @R14
    A=M
    0;JMP
(Main.fibonacci$IF_FALSE)
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
//push constant 2
    @2
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
//call Main.fibonacci 1
    @return-address$Main.fibonacci2
    D=A
    @SP
    A=M
    M=D
    @SP
    M=M+1
    @LCL
    D=M
    @SP
    A=M
    M=D
    @SP
    M=M+1
    @ARG
    D=M
    @SP
    A=M
    M=D
    @SP
    M=M+1
    @THIS
    D=M
    @SP
    A=M
    M=D
    @SP
    M=M+1
    @THAT
    D=M
    @SP
    A=M
    M=D
    @SP
    M=M+1
    @SP
    D=M
    @1
    D=D-A
    @5
    D=D-A
    @ARG
    M=D
    @SP
    D=M
    @LCL
    M=D
    @Main.fibonacci
    0;JMP
(return-address$Main.fibonacci2)
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
//call Main.fibonacci 1
    @return-address$Main.fibonacci3
    D=A
    @SP
    A=M
    M=D
    @SP
    M=M+1
    @LCL
    D=M
    @SP
    A=M
    M=D
    @SP
    M=M+1
    @ARG
    D=M
    @SP
    A=M
    M=D
    @SP
    M=M+1
    @THIS
    D=M
    @SP
    A=M
    M=D
    @SP
    M=M+1
    @THAT
    D=M
    @SP
    A=M
    M=D
    @SP
    M=M+1
    @SP
    D=M
    @1
    D=D-A
    @5
    D=D-A
    @ARG
    M=D
    @SP
    D=M
    @LCL
    M=D
    @Main.fibonacci
    0;JMP
(return-address$Main.fibonacci3)
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
    @LCL
    D=M
    @R13
    M=D
    @5
    D=A
    @R13
    A=M-D
    D=M
    @R14
    M=D
    @SP
    AM=M-1
    D=M
    @ARG
    A=M
    M=D
    @ARG
    D=M+1
    @SP
    M=D
    @R13
    AM=M-1
    D=M
    @THAT
    M=D
    @R13
    AM=M-1
    D=M
    @THIS
    M=D
    @R13
    AM=M-1
    D=M
    @ARG
    M=D
    @R13
    AM=M-1
    D=M
    @LCL
    M=D
    @R14
    A=M
    0;JMP
(Sys.init)
//push constant 4
    @4
    D=A
    @SP
    A=M
    M=D
    @SP
    M=M+1
//call Main.fibonacci 1
    @return-address$Main.fibonacci4
    D=A
    @SP
    A=M
    M=D
    @SP
    M=M+1
    @LCL
    D=M
    @SP
    A=M
    M=D
    @SP
    M=M+1
    @ARG
    D=M
    @SP
    A=M
    M=D
    @SP
    M=M+1
    @THIS
    D=M
    @SP
    A=M
    M=D
    @SP
    M=M+1
    @THAT
    D=M
    @SP
    A=M
    M=D
    @SP
    M=M+1
    @SP
    D=M
    @1
    D=D-A
    @5
    D=D-A
    @ARG
    M=D
    @SP
    D=M
    @LCL
    M=D
    @Main.fibonacci
    0;JMP
(return-address$Main.fibonacci4)
(Sys.init$WHILE)
    @Sys.init$WHILE
    0;JMP
