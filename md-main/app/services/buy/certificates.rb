#
# => create new certificate purchasing
# Result = Buy::Certificates.new.create( data* )
#
# => or purchase processing
# Result = Buy::Certificates.new( purchase ).processing
#
module Buy
  class Certificates
    attr_reader :purchase
    def initialize(purchase = nil)
      @purchase = purchase
    end

    def create(dreamer:, destination:, product:, comment: nil)
      unless product.certificate?
        raise ArgumentError, 'Expected that the product will be certificate'
      end
      unless destination.is_a? Dream
        raise ArgumentError, 'Expected that the destination will be a dream'
      end

      purchase = Purchasing::Create.call(dreamer: dreamer, product: product,
                                         comment: comment, destination: destination,
                                         destination_dreamer: destination.dreamer)

      return Result::Error.new purchase unless purchase.success?

      @purchase = purchase.data
      processing
    end

    def processing
      raise ArgumentError, 'Wrong product' unless @purchase.product.certificate?
      purchase = Purchasing::Process.call(@purchase)

      return Result::Error.new @purchase unless purchase.success?
      create_certificate
    end

    protected

    def create_certificate
      product_properties = @purchase.product.properties
      certificate_name = product_properties.find_by!(key: 'certificate_name').value
      certificate_launches = product_properties.find_by!(key: 'certificate_launches').value
      certificate_type = CertificateType.find_by(value: certificate_launches)

      certificate = Certificate.create(certifiable: @purchase.destination,
                                       gifted_by_id: @purchase.dreamer.id,
                                       wish: @purchase.comment,
                                       certificate_name: certificate_name,
                                       launches: certificate_launches,
                                       certificate_type: certificate_type,
                                       paid: true,
                                       accepted: accepted?)

      return Result::Error.new @purchase unless certificate.persisted?

      certificate.certifiable.calculate_launches_count!
      certificate.certifiable.update_summary_certificate_type!

      create_activity
      Result::Success.new certificate
    end

    def accepted?
      @purchase.destination.dreamer == @purchase.dreamer
    end

    def create_activity
      # TODO: test it
      key = 'paid_gift_certificate'
      key = 'paid_self_certificate' if @purchase.dreamer == @purchase.destination.dreamer

      Feed::Activity::Create.call(trackable: @purchase.destination,
                                  owner: @purchase.dreamer,
                                  key: key)
    end
  end
end
