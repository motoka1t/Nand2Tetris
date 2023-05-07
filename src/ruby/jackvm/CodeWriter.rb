require_relative "./Common.rb"

class CodeWriter
  Indent = "    "

  def initialize(filename)
    @asmFile = File.open(filename, "w+");
    @functionName = ""
  end

  def setFileName(filename)
    @currentFile = filename
    @cnt1 = 0 # for eq lt gt
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

  def writeLabel1(label1)
    @asmFile.print "("+ label1 + ")" + "\n"
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
      writeLabel( "FALSEEQ" + @cnt1.to_s)
      writeCommand("D=0")
      writeCommand("@" + @functionName + "$" + "ENDEQ" + @cnt1.to_s)
      writeCommand("0;JMP")
    when "gt"
      writeLabel("FALSEGT" + @cnt1.to_s)
      writeCommand("D=0")
      writeCommand("@" + @functionName + "$" + "ENDGT" + @cnt1.to_s)
      writeCommand("0;JMP")      
    when "lt"
      writeLabel("FALSELT" + @cnt1.to_s)
      writeCommand("D=0")
      writeCommand("@" + @functionName + "$" + "ENDLT" + @cnt1.to_s)      
      writeCommand("0;JMP")
    end
  end

  def trueBlock(command)
    case command
    when "eq"
      writeLabel("TRUEEQ" + @cnt1.to_s)
      writeCommand("D=-1")
      writeCommand("@" + @functionName + "$" + "ENDEQ" + @cnt1.to_s)
      writeCommand("0;JMP")
    when "gt"
      writeLabel("TRUEGT" + @cnt1.to_s)
      writeCommand("D=-1")
      writeCommand("@" + @functionName + "$" + "ENDGT" + @cnt1.to_s)
      writeCommand("0;JMP")      
    when "lt"
      writeLabel("TRUELT" + @cnt1.to_s)
      writeCommand("D=-1")
      writeCommand("@" + @functionName + "$" + "ENDLT" + @cnt1.to_s)      
      writeCommand("0;JMP")
    end
  end  

  def endBlock(command)
    case command
    when "eq"
      writeLabel("ENDEQ" + @cnt1.to_s)
      writeCommand("@SP")
      writeCommand("A=M")
      writeCommand("M=D")
    when "gt"
      writeLabel("ENDGT" + @cnt1.to_s)
      writeCommand("@SP")
      writeCommand("A=M")
      writeCommand("M=D")
    when "lt"
      writeLabel("ENDLT" + @cnt1.to_s)
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
        writeCommand("@TRUEEQ" + @cnt1.to_s)
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
        writeCommand("@TRUEGT" + @cnt1.to_s)
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
        writeCommand("@TRUELT" + @cnt1.to_s)
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
    @cnt1 = @cnt1 + 1
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
        pushStack
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
        writeCommand("@R15")
        writeCommand("M=D")
        popStack
        writeCommand("D=M")
        writeCommand("@R15")
        writeCommand("A=M")         
        writeCommand("M=D")
      when "argument"
        writeCommand("@"+index)
        writeCommand("D=A")
        writeCommand("@ARG")
        writeCommand("D=D+M")
        writeCommand("@R15")
        writeCommand("M=D")
        popStack
        writeCommand("D=M")        
        writeCommand("@R15")
        writeCommand("A=M")         
        writeCommand("M=D")
      when "this"
        writeCommand("@"+index)
        writeCommand("D=A")
        writeCommand("@THIS")
        writeCommand("D=D+M")
        writeCommand("@R15")
        writeCommand("M=D")
        popStack
        writeCommand("D=M")        
        writeCommand("@R15")
        writeCommand("A=M")         
        writeCommand("M=D")
      when "that"
        writeCommand("@"+index)
        writeCommand("D=A")
        writeCommand("@THAT")
        writeCommand("D=D+M")
        writeCommand("@R15")
        writeCommand("M=D")
        popStack
        writeCommand("D=M")        
        writeCommand("@R15")
        writeCommand("A=M")         
        writeCommand("M=D")
      when "pointer"
        writeCommand("@"+index)
        writeCommand("D=A")
        writeCommand("@3")
        writeCommand("D=D+A")
        writeCommand("@R15")
        writeCommand("M=D")
        popStack
        writeCommand("D=M")        
        writeCommand("@R15")
        writeCommand("A=M")         
        writeCommand("M=D")
      when "temp"
        writeCommand("@"+index)
        writeCommand("D=A")
        writeCommand("@5")
        writeCommand("D=D+A")
        writeCommand("@R15")
        writeCommand("M=D")
        popStack
        writeCommand("D=M")        
        writeCommand("@R15")
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

  def writeInit
    writeDebugComment1("Bootstrap code")
    # SP=256
    @functionName = ""
    @cnt2 = 0
    writeCommand("@256")
    writeCommand("D=A")
    writeCommand("@SP")
    writeCommand("M=D")
    # Call Sys.init
    writeCall("Sys.init", "0")
  end

  def writeEnd
