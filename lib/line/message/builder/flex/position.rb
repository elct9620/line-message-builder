# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        module Position
          # The horizontal provides "align" options for flex components.
          module Horizontal
            def self.included(base)
              base.option :align,
                          default: :nil,
                          validator: Validators::Enum.new(
                            :start, :center, :end
                          )
            end
          end

          # The vertical provides "gatvity" options for flex components.
          module Vertical
            def self.included(base)
              base.option :gravity,
                          default: :nil,
                          validator: Validators::Enum.new(
                            :top, :center, :bottom
                          )
            end
          end

          # The padding provides "padding" options for flex components.
          module Padding
            def self.included(base)
              %i[padding padding_top padding_bottom padding_start padding_end].each do |option|
                base.option option,
                            default: :nil,
                            validator: Validators::PercentageSize.new
              end
            end
          end

          # The margin provides "margin" options for flex components.
          module Margin
            def self.included(base)
              base.option :margin,
                          default: :nil,
                          validator: Validators::KeywordSize.new
            end
          end

          # The offset provides "offset" options for flex components.
          module Offset
            def self.included(base)
              base.option :position,
                          default: :nil,
                          validator: Validators::Enum.new(:absolute, :relative)

              %i[offset_top offset_bottom offset_start offset_end].each do |option|
                base.option option,
                            default: :nil,
                            validator: Validators::KeywordSize.new
              end
            end
          end
        end
      end
    end
  end
end
