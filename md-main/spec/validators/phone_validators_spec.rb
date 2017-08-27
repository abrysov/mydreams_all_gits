require 'rails_helper'

describe PhoneValidator do
  let!(:validator) { PhoneValidator.new({attributes: [:phone]}) }
  let!(:dreamer) { FactoryGirl.create(:dreamer) }

  it 'should validate valid phone' do
    dreamer.errors.should_not_receive('add')
    validator.validate_each(dreamer, :phone, '+7 (925) 123-12012')
  end

  it 'should validate invalid phone' do
    dreamer.errors.should_receive('add')
    validator.validate_each(dreamer, :phone, 'notvalid')
  end
end
