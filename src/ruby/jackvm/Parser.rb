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
    while !@vmFile.eof?
      line = @vmFile.readline
      line.strip!
      if line =~ /^\/\//
        next
      elsif line.empty?
        next
      else
        @chars = line.split(//)
        parseReadline(@chars)
        @parseState = S_COMMAND
        return line
      end
    end
  end

  def parseReadline(chars)
    @parseCommand = []
    delimiter = " "
    while c = chars.shift
      chars.unshift c
      @parseCommand.push parseCommand(chars, delimiter) 
    end
  end
  
  def parseCommand(chars, delimiter)
    field = ""
    while c = chars.shift
      if c == delimiter
        return field
      else
        field.concat c
      end
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
  
end


  
