require_relative "./Common.rb"

class CodeWriter
  Indent = "    "

  def initialize(filename)
    @asmFile = File.open(filename, "w+");
  end

  def setFileName(filename)
    @currentFile = filename
    @cnt = 0
  end

  def writeDebugComment1(command)
    @asmFile.print "//" + command + "\n"
  end

  def writeDebugComment2(command, segment, index)
    case command
    when C_PUSH
      @asmFile.print "//" + "push " + segment + " " + index.to_s + "\n"
    when C_POP
      @asmFile.print "//" + "pop " + segment + " " + index.to_s + "\n"
    end
  end
    
  def writeCommand(commands)
    @asmFile.print Indent + commands + "\n"
  end

  def writeLabel(labels)
    @asmFile.print "("+ labels + ")" + "\n"
  end
  
  def popStack
    writeCommand("@SP")
    writeCommand("AM=M-1")
  end

  def pushStack
    writeCommand("@SP")
    writeCommand("A=M")
    writeCommand("M=D")
    writeCommand("@SP")
    writeCommand("M=M+1")
  end

  def falseBlock(command)
    case command
    when "eq"
      writeLabel("FALSEEQ" + @cnt.to_s)
      writeCommand("D=0")
      writeCommand("@ENDEQ" + @cnt.to_s)
      writeCommand("0;JMP")
    when "gt"
      writeLabel("FALSEGT" + @cnt.to_s)
      writeCommand("D=0")
      writeCommand("@ENDGT" + @cnt.to_s)
      writeCommand("0;JMP")      
    when "lt"
      writeLabel("FALSELT" + @cnt.to_s)
      writeCommand("D=0")
      writeCommand("@ENDLT" + @cnt.to_s)      
      writeCommand("0;JMP")
    end
  end

  def trueBlock(command)
    case command
    when "eq"
      writeLabel("TRUEEQ" + @cnt.to_s)
      writeCommand("D=-1")
      writeCommand("@ENDEQ" + @cnt.to_s)
      writeCommand("0;JMP")
    when "gt"
      writeLabel("TRUEGT" + @cnt.to_s)
      writeCommand("D=-1")
      writeCommand("@ENDGT" + @cnt.to_s)
      writeCommand("0;JMP")      
    when "lt"
      writeLabel("TRUELT" + @cnt.to_s)
      writeCommand("D=-1")
      writeCommand("@ENDLT" + @cnt.to_s)      
      writeCommand("0;JMP")
    end
  end  

  def endBlock(command)
    case command
    when "eq"
      writeLabel("ENDEQ" + @cnt.to_s)
      writeCommand("@SP")
      writeCommand("A=M")
      writeCommand("M=D")
    when "gt"
      writeLabel("ENDGT" + @cnt.to_s)
      writeCommand("@SP")
      writeCommand("A=M")
      writeCommand("M=D")
    when "lt"
      writeLabel("ENDLT" + @cnt.to_s)
      writeCommand("@SP")
      writeCommand("A=M")
      writeCommand("M=D")
    end
  end  
  
  def writeArithmetric(command)
    writeDebugComment1(command)
    case command
    when "add"
        popStack
        writeCommand("D=M")
        popStack
        writeCommand("D=D+M")
        pushStack
    when "sub"
        popStack
        writeCommand("D=M")
        popStack
        writeCommand("D=M-D")
        pushStack
    when "neg"
        popStack
        writeCommand("D=-M")
        pushStack
    when "eq"
        popStack
        writeCommand("D=M")
        popStack
        writeCommand("D=M-D")
        writeCommand("@TRUEEQ" + @cnt.to_s)
        writeCommand("D;JEQ")
        falseBlock("eq")
        trueBlock("eq")
        endBlock("eq")
        pushStack
    when "gt"
        popStack
        writeCommand("D=M")
        popStack
        writeCommand("D=M-D")
        writeCommand("@TRUEGT" + @cnt.to_s)
        writeCommand("D;JGT")
        falseBlock("gt")
        trueBlock("gt")
        endBlock("gt")
        pushStack
    when "lt"
        popStack
        writeCommand("D=M")
        popStack
        writeCommand("D=M-D")
        writeCommand("@TRUELT" + @cnt.to_s)
        writeCommand("D;JLT")
        falseBlock("lt")
        trueBlock("lt")
        endBlock("lt")
        pushStack
    when "and"
        popStack
        writeCommand("D=M")
        popStack
        writeCommand("D=D&M")
        pushStack
    when "or"
        popStack
        writeCommand("D=M")
        popStack
        writeCommand("D=D|M")
        pushStack
    when "not"
        popStack
        writeCommand("D=!M")
        pushStack
    end
    @cnt = @cnt + 1
  end

  def writePushPop(command, segment, index)
    writeDebugComment2(command, segment, index)
    case command
    when C_PUSH
      case segment
      when "constant"
        writeCommand("@"+index)
        writeCommand("D=A")
        pushStack
      when "local"
        writeCommand("@"+index)
        writeCommand("D=A")
        writeCommand("@LCL")
        writeCommand("A=D+M")
        writeCommand("D=M")
        pushStack
      when "argument"
        writeCommand("@"+index)
        writeCommand("D=A")
        writeCommand("@ARG")
        writeCommand("A=D+M")
        writeCommand("D=M")
