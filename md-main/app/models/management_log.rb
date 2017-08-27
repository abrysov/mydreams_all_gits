class ManagementLog < ActiveRecord::Base
  belongs_to :logable, polymorphic: true
  belongs_to :dreamer
end
