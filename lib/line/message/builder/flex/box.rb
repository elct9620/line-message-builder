# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The box is a component for the Flex message.
        class Box < Line::Message::Builder::Base
          include Actionable
          include Position::Padding

          attr_reader :contents

          option :layout, default: :horizontal, validator: Validators::Enum.new(
            :horizontal, :vertical, :baseline
          )
          option :justify_content, default: nil, validator: Validators::Enum.new(
            :flex_start, :center, :flex_end, :space_between, :space_around, :space_evenly
          )
          option :align_items, default: nil, validator: Validators::Enum.new(
            :flex_start, :center, :flex_end
          )
          option :spacing, default: nil, validator: Validators::Size.new
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

          def to_h # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
            raise RequiredError, "layout is required" if layout.nil?

            {
              type: "box",
              layout: layout,
              justifyContent: justify_content,
              alignItems: align_items,
              # Position::Padding
              paddingAll: padding,
              paddingTop: padding_top,
              paddingBottom: padding_bottom,
              paddingStart: padding_start,
              paddingEnd: padding_end,
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
