# frozen_string_literal: true
require 'babl/utils'
require 'babl/errors'

module Babl
    module Operators
        module Call
            module DSL
                # Interpret whatever is passed to this method as BABL template. It is idempotent.
                def call(arg = nil, &block)
                    if block
                        raise Errors::InvalidTemplate, 'call() expects no argument when a block is given' unless arg.nil?

                        # The 'block' is wrapped by #selfify such that there is no implicit closure referencing the current
                        # template. Ideally, once a template has been compiled, all intermediate template objects should be
                        # garbage collectable.
                        return with(unscoped, &Utils::Proc.selfify(block))
                    end

                    case arg
                    when Template then self.class.new(builder.wrap { |bound| arg.builder.bind(bound) })
                    when Utils::DslProxy then call(arg.itself)
                    when ::Proc then call(&arg)
                    when ::Hash then object(**arg)
                    when ::Array then array(*arg)
                    when ::String, ::Numeric, ::NilClass, ::TrueClass, ::FalseClass, ::Symbol then static(arg)
                    else raise Errors::InvalidTemplate, "call() received invalid argument: #{arg}"
                    end
                end
            end
        end
    end
end
