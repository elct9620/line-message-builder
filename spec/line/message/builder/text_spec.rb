# frozen_string_literal: true

RSpec.describe Line::Message::Builder::Text do
  subject(:text_builder) { described_class.new(message_text) }

  let(:message_text) { "Hello, world!" }

  describe "#to_h" do
    subject { text_builder.to_h }

    it { is_expected.to be_a(Hash) }
    it { is_expected.to include(type: "text") }
    it { is_expected.to include(text: "Hello, world!") }

    context "with quick reply" do
      before do
        text_builder.quick_reply do
          message "Yes", label: "Yes"
          message "No", label: "No", image_url: "https://example.com/image.png"
        end
      end

      it { is_expected.to include(:quickReply) }
      
      it "includes quick reply items" do
        quick_reply = subject[:quickReply]
        expect(quick_reply).to be_a(Hash)
        expect(quick_reply).to include(:items)
        expect(quick_reply[:items]).to be_an(Array)
        expect(quick_reply[:items].size).to eq(2)
      end

      it "formats the first quick reply item correctly" do
        first_item = subject[:quickReply][:items].first
        expect(first_item).to include(
          type: "action",
          action: {
            type: "message",
            label: "Yes",
            text: "Yes"
          }
        )
      end

      it "formats the second quick reply item with image correctly" do
        second_item = subject[:quickReply][:items].last
        expect(second_item).to include(
          type: "action",
          imageUrl: "https://example.com/image.png",
          action: {
            type: "message",
            label: "No",
            text: "No"
          }
        )
      end
    end
  end
end
