# frozen_string_literal: true

RSpec.describe Line::Message::Builder do
  subject { builder.build }

  let(:builder) do
    described_class.with do
      flex alt_text: "Simple Flex Message" do
        bubble
      end
    end
  end

  it { is_expected.to have_line_flex_message }
  it { is_expected.to have_line_flex_message(/Simple Flex Message/) }

  context "with hero image" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            hero_image "https://example.com/image.jpg"
          end
        end
      end
    end

    it { is_expected.to have_line_flex_message }
    it { is_expected.to have_line_flex_image("https://example.com/image.jpg") }
  end

  context "with hero box" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            hero do
              box do
                text "Hero Box"
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_message }
    it { is_expected.to have_line_flex_text(/Hero Box/) }
  end

  context "with header" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            header do
              box do
                text "Header"
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_message }
    it { is_expected.to have_line_flex_text(/Header/) }
  end

  context "with body" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box do
                text "Body"
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_message }
    it { is_expected.to have_line_flex_text(/Body/) }
  end

  context "with footer" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            footer do
              box do
                text "Footer"
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_message }
    it { is_expected.to have_line_flex_text(/Footer/) }
  end

  context "with size option" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble size: :kilo do
            body do
              box do
                text "Body"
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_message }
    it { is_expected.to have_line_flex_bubble(size: :kilo) }
  end

  context "with styles option" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble styles: { header: { background_color: "#FFFFFF" } } do
            body do
              box do
                text "Body"
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_message }
    it { is_expected.to have_line_flex_bubble(styles: { header: { background_color: "#FFFFFF" } }) }
  end
end
