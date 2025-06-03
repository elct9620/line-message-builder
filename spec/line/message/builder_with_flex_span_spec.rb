# frozen_string_literal: true

RSpec.describe Line::Message::Builder do
  subject(:build) { builder.build }

  let(:builder) do
    described_class.with do
      flex alt_text: "Simple Flex Message" do
        bubble do
          body do
            text "This contains a span:" do
              span "Hello, World!"
            end
          end
        end
      end
    end
  end

  it { is_expected.to have_line_flex_span(/Hello, World!/) }

  context "with span color" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              text "This contains a span:" do
                span "Hello, World!", color: "#FF0000"
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_span(/Hello, World!/, color: "#FF0000") }
  end

  context "with span size" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              text "This contains a span:" do
                span "Hello, World!", size: :lg
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_span(/Hello, World!/, size: :lg) }
  end

  context "with span weight" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              text "This contains a span:" do
                span "Hello, World!", weight: :bold
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_span(/Hello, World!/, weight: :bold) }
  end

  context "with bold! helper" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              text "This contains a span:" do
                span "Hello, World!" do
                  bold!
                end
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_span(/Hello, World!/, weight: :bold) }
  end

  context "with span decoration" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              text "This contains a span:" do
                span "Hello, World!", decoration: :underline
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_span(/Hello, World!/, decoration: :underline) }
  end

  context "with underline! helper" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              text "This contains a span:" do
                span "Hello, World!" do
                  underline!
                end
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_span(/Hello, World!/, decoration: :underline) }
  end

  context "with line_through! helper" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              text "This contains a span:" do
                span "Hello, World!" do
                  line_through!
                end
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_span(/Hello, World!/, decoration: :"line-through") }
  end

  context "with invalid span decoration" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              text "This contains a span:" do
                span "Hello, World!", decoration: :invalid
              end
            end
          end
        end
      end
    end

    it { expect { build }.to raise_error(Line::Message::Builder::ValidationError, /Invalid value: invalid/) }
  end

  context "with invalid span weight" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              text "This contains a span:" do
                span "Hello, World!", weight: :invalid
              end
            end
          end
        end
      end
    end

    it { expect { build }.to raise_error(Line::Message::Builder::ValidationError, /Invalid value: invalid/) }
  end

  context "with multiple spans" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              text "This contains spans:" do
                span "Hello, ", color: "#FF0000"
                span "World", weight: :bold
                span "!", decoration: :underline
              end
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_span(/Hello, /, color: "#FF0000") }
    it { is_expected.to have_line_flex_span(/World/, weight: :bold) }
    it { is_expected.to have_line_flex_span(/!/, decoration: :underline) }
  end

  context "without text content" do
    let(:builder) do
      described_class.with do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              text "This contains a span:" do
                span nil
              end
            end
          end
        end
      end
    end

    it { expect { build }.to raise_error(Line::Message::Builder::RequiredError, /text content is required/) }
  end
end
