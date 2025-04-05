# frozen_string_literal: true

module Line
  module Message
    module RSpec
      module Matchers
        # :nodoc:
        module Utils
          def self.stringify_keys!(arg, deep: false) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/MethodLength
            case arg
            when Hash
              Hash[
                *arg.map { |key, value| [key.to_s, deep ? stringify_keys!(value, deep: deep) : value] }
                    .inject([]) { |memo, pair| memo + pair }
              ]
            when Array
              arg.map { |item| deep ? stringify_keys!(item, deep: deep) : item }
            else
              arg
            end
          end
        end
      end
    end
  end
end
