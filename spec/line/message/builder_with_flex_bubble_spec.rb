# frozen_string_literal: true

RSpec.describe Line::Message::Builder do
  subject { builder.build }

  let(:builder) do
    described_class.with do
      flex alt_text: "Simple Flex Message"
    end
  end

  it { is_expected.to have_line_flex_message }
  it { is_expected.to have_line_flex_message(/Simple Flex Message/) }

  context "with hero image" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            hero_image "https://example.com/image.jpg"
          end
        end
      end
    end

    it { is_expected.to have_line_flex_message }
    it { is_expected.to have_line_flex_image("https://example.com/image.jpg") }
  end
end
