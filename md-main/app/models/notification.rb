class Notification < ActiveRecord::Base
  belongs_to :dreamer
  belongs_to :initiator, class_name: 'Dreamer'
  belongs_to :resource, polymorphic: true
end
