# frozen_string_literal: true

RSpec::Matchers.define :have_line_quick_reply do |expected|
  match do |actual|
    actual.each do |message|
      reply = message[:quickReply]
      next unless reply

      reply[:items].each do |item|
        action = item[:action]
        next unless action

        return true if expected.nil?
        return true if RSpec::Matchers::BuiltIn::Include.new(expected).matches?(action)
      end
    end

    false
  end

  failure_message do |_actual|
    "expected to find a quick reply message matching #{expected}"
  end
end
