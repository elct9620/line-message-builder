# frozen_string_literal: true

RSpec.describe Line::Message::Builder::Text do
  subject(:text_builder) { described_class.new(message_text, context: context) }

  let(:message_text) { "Hello, world!" }
  let(:context) { nil }

  describe "#to_h" do
    subject { text_builder.to_h }

    it { is_expected.to be_a(Hash) }
    it { is_expected.to include(type: "text") }
    it { is_expected.to include(text: "Hello, world!") }
  end

  context "with context" do
    let(:context) do
      Class.new do
        def user_name
          "John Doe"
        end
      end.new
    end

    let(:message_text) { "Hello, #{user_name}!" }

    describe "#to_h" do
      subject { text_builder.to_h }

      it { is_expected.to include(text: "Hello, John Doe!") }
    end
  end
end
