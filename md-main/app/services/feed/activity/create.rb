module Feed
  module Activity
    class Create
      attr_reader :trackable, :owner, :key

      def initialize(trackable: nil, owner:, key:)
        @trackable = trackable
        @owner = owner
        @key = key
      end

      def call
        activity = ::Activity.create(trackable: trackable,
                                     owner: owner,
                                     key: key)
        add_to_queue(activity)
        activity
      end

      def self.call(**args)
        new(args).call
      end

      private

      def add_to_queue(activity)
        if key =~ /_like$/
          NotificationWorker.perform_in(10.seconds, activity.id)
        else
          NotificationWorker.perform_async(activity.id)
        end
      end
    end
  end
end
