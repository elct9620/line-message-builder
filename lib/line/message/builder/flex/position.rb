# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The `Position` module serves as a namespace for several mixin modules
        # that provide common positioning-related properties (options) to various
        # Flex Message components (like {Box}, {Text}, {Image}, {Button}).
        #
        # These mixins are included in component classes to add DSL methods for
        # setting properties like alignment, gravity, padding, margin, and offsets,
        # which correspond to attributes in the LINE Flex Message JSON structure.
        #
        # @see Horizontal For `align` property.
        # @see Vertical For `gravity` property.
        # @see Padding For `paddingAll`, `paddingTop`, etc. properties.
        # @see Margin For `margin` property.
        # @see Offset For `position`, `offsetTop`, etc. properties.
        module Position
          # Provides the `align` option for horizontal alignment of a component
          # within its parent {Box} (if the parent box's `layout` is vertical).
          # For components like {Image} or {Text}, this controls their horizontal
          # alignment within the space allocated to them.
          #
          # @!method align(value)
          #   Sets or gets the horizontal alignment.
          #   @param value [Symbol, String, nil] Alignment keyword:
          #     `:start` (aligns to the start of the horizontal space),
          #     `:center` (aligns to the center),
          #     `:end` (aligns to the end).
          #   @return [Symbol, String, nil] The current alignment value.
          module Horizontal
            # @!visibility private
            def self.included(base)
              base.option :align,
                          default: nil,
                          validator: Validators::Enum.new(
                            :start, :center, :end
                          )
            end
          end

          # Provides the `gravity` option for vertical alignment of a component
          # within its parent {Box} (if the parent box's `layout` is horizontal
          # or baseline). For components like {Image} or {Text}, this controls
          # their vertical alignment within the space allocated to them.
          #
          # @!method gravity(value)
          #   Sets or gets the vertical alignment (gravity).
          #   @param value [Symbol, String, nil] Gravity keyword:
          #     `:top` (aligns to the top),
          #     `:center` (aligns to the center),
          #     `:bottom` (aligns to the bottom).
          #   @return [Symbol, String, nil] The current gravity value.
          module Vertical
            # @!visibility private
            def self.included(base)
              base.option :gravity, # Note: API key is `gravity` (lowercase `g`)
                          default: nil,
                          validator: Validators::Enum.new(
                            :top, :center, :bottom
                          )
            end
          end

          # Provides padding options for components, allowing space to be defined
          # around the content of a component, inside its borders.
          #
          # @!method padding_all(value)
          #   Sets or gets the padding for all sides.
          #   Corresponds to LINE API `paddingAll`.
          #   @param value [String, Symbol, nil] Padding value (e.g., `"10px"`, `"md"`, `"5%"`).
          #     Keywords: `:none`, `:xs`, `:sm`, `:md`, `:lg`, `:xl`, `:xxl`.
          #   @return [String, Symbol, nil] The current padding value.
          #
          # @!method padding_top(value)
          #   Sets or gets the top padding. Corresponds to LINE API `paddingTop`.
          #   @param value [String, Symbol, nil] Padding value.
          #   @return [String, Symbol, nil] The current top padding.
          #
          # @!method padding_bottom(value)
          #   Sets or gets the bottom padding. Corresponds to LINE API `paddingBottom`.
          #   @param value [String, Symbol, nil] Padding value.
          #   @return [String, Symbol, nil] The current bottom padding.
          #
          # @!method padding_start(value)
          #   Sets or gets the start-edge padding (left in LTR, right in RTL).
          #   Corresponds to LINE API `paddingStart`.
          #   @param value [String, Symbol, nil] Padding value.
          #   @return [String, Symbol, nil] The current start padding.
          #
          # @!method padding_end(value)
          #   Sets or gets the end-edge padding (right in LTR, left in RTL).
          #   Corresponds to LINE API `paddingEnd`.
          #   @param value [String, Symbol, nil] Padding value.
          #   @return [String, Symbol, nil] The current end padding.
          #
          # @note In this DSL, `padding` is an alias for `padding_all`.
          #   The LINE API uses `paddingAll`. When using the DSL `padding(value)`,
          #   it sets the underlying value that will be output as `paddingAll`.
          module Padding
            # @!visibility private
            def self.included(base)
              # Define :padding first, which often acts as an alias for :padding_all in DSLs.
              # The :padding_all option will map to the `paddingAll` API property.
              base.option :padding_all, # Maps to `paddingAll` in JSON
                          default: nil,
                          validator: Validators::Size.new(:pixel, :keyword, :percentage)

              # Alias `padding` to `padding_all` for convenience in the DSL
              base.send(:alias_method, :padding, :padding_all)
              base.send(:alias_method, :padding=, :padding_all=)


              # Individual side paddings
              %i[padding_top padding_bottom padding_start padding_end].each do |option_name|
                base.option option_name, # e.g., maps to `paddingTop` in JSON
                            default: nil,
                            validator: Validators::Size.new(:pixel, :keyword, :percentage)
              end
            end
          end

          # Provides the `margin` option, allowing space to be defined around a
          # component, outside its borders.
          #
          # @!method margin(value)
          #   Sets or gets the margin space around the component.
          #   @param value [String, Symbol, nil] Margin value (e.g., `"10px"`, `"md"`).
          #     Keywords: `:none`, `:xs`, `:sm`, `:md`, `:lg`, `:xl`, `:xxl`.
          #   @return [String, Symbol, nil] The current margin value.
          module Margin
            # @!visibility private
            def self.included(base)
              base.option :margin,
                          default: nil,
                          validator: Validators::Size.new(:pixel, :keyword) # Percentage not allowed for margin
            end
          end

          # Provides options for positioning components using offsets, either
          # absolutely or relatively to their normal position.
          #
          # @!method position(value)
          #   Sets or gets the positioning scheme.
          #   @param value [Symbol, String, nil] Positioning type:
          #     `:relative` (default, offsets are relative to normal position),
          #     `:absolute` (offsets are relative to the parent component's edges).
          #   @return [Symbol, String, nil] The current position type.
          #
          # @!method offset_top(value)
          #   Sets or gets the top offset. Corresponds to LINE API `offsetTop`.
          #   @param value [String, Symbol, nil] Offset value (e.g., `"10px"`, `"md"`).
          #   @return [String, Symbol, nil] The current top offset.
          #
          # @!method offset_bottom(value)
          #   Sets or gets the bottom offset. Corresponds to LINE API `offsetBottom`.
          #   @param value [String, Symbol, nil] Offset value.
          #   @return [String, Symbol, nil] The current bottom offset.
          #
          # @!method offset_start(value)
          #   Sets or gets the start-edge offset. Corresponds to LINE API `offsetStart`.
          #   @param value [String, Symbol, nil] Offset value.
          #   @return [String, Symbol, nil] The current start offset.
          #
          # @!method offset_end(value)
          #   Sets or gets the end-edge offset. Corresponds to LINE API `offsetEnd`.
          #   @param value [String, Symbol, nil] Offset value.
          #   @return [String, Symbol, nil] The current end offset.
          module Offset
            # @!visibility private
            def self.included(base)
              base.option :position,
                          default: nil, # LINE API default is :relative if offsets are used
                          validator: Validators::Enum.new(:absolute, :relative)

              %i[offset_top offset_bottom offset_start offset_end].each do |option_name|
                base.option option_name, # e.g., maps to `offsetTop` in JSON
                            default: nil,
                            validator: Validators::Size.new(:pixel, :keyword, :percentage) # Corrected: Percentage is allowed for offsets
              end
            end
          end
        end
      end
    end
  end
end
