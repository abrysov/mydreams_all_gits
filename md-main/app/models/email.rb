class Email < ActiveRecord::Base
  belongs_to :dreamer

  has_many :sended_mails

  scope :available_for_newsletter, -> do
    joins(:dreamer).where(
      unsub: false,
      spam: false,
      reject: false,
      hard_bounce: false,
      soft_bounce: false,
      dreamer: {
        deleted_at: nil,
        blocked_at: nil
      }
    )
  end
end
