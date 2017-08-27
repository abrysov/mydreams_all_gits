class LikeSerializer < ActiveModel::Serializer
  attribute :id

  belongs_to :dreamer

  class DreamerSerializer < ShortDreamerSerializer; end
end
