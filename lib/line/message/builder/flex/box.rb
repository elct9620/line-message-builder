# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The box is a component for the Flex message.
        class Box < Line::Message::Builder::Base
          include Actionable

          attr_reader :contents

          option :layout, default: :horizontal
          option :spacing, default: nil
          option :flex, default: nil

          def initialize(context: nil, **options, &)
            @contents = []

            super
          end

          def box(**options, &)
            @contents << Flex::Box.new(context: context, **options, &)
          end

          def text(text, **options, &)
            @contents << Flex::Text.new(text, context: context, **options, &)
          end

          def button(**options, &)
            @contents << Flex::Button.new(context: context, **options, &)
          end

          def image(url, **options, &)
            @contents << Flex::Image.new(url, context: context, **options, &)
          end

          def to_h
            raise RequiredError, "layout is required" if layout.nil?
            raise RequiredError, "contents is required" if contents.empty?

            {
              type: "box",
              layout: layout,
              spacing: spacing,
              flex: flex,
              contents: contents.map(&:to_h),
              action: action&.to_h
            }.compact
          end
        end
      end
    end
  end
end
