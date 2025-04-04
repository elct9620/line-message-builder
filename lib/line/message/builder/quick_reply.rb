# frozen_string_literal: true

module Line
  module Message
    class Builder
      # The QuickReply allows to attach quick reply buttons to a message.
      module QuickReply
        autoload :Builder, "line/message/builder/quick_reply/builder"

        def quick_reply(&)
          @quick_reply ||= Builder.new(context, &)
        end
      end
    end
  end
end
