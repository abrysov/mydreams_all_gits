module Legacy
  class ResultAPIResponder
    attr_reader :status

    def self.success
      new Result::Success.new
    end

    def initialize(status)
      @status = status
    end

    def to_json(_options = {})
      if status.success?
        successful_response.to_json
      else
        error_response.to_json
      end
    end

    def successful_response
      { code: 0 }.merge body: status.data
    end

    def error_response
      { code: 1 }.merge message: status.error
    end
  end
end
