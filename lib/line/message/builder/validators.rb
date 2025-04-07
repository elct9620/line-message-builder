# frozen_string_literal: true

module Line
  module Message
    module Builder
      # :nodoc:
      module Validators
        require_relative "validators/enum"
        require_relative "validators/size"
      end
    end
  end
end
