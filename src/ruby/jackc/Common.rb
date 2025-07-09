# TokenType
TK_UNKNOWN      = 0
TK_KEYWORD      = 1
TK_SYMBOL       = 2
TK_IDENTIFIER   = 3
TK_INT_CONST    = 4
TK_STRING_CONST = 5

# compileClass
ST_CLASS_KEYWORD    = 0   
ST_CLASS_NAME       = 1
ST_CLASS_BEGIN      = 2
ST_CLASS_VAR_DEC    = 3
ST_CLASS_SUBROUTINE = 4
ST_CLASS_END        = 5

# compileClassVarDec
ST_CLASS_VAR_DEC_KEYWORD = 0
ST_CLASS_VAR_DEC_TYPE    = 1
ST_CLASS_VAR_DEC_NAME    = 2
ST_CLASS_VAR_DEC_NEXT    = 3

# compileSubroutine
ST_CLASS_SUBROUTINE_KEYWORD         = 0
ST_CLASS_SUBROUTINE_TYPE            = 1
ST_CLASS_SUBROUTINE_NAME            = 2
ST_CLASS_SUBROUTINE_BEGIN_PARAMETER = 3
ST_CLASS_SUBROUTINE_PARAMETERLIST   = 4
ST_CLASS_SUBROUTINE_END_PARAMETER   = 5
ST_CLASS_SUBROUTINE_BEGIN_BODY      = 6
ST_CLASS_SUBROUTINE_BODY_VARDEC     = 7
ST_CLASS_SUBROUTINE_BODY            = 8
ST_CLASS_SUBROUTINE_END_BODY        = 9

# compileParameterList
ST_PARAMETER_LIST_TYPE    = 0
ST_PARAMETER_LIST_NAME    = 1
ST_PARAMETER_LIST_NEXT    = 2

# compileVarDec
ST_VAR_DEC_KEYWORD = 0
ST_VAR_DEC_TYPE    = 1
ST_VAR_DEC_NAME    = 2
ST_VAR_DEC_NEXT    = 3

# compileLet
ST_LET_KEYWORD               = 0
ST_LET_VARNAME               = 1
ST_LET_BEGIN_ARRAY = 2
ST_LET_ARRAY       = 3
ST_LET_END_ARRAY   = 4
ST_LET_EQUAL                 = 5
ST_LET_RIGHT_EXPRESSION      = 6
ST_LET_NEXT                  = 7

#compileIf
ST_IF_KEYWORD         = 0
ST_IF_BEGIN_CONDITION = 1
ST_IF_CONDITION       = 2
ST_IF_END_CONDITION   = 3
ST_IF_BEGIN_BODY      = 4
ST_IF_BODY            = 5
ST_IF_END_BODY        = 6
ST_ELSE_KEYWORD       = 7
ST_ELSE_BEGIN_BODY    = 8
ST_ELSE_BODY          = 9
ST_ELSE_END_BODY      = 10

#compileWhile
ST_WHILE_KEYWORD         = 0
ST_WHILE_BEGIN_CONDITION = 1
ST_WHILE_CONDITION       = 2
ST_WHILE_END_CONDITION   = 3
ST_WHILE_BEGIN_BODY      = 4
ST_WHILE_BODY            = 5
ST_WHILE_END_BODY        = 6

#compileDo
ST_DO_KEYWORD                   = 0
ST_DO_SUBROUTINE_NAME           = 1
ST_DO_SUBROUTINE_NAME_NEXT      = 2
ST_DO_SUBROUTINE_BEGIN_ARGUMENT = 3
ST_DO_SUBROUTINE_ARGUMENT       = 4
ST_DO_SUBROUTINE_END_ARGUMENT   = 5
ST_DO_END                       = 6

#compileReturn
ST_RETURN_KEYWORD = 0
ST_RETURN_VALUE   = 1
ST_RETURN_END     = 2

ST_EXPRESSION_TERM = 0
ST_EXPRESSION_NEXT = 1

ST_EXPRESSION_LIST = 0
ST_EXPRESSION_LIST_NEXT = 1

#compileTerm
ST_TERM_FIRST_STEP                = 0
ST_TERM_BEGIN_ARRAY               = 1
ST_TERM_ARRAY                     = 2
ST_TERM_END_ARRAY                 = 3
ST_TERM_SUBROUTINE_NAME_NEXT      = 4
ST_TERM_SUBROUTINE_METHOD_NAME    = 5
ST_TERM_SUBROUTINE_BEGIN_ARGUMENT = 6
ST_TERM_SUBROUTINE_ARGUMENT       = 7
ST_TERM_SUBROUTINE_END_ARGUMENT   = 8
ST_TERM_BEGIN_EXPRESSION          = 9
ST_TERM_EXPRESSION                = 10
ST_TERM_END_EXPORESSION           = 11
ST_TERM_UNARY_OPERATOR            = 12

def getArthimetic(symbol)
  case symbol
  when "+"
    return "ADD"
  when "-"
    return "SUB"
  when "*"
    return "MULTIPLY"
  when "/"
    return "DIVIDE"
  when "&"
    return "AND"
  when "|"
    return "OR"
  when "<"
    return "LT"
  when ">"
    return "GT"
  when "="
    return "EQ"
  end
end

def checkPriority(op, priority)
  result = false
  pr = getPriority(op)
  if pr > priority
    result = true
  end
  return result
end

def getPriority(op)
  if op === "*"
    return 2
  elsif op === "/"
    return 2
  else
    return 1
  end
end

def getUnaryOperator(symbol)
  case symbol
  when "-"
    return "NEG"
  when "~"
    return "NOT"
  end
end

def getSegment(kind)
  case kind
  when "FIELD"
    return "argument"
  when "ARG"
    return "argument"
  when "VAR"
    return "local"
  else
    return ""
  end
end

TokenClass = Struct.new("TokenClass", "token", "tokenType", "keyWord", "symbol", "identifier", "intVal", "stringVal")


