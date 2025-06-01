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
    while !@asmFile.eof? 
      line = @asmFile.readline
      line.strip!
      if line =~ /^\/\//
        next
      elsif line.empty?
        next
      else
        command = line.split('//')
        @command = command[0]
        @command.strip!
        @chars = @command.split(//)
        return @command
      end
    end
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
      else
        field.concat c
      end
    end
  end

  def comp
    # field = ""
    # while c = @chars.shift
    #   if c == ";"
    #     return field
    #   elsif c == " "
    #     next
    #   else
    #     field.concat c
    #   end
    # end
    # return field
  end

  def jump
    # field = ""
    # while c = @chars.shift
    #   if c == " "
    #     next
    #   else
    #     field.concat c
    #   end
    # end
    # return field
  end    
end


  
