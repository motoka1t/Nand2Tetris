SymbolTableClass = Struct.new(:name, :type, :kind, :index, keyword_init: true) 

class SymbolTable
  def initialize()
    @classTable = []
    @methodTable = []
  end

  def startSubroutine()
    @methodTable = []
  end

  def list()
    return @classTable
  end

  def define(name1, type1, kind1)
    index1 = varCount(kind1)
    item = SymbolTableClass.new(name:name1, type:type1, kind:kind1, index:index1)
    if (kind1 === "STATIC") or (kind1 === "FIELD")
      @classTable.push(item)
    else
      @methodTable.push(item)
    end
  end

  def varCount(kind)
    count = 0
    for item in @classTable
      if (kind === item.kind)
        count = count + 1
      end
    end
    for item in @methodTable
      if (kind === item.kind)
        count = count + 1
      end
    end
    return count
  end

  def kindOf(name)
    result = "NONE"
    for item in @classTable
      if (name === item.name)
        result = item.kind
      end
    end
    for item in @methodTable
      if (name === item.name)
        result = item.kind
      end
    end    
    return result
  end

  def typeOf(name)
    result = ""
    for item in @classTable
      if (name === item.name)
        result = item.type
      end
    end
    for item in @methodTable
      if (name === item.name)
        result = item.type
      end
    end   
    return result
  end

  def indexOf(name)
    result = 0
    for item in @classTable
      if (name === item.name)
        result = item.index
      end
    end
    for item in @methodTable
      if (name === item.name)
        result = item.index
      end
    end
    return result
  end
end
