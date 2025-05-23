# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The `Size` module groups sub-modules that provide various sizing-related
        # DSL options for Flex Message components. These are included in specific
        # component classes as needed.
        module Size
          # Provides the `flex` option, which determines how much a component
          # will grow or shrink relative to other components in a flex layout.
          #
          # @see https://developers.line.biz/en/reference/messaging-api/#component-flex-property
          module Flex
            # @!visibility private
            def self.included(base)
              # @!method flex(value)
              #   Sets or gets the flex factor of the component.
              #   A value of 0 means the component will not flex.
              #   A positive value means it will grow proportionally.
              #   @param value [Integer, nil] The flex factor.
              #   @return [Integer, nil] The current flex factor.
              base.option :flex,
                          default: nil # Validator could be added for non-negative integers
            end
          end

          # Provides the `size` option specifically for the {Flex::Image} component.
          # It allows specifying predefined image sizes, pixel dimensions, or percentages.
          #
          # @see https://developers.line.biz/en/reference/messaging-api/#image-size
          module Image
            # @!visibility private
            def self.included(base)
              # @!method size(value)
              #   Sets or gets the size of the image.
              #   @param value [String, Symbol, nil] e.g., "xl", "300px", "50%", :full.
              #   @return [String, Symbol, nil] The current image size.
              base.option :size,
                          default: nil,
                          validator: Validators::Size.new(:pixel, :image, :percentage)
            end
          end

          # Provides a shared `size` option for components like {Flex::Text},
          # Icon, and Span. This typically refers to font size or icon size.
          # Values can be specified in pixels (e.g., "16px") or as keywords (e.g., :md).
          #
          # @see https://developers.line.biz/en/reference/messaging-api/#text-size
          # @see https://developers.line.biz/en/reference/messaging-api/#icon-size
          module Shared
            # @!visibility private
            def self.included(base)
              # @!method size(value)
              #   Sets or gets the size (e.g., font size, icon size).
              #   @param value [String, Symbol, nil] e.g., "16px", :md, "lg".
              #   @return [String, Symbol, nil] The current size.
              base.option :size,
                          default: nil,
                          validator: Validators::Size.new(:pixel, :keyword)
            end
          end

          # Provides the `adjust_mode` option, currently supporting `shrink-to-fit`.
          # This is used, for example, in {Flex::Button} to adjust its width to fit the label.
          #
          # @see https://developers.line.biz/en/reference/messaging-api/#button-adjustmode
          module AdjustMode
            # @!visibility private
            def self.included(base)
              # @!method adjust_mode(value)
              #   Sets or gets the adjustment mode.
              #   @param value [:"shrink-to-fit", nil] The adjustment mode.
              #   @return [:"shrink-to-fit", nil] The current adjustment mode.
              base.option :adjust_mode,
                          default: nil,
                          validator: Validators::Enum.new(
                            :"shrink-to-fit"
                          )
            end

            # A shorthand method to set the `adjust_mode` to `:"shrink-to-fit"`.
            # @return [:"shrink-to-fit"]
            def shrink_to_fit!
              self.adjust_mode = :"shrink-to-fit" # Use the writer method
            end
          end
        end
      end
    end
  end
end
