# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Validators
        # Validate size values for LINE messages.
        class Size
          VARIANTS = %i[pixel keyword image percentage].freeze
          KEYWORDS = %i[none xs sm md lg xl xxl].freeze
          IMAGE_KEYWORDS = %i[xxs xs sm md lg xl xxl 3xl 4xl 5xl full].freeze
          PIXEL_REGEX = /^\d+px$/
          PERCENTAGE_REGEX = /^\f+%$/

          def initialize(*variants)
            @variants = variants & VARIANTS
          end

          def valid?(value)
            @variants.any? do |variant|
              send("#{variant}?", value)
            end
          end

          def pixel?(value)
            value.to_s.match?(PIXEL_REGEX)
          end

          def keyword?(value)
            KEYWORDS.include?(value.to_sym)
          end

          def image?(value)
            IMAGE_KEYWORDS.include?(value.to_sym)
          end

          def percentage?(value)
            value.to_s.match?(PERCENTAGE_REGEX)
          end

          def valid!(value)
            return if valid?(value)

            raise ValidationError,
                  "Invalid value: #{value}. " \
                  "Expected one of: #{VARIANTS.join(", ")}"
          end
        end
      end
    end
  end
end
