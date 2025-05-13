# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        module Size
          # The flex size provides "flex" options for flex components.
          module Flex
            def self.included(base)
              base.option :flex,
                          default: nil
            end
          end

          # The image provides "size" options for flex image component.
          module Image
            def self.included(base)
              base.option :size,
                          default: nil,
                          validator: Validators::Size.new(:pixel, :image, :percentage)
            end
          end

          # The shared provides "size" options for flex components which is icon, text and span.
          module Shared
            def self.included(base)
              base.option :size,
                          default: nil,
                          validator: Validators::Size.new(:pixel, :keyword)
            end
          end

          # The adjust mode provides "adjust mode" options for flex components.
          module AdjustMode
            def self.included(base)
              base.option :adjust_mode,
                          default: nil,
                          validator: Validators::Enum.new(
                            :"shrink-to-fit"
                          )
            end

            def shrink_to_fit!
              @adjust_mode = :"shrink-to-fit"
            end
          end
        end
      end
    end
  end
end
