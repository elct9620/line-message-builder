# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Ruby gem that provides a Domain Specific Language (DSL) for building LINE messaging API messages. The gem allows developers to construct complex Flex Messages, text messages, and quick replies using an intuitive Ruby syntax.

## Development Commands

### Testing
- `rake spec` or `bundle exec rspec` - Run all tests
- `bundle exec rspec spec/specific_file_spec.rb` - Run a specific test file
- `bundle exec rspec spec/specific_file_spec.rb:123` - Run test at specific line

### Code Quality
- `rake rubocop` or `bundle exec rubocop` - Run RuboCop linter
- `bundle exec rubocop --autocorrect` - Auto-fix RuboCop violations where possible
- `rake` - Run both tests and RuboCop (default task)

### Build and Release
- `bundle exec rake install` - Install gem locally
- `bundle exec rake build` - Build the gem
- `bundle exec rake release` - Release new version (creates git tag and pushes to RubyGems)

### Console
- `bin/console` - Interactive console with the gem loaded

## Architecture

### Core Components

**Main Builder (`lib/line/message/builder.rb`)**
- Entry point for the DSL using `Line::Message::Builder.with`
- Handles context binding and message collection
- Supports both regular mode and SDK v2 mode

**Base Classes**
- `Builder::Base` - Foundation for all builder components
- `Builder::Container` - Base for components that can contain other components
- `Builder::Context` - Manages variable access and method delegation

**Message Types**
- `Builder::Text` - Simple text messages with quick reply support
- `Builder::Flex` - Complex flex messages with rich layouts

**Flex Components (`lib/line/message/builder/flex/`)**
- `Bubble` - Main flex container
- `Carousel` - Collection of bubbles
- `Box` - Layout container (horizontal/vertical/baseline)
- `Text` - Text component with span support
- `Span` - Inline text styling within text components
- `Button` - Interactive buttons
- `Image` - Image components
- `Separator` - Visual separators

**Actions (`lib/line/message/builder/actions/`)**
- `Message` - Send text message action
- `Postback` - Send postback data action

**Quick Replies**
- `QuickReply` - Container for quick reply buttons

**Partials**
- `Flex::Partial` - Base class for reusable flex components

### Key Patterns

**DSL Design**: The gem uses Ruby's block evaluation (`instance_eval`) to create a clean DSL where methods like `text`, `box`, `button` are available directly within builder blocks.

**Context Handling**: The builder accepts a context object (like Rails' `view_context`) and delegates unknown methods to it, enabling access to helpers and variables.

**Validation**: Components validate their properties using the `validators/` classes to ensure LINE API compatibility.

**Testing Strategy**: Uses feature-style tests that build complete messages and verify their structure, rather than unit tests of individual methods.

## Coding Conventions

### DSL Usage
```ruby
# Preferred - clean DSL syntax
Line::Message::Builder.with do
  flex alt_text: "Hello" do
    bubble do
      body do
        text "Content"
      end
    end
  end
end

# Avoid - explicit block parameters
Line::Message::Builder.with do |builder|
  builder.flex alt_text: "Hello" do
    # ...
  end
end
```

### RSpec Testing
- Write feature tests using the full DSL as the test subject
- Use `subject { builder.build }` pattern
- Prefer `it { is_expected.to ... }` over `expect(subject)...`
- One assertion per example
- Test message structure, not implementation details

### Code Style
- Follow standard Ruby naming conventions (snake_case, CamelCase, UPPER_SNAKE_CASE)
- No explanatory comments - code should be self-documenting
- Use RDoc for API documentation only

## RSpec Matchers

The gem provides custom RSpec matchers for testing LINE messages:
- `have_line_text_message` - Match text messages
- `have_line_flex_message` - Match flex messages
- `have_line_flex_bubble` - Match flex bubbles
- `have_line_flex_component` - Match specific flex components

Include with: `require "line/message/rspec"`

## LLM Integration

The repository includes `llm.txt` with comprehensive DSL documentation for AI assistants. This file contains detailed examples and API references for all supported LINE message types and components.