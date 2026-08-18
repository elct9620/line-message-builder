# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Actions
        # Represents a URI action for LINE messages.
        #
        # A URI action opens the given URI when the component it is attached to is
        # tapped. Unlike Postback, it needs no webhook handling, which makes it the
        # action to reach for when a component should simply link somewhere.
        #
        # The available schemes are +http+, +https+, +line+ and +tel+.
        #
        # A separate URI can be opened on desktop by setting +alt_uri_desktop+,
        # which maps to the <code>altUri.desktop</code> property. When it is set,
        # LINE for macOS and Windows ignores +uri+. This is supported in Flex
        # Messages but has no effect in a quick reply.
        #
        # == Example: Linking a Flex button to a web page
        #
        #   Line::Message::Builder.with do
        #     flex alt_text: "Event" do
        #       bubble do
        #         footer do
        #           button style: :primary do
        #             uri "https://example.com/event", label: "View event"
        #           end
        #         end
        #       end
        #     end
        #   end
        #
        # === Example: Opening a different page on desktop
        #
        #   uri "https://example.com/mobile",
        #       label: "Open",
        #       alt_uri_desktop: "https://example.com/desktop"
        #
        # See also:
        # - https://developers.line.biz/en/reference/messaging-api/#uri-action
        class Uri < Line::Message::Builder::Base
          # The URI opened when the action is performed. This is a required
          # attribute. Max 1000 characters.
          attr_reader :uri

          # :method: label
          # :call-seq:
          #   label() -> String or nil
          #   label(value) -> String or nil
          #
          # Sets or gets the label for the action.
          #
          # [value]
          #   The label text for the action
          option :label, default: nil

          # :method: alt_uri_desktop
          # :call-seq:
          #   alt_uri_desktop() -> String or nil
          #   alt_uri_desktop(value) -> String or nil
          #
          # Sets or gets the URI opened on LINE for macOS and Windows, mapping to
          # the <code>altUri.desktop</code> property. Has no effect in a quick reply.
          #
          # [value]
          #   The desktop URI (max 1000 characters)
          option :alt_uri_desktop, default: nil

          # Initializes a new Uri action.
          #
          # [uri]
          #   The URI to open when the action is performed (required)
          # [context]
          #   An optional context object (default: +nil+)
          # [options]
          #   Options for the action, including +:label+ and +:alt_uri_desktop+
          # [block]
          #   An optional block to be instance-eval'd
          #
          # == Example
          #
          #   Uri.new("https://example.com", label: "Open")
          def initialize(uri, context: nil, **, &)
            @uri = uri

            super(context: context, **, &)
          end

          # Converts the Uri action object to a hash suitable for the LINE
          # Messaging API.
          #
          # Raises RequiredError if +uri+ is +nil+.
          #
          # == Example
          #
          #   Uri.new("https://example.com", label: "Open").to_h
          #   # => { type: "uri", label: "Open", uri: "https://example.com" }
          #
          # [return]
          #   A hash representing the URI action
          def to_h
            raise RequiredError, "uri is required" if uri.nil?

            return to_sdkv2 if context.sdkv2?

            to_api
          end

          private

          def to_api # :nodoc:
            {
              type: "uri",
              label: label,
              uri: uri,
              altUri: alt_uri
            }.compact
          end

          def to_sdkv2 # :nodoc:
            {
              type: "uri",
              label: label,
              uri: uri,
              alt_uri: alt_uri
            }.compact
          end

          def alt_uri # :nodoc:
            return if alt_uri_desktop.nil?

            { desktop: alt_uri_desktop }
          end
        end
      end
    end
  end
end
