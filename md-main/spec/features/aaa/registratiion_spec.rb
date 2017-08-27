require 'rails_helper'

describe 'Registration', js: true do
  before(:each) do
    visit root_path
    ActionMailer::Base.deliveries.clear
  end

  context 'failure' do
    specify do
      page.find('.no_authorized a[data-modal-type=authorization]').click
      page.find('a[data-modal-type="registration"]').click

      within '.card-modal-registration' do
        page.find('label[for="registration"]').click
      end
      ActionMailer::Base.deliveries.count.should == 0
    end
  end

  context 'success' do
    specify do
      page.find('.no_authorized a[data-modal-type=authorization]').click
      page.find('a[data-modal-type="registration"]').click

      within '.card-modal-registration' do
        fill_in 'dreamer[first_name]', with: 'First name'
        fill_in 'dreamer[email]', with: 'email@example.com'
        fill_in 'dreamer[password]', with: 'password'
        page.find('.reg_gender_select-link').click
        page.find('.ik_select_option[data-value=true]').click
        page.find('#dreamer_terms_of_service').click
        page.find('label[for="registration"]').click
      end
      sleep 3
      ActionMailer::Base.deliveries.count.should == 1
      # page.should_not have_content 'Registration'
      # current_path.should be == account_root_path(locale: :en)
    end
  end
end