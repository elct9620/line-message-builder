# frozen_string_literal: true

RSpec.describe Line::Message::Builder do
  subject(:builder) do
    described_class.with do
      text "Hello, world!"
    end
  end

  it { is_expected.not_to be_sdkv2 }

  context "when using SDKv2 mode" do
    subject(:builder) do
      described_class.with(mode: :sdkv2) do
        text "Hello, SDKv2!"
      end
    end

    it { is_expected.to be_sdkv2 }
  end

  describe "VERSION" do
    subject { Line::Message::Builder::VERSION }

    it { is_expected.not_to be_nil }
  end

  describe "#build" do
    subject(:result) { builder.build }

    context "with a single text message" do
      it { is_expected.to be_an(Array) }
      it { is_expected.to have_attributes(size: 1) }

      it { is_expected.to have_line_text_message(/Hello, world!/) }
    end

    context "with multiple text messages" do
      let(:builder) do
        described_class.with do
          text "First message"
          text "Second message"
        end
      end

      it { is_expected.to be_an(Array) }
      it { is_expected.to have_attributes(size: 2) }

      it { is_expected.to have_line_text_message(/First message/) }
      it { is_expected.to have_line_text_message(/Second message/) }
    end

    context "with context" do
      let(:builder) do
        described_class.with(ctx) do
          text "#{greeting}, #{user_name}!"
        end
      end

      let(:ctx) do
        Class.new do
          def user_name
            "John Doe"
          end

          def greeting
            "Hello"
          end
        end.new
      end

      it { is_expected.to have_line_text_message(/Hello, John Doe!/) }
    end

    context "with loop" do
      let(:builder) do
        described_class.with do
          3.times do |i|
            text "This is message number #{i + 1}."
          end
        end
      end

      it { is_expected.to have_line_text_message(/This is message number 1\./) }
      it { is_expected.to have_line_text_message(/This is message number 2\./) }
      it { is_expected.to have_line_text_message(/This is message number 3\./) }
    end

    context "with conditional" do
      let(:builder) do
        described_class.with(ctx) do
          text "This is a message." if condition?
        end
      end

      let(:ctx) do
        Class.new do
          def condition?
            true
          end
        end.new
      end

      it { is_expected.to have_line_text_message(/This is a message\./) }
    end

    context "with SDKv2 mode" do
      let(:builder) do
        described_class.with(mode: :sdkv2) do
          text "This is a message in SDKv2 mode."
        end
      end

      it "expected to have snake case keys" do
        expect(result).to include({ text: "This is a message in SDKv2 mode.", type: "text" })
      end
    end
  end

  describe "#to_json" do
    subject(:json) { builder.to_json }

    it { is_expected.to be_a(String) }
    it { is_expected.to include('"type":"text"') }
    it { is_expected.to include('"text":"Hello, world!"') }
  end
end
