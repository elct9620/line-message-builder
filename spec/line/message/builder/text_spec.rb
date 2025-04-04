# frozen_string_literal: true

RSpec.describe Line::Message::Builder::Text do
  subject(:text_builder) { described_class.new(message_text) }

  let(:message_text) { "Hello, world!" }

  describe "#to_h" do
    subject { text_builder.to_h }

    it { is_expected.to be_a(Hash) }
    it { is_expected.to include(type: "text") }
    it { is_expected.to include(text: "Hello, world!") }
  end
end
