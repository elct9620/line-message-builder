# frozen_string_literal: true

RSpec.describe Line::Message::Builder do
  subject(:builder) do
    described_class.new do
      text "Hello, world!"
    end
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

      it { is_expected.to include({ type: "text", text: "Hello, world!" }) }
    end

    context "with multiple text messages" do
      let(:builder) do
        described_class.new do
          text "First message"
          text "Second message"
        end
      end

      it { is_expected.to be_an(Array) }
      it { is_expected.to have_attributes(size: 2) }

      it "formats the first message correctly" do
        expect(result[0]).to include(text: "First message")
      end

      it "formats the second message correctly" do
        expect(result[1]).to include(text: "Second message")
      end
    end

    context "with context" do
      let(:builder) do
        described_class.new(ctx) do
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

      it "allows calling methods from context" do
        expect(result.first[:text]).to eq("Hello, John Doe!")
      end
    end
  end
end
