class Certificate < ActiveRecord::Base
  validates :certifiable, presence: true

  belongs_to :certificate_type
  belongs_to :certifiable, polymorphic: true
  belongs_to :gifted_by, class_name: 'Dreamer'

  # TODO: move to state machine
  after_update :update_launches_count, if: :paid?
  after_update :update_summary_certificate_type, if: :paid?

  scope :paid, -> { where(paid: true) }
  scope :for_dreams, -> { where(certifiable_type: 'Dream') }
  scope :by_ids, -> (ids) { where(certifiable_id: ids) }
  scope :gifted, -> { where.not(gifted_by_id: nil).where(accepted: false) }
  scope :accepted, -> { where(accepted: true) }

  private

  def update_launches_count
    certifiable.calculate_launches_count!
  end

  def update_summary_certificate_type
    certifiable.update_summary_certificate_type!
  end
end
