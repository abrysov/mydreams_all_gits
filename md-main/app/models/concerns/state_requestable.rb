module StateRequestable
  extend ActiveSupport::Concern

  included do
    state_machine :state, :initial => :initial do
      state :needs_accepting
      state :admin_accepted
      state :admin_declined
      state :gifted

      event :to_initial do
        transition any => :initial
      end
      event :request_accepting do
        transition :initial => :needs_accepting
      end
      event :accept do
        transition :needs_accepting => :admin_accepted
      end
      event :decline do
        transition :needs_accepting => :admin_declined
      end
    end
  end
end
