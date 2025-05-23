# frozen_string_literal: true

module Line
  module Message
    module Builder
      # The `Flex` module serves as the main namespace for all components
      # and builders related to LINE Flex Messages. It provides a structured
      # way to create rich, dynamic message layouts.
      #
      # Flex Messages are composed of containers (like {Bubble} and {Carousel})
      # which in turn hold various components ({Box}, {Text}, {Image}, {Button}, etc.).
      # These components can be arranged and styled with a high degree of flexibility.
      #
      # The primary entry point for creating a Flex Message is usually through
      # {Flex::Builder}.
      #
      # @see https://developers.line.biz/en/docs/messaging-api/using-flex-messages/
      # @see Flex::Builder
      # @see Flex::Bubble
      # @see Flex::Carousel
      # @see Flex::Box
      # @see Flex::Text
      # @see Flex::Image
      # @see Flex::Button
      module Flex
        # Core builder for Flex Messages
        require_relative "flex/builder"

        # Modules providing DSL extensions
        require_relative "flex/actionable"
        require_relative "flex/position" # For positioning options (align, margin, padding, etc.)
        require_relative "flex/size"     # For sizing options (flex factor, component-specific sizes)

        # Partial rendering system
        require_relative "flex/partial"  # For defining and using reusable partial layouts

        # Main container types for Flex Messages
        require_relative "flex/bubble"   # Single message unit
        require_relative "flex/carousel" # Horizontally scrollable list of bubbles

        # Basic building block components
        require_relative "flex/box"      # Layout container for other components
        require_relative "flex/text"     # For displaying text
        require_relative "flex/button"   # For interactive buttons
        require_relative "flex/image"    # For displaying images
        # Other components like Icon, Span, Separator could be added here if implemented.
      end
    end
  end
end
