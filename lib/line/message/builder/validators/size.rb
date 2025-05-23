# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Validators
        # The `Size` validator checks if a given value conforms to one or more
        # allowed size formats used in LINE Flex Messages and other components.
        # These formats include pixel values (e.g., "10px"), predefined keywords
        # (e.g., :sm, :md), image-specific keywords (e.g., :full), and percentages (e.g., "50%").
        #
        # Example:
        #   ```ruby
        #   # Validator for general component sizes (pixel or keyword)
        #   general_size_validator = Line::Message::Builder::Validators::Size.new(:pixel, :keyword)
        #   general_size_validator.valid!("100px") # => true
        #   general_size_validator.valid!(:md)     # => true
        #   general_size_validator.valid!("50%")  # => false, raises ValidationError in valid!
        #
        #   # Validator for image component sizes
        #   image_size_validator = Line::Message::Builder::Validators::Size.new(:pixel, :image, :percentage)
        #   image_size_validator.valid!(:full)    # => true
        #   image_size_validator.valid!("75%")   # => true
        #   ```
        class Size
          # @!visibility private
          VARIANTS = %i[pixel keyword image percentage].freeze
          # @!visibility private
          # General keywords for component sizes (e.g., spacing, font size, margin).
          # `none` is often used for `spacing` or `margin`.
          KEYWORDS = %i[none xxs xs sm md lg xl xxl].freeze # Added xxs based on some component docs
          # @!visibility private
          # Keywords specific to image component sizes.
          IMAGE_KEYWORDS = %i[xxs xs sm md lg xl xxl xxxl xxxxL xxxxxL full].freeze # Corrected Ls, added more based on docs
          # @!visibility private
          PIXEL_REGEX = /^\d+px$/
          # @!visibility private
          # Corrected regex for percentage: should match digits followed by %
          PERCENTAGE_REGEX = /^\d+%$/

          # @!attribute [r] variants
          #   @return [Array<Symbol>] The allowed size format variants for this validator instance.
          attr_reader :variants

          # Initializes a new Size validator.
          #
          # @param accepted_variants [Array<Symbol>] A list of size format variants to accept.
          #   Must be a subset of {VARIANTS}. For example, `[:pixel, :keyword]`.
          def initialize(*accepted_variants)
            @variants = accepted_variants.map(&:to_sym) & VARIANTS
            raise ArgumentError, "At least one valid variant must be specified." if @variants.empty? && !accepted_variants.empty?
          end

          # Checks if the given value is valid according to any of the allowed variants
          # for this validator instance.
          #
          # @param value [Object] The value to validate (e.g., String, Symbol).
          # @return [Boolean] `true` if the value is valid, `false` otherwise.
          def valid?(value)
            # Allow nil to pass, as options usually handle their own defaults or presence.
            # If nil is explicitly invalid for a certain size, the component should check.
            return true if value.nil?

            @variants.any? do |variant|
              send(:"#{variant}?", value)
            end
          end

          # Checks if the value is a valid pixel size string (e.g., "10px").
          # @param value [Object] The value to check.
          # @return [Boolean] `true` if it's a valid pixel string.
          def pixel?(value)
            value.to_s.match?(PIXEL_REGEX)
          end

          # Checks if the value is a valid general size keyword (e.g., :md, :xs).
          # @param value [Object] The value to check.
          # @return [Boolean] `true` if it's a valid keyword.
          def keyword?(value)
            KEYWORDS.include?(value.to_sym)
          end

          # Checks if the value is a valid image-specific size keyword (e.g., :full, :xxl).
          # @param value [Object] The value to check.
          # @return [Boolean] `true` if it's a valid image keyword.
          def image?(value)
            IMAGE_KEYWORDS.include?(value.to_sym)
          end

          # Checks if the value is a valid percentage string (e.g., "50%").
          # @param value [Object] The value to check.
          # @return [Boolean] `true` if it's a valid percentage string.
          def percentage?(value)
            value.to_s.match?(PERCENTAGE_REGEX)
          end

          # Validates the given value. If invalid, raises a {ValidationError}.
          #
          # @param value [Object] The value to validate.
          # @raise [ValidationError] if the value does not conform to any of the allowed variants.
          # @return [void] Returns nothing if validation passes.
          def valid!(value)
            return if valid?(value)

            raise ValidationError,
                  "Invalid size value: `#{value}`. " \
                  "This property accepts formats: `#{@variants.join(", ")}`. " \
                  "Valid keywords: #{KEYWORDS.join(', ')}. " \
                  "Valid image keywords: #{IMAGE_KEYWORDS.join(', ')}. " \
                  "Pixel format: e.g., '10px'. Percentage format: e.g., '50%'."
          end
        end
      end
    end
  end
end
