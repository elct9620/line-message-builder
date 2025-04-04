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

    it "builds a single text message" do
      builder = Line::Message::Builder.new do
        text "Hello, world!"
      end

      result = builder.build
      expect(result).to be_an(Array)
      expect(result.size).to eq(1)
      expect(result.first).to eq({
        type: "text",
        text: "Hello, world!"
      })
    end

    it "builds multiple text messages" do
      builder = Line::Message::Builder.new do
        text "First message"
        text "Second message"
      end

      result = builder.build
      expect(result).to be_an(Array)
      expect(result.size).to eq(2)
      expect(result[0][:text]).to eq("First message")
      expect(result[1][:text]).to eq("Second message")
    end

    it "passes context to messages" do
      context = { user_id: "U123456789" }
      builder = Line::Message::Builder.new(context) do
        text "Hello with context"
      end

      # 驗證 context 被正確傳遞
      expect(builder.context).to eq(context)
    end
  end
end
