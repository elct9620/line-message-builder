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

  context "with text wrap!" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                text "Nested box" do
                  wrap!
                end
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

  context "with text offset" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                text "Nested box", position: :absolute do
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
    end

    it { is_expected.to have_line_flex_text(/Nested box/, position: :absolute) }
    it { is_expected.to have_line_flex_text(/Nested box/, offsetTop: "10px") }
    it { is_expected.to have_line_flex_text(/Nested box/, offsetBottom: "20px") }
    it { is_expected.to have_line_flex_text(/Nested box/, offsetStart: "30px") }
    it { is_expected.to have_line_flex_text(/Nested box/, offsetEnd: "40px") }
  end

  context "with invalid text offset" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                text "Nested box", position: :invalid do
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
    end

    it { expect { build }.to raise_error(Line::Message::Builder::ValidationError, /Invalid value: invalid/) }
  end

  context "with text adjust mode" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                text "Nested box" do
                  shrink_to_fit!
                end
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_text(/Nested box/, adjustMode: :"shrink-to-fit") }
  end

  context "with text weight" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                text "Nested box", weight: :bold
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_text(/Nested box/, weight: :bold) }
  end

  context "with invalid text weight" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                text "Nested box", weight: :heavy
              end
            end
          end
        end
      end
    end

    it { expect { build }.to raise_error(Line::Message::Builder::ValidationError, /Invalid value: heavy/) }
  end

  context "with text max lines" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                text "Nested box", wrap: true, max_lines: 3
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_text(/Nested box/, maxLines: 3) }
  end

  context "with text style" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                text "Nested box", style: :italic
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_text(/Nested box/, style: :italic) }
  end

  context "with invalid text style" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                text "Nested box", style: :oblique
              end
            end
          end
        end
      end
    end

    it { expect { build }.to raise_error(Line::Message::Builder::ValidationError, /Invalid value: oblique/) }
  end

  context "with text decoration" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                text "Nested box", decoration: :underline
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_text(/Nested box/, decoration: :underline) }
  end

  context "with invalid text decoration" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                text "Nested box", decoration: :blink
              end
            end
          end
        end
      end
    end

    it { expect { build }.to raise_error(Line::Message::Builder::ValidationError, /Invalid value: blink/) }
  end

  context "with text scaling" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                text "Nested box", scaling: true
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_text(/Nested box/, scaling: true) }
  end

  context "without optional text styling" do
    it { is_expected.not_to have_line_flex_text(/Nested box/, weight: :bold) }
  end
end
