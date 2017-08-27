module Result
  class Error
    attr_reader :error

    def initialize(error = nil)
      @error = error
    end

    def success?
      false
    end
  end
end
