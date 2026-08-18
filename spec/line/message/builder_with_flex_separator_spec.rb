# frozen_string_literal: true

RSpec.describe Line::Message::Builder do
  subject(:build) { builder.build }

  let(:builder) do
    described_class.with do
      flex alt_text: "Separator Example" do
        bubble do
          body do
            text "Section 1"
            separator
            text "Section 2"
          end
        end
      end
    end
  end

  it { is_expected.to have_line_flex_separator }

  context "with separator in nested box" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Separator in Box" do
          bubble do
            body do
              box do
                text "Above separator"
                separator
                text "Below separator"
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_separator }
  end

  context "with separator in different containers" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Separator in Containers" do
          bubble do
            header do
              text "Header"
              separator
            end
            body do
              text "Body content"
            end
            footer do
              separator
              text "Footer"
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_separator }
  end

  context "with separator margin" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Separator Example" do
          bubble do
            body do
              text "Section 1"
              separator margin: :xl
              text "Section 2"
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_separator(margin: :xl) }
  end

  context "with separator color" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Separator Example" do
          bubble do
            body do
              text "Section 1"
              separator color: "#F0F0F0"
              text "Section 2"
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_separator(color: "#F0F0F0") }
  end

  context "with invalid separator margin" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Separator Example" do
          bubble do
            body do
              text "Section 1"
              separator margin: :huge
              text "Section 2"
            end
          end
        end
      end
    end

    it { expect { build }.to raise_error(Line::Message::Builder::ValidationError, /Invalid value: huge/) }
  end

  context "without separator styling" do
    it { is_expected.not_to have_line_flex_separator(color: "#F0F0F0") }
  end
end
