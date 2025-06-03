# frozen_string_literal: true

module Line
  module Message
    module RSpec
      # :nodoc:
      module Matchers
        def have_line_flex_separator(**options) # rubocop:disable Naming/PredicateName
          options = Utils.stringify_keys!(options, deep: true)

          HaveFlexComponent.new(expected_desc: "separator(#{options.inspect})") do |content|
            next false unless content["type"] == "separator"

            options.empty? || ::RSpec::Matchers::BuiltIn::Include.new(options).matches?(content)
          end
        end
      end
    end
  end
end
