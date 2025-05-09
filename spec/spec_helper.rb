# frozen_string_literal: true

require "simplecov"
require "simplecov-cobertura"

SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter if ENV["CI"]
SimpleCov.start

require "line/message/builder"
require "line/message/rspec"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.include Line::Message::RSpec::Matchers

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
