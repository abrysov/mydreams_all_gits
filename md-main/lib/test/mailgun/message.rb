module Test
  module Mailgun
    class Message
      def send_email(params)
        @mails ||= []
        @mails << params

        { 'id' => Time.now.to_i.to_s }
      end
    end
  end
end
