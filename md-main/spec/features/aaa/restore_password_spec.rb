require 'rails_helper'

describe 'Restore', pending: true, js: true do
  before do
    visit root_path
  end

  before(:each) do
    ActionMailer::Base.deliveries.clear
  end

  describe 'failure' do
    context 'without data' do
      specify do
        page.find('.no_authorized a[data-modal-type=authorization]').click
        page.find('a[data-modal-type="recovery"]').click

        within '.recovery_form' do
          page.find('#recovery').click
          page.should have_css '.error'
        end
        ActionMailer::Base.deliveries.count.should == 0
      end
    end

    context 'not existing email' do
      specify do
        page.find('.no_authorized a[data-modal-type=authorization]').click
        page.find('a[data-modal-type="recovery"]').click

        within '.recovery_form' do
          fill_in 'dreamer[email]', with: 'wrong_email@mail.ru'
          page.find('#recovery').click
          page.should have_css '.error'
        end
        ActionMailer::Base.deliveries.count.should == 0
      end
    end
  end

  describe 'success' do
    let!(:dreamer) { FactoryGirl.create(:dreamer) }

    specify do
      page.find('.no_authorized a[data-modal-type=authorization]').click
      page.find('a[data-modal-type="recovery"]').click

      within '.recovery_form' do
        fill_in 'dreamer[email]', with: dreamer.email
        page.find('#recovery').click
      end
      sleep 2
      ActionMailer::Base.deliveries.count.should == 2

      page.should_not have_css '.error'

      @mail = ActionMailer::Base.deliveries.last
      @host = ActionMailer::Base.default_url_options[:host]

      @mail.should deliver_to(dreamer.email)
      @mail.should deliver_from(Devise.mailer_sender)

      @mail.should have_body_text(/#{%r{<a href=\"http://#{@host}/dreamers/password/edit}}/)

      visit @mail.body.raw_source[/(http:\/\/.+\")/][0..-2]

      current_path.should be == edit_dreamer_password_path

      # fill_in 'dreamer[password]', with: 'newpassword123'
      # fill_in 'dreamer[password_confirmation]', with: 'newpassword123'
      # page.find('#submit').click
      # page.should have_content dreamer.first_name
    end
  end
end