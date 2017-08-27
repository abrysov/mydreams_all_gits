module Seed
  class RandomEntity
    def self.call
      entity = %w(dream top_dream photo post).sample.classify.constantize
      entity.order('RANDOM()').first
    end
  end
end
