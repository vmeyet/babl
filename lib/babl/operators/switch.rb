require 'babl/nodes/switch'
require 'babl/nodes/internal_value'
require 'babl/nodes/terminal_value'

module Babl
    module Operators
        module Switch
            module DSL
                # Conditional switching between different templates
                def switch(conds = {})
                    construct_node(continue: nil) { |node, context|
                        nodes = conds.map { |cond, value|
                            cond_node = unscoped.call(cond).builder
                                .precompile(Nodes::InternalValue.instance, context.merge(continue: nil))

                            value_node = unscoped.call(value).builder
                                .precompile(Nodes::TerminalValue.instance, context.merge(continue: node))

                            [cond_node, value_node]
                        }.to_h

                        Nodes::Switch.new(nodes)
                    }
                end
            end
        end
    end
end
