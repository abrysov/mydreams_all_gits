require 'rails_helper'

describe 'Admin Users' do

  let(:restrictable_for_manager) do
    ['Admin Users', 'Dreamers', 'Superuser']
  end
  let(:allowable_for_manager) do
    [
        'Dashboard', 'Activities', 'Admin Comments', 'Attachments', 'Comments', 'Dreamer Cities',
        'Dreamer Countries', 'Dreams', 'Friendships', 'Likes', 'Messages', 'Photos', 'Static Pages',
        'Suggested Dreams', 'Top Dreams'
    ]
  end

  describe 'index page' do
    let!(:manager) { FactoryGirl.create(:manager) }

    before do
      sign_in_as_admin
      visit admin_admin_users_path
    end
    specify do
      (allowable_for_manager + restrictable_for_manager).each do |allowable|
        page.should have_link allowable
      end

      within '#index_table_admin_users' do
        page.should have_content manager.email
        within "#admin_user_#{manager.id}" do
          within '.col-manager' do
            page.should have_content 'Yes'
          end
          page.should have_content manager.email
        end
      end
    end
  end

  describe 'can login and not see forbidden areas' do
    before do
      sign_in_as_manager
    end

    specify do
      restrictable_for_manager.each do |restrictable|
        page.should_not have_link restrictable
      end

      allowable_for_manager.each do |allowable|
        page.should have_link allowable
      end
    end
  end

  describe 'forbidden to some areas' do
    before do
      sign_in_as_manager
      visit admin_admin_users_path
    end
    specify do
      within '.flash.flash_error' do
        page.should have_content 'You are not authorized to perform this action.'
      end
      current_path.should be == admin_root_path
    end
  end
end
