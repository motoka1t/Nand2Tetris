#
require_relative "./Common.rb"

class Parser
  
  def initialize(filename)
    @asmFile = File.open(filename, "r")
  end
    
  def hasMoreCommands
    return !@asmFile.eof?
  end
    
  def advance  
    command = @asmFile.readline
    command.strip!
    @chars = command.split(//)
    command
  end

  def commandType
    c = @chars.first
    case c
    when "@" 
      return A_COMMAND
    when "("
      return L_COMMAND
    else
      return C_COMMAND
    end
  end

  def symbol
    field = ""
    while c = @chars.shift
      if c == "@"
        next
      elsif c == "("
        next
      elsif c == ")"
        return field
      else
        field.concat c
      end
    end
    return field
  end

  def dest
    field = ""
    while c = @chars.shift
      if c == "="
        return field
      elsif c == " "
        next
      elsif isComment
        #undo
        @chars = field.split(//)
        field = ""
        return field
      else
        field.concat c
      end
    end
    #undo
    @chars = field.split(//)
    field = ""
    return field
  end

  def comp
    field = ""
    while c = @chars.shift
      if c == ";"
        return field
      elsif isComment
        @chars = []
        return field
      elsif c == " "
        next
      else
        field.concat c
      end
    end
    return field
  end

  def jump
    field = ""
    while c = @chars.shift
      if c == " "
        next
      elsif isComment
        field.concat c
        return field
      else
        field.concat c
      end
    end
    return field
  end

  def isEmpty
    return @chars.empty?
  end

  def isComment
    c = @chars.first(2)
    return c == ["/", "/"]
  end
    
end


  
