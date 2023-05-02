
  class Code
    def dest(mnemonic)
      field = ""
      case mnemonic
      when "M"
        field = "001"
      when "D"
        field = "010"
      when "MD"
        field = "011"
      when "A"
        field = "100"
      when "AM"
        field = "101"
      when "AD"
        field = "110"
      when "AMD"
        field = "111"
      else
        field = "000"
      end
      return field
    end

    def comp(mnemonic)
      field = ""
      case mnemonic
      when "0"
        field = "0101010"
      when "1"
        field = "0111111"
      when "-1"
        field = "0111010"
      when "D"
        field = "0001100"
      when "A"
        field = "0110000"
      when "M"
        field = "1110000"
      when "!D"
        field = "0001101"
      when "!A"
        field = "0110001"
      when "!M"
        field = "1110001"
      when "-D"
        field = "0001111"
      when "-A"
        field = "0110011"
      when "-M"
        field = "1110011"
      when "D+1"
        field = "0011111"
      when "A+1"
        field = "0110111"
      when "M+1"
        field = "1110111"
      when "D-1"
        field = "0001110"
      when 'A-1'
        field = "0110010"
      when "M-1"
        field = "1110010"
      when "D+A"
        field = "0000010"
      when "D+M"
        field = "1000010"
      when "D-A"
        field = "0010011"
      when "D-M"
        field = "1010011"
      when "A-D"
        field = "0000111"
      when "M-D"
        field = "1000111"
      when "D&A"
        field = "0000000"
      when "D&M"
        field = "1000000"
      when "D|A"
        field = "0010101"
      when "D|M"
        field = "1010101"
      else
        field = "0000000"
      end
      return field
    end

    def jump(mnemonic)
      field = ""
      case mnemonic
      when "JGT"
        field = "001"
      when "JEQ"
        field = "010"
      when "JGE"
        field = "011"
      when "JLT"
        field = "100"
      when "JNE"
        field = "101"
      when "JLE"
        field = "110"
      when "JMP"
        field = "111"
      else
        field = "000"
      end
      return field
    end
  end

