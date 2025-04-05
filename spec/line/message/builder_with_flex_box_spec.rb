# frozen_string_literal: true

RSpec.describe Line::Message::Builder do
  subject { builder.build }

  let(:builder) do
    described_class.with do
      flex alt_text: "Simple Flex Message" do
        bubble do
          header do
            text "Hello, world!"
            text "Long text can wrap", wrap: true
          end
        end
      end
    end
  end

  it { is_expected.to have_line_flex_message }
  it { is_expected.to have_line_flex_message(/Simple Flex Message/) }
  it { is_expected.to have_line_flex_text(/Hello, world!/) }
  it { is_expected.to have_line_flex_text(/Long text can wrap/) }
end
