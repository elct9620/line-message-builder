# frozen_string_literal: true

RSpec.describe Line::Message::Builder do
  subject(:build) { builder.build }

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

  context "with image margin" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                image "https://example.com/image.jpg", margin: :lg
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_image("https://example.com/image.jpg", margin: :lg) }
  end

  context "with invalid image margin" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                image "https://example.com/image.jpg", margin: :invalid
              end
            end
          end
        end
      end
    end

    it { expect { build }.to raise_error(Line::Message::Builder::ValidationError, /Invalid value: invalid/) }
  end

  context "with image align" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                image "https://example.com/image.jpg", align: :start
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_image("https://example.com/image.jpg", align: :start) }
  end

  context "with image flex" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                image "https://example.com/image.jpg", flex: 2
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_image("https://example.com/image.jpg", flex: 2) }
  end

  context "with image offset" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                image "https://example.com/image.jpg", position: :absolute do
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

    it { is_expected.to have_line_flex_image("https://example.com/image.jpg", position: :absolute) }
    it { is_expected.to have_line_flex_image("https://example.com/image.jpg", offsetTop: "10px") }
    it { is_expected.to have_line_flex_image("https://example.com/image.jpg", offsetBottom: "20px") }
    it { is_expected.to have_line_flex_image("https://example.com/image.jpg", offsetStart: "30px") }
    it { is_expected.to have_line_flex_image("https://example.com/image.jpg", offsetEnd: "40px") }
  end

  context "with invalid image offset" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                image "https://example.com/image.jpg", position: :invalid do
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
end
