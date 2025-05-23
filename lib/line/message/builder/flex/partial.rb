# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The `HasPartial` module provides a mechanism to include reusable
        # partial layouts within Flex Message components (like {Box}, {Bubble}).
        #
        # To use it, include this module in your component class and then
        # define partial classes that inherit from {Partial}.
        #
        # Example:
        #   ```ruby
        #   class MyHeaderPartial < Line::Message::Builder::Flex::Partial
        #     def call
        #       # `self` here refers to the MyHeaderPartial instance
        #       # `context` (available via method_missing) refers to the component
        #       # instance where the partial is being included (e.g., a Box).
        #       context.text "Title: #{context.assigns[:title]}"
        #     end
        #   end
        #
        #   class MyComponent < Line::Message::Builder::Flex::Box
        #     include Line::Message::Builder::Flex::HasPartial
        #
        #     def initialize(**options, &block)
        #       super
        #       partial!(MyHeaderPartial, title: "My Dynamic Title") if options[:use_header]
        #       instance_eval(&block) if block
        #     end
        #   end
        #   ```
        module HasPartial
          # Renders a given partial class within the current component's context.
          # The methods defined in the partial's `call` method will be executed
          # as if they were called directly on the current component (e.g., a {Box} instance).
          #
          # Local variables can be passed to the partial via the `assigns` hash.
          # These will be accessible in the partial through `context.assigns[:variable_name]`.
          #
          # @param partial_class [Class<Partial>] The class of the partial to render.
          #   It must be a subclass of {Partial}.
          # @param assigns [Hash] A hash of local variables to make available within the partial.
          # @raise [ArgumentError] if the provided `partial_class` is not a subclass of {Partial}.
          # @return [void]
          def partial!(partial_class, **assigns)
            raise ArgumentError, "Not a partial, expected a class inheriting from Line::Message::Builder::Flex::Partial, got #{partial_class}" unless partial_class < Partial

            # Store original assigns from the component's context
            original_assigns = context.assigns
            # Set new assigns for the partial's execution
            context.assigns = assigns
            # Instantiate and call the partial. The partial's `initialize` receives
            # the component instance (`self`) as its `context`.
            # The `call` method of the partial is then executed.
            partial_class.new(context: self).call
            # Restore original assigns to the component's context
            context.assigns = original_assigns
          end
        end

        # Base class for creating reusable partials in Flex Messages.
        # Subclasses must implement the `#call` method, which defines the
        # components to be rendered by the partial.
        #
        # Within the `#call` method, methods of the including component (e.g., {Box#text}, {Box#button})
        # can be called as if they were local methods, thanks to `method_missing`
        # delegation to the `@context` object (which is the component instance).
        #
        # @example
        #   class UserProfilePartial < Line::Message::Builder::Flex::Partial
        #     def call
        #       context.box layout: :vertical do
        #         context.text "Name: #{context.assigns[:user].name}"
        #         context.text "Email: #{context.assigns[:user].email}"
        #       end
        #     end
        #   end
        class Partial
          # @!attribute [r] context
          #   @return [Line::Message::Builder::Base] The component instance (e.g., {Box}, {Bubble})
          #     within which this partial is being rendered.
          attr_reader :context

          # Initializes a new partial.
          #
          # @param context [Line::Message::Builder::Base] The component instance (e.g., a {Box} or {Bubble})
          #   that is including this partial. This context provides access to methods like `text`, `box`, etc.,
          #   and also to any `assigns` passed during the `partial!` call.
          def initialize(context:)
            @context = context
          end

          # This method must be implemented by subclasses to define the content of the partial.
          # Use methods from the `@context` (e.g., `context.text "Hello"`) to build components.
          #
          # @param args [Array] Any arguments that might be passed during the call (though typically not used).
          # @raise [NotImplementedError] if not implemented by a subclass.
          def call(*_args)
            raise NotImplementedError, "The #{self.class.name} class must implement the call method"
          end

          # @!visibility private
          # Checks if the partial's context can respond to a given method.
          def respond_to_missing?(method_name, include_private = false)
            @context.respond_to?(method_name, include_private) || super
          end

          # @!visibility private
          # Delegates missing method calls to the `@context` object.
          # This allows calling methods like `text`, `box`, etc., directly within the partial's `call` method,
          # and they will be executed on the component instance that includes the partial.
          def method_missing(method_name, ...)
            if @context.respond_to?(method_name)
              @context.public_send(method_name, ...)
            else
              super
            end
          end
        end
      end
    end
  end
end
