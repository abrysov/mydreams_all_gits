module Test
  module Mandrill
    class Messages
      def initialize(*args)
        @args = args
      end

      def send(*args)
      end

      def send_raw(raw_message, from_email=nil, from_name=nil, to=nil, async=false, ip_pool=nil, send_at=nil, return_path_domain=nil)
        return to.map {|t| {"email" => t, "status" => "sent", "_id" => Digest::MD5.hexdigest(Time.now.to_s), "reject_reason" => nil} }
      end
    end
  end
end
