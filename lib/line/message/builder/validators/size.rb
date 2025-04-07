# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Validators
        # Validate size values for LINE messages.
        class Size
          KEYWORDS = %i[none xs sm md lg xl xxl].freeze

          def valid?(value)
            is_keyword = KEYWORDS.include?(value.to_sym)
            is_pixels = value.end_with?("px")
            is_keyword || is_pixels
          end

          def valid!(value)
            return if valid?(value)

            raise ValidationError,
                  "Invalid value: #{value}. Allowed values are: #{KEYWORDS.join(", ")} or a pixel value (e.g., '100px')"
          end
        end

        # Validate size values with percentage.
        class PercentageSize < Size
          def valid!(value)
            is_percentage = value.end_with?("%")
            return if is_percentage || valid?(value)

            raise ValidationError,
                  "Invalid value: #{value}. Allowed values are: #{KEYWORDS.join(", ")}, " \
                  "a pixel value (e.g., '100px'), or a percentage (e.g., '50%')"
          end
        end
      end
    end
  end
end
