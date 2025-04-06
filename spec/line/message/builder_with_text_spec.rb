# frozen_string_literal: true

RSpec.describe Line::Message::Builder do
  subject { builder.build }

  let(:builder) do
    described_class.with do
      text "Hello, world!"
    end
  end

  it { is_expected.to have_line_text_message(/Hello, world!/) }

  context "with quote token" do
    let(:builder) do
      described_class.with do
        text "Hello, world!", quote_token: "quote_token"
      end
    end

    it { is_expected.to have_line_text_message(/Hello, world!/, quoteToken: "quote_token") }
  end
end
