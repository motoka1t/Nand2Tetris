#!/usr/bin/ruby
require_relative "./Common.rb"
require_relative "./Parser.rb"
require_relative "./CodeWriter.rb"

def translate(asmCodeWriter, vmParser, vmFilename)
  asmCodeWriter.setFileName(vmFilename)
  while vmParser.hasMoreCommands
    vmParser.advance
    if vmParser.isEmpty
      next
    elsif vmParser.isComment
      next
    else
      if vmParser.commandType == C_ARITHMETRIC
        command = vmParser.arg1
        asmCodeWriter.writeArithmetric(command)
      elsif vmParser.commandType == C_PUSH
        segment = vmParser.arg1
        index = vmParser.arg2
        asmCodeWriter.writePushPop(C_PUSH, segment, index)
      elsif vmParser.commandType == C_POP
        segment = vmParser.arg1
        index = vmParser.arg2
        asmCodeWriter.writePushPop(C_POP, segment, index)
      end
    end
  end
end

vmFile = ARGV.shift

if File.directory?(vmFile)
  Dir.chdir(vmFile)
  vmFiles = Dir.glob("*.vm")
  asmFilename = File.basename(vmFile) + ".asm"
  asmCodeWriter = CodeWriter.new(asmFilename)
  for vmFilename in vmFiles
    print "Parser\n"
    vmParser = Parser.new(vmFilename)
    print "Translate\n"
    translate(asmCodeWriter, vmParser, vmFilename)
  end
else
  vmFilename = vmFile
  asmFileName = vmFilename.gsub(/vm/, "asm")
  asmCodeWriter = CodeWriter.new(asmFilename)
  vmParser = Parser.new(vmFilename)
  translate(asmCodeWriter, vmParser, vmFilename)
end
