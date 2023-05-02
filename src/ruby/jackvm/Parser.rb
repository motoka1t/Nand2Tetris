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
    chars = rl.split(//)
    @isEmpty = chars.empty?
    @isComment = checkComment(chars)
    parseCommand(chars)
    @parseState = S_COMMAND
    rl
  end

  def checkComment(chars)
    c = chars.first(2)
    return c == ["/", "/"]
  end

  
  def parseCommand(chars)
    @parseCommand = []
    delimiter = " "
    while c = chars.shift
      if not ( isEmpty || isComment)
        chars.unshift c
        @parseCommand.push parseReadline(chars, delimiter) 
      end
    end
  end
  
  def parseReadline(chars, delimiter)
    field = ""
    nextisEmpty = false
    nextisComment = false
    while c = chars.shift
      if nextisComment
        return field
      elsif c == delimiter
        return field
      else
        field.concat c
      end
      nextisComment = checkComment(chars)
    end
  return field
  end
  
  def commandType
    if @parseState == S_COMMAND 
      @parseState = S_ARG1
      @command = @parseCommand[0]
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
        @parseState = S_ARG2
        return @parseCommand[1]
      end
    end
  end

  def arg2
    if @parseState == S_ARG2
      return @parseCommand[2]  
    end
  end

  def isEmpty
    return @isEmpty
  end

  def isComment
    return @isComment
  end
  
end


  
