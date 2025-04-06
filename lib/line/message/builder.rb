# frozen_string_literal: true

require_relative "builder/version"

module Line
  module Message
    # The Builder module provides a DSL for building LINE messages.
    module Builder
      class Error < StandardError; end
      class RequiredError < Error; end
      class ValidationError < Error; end

      require_relative "builder/base"
      require_relative "builder/validators"
      require_relative "builder/actions"
      require_relative "builder/quick_reply"
      require_relative "builder/container"
      require_relative "builder/text"
      require_relative "builder/flex"

      module_function

      def with(context = nil, &)
        Container.new(context: context, &)
      end
    end
  end
end
