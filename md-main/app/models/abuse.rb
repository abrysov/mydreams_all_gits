class Abuse < ActiveRecord::Base
  belongs_to :abusable, polymorphic: true
  belongs_to :moderator, class_name: Dreamer
  belongs_to :complain
end
