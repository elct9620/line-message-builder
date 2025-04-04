# frozen_string_literal: true

RSpec.describe Line::Message::Builder do
  it "has a version number" do
    expect(Line::Message::Builder::VERSION).not_to be_nil
  end

  describe "#build" do
    before do
      # 確保 Text 類被加載
      require "line/message/builder/text"
    end

    describe "with a single text message" do
      let(:builder) do
        described_class.new do
          text "Hello, world!"
        end
      end
      
      let(:result) { builder.build }

      it "returns an array" do
        expect(result).to be_an(Array)
      end

      it "contains one message" do
        expect(result.size).to eq(1)
      end

      it "has the correct message format" do
        expect(result.first).to eq({
          type: "text",
          text: "Hello, world!"
        })
      end
    end

    describe "with multiple text messages" do
      let(:builder) do
        described_class.new do
          text "First message"
          text "Second message"
        end
      end
      
      let(:result) { builder.build }

      it "returns an array" do
        expect(result).to be_an(Array)
      end

      it "contains two messages" do
        expect(result.size).to eq(2)
      end

      it "has the correct first message text" do
        expect(result[0][:text]).to eq("First message")
      end

      it "has the correct second message text" do
        expect(result[1][:text]).to eq("Second message")
      end
    end

    describe "with context" do
      let(:context) { { user_id: "U123456789" } }
      
      let(:builder) do
        described_class.new(context) do
          text "Hello with context"
        end
      end

      it "passes context to the builder" do
        expect(builder.context).to eq(context)
      end
    end
  end
end
