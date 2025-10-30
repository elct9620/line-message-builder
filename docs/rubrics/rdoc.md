# RDoc Documentation Rubric

This document outlines the criteria for evaluating the quality of RDoc documentation in Ruby code. We assert at least 80% of the criteria must be met to pass.

## Criteria

### Proper RDoc Syntax Usage (1 point)

> Enforce correct RDoc markup syntax and avoid YARD-style tags that are not compatible with RDoc

```ruby
##
# The Base class serves as the foundation for all message builder classes
# within the Line::Message::Builder DSL. It provides core functionality
# for defining options, handling initialization, and delegating method calls
# to a context object.
#
# == Example
#
#   class MyBuilder < Base
#     option :color, default: "red"
#   end
#
#   builder = MyBuilder.new
#   puts builder.color # => "red"
```

- Use RDoc directives: `:method:`, `:call-seq:`, `:nodoc:`, `:yields:` (not YARD `@param`, `@return`, `@see` tags)
- Use `==` for major sections (h2), `===` for subsections (h3)
- Use `[param_name]` for parameter documentation with 2-space indented descriptions
- Use `+code+` for method names and identifiers, `<code>:symbol</code>` for symbols and string literals
- Reference external documentation with links: `{Link Text}[URL]`
- Use `-` for unordered lists
- Consult [RDoc Markup Reference](https://ruby.github.io/rdoc/RDoc/MarkupReference.html) for details

### Complete Class and Module Documentation (1 point)

> Every public class and module must have comprehensive documentation including purpose, usage, and cross-references

```ruby
# The Text class provides a builder for creating simple text messages
# in the LINE Messaging API. Text messages are the most basic message type,
# consisting of plain text content with optional quick reply buttons and
# quote tokens for replying to specific messages.
#
# Text messages support:
# - Plain text content (up to 5,000 characters)
# - Quick reply buttons for user interaction
# - Quote tokens to reply to specific messages in a conversation
#
# == Example: Basic text message
#
#   Line::Message::Builder.with do
#     text "Hello, world!"
#   end
#
# See also:
# - QuickReply
# - https://developers.line.biz/en/reference/messaging-api/#text-message
class Text < Base
```

- Classes must have a purpose statement (what it represents/does)
- Include feature list using bullet points for complex components
- Provide at least one complete usage example with proper context
- Include "See also:" section with related classes and external API documentation links
- For mixin modules, document what functionality they add to including classes

### Method Documentation with Parameters and Returns (1 point)

> All public methods must document their purpose, parameters, and return values clearly

```ruby
# Defines a new option for the builder class.
#
# This method dynamically creates an instance method on the builder class
# with the given name. When this instance method is called without arguments,
# it returns the current value; with an argument, it sets the value.
#
# [name]
#   The name of the option to define. This will also be the name of the
#   generated instance method.
# [default]
#   The default value for the option if not explicitly set.
# [validator]
#   An optional validator object that must respond to +valid!+ method.
#   If the value is invalid, the validator should raise an error.
#
# [return]
#   The dynamically created method name as a symbol
#
# == Example
#
#   class MyBuilder < Base
#     option :color, default: "red"
#     option :size, validator: SizeValidator.new
#   end
def option(name, default: nil, validator: nil)
```

- Document method purpose in the first paragraph
- Use `[param_name]` format for each parameter with 2-space indented description
- Document optional parameters and their default values
- Include `[block]` documentation if the method accepts a block
- Use `[return]` label to describe return value for non-obvious returns
- Use `:nodoc:` directive for private methods and internal implementations

### Dynamic Method Documentation with :method: Directive (1 point)

> Dynamically defined methods must be documented using RDoc's :method: and :call-seq: directives

```ruby
# :method: quote_token
# :call-seq:
#   quote_token() -> String or nil
#   quote_token(value) -> String
#
# Sets or gets the quote token for replying to a specific message.
#
# Quote tokens allow your bot to quote and reply to a specific message
# in the conversation. When set, the original message being replied to
# will be displayed above the new message.
#
# [value]
#   The quote token string obtained from a webhook event
option :quote_token, default: nil
```

- Use `:method:` directive to document dynamically defined methods (e.g., from `option`, `attr_accessor`)
- Use `:call-seq:` to show both getter and setter signatures
- Show return types using arrow notation: `method_name() -> Type or nil`
- Document both forms: getter (no arguments) and setter (with argument)
- Place directive immediately before the line that defines the method
- Include parameter documentation using `[param_name]` format

### Progressive Examples with Real-World Usage (1 point)

> Documentation must include runnable examples that progress from simple to complex use cases

```ruby
# == Example: Basic text message
#
#   Line::Message::Builder.with do
#     text "Hello, world!"
#   end
#
# === Example: Text with quick reply
#
#   Line::Message::Builder.with do
#     text "Choose an option:" do
#       quick_reply do
#         button action: :message, label: "Yes", text: "I agree"
#         button action: :message, label: "No", text: "I disagree"
#       end
#     end
#   end
```

- Provide at least one complete, executable example for public classes
- Use descriptive example headings: `== Example: Description`
- Show full DSL context (e.g., `Line::Message::Builder.with do ... end`)
- Use `===` for sub-examples or variations
- Include output comments using `# =>` notation where helpful
- Progress from simple to complex examples
- Indent code blocks with 2 spaces

## Scoring

Each criterion is worth 1 point and is awarded only when fully satisfied. A score below 80% (4 out of 5 points) indicates insufficient documentation quality.
