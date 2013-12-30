#--
# DO NOT MODIFY!!!!
# This file is automatically generated by rex 1.0.5
# from lexical definition file "generators/scanner.rex".
#++

require 'racc/parser'
class TPPlus::Scanner < Racc::Parser
  require 'strscan'

  class ScanError < StandardError ; end

  attr_reader   :lineno
  attr_reader   :filename
  attr_accessor :state

  def scan_setup(str)
    @ss = StringScanner.new(str)
    @lineno =  1
    @state  = nil
  end

  def action
    yield
  end

  def scan_str(str)
    scan_setup(str)
    do_parse
  end
  alias :scan :scan_str

  def load_file( filename )
    @filename = filename
    open(filename, "r") do |f|
      scan_setup(f.read)
    end
  end

  def scan_file( filename )
    load_file(filename)
    do_parse
  end


  def next_token
    return if @ss.eos?

    # skips empty actions
    until token = _next_token or @ss.eos?; end
    token
  end

  def _next_token
    text = @ss.peek(1)
    @lineno  +=  1  if text == "\n"
    token = case @state
    when nil
      case
      when (text = @ss.scan(/BLANK/i))
        ;

      when (text = @ss.scan(/\#.*(?=\n?$)/i))
         action { [:COMMENT, text] }

      when (text = @ss.scan(/true|false/i))
         action { [:TRUE_FALSE, text] }

      when (text = @ss.scan(/R(?=\[)/i))
         action { [:NUMREG, text] }

      when (text = @ss.scan(/P(?=\[)/i))
         action { [:POSITION, text] }

      when (text = @ss.scan(/PR(?=\[)/i))
         action { [:POSREG, text] }

      when (text = @ss.scan(/VR(?=\[)/i))
         action { [:VREG, text] }

      when (text = @ss.scan(/SR(?=\[)/i))
         action { [:SREG, text] }

      when (text = @ss.scan(/F|DO|RO|UO|SO(?=\[)/i))
         action { [:OUTPUT, text] }

      when (text = @ss.scan(/DI|RI|UI|SI(?=\[)/i))
         action { [:INPUT, text] }

      when (text = @ss.scan(/\=\=/i))
         action { [:EEQUAL, text] }

      when (text = @ss.scan(/\=/i))
         action { [:EQUAL, text] }

      when (text = @ss.scan(/\:\=/i))
         action { [:ASSIGN, text] }

      when (text = @ss.scan(/\<\>|\!\=/i))
         action { [:NOTEQUAL, text] }

      when (text = @ss.scan(/\>\=/i))
         action { [:GTE, text] }

      when (text = @ss.scan(/\<\=/i))
         action { [:LTE, text] }

      when (text = @ss.scan(/\</i))
         action { [:LT, text] }

      when (text = @ss.scan(/\>/i))
         action { [:GT, text] }

      when (text = @ss.scan(/\+/i))
         action { [:PLUS, text] }

      when (text = @ss.scan(/\-/i))
         action { [:MINUS, text] }

      when (text = @ss.scan(/\*/i))
         action { [:STAR, text] }

      when (text = @ss.scan(/\//i))
         action { [:SLASH, text] }

      when (text = @ss.scan(/DIV/i))
         action { [:DIV, text] }

      when (text = @ss.scan(/&&/i))
         action { [:AND, text] }

      when (text = @ss.scan(/\|\|/i))
         action { [:OR, text] }

      when (text = @ss.scan(/\%/i))
         action { [:MOD, text] }

      when (text = @ss.scan(/\@/i))
         action { [:AT_SYM, text] }

      when (text = @ss.scan(/at/i))
         action { [:AT, text] }

      when (text = @ss.scan(/jump_to/i))
         action { [:JUMP, text] }

      when (text = @ss.scan(/linear_move|joint_move|circular_move/i))
         action { [:MOVE, text] }

      when (text = @ss.scan(/term/i))
         action { [:TERM, text] }

      when (text = @ss.scan(/turn_on|turn_off|toggle/i))
         action { [:IO_METHOD, text] }

      when (text = @ss.scan(/to/i))
         action { [:TO, text] }

      when (text = @ss.scan(/\n+/i))
         action { [:NEWLINE, text] }

      when (text = @ss.scan(/;/i))
         action { [:SEMICOLON, text] }

      when (text = @ss.scan(/\d+\.\d+|\.\d+/i))
         action { [:REAL, text.to_f] }

      when (text = @ss.scan(/\./i))
         action { [:DOT, text] }

      when (text = @ss.scan(/\d+/i))
         action { [:DIGIT, text.to_i] }

      when (text = @ss.scan(/\s+/i))
        ;

      when (text = @ss.scan(/[\w\!\?_]+/i))
         action { [:WORD, text] }

      when (text = @ss.scan(/./i))
         action { [text, text] }

      
      else
        text = @ss.string[@ss.pos .. -1]
        raise  ScanError, "can not match: '" + text + "'"
      end  # if

    else
      raise  ScanError, "undefined state: '" + state.to_s + "'"
    end  # case state
    token
  end  # def _next_token

end # class

if __FILE__ == $0
  exit  if ARGV.size != 1
  filename = ARGV.shift
  rex = TPPlus::Scanner.new
  begin
    rex.load_file  filename
    while  token = rex.next_token
      p token
    end
  rescue
    $stderr.printf  "%s:%d:%s\n", rex.filename, rex.lineno, $!.message
  end
end
