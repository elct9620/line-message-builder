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

  context "with invalid button margin" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            footer do
              button margin: :invalid do
                postback "action=submit", label: "Submit"
              end
            end
          end
        end
      end
    end

    it { expect { build }.to raise_error(Line::Message::Builder::ValidationError, /Invalid value: invalid/) }
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

  context "with button padding" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            footer do
              button padding: :md do
                postback "action=submit", label: "Submit"
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_button("postback", paddingAll: :md) }
  end

  context "with invalid button padding" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            footer do
              button padding: :invalid do
                postback "action=submit", label: "Submit"
              end
            end
          end
        end
      end
    end

    it { expect { build }.to raise_error(Line::Message::Builder::ValidationError, /Invalid value: invalid/) }
  end

  context "with button offset" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            footer do
              button position: :absolute do
                postback "action=submit", label: "Submit"
                offset_top "10px"
                offset_bottom "20px"
                offset_start "30px"
                offset_end "40px"
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_button("postback", position: :absolute) }
    it { is_expected.to have_line_flex_button("postback", offsetTop: "10px") }
    it { is_expected.to have_line_flex_button("postback", offsetBottom: "20px") }
    it { is_expected.to have_line_flex_button("postback", offsetStart: "30px") }
    it { is_expected.to have_line_flex_button("postback", offsetEnd: "40px") }
  end

  context "with invalid button offset" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            footer do
              button position: :invalid do
                postback "action=submit", label: "Submit"
              end
            end
          end
        end
      end
    end

    it { expect { build }.to raise_error(Line::Message::Builder::ValidationError, /Invalid value: invalid/) }
  end

  context "with button adjust mode" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            footer do
              button do
                postback "action=submit", label: "Submit"
                shrink_to_fit!
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_button("postback", adjustMode: :"shrink-to-fit") }
  end
end
