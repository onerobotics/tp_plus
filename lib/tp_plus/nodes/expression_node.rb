module TPPlus
  module Nodes
    class ExpressionNode
      attr_reader :left_op, :op, :right_op
      def initialize(left_op, op_string, right_op)
        @left_op  = left_op
        @op       = OperatorNode.new(op_string)
        @right_op = right_op
      end

      def grouped?
        return false if @right_op.nil? # this is for NOT (!) operator

        @left_op.is_a?(ParenExpressionNode) || @right_op.is_a?(ParenExpressionNode)
      end

      def requires_mixed_logic?(context)
        contains_expression? ||
          grouped? ||
          [@op, @left_op, @right_op].map { |op|
            next if op.nil?
            op.requires_mixed_logic?(context)
          }.any?
      end

      def contains_expression?
        [@left_op, @right_op].map {|op| op.is_a? ExpressionNode }.any?
      end

      def boolean_result?
        case @op.string
        when "&&","||","!","==","<>",">",">=","<","<="
          true
        else
          false
        end
      end

      def with_parens(string, context, options={})
        return string unless options[:force_parens] || options[:as_condition] && requires_mixed_logic?(context)

        "(#{string})"
      end

      def string_val(context, options={})
        if @op.bang?
          # this is for skip conditions, which do not
          # support mixed logic
          if options[:disable_mixed_logic]
            "#{@left_op.eval(context)}=OFF"
          else
            "#{@op.eval(context,options)}#{@left_op.eval(context)}"
          end
        else
          if @op.boolean? && options[:opposite]
<<<<<<< HEAD
	          o = { opposite: true }
=======
	    o = { opposite: true }
>>>>>>> onerobotics/master
            "#{@left_op.eval(context,o)}#{@op.eval(context,options)}#{@right_op.eval(context,o)}"
          else
            if options[:opposite] && options[:type] == "if" && @right_op.kind_of?(ExpressionNode)
              o = { opposite: true, type: "if"}
            else
              o = {}
            end
            "#{@left_op.eval(context)}#{@op.eval(context,options)}#{@right_op.eval(context,o)}"
          end
        end
      end

      def eval(context,options={})
        options[:force_parens] = true if grouped?

        with_parens(string_val(context, options), context, options)
      end
    end
  end
end