#    writeLabel1("END")
#    writeCommand("@END")
#    writeCommand("0;JMP")
  end
  
  def writeLabel(label)
    label1 = @functionName + "$" + label
    @asmFile.print "("+ label1 + ")" + "\n"
  end
  
  def writeGoto(label)
    label1 = @functionName + "$" + label
    writeCommand("@" + label1)
    writeCommand("0;JMP")
  end

  def writeIf(label)
    label1 = @functionName + "$" + label    
    popStack
    writeCommand("D=M")
    writeCommand("@" + label1)
    writeCommand("D;JNE")
  end

  def writeCall(functionName, numArgs)
    writeDebugComment1("call " + functionName + " " + numArgs )
    @cnt2 = @cnt2 + 1
    # push return-address
    writeCommand("@return-address"+ "$" + functionName + @cnt2.to_s )
    writeCommand("D=A")
    pushStack
    # push LCL
    writeCommand("@LCL")
    writeCommand("D=M")
    pushStack
    # push ARG
    writeCommand("@ARG")
    writeCommand("D=M")
    pushStack
    # push THIS
    writeCommand("@THIS")
    writeCommand("D=M")
    pushStack
    # push THAT
    writeCommand("@THAT")
    writeCommand("D=M")
    pushStack
    #ARG=SP-n-5
    writeCommand("@SP")
    writeCommand("D=M")
    writeCommand("@"+numArgs)
    writeCommand("D=D-A")
    writeCommand("@5")
    writeCommand("D=D-A")
    writeCommand("@ARG")
    writeCommand("M=D")
    #LCL=SP
    writeCommand("@SP")
    writeCommand("D=M")
    writeCommand("@LCL")
    writeCommand("M=D")
    #goto f 
    writeCommand("@" + functionName)
    writeCommand("0;JMP")
    #(return-address)
    writeLabel1("return-address" + "$" + functionName + @cnt2.to_s)
  end

  def writeFunction(functionName, numLocals)
    writeLabel1(functionName)
    @functionName = functionName
    # repete k times
    i = 0
    k = numLocals.to_i
    while (i < k)
      # push 0
      writeCommand("@0")
      writeCommand("D=A")
      pushStack
      i = i + 1
    end
  end

  def writeReturn
    #FRAME:R13 RET:R14
    #FRAME=LCL
    writeCommand("@LCL")
    writeCommand("D=M")
    writeCommand("@R13")
    writeCommand("M=D")
    #RET=*(FRAME-5)
    writeCommand("@5")
    writeCommand("D=A")
    writeCommand("@R13")
    writeCommand("A=M-D")
    writeCommand("D=M")
    writeCommand("@R14")
    writeCommand("M=D")
    #*ARG=pop()
    popStack
    writeCommand("D=M")
    writeCommand("@ARG")
    writeCommand("A=M")
    writeCommand("M=D")
    #SP=ARG+1
    writeCommand("@ARG")
    writeCommand("D=M+1")
    writeCommand("@SP")
    writeCommand("M=D")
    #THAT=*(FRAME-1)
    writeCommand("@R13")
    writeCommand("AM=M-1")
    writeCommand("D=M")
    writeCommand("@THAT")
    writeCommand("M=D")
    #THIS=*(FRAME-2)
    writeCommand("@R13")
    writeCommand("AM=M-1")
    writeCommand("D=M")
    writeCommand("@THIS")
    writeCommand("M=D")
    #ARG=*(FRAME-3)
    writeCommand("@R13")
    writeCommand("AM=M-1")
    writeCommand("D=M")
    writeCommand("@ARG")
    writeCommand("M=D")
    #LCL=*(FRAME-4)
    writeCommand("@R13")
    writeCommand("AM=M-1")
    writeCommand("D=M")
    writeCommand("@LCL")
    writeCommand("M=D")
    #goto RET
    writeCommand("@R14")
    writeCommand("A=M")
    writeCommand("0;JMP")
  end
    
  def close
    @asmFile.close
  end

  def functionName
    return @functionName
  end

end
