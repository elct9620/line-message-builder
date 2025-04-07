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
                          default: :nil
            end
          end
        end
      end
    end
  end
end