e        pushStack
      when "this"
        writeCommand("@"+index)
        writeCommand("D=A")
        writeCommand("@THIS")
        writeCommand("A=D+M")
        writeCommand("D=M")
        pushStack        
      when "that"
        writeCommand("@"+index)
        writeCommand("D=A")
        writeCommand("@THAT")
        writeCommand("A=D+M")
        writeCommand("D=M")
        pushStack
      when "pointer"
        writeCommand("@"+index)
        writeCommand("D=A")
        writeCommand("@3")
        writeCommand("A=D+A")
        writeCommand("D=M")
        pushStack
      when "temp"
        writeCommand("@"+index)
        writeCommand("D=A")
        writeCommand("@5")
        writeCommand("A=D+A")
        writeCommand("D=M")
        pushStack
      when "static"
        writeCommand("@" + @currentFile +"."+index)
        writeCommand("D=M")
        pushStack
      end

    when C_POP
      case segment
      when "constant"
        writeCommand("")
      when "local"
        writeCommand("@"+index)
        writeCommand("D=A")
        writeCommand("@LCL")
        writeCommand("D=D+M")
        writeCommand("@R13")
        writeCommand("M=D")
        popStack
        writeCommand("D=M")
        writeCommand("@R13")
        writeCommand("A=M")         
        writeCommand("M=D")
      when "argument"
        writeCommand("@"+index)
        writeCommand("D=A")
        writeCommand("@ARG")
        writeCommand("D=D+M")
        writeCommand("@R13")
        writeCommand("M=D")
        popStack
        writeCommand("D=M")        
        writeCommand("@R13")
        writeCommand("A=M")         
        writeCommand("M=D")
      when "this"
        writeCommand("@"+index)
        writeCommand("D=A")
        writeCommand("@THIS")
        writeCommand("D=D+M")
        writeCommand("@R13")
        writeCommand("M=D")
        popStack
        writeCommand("D=M")        
        writeCommand("@R13")
        writeCommand("A=M")         
        writeCommand("M=D")
      when "that"
        writeCommand("@"+index)
        writeCommand("D=A")
        writeCommand("@THAT")
        writeCommand("D=D+M")
        writeCommand("@R13")
        writeCommand("M=D")
        popStack
        writeCommand("D=M")        
        writeCommand("@R13")
        writeCommand("A=M")         
        writeCommand("M=D")
      when "pointer"
        writeCommand("@"+index)
        writeCommand("D=A")
        writeCommand("@3")
        writeCommand("D=D+A")
        writeCommand("@R13")
        writeCommand("M=D")
        popStack
        writeCommand("D=M")        
        writeCommand("@R13")
        writeCommand("A=M")         
        writeCommand("M=D")
      when "temp"
        writeCommand("@"+index)
        writeCommand("D=A")
        writeCommand("@5")
        writeCommand("D=D+A")
        writeCommand("@R13")
        writeCommand("M=D")
        popStack
        writeCommand("D=M")        
        writeCommand("@R13")
        writeCommand("A=M")         
        writeCommand("M=D")
      when "static"
        popStack
        writeCommand("D=M")
        writeCommand("@" + @currentFile +"."+index)
        writeCommand("M=D")
      end
    end
  end
  
  def close
    @asmFile.close
  end

end
