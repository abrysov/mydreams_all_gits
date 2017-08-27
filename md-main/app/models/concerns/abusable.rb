module Abusable
  extend ActiveSupport::Concern

  included do
    has_many :abuses, class_name: Abuse, as: :abusable
  end
end
