# frozen_string_literal: true

RSpec.describe Line::Message::Builder do
  subject(:build) { builder.build }

  let(:builder) do
    described_class.with do
      flex alt_text: "Simple Flex Message" do
        carousel do
          bubble do
            body do
              box do
                text "Nested box"
              end
            end
          end

          bubble do
            body do
              box do
                text "Another nested box"
              end
            end
          end
        end
      end
    end
  end

  it { is_expected.to have_line_flex_message(/Simple Flex Message/) }
  it { is_expected.to have_line_flex_text(/Nested box/) }
  it { is_expected.to have_line_flex_text(/Another nested box/) }
end
