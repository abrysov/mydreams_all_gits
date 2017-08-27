class Subscription < ActiveRecord::Base
  belongs_to :subscriber, class_name: Dreamer
  belongs_to :dreamer
end
