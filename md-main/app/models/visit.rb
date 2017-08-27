# == Schema Information
#
# Table name: visits
#
#  id         :integer          not null, primary key
#  visitor_id :integer
#  visited_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Visit < ActiveRecord::Base
  belongs_to :visitor, class_name: 'Dreamer'
  belongs_to :visited, class_name: 'Dreamer', counter_cache: true

  validates :visited, :visitor, presence: true
  validates :visitor_id, uniqueness: { scope: :visited_id }
  validate :not_same

  private

  def not_same
    errors.add(:visitor, I18n.t('errors.visit.visitor_self')) if visitor == visited
  end
end
