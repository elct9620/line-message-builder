# frozen_string_literal: true

module Line
  module Message
    module Builder
      # The `Line::Message::Builder::Flex` module serves as the primary namespace
      # for all classes, modules, and components related to the construction of
      # LINE Flex Messages within the `line-message-builder` gem.
      #
      # Flex Messages are highly customizable messages that can display rich content
      # with various layouts, components, and interactive elements. This module
      # organizes the DSL for building these messages.
      #
      # This file (`lib/line/message/builder/flex.rb`) is responsible for loading
      # all necessary sub-components and builder logic for Flex Messages, such as:
      # - {Flex::Builder}: The main class used to construct a complete Flex Message object.
      # - Container components: {Flex::Bubble}, {Flex::Carousel}.
      # - Basic components: {Flex::Box}, {Flex::Text}, {Flex::Button}, {Flex::Image}.
      # - Mixin modules for shared functionality: {Flex::Actionable},
      #   modules within {Flex::Position} and {Flex::Size}.
      # - The partial system: {Flex::HasPartial} and {Flex::Partial}.
      #
      # While this module itself is a namespace, the actual process of building a
      # Flex Message typically starts within a {Line::Message::Builder::Container}
      # block, by calling the `flex` method on the container. This method then
      # instantiates and uses {Flex::Builder} to define the Flex Message structure.
      #
      # @example How a Flex Message is typically initiated (conceptual)
      #   Line::Message::Builder.with do
      #     # This `flex` call on root_container would utilize Flex::Builder
      #     flex alt_text: "My Flex Message"  do
      #       bubble do
      #         # ... define bubble content ...
      #       end
      #     end
      #   end
      #
      # @see Flex::Builder For the main Flex Message construction entry point.
      # @see Flex::Bubble
      # @see Flex::Carousel
      # @see Flex::Box
      # @see Flex::Text
      # @see Flex::Button
      # @see Flex::Image
      # @see https://developers.line.biz/en/docs/messaging-api/using-flex-messages/
      module Flex
        # Main builder for the entire Flex Message object
        require_relative "flex/builder"

        # Mixin modules for component capabilities
        require_relative "flex/actionable"
        require_relative "flex/position" # For positioning options (margin, padding, etc.)
        require_relative "flex/size"     # For sizing options (flex factor, specific sizes)

        # Partial system for reusable components
        require_relative "flex/partial"

        # Container-type components
        require_relative "flex/bubble"   # Individual message unit
        require_relative "flex/carousel" # Horizontally scrollable list of bubbles

        # Basic building-block components
        require_relative "flex/box"      # Layout container
        require_relative "flex/text"     # Text display
        require_relative "flex/button"   # Interactive button
        require_relative "flex/image"    # Image display
        require_relative "flex/separator" # Visual separator
        require_relative "flex/span" # Text span for styling parts of text
      end
    end
  end
end
