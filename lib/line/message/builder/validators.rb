# frozen_string_literal: true

module Line
  module Message
    module Builder
      # The `Validators` module serves as a namespace for various validator classes
      # used within the `Line::Message::Builder` ecosystem. These validators ensure
      # that options and attributes for message components conform to the expected
      # formats and value ranges defined by the LINE Messaging API.
      #
      # For example, when an option is defined in a builder class (like {Flex::Box}),
      # a validator can be associated with it to check any value provided for that option.
      #
      # @example Using a validator in an option definition
      #   ```ruby
      #   # In some builder class inheriting from Line::Message::Builder::Base
      #   option :layout,
      #          default: :horizontal,
      #          validator: Line::Message::Builder::Validators::Enum.new(:horizontal, :vertical, :baseline)
      #   ```
      #
      # @see Validators::Enum
      # @see Validators::Size
      module Validators
        require_relative "validators/enum"
        require_relative "validators/size"
        # Other validators like RangeValidator, RegexValidator, etc., could be added here.
      end
    end
  end
end
