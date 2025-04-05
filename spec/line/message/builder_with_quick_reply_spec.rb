# frozen_string_literal: true

RSpec.describe Line::Message::Builder do
  subject { builder.build }

  let(:builder) do
    described_class.with do
      text "With Quick Reply" do
        quick_reply do
          message "Yes", label: "Yes"
          postback "action=no", label: "No"
        end
      end
    end
  end

  it { is_expected.to have_line_quick_reply }
  it { is_expected.to have_line_quick_reply(type: "message") }
  it { is_expected.to have_line_quick_reply(label: "Yes") }
  it { is_expected.to have_line_quick_reply(text: "Yes") }
  it { is_expected.to have_line_quick_reply(type: "postback", label: "No") }
  it { is_expected.to have_line_text_message(/With Quick Reply/) }
end
