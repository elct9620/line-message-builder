# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The `Position` module contains various sub-modules that provide
        # positioning-related DSL options for Flex Message components.
        # These modules are typically included in component classes like {Box}, {Image}, {Text}, etc.
        module Position
          # Provides the `align` option for horizontal alignment of a component
          # within its parent. This is applicable when the parent is a horizontal box
          # and the component is smaller than the space allocated to it.
          #
          # @see https://developers.line.biz/en/reference/messaging-api/#component-align-property
          module Horizontal
            # @!visibility private
            def self.included(base)
              # @!method align(value)
              #   Sets or gets the horizontal alignment.
              #   @param value [:start, :center, :end, nil] The alignment value.
              #   @return [:start, :center, :end, nil] The current alignment.
              base.option :align,
                          default: nil,
                          validator: Validators::Enum.new(
                            :start, :center, :end
                          )
            end
          end

          # Provides the `gravity` option for vertical alignment of a component
          # within its parent. This is applicable when the parent is a vertical box
          # and the component is smaller than the space allocated to it.
          #
          # @see https://developers.line.biz/en/reference/messaging-api/#component-gravity-property
          module Vertical
            # @!visibility private
            def self.included(base)
              # @!method gravity(value)
              #   Sets or gets the vertical alignment (gravity).
              #   @param value [:top, :center, :bottom, nil] The gravity value.
              #   @return [:top, :center, :bottom, nil] The current gravity.
              base.option :gravity,
                          default: nil,
                          validator: Validators::Enum.new(
                            :top, :center, :bottom
                          )
            end
          end

          # Provides options for setting padding around a component's content.
          # Includes `padding_all`, `padding_top`, `padding_bottom`, `padding_start`, and `padding_end`.
          # Values can be specified in pixels (e.g., "10px"), as a keyword (e.g., :md),
          # or as a percentage (e.g., "5%").
          #
          # @see https://developers.line.biz/en/reference/messaging-api/#box-paddingall
          module Padding
            # @!visibility private
            def self.included(base)
              # @!method padding_all(value)
              #   Sets or gets the padding for all sides of the component.
              #   This value is used for the `paddingAll` property in the JSON payload sent to the LINE API.
              #   @param value [String, Symbol, nil] The padding value (e.g., "10px", :md, "5%").
              #   @return [String, Symbol, nil] The current padding value for all sides.
              # @!method padding_top(value)
              #   Sets or gets the top padding.
              #   @param value [String, Symbol, nil]
              #   @return [String, Symbol, nil]
              # @!method padding_bottom(value)
              #   Sets or gets the bottom padding.
              #   @param value [String, Symbol, nil]
              #   @return [String, Symbol, nil]
              # @!method padding_start(value)
              #   Sets or gets the start-side padding (left in LTR, right in RTL).
              #   @param value [String, Symbol, nil]
              #   @return [String, Symbol, nil]
              # @!method padding_end(value)
              #   Sets or gets the end-side padding (right in LTR, left in RTL).
              #   @param value [String, Symbol, nil]
              #   @return [String, Symbol, nil]
              #
              # Note: The RDoc for these methods is illustrative. The actual methods are dynamically defined.
              # The `base.option` calls below are what create these methods.
              # The `padding` method was renamed to `padding_all` to avoid conflicts with Kernel#padding.
              base.option :padding_all,
                          default: nil,
                          validator: Validators::Size.new(:pixel, :keyword, :percentage)
              base.option :padding_top,
                          default: nil,
                          validator: Validators::Size.new(:pixel, :keyword, :percentage)
              base.option :padding_bottom,
                          default: nil,
                          validator: Validators::Size.new(:pixel, :keyword, :percentage)
              base.option :padding_start,
                          default: nil,
                          validator: Validators::Size.new(:pixel, :keyword, :percentage)
              base.option :padding_end,
                          default: nil,
                          validator: Validators::Size.new(:pixel, :keyword, :percentage)
            end
          end

          # Provides the `margin` option for setting the space around a component,
          # outside its border/padding.
          # Values can be specified in pixels (e.g., "10px") or as a keyword (e.g., :md).
          #
          # @see https://developers.line.biz/en/reference/messaging-api/#component-margin-property
          module Margin
            # @!visibility private
            def self.included(base)
              # @!method margin(value)
              #   Sets or gets the margin.
              #   @param value [String, Symbol, nil] e.g., "10px", :md.
              #   @return [String, Symbol, nil] The current margin.
              base.option :margin,
                          default: nil,
                          validator: Validators::Size.new(:pixel, :keyword)
            end
          end

          # Provides options for absolute or relative positioning of a component.
          # Includes `position`, `offset_top`, `offset_bottom`, `offset_start`, and `offset_end`.
          #
          # @see https://developers.line.biz/en/reference/messaging-api/#component-position-property
          # @see https://developers.line.biz/en/reference/messaging-api/#component-offsettop-property
          module Offset
            # @!visibility private
            def self.included(base)
              # @!method position(value)
              #   Sets or gets the positioning type.
              #   @param value [:absolute, :relative, nil] The position type.
              #   @return [:absolute, :relative, nil] The current position type.
              base.option :position,
                          default: nil,
                          validator: Validators::Enum.new(:absolute, :relative)

              # @!method offset_top(value)
              #   Sets or gets the top offset.
              #   @param value [String, Symbol, nil] e.g., "10px", :md.
              #   @return [String, Symbol, nil]
              # @!method offset_bottom(value)
              #   Sets or gets the bottom offset.
              #   @param value [String, Symbol, nil]
              #   @return [String, Symbol, nil]
              # @!method offset_start(value)
              #   Sets or gets the start-side offset.
              #   @param value [String, Symbol, nil]
              #   @return [String, Symbol, nil]
              # @!method offset_end(value)
              #   Sets or gets the end-side offset.
              #   @param value [String, Symbol, nil]
              #   @return [String, Symbol, nil]
              #
              # Note: RDoc for these methods is illustrative.
              %i[offset_top offset_bottom offset_start offset_end].each do |option_name|
                base.option option_name,
                            default: nil,
                            validator: Validators::Size.new(:pixel, :keyword, :percentage) # Corrected: offset allows percentage
              end
            end
          end
        end
      end
    end
  end
end
