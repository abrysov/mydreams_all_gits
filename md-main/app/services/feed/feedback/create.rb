module Feed
  module Feedback
    class Create
      attr_reader :initiator, :dreamer, :resource, :action

      def initialize(initiator:, dreamer:, resource:, action:)
        @initiator = initiator
        @dreamer = dreamer
        @resource = resource
        @action = action
      end

      def call
        dreamer.feedbacks.create(
          initiator: initiator,
          resource: resource,
          action: action
        )
      end

      def self.call(*args)
        new(*args).call
      end
    end
  end
end
