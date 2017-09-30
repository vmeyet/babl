# frozen_string_literal: true
require 'babl/errors'
require 'babl/utils'

module Babl
    module Nodes
        class Parent < Utils::Value.new(:node)
            PARENT_MARKER = Utils::Ref.new

            class Verifier < Utils::Value.new(:node)
                def dependencies
                    deps = node.dependencies
                    raise Errors::InvalidTemplate, 'Out of context parent dependency' if deps.key? PARENT_MARKER
                    deps
                end

                def schema
                    node.schema
                end

                def pinned_dependencies
                    node.pinned_dependencies
                end

                def render(ctx)
                    node.render(ctx)
                end

                def optimize
                    Verifier.new(node.optimize)
                end
            end

            def schema
                node.schema
            end

            def pinned_dependencies
                node.pinned_dependencies
            end

            def dependencies
                { PARENT_MARKER => node.dependencies }
            end

            def render(ctx)
                node.render(ctx.move_backward)
            end

            def optimize
                optimized = node.optimize
                Constant === optimized ? optimized : Parent.new(optimized)
            end
        end
    end
end
