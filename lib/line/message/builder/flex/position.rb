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
        end
      end
    end
  end
end
