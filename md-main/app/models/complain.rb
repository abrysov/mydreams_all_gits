class Complain < ActiveRecord::Base
  belongs_to :complainer, class_name: Dreamer
  belongs_to :suspected, class_name: Dreamer
  belongs_to :complainable, polymorphic: true
end
