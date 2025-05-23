# frozen_string_literal: true

require_relative "builder/version"

module Line
  module Message
    # The Builder module provides a Domain Specific Language (DSL) for constructing
    # and validating LINE messages. It offers a structured and intuitive way to
    # define various message types, such as text, flex messages, and quick replies,
    # ensuring they adhere to the LINE Messaging API specifications.
    #
    # This module simplifies the process of creating complex message structures
    # by providing a set of builder classes and helper methods.
    module Builder
      # Base error class for all errors raised by the Line::Message::Builder module.
      # This allows for rescuing any specific builder error or all builder errors.
      class Error < StandardError; end
      # Error raised when a required attribute or element is missing during message construction.
      # For example, if a text message is created without specifying the text content.
      class RequiredError < Error; end
      # Error raised when an attribute or element fails validation rules.
      # For example, if a URL provided for an action is invalid or if a text
      # message exceeds the maximum allowed length.
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

      # Entry point for building a message container.
      # This method initializes a new message {Container} and evaluates the
      # provided block within the context of that container.
      #
      # @param context [Object, nil] An optional context object that can be made
      #   available within the builder block. This can be useful for accessing
      #   helper methods or data within the block.
      # @yield [container] The block is yielded with the newly created {Container}
      #   instance, allowing you to define the message structure using the DSL.
      # @return [Container] The initialized message container with the defined structure.
      # @example
      #   message = Line::Message::Builder.with do |root|
      #     root.text "Hello, world!"
      #   end
      def with(context = nil, &)
        Container.new(context: context, &)
      end
    end
  end
end
