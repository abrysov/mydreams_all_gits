class Tag < ActiveRecord::Base
  has_closure_tree
  has_many :dream_hidden_tags, dependent: :destroy
  has_many :dreams, through: :dream_hidden_tags
  validates :name, uniqueness: true, allow_blank: false
end
