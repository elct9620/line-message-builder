# Coding Guideline

These are coding guidelines that should be followed when writing code for this gem.

## Introduction

This gem is designed to provide DSL (Domain Specific Language) for building LINE messaging API reply messages.

## Naming Conventions

- Use `snake_case` for method names and variable names.
- Use `CamelCase` for class names.
- Use `UPPER_SNAKE_CASE` for constants.

## Comments

Only use comments for RDoc documentation. Do not use comments to explain anything in the code. The code should be self-explanatory. If you find yourself needing to write a comment to explain something, consider refactoring the code instead.

## RSpec

- Each example should only have one assertion.
- Prefer `it { is_expected.to ... }` over `expect(...)` syntax.
- Use `subject` to define the object under test.

```ruby
describe "#build" do
  subject { builder.build }
end
```

- Name subject if needed.

```ruby
subject(:builder) { described_class.new }

describe "#build" do
  subject { builder.build }

  it { is_expected.to be_a Array }
end
```
