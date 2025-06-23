require_relative "./Common.rb"

class JackTokenizer  
  def initialize(filename)
    @jackFile = File.open(filename)
    @tokens = []
    @inComment = false
  end

  def hasMoreTokens
    return (!@jackFile.eof? or (@tokens.length > 0))
  end

  def advance
    while !@jackFile.eof?
      if @tokens.length == 0
        line = @jackFile.readline
        line = line.lstrip
        line = line.rstrip
        if (/^\/\// =~ line)
          next
        elsif (/^\/\*/ =~ line)
          if not (/\*\/$/ =~ line)
            @inComment = true
          end           
          next
        elsif @inComment
          if (/\*\/$/ =~ line)
            @inComment = false
          end     
          next
        elsif line.empty?
          next
        else
          @tokens = getTokens(chopComment(line))
          token = @tokens.shift
          parseToken(token)
          return token
        end
      else
        token = @tokens.shift
        parseToken(token)
        return token
      end
    end
  end

  def tokenType
    return @tokenType
  end

  def keyWord
    return @keyword
  end

  def symbol
     return @symbol
  end

  def identifier
    return @identifier
  end

  def intVal
    return @intval
  end

  def stringVal
    return @stringval
  end

  def chopComment(line)
    lines = line.split("//")
    l = lines[0]
    l = l.lstrip
    l = l.rstrip
    return l
  end

  def getTokens(line)
    field = ""
    tokens =[]
    chars = line.split(//)
    while (chars.length > 0)
      c = chars.shift
      if checkSymbol(c)     
        if (field.length > 0)
          tokens.push(field)
          field = ""
        end
        tokens.push(c)
      elsif c === " "
        if (field.length > 0)
          tokens.push(field)
          field = ""
        end
      else
        field = field.concat(c)  
      end  
    end
    return tokens
  end
 
  def parseToken(token)
    @tokenType = TK_UNKNOWN
    if checkKeyword(token)
      @tokenType = TK_KEYWORD
      @keyword = token.upcase
    elsif checkSymbol(token)
      @tokenType = TK_SYMBOL
      @symbol = token
    elsif checkIntegerConstant(token)
      @tokenType = TK_INT_CONST  
      @intval = token.to_i
    elsif checkConstant(token)
      @tokenType = TK_STRING_CONST
      @stringval = token
    elsif checkIdentifier(token)
      @tokenType = TK_IDENTIFIER
      @identifier = token
    end
  end

  def checkKeyword(token)
    keywords = ["class", "constructor", "function", "method", "field", "static", 
                "var", "int", "char", "boolean", "void", "true", "false", "null",
              "this", "let", "do", "if", "else", "while", "return"]
    for keyword in keywords
      if (token == keyword)
        return true
      end
    end
    return false
  end

  def checkSymbol(token)
    symbols = ["{", "}", "(", ")", "[", "]", ".", ",", ";", "+", "-", "*", "/",
               "&", "|", "<", ">", "=", "~"]
    for symbol in symbols
      if (token == symbol)
        return true
      end
    end
    return false
  end
    
  def checkIntegerConstant(token)
    if token =~ /^\d+$/
      return true
    end
    return false
  end

  def checkConstant(token)
    if token =~ /^\"\w+\"$/
      return true
    end
    return false
  end
  
  def checkIdentifier(token)
    if (token =~ /^[A-Za-z_]/) and (token =~ /\w+$/)
      return true
    end
    return false
  end
  
end
