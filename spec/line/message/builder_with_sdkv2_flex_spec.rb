# frozen_string_literal: true

RSpec.describe Line::Message::Builder do
  subject(:build) { builder.build }

  describe "text properties" do
    let(:builder) do
      described_class.with(mode: :sdkv2) do
        flex alt_text: "SDK v2" do
          bubble do
            body do
              text "Heading", weight: :bold, max_lines: 3, style: :italic, decoration: :underline, scaling: true
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_text(/Heading/, max_lines: 3) }
    it { is_expected.to have_line_flex_text(/Heading/, weight: :bold) }
    it { is_expected.to have_line_flex_text(/Heading/, scaling: true) }
  end

  describe "box appearance" do
    let(:builder) do
      described_class.with(mode: :sdkv2) do
        flex alt_text: "SDK v2" do
          bubble do
            body do
              box background_color: "#F7F7F7", border_color: "#DDDDDD", border_width: :normal, corner_radius: :md do
                text "Card"
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_box(background_color: "#F7F7F7") }
    it { is_expected.to have_line_flex_box(border_color: "#DDDDDD") }
    it { is_expected.to have_line_flex_box(border_width: :normal) }
    it { is_expected.to have_line_flex_box(corner_radius: :md) }
  end

  describe "box gradient" do
    let(:builder) do
      described_class.with(mode: :sdkv2) do
        flex alt_text: "SDK v2" do
          bubble do
            body do
              box background_angle: "90deg",
                  background_start_color: "#FF0000",
                  background_end_color: "#0000FF",
                  background_center_color: "#00FF00",
                  background_center_position: "30%" do
                text "Card"
              end
            end
          end
        end
      end
    end

    let(:gradient) do
      {
        type: "linearGradient", angle: "90deg", start_color: "#FF0000",
        end_color: "#0000FF", center_color: "#00FF00", center_position: "30%"
      }
    end

    it { expect(build).to have_line_flex_box(background: gradient) }
  end

  describe "button properties" do
    let(:builder) do
      described_class.with(mode: :sdkv2) do
        flex alt_text: "SDK v2" do
          bubble do
            footer do
              button color: "#1DB446", scaling: true do
                postback "action=submit", label: "Submit", display_text: "Submitted"
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_button("postback", color: "#1DB446") }
    it { is_expected.to have_line_flex_button("postback", scaling: true) }
    it { is_expected.to have_line_flex_button("postback", display_text: "Submitted") }
  end

  describe "image properties" do
    let(:builder) do
      described_class.with(mode: :sdkv2) do
        flex alt_text: "SDK v2" do
          bubble do
            body do
              box do
                image "https://example.com/image.png", background_color: "#FFFFFF", animated: true
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_image("https://example.com/image.png", background_color: "#FFFFFF") }
    it { is_expected.to have_line_flex_image("https://example.com/image.png", animated: true) }
  end

  describe "icon component" do
    let(:builder) do
      described_class.with(mode: :sdkv2) do
        flex alt_text: "SDK v2" do
          bubble do
            body do
              box layout: :baseline do
                icon "https://example.com/star.png", aspect_ratio: "2:1", scaling: true
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_icon("https://example.com/star.png", aspect_ratio: "2:1") }
    it { is_expected.to have_line_flex_icon("https://example.com/star.png", scaling: true) }
  end

  describe "separator properties" do
    let(:builder) do
      described_class.with(mode: :sdkv2) do
        flex alt_text: "SDK v2" do
          bubble do
            body do
              text "Above"
              separator margin: :xl, color: "#F0F0F0"
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_separator(margin: :xl, color: "#F0F0F0") }
  end

  describe "span properties" do
    let(:builder) do
      described_class.with(mode: :sdkv2) do
        flex alt_text: "SDK v2" do
          bubble do
            body do
              text do
                span "Emphasised", style: :italic
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_span(/Emphasised/, style: :italic) }
  end

  describe "uri action" do
    let(:builder) do
      described_class.with(mode: :sdkv2) do
        flex alt_text: "SDK v2" do
          bubble do
            footer do
              button do
                uri "https://example.com/mobile", label: "Open", alt_uri_desktop: "https://example.com/desktop"
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_button("uri", uri: "https://example.com/mobile") }
    it { is_expected.to have_line_flex_button("uri", alt_uri: { desktop: "https://example.com/desktop" }) }
  end
end
