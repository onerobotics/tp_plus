module TPPlus
  module Nodes
    class TerminationNode
      def initialize(value)
        @value = value
      end

      def eval(context)
        if @value.is_a? DigitNode
          v = @value.eval(context)
          if v.is_a? Integer
            "CNT#{@value.eval(context)}"
          else
            "FINE"
          end
        else
          # for registers
          "CNT #{@value.eval(context)}"
        end
      end
    end
  end
end
