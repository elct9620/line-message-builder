# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The Size module acts as a namespace for several mixin modules that
        # provide various size-related properties (options) to Flex Message
        # components. These properties control aspects like the component's flex
        # factor within a box, specific size keywords for images or text, and
        # adjustment behaviors like shrink-to-fit.
        #
        # These mixins are included in component classes (e.g., Box, Image, Text)
        # to add DSL methods for these sizing attributes.
        #
        # See also:
        # - Flex - For +flex+ property (flex grow/shrink factor)
        # - Image - For image-specific +size+ keywords
        # - Shared - For common +size+ keywords (text, icons, spans)
        # - AdjustMode - For +adjust_mode+ property (e.g., shrink-to-fit)
        module Size
          # Provides the +flex+ option, which determines the ratio of space a
          # component occupies within its parent Box relative to its siblings.
          # A higher flex value means the component will take up more space.
          # A value of 0 means the component does not flex (its size is fixed).
          module Flex
            ##
            # :method: flex
            # :call-seq:
            #   flex() -> Integer or nil
            #   flex(value) -> Integer
            #
            # Sets or gets the flex factor of the component.
            #
            # [value]
            #   The flex factor. +0+ means no flex. Positive integers determine the ratio.

            # :nodoc:
            def self.included(base)
              base.option :flex,
                          default: nil # Default is 0 if not specified and parent is a Box
            end
          end

          # Provides the +size+ option specifically for Image components.
          # This allows setting the image size using keywords recognized by the
          # LINE API for images, or explicit pixel/percentage values.
          module Image
            ##
            # :method: size
            # :call-seq:
            #   size() -> Symbol, String, or nil
            #   size(value) -> Symbol or String
            #
            # Sets or gets the size of the image.
            #
            # [value]
            #   Image size. Can be keywords like +:xxs+, +:xs+, +:sm+, +:md+, +:lg+,
            #   +:xl+, +:xxl+, +:full+, or a string like <code>"50px"</code> or <code>"25%"</code>.

            # :nodoc:
            def self.included(base)
              base.option :size,
                          default: nil,
                          validator: Validators::Size.new(:pixel, :image, :percentage)
            end
          end

          # Provides a common +size+ option for components like Text, Icon,
          # and Span. This allows setting size using standard keywords or explicit
          # pixel values.
          module Shared
            ##
            # :method: size
            # :call-seq:
            #   size() -> Symbol, String, or nil
            #   size(value) -> Symbol or String
            #
            # Sets or gets the size of the component (e.g., text font size).
            #
            # [value]
            #   Component size. Can be keywords like +:xxs+, +:xs+, +:sm+, +:md+, +:lg+,
            #   +:xl+, +:xxl+, +:3xl+, +:4xl+, +:5xl+, or a string like <code>"16px"</code>.

            # :nodoc:
            def self.included(base)
              base.option :size,
                          default: nil,
                          validator: Validators::Size.new(:pixel, :keyword)
            end
          end

          # Provides the +adjust_mode+ option, primarily for Button components,
          # to control how they fit within available space. Currently, only
          # <code>:"shrink-to-fit"</code> is supported by LINE API via this property.
          module AdjustMode
            ##
            # :method: adjust_mode
            # :call-seq:
            #   adjust_mode() -> Symbol, String, or nil
            #   adjust_mode(value) -> Symbol or String
            #
            # Sets or gets the adjust mode.
            #
            # [value]
            #   The adjust mode. Currently, only <code>:"shrink-to-fit"</code> is a valid value.

            # :nodoc:
            def self.included(base)
              base.option :adjust_mode,
                          default: nil,
                          validator: Validators::Enum.new(
                            :"shrink-to-fit" # LINE API uses "shrink-to-fit"
                          )
            end

            # A convenience DSL method to set the +adjust_mode+ to <code>:"shrink-to-fit"</code>.
            #
            # == Example
            #
            #   button_component.shrink_to_fit!
            def shrink_to_fit!
              adjust_mode(:"shrink-to-fit")
            end
          end
        end
      end
    end
  end
end
