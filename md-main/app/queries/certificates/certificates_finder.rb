module Certificates
  class CertificatesFinder
    def initialize(current_dreamer)
      @current_dreamer = current_dreamer
    end

    def filter(f = {})
      @scope = Certificate.for_dreams.
               by_ids(@current_dreamer.dreams.pluck(:id))

      @scope = @scope.paid                      if f[:paid].present?
      @scope = @scope.gifted                    if f[:gifted].present?
      @scope = @scope.order(created_at: :desc)  if f[:new].present?
      @scope = @scope.order(launches: :desc)    if f[:launches].present?

      @scope
    end
  end
end
