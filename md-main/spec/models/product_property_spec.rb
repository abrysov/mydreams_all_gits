require 'rails_helper'

RSpec.describe ProductProperty do
  it { is_expected.to belong_to :product }
end
