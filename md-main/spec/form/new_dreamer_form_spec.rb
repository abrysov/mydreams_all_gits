require 'rails_helper'

RSpec.describe NewDreamerForm do
  let(:params) do
    { email: 'test@mail.com', phone: '+79999999999', first_name: 'test', gender: 'male',
      password: 'password', terms_of_service: '1' }
  end
  it do
    dreamer_form = NewDreamerForm.new(params)
    expect(dreamer_form.save).to eq true
    expect(Dreamer.last.email).to eq 'test@mail.com'
  end
end
