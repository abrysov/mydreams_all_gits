class DreamHiddenTag < ActiveRecord::Base
  belongs_to :dream
  belongs_to :tag
end
