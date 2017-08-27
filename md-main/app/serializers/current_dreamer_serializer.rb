class CurrentDreamerSerializer < DreamerSerializer
  attribute :followers_count
  attribute :followees_count
  attribute :unreaded_messages_count
  attribute :email
  attribute :token
  attribute :coins_count

  def coins_count
    object.account.amount
  end

  def unreaded_messages_count
    object.conversations.joins(:messages).
      where.not('messages.viewed_ids @> ARRAY[?]', object.id).
      count
  end

  def token
    JWT.encode(
      { 'user_id' => object.id },
      'super-secret-key',
      'HS256'
    )
  end
end
