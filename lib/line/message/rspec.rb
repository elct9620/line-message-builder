# frozen_string_literal: true

# This file serves as the main entry point for RSpec matchers related to the
# `line-message` gem. When `require "line/message/rspec"` is used in a
# RSpec test suite, this file is loaded, and it, in turn, loads the
# necessary files to make the custom matchers available for testing
# `Line::Message::Builder` objects and their outputs.
#
# By requiring this file, developers gain access to specialized matchers
# designed to simplify the testing of message structures built with
# `line-message`.
#
# @example in `spec_helper.rb` or a specific test file
#   require "line/message/rspec"
#
# @see Line::Message::Rspec::Matchers
require "line/message/rspec/matchers"
