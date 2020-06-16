# frozen_string_literal: true
require 'babl/nodes'
require 'babl/utils'
require 'babl/errors'

module Babl
    module Operators
        module Object
            module DSL
                # Create a JSON object node with static structure
                def object(*args)
                    kwargs, args = args.partition { |el| el.is_a?(Hash) }
                    (args.map(&:to_sym) + kwargs.flat_map(&:keys).map(&:to_sym)).group_by(&:itself).each_value do |keys|
                        raise Errors::InvalidTemplate, "Duplicate key in object(): #{keys.first}" if keys.size > 1
                    end

                    kwargs << args.map { |name| [name.to_sym, unscoped.nav(name)] }.to_h

                    templates = kwargs.reduce(&:merge).map { |k, v| [k, unscoped.reset_continue.call(v)] }

                    construct_terminal { |ctx|
                        Nodes::Object.new(templates.map { |key, template|
                            [
                                key.to_sym,
                                template.builder.precompile(
                                    Nodes::TerminalValue.instance,
                                    ctx.merge(key: key)
                                )
                            ]
                        }.to_h)
                    }
                end
            end
        end
    end
end
