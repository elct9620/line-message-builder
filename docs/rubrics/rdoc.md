# RDoc Rubric

This document outlines the criteria for evaluating the quality of gem's documantion. We assert at least 80% of the criteria must be met to pass.

## Criteria

Following are the criteria used to evaluate the gem's documentation.

### Syntax Correctness (1 points)

We enforce use RDoc syntax not YARD syntax, do not use `@` tags which are not supported in RDoc.

```ruby
##
# Line::Message::Builder is a DSL to build LINE message objects.
#
# For more details, see the {GitHub Repository}[https://github.com/elct9620/line-message-builder].
#
# == Example
#   builder = Line::Message::Builder.with do
#     text "Hello, world!"
#   end
#   pp builder.build
#   # => [{ type: "text", text: "Hello, world!" }]
```

- The RDoc have it's own syntax, check [ExampleRDoc](https://raw.githubusercontent.com/ruby/rdoc/refs/heads/master/ExampleRDoc.rdoc) if needed.
- Do not use YARD syntax such as `@param`, `@return`, etc.
- Consider heading, links is different in Markdown and RDoc.
`
### Return Types Documented (1 points)

To help users understand expected outputs, all public methods must have documented return types.

```ruby
##
# The Line::Message::Builder.with method create a container as a DSL context.
#
# [params]
#   context: an optional context object to be used within the DSL block
#
# [return]
#   returns Line::Message::Container instance
```

- Each public method must have a `[return]` label describing the return type.
- The return type should use `Line::Message::Container` style to make RDoc link the class properly.

### Examples Provided (1 points)

To illustrate usage, each public method should include at least one example.

```ruby
##
# The Line::Message::Builder.with method create a container as a DSL context.
#
# == Example
#
#   builder = Line::Message::Builder.with do
#     text "Hello, world!"
#   end
#   pp builder.build
#   # => [{ type: "text", text: "Hello, world!" }]
```

- Consider the code block indentation in RDoc.
- Each public method must have at least one example demonstrating its usage.

## Scoring

Each criteria only get the point when it is fully satisfied, otherwise get 0 point.
