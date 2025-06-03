# frozen_string_literal: true

RSpec.describe Line::Message::Builder::Flex::Span do
  let(:message) do
    Line::Message::Builder.with do
      flex alt_text: "Span Test" do
        bubble do
          body do
            text do
              span "Hello", color: "#FF0000", size: :xl
            end
          end
        end
      end
    end.build
  end

  describe "span component" do
    it { expect(message).to have_line_flex_span("Hello") }
    it { expect(message).to have_line_flex_span("Hello", color: "#FF0000") }
    it { expect(message).to have_line_flex_span("Hello", size: "xl") }
    it { expect(message).to have_line_flex_span("Hello", color: "#FF0000", size: "xl") }
    it { expect(message).not_to have_line_flex_span("World") }
    it { expect(message).not_to have_line_flex_span("Hello", color: "#00FF00") }
  end

  context "with various formatting options" do
    let(:message) do
      Line::Message::Builder.with do
        flex alt_text: "Span Formatting Test" do
          bubble do
            body do
              text do
                span "Bold", weight: :bold
                span "Underline", decoration: :underline
                span "Line-through", decoration: :"line-through"
              end
            end
          end
        end
      end.build
    end

    it { expect(message).to have_line_flex_span("Bold", weight: "bold") }
    it { expect(message).to have_line_flex_span("Underline", decoration: "underline") }
    it { expect(message).to have_line_flex_span("Line-through", decoration: "line-through") }
  end

  context "with helper methods" do
    let(:message) do
      Line::Message::Builder.with do
        flex alt_text: "Span Helpers Test" do
          bubble do
            body do
              text do
                s = span "Test"
                s.bold!
                s.underline!
                
                s2 = span "Strikethrough"
                s2.line_through!
              end
            end
          end
        end
      end.build
    end

    it { expect(message).to have_line_flex_span("Test", weight: "bold", decoration: "underline") }
    it { expect(message).to have_line_flex_span("Strikethrough", decoration: "line-through") }
  end

  describe "#to_h" do
    context "when text is nil" do
      subject { described_class.new(nil).to_h }

      it "raises a RequiredError" do
        expect { subject }.to raise_error(Line::Message::Builder::RequiredError)
      end
    end

    context "with valid options" do
      subject { described_class.new("Hello", color: "#FF0000", size: :xl, weight: :bold).to_h }

      it "returns a hash with the correct attributes" do
        expect(subject).to eq({
          "type" => "span",
          "text" => "Hello",
          "color" => "#FF0000",
          "size" => "xl",
          "weight" => "bold"
        })
      end
    end

    context "with sdkv2 context" do
      subject do 
        context = double(sdkv2?: true)
        described_class.new("Hello", context: context, color: "#FF0000").to_h
      end

      it "returns a hash with the correct attributes" do
        expect(subject).to include({
          "type" => "span",
          "text" => "Hello",
          "color" => "#FF0000"
        })
      end
    end
  end
end
