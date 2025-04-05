# frozen_string_literal: true

RSpec::Matchers.define :have_line_flex_message do |alt_text|
  match do |actual|
    actual.each do |message|
      next unless message[:type] == "flex"

      return true if alt_text.nil?
      return true if message[:altText] =~ alt_text
    end

    false
  end

  failure_message do |_actual|
    "expected to find a flex message matching #{alt_text}"
  end
end
