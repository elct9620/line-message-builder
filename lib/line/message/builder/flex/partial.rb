# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The `HasPartial` module provides functionality for Flex Message components
        # (like {Box}, {Bubble}) to render reusable "partials". Partials are defined
        # by creating classes that inherit from {Partial}.
        #
        # Including this module into a component class gives it the {#partial!} method.
        #
        # @example Defining and using a partial
        #   # Define a reusable partial
        #   class MyButtonPartial < Line::Message::Builder::Flex::Partial
        #     def call(label:, data:)
        #       # `button` method is available from the context (e.g., a Box)
        #       button style: :primary do |btn|
        #         btn.postback data, label: label
        #       end
        #     end
        #   end
        #
        #   # Use the partial within a Box component
        #   a_box_component.instance_eval do
        #     # ... other box content ...
        #     partial! MyButtonPartial, label: "Action", data: "action=do_something"
        #     # ... other box content ...
        #   end
        #
        # @see Partial
        module HasPartial
          # Renders a given {Partial} class within the current component's context.
          #
          # This method temporarily makes the provided `assigns` available to the
          # partial through the `context.assigns` mechanism. After the partial's
          # `call` method completes, the original `context.assigns` are restored.
          #
          # @param partial_class [Class] The class of the partial to render. Must be a
          #   subclass of {Partial}.
          # @param assigns [Hash] A hash of key-value pairs that will be made
          #   available as `assigns` within the partial's `call` method.
          # @return [void]
          # @raise [ArgumentError] if `partial_class` is not a subclass of {Partial}.
          def partial!(partial_class, **assigns)
            unless partial_class < Partial
              raise ArgumentError,
                    "Argument must be a Line::Message::Builder::Flex::Partial class"
            end

            original_assigns = context.assigns
            context.assigns = assigns
            # `self` here is the component instance (e.g., Box, Bubble) that includes HasPartial.
            # This component instance becomes the `@context` for the Partial instance.
            partial_class.new(context: self).call
            context.assigns = original_assigns
          end
        end

        # The `Partial` class is an abstract base for creating reusable snippets
        # of Flex Message content. To define a partial, create a new class that
        # inherits from `Partial` and implements the {#call} instance method.
        #
        # Within the `call` method, you can use the standard Flex Message builder
        # DSL methods (e.g., `text`, `box`, `button`) as if you were directly inside
        # the component where the partial is being rendered. This is possible because
        # the `Partial` instance delegates unknown method calls to the component
        # instance that is rendering it (passed as `context` during initialization).
        #
        # @abstract Subclass and implement {#call} to create a concrete partial.
        # @see HasPartial For how to render partials.
        class Partial
          # Initializes a new Partial instance.
          # This is typically called by the {HasPartial#partial!} method.
          #
          # @param context [Object] The component instance (e.g., {Box}, {Bubble})
          #   within which this partial is being rendered. This context provides
          #   the DSL methods (like `text`, `box`) used in the partial's `call` method.
          def initialize(context:)
            @context = context # The component (e.g., Box, Bubble) rendering this partial
          end

          # This method must be implemented by subclasses to define the content of
          # the partial. Inside this method, use the Flex Message builder DSL methods
          # (e.g., `text "Hello"`, `button { ... }`) which will be delegated to the
          # rendering context.
          #
          # Any arguments passed to `partial!` as `assigns` are available via
          # `context.assigns` or directly if the rendering context's `method_missing`
          # handles `assigns` lookup (as {Line::Message::Builder::Context} does).
          #
          # @param ... [Object] Arguments passed from the `partial!` call's `assigns`
          #   can be explicitly defined as parameters here, or accessed via `context.assigns`.
          # @raise [NotImplementedError] if a subclass does not implement this method.
          def call(*)
            raise NotImplementedError,
                  "The #{self.class.name} class must implement the #call method to define its content."
          end

          # @!visibility private
          # Part of Ruby's dynamic method dispatch. It's overridden here to declare
          # that instances of `Partial` can respond to methods to which the
          # wrapped `@context` object responds.
          def respond_to_missing?(method_name, include_private = false)
            @context.respond_to?(method_name, include_private) || super
          end

          # @!visibility private
          # Handles calls to methods not explicitly defined on the `Partial` class
          # by delegating them to the wrapped `@context` object (the rendering component).
          # This allows the `call` method of a partial to use DSL methods like `text`,
          # `box`, `button`, etc., as if they were defined directly in the partial.
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
