module Test
  module Mandrill
    class API
      def initialize(*args)
        @args = args
      end

      def messages
        Mandrill::Messages.new
      end
    end
  end
end
