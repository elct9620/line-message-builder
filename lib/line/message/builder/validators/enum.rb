# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Validators
        # The `Enum` validator checks if a given value is one of a predefined set of allowed symbols.
        # It is used to validate options that accept a fixed range of keyword-like values.
        #
        # Example:
        #   ```ruby
        #   # Validator for an option that must be :small, :medium, or :large
        #   size_validator = Line::Message::Builder::Validators::Enum.new(:small, :medium, :large)
        #
        #   size_validator.valid!(:medium) # => returns, no error
        #   size_validator.valid!(:other)  # => raises Line::Message::Builder::ValidationError
        #   ```
        class Enum
          # @!attribute [r] allowed_values
          #   @return [Array<Symbol>] The set of allowed symbol values.
          attr_reader :allowed_values

          # Initializes a new Enum validator.
          #
          # @param allowed_values [Array<Symbol>] A list of symbols that are considered valid.
          def initialize(*allowed_values)
            @allowed_values = allowed_values.map(&:to_sym) # Ensure all are symbols
          end

          # Validates the given value against the allowed set.
          # The value is converted to a symbol before comparison.
          #
          # @param value [Object] The value to validate. It will be converted to a symbol.
          # @raise [ValidationError] if the value (as a symbol) is not in the `allowed_values`.
          # @return [void] Returns nothing if validation passes.
          def valid!(value)
            # Allow nil to pass if :nil is not explicitly in allowed_values,
            # as options usually handle their own defaults or presence checks.
            # If nil should be explicitly disallowed or allowed, it should be part of `allowed_values`.
            return if value.nil? && !allowed_values.include?(:nil)
            return if allowed_values.include?(value.to_sym)

            raise ValidationError, "Invalid value: `#{value}`. Allowed values are: `#{allowed_values.map(&:inspect).join(", ")}`."
          end
        end
      end
    end
  end
end
