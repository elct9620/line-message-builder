# frozen_string_literal: true

RSpec.describe Line::Message::Builder do
  subject { builder.build }

  let(:builder) do
    described_class.with do
      flex alt_text: "Simple Flex Message" do
        bubble do
          body do
            box do
              image "https://example.com/image.jpg"
            end
          end
        end
      end
    end
  end

  it { is_expected.to have_line_flex_image("https://example.com/image.jpg") }

  context "with image size" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                image "https://example.com/image.jpg", size: :full
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_image("https://example.com/image.jpg", size: :full) }
  end

  context "with image aspect ratio" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                image "https://example.com/image.jpg", aspect_ratio: "3:5"
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_image("https://example.com/image.jpg", aspectRatio: "3:5") }
  end

  context "with image aspect mode" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                image "https://example.com/image.jpg", aspect_mode: :cover
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_image("https://example.com/image.jpg", aspectMode: :cover) }
  end
end
