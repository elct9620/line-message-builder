# frozen_string_literal: true

RSpec.describe Line::Message::Builder::QuickReply::Builder do
  subject(:builder) { described_class.new }

  describe "#to_h" do
    subject(:result) { builder.to_h }

    it { is_expected.to be_a(Hash) }
    it { is_expected.to include(items: []) }

    context "with message actions" do
      before do
        builder.message "Yes", label: "Yes"
        builder.message "No", label: "No", image_url: "https://example.com/image.png"
      end

      it { is_expected.to include(items: be_an(Array)) }
      it { is_expected.to include(items: have_attributes(size: 2)) }

      it "formats the first message action correctly" do
        expect(result[:items][0]).to include(
          type: "action",
          action: {
            type: "message",
            label: "Yes",
            text: "Yes"
          }
        )
      end

      it "formats the message action with image correctly" do
        expect(result[:items][1]).to include(
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

    context "with postback actions" do
      before do
        builder.postback data: "action=buy&itemid=123", label: "Buy"
        builder.postback data: "action=add&itemid=123", label: "Add to Cart", 
                        text: "Added to cart", image_url: "https://example.com/cart.png"
      end

      it { is_expected.to include(items: be_an(Array)) }
      it { is_expected.to include(items: have_attributes(size: 2)) }

      it "formats the first postback action correctly" do
        expect(result[:items][0]).to include(
          type: "action",
          action: {
            type: "postback",
            label: "Buy",
            data: "action=buy&itemid=123"
          }
        )
      end

      it "formats the postback action with text and image correctly" do
        expect(result[:items][1]).to include(
          type: "action",
          imageUrl: "https://example.com/cart.png",
          action: {
            type: "postback",
            label: "Add to Cart",
            data: "action=add&itemid=123",
            text: "Added to cart"
          }
        )
      end
    end
  end
end
