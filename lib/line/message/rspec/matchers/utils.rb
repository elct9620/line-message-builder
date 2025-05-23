# frozen_string_literal: true

module Line
  module Message
    module RSpec
      module Matchers
        # The `Utils` module provides helper methods for the RSpec matchers
        # defined in the `Line::Message::RSpec::Matchers` namespace.
        # These utilities are primarily for internal use within the matchers
        # to process data before comparison.
        module Utils
          # Converts all keys in a given argument (typically a Hash or an Array of Hashes)
          # to strings. This is useful for standardizing message data before matching,
          # as LINE API responses and builder outputs might use a mix of symbol and string keys.
          #
          # @param arg [Object] The argument to process. Can be a Hash, Array, or any other type.
          #   If it's a Hash, its keys are stringified. If it's an Array, `stringify_keys!` is
          #   applied to each element if `deep` is true. Other types are returned as is.
          # @param deep [Boolean] If `true`, performs a deep stringification, meaning it
          #   will recursively stringify keys in nested Hashes and process elements of nested Arrays.
          #   If `false` (default), only the top-level keys of a Hash are stringified, or top-level
          #   elements of an Array are processed (if they are Hashes and `deep` was true at a higher level).
          #
          # @return [Object] The processed argument with keys stringified as specified.
          #
          # @example Basic usage with a Hash
          #   Line::Message::RSpec::Matchers::Utils.stringify_keys!({ name: "Test", type: "flex" })
          #   # => { "name" => "Test", "type" => "flex" }
          #
          # @example Deep stringification
          #   data = {
          #     user: { id: 123, profile: { name: "User" } },
          #     items: [{ item_id: "A", price: 100 }, { item_id: "B", options: { color: :red } }]
          #   }
          #   Line::Message::RSpec::Matchers::Utils.stringify_keys!(data, deep: true)
          #   # => {
          #   #      "user" => { "id" => 123, "profile" => { "name" => "User" } },
          #   #      "items" => [{ "item_id" => "A", "price" => 100 }, { "item_id" => "B", "options" => { "color" => :red } }]
          #   #    }
          #   # Note: In the items array, the value of "options" (which is a Hash) also has its key "color" stringified.
          #
          # @note The method name includes a bang (`!`) which often implies modification in place,
          #   but this implementation returns a new Hash/Array and does not modify the original `arg` directly.
          #   This is a common convention in some Ruby projects for "destructive" or transformative operations,
          #   even if they return new objects.
          def self.stringify_keys!(arg, deep: false) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
            case arg
            when Hash
              # For Hashes: iterate through key-value pairs.
              # Convert the key to a string.
              # If 'deep' is true, recursively call stringify_keys! on the value.
              # Otherwise, use the value as is.
              # `inject` is used here to build the new hash. `memo + pair` concatenates arrays of [key, value].
              Hash[
                *arg.map { |key, value| [key.to_s, deep ? stringify_keys!(value, deep: deep) : value] }
                    .inject([]) { |memo, pair| memo + pair } # Correctly builds [k1, v1, k2, v2, ...] for Hash[]
              ]
            when Array
              # For Arrays: if 'deep' is true, map each item through stringify_keys! recursively.
              # Otherwise, return the array as is (or rather, its elements are processed if they were hashes
              # from a higher-level call where deep was true).
              # If `deep` is false at this level, array elements other than Hashes are untouched.
              arg.map { |item| deep ? stringify_keys!(item, deep: deep) : item }
            else
              # For any other type, return the argument itself.
              arg
            end
          end
        end
      end
    end
  end
end
