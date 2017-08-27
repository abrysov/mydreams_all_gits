class CommentSerializer < ActiveModel::Serializer
  include ApplicationHelper

  attribute :id
  attribute :body
  attribute :created_at

  belongs_to :dreamer, serializer: ShortDreamerSerializer
end
