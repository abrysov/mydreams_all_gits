class Conversation < ActiveRecord::Base
  has_many :messages

  def opponent_for(dreamer)
    opponent_id = (member_ids - [dreamer.id]).first
    Dreamer.find_by(id: opponent_id) || DeletedDreamer.new(id: opponent_id)
  end

  def members
    Dreamer.where(id: member_ids)
  end
end
