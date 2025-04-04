# frozen_string_literal: true

module Line
  module Message
    class Builder
      # The actions module contains classes for building different types of actions
      module Actions
        require_relative "actions/message"
        require_relative "actions/postback"
      end
    end
  end
end
