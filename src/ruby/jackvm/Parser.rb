#
require_relative "./Common.rb"

class Parser
  S_COMMAND = 0
  S_ARG1 = 1
  S_ARG2 = 2
  
  def initialize(filename)
    @vmFile = File.open(filename, "r")
  end
    
  def hasMoreCommands
    return !@vmFile.eof?
  end
    
  def advance  
    rl = @vmFile.readline
    rl.strip!
    @chars = rl.split(//)
    @parseState = S_COMMAND
    rl
  end
  
  def commandType
    if @parseState == S_COMMAND 
      field = ""
      while c = @chars.shift
        if c == " "
          break
        else
          field.concat c
        end
      end
      @command = field
      @parseState = S_ARG1
    end
    case @command
      when "push" 
        return C_PUSH
      when "pop"
        return C_POP
      when "label"
        return C_LABEL
      when "goto"
        return C_GOTO
      when "if-goto"
        return C_IF
      when "function"
        return C_FUNCTION
      when "call"
        return C_CALL
      when "return"
        return C_RETURN
      else
        return C_ARITHMETRIC
    end
  end

  def arg1
    if @parseState == S_ARG1
      if commandType == C_ARITHMETRIC
        @parseState = S_ARG2
        return @command
      else
        field = ""
        while c = @chars.shift
          if c == " "
            break
          else
            field.concat c
          end
        end
        @parseState = S_ARG2
        return field
      end
    end
  end

  def arg2
    if @parseState == S_ARG2
      field = ""
      while c = @chars.shift
        if c == " "
          break
        else
          field.concat c
        end
      end
      return field  
    end
  end

  def isEmpty
    return @chars.empty?
  end

  def isComment
    c = @chars.first(2)
    return c == ["/", "/"]
  end
    
end


  
