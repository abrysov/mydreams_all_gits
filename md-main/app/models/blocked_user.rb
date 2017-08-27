class BlockedUser < ActiveRecord::Base
  belongs_to :dreamer
  belongs_to :moderator, class_name: Dreamer
  belongs_to :abuse
end
