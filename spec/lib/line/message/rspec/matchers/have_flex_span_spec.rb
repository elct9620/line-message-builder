# frozen_string_literal: true

RSpec.describe Line::Message::RSpec::Matchers::HaveFlexComponent do
  describe "#have_line_flex_span" do
    let(:messages) do
      Line::Message::Builder.with do
        flex alt_text: "Span Matcher Test" do
          bubble do
            body do
              text do
                span "Hello", color: "#FF0000", size: :xl
                span "World", weight: :bold, decoration: :underline
              end
            end
          end
        end
      end.build
    end

    it "matches a span with the specified text" do
      expect(messages).to have_line_flex_span("Hello")
      expect(messages).to have_line_flex_span("World")
      expect(messages).not_to have_line_flex_span("Goodbye")
    end

    it "matches a span with the specified text and attributes" do
      expect(messages).to have_line_flex_span("Hello", color: "#FF0000")
      expect(messages).to have_line_flex_span("Hello", size: "xl")
      expect(messages).to have_line_flex_span("World", weight: "bold")
      expect(messages).to have_line_flex_span("World", decoration: "underline")
    end

    it "doesn't match when attributes don't match" do
      expect(messages).not_to have_line_flex_span("Hello", color: "#00FF00")
      expect(messages).not_to have_line_flex_span("Hello", weight: "bold")
      expect(messages).not_to have_line_flex_span("World", color: "#FF0000")
    end

    it "shows appropriate description" do
      matcher = have_line_flex_span("Hello")
      expect(matcher.description).to eq('have flex component matching span("Hello")')
    end

    it "shows appropriate failure message" do
      matcher = have_line_flex_span("NonExistent")
      matcher.matches?(messages)
      expect(matcher.failure_message).to eq('expected to find a flex component matching span("NonExistent")')
    end
  end
end
