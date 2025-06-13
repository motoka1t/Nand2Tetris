require_relative "./Common.rb"
require_relative "./JACKTokenizer.rb"

class CompilationEngine
  
  def initialize(jackFilename, xmlFilename)
    @jackTokenizer = JackTokenizer.new(jackFilename)
    @xmlFile = File.open(xmlFilename, "w+")
  end

  def compile()
    compileClass()
  end
  
  def compileClass()
    parseState = ST_CL_KEYWORD
    @jackTokenizer.advance
    while (@jackTokenizer.hasMoreTokens)
      if !(@jackTokenizer.inComment)
        if (parseState == ST_CL_KEYWORD)
          if (@jackTokenizer.tokenType == TK_KEYWORD)
            if (@jackTokenizer.keyWord == "CLASS")
              printKeyword()
              parseState = ST_CL_NAME
            end
          end
        elsif (parseState == ST_CL_NAME)
          if (@jackTokenizer.tokenType == TK_IDENTIFIER)
            printIdentifier()
            parseState = ST_CL_BEGIN
          end
        elsif (parseState == ST_CL_BEGIN)
          if (@jackTokenizer.tokenType == TK_SYMBOL)
            if (@jackTokenizer.symbol == "{")
              printSymbol()
              parseState = ST_CL_END
            end
          end
        else
          compileClassVarDec()
          compileSubroutine()          
          if (@jackTokenizer.tokenType == TK_SYMBOL)
            if(@jackTokenizer.symbol == "}")
              printSymbol()
              return 0
            end
          end
        end
      end
      @jackTokenizer.advance
    end
  end

  def compileClassVarDec()
    parseState = ST_CLVD_KEYWORD
    while (@jackTokenizer.hasMoreTokens)
      if !(@jackTokenizer.inComment)

        if (parseState == ST_CLVD_KEYWORD)
          if (@jackTokenizer.tokenType == TK_KEYWORD)
            if (@jackTokenizer.keyWord == "STATIC") || (@jackTokenizer.keyWord == "FIELD")
              printKeyword()
              parseState = ST_CLVD_TYPE
            else
              return 0
            end
          end
        elsif (parseState == ST_CLVD_TYPE)
          if compileType()
            parseState = ST_CLVD_NAME
          end
        elsif (parseState == ST_CLVD_NAME)
          if (@jackTokenizer.tokenType == TK_IDENTIFIER)
            printIdentifier()
            parseState = ST_CLVD_VAR
          end
        else
          if (@jackTokenizer.tokenType == TK_SYMBOL)
            if (@jackTokenizer.symbol == ";")
              printSymbol()
              parseState = ST_CLVD_KEYWORD
            elsif (@jackTokenizer.symbol == ",")
              printSymbol()
              parseState = ST_CLVD_NAME
            end
          end
        end
      end
      @jackTokenizer.advance
    end
  end

  def compileType()
    if (@jackTokenizer.tokenType == TK_KEYWORD)     
      if (@jackTokenizer.keyWord == "INT") || (@jackTokenizer.keyWord == "CHAR") || (@jackTokenizer.keyWord == "BOOLEAN")
        printKeyword()
        return true
      end
    elsif (@jackTokenizer.tokenType == TK_IDENTIFIER)
      printIdentifier()
      return true
    end
  return false
  end

  def compileSubroutine()
    parseState = ST_CLSR_KEYWORD
    while (@jackTokenizer.hasMoreTokens)
      if !(@jackTokenizer.inComment)

        if (parseState == ST_CLSR_KEYWORD)
          if (@jackTokenizer.tokenType == TK_KEYWORD)
            if (@jackTokenizer.keyWord == "CONSTRUCTOR") || (@jackTokenizer.keyWord == "FUNCTION") || (@jackTokenizer.keyWord == "METHOD")
              printKeyword()
              parseState = ST_CLSR_TYPE
            else
              return 0
            end
          end
        elsif (parseState == ST_CLSR_TYPE)
          if (@jackTokenizer.tokenType == TK_KEYWORD) &&(@jackTokenizer.keyWord = "VOID")
            printKeyWord()
            parseState = ST_CLSR_NAME
          elsif compileType()
            parseState = ST_CLSR_NAME
          end
        elsif (parseState == ST_CLSR_NAME)
          if (@jackTokenizer.tokenType == TK_IDENTIFIER)
            printIdentifier()
            parseState = ST_CLSR_BEGIN_PARAMETER
          end
        elsif (parseState == ST_CLSR_BEGIN_PARAMETER )
          if (@jackTokenizer.tokenType == TK_SYMBOL)
            if (@jackTokenizer.symbol == "(")
              printSymbol()
              parseState = ST_CLSR_END_PARAMETER
            end
          end
        elsif (parseState == ST_CLSR_END_PARAMETER )
          compileParameterList() 
          if (@jackTokenizer.tokenType == TK_SYMBOL)
            if (@jackTokenizer.symbol == ")")
              printSymbol()
              parseState = ST_CLSR_NEXT
            end
          end
        else
          compileSubroutineBody()
          return 0
        end
      end
    @jackTokenizer.advance
    end
  end

  def compileParameterList()
    parseState = ST_PL_TYPE
    while (@jackTokenizer.hasMoreTokens)
      if !(@jackTokenizer.inComment)

        if (parseState == ST_PL_TYPE)
          if compileType() 
            parseState = ST_PL_NAME
          else
            return 0
          end
        elsif (parseState == ST_PL_NAME)
          if (@jackTokenizer.tokenType == TK_IDENTIFIER)
            printIdentifier()
            parseState = ST_PL_NEXT
          end
        else
          if (@jackTokenizer.tokenType == TK_SYMBOL)
            if (@jackTokenizer.symbol == ")")
              return 0
            elsif (@jackTokenizer.symbol == ",")
              printSymbol()
              parseState = ST_PL_TYPE
            end
          end
        end
      end
    @jackTokenizer.advance
    end
  end
  
  def compileSubroutineBody()
    parseState = ST_SB_BEGIN
    while (@jackTokenizer.hasMoreTokens)
      if !(@jackTokenizer.inComment)

        if (parseState == ST_SB_BEGIN)
          if (@jackTokenizer.tokenType == TK_SYMBOL)
            if (@jackTokenizer.symbol == "{")
              printSymbol()
              parseState = ST_SB_END
            end
          end
        else
          compileVarDec()
          compileStatements()
          if (@jackTokenizer.tokenType == TK_SYMBOL)
            if (@jackTokenizer.symbol == "}")
              printSymbol()
              return 0
            end
          end
        end
      end
    @jackTokenizer.advance
    end
  end

  def compileVarDec()
    parseState = ST_VD_KEYWORD
    while (@jackTokenizer.hasMoreTokens)
      if !(@jackTokenizer.inComment)

        if (parseState == ST_VD_KEYWORD)
          if (@jackTokenizer.tokenType == TK_KEYWORD)
            if (@jackTokenizer.keyWord == "VAR")
              printKeyword()
              parseState = ST_VD_TYPE
            else
              return 0
            end
          end
        elsif (parseState == ST_VD_TYPE)
          if compileType()
            parseState = ST_VD_NAME
          else
            return 0
          end
        elsif (parseState == ST_VD_NAME)
          if (@jackTokenizer.tokenType == TK_IDENTIFIER)
            printIdentifier()
            parseState = ST_VD_NEXT
          end
        else
          if (@jackTokenizer.tokenType == TK_SYMBOL)
            if (@jackTokenizer.symbol == ";")
              parseState = ST_VD_KEYWORD
            elsif (@jackTokenizer.symbol == ",")
              printSymbol()
              parseState = ST_VD_NAME
            end
          end
        end
      end
    @jackTokenizer.advance
    end
  end

  def compileStatements()
    while (@jackTokenizer.hasMoreTokens)
      if !(@jackTokenizer.inComment)
        state = compileLet() || compileIf() || compileWhile() || compileDo() || compileReturn()
        if (state == false)
          return 0
        end
      end
      @jackTokenizer.advance
    end
  end

  def compileLet()
    parseState = ST_LT_KEYWORD
    while (@jackTokenizer.hasMoreTokens)
      if !(@jackTokenizer.inComment)

        if (parseState == ST_LT_KEYWORD)
          if (@jackTokenizer.tokenType == TK_KEYWORD)
            if (@jackTokenizer.keyWord == "LET")
              printKeyword()
              parseState = ST_LT_NAME
            else
              return false
            end
          end
        elsif (parseState == ST_LT_NAME)
          if (@jackTokenizer.tokenType == TK_IDENTIFIER)
            printIdentifier()
            parseState = ST_LT_EQUAL
          end
        elsif (parseState == ST_LT_EQUAL)
          if (@jackTokenizer.tokenType == TK_SYMBOL)
            if (@jackTokenizer.symbol == "=")
              printSymbol()
              compileExpression()
              parseState = ST_LT_NEXT
            elsif (@jackTokenizer.symbol == "[")
              printSymbol()
              parseState == ST_LT_INDEX
            end
          end
        elsif (parseState == ST_LT_INDEX)
          compileExpression()
          if (@jackTokenizer.tokenType == TK_SYMBOL)
            if (@jackTokenizer.symbol == "]")
              printSymbol()
              parseState == ST_LT_EQUAL
            end
          end
        else
          if (@jackTokenizer.tokenType == TK_SYMBOL)
            if (@jackTokenizer.symbol == ";")
              return true
            end
          end
        end
      end
      @jackTokenizer.advance
    end
  end

  def compileIf()
    parseState = ST_IF_KEYWORD
    while (@jackTokenizer.hasMoreTokens)
      if !(@jackTokenizer.inComment)

        if (parseState == ST_IF_KEYWORD)
          if (@jackTokenizer.tokenType == TK_KEYWORD)
            if (@jackTokenizer.keyWord == "IF")
              printKeyword()
              parseState = ST_IF_BEGIN_CONDITION
            else
              return false
            end
          end
        elsif (parseState == ST_IF_BEGIN_CONDITION)
          if (@jackTokenizer.tokenType == TK_SYMBOL)
            if (@jackTokenizer.symbol == "(")
              printSymbol()
              parseState = ST_IF_END_CONDITION
            end
          end
        elsif (parseState == ST_IF_END_CONDITION)
          compileExpression()
          if (@jackTokenizer.tokenType == TK_SYMBOL)
            if (@jackTokenizer.symbol == ")")
              parseState = ST_IF_BEGIN_BODY
            end
          end
        elsif (parseState == ST_IF_BEGIN_BODY)
          if (@jackTokenizer.tokenType == TK_SYMBOL)
            if (@jackTokenizer.symbol == "{")
              parseState == ST_IF_END_BODY
            end
          end
        elsif (parseState == ST_IF_END_BODY)
          compileStatements()
          if (@jackTokenizer.tokenType == TK_SYMBOL)
            if (@jackTokenizer.symbol == "}")
              parseState == ST_IF_NEXT
            end
          end          
        elsif (parseState == ST_IF_NEXT)
          if (@jackTokenizer.tokenType == TK_SYMBOL)
            if (@jackTokenizer.symbol == "?")
              return true
            end
          elsif (@jackTokenizer.tokenType == TK_KEYWORD)
            if (@jackTokenizer.keyWord == "ELSE")
              parseState = ST_ELSE_BEGIN_BODY
            end
          end
        elsif (parseState == ST_ELSE_BEGIN_BODY)
          if (@jackTokenizer.tokenType == TK_SYMBOL)
            if (@jackTokenizer.symbol == "{")
              parseState == ST_ELSE_END_BODY
            end
          end
        elsif (parseState == ST_ELSE_END_BODY)
          compileStatements()
          if (@jackTokenizer.tokenType == TK_SYMBOL)
            if (@jackTokenizer.symbol == "}")
              parseState == ST_IF_NEXT
            end
          end          
        else
          if (@jackTokenizer.tokenType == TK_SYMBOL)
            if (@jackTokenizer.symbol == "?")
              return true
            end
          end
        end
      end
      @jackTokenizer.advance
    end
  end
  
  def compileWhile()
    parseState = ST_WHILE_KEYWORD
    while (@jackTokenizer.hasMoreTokens)
      if !(@jackTokenizer.inComment)

        if (parseState == ST_WHILE_KEYWORD)
          if (@jackTokenizer.tokenType == TK_KEYWORD)
            if (@jackTokenizer.keyWord == "WHILE")
              printKeyword()
              parseState = ST_WHILE_BEGIN_CONDITION
            else
              return false
            end
          end
        elsif (parseState == ST_WHILE_BEGIN_CONDITION)
          if (@jackTokenizer.tokenType == TK_SYMBOL)
            if (@jackTokenizer.symbol == "(")
              printSymbol()
              parseState = ST_WHILE_END_CONDITION
            end
          end
        elsif (parseState == ST_WHILE_END_CONDITION)
          compileExpression()
          if (@jackTokenizer.tokenType == TK_SYMBOL)
            if (@jackTokenizer.symbol == ")")
              printSymbol()
              parseState = ST_WHILE_BEGIN_BODY
            end
          end
        elsif (parseState == ST_WHILE_BEGIN_BODY)
          if (@jackTokenizer.tokenType == TK_SYMBOL)
            if (@jackTokenizer.symbol == "{")
              printSymbol()
              parseState = ST_WHILE_END_BODY
            end
          end
        elsif (parseState == ST_WHILE_END_BODY)
          if (@jackTokenizer.tokenType == TK_SYMBOL)
            if (@jackTokenizer.symbol == "}")
              printSymbol()
              return true
            end
          end
        end
      end
      @jackTokenizer.advance
    end
  end

  def compileDo()
    parseState = ST_DO_KEYWORD
    while (@jackTokenizer.hasMoreTokens)
      if !(@jackTokenizer.inComment)

        if (parseState == ST_DO_KEYWORD)
          if (@jackTokenizer.tokenType == TK_KEYWORD)
            if (@jackTokenizer.keyWord == "DO")
              printKeyword()
              parseState = ST_DO_SUBROUTINECALL
            else
              return false
            end
          end
        elsif (parseState == ST_DO_SUBROUTINECALL)
          compileSubroutineCall()
          parseState = ST_DO_NEXT
        else
          if (@jackTokenizer.tokenType == TK_SYMBOL)
            if (@jackTokenizer.symbol == ";")
              return true
            end
          end
        end
      end
      @jackTokenizer.advance
    end
  end

  def compileReturn()
    parseState = ST_RETURN_KEYWORD
    while (@jackTokenizer.hasMoreTokens)
      if !(@jackTokenizer.inComment)

        if (parseState == ST_RETURN_KEYWORD)
          if (@jackTokenizer.tokenType == TK_KEYWORD)
            if (@jackTokenizer.keyWord == "RETURN")
              printKeyword()
              parseState = ST_RETURN_EXPRESSION
            else
              return false
            end
          end
        elsif (parseState == ST_RETURN_EXPRESSION)
          compileExpression()
          parseState = ST_RETURN_NEXT
        else
          if (@jackTokenizer.tokenType == TK_SYMBOL)
            if (@jackTokenizer.symbol == ";")
              return true
            end
          end
        end
      end
      @jackTokenizer.advance
    end

  end
  
  def compileExpression()
    parseState = ST_EX_TERM
    while (@jackTokenizer.hasMoreTokens)
      if !(@jackTokenizer.inComment)

        if (parseState == ST_EX_TERM)
          
          if compileTerm()
            parseState == ST_EX_OP
          else
            return 0
          end
        elsif (parseState == ST_EX_OP)
          if (@jackTokenizer.tokenType == TK_SYMBOL)
            if (@jackTokenizer.symbol == "+") || (@jackTokenizer.symbol == "-") || (@jackTokenizer.symbol == "*") || (@jackTokenizer.symbol == "/") || (@jackTokenizer.symbol == "&") || (@jackTokenizer.symbol == "|") || (@jackTokenizer.symbol == "<") || (@jackTokenizer.symbol == ">") || (@jackTokenizer.symbol == "=")
              parseState == ST_EX_TERM
            else
              return 0
            end
          end
        end
      end
      @jackTokenizer.advance      
    end
  
  end

  def compileTerm()
    while (@jackTokenizer.hasMoreTokens)
      if !(@jackTokenizer.inComment)

        if (@jackTokenizer.tokenType == TK_INT_CONST)

        elsif (@jackTokenizer.tokenType == TK_STRING_CONST)

        elsif (@jackTokenizer.tokenType == TK_KEYWORD)

          

      end
     @jackTokenizer.advance      
 
    end
    
  end

  def compileExpressionList()

  end

  def compileSubroutineCall()

  end
  
  def printKeyword()
    keyword = @jackTokenizer.keyWord
    @xmlFile.print "<keyword>" + keyword.downcase + "</keyword>\n"
  end

  def printSymbol()
    symbol = @jackTokenizer.symbol
    @xmlFile.print "<symbol>" + "\"" + symbol + "\"" + "</symbol>\n"
  end
  
  def printIdentifier()
    identifier = @jackTokenizer.identifier
    @xmlFile.print "<identifier>" + identifier + "</identifier>\n"
  end

  
end
