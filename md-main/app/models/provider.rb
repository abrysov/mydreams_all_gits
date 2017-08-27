class Provider < ActiveRecord::Base
  belongs_to :dreamer

  serialize :meta, ActiveSupport::HashWithIndifferentAccess
end
