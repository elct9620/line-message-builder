# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # Represents a "bubble" container in a LINE Flex Message.
        # A bubble is a self-contained unit of content, structured into optional
        # sections: header, hero (an image or box), body, and footer.
        # Bubbles are the fundamental building blocks for single Flex Messages or
        # for each item in a {Carousel} container.
        #
        # @example Creating a simple bubble with a body
        #   Line::Message::Builder.with do |root|
        #     root.flex alt_text: "Simple Bubble" do |flex|
        #       flex.bubble do |bubble|
        #         bubble.body do |body_box|
        #           body_box.text "Hello, this is a bubble!"
        #         end
        #       end
        #     end
        #   end
        #
        # @see https://developers.line.biz/en/reference/messaging-api/#bubble
        # @see HasPartial For including reusable component groups within sections.
        # @see Box For the structure of header, hero (if box), body, and footer.
        # @see Image For using an image as a hero section.
        class Bubble < Line::Message::Builder::Base
          include HasPartial # Allows including predefined partial component sets into sections.

          # Specifies the size of the bubble.
          # @!method size(value)
          #   @param value [Symbol, String, nil] Bubble size. Keywords: `:nano`, `:micro`,
          #     `:kilo`, `:mega`, `:giga`. Pixel/percentage values are not directly
          #     supported for bubble size by LINE; use keywords.
          #   @return [Symbol, String, nil] The current bubble size.
          option :size, default: nil # E.g., :nano, :micro, :kilo, :mega, :giga

          # Defines custom styles for the bubble and its sections (header, hero, body, footer).
          # @!method styles(value)
          #   @param value [Hash, nil] A hash defining style overrides.
          #     See LINE API documentation for the structure of the styles object.
          #   @return [Hash, nil] The current styles hash.
          #   @example
          #     bubble.styles(
          #       header: { backgroundColor: "#FF0000" },
          #       body: { separator: true, separatorColor: "#00FF00" }
          #     )
          option :styles, default: nil

          # Initializes a new Flex Message Bubble container.
          # The provided block is instance-eval'd, allowing DSL methods for defining
          # sections (e.g., {#header}, {#body}) to be called.
          #
          # @param context [Object, nil] An optional context for the builder.
          # @param options [Hash] A hash of options to set instance variables
          #   (e.g., `:size`, `:styles`).
          # @param block [Proc, nil] A block to define the sections of this bubble.
          def initialize(context: nil, **options, &)
            @header = nil
            @hero = nil
            @body = nil
            @footer = nil

            super # Calls Base#initialize, sets options, and evals block
          end

          # Defines the header section of the bubble using a {Box} component.
          #
          # @param options [Hash] Options for the header Box. See {Box#initialize}.
          # @param block [Proc] A block to define the contents of the header Box.
          # @return [Flex::Box] The newly created Box object for the header.
          def header(**options, &)
            @header = Box.new(**options, context: context, &)
          end

          # Defines the hero section of the bubble using a {Box} component.
          # The hero section is typically used for prominent content like a large image or video.
          #
          # @param options [Hash] Options for the hero Box. See {Box#initialize}.
          # @param block [Proc] A block to define the contents of the hero Box.
          # @return [Flex::Box] The newly created Box object for the hero section.
          def hero(**options, &)
            @hero = Box.new(**options, context: context, &)
          end

          # Defines the hero section of the bubble using an {Image} component.
          # This is a convenience method for common cases where the hero is a single image.
          #
          # @param url [String] The URL of the image.
          # @param options [Hash] Options for the Image component. See {Image#initialize}.
          # @param block [Proc, nil] An optional block for the Image component (e.g., for an action).
          # @return [Flex::Image] The newly created Image object for the hero section.
          def hero_image(url, **options, &)
            @hero = Image.new(url, **options, context: context, &)
          end

          # Defines the body section of the bubble using a {Box} component.
          # This is the main content area of the bubble.
          #
          # @param options [Hash] Options for the body Box. See {Box#initialize}.
          # @param block [Proc] A block to define the contents of the body Box.
          # @return [Flex::Box] The newly created Box object for the body.
          def body(**options, &)
            @body = Box.new(**options, context: context, &)
          end

          # Defines the footer section of the bubble using a {Box} component.
          #
          # @param options [Hash] Options for the footer Box. See {Box#initialize}.
          # @param block [Proc] A block to define the contents of the footer Box.
          # @return [Flex::Box] The newly created Box object for the footer.
          def footer(**options, &)
            @footer = Box.new(**options, context: context, &)
          end

          private

          def to_api
            {
              type: "bubble",
              size: size, # From option
              styles: styles, # From option
              header: @header&.to_h,
              hero: @hero&.to_h,
              body: @body&.to_h,
              footer: @footer&.to_h
            }.compact
          end

          def to_sdkv2
            {
              type: "bubble",
              size: size, # From option
              styles: styles, # From option
              header: @header&.to_h,
              hero: @hero&.to_h,
              body: @body&.to_h,
              footer: @footer&.to_h
            }.compact
          end
        end
      end
    end
  end
end
