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

    describe "with a single text message" do
      subject(:builder) do
        described_class.new do
          text "Hello, world!"
        end
      end

      describe "result" do
        subject { builder.build }

        it { is_expected.to be_an(Array) }
        it { is_expected.to have_attributes(size: 1) }

        describe "first message" do
          subject { builder.build.first }

          it { is_expected.to eq({ type: "text", text: "Hello, world!" }) }
        end
      end
    end

    describe "with multiple text messages" do
      subject(:builder) do
        described_class.new do
          text "First message"
          text "Second message"
        end
      end

      describe "result" do
        subject { builder.build }

        it { is_expected.to be_an(Array) }
        it { is_expected.to have_attributes(size: 2) }
      end

      describe "first message" do
        subject { builder.build[0] }

        it { is_expected.to include(text: "First message") }
      end

      describe "second message" do
        subject { builder.build[1] }

        it { is_expected.to include(text: "Second message") }
      end
    end

    describe "with context" do
      subject(:builder) do
        described_class.new(ctx) do
          text "Hello with context"
        end
      end

      let(:ctx) { { user_id: "U123456789" } }

      describe "context" do
        subject { builder.context }

        it { is_expected.to eq(ctx) }
      end
    end

    describe "with context methods" do
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

      describe "message text" do
        subject { builder.build.first[:text] }

        it { is_expected.to eq("Hello, John Doe!") }
      end
    end
  end
end
