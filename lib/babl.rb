# frozen_string_literal: true
require 'babl/railtie' if defined?(Rails)
require 'babl/template'
require 'babl/version'
require 'babl/rendering'
require 'babl/operators'

module Babl
    class Config
        attr_accessor :search_path, :preloader, :pretty, :cache_templates

        def initialize
            @search_path = nil
            @preloader = Babl::Rendering::NoopPreloader
            @pretty = true
            @cache_templates = false
        end
    end

    class << self
        def compile(template: Babl::Template.new, &source)
            if config.search_path
                ctx = Babl::Operators::Partial::AbsoluteLookupContext.new(config.search_path)
                template = template.with_lookup_context(ctx)
            end

            template.source(&source).compile(
                pretty: config.pretty,
                preloader: config.preloader
            )
        end

        def configure
            yield(config)
        end

        def config
            @config ||= Config.new
        end
    end
end
