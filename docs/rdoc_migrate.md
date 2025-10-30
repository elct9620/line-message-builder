# YARD to RDoc Migration Checklist

This document tracks the migration progress from YARD to RDoc documentation syntax and provides detailed migration guidance for each file.

## Migration Status

**Total Files**: 22
**Completed**: 0
**In Progress**: 0
**Pending**: 22

## Table of Contents

1. [File Checklist](#file-checklist)
2. [General Migration Guide](#general-migration-guide)
3. [Common Migration Patterns](#common-migration-patterns)
4. [Quality Standards](#quality-standards)
5. [Validation Steps](#validation-steps)

---

## File Checklist

### Phase 1: Core Entry Points (5 files)

- [ ] `lib/line/message/builder.rb` - Main entry point
- [ ] `lib/line/message/builder/container.rb` - Message container
- [ ] `lib/line/message/builder/text.rb` - Text messages
- [ ] `lib/line/message/builder/flex/builder.rb` - Flex messages entry
- [ ] `lib/line/message/builder/flex/bubble.rb` - Bubble containers

### Phase 2: Flex Components (5 files)

- [ ] `lib/line/message/builder/flex/box.rb` - Box layouts
- [ ] `lib/line/message/builder/flex/text.rb` - Flex text components
- [ ] `lib/line/message/builder/flex/button.rb` - Button components
- [ ] `lib/line/message/builder/flex/image.rb` - Image components
- [ ] `lib/line/message/builder/quick_reply.rb` - Quick replies

### Phase 3: Foundation & Context (5 files)

- [ ] `lib/line/message/builder/base.rb` - Foundation (complex DSL)
- [ ] `lib/line/message/builder/context.rb` - Context handling
- [ ] `lib/line/message/builder/flex/carousel.rb` - Carousels
- [ ] `lib/line/message/builder/flex/span.rb` - Text spans
- [ ] `lib/line/message/builder/flex/separator.rb` - Separators

### Phase 4: Actions & Partials (5 files)

- [ ] `lib/line/message/builder/flex/partial.rb` - Partial system
- [ ] `lib/line/message/builder/actions/message.rb` - Message actions
- [ ] `lib/line/message/builder/actions/postback.rb` - Postback actions
- [ ] `lib/line/message/builder/flex/actionable.rb` - Mixin module
- [ ] `lib/line/message/builder/flex/position.rb` - Position modules

### Phase 5: Size Modules & Namespace (2 files)

- [ ] `lib/line/message/builder/flex/size.rb` - Size modules
- [ ] `lib/line/message/builder/flex.rb` - Namespace docs

---

## General Migration Guide

### Overview

This guide applies to all Ruby files being migrated from YARD to RDoc. Follow these steps for each file.

### Step 1: Understand the File Structure

Before making changes:

1. Read through the entire file
2. Identify documentation patterns:
   - Class/Module documentation
   - `attr_reader`, `attr_accessor`, `attr_writer` declarations
   - Regular methods
   - Dynamic methods (created by `option` macro or `define_method`)
   - Private methods
3. Count how many of each pattern exists

### Step 2: Convert Class/Module Documentation

**Remove YARD-specific syntax:**
- Remove `{ClassName}` curly braces → use plain `ClassName`
- Remove backticks from class names
- Keep backticks only for inline code → convert to `+code+`

**Update examples:**
```ruby
# YARD - WRONG
# @example Creating a message
#   builder.text "Hello"

# RDoc - CORRECT
# == Example
#
#   builder.text "Hello"
```

**Update cross-references:**
```ruby
# YARD - WRONG
# @see Container
# @see https://example.com

# RDoc - CORRECT
# See Container for details.
#
# Reference: https://example.com
```

### Step 3: Convert Attribute Documentation

For `attr_reader`, `attr_accessor`, `attr_writer`:

```ruby
# YARD - WRONG
# @!attribute [r] context
#   @return [Context] The context object
attr_reader :context

# RDoc - CORRECT (Simple description only, no "returns")
# The context object used for delegation.
attr_reader :context
```

**Key points:**
- No special directives needed
- Just write a description above the attribute
- Do NOT add "Returns:" or "[return]" labels
- RDoc automatically documents the return type from the code

### Step 4: Convert Method Documentation

#### Regular Methods

```ruby
# YARD - WRONG
# @param name [String] The name
# @param age [Integer] The age
# @return [Person] A new person
def initialize(name, age)

# RDoc - CORRECT
# Creates a new person.
#
# [name]
#   The person's name
# [age]
#   The person's age (must be positive)
#
# Example:
#   person = Person.new("Alice", 30)
def initialize(name, age)
```

**Key points:**
- Use `[param_name]` label on its own line
- Description must be on the next line, indented with 2 spaces
- Each parameter documented separately
- No type annotations in brackets
- No `@return` - describe return in prose if needed

#### Methods with Yields

```ruby
# YARD - WRONG
# @yield [builder] Yields the builder
# @return [void]
def with(&block)

# RDoc - CORRECT
# Creates a builder and yields it to the block.
#
# :yields: builder
def with(&block)
```

**Key points:**
- Use `:yields:` directive on its own line
- No need for `@yield` or detailed yield documentation

### Step 5: Convert Dynamic Method Documentation

For methods created by `option` macro or `define_method`:

```ruby
# YARD - WRONG
# @!method size(value)
#   @param value [Symbol] The size
#   @return [Symbol] Current size
option :size, default: nil

# RDoc - CORRECT
# :method: size
# :call-seq:
#   size() -> Symbol or nil
#   size(value) -> Symbol
#
# Sets or gets the component size.
#
# [value]
#   The size to set (e.g. +:sm+, +:md+, +:lg+)
option :size, default: nil
```

**Key points:**
- Use `:method:` directive with method name
- Use `:call-seq:` to show both getter and setter forms
- Place directives in comment block BEFORE the `option` call
- Parameter description must be on new line with 2-space indent
- Show return types in call-seq (e.g., `-> Symbol or nil`)

### Step 6: Mark Private Methods

```ruby
# YARD - WRONG
# @!visibility private
def helper_method
end

# RDoc - CORRECT
def helper_method # :nodoc:
end
```

**Key points:**
- Add `# :nodoc:` at the end of the method definition line
- Remove any multi-line documentation for private methods
- Common candidates: `to_api`, `to_sdkv2`, `respond_to_missing?`, `method_missing`

### Step 7: Format Code References

**In prose:**
- Methods: `+method_name+` (e.g., `+initialize+`)
- Classes: Plain text `ClassName` (auto-links)
- Symbols: `+:symbol+` (e.g., `+:api+`)
- Strings: `+"string"+` or `<tt>"string"</tt>` for complex strings
- Complex code: `<tt>complex.code</tt>`

**Examples:**
```ruby
# The +initialize+ method creates a new Container instance.
# You can pass +:api+ or +:sdkv2+ as the mode.
# Use the +"GET"+ HTTP method for requests.
```

### Step 8: Add Examples

Every public method should have at least one example:

```ruby
# Creates a text message.
#
# [text]
#   The message content
#
# == Example
#
#   builder.text "Hello, world!"
def text(content)
```

**Key points:**
- Use `== Example` heading
- Blank line after heading
- Indent code 2 spaces
- For multiple examples: `=== Example: Description`
- Parameter labels must be on their own line with description indented

### Step 9: Validate and Test

After each file migration:

```bash
# Validate RDoc syntax
bundle exec rdoc lib/path/to/file.rb

# Run tests to ensure no regressions
bundle exec rspec
```

Review the terminal output for:
- Any RDoc warnings or errors
- Test failures
- Documentation coverage messages

---

## Common Migration Patterns

### Quick Reference Table

| YARD Syntax | RDoc Syntax | Notes |
|-------------|-------------|-------|
| `@param name [Type]` | `[name]` on own line + description | Label must be on own line, description indented 2 spaces |
| `@return [Type]` | Describe in prose | No `[return]` label needed usually |
| `@raise [Exception]` | Describe in prose | Can mention in method description |
| `@example Title` | `== Example` | Use heading with code indented 2 spaces |
| `@yield [args]` | `:yields: args` | Use directive on own line |
| `@see ClassName` | Plain `ClassName` | Just mention in prose |
| `@!method name(args)` | `:method:` + `:call-seq:` | For dynamic methods only |
| `@!attribute [r]` | Simple description | No directive, no "Returns:" label |
| `@!visibility private` | `# :nodoc:` | Append to def line |
| `{ClassName}` | `ClassName` | Remove braces for auto-linking |
| `` `code` `` | `+code+` or `<tt>code</tt>` | Use + for simple, <tt> for complex |

### Pattern 1: Attribute Documentation (attr_reader, attr_accessor)

**YARD:**
```ruby
# @!attribute [r] context
#   @return [Context] The context object
attr_reader :context
```

**RDoc (CORRECT):**
```ruby
# The context object used for delegation.
attr_reader :context
```

**Key rules:**
- No `:attr_reader:` directive needed
- No "Returns::" or "[return]" labels
- Just plain description
- RDoc infers the type automatically

### Pattern 2: Regular Method Documentation

**YARD:**
```ruby
# Initializes a new container.
# @param context [Object, nil] An optional context object
# @param mode [Symbol] The mode (:api or :sdkv2)
# @return [Container] The container instance
def initialize(context: nil, mode: :api)
```

**RDoc (CORRECT):**
```ruby
# Initializes a new container.
#
# [context]
#   An optional context object (default: +nil+)
# [mode]
#   The mode (+:api+ or +:sdkv2+, default: +:api+)
def initialize(context: nil, mode: :api)
```

**Key rules:**
- Use `[param_name]` label on its own line
- Description must be on next line, indented 2 spaces
- No type annotations in brackets
- Mention types in prose if needed
- Usually no need for explicit return documentation
- If return value is important, mention it in the description

### Pattern 3: Methods with Yields

**YARD:**
```ruby
# Builds messages with the given block.
# @yield [container] Yields the container
# @return [void]
def with(&block)
```

**RDoc (CORRECT):**
```ruby
# Builds messages with the given block.
#
# :yields: container
def with(&block)
```

**Key rules:**
- Use `:yields:` directive on its own line
- List yielded arguments after the colon
- No need for detailed yield documentation in most cases

### Pattern 4: Dynamic Method Documentation

**YARD:**
```ruby
# @!method size(value)
#   Sets or gets the size.
#   @param value [Symbol, nil] The size (:sm, :md, :lg)
#   @return [Symbol, nil] The current size
option :size, default: nil
```

**RDoc (CORRECT):**
```ruby
# :method: size
# :call-seq:
#   size() -> Symbol or nil
#   size(value) -> Symbol
#
# Sets or gets the component size.
#
# [value]
#   The size to set (e.g. +:sm+, +:md+, +:lg+)
option :size, default: nil
```

**Key rules:**
- Use `:method: method_name` directive
- Use `:call-seq:` to show signatures
- Show both getter and setter forms
- Place BEFORE the `option` call
- Parameter label on its own line, description indented 2 spaces
- Return type shown in call-seq, not in description

### Pattern 5: Example Documentation

**YARD:**
```ruby
# @example Creating a simple message
#   Line::Message::Builder.with do
#     text "Hello"
#   end
#
# @example With options
#   Line::Message::Builder.with(context) do
#     text "Hello"
#   end
```

**RDoc (CORRECT):**
```ruby
# == Example
#
#   Line::Message::Builder.with do
#     text "Hello"
#   end
#
# === Example: With options
#
#   Line::Message::Builder.with(context) do
#     text "Hello"
#   end
```

**Key rules:**
- Use `== Example` for single example
- Use `=== Example: Description` for multiple examples
- Blank line after heading
- Indent code 2 spaces

### Pattern 6: Cross-References

**YARD:**
```ruby
# @see Container
# @see {Flex::Builder}
# @see https://developers.line.biz/en/docs
```

**RDoc (CORRECT):**
```ruby
# See Container and Flex::Builder for more details.
#
# Reference: https://developers.line.biz/en/docs
```

**Key rules:**
- Mention class names directly in prose (they auto-link)
- No special syntax needed for class references
- URLs can be mentioned directly or use `{text}[url]` for clickable links

### Pattern 7: Private Methods

**YARD:**
```ruby
# @!visibility private
# Internal helper method.
def helper_method
end
```

**RDoc (CORRECT):**
```ruby
def helper_method # :nodoc:
end
```

**Key rules:**
- Add `# :nodoc:` at end of def line
- Remove all documentation for private methods
- Common candidates: `to_api`, `to_sdkv2`, `respond_to_missing?`, `method_missing`, `self.included`

---

## Migration Checklist per File

For each file, verify:

- [ ] All `@param` converted to `[param_name]` with description on next line (indented 2 spaces)
- [ ] All `@return` removed or converted to prose
- [ ] All `@yield` converted to `:yields:` directive
- [ ] All `@example` converted to `== Example` headings
- [ ] All `@see` converted to prose references
- [ ] All `@!method` converted to `:method:` + `:call-seq:` (dynamic methods only)
- [ ] All `@!attribute` removed (use simple description only)
- [ ] All `@!visibility private` converted to `# :nodoc:`
- [ ] All `{ClassName}` curly braces removed
- [ ] All backticks converted to `+code+` or `<tt>code</tt>`
- [ ] All attr_reader/attr_accessor have simple descriptions only (no "Returns:" label)
- [ ] All dynamic methods have `:method:` and `:call-seq:`
- [ ] All private methods marked with `# :nodoc:`
- [ ] All public methods have examples
- [ ] Code examples properly indented (2 spaces)
- [ ] Parameter labels are on their own line, not inline with description

## Quality Standards (from docs/rubrics/rdoc.md)

- **Syntax Correctness**: No YARD `@` tags, proper RDoc directives
- **Return Types**: All public methods have `[return]` documentation
- **Examples**: All public methods have at least one example
- **Indentation**: Proper 2-space indentation for labeled content
- **Links**: Use `ClassName` for class references, `{text}[url]` for external links

## Validation Steps

After migrating each file:

1. **Syntax Validation**
   ```bash
   bundle exec rdoc lib/path/to/file.rb
   ```
   Check terminal output for:
   - RDoc warnings or errors
   - Undocumented methods warnings
   - Verify no YARD syntax remains

2. **Regression Testing**
   ```bash
   bundle exec rspec
   ```
   - Ensure all tests still pass
   - No functionality should be affected by documentation changes

3. **Quality Checklist** (per `docs/rubrics/rdoc.md`)
   - [ ] No YARD `@` tags remain
   - [ ] All parameter labels on own line with indented descriptions
   - [ ] All public methods have at least one example
   - [ ] Proper 2-space indentation for labeled content
   - [ ] Class references use plain text for auto-linking
   - [ ] No `:attr_reader:` or similar directives used
   - [ ] No "Returns:" labels for attr_reader
   - [ ] All private methods have `# :nodoc:`

4. **Update This File**
   - Mark the file as completed: `- [x]` in the checklist
   - Update the Migration Status counts at the top

---

## Detailed Migration Workflow

### Step-by-Step Process for Each File

1. **Read the file and current documentation**
   ```bash
   cat lib/path/to/file.rb
   ```

2. **Identify patterns** (refer to phase-specific "Key Migration Points" above)
   - Count dynamic methods (created by `option`)
   - List private methods needing `:nodoc:`
   - Note any missing documentation

3. **Make changes systematically**
   - Start with class/module documentation
   - Convert attributes
   - Convert each method
   - Update examples last

4. **Test immediately**
   ```bash
   bundle exec rdoc lib/path/to/file.rb && bundle exec rspec
   ```
   Review terminal output for warnings or errors

5. **Mark as complete** in this document

### Parallel Processing Strategy

Each phase can be done in parallel by multiple people:

**Phase 1: Core Entry Points** - 5 people work in parallel
- Person 1: `builder.rb`
- Person 2: `container.rb`
- Person 3: `text.rb`
- Person 4: `flex/builder.rb`
- Person 5: `flex/bubble.rb`

**Phase 2: Flex Components** - 5 people work in parallel
- Person 1: `flex/box.rb`
- Person 2: `flex/text.rb`
- Person 3: `flex/button.rb`
- Person 4: `flex/image.rb`
- Person 5: `quick_reply.rb`

**Phase 3: Foundation & Context** - 5 people work in parallel
- Person 1: `base.rb` (most complex, needs experienced person)
- Person 2: `context.rb`
- Person 3: `flex/carousel.rb`
- Person 4: `flex/span.rb`
- Person 5: `flex/separator.rb`

**Phase 4: Actions & Partials** - 5 people work in parallel
- Person 1: `flex/partial.rb`
- Person 2: `actions/message.rb`
- Person 3: `actions/postback.rb`
- Person 4: `flex/actionable.rb`
- Person 5: `flex/position.rb` (13 dynamic methods, needs patience)

**Phase 5: Size Modules & Namespace** - 2 people work in parallel
- Person 1: `flex/size.rb`
- Person 2: `flex.rb`

**Important Dependencies:**
- Phase 3 should ideally be done after Phase 1 and 2 (especially `base.rb` and `context.rb`)
- Other phases can be done in any order

### Estimated Time per File

- **Simple** (separator.rb, flex.rb): 15-30 minutes
- **Medium** (most files): 30-60 minutes
- **Complex** (base.rb, position.rb): 1-2 hours
- **Quick_reply.rb** (no existing docs): 45-60 minutes

**Total estimated**: 15-25 hours for all 22 files

---

## Troubleshooting

### Common Issues

**Issue**: RDoc generates warnings about undefined methods
- **Solution**: Ensure `:method:` directive matches the actual method name

**Issue**: Cross-references don't link
- **Solution**: Use plain class names without `{}` or special formatting

**Issue**: Code examples don't render correctly
- **Solution**: Check 2-space indentation and ensure blank line before code block

**Issue**: Labels don't associate with content
- **Solution**: Content must be indented exactly 2 spaces under `[label]`

**Issue**: Dynamic methods don't appear in docs
- **Solution**: Verify `:method:` and `:call-seq:` directives are before `option` call

### Getting Help

- **RDoc Reference**: https://ruby.github.io/rdoc/RDoc/MarkupReference.html
- **RDoc Rubric**: `docs/rubrics/rdoc.md`
- **Example File**: Check already-migrated files for patterns

---

## Progress Tracking

Update after each completed file:

**Total Files**: 22
**Completed**: 0
**In Progress**: 0
**Pending**: 22

Last updated: 2025-10-30
