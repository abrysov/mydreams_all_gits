class Reaction < ActiveRecord::Base
  belongs_to :reactable, polymorphic: true
  belongs_to :dreamer
end
