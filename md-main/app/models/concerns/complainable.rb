module Complainable
  extend ActiveSupport::Concern

  included do
    has_many :complains, class_name: Complain, as: :complainable
  end
end
