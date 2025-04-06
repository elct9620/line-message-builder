# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The action DSL for flex components.
        module Actionable
          def self.included(base)
            base.attr_reader :action
          end

          def message(text, **options, &)
            @action = Actions::Message.new(text, context: context, **options, &)
          end

          def postback(data, **options, &)
            @action = Actions::Postback.new(data, context: context, **options, &)
          end
        end
      end
    end
  end
end
