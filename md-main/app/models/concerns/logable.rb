module Logable
  extend ActiveSupport::Concern

  included do
    has_many :logs, class_name: ModeratorLog, as: :logable
  end
end
