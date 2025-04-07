# frozen_string_literal: true

RSpec.describe Line::Message::Builder do
  subject(:build) { builder.build }

  let(:builder) do
    described_class.with do
      flex alt_text: "Simple Flex Message" do
        bubble do
          body do
            box do
              text "Nested box"
            end
          end
        end
      end
    end
  end

  it { is_expected.to have_line_flex_text(/Nested box/) }

  context "with text size" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                text "Nested box", size: :lg
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_text(/Nested box/, size: :lg) }
  end

  context "with text color" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                text "Nested box", color: "#FF0000"
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_text(/Nested box/, color: "#FF0000") }
  end

  context "with text line spacing" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                text "Nested box", line_spacing: "10px"
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_text(/Nested box/, lineSpacing: "10px") }
  end

  context "with text alignment" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                text "Nested box", align: :center
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_text(/Nested box/, align: :center) }
  end

  context "with invalid text alignment" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                text "Nested box", align: :invalid
              end
            end
          end
        end
      end
    end

    it { expect { build }.to raise_error(Line::Message::Builder::ValidationError, /Invalid value: invalid/) }
  end

  context "with text flex" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                text "Nested box", flex: 2
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_text(/Nested box/, flex: 2) }
  end

  context "with text wrap" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                text "Nested box", wrap: true
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_text(/Nested box/, wrap: true) }
  end

  context "with text margin" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                text "Nested box", margin: :lg
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_text(/Nested box/, margin: :lg) }
  end

  context "with invalid text margin" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                text "Nested box", margin: :invalid
              end
            end
          end
        end
      end
    end

    it { expect { build }.to raise_error(Line::Message::Builder::ValidationError, /Invalid value: invalid/) }
  end
end
