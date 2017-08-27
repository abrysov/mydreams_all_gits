class NegativeAmountError < StandardError
  attr_reader :data, :errors

  def initialize(data: nil, errors: nil)
    @data = data
    @errors = errors
  end
end
