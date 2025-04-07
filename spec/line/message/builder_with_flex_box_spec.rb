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

  it { is_expected.to have_line_flex_message(/Simple Flex Message/) }
  it { is_expected.to have_line_flex_text(/Nested box/) }

  context "with box layout" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box layout: :horizontal do
                text "Nested box"
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_box(layout: :horizontal) }
  end

  context "with invalid layout" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box layout: :invalid do
                text "Nested box"
              end
            end
          end
        end
      end
    end

    it { expect { build }.to raise_error(Line::Message::Builder::ValidationError, /Invalid value: invalid/) }
  end

  context "with flex option" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box flex: 2 do
                text "Nested box"
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_box(flex: 2) }
  end

  context "with spacing option" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box spacing: :sm do
                text "Nested box"
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_box(spacing: :sm) }
  end

  context "with invalid spacing option" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box spacing: :invalid do
                text "Nested box"
              end
            end
          end
        end
      end
    end

    it { expect { build }.to raise_error(Line::Message::Builder::ValidationError, /Invalid value: invalid/) }
  end

  context "with padding option" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box padding: "10px" do
                text "Nested box"
                padding_top "20px"
                padding_bottom "30px"
                padding_start "40px"
                padding_end "50px"
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_box(paddingAll: "10px") }
    it { is_expected.to have_line_flex_box(paddingTop: "20px") }
    it { is_expected.to have_line_flex_box(paddingBottom: "30px") }
    it { is_expected.to have_line_flex_box(paddingStart: "40px") }
    it { is_expected.to have_line_flex_box(paddingEnd: "50px") }
  end

  context "with invalid padding option" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box padding: "superBig" do
                text "Nested box"
              end
            end
          end
        end
      end
    end

    it { expect { build }.to raise_error(Line::Message::Builder::ValidationError, /Invalid value: superBig/) }
  end

  context "with justify_content option" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box justify_content: :flex_start do
                text "Nested box"
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_box(justifyContent: :flex_start) }
  end

  context "with invalid justify_content option" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box justify_content: :invalid do
                text "Nested box"
              end
            end
          end
        end
      end
    end

    it { expect { build }.to raise_error(Line::Message::Builder::ValidationError, /Invalid value: invalid/) }
  end

  context "with align_items option" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box align_items: :flex_start do
                text "Nested box"
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_box(alignItems: :flex_start) }
  end

  context "with invalid align_items option" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              box align_items: :invalid do
                text "Nested box"
              end
            end
          end
        end
      end
    end

    it { expect { build }.to raise_error(Line::Message::Builder::ValidationError, /Invalid value: invalid/) }
  end
end
