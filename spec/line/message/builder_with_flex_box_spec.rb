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
          body do
            box do
              text "Nested box"
            end
          end
        end
      end
    end
  end

  it { is_expected.to have_line_flex_message }
  it { is_expected.to have_line_flex_message(/Simple Flex Message/) }
  it { is_expected.to have_line_flex_text(/Hello, world!/) }
  it { is_expected.to have_line_flex_text(/Long text can wrap/) }
  it { is_expected.to have_line_flex_text(/Nested box/) }

  context "with box layout" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box layout: :horizontal do
                text "Nested box"
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_box(layout: :horizontal) }
  end
end
