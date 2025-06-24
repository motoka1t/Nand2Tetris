#!/usr/bin/ruby
require_relative "./Common.rb"
require_relative "./JACKTokenizer.rb"
require_relative "./CompilationEngine.rb"

def tokenize(jackTokenizer) 
  tokens = []
  while jackTokenizer.hasMoreTokens
    token = jackTokenizer.advance
    tokenType = jackTokenizer.tokenType
    print tokenType
    print " "
    print token
    print "\n"
    if tokenType == TK_KEYWORD
      keyWord = jackTokenizer.keyWord
      tk = TokenClass.new(token, tokenType, keyWord, "", "", 0, "")
      tokens.push(tk)
    elsif tokenType == TK_SYMBOL
      symbol = jackTokenizer.symbol
      tk = TokenClass.new(token, tokenType, "", symbol, "", 0, "")
      tokens.push(tk)
    elsif tokenType == TK_IDENTIFIER
      identifier = jackTokenizer.identifier
      tk = TokenClass.new(token, tokenType, "", "", identifier, 0, "")
      tokens.push(tk)
    elsif tokenType == TK_INT_CONST
      intVal = jackTokenizer.intVal
      tk = TokenClass.new(token, tokenType, "", "", "", intVal, "")
      tokens.push(tk)    
    elsif tokenType == TK_STRING_CONST
      stringVal = jackTokenizer.stringVal
      tk = TokenClass.new(token, tokenType, "", "", "", 0, stringVal)
      tokens.push(tk)   
    end
  end
  return tokens
end
classLists = ["Square", "SquareGame", "String", "Array"]
jackFile = ARGV.shift
if File.directory?(jackFile)
  Dir.chdir(jackFile)
  jackFiles = Dir.glob("*.jack")
  for jackFilename in jackFiles
    xmlFilename = jackFilename.gsub(/jack/, "xml")
    jackTokenizer = JackTokenizer.new(jackFilename)
    tokens = tokenize(jackTokenizer)
    compilationEngine = CompilationEngine.new(tokens, xmlFilename, classLists)   
  end
else
  jackFilename = jackFile
  xmlFilename = jackFilename.gsub(/jack/, "xml")
  jackTokenizer = JackTokenizer.new(jackFilename)
  tokens = tokenize(jackTokenizer)
  compilationEngine = CompilationEngine.new(tokens, xmlFilename, classLists)
end
