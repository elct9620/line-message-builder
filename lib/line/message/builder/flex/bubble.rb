# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # Represents a Bubble container in a Flex Message.
        # A bubble is a basic unit of a Flex Message, consisting of optional
        # header, hero, body, and footer sections.
        #
        # @see https://developers.line.biz/en/reference/messaging-api/#bubble
        class Bubble < Line::Message::Builder::Base
          include HasPartial

          # @!attribute size
          #   @return [:nano, :micro, :deca, :hecto, :kilo, :mega, :giga, String, nil]
          #     The size of the bubble. Can be one of the predefined sizes or a custom width (e.g., "300px").
          #   @see https://developers.line.biz/en/reference/messaging-api/#bubble-size
          option :size, default: nil
          # @!attribute styles
          #   @return [Hash, nil] A hash defining the styles for the bubble's header, hero, body, and footer.
          #   @see https://developers.line.biz/en/reference/messaging-api/#bubble-style
          option :styles, default: nil

          # Initializes a new Bubble container.
          #
          # @param context [Object, nil] The context for the bubble.
          # @param options [Hash] Options for the bubble (e.g., size, styles).
          # @param block [Proc, nil] A block to define the contents of the bubble using the DSL.
          #   Within the block, you can define `header`, `hero`, `body`, and `footer` sections.
          def initialize(context: nil, **options, &)
            @header = nil
            @hero = nil
            @body = nil
            @footer = nil

            super
          end

          # Defines the header section of the bubble.
          # The header is a {Box} component.
          #
          # @param options [Hash] Options for the header Box.
          # @param block [Proc] A block to define the contents of the header Box.
          # @return [Box] The created Box component for the header.
          def header(**options, &)
            @header = Box.new(**options, context: context, &)
          end

          # Defines the hero section of the bubble.
          # The hero is typically a {Box} component, often containing an {Image}.
          #
          # @param options [Hash] Options for the hero Box.
          # @param block [Proc] A block to define the contents of the hero Box.
          # @return [Box] The created Box component for the hero.
          def hero(**options, &)
            @hero = Box.new(**options, context: context, &)
          end

          # Defines the hero section of the bubble with a single {Image}.
          #
          # @param url [String] The URL of the image for the hero section.
          # @param options [Hash] Options for the Image component.
          # @param block [Proc, nil] An optional block for further configuration of the Image.
          # @return [Image] The created Image component for the hero.
          def hero_image(url, **options, &)
            @hero = Image.new(url, **options, context: context, &)
          end

          # Defines the body section of the bubble.
          # The body is a {Box} component.
          #
          # @param options [Hash] Options for the body Box.
          # @param block [Proc] A block to define the contents of the body Box.
          # @return [Box] The created Box component for the body.
          def body(**options, &)
            @body = Box.new(**options, context: context, &)
          end

          # Defines the footer section of the bubble.
          # The footer is a {Box} component.
          #
          # @param options [Hash] Options for the footer Box.
          # @param block [Proc] A block to define the contents of the footer Box.
          # @return [Box] The created Box component for the footer.
          def footer(**options, &)
            @footer = Box.new(**options, context: context, &)
          end

          # Converts the Bubble container to its hash representation for the LINE API.
          #
          # @return [Hash] The hash representation of the bubble.
          def to_h
            {
              type: "bubble",
              header: @header&.to_h,
              hero: @hero&.to_h,
              body: @body&.to_h,
              footer: @footer&.to_h,
              size: size, # size can be a symbol or string
              styles: styles
            }.compact
          end
        end
      end
    end
  end
end
