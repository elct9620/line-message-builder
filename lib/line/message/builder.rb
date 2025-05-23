# frozen_string_literal: true

require_relative "builder/version"

module Line
  module Message
    # The Builder module provides a DSL for building LINE messages.
    # It allows for a more Ruby-like way to construct message objects.
    module Builder
      # Base error class for the Builder module.
      class Error < StandardError; end
      # Error raised when a required attribute is missing.
      class RequiredError < Error; end
      # Error raised when an attribute fails validation.
      class ValidationError < Error; end

      require_relative "builder/context"
      require_relative "builder/base"
      require_relative "builder/validators"
      require_relative "builder/actions"
      require_relative "builder/quick_reply"
      require_relative "builder/container"
      require_relative "builder/text"
      require_relative "builder/flex"

      module_function

      # Creates a new message container.
      #
      # @param context [Object] The context to use for the message.
      # @param &block [Proc] A block to be executed in the context of the new container.
      # @return [Container] The new message container.
      def with(context = nil, &)
        Container.new(context: context, &)
      end
    end
  end
end
