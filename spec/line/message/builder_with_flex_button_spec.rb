# frozen_string_literal: true

RSpec.describe Line::Message::Builder do
  subject(:build) { builder.build }

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

  it { is_expected.to have_line_flex_message(/Simple Flex Message/) }
  it { is_expected.to have_line_flex_button("postback", data: "action=submit", label: "Submit") }

  context "when no action is defined" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            footer do
              button
            end
          end
        end
      end
    end

    it { expect { build }.to raise_error(Line::Message::Builder::RequiredError, /action is required/) }
  end

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

  context "with button margin" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            footer do
              button margin: :lg do
                postback "action=submit", label: "Submit"
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_button("postback", margin: :lg) }
  end

  context "with button flex" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            footer do
              button flex: 2 do
                postback "action=submit", label: "Submit"
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_button("postback", flex: 2) }
  end
end
