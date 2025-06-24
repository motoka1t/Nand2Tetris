require_relative "./Common.rb"

class CompilationEngine
  
  def initialize(tokens, xmlFilename, classTypes)
    @tokens = tokens
    @xmlFile = File.open(xmlFilename, "w+")
    @xmlIndex = 0
    @token = @tokens.shift
    @classtypes = classTypes
    compileClass()
  end

  def compileClass()
    state = ST_CLASS_KEYWORD
    result = false
    xmlWriteNonTerminal("class", "begin")
    if state === ST_CLASS_KEYWORD
      keywords = ["CLASS"]
      if checkKeyword(@token, keywords)
        xmlWriteTerminal("keyword", @token.keyWord.downcase)
        state = ST_CLASS_NAME
        @token = @tokens.shift()
      end
    end

     if state === ST_CLASS_NAME
      if (@token.tokenType == TK_IDENTIFIER)
        className = @token.identifier
        @classtypes.push(className)
        xmlWriteTerminal("identifier", className)
        state = ST_CLASS_BEGIN
        @token = @tokens.shift()
      end
    end

    if state === ST_CLASS_BEGIN
      symbols = ["{"]
      if checkSymbol(@token, symbols)
        xmlWriteTerminal("symbol", @token.symbol)
        state = ST_CLASS_VAR_DEC
        @token = @tokens.shift()
      end
    end

    if state === ST_CLASS_VAR_DEC
      compileClassVarDec()
      state = ST_CLASS_SUBROUTINE
    end 
    
    if state === ST_CLASS_SUBROUTINE
      compileSubroutine()
      state = ST_CLASS_END
    end
    
    if state === ST_CLASS_END
      symbols = ["}"]
      if checkSymbol(@token, symbols) 
        xmlWriteTerminal("symbol", @token.symbol)
        result = true
        @token = @tokens.shift()         
      end
    end

    xmlWriteNonTerminal("class", "end")
    return result
  end

  def compileClassVarDec()
    state = ST_CLASS_VAR_DEC_KEYWORD
    result = false
    
    while (@tokens.length > 0)
      if state === ST_CLASS_VAR_DEC_KEYWORD
        keywords = ["STATIC", "FIELD"]
        if checkKeyword(@token, keywords)
          xmlWriteNonTerminal("classVarDec", "begin")
          xmlWriteTerminal("keyword", @token.keyWord.downcase)
          state = ST_CLASS_VAR_DEC_TYPE
          @token = @tokens.shift()
        else
          break
        end
      end
      
      if state === ST_CLASS_VAR_DEC_TYPE
        keywords = ["INT", "CHAR", "BOOLEAN"]
        if checkKeyword(@token, keywords)
          xmlWriteTerminal("keyword", @token.keyWord.downcase)
          state = ST_CLASS_VAR_DEC_NAME
          @token = @tokens.shift()
        elsif checkIdentifier(@token, @classtypes)
          xmlWriteTerminal("identifier", @token.identifier)
          state = ST_CLASS_VAR_DEC_NAME
          @token = @tokens.shift()
        end
      end

      if state === ST_CLASS_VAR_DEC_NAME
        if (@token.tokenType == TK_IDENTIFIER)
          xmlWriteTerminal("identifier", @token.identifier)
          state = ST_CLASS_VAR_DEC_NEXT
          @token = @tokens.shift()
        end
      end

      if state === ST_CLASS_VAR_DEC_NEXT
        symbols1 = [","]
        symbols2 = [";"]
        if checkSymbol(@token, symbols1)
          xmlWriteTerminal("symbol", @token.symbol)   
          state = ST_CLASS_VAR_DEC_NAME  
          @token = @tokens.shift()
        elsif checkSymbol(@token, symbols2)
          xmlWriteTerminal("symbol", @token.symbol) 
          xmlWriteNonTerminal("classVarDec", "end")
          state = ST_CLASS_VAR_DEC_KEYWORD
          @token = @tokens.shift()
          result = true
        end
      end
    end
  
  return result
  end

  def compileSubroutine()
    state = ST_CLASS_SUBROUTINE_KEYWORD
    result = false
    

    while (@tokens.length > 0)
      if state === ST_CLASS_SUBROUTINE_KEYWORD
        keywords = ["CONSTRUCTOR", "FUNCTION", "METHOD"]
        if checkKeyword(@token, keywords)
          xmlWriteNonTerminal("subroutineDec", "begin")
          xmlWriteTerminal("keyword", @token.keyWord.downcase)
          state = ST_CLASS_SUBROUTINE_TYPE
          @token = @tokens.shift()
        else
          break
        end
      end

      if state === ST_CLASS_SUBROUTINE_TYPE
        keywords = ["VOID", "INT", "CHAR", "BOOLEAN"]
        if checkKeyword(@token, keywords)
          xmlWriteTerminal("keyword", @token.keyWord.downcase)    
          state = ST_CLASS_SUBROUTINE_NAME
          @token = @tokens.shift() 
        elsif checkIdentifier(@token, @classtypes)
          xmlWriteTerminal("identifier", @token.identifier)
          state = ST_CLASS_SUBROUTINE_NAME
          @token = @tokens.shift() 
        else
          break 
        end
      end

      if state === ST_CLASS_SUBROUTINE_NAME
        if (@token.tokenType == TK_IDENTIFIER)
          xmlWriteTerminal("identifier", @token.identifier)
          state = ST_CLASS_SUBROUTINE_BEGIN_PARAMETER 
          @token = @tokens.shift()    
        else
          break                 
        end
      end

      if state === ST_CLASS_SUBROUTINE_BEGIN_PARAMETER
        symbols = ["("]
        if checkSymbol(@token, symbols)
          xmlWriteTerminal("symbol", @token.symbol) 
          state = ST_CLASS_SUBROUTINE_PARAMETERLIST
          @token = @tokens.shift() 
        else
          break   
        end
      end      

      if state === ST_CLASS_SUBROUTINE_PARAMETERLIST
        compileParameterList()
        state = ST_CLASS_SUBROUTINE_END_PARAMETER
      end

      if state === ST_CLASS_SUBROUTINE_END_PARAMETER
        symbols = [")"]
        if checkSymbol(@token, symbols)
          xmlWriteTerminal("symbol", @token.symbol)  
          state = ST_CLASS_SUBROUTINE_BEGIN_BODY
          @token = @tokens.shift()      
        else
          break
        end
      end

      xmlWriteNonTerminal("subroutineBody", "begin") 

      if state === ST_CLASS_SUBROUTINE_BEGIN_BODY
        symbols = ["{"]
        if checkSymbol(@token, symbols)
          xmlWriteTerminal("symbol", @token.symbol)
          state = ST_CLASS_SUBROUTINE_BODY_VARDEC  
          @token = @tokens.shift()
        end      
      end

      if state === ST_CLASS_SUBROUTINE_BODY_VARDEC
        compileVarDec()
        state = ST_CLASS_SUBROUTINE_BODY
      end

      if state === ST_CLASS_SUBROUTINE_BODY
        compileStatements()       
        state = ST_CLASS_SUBROUTINE_END_BODY
      end

      if state === ST_CLASS_SUBROUTINE_END_BODY
        symbols = ["}"]
        if checkSymbol(@token, symbols)  
          xmlWriteTerminal("symbol", @token.symbol)    
          state = ST_CLASS_SUBROUTINE_KEYWORD
          @token = @tokens.shift()
          result = true
        end         
      end
      xmlWriteNonTerminal("subroutineBody", "end") 
      xmlWriteNonTerminal("subroutineDec", "end")
    end
    return result
  end

  def compileParameterList()
    state = ST_PARAMETER_LIST_TYPE
    result = false
    xmlWriteNonTerminal("parameterList", "begin")

    while (@tokens.length > 0)
      if state === ST_PARAMETER_LIST_TYPE
        keywords = ["INT", "CHAR", "BOOLEAN"]
        if checkKeyword(@token, keywords)
          xmlWriteTerminal("keyword", @token.keyWord.downcase)
          state = ST_PARAMETER_LIST_NAME
          @token = @tokens.shift()
        else
          break
        end
      end
      
      if state === ST_PARAMETER_LIST_NAME  
        if (@token.tokenType == TK_IDENTIFIER)
          xmlWriteTerminal("identifier", @token.identifier)
          state = ST_PARAMETER_LIST_NEXT
          @token = @tokens.shift()
        end
      end  

      if state === ST_PARAMETER_LIST_NEXT
        symbols = [","]
        if checkSymbol(@token, symbols)
          xmlWriteTerminal("symbol", @token.symbol)
          state = ST_PARAMETER_LIST_TYPE
          @token = @tokens.shift()          
        else
          break
        end
      end
    end
    xmlWriteNonTerminal("parameterList", "end") 
    return result  
  end

  def compileVarDec()
    state = ST_VAR_DEC_KEYWORD
    result = false
    
    while (@tokens.length > 0)
      if state === ST_VAR_DEC_KEYWORD
        keywords = ["VAR"]
        if checkKeyword(@token, keywords)
          xmlWriteNonTerminal("varDec", "begin")
          xmlWriteTerminal("keyword", @token.keyWord.downcase)
          state = ST_VAR_DEC_TYPE 
          @token = @tokens.shift()
        else
          break 
        end
      end 
      
      if state === ST_VAR_DEC_TYPE
        keywords = ["INT", "CHAR", "BOOLEAN"]
        if checkKeyword(@token, keywords)
          xmlWriteTerminal("keyword", @token.keyWord.downcase)
          state = ST_VAR_DEC_NAME
          @token = @tokens.shift()
        elsif checkIdentifier(@token, @classtypes)
          xmlWriteTerminal("identifier", @token.identifier) 
          state = ST_VAR_DEC_NAME
          @token = @tokens.shift()
        end
      end

      if state === ST_VAR_DEC_NAME
        if (@token.tokenType == TK_IDENTIFIER)
          xmlWriteTerminal("identifier", @token.identifier)  
          state = ST_VAR_DEC_NEXT
          @token = @tokens.shift()
        end
      end

      if state === ST_VAR_DEC_NEXT
        symbols1 = [","]
        symbols2 = [";"]
        if checkSymbol(@token, symbols1)
          xmlWriteTerminal("symbol", @token.symbol)
          state = ST_VAR_DEC_NAME
          @token = @tokens.shift()
        elsif checkSymbol(@token, symbols2)
          xmlWriteTerminal("symbol", @token.symbol)
          xmlWriteNonTerminal("varDec", "end")
          state = ST_VAR_DEC_KEYWORD
          result = true
          @token = @tokens.shift()
        end
      end
    end
    return result
  end

  def compileStatements()
    result = false
    xmlWriteNonTerminal("statements", "begin")
    while(@tokens.length > 0)
      if compileLet() or compileIf() or compileWhile() or compileDo() or compileReturn() 
        #print "statements*"
        #print "\n"
      else
        break
      end
    end
    xmlWriteNonTerminal("statements", "end")
    return result 
  end

  def compileDo()
    state = ST_DO_KEYWORD
    varName = ""
    subRoutinename = ""
    result = false

    if state === ST_DO_KEYWORD
      keywords = ["DO"]
      if checkKeyword(@token, keywords)  
        xmlWriteNonTerminal("doStatement", "begin")
        xmlWriteTerminal("keyword", @token.keyWord.downcase)
        state = ST_DO_SUBROUTINE_NAME
        @token = @tokens.shift()
      end
    end

    while (@tokens.length > 0)
      if state === ST_DO_SUBROUTINE_NAME
        if (@token.tokenType == TK_IDENTIFIER)
          varName = subRoutinename
          subRoutinename = @token.identifier
          xmlWriteTerminal("identifier", @token.identifier) 
          state = ST_DO_SUBROUTINE_NAME_NEXT
          @token = @tokens.shift() 
        end
      else
        break
      end

      if state === ST_DO_SUBROUTINE_NAME_NEXT
        symbols = ["."]
        if checkSymbol(@token, symbols)
          xmlWriteTerminal("symbol", @token.symbol)
          state = ST_DO_SUBROUTINE_NAME
          @token = @tokens.shift() 
        else
          state = ST_DO_SUBROUTINE_BEGIN_EXPRESSIONLIST
          break
        end 
      end    
    end   

    if state === ST_DO_SUBROUTINE_BEGIN_EXPRESSIONLIST
      symbols = ["("]      
      if checkSymbol(@token, symbols)
        xmlWriteTerminal("symbol", @token.symbol)   
        state = ST_DO_SUBROUTINE_EXPRESSIONLIST
        @token = @tokens.shift() 
      end
    end

    if state === ST_DO_SUBROUTINE_EXPRESSIONLIST
      compileExpressionList()
      state = ST_DO_SUBROUTINE_END_EXPRESSIONLIST
    end

    if state === ST_DO_SUBROUTINE_END_EXPRESSIONLIST
      symbols = [")"]         
      if checkSymbol(@token, symbols)
        xmlWriteTerminal("symbol", @token.symbol)
        state = ST_DO_END
        @token = @tokens.shift() 
      end
    end
    
    if state === ST_DO_END
      symbols = [";"]         
      if checkSymbol(@token, symbols)
        xmlWriteTerminal("symbol", @token.symbol)
        xmlWriteNonTerminal("doStatement", "end") 
        @token = @tokens.shift()     
        result = true
      end          
    end   
    return result  
  end

  def compileLet()
    state = ST_LET_KEYWORD
    result = false

    if state === ST_LET_KEYWORD
      keywords = ["LET"]
      if checkKeyword(@token, keywords)
        xmlWriteNonTerminal("letStatement", "begin")
        xmlWriteTerminal("keyword", @token.keyWord.downcase)
        state = ST_LET_VARNAME
        @token = @tokens.shift()
      end
    end

    if state === ST_LET_VARNAME
      if (@token.tokenType == TK_IDENTIFIER) 
        varName = @token.identifier
        xmlWriteTerminal("identifier", @token.identifier)
        state = ST_LET_BEGIN_LEFT_EXPRESSION
        @token = @tokens.shift()
      end
    end
    
    if state === ST_LET_BEGIN_LEFT_EXPRESSION
      symbols = ["["]
      if checkSymbol(@token, symbols)
        xmlWriteTerminal("symbol", @token.symbol)
        state = ST_LET_LEFT_EXPRESSION
        @token = @tokens.shift()
      else
        state = ST_LET_EQUAL
      end
    end

    if state === ST_LET_LEFT_EXPRESSION
      compileExpression()
      state = ST_LET_END_LEFT_EXPRESSION
    end
    
    if state === ST_LET_END_LEFT_EXPRESSION
      symbols = ["]"]
      if checkSymbol(@token, symbols)
        xmlWriteTerminal("symbol", @token.symbol)
        state = ST_LET_EQUAL
        @token = @tokens.shift()
      end
    end

    if state === ST_LET_EQUAL
      symbols = ["="]
      if checkSymbol(@token, symbols)
        xmlWriteTerminal("symbol", @token.symbol)
        state = ST_LET_RIGHT_EXPRESSION
        @token = @tokens.shift()
      end
    end

    if state === ST_LET_RIGHT_EXPRESSION
      compileExpression()   
      state = ST_LET_NEXT
    end

    if state === ST_LET_NEXT
      symbols = [";"]
      if checkSymbol(@token, symbols)
        xmlWriteTerminal("symbol", @token.symbol) 
        xmlWriteNonTerminal("letStatement", "end") 
        @token = @tokens.shift()
        result = true
      end
    end 
    return result
  end

  def compileWhile()
    state = ST_WHILE_KEYWORD
    result = false

    if state === ST_WHILE_KEYWORD
      keywords = ["WHILE"]
      if checkKeyword(@token, keywords)
        xmlWriteNonTerminal("whileStatement", "begin")  
        xmlWriteTerminal("keyword", @token.keyWord.downcase) 
        state = ST_WHILE_BEGIN_CONDITION
        @token = @tokens.shift()
      end
    end

    if state === ST_WHILE_BEGIN_CONDITION
      symbols = ["("]
      if checkSymbol(@token, symbols)
        xmlWriteTerminal("symbol", @token.symbol) 
        state = ST_WHILE_CONDITION
        @token = @tokens.shift()
      end
    end

    if state === ST_WHILE_CONDITION
      print @token
      compileExpression()
      state = ST_WHILE_END_CONDITION
    end

    if state ===ST_WHILE_END_CONDITION
      symbols = [")"]
      if checkSymbol(@token, symbols)
        xmlWriteTerminal("symbol", @token.symbol) 
        state = ST_WHILE_BEGIN_BODY
        @token = @tokens.shift()
      end
    end

    if state === ST_WHILE_BEGIN_BODY
      symbols = ["{"]
      if checkSymbol(@token, symbols)
        xmlWriteTerminal("symbol", @token.symbol)  
        state = ST_WHILE_BODY
        @token = @tokens.shift()
      end
    end
    
    if state === ST_WHILE_BODY
      compileStatements()
      state = ST_WHILE_END_BODY
    end

    if state === ST_WHILE_END_BODY
      symbols = ["}"]
      if checkSymbol(@token, symbols)
        state = ST_WHILE_KEYWORD
        xmlWriteTerminal("symbol", @token.symbol) 
        xmlWriteNonTerminal("whileStatement", "end")                     
        result = true
        @token = @tokens.shift()
      end        
    end
    print @token
    return result
  end

  def compileReturn()
    state = ST_RETURN_KEYWORD
    result = false
 
    if state === ST_RETURN_KEYWORD
      keywords = ["RETURN"]
      if checkKeyword(@token, keywords)
        state = ST_RETURN_VALUE
        xmlWriteNonTerminal("returnStatement", "begin")  
        xmlWriteTerminal("keyword", @token.keyWord.downcase) 
        @token = @tokens.shift()
      end
    end

    if state === ST_RETURN_VALUE
      compileExpression()
      state = ST_RETURN_END
    end
    
    if state === ST_RETURN_END
      symbols = [";"]
      if checkSymbol(@token, symbols)
        state = ST_RETURN_KEYWORD
        xmlWriteTerminal("symbol", @token.symbol)  
        xmlWriteNonTerminal("returnStatement", "end")  
        result = true
        @token = @tokens.shift()       
      end   
    end
    return result
  end

  def compileIf() 
    state = ST_IF_KEYWORD
    result = false

    if state === ST_IF_KEYWORD
      keywords = ["IF"]
      if checkKeyword(@token, keywords)
        xmlWriteNonTerminal("ifStatement", "begin")  
        xmlWriteTerminal("keyword", @token.keyWord)
        state = ST_IF_BEGIN_CONDITION
        @token = @tokens.shift()          
      end
    end

    if state === ST_IF_BEGIN_CONDITION
      symbols = ["("]
      if checkSymbol(@token, symbols)
        xmlWriteTerminal("symbol", @token.symbol)
        state = ST_IF_CONDITION
        @token = @tokens.shift()          
      end
    end   
    
    if state === ST_IF_CONDITION
      compileExpression()
      state = ST_IF_END_CONDITION
    end

    if state === ST_IF_END_CONDITION
      symbols = [")"]
      if checkSymbol(@token, symbols)
        xmlWriteTerminal("symbol", @token.symbol)
        state = ST_IF_BEGIN_BODY
        @token = @tokens.shift()       
      end
    end

    if state ===ST_IF_BEGIN_BODY
      symbols = ["{"]
      if checkSymbol(@token, symbols)
        xmlWriteTerminal("symbol", @token.symbol)
        state = ST_IF_BODY
        @token = @tokens.shift()          
      end
    end
    
    if state === ST_IF_BODY
      compileStatements()
      state = ST_IF_END_BODY
    end

    if state === ST_IF_END_BODY
      symbols = ["}"]
      if checkSymbol(@token, symbols)
        xmlWriteTerminal("symbol", @token.symbol) 
        state = ST_ELSE_KEYWORD
        @token = @tokens.shift()  
        result = true        
      end
    end   
    
    if state === ST_ELSE_KEYWORD
      keywords = ["ELSE"]
      if checkKeyword(@token, keywords)
        state = ST_ELSE_BEGIN_BODY
        xmlWriteTerminal("keyword", @token.keyWord.downcase)
        @token = @tokens.shift()              
      end    
    end        
    
    if state === ST_ELSE_BEGIN_BODY
      symbols = ["{"]
      if checkSymbol(@token, symbols)
        xmlWriteTerminal("symbol", @token.symbol) 
        state = ST_ELSE_BODY
        @token = @tokens.shift()           
      end
    end     
    
    if state === ST_ELSE_BODY
      compileStatements()
      state = ST_ELSE_END_BODY
    end

    if state === ST_ELSE_END_BODY
      symbols = ["}"]
      if checkSymbol(@token, symbols)
        xmlWriteTerminal("symbol", @token.symbol)   
        
        result = true 
        @token = @tokens.shift()               
      end          
    end 
    if result
      xmlWriteNonTerminal("ifStatement", "end") 
    end
    return result
  end

  def compileExpression()
    state = ST_EXPRESSION_TERM
    result = false
    hasExpression = false
    while (@tokens.length > 0)
      if state === ST_EXPRESSION_TERM
        symbols = [")", ";"]
        if checkSymbol(@token, symbols)
          break
        end
        if not hasExpression
          xmlWriteNonTerminal("expression", "begin")
          hasExpression = true
        end
        if compileTerm()
          state = ST_EXPRESSION_NEXT
          result = true
        else
          break
        end
      end
    
      if state === ST_EXPRESSION_NEXT
        symbols = ["+", "-", "*", "/", "&", "|", "<", ">", "="]
        if checkSymbol(@token, symbols)
          xmlWriteTerminal("symbol", @token.symbol)
          state = ST_EXPRESSION_TERM
          @token = @tokens.shift()
        else
          break
        end
      end
    end
    if hasExpression
      xmlWriteNonTerminal("expression", "end") 
    end 
    return result
  end

  def compileTerm()
    state = ST_TERM_FIRST_STEP
    result = false
    xmlWriteNonTerminal("term", "begin")
    if state === ST_TERM_FIRST_STEP
      case @token.tokenType
      when TK_INT_CONST
        xmlWriteTerminal("integerConstant", @token.intVal.to_s)
        @token = @tokens.shift()
        result = true
      when TK_STRING_CONST
        xmlWriteTerminal("stringConstant", @token.stringVal)
        @token = @tokens.shift()
        result = true
      when TK_KEYWORD
        keywords = ["TRUE", "FALSE", "NULL", "THIS"]
        if checkKeyword(@token, keywords)
          xmlWriteTerminal("keyword", @token.keyWord.downcase) 
          @token = @tokens.shift()
          result = true
        end
      when TK_IDENTIFIER
        nexttoken = @tokens.shift()
        @tokens.unshift(nexttoken)
        symbols1 = ["["]
        symbols2 = ["{"]
        symbols3 = ["."]
        if checkSymbol(nexttoken, symbols1)
          xmlWriteTerminal("identifier", @token.identifier)  
          state = ST_TERM_BEGIN_ARRAY
          @token = @tokens.shift()
        elsif checkSymbol(nexttoken, symbols2)
          xmlWriteTerminal("identifier", @token.identifier)           
          state = ST_TERM_SUBROUTINE_BEGIN_BODY
          @token = @tokens.shift()
        elsif checkSymbol(nexttoken, symbols3)
          xmlWriteTerminal("identifier", @token.identifier)            
          state = ST_TERM_SUBROUTINE_NAME_NEXT
          @token = @tokens.shift()
        else 
          xmlWriteTerminal("identifier", @token.identifier)
          @token = @tokens.shift()
          result = true
        end
      when TK_SYMBOL
        print @token
        if (@token.symbol === "(")
          xmlWriteTerminal("symbol", @token.symbol) 
          state = ST_TERM_EXPRESSION
          @token = @tokens.shift()
        elsif ((@token.symbol === "-") or (@token.symbol === "~"))
          xmlWriteTerminal("symbol", @token.symbol) 
          state = ST_TERM_UNARY_OPERATOR
          @token = @tokens.shift()
        end  
      end
    end

    if state === ST_TERM_BEGIN_ARRAY
      symbols = ["["]
      if checkSymbol(@token, symbols)
        xmlWriteTerminal("symbol", @token.symbol)
        state = ST_TERM_ARRAY
        @token = @tokens.shift()
      end
    end

    if state === ST_TERM_ARRAY 
      compileExpression()
      state = ST_TERM_END_ARRAY
    end

    if state === ST_TERM_END_ARRAY
      symbols = ["]"]
      if checkSymbol(@token, symbols)
        xmlWriteTerminal("symbol", @token.symbol) 
        @token = @tokens.shift()
        result = true
      end
    end

    if state === ST_TERM_SUBROUTINE_NAME_NEXT
      symbols = ["."]
      if checkSymbol(@token, symbols)
        xmlWriteTerminal("symbol", @token.symbol) 
        state = ST_TERM_SUBROUTINE_METHOD_NAME
        @token = @tokens.shift()
      end
    end

    if state === ST_TERM_SUBROUTINE_METHOD_NAME
      if @token.tokenType == TK_IDENTIFIER
        xmlWriteTerminal("identifier", @token.identifier) 
        state = ST_TERM_SUBROUTINE_BEGIN_BODY
        @token = @tokens.shift()
      end
    end   

    if state === ST_TERM_SUBROUTINE_BEGIN_BODY
      symbols = ["("]
      if checkSymbol(@token, symbols)
        xmlWriteTerminal("symbol", @token.symbol) 
        state = ST_TERM_SUBROUTINE_BODY
        @token = @tokens.shift()
      end
    end

    if state === ST_TERM_SUBROUTINE_BODY
      compileExpressionList()
      state = ST_TERM_SUBROUTINE_END_BODY
    end

    if state === ST_TERM_SUBROUTINE_END_BODY
      symbols = [")"]
      if checkSymbol(@token, symbols)
        xmlWriteTerminal("symbol", @token.symbol) 
        @token = @tokens.shift()
        result = true
      end
    end 

    if state === ST_TERM_BEGIN_EXPRESSION
      symbols = ["("]
      if checkSymbol(@token, symbols)
        xmlWriteTerminal("symbol", @token.symbol)             
        state = ST_TERM_EXPRESSION
        @token = @tokens.shift()
      end
    end        
    
    if state === ST_TERM_EXPRESSION
      compileExpression()
      state = ST_TERM_END_EXPORESSIOn
    end

    if state === ST_TERM_END_EXPORESSIOn
      symbols = [")"]
      if checkSymbol(@token, symbols)
        xmlWriteTerminal("symbol", @token.symbol)  
        @token = @tokens.shift()                    
        result = true
      end
    end

    if state === ST_TERM_UNARY_OPERATOR
      result = compileTerm() 
    end
    xmlWriteNonTerminal("term", "end")   
    return result
  end

  def compileExpressionList()
    state = ST_EXPRESSION_LIST
    result = false
    xmlWriteNonTerminal("expressionList", "begin")  
    while(@tokens.length > 0)
      if state === ST_EXPRESSION_LIST
        if compileExpression()
          state = ST_EXPRESSION_LIST_NEXT
          result = true
        else
          break
        end
      end
    
      if state === ST_EXPRESSION_LIST_NEXT
        symbols = [","]
        if checkSymbol(@token, symbols)
          xmlWriteTerminal("symbol", @token.symbol)
          state = ST_EXPRESSION_LIST
          @token = @tokens.shift()        
        else
          break
        end       
      end
    end
     xmlWriteNonTerminal("expressionList", "end")     
    return result
  end

  def checkKeyword(token, keywords)
    if (token.tokenType == TK_KEYWORD) 
      case token.keyWord
      when *keywords
        return true
      else
        return false
      end
    else
      return false
    end  
  end

  def checkIdentifier(token, identifiers)
    if (token.tokenType == TK_IDENTIFIER) 
      case token.identifier
      when *identifiers
        return true
      else
        return false
      end
    else
      return false
    end  
  end

  def checkSymbol(token, symbols)
    if (token.tokenType == TK_SYMBOL) 
      case token.symbol
      when *symbols
        return true
      else
        return false
      end
    else
      return false
    end  
  end

  def xmlWriteIndent()
    cnt = 0
    while (cnt < @xmlIndex)
      @xmlFile.print " "
      cnt = cnt + 1
    end
  end

  def xmlWriteNonTerminal(name, flag)
    if (flag === "begin")
      xmlWriteIndent()
      @xmlFile.print "<"+name+">\n"
      @xmlIndex = @xmlIndex + 2
    else
      @xmlIndex = @xmlIndex - 2
      xmlWriteIndent()
      @xmlFile.print "</"+name+">\n"
    end
  end

  def xmlWriteTerminal(name, value)
    xmlWriteIndent()
    @xmlFile.print "<"+name+">" + " " + value + " " + "</"+name+">\n"
  end  
end