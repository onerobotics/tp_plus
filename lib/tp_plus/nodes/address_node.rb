module TPPlus
  module Nodes
    class AddressNode
      attr_reader :id
      def initialize(id)
        @id = id
      end

      def requires_mixed_logic?(context)
        false
      end

      def node(context)
        context.get_var(@id)
      end

      def eval(context,options={})
        node(context).address(context)
      end
    end
  end
end
