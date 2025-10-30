# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # Represents a "bubble" container in a LINE Flex Message.
        # A bubble is a self-contained unit of content, structured into optional
        # sections: header, hero (an image or box), body, and footer.
        # Bubbles are the fundamental building blocks for single Flex Messages or
        # for each item in a Carousel container.
        #
        # == Example: Creating a simple bubble with a body
        #
        #   Line::Message::Builder.with do
        #     flex alt_text: "Simple Bubble" do
        #       bubble do
        #         body do
        #           text "Hello, this is a bubble!"
        #         end
        #       end
        #     end
        #   end
        #
        # See also:
        # - https://developers.line.biz/en/reference/messaging-api/#bubble
        # - HasPartial
        # - Box
        # - Image
        class Bubble < Line::Message::Builder::Base
          include HasPartial # Allows including predefined partial component sets into sections.

          # :method: size
          #
          # :call-seq:
          #   size() -> Symbol, String, or nil
          #   size(value) -> Symbol, String, or nil
          #
          # Specifies the size of the bubble.
          #
          # [value]
          #   Bubble size. Keywords: <code>:nano</code>, <code>:micro</code>, <code>:kilo</code>, <code>:mega</code>, <code>:giga</code>.
          #   Pixel/percentage values are not directly supported for bubble
          #   size by LINE; use keywords.
          option :size, default: nil # E.g., :nano, :micro, :kilo, :mega, :giga

          # :method: styles
          #
          # :call-seq:
          #   styles() -> Hash or nil
          #   styles(value) -> Hash or nil
          #
          # Defines custom styles for the bubble and its sections (header, hero, body, footer).
          #
          # [value]
          #   A hash defining style overrides. See LINE API documentation
          #   for the structure of the styles object.
          #
          # == Example
          #
          #   bubble.styles(
          #     header: { backgroundColor: "#FF0000" },
          #     body: { separator: true, separatorColor: "#00FF00" }
          #   )
          option :styles, default: nil

          # Initializes a new Flex Message Bubble container.
          # The provided block is instance-eval'd, allowing DSL methods for defining
          # sections (e.g., #header, #body) to be called.
          #
          # [context]
          #   An optional context for the builder.
          # [option]
          #   A hash of options to set instance variables (e.g., <code>:size</code>, <code>:styles</code>).
          # [block]
          #   A block to define the sections of this bubble.
          def initialize(context: nil, **options, &)
            @header = nil
            @hero = nil
            @body = nil
            @footer = nil

            super # Calls Base#initialize, sets options, and evals block
          end

          # Defines the header section of the bubble using a Box component.
          #
          # [option]
          #   Options for the header Box. See Box#initialize.
          # [block]
          #   A block to define the contents of the header Box.
          def header(**options, &)
            @header = Box.new(**options, context: context, &)
          end

          # Defines the hero section of the bubble using a Box component.
          # The hero section is typically used for prominent content like a large image or video.
          #
          # [option]
          #   Options for the hero Box. See Box#initialize.
          # [block]
          #   A block to define the contents of the hero Box.
          def hero(**options, &)
            @hero = Box.new(**options, context: context, &)
          end

          # Defines the hero section of the bubble using an Image component.
          # This is a convenience method for common cases where the hero is a single image.
          #
          # [url]
          #   The URL of the image.
          # [option]
          #   Options for the Image component. See Image#initialize.
          # [block]
          #   An optional block for the Image component (e.g., for an action).
          def hero_image(url, **options, &)
            @hero = Image.new(url, **options, context: context, &)
          end

          # Defines the body section of the bubble using a Box component.
          # This is the main content area of the bubble.
          #
          # [option]
          #   Options for the body Box. See Box#initialize.
          # [block]
          #   A block to define the contents of the body Box.
          def body(**options, &)
            @body = Box.new(**options, context: context, &)
          end

          # Defines the footer section of the bubble using a Box component.
          #
          # [option]
          #   Options for the footer Box. See Box#initialize.
          # [block]
          #   A block to define the contents of the footer Box.
          def footer(**options, &)
            @footer = Box.new(**options, context: context, &)
          end

          private

          def to_api # :nodoc:
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

          def to_sdkv2 # :nodoc:
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
