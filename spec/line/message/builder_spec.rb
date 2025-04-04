# frozen_string_literal: true

RSpec.describe Line::Message::Builder do
  describe "VERSION" do
    subject { Line::Message::Builder::VERSION }

    it { is_expected.not_to be_nil }
  end

  describe "#build" do
    before do
      # 確保 Text 類被加載
      require "line/message/builder/text"
    end

    context "with a single text message" do
      subject(:builder) do
        described_class.new do
          text "Hello, world!"
        end
      end

      context "when building messages" do
        subject(:result) { builder.build }

        it { is_expected.to be_an(Array) }
        it { is_expected.to have_attributes(size: 1) }

        it "formats the message correctly" do
          expect(result.first).to eq({ type: "text", text: "Hello, world!" })
        end
      end
    end

    context "with multiple text messages" do
      subject(:builder) do
        described_class.new do
          text "First message"
          text "Second message"
        end
      end

      subject(:result) { builder.build }

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
      subject(:builder) do
        described_class.new(ctx) do
          text "Hello with context"
        end
      end

      let(:ctx) { { user_id: "U123456789" } }

      it "passes context to the builder" do
        expect(builder.context).to eq(ctx)
      end
    end

    context "with context methods" do
      subject(:builder) do
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
        expect(builder.build.first[:text]).to eq("Hello, John Doe!")
      end
    end
  end
end
