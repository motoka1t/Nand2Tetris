#!/usr/bin/ruby
require_relative "./Common.rb"
require_relative "./Parser.rb"
require_relative "./Code.rb"
require_relative "./SymbolTable.rb"

def initSymbolTable(asmSymbolTable)
  # defined symbol
  asmSymbolTable.addEntry("SP", 0)
  asmSymbolTable.addEntry("LCL", 1)
  asmSymbolTable.addEntry("ARG", 2)
  asmSymbolTable.addEntry("THIS", 3)
  asmSymbolTable.addEntry("THAT", 4)
  for i in [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    asmSymbolTable.addEntry("R"+i.to_s, i)
  end
  asmSymbolTable.addEntry("SCREEN", 16384)
  asmSymbolTable.addEntry("KBD", 24576)
end

def firstPass(filename, asmSymbolTable)
  asmParse = Parser.new(filename)

  n = 0
  while asmParse.hasMoreCommands
    command = asmParse.advance
    if asmParse.commandType == L_COMMAND
      symbol = asmParse.symbol
      asmSymbolTable.addEntry(symbol, n) 
    else
      n = n + 1
    end
  end
end

def secondPass(filename, asmSymbolTable)
  asmParse = Parser.new(filename)
  asmCode = Code.new()
  # output to hack file
  hackOut = File.open(filename.gsub(/asm/, "hack"), "w+")
  n = 16
  while asmParse.hasMoreCommands
    command = asmParse.advance
    if asmParse.commandType == A_COMMAND
      symbol = asmParse.symbol
      if symbol =~ /[a-zA-Z]/
        if asmSymbolTable.contains(symbol)
          symbol = asmSymbolTable.getAddress(symbol)
        else
          asmSymbolTable.addEntry(symbol, n)
          symbol = n
          n = n + 1
        end
      end
      field = '0' + format("%015b\n", symbol.to_i)
      hackOut.print field
    elsif asmParse.commandType == C_COMMAND
      dest = asmParse.dest
      comp = asmParse.comp
      jump = asmParse.jump
      field = "111" + asmCode.comp(comp) + asmCode.dest(dest) + asmCode.jump(jump) + "\n"
      hackOut.print field
    end
  end
end

# Main
filename = ARGV.first

asmSymbolTable = SymbolTable.new()
initSymbolTable(asmSymbolTable)
firstPass(filename, asmSymbolTable)
secondPass(filename, asmSymbolTable)

# End
