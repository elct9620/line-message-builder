# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Validators
        # Validate size values for LINE messages.
        class Size
          def valid?(value)
            value.end_with?("px")
          end

          def valid!(value)
            return if valid?(value)

            raise ValidationError,
                  "Invalid value: #{value}. Expected a pixel value (e.g., '100px')"
          end
        end

        # Validate size values with keywords.
        class KeywordSize < Size
          KEYWORDS = %i[none xs sm md lg xl xxl].freeze

          def valid?(value)
            KEYWORDS.include?(value.to_sym) || super
          end

          def valid!(value)
            return if valid?(value)

            raise ValidationError,
                  "Invalid value: #{value}. Allowed values are: #{KEYWORDS.join(", ")}, " \
                  "a pixel value (e.g., '100px')"
          end
        end

        # Validate size values with percentage.
        class PercentageSize < KeywordSize
          def valid?(value)
            value.end_with?("%") || super
          end

          def valid!(value)
            return if valid?(value)

            raise ValidationError,
                  "Invalid value: #{value}. Allowed values are: #{KEYWORDS.join(", ")}, " \
                  "a pixel value (e.g., '100px'), or a percentage (e.g., '50%')"
          end
        end
      end
    end
  end
end
