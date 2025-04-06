# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Validators
        # Validate values against a set of allowed values.
        class Enum
          attr_reader :allowed_values

          def initialize(*allowed_values)
            @allowed_values = allowed_values
          end

          def valid!(value)
            return if allowed_values.include?(value.to_sym)

            raise ValidationError, "Invalid value: #{value}. Allowed values are: #{allowed_values.join(", ")}"
          end
        end
      end
    end
  end
end
