class FriendRequestSerializer < ActiveModel::Serializer
  attribute :id

  belongs_to :sender
  belongs_to :receiver
end
