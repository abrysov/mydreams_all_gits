require 'rails_helper'

describe 'Authentication', js: true do
  before do
    visit root_path
  end
  describe 'success' do
    let!(:dreamer) { FactoryGirl.create(:dreamer) }

    specify do
      page.find('.no_authorized a[data-modal-type=authorization]').click

      within '.card-modal-authorization' do
        fill_in 'dreamer[login]', with: dreamer.email
        fill_in 'dreamer[password]', with: 'password'
        page.find('label[for="authorization"]').click
      end
      sleep 3
      # current_path.should be == account_root_path(locale: :en)
    end
  end
end