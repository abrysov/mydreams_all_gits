#
# => create new purchasing vip-status
# Result = Buy::VipStatus.new.create( data* )
#
# => or purchase processing
# Result = Buy::VipStatus.new( purchase ).processing
#
module Buy
  class VipStatus
    def initialize(purchase = nil)
      @purchase = purchase
    end

    def create(dreamer:, product:, destination: nil, comment: nil)
      raise ArgumentError, 'Expected that the product will be vip' unless product.vip?

      destination ||= dreamer
      destination_dreamer ||= destination

      return Result::Error.new unless destination.is_a? Dreamer

      purchase = Purchasing::Create.call(dreamer: dreamer, product: product,
                                         comment: comment, destination: destination,
                                         destination_dreamer: destination_dreamer)

      Result::Error.new purchase unless purchase.success?

      @purchase = purchase.data
      processing
    end

    def processing
      raise ArgumentError, 'Wrong product' unless @purchase.product.vip?
      return Result::Error.new unless @purchase.destination.is_a? Dreamer

      status = Purchasing::Process.call(@purchase)
      return status unless status.success?

      create_vip
    end

    protected

    def create_vip
      # TODO: in progress

      duration = @purchase.product.properties.find_by!(key: 'vip_duration').value.to_i
      paid_at = @purchase.destination.vip_end || Time.zone.now
      completed_at = paid_at + duration.days

      vip = ::VipStatus.create(dreamer: @purchase.destination, from_dreamer: @purchase.dreamer,
                               paid_at: paid_at, completed_at: completed_at, duration: duration,
                               comment: @purchase.comment)

      if vip.persisted?
        @purchase.destination.update_attribute(:is_vip, true)
        create_activity

        Result::Success.new vip
      else
        Result::Error.new
      end
    end

    def create_activity
      # TODO: test it
      key = 'paid_gift_vip'
      key = 'paid_self_vip' if @purchase.dreamer == @purchase.destination

      # TODO: trackable for vip?
      Feed::Activity::Create.call(trackable: @purchase.destination,
                                  owner: @purchase.dreamer,
                                  key: key)
    end
  end
end
