# frozen_string_literal: true

module Line
  module Message
    module Builder
      # The Flex module allows to build Flex messages.
      module Flex
        require_relative "flex/builder"

        # Container
        require_relative "flex/bubble"

        # Components
        require_relative "flex/box"
        require_relative "flex/text"
      end
    end
  end
end
