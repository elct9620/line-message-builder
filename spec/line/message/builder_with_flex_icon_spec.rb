# frozen_string_literal: true

RSpec.describe Line::Message::Builder do
  subject(:build) { builder.build }

  let(:builder) do
    described_class.with do
      flex alt_text: "Review" do
        bubble do
          body do
            box layout: :baseline do
              icon "https://example.com/star.png"
              text "4.0"
            end
          end
        end
      end
    end
  end

  it { is_expected.to have_line_flex_icon("https://example.com/star.png") }

  context "with icon size" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Review" do
          bubble do
            body do
              box layout: :baseline do
                icon "https://example.com/star.png", size: :sm
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_icon("https://example.com/star.png", size: :sm) }
  end

  context "with icon aspect ratio" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Review" do
          bubble do
            body do
              box layout: :baseline do
                icon "https://example.com/star.png", aspect_ratio: "2:1"
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_icon("https://example.com/star.png", aspectRatio: "2:1") }
  end

  context "with icon scaling" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Review" do
          bubble do
            body do
              box layout: :baseline do
                icon "https://example.com/star.png", scaling: true
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_icon("https://example.com/star.png", scaling: true) }
  end

  context "with icon margin" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Review" do
          bubble do
            body do
              box layout: :baseline do
                icon "https://example.com/star.png", margin: :md
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_icon("https://example.com/star.png", margin: :md) }
  end

  context "without url" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Review" do
          bubble do
            body do
              box layout: :baseline do
                icon nil
              end
            end
          end
        end
      end
    end

    it { expect { build }.to raise_error(Line::Message::Builder::RequiredError, /url is required/) }
  end
end
