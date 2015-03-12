module TPPlus
  module Nodes
    class TimerNode
      attr_accessor :comment
      def initialize(id)
        @id = id
        @comment = ""
      end

      def address(context)
        "#{@id}"
      end

      def eval(context, options={})
        "TIMER[#{@id}]" # FANUC does not like timer comments
      end
    end
  end
end
