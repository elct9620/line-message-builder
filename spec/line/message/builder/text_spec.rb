# frozen_string_literal: true

RSpec.describe Line::Message::Builder::Text do
  subject(:text_builder) { described_class.new(message_text) }

  let(:message_text) { "Hello, world!" }

  describe "#to_h" do
    subject(:result) { text_builder.to_h }

    it { is_expected.to be_a(Hash) }
    it { is_expected.to include(type: "text") }
    it { is_expected.to include(text: "Hello, world!") }

    context "with quick reply" do
      subject(:quick_reply) { result[:quickReply] }

      before do
        text_builder.quick_reply do
          message "Yes", label: "Yes"
          message "No", label: "No", image_url: "https://example.com/image.png"
        end
      end

      it { expect(result).to include(:quickReply) }
      it { is_expected.to be_a(Hash) }
      it { is_expected.to include(:items) }
      it { is_expected.to include(items: be_an(Array)) }
      it { is_expected.to include(items: have_attributes(size: 2)) }

      it "formats the first quick reply item correctly" do
        expect(quick_reply[:items][0]).to include(
          type: "action",
          action: { type: "message", label: "Yes", text: "Yes" }
        )
      end

      it "formats the second quick reply item with image correctly" do
        expect(quick_reply[:items][1]).to include(
          type: "action",
          imageUrl: "https://example.com/image.png",
          action: { type: "message", label: "No", text: "No" }
        )
      end
    end
  end
end
