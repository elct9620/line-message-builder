# frozen_string_literal: true

RSpec.describe Line::Message::Builder do
  subject(:build) { builder.build }

  let(:ctx) do
    Class.new do
      def hello_message
        "Partial box"
      end
    end.new
  end

  context "with partial inside carousel" do
    let(:partial) do
      Class.new(Line::Message::Builder::Flex::Partial) do
        def call(*)
          bubble do
            body do
              box do
                text "Partial box"
              end
            end
          end
        end
      end
    end

    let(:builder) do
      stub_const("PartialBox", partial)

      described_class.with(ctx) do
        flex alt_text: "Simple Flex Message" do
          carousel do
            partial! PartialBox
          end
        end
      end
    end

    it { is_expected.to have_line_flex_message(/Simple Flex Message/) }
    it { is_expected.to have_line_flex_text(/Partial box/) }
  end

  context "with partial inside bubble" do
    let(:partial) do
      Class.new(Line::Message::Builder::Flex::Partial) do
        def call(*)
          body do
            box do
              text "Partial box"
            end
          end
        end
      end
    end

    let(:builder) do
      stub_const("PartialBox", partial)

      described_class.with(ctx) do
        flex alt_text: "Simple Flex Message" do
          bubble do
            partial! PartialBox
          end
        end
      end
    end

    it { is_expected.to have_line_flex_message(/Simple Flex Message/) }
    it { is_expected.to have_line_flex_text(/Partial box/) }
  end

  context "with partial inside box" do
    let(:partial) do
      Class.new(Line::Message::Builder::Flex::Partial) do
        def call(*)
          box do
            text hello_message
          end
        end
      end
    end

    let(:builder) do
      stub_const("PartialBox", partial)

      described_class.with(ctx) do
        flex alt_text: "Simple Flex Message" do
          bubble do
            body do
              partial! PartialBox
            end
          end
        end
      end
    end

    it { is_expected.to have_line_flex_message(/Simple Flex Message/) }
    it { is_expected.to have_line_flex_text(/Partial box/) }
  end

  context "with partial inside bubble with assigns" do
    let(:partial) do
      Class.new(Line::Message::Builder::Flex::Partial) do
        def call(*)
          body do
            box do
              text hello_message
            end
          end
        end
      end
    end

    let(:builder) do
      stub_const("PartialBox", partial)

      described_class.with(ctx) do
        flex alt_text: "Simple Flex Message" do
          bubble do
            partial! PartialBox, hello_message: "Hello from assigns"
          end
        end
      end
    end

    it { is_expected.to have_line_flex_message(/Simple Flex Message/) }
    it { is_expected.to have_line_flex_text(/Hello from assigns/) }
  end
end
