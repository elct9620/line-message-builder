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
end
