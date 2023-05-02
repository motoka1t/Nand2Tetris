#
class SymbolTable

  def initialize
    @symbolTable = Hash.new()
  end

  def addEntry(symbol, address)
    @symbolTable.store(symbol, address)
  end

  def contains(symbol)
    return @symbolTable.key?(symbol)
  end

  def getAddress(symbol)
    return @symbolTable[symbol]
  end
end
