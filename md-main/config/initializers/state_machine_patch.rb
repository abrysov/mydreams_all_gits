module StateMachine
  Machine.ignore_method_conflicts = true

  module Integrations
    module ActiveModel
      public :around_validation
    end
  end
end
