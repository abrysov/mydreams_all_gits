module FeatureHelpers
  include Devise::TestHelpers

  def sign_in_as_admin
    FactoryGirl.create(:admin_user) unless AdminUser.where(email: 'admin@example.com').any?

    visit admin_root_path
    page.should have_content 'You need to sign in or sign up before continuing.'

    fill_in 'Login', with: 'admin@example.com'
    fill_in 'Password', with: 'password'
    within '#admin_user_submit_action' do
      click_on 'Login'
    end

    page.should have_content 'Dashboard'
    page.should have_content 'Signed in successfully.'
  end

  def sign_in_as_manager
    FactoryGirl.create(:manager) unless AdminUser.where(email: 'manager@example.com').any?
    visit admin_root_path
    page.should have_content 'You need to sign in or sign up before continuing.'

    fill_in 'Login', with: 'manager@example.com'
    fill_in 'Password', with: 'password'
    within '#admin_user_submit_action' do
      click_on 'Login'
    end

    page.should have_content 'Dashboard'
    page.should have_content 'Signed in successfully.'
  end

  def sign_in_as_dreamer(dreamer = nil)
    @current_dreamer = dreamer || FactoryGirl.create(:dreamer)
    visit root_path

    page.find('.no_authorized a[data-modal-type=authorization]').click

    fill_in 'dreamer[login]', with: @current_dreamer.email
    fill_in 'dreamer[password]', with: 'password'
    page.find('label[for="authorization"]').click

    sleep 2
  end

  def fill_in_ckeditor(locator, opts)
    content = opts.fetch(:with).to_json
    page.execute_script <<-SCRIPT
    CKEDITOR.instances['#{locator}'].setData(#{content});
    $('textarea##{locator}').text(#{content});
    SCRIPT
  end
end
