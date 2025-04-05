# frozen_string_literal: true

module Line
  module Message
    module Builder
      # The container class is main container to manage messages.
      class Container < Base
        attr_reader :context

        def initialize(context: nil, &)
          @messages = []

          super
        end

        def text(text, &)
          @messages << Text.new(text, context: context, &)
        end

        def flex(**args, &)
          @messages << Flex::Builder.new(**args, context: context, &)
        end

        def build
          @messages.map(&:to_h)
        end

        def to_json(*args)
          build.to_json(*args)
        end
      end
    end
  end
end
