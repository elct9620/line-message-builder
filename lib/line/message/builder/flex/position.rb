# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The Position module serves as a namespace for several mixin modules
        # that provide common positioning-related properties (options) to various
        # Flex Message components (like Box, Text, Image, Button).
        #
        # These mixins are included in component classes to add DSL methods for
        # setting properties like alignment, gravity, padding, margin, and offsets,
        # which correspond to attributes in the LINE Flex Message JSON structure.
        #
        # See also:
        # - Horizontal for +align+ property
        # - Vertical for +gravity+ property
        # - Padding for +padding_all+, +padding_top+, etc. properties
        # - Margin for +margin+ property
        # - Offset for +position+, +offset_top+, etc. properties
        module Position
          # Provides the +align+ option for horizontal alignment of a component
          # within its parent Box (if the parent box's +layout+ is vertical).
          # For components like Image or Text, this controls their horizontal
          # alignment within the space allocated to them.
          #
          # :method: align
          # :call-seq:
          #   align() -> Symbol, String, or nil
          #   align(value) -> Symbol, String, or nil
          #
          # Sets or gets the horizontal alignment.
          #
          # [value]
          #   Alignment keyword: +:start+ (aligns to the start of the horizontal space),
          #   +:center+ (aligns to the center), +:end+ (aligns to the end)
          module Horizontal
            def self.included(base) # :nodoc:
              base.option :align,
                          default: nil,
                          validator: Validators::Enum.new(
                            :start, :center, :end
                          )
            end
          end

          # Provides the +gravity+ option for vertical alignment of a component
          # within its parent Box (if the parent box's +layout+ is horizontal
          # or baseline). For components like Image or Text, this controls
          # their vertical alignment within the space allocated to them.
          #
          # :method: gravity
          # :call-seq:
          #   gravity() -> Symbol, String, or nil
          #   gravity(value) -> Symbol, String, or nil
          #
          # Sets or gets the vertical alignment (gravity).
          #
          # [value]
          #   Gravity keyword: +:top+ (aligns to the top), +:center+ (aligns to the center),
          #   +:bottom+ (aligns to the bottom)
          module Vertical
            def self.included(base) # :nodoc:
              base.option :gravity, # NOTE: API key is `gravity` (lowercase `g`)
                          default: nil,
                          validator: Validators::Enum.new(
                            :top, :center, :bottom
                          )
            end
          end

          # Provides padding options for components, allowing space to be defined
          # around the content of a component, inside its borders.
          #
          # Note: In this DSL, +padding+ is an alias for +padding_all+.
          # The LINE API uses +paddingAll+. When using the DSL <code>padding(value)</code>,
          # it sets the underlying value that will be output as +paddingAll+.
          #
          # :method: padding
          # :call-seq:
          #   padding() -> String, Symbol, or nil
          #   padding(value) -> String, Symbol, or nil
          #
          # Sets or gets the padding for all sides (alias for +padding_all+).
          # Corresponds to LINE API +paddingAll+.
          #
          # [value]
          #   Padding value (e.g. <code>"10px"</code>, <code>"md"</code>, <code>"5%"</code>).
          #   Keywords: +:none+, +:xs+, +:sm+, +:md+, +:lg+, +:xl+, +:xxl+
          #
          # :method: padding_all
          # :call-seq:
          #   padding_all() -> String, Symbol, or nil
          #   padding_all(value) -> String, Symbol, or nil
          #
          # Sets or gets the padding for all sides.
          # Corresponds to LINE API +paddingAll+.
          #
          # [value]
          #   Padding value (e.g. <code>"10px"</code>, <code>"md"</code>, <code>"5%"</code>).
          #   Keywords: +:none+, +:xs+, +:sm+, +:md+, +:lg+, +:xl+, +:xxl+
          #
          # :method: padding_top
          # :call-seq:
          #   padding_top() -> String, Symbol, or nil
          #   padding_top(value) -> String, Symbol, or nil
          #
          # Sets or gets the top padding. Corresponds to LINE API +paddingTop+.
          #
          # [value]
          #   Padding value
          #
          # :method: padding_bottom
          # :call-seq:
          #   padding_bottom() -> String, Symbol, or nil
          #   padding_bottom(value) -> String, Symbol, or nil
          #
          # Sets or gets the bottom padding. Corresponds to LINE API +paddingBottom+.
          #
          # [value]
          #   Padding value
          #
          # :method: padding_start
          # :call-seq:
          #   padding_start() -> String, Symbol, or nil
          #   padding_start(value) -> String, Symbol, or nil
          #
          # Sets or gets the start-edge padding (left in LTR, right in RTL).
          # Corresponds to LINE API +paddingStart+.
          #
          # [value]
          #   Padding value
          #
          # :method: padding_end
          # :call-seq:
          #   padding_end() -> String, Symbol, or nil
          #   padding_end(value) -> String, Symbol, or nil
          #
          # Sets or gets the end-edge padding (right in LTR, left in RTL).
          # Corresponds to LINE API +paddingEnd+.
          #
          # [value]
          #   Padding value
          module Padding
            def self.included(base) # :nodoc:
              # Individual side paddings
              %i[padding padding_all padding_top padding_bottom padding_start padding_end].each do |option_name|
                base.option option_name, # e.g., maps to `paddingTop` in JSON
                            default: nil,
                            validator: Validators::Size.new(:pixel, :keyword, :percentage)
              end
            end
          end

          # Provides the +margin+ option, allowing space to be defined around a
          # component, outside its borders.
          #
          # :method: margin
          # :call-seq:
          #   margin() -> String, Symbol, or nil
          #   margin(value) -> String, Symbol, or nil
          #
          # Sets or gets the margin space around the component.
          #
          # [value]
          #   Margin value (e.g. <code>"10px"</code>, <code>"md"</code>).
          #   Keywords: +:none+, +:xs+, +:sm+, +:md+, +:lg+, +:xl+, +:xxl+
          module Margin
            def self.included(base) # :nodoc:
              base.option :margin,
                          default: nil,
                          validator: Validators::Size.new(:pixel, :keyword) # Percentage not allowed for margin
            end
          end

          # Provides options for positioning components using offsets, either
          # absolutely or relatively to their normal position.
          #
          # :method: position
          # :call-seq:
          #   position() -> Symbol, String, or nil
          #   position(value) -> Symbol, String, or nil
          #
          # Sets or gets the positioning scheme.
          #
          # [value]
          #   Positioning type: +:relative+ (default, offsets are relative to normal position),
          #   +:absolute+ (offsets are relative to the parent component's edges)
          #
          # :method: offset_top
          # :call-seq:
          #   offset_top() -> String, Symbol, or nil
          #   offset_top(value) -> String, Symbol, or nil
          #
          # Sets or gets the top offset. Corresponds to LINE API +offsetTop+.
          #
          # [value]
          #   Offset value (e.g. <code>"10px"</code>, <code>"md"</code>)
          #
          # :method: offset_bottom
          # :call-seq:
          #   offset_bottom() -> String, Symbol, or nil
          #   offset_bottom(value) -> String, Symbol, or nil
          #
          # Sets or gets the bottom offset. Corresponds to LINE API +offsetBottom+.
          #
          # [value]
          #   Offset value
          #
          # :method: offset_start
          # :call-seq:
          #   offset_start() -> String, Symbol, or nil
          #   offset_start(value) -> String, Symbol, or nil
          #
          # Sets or gets the start-edge offset. Corresponds to LINE API +offsetStart+.
          #
          # [value]
          #   Offset value
          #
          # :method: offset_end
          # :call-seq:
          #   offset_end() -> String, Symbol, or nil
          #   offset_end(value) -> String, Symbol, or nil
          #
          # Sets or gets the end-edge offset. Corresponds to LINE API +offsetEnd+.
          #
          # [value]
          #   Offset value
          module Offset
            def self.included(base) # :nodoc:
              base.option :position,
                          default: nil, # LINE API default is :relative if offsets are used
                          validator: Validators::Enum.new(:absolute, :relative)

              %i[offset_top offset_bottom offset_start offset_end].each do |option_name|
                base.option option_name, # e.g., maps to `offsetTop` in JSON
                            default: nil,
                            validator: Validators::Size.new(:pixel, :keyword)
              end
            end
          end
        end
      end
    end
  end
end
