class DetailedDreamSerializer < DreamSerializer
  has_many :last_likes
  has_many :last_comments

  class DreamerSerializer < ShortDreamerSerializer; end
end
