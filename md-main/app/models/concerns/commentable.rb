module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, -> { not_deleted }, as: :commentable

    has_many :last_comments, -> { joins(:dreamer).order(id: :desc).where(deleted_at: nil).limit(3) }, class_name: 'Comment', as: :commentable
  end
end
