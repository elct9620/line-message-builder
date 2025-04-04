# frozen_string_literal: true

RSpec::Matchers.define :have_line_text_message do |expected|
  match do |actual|
    actual.each do |message|
      next unless message[:type] == "text"

      return true if message[:text].match?(expected)
    end

    false
  end

  failure_message do |_actual|
    "expected to find a text message matching #{expected}"
  end
end
