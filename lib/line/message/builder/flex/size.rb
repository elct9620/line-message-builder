# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The `Size` module acts as a namespace for several mixin modules that
        # provide various size-related properties (options) to Flex Message
        # components. These properties control aspects like the component's flex
        # factor within a box, specific size keywords for images or text, and
        # adjustment behaviors like shrink-to-fit.
        #
        # These mixins are included in component classes (e.g., {Box}, {Image}, {Text})
        # to add DSL methods for these sizing attributes.
        #
        # @see Flex For `flex` property (flex grow/shrink factor).
        # @see Image For image-specific `size` keywords.
        # @see Shared For common `size` keywords (text, icons, spans).
        # @see AdjustMode For `adjustMode` property (e.g., shrink-to-fit).
        module Size
          # Provides the `flex` option, which determines the ratio of space a
          # component occupies within its parent {Box} relative to its siblings.
          # A higher flex value means the component will take up more space.
          # A value of 0 means the component does not flex (its size is fixed).
          #
          # @!method flex(value)
          #   Sets or gets the flex factor of the component.
          #   @param value [Integer, nil] The flex factor. `0` means no flex.
          #     Positive integers determine the ratio.
          #   @return [Integer, nil] The current flex factor.
          module Flex
            # @!visibility private
            def self.included(base)
              base.option :flex,
                          default: nil # Default is 0 if not specified and parent is a Box
            end
          end

          # Provides the `size` option specifically for {Image} components.
          # This allows setting the image size using keywords recognized by the
          # LINE API for images, or explicit pixel/percentage values.
          #
          # @!method size(value)
          #   Sets or gets the size of the image.
          #   @param value [Symbol, String, nil] Image size. Can be keywords like
          #     `:xxs`, `:xs`, `:sm`, `:md`, `:lg`, `:xl`, `:xxl`, `:full`,
          #     or a string like `"50px"`, `"25%"`.
          #   @return [Symbol, String, nil] The current image size.
          module Image
            # @!visibility private
            def self.included(base)
              base.option :size,
                          default: nil,
                          validator: Validators::Size.new(:pixel, :image, :percentage)
            end
          end

          # Provides a common `size` option for components like {Text}, {Icon},
          # and {Span}. This allows setting size using standard keywords or explicit
          # pixel values.
          #
          # @!method size(value)
          #   Sets or gets the size of the component (e.g., text font size).
          #   @param value [Symbol, String, nil] Component size. Can be keywords like
          #     `:xxs`, `:xs`, `:sm`, `:md`, `:lg`, `:xl`, `:xxl`, `3xl`, `4xl`, `5xl`,
          #     or a string like `"16px"`.
          #   @return [Symbol, String, nil] The current component size.
          module Shared
            # @!visibility private
            def self.included(base)
              base.option :size,
                          default: nil,
                          validator: Validators::Size.new(:pixel, :keyword)
            end
          end

          # Provides the `adjust_mode` option, primarily for {Button} components,
          # to control how they fit within available space. Currently, only
          # `shrink-to-fit` is supported by LINE API via this property.
          #
          # @!method adjust_mode(value)
          #   Sets or gets the adjust mode.
          #   @param value [Symbol, String, nil] The adjust mode. Currently, only
          #     `:"shrink-to-fit"` is a valid value.
          #   @return [Symbol, String, nil] The current adjust mode.
          module AdjustMode
            # @!visibility private
            def self.included(base)
              base.option :adjust_mode,
                          default: nil,
                          validator: Validators::Enum.new(
                            :"shrink-to-fit" # LINE API uses "shrink-to-fit"
                          )
            end

            # A convenience DSL method to set the `adjust_mode` to `:"shrink-to-fit"`.
            #
            # @example
            #   button_component.shrink_to_fit!
            #
            # @return [Symbol] The value `:"shrink-to-fit"`.
            def shrink_to_fit!
              adjust_mode(:"shrink-to-fit")
            end
          end
        end
      end
    end
  end
end
