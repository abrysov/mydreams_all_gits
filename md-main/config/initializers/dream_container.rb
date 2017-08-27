DreamContainer.configure do |container|
  if Rails.env.test?
    container.register(:google_receipt_verify, -> { Payments::Google::PlayStub.new })
    container.register(:appstore_receipt_verify, -> { Payments::Apple::AppstoreStub.new })
    container.register(:yandex_kassa_api_klass, -> { Payments::YandexKassa::ApiStub.new })
  else
    container.register(:google_receipt_verify, -> { Payments::Google::Play.new })
    container.register(:appstore_receipt_verify, -> { Payments::Apple::Appstore.new })
    container.register(:yandex_kassa_api_klass, -> { Payments::YandexKassa::Api.new })
  end

  container.register(:yandex_kassa_helpers_klass, -> { Payments::YandexKassa::Helpers.new })
end
