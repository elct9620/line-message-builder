# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The HasPartial module provides functionality for Flex Message components
        # (like Box, Bubble) to render reusable "partials". Partials are defined
        # by creating classes that inherit from Partial.
        #
        # Including this module into a component class gives it the +partial!+ method.
        #
        # == Example
        #
        #   # Define a reusable partial
        #   class MyButtonPartial < Line::Message::Builder::Flex::Partial
        #     def call
        #       # +button+ method is available from the context (e.g., a Box)
        #       button style: :primary do
        #         # +data+ and +label+ are available from <code>context.assigns</code>
        #         postback data, label: label
        #       end
        #     end
        #   end
        #
        #   # Use the partial within a Box component
        #   Line::Message::Builder.with do
        #     flex do
        #       bubble do
        #         body do
        #           partial! MyButtonPartial, label: "Action", data: "action=do_something"
        #         end
        #       end
        #     end
        #   end
        #
        # See also:
        # - Partial
        module HasPartial
          # Renders a given Partial class within the current component's context.
          #
          # This method temporarily makes the provided +assigns+ available to the
          # partial through the <code>context.assigns</code> mechanism. After the partial's
          # +call+ method completes, the original <code>context.assigns</code> are restored.
          #
          # [partial_class]
          #   The class of the partial to render. Must be a subclass of Partial.
          # [assigns]
          #   A hash of key-value pairs that will be made available as +assigns+
          #   within the partial's +call+ method.
          #
          # Raises ArgumentError if +partial_class+ is not a subclass of Partial.
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

        # The Partial class is an abstract base for creating reusable snippets
        # of Flex Message content. To define a partial, create a new class that
        # inherits from Partial and implements the +call+ instance method.
        #
        # Within the +call+ method, you can use the standard Flex Message builder
        # DSL methods (e.g., +text+, +box+, +button+) as if you were directly inside
        # the component where the partial is being rendered. This is possible because
        # the Partial instance delegates unknown method calls to the component
        # instance that is rendering it (passed as +context+ during initialization).
        #
        # Subclass and implement +call+ to create a concrete partial.
        #
        # See also:
        # - HasPartial for how to render partials
        class Partial
          # Initializes a new Partial instance.
          # This is typically called by the HasPartial#partial! method.
          #
          # [context]
          #   The component instance (e.g., Box, Bubble) within which this partial
          #   is being rendered. This context provides the DSL methods (like +text+,
          #   +box+) used in the partial's +call+ method.
          def initialize(context:)
            @context = context # The component (e.g., Box, Bubble) rendering this partial
          end

          # This method must be implemented by subclasses to define the content of
          # the partial. Inside this method, use the Flex Message builder DSL methods
          # (e.g., <code>text "Hello"</code>, <code>button { ... }</code>) which will be
          # delegated to the rendering context.
          #
          # Any arguments passed to +partial!+ as +assigns+ are available via
          # <code>context.assigns</code> or directly if the rendering context's +method_missing+
          # handles +assigns+ lookup (as Line::Message::Builder::Context does).
          #
          # Arguments passed from the +partial!+ call's +assigns+ can be explicitly defined
          # as parameters here, or accessed via <code>context.assigns</code>.
          #
          # Raises NotImplementedError if a subclass does not implement this method.
          def call(*)
            raise NotImplementedError,
                  "The #{self.class.name} class must implement the #call method to define its content."
          end

          def respond_to_missing?(method_name, include_private = false) # :nodoc:
            @context.respond_to?(method_name, include_private) || super
          end

          def method_missing(method_name, ...) # :nodoc:
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
