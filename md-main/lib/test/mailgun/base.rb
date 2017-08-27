module Test
  module Mailgun
    class Base
      def initialize(opts)
        @opts = opts
      end

      def messages
        ::Test::Mailgun::Message.new
      end
    end
  end
end
