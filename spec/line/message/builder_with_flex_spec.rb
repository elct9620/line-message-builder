# frozen_string_literal: true

RSpec.describe Line::Message::Builder do
  subject { builder.build }

  let(:builder) do
    described_class.with do
      flex alt_text: "Simple Flex Message" do
        bubble
      end
    end
  end

  it { is_expected.to have_line_flex_message }
  it { is_expected.to have_line_flex_message(/Simple Flex Message/) }

  describe "#to_json" do
    subject { builder.to_json }

    it { is_expected.not_to include("nil") }
  end
end
