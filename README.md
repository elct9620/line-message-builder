# LINE Message Builder

[![.github/workflows/main.yml](https://github.com/elct9620/line-message-builder/actions/workflows/main.yml/badge.svg)](https://github.com/elct9620/line-message-builder/actions/workflows/main.yml)
[![codecov](https://codecov.io/gh/elct9620/line-message-builder/graph/badge.svg?token=9TJTSRIL0X)](https://codecov.io/gh/elct9620/line-message-builder)
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/elct9620/line-message-builder)
[![Documentation](https://img.shields.io/badge/docs-gh--pages-brightgreen)](https://elct9620.github.io/line-message-builder/)

Build LINE messages using DSL (Domain Specific Language) in Ruby.

## Features

- Build LINE messages using DSL
- Validation of properties
- RSpec matchers for testing
- LINE Bot SDK v2 support (Experimental)

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

### LLM.txt

The `llm.txt` is available in document assets.

You can get it from [http://aotoki.me/line-message-builder/llm.txt](http://aotoki.me/line-message-builder/llm.txt).

### Builder

```ruby
builder = Line::MessageBuilder::Builder.with do
  text "Hello, world!"
end

pp builder.build
# => [{ type: "text", text: "Hello, world!" }]

puts builder.to_json
# => "[{\"type\":\"text",\"text\":\"Hello, world!\"}"
```

To use with [line-bot-sdk-ruby](https://github.com/line/line-bot-sdk-ruby) v2, you can set mode to `sdkv2`:

```ruby
builder = Line::MessageBuilder::Builder.with(mode: :sdkv2) do
  text "Hello, world!"
end
```

### Context

The context can make `Builder` to access additional methods and variables.

```ruby
context = OpenStruct.new(
  name: "John Doe",
)

builder = Line::MessageBuilder::Builder.with(context) do
  text "Hello, #{name}!"
end

pp builder.build
# => [{ type: "text", text: "Hello, John Doe!" }]

puts builder.to_json
# => "[{\"type\":\"text\",\"text\":\"Hello, John Doe!\"}"
```

For Rails, you can use `view_context` to make `Builder` to access Rails helpers.

```ruby
# app/controllers/line_controller.rb
builder = Line::MessageBuilder::Builder.with(view_context) do
  text "Anything you want?" do
    quick_reply do
      message "Yes", label: "Yes", image_url: image_url("yes.png")
      message "No", label: "No", image_url: image_url("no.png")
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

builder = Line::MessageBuilder::Builder.with(context) do
  text "Anything you want?" do
    quick_reply do
      message "Yes", label: "Yes", image_url: image_url("yes.png")
      message "No", label: "No", image_url: image_url("no.png")
    end
  end
end
```

### Partial

> [!WARNING]
> This is experimental and may change in the future.

You can create a partial object to reuse the same structure in the `Carousel`, `Bubble`, or `Box`.

```ruby
# Reuse the bubble structure in the Carousel
class CardPartial < Line::Message::Builder::Flex::Partial
  def call
    body do
      text "Hello World!"
    end
  end
end

builder = Line::MessageBuilder::Builder.with do
  carousel do
    3.times do |i|
      bubble do
        partial! CardPartial
      end
    end
  end
end
```

The partial can have `assigns` feature to provide variables to the partial.

```ruby
class CardPartial < Line::Message::Builder::Flex::Partial
  def call
    body do
      text "Card #{idx}!"
    end
  end
end

builder = Line::MessageBuilder::Builder.with do
  carousel do
    3.times do |i|
      bubble do
        partial! CardPartial, idx: i
      end
    end
  end
end
```

> [!NOTE]
> The assigns will override the context variables.

### RSpec Matcher

| Matcher                     | Description                          |
| --------------------------- | ------------------------------------ |
| `have_line_text_message`    | Match a text message                 |
| `have_line_flex_message`    | Match a flex message                 |
| `have_line_flex_bubble`     | Match a flex message with bubble     |
| `have_line_flex_text`       | Match a flex message with text       |
| `have_line_flex_image`      | Match a flex message with image      |
| `have_line_flex_button`     | Match a flex message with button     |
| `have_line_flex_box`        | Match a flex message with box        |
| `have_line_flex_separator`  | Match a flex message with separator  |


Add `line/message/rspec` to your `spec_helper.rb` or `rails_helper.rb`:

```ruby
require "line/message/rspec"
```

Include `Line::Message::RSpec::Matchers` in your RSpec configuration:

```ruby
RSpec.configure do |config|
  config.include Line::Message::RSpec::Matchers
end
```

Then the matchers are available in your specs:

```ruby
let(:builder) do
  Line::MessageBuilder::Builder.with do
    text "Hello, world!"
    text "Nice to meet you!"
  end
end

subject { builder.build }

it { is_expected.to have_line_text_message("Hello, world!") }
it { is_expected.to have_line_text_message(/Nice to meet you!/) }
```

The matchers can work with webmock `a_request`:

```ruby
it "reply with message" do
  expect(a_request(:post, "https://api.line.me/v2/bot/message/reply")
    .with(
      body: hash_including({
        messages: have_line_text_message(/Hello, world!/),
      })
    )
  ).to have_been_made.once
end
```

## Capabilities

- ✅ Supported
- 🚧 Partially Supported
- ❌ Not Supported

### Message Types

| Type     | Supported |
| ----     | --------- |
| Text     | 🚧        |
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

### Common Properties

| Property    | Supported |
| --------    | --------- |
| Quick Reply | ✅        |
| Sender      | ❌        |

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

### Flex Components

| Component | Supported     |
| --------- | ---------     |
| Bubble    | 🚧            |
| Carousel  | ✅            |
| Box       | 🚧            |
| Button    | 🚧            |
| Image     | 🚧            |
| Video     | ❌            |
| Icon      | ❌            |
| Text      | 🚧            |
| Span      | ✅            |
| Separator | ✅            |
| Filler    | ❌ Deprecated |

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/elct9620/line-message-builder.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
