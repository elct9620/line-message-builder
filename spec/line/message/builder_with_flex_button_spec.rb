# frozen_string_literal: true

RSpec.describe Line::Message::Builder do
  subject { builder.build }

  let(:builder) do
    described_class.with do
      flex alt_text: "Simple Flex Message" do
        bubble do
          footer do
            button do
              postback "action=submit", label: "Submit"
            end
          end
        end
      end
    end
  end

  it { is_expected.to have_line_flex_message }
  it { is_expected.to have_line_flex_message(/Simple Flex Message/) }
  it { is_expected.to have_line_flex_button("postback") }
  it { is_expected.to have_line_flex_button("postback", data: "action=submit", label: "Submit") }

  context "with button style" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            footer do
              button style: :primary do
                postback "action=submit", label: "Submit"
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_button("postback", style: :primary) }
  end

  context "with button height" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            footer do
              button height: :sm do
                postback "action=submit", label: "Submit"
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_button("postback", height: :sm) }
  end
end
