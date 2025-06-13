# TokenType
TK_UNKNOWN      = 0
TK_KEYWORD      = 1
TK_SYMBOL       = 2
TK_IDENTIFIER   = 3
TK_INT_CONST    = 4
TK_STRING_CONST = 5

# compileClass
ST_CL_KEYWORD   = 0   
ST_CL_NAME      = 1
ST_CL_BEGIN     = 2
ST_CL_END       = 3

# compileClassVarDec
ST_CLVD_KEYWORD = 0
ST_CLVD_TYPE    = 1
ST_CLVD_NAME    = 2
ST_CLVD_VAR     = 3

# compileSubroutine
ST_CLSR_KEYWORD = 0
ST_CLSR_TYPE    = 1
ST_CLSR_NAME    = 2
ST_CLSR_BEGIN_PARAMETER = 3
ST_CLSR_END_PARAMETER = 4
ST_CLSR_NEXT = 5

# compileParameterList
ST_PL_TYPE    = 0
ST_PL_NAME    = 1
ST_PL_NEXT    = 2

# compileSubroutineBody
ST_SB_BEGIN   = 0
ST_SB_END     = 1

# compileVarDec
ST_VD_KEYWORD = 0
ST_VD_TYPE    = 1
ST_VD_NAME    = 2
ST_VD_NEXT    = 3

# compileLet
ST_LT_KEYWORD = 0
ST_LT_NAME    = 1
ST_LT_EQUAL   = 2
ST_LT_INDEX   = 3
ST_LT_NEXT    = 4

#compileIf
ST_IF_KEYWORD = 0
ST_IF_BEGIN_CONDITION = 1
ST_IF_END_CONDITION   = 2
ST_IF_BEGIN_BODY      = 3
ST_IF_END_BODY        = 4
ST_IF_NEXT            = 5
ST_ELSE_BEGIN_BODY    = 6
ST_ELSE_END_BODY      = 7
ST_ELSE_NEXT          = 8

#compileWhile
ST_WHILE_KEYWORD         = 0
ST_WHILE_BEGIN_CONDITION = 1
ST_WHILE_END_CONDITION   = 2
ST_WHILE_BEGIN_BODY      = 3
ST_WHILE_END_BODY        = 4

#compileDo
ST_DO_KEYWORD        = 0
ST_DO_SUBROUTINECALL = 1
ST_DO_NEXT           = 2

#compileReturn
ST_RETURN_KEYWORD = 0
ST_RETURN_EXPRESSION = 1
ST_RETURN_NEXT = 2
