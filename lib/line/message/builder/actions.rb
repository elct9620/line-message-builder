# frozen_string_literal: true

module Line
  module Message
    module Builder
      # The `Line::Message::Builder::Actions` module serves as a central namespace
      # for all action objects used within the LINE message builder DSL. Actions
      # represent operations that can be triggered by users interacting with
      # message components like buttons (in quick replies, templates, etc.) or
      # imagemap areas.
      #
      # This module itself does not define specific action classes directly but
      # acts as a container that loads them from individual files (e.g., `message.rb`,
      # `postback.rb`). Each loaded file defines a class corresponding to a
      # specific action type supported by the LINE Messaging API.
      #
      # By organizing actions under this namespace, the builder provides a clear
      # and consistent way to create and manage different types of interactive
      # elements in messages.
      #
      # See also:
      # - Actions::Message
      # - Actions::Postback
      # - https://developers.line.biz/en/reference/messaging-api/#action-objects
      module Actions
        require_relative "actions/message"
        require_relative "actions/postback"
      end
    end
  end
end
