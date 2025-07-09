require_relative "./Common.rb"

class VMWriter

  def initialize(vmFilename)
    @vmFile = File.open(vmFilename, "w+")
  end

  def writePush(segment, index)
    @vmFile.print "    "
    @vmFile.print "push" 
    @vmFile.print " "
    @vmFile.print segment.downcase
    @vmFile.print " "
    @vmFile.print index
    @vmFile.print "\n"
  end

  def writePop(segment, index)
    @vmFile.print "    "
    @vmFile.print "pop" 
    @vmFile.print " "
    @vmFile.print segment.downcase 
    @vmFile.print " " 
    @vmFile.print index
    @vmFile.print "\n"
  end
  
  def writeArithmetic(command)
    @vmFile.print "    "
    @vmFile.print command.downcase
    @vmFile.print "\n" 
  end

  def writeLabel(label)
    @vmFile.print "label" 
    @vmFile.print " " 
    @vmFile.print label
    @vmFile.print "\n"
  end

  def writeGoTo(label)
    @vmFile.print "    "
    @vmFile.print "goto"
    @vmFile.print " " 
    @vmFile.print label
    @vmFile.print "\n"
  end  

  def writeIf(label)
    @vmFile.print "    "
    @vmFile.print "if-goto"
    @vmFile.print " " 
    @vmFile.print label
    @vmFile.print "\n"
  end  

  def writeCall(name, nArgs)
    @vmFile.print "    "
    @vmFile.print "call" 
    @vmFile.print " "
    @vmFile.print name
    @vmFile.print " "
    @vmFile.print nArgs
    @vmFile.print "\n"
  end  

  def writeFunction(name, nLocals)
    @vmFile.print "function"
    @vmFile.print " " 
    @vmFile.print name
    @vmFile.print " "
    @vmFile.print nLocals
    @vmFile.print "\n"
  end    

  def writeReturn()
    @vmFile.print "    "
    @vmFile.print "return"
    @vmFile.print "\n"
  end 
  
  def close()
    @vmFile.close()
  end

end
