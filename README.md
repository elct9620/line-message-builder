# LINE Message Builder

Build LINE messages using DSL (Domain Specific Language) in Ruby.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add line-message-builder
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install line-message-builder
```

## Usage

> [!NOTE]
> Working in progress.

### Builder

```ruby
builder = Line::MessageBuilder::Builder.new do
    text "Hello, world!"
end

pp builder.build
# => [{ type: "text", text: "Hello, world!" }]

puts builder.to_json
# => {"type":"text","text":"Hello, world!"}
```

### Context

The context can make `Builder` to access additional methods and variables.

```ruby
context = OpenStruct.new(
    name: "John Doe",
)

builder = Line::MessageBuilder::Builder.new(context) do
    text "Hello, #{name}!"
end

pp builder.build
# => [{ type: "text", text: "Hello, John Doe!" }]

puts builder.to_json
# => {"type":"text","text":"Hello, John Doe!"}
```

For Rails, you can use `view_context` to make `Builder` to access Rails helpers.

```ruby
# app/controllers/line_controller.rb
builder = Line::MessageBuilder::Builder.new(view_context) do
    text "Anything you want?" do
        quick_reply do
            action "Yes", label: "Yes", image_url: image_url("yes.png")
            action "No", label: "No", image_url: image_url("no.png")
        end
    end
end
```

If not in controller, you can create a `ActionView::Base` instance and pass it to `Builder`.

```ruby
# app/presenters/line_presenter.rb
context = ActionView::Base.new(
    ActionController::Base.view_paths,
    {},
    ActionController::Base.new,
)

builder = Line::MessageBuilder::Builder.new(context) do
    text "Anything you want?" do
        quick_reply do
            action "Yes", label: "Yes", image_url: image_url("yes.png")
            action "No", label: "No", image_url: image_url("no.png")
        end
    end
end
```

### RSpec Matcher

Add `line/message/rspec` to your `spec_helper.rb` or `rails_helper.rb`:

```ruby
require "line/message/rspec"
```

Then the matchers are available in your specs:

```ruby
let(:builder) do
    Line::MessageBuilder::Builder.new do
        text "Hello, world!"
        text "Nice to meet you!"
    end
end

subject { builder.build }

it { is_expected.to have_line_text_message("Hello, world!") }
it { is_expected.to have_line_text_message(/Nice to meet you!/) }
```

## Capabilities

### Message Types

| Type     | Supported |
| ----     | --------- |
| Text     | ✅        |
| Text v2  | ❌        |
| Sticker  | ❌        |
| Sticker  | ❌        |
| Image    | ❌        |
| Video    | ❌        |
| Audio    | ❌        |
| Location | ❌        |
| Imagemap | ❌        |
| Template | ❌        |
| Flex     | 🚧        |

### Actions

| Action Type     | Supported |
| -----------     | --------- |
| Postback        | 🚧        |
| Message         | ✅        |
| Uri             | ❌        |
| Datetime        | ❌        |
| Camera          | ❌        |
| CameraRoll      | ❌        |
| Location        | ❌        |
| Richmenu Switch | ❌        |
| Clipboard       | ❌        |

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/elct9620/line-message-builder.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
