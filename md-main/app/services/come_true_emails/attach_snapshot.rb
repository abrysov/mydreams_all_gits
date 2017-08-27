module ComeTrueEmails
  class AttachSnapshot
    def self.call(come_true_email, snapshot_type: :none)
      return if snapshot_type.to_s == 'none' || snapshot_type.nil?

      dreamer = come_true_email.dream.dreamer
      dream = come_true_email.dream

      result = case snapshot_type
               when 'dream_dreamer'
                 BuildSnapshot::DreamDreamerCard.call(dream)
               when 'dream'
                 BuildSnapshot::DreamCard.call(dream)
               when 'dreamer'
                 BuildSnapshot::DreamerCard.call(dreamer)
               end

      return Result::Error.new unless result.success?

      snapshot = result.data

      come_true_email.snapshot = snapshot
      come_true_email.save
      snapshot.unlink

      come_true_email.snapshot.present? ? Result::Success.new : Result::Error.new
    end
  end
end
