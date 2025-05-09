# frozen_string_literal: true

module Line
  module Message
    module Builder
      # The Flex module allows to build Flex messages.
      module Flex
        require_relative "flex/builder"
        require_relative "flex/actionable"
        require_relative "flex/position"
        require_relative "flex/size"

        # Container
        require_relative "flex/bubble"
        require_relative "flex/carousel"

        # Components
        require_relative "flex/box"
        require_relative "flex/text"
        require_relative "flex/button"
        require_relative "flex/image"
      end
    end
  end
end
