# frozen_string_literal: true

require_relative "builder/version"

module Line
  module Message
    # The Builder module provides a DSL for building LINE messages.
    class Builder
      class Error < StandardError; end

      require_relative "builder/base"
      require_relative "builder/actions"
      require_relative "builder/quick_reply"
      require_relative "builder/text"

      attr_reader :context

      def initialize(context = nil, &)
        @messages = []
        @context = context

        instance_eval(&) if ::Kernel.block_given?
      end

      def text(text, &)
        @messages << Text.new(text, context: context, &)
      end

      def build
        @messages.map(&:to_h)
      end

      def to_json(*args)
        build.to_json(*args)
      end

      def respond_to_missing?(method_name, include_private = false)
        context.respond_to?(method_name, include_private) || super
      end

      def method_missing(method_name, ...)
        if context.respond_to?(method_name)
          context.public_send(method_name, ...)
        else
          super
        end
      end
    end
  end
end
