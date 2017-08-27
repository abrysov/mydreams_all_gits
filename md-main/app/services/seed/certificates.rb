module Seed
  class Certificates
    def self.call(dreamer, number_creates)
      number_creates.times do
        certificate_type = CertificateType.order('random()').first
        certifiable = Dream.order('random()').first
        gifted = [true, false].sample
        gifted_by = dreamer if gifted

        paid = [true, false].sample
        accepted = [true, false].sample

        Certificate.create(
          certifiable: certifiable,
          certificate_type: certificate_type,
          gifted_by: gifted_by,
          paid: paid,
          accepted: accepted,
          wish: Faker::Lorem.sentence
        )
      end
    end
  end
end
