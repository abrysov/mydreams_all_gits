RSpec.shared_examples 'dreamers' do

  let!(:dreamer1) { FactoryGirl.create(:dreamer) }
  let!(:dreamer2) { FactoryGirl.create(:dreamer) }
  let!(:dreamer3) { FactoryGirl.create(:dreamer) }

  before(:each) do
    visit admin_dreamers_path
  end

  describe 'index page' do
    specify do
      page.should have_content 'Dreamers'
      within '#index_table_dreamers' do
        page.should have_content dreamer1.email
        page.should have_content dreamer1.age
        page.should have_content dreamer1.first_name
        page.should have_content dreamer1.last_name

        page.should have_content dreamer2.first_name
      end
    end
  end

  describe 'view page' do
    specify do
      within '#index_table_dreamers' do
        within "#dreamer_#{dreamer1.id}" do
          click_on 'View'
        end
      end
      page.should have_content dreamer1.email
      page.should have_content dreamer1.age
      page.should have_content dreamer1.first_name
      page.should have_content dreamer1.last_name

      page.should_not have_content dreamer2.first_name
    end
  end

  describe 'edit page' do
    specify do
      within '#index_table_dreamers' do
        within "#dreamer_#{dreamer1.id}" do
          click_on 'Edit'
        end
      end
      page.should have_content 'Edit Dreamer'
      within 'form#edit_dreamer' do
        fill_in 'dreamer_first_name', with: 'New dreamer name'
        fill_in 'dreamer_last_name', with: 'New dreamer last name'
        fill_in 'dreamer_password', with: 'password'
        attach_file 'dreamer_avatar', FactoryHelpers::random_fixture_image
      end
      click_on 'Update Dreamer'
      page.should have_content 'Dreamer was successfully updated.'
      page.should have_content 'New dreamer name'
      page.should have_content 'New dreamer last name'
    end
  end

  describe '#create' do
    specify do
      click_on 'New Dreamer'

      page.should have_content 'New Dreamer'
      within 'form#new_dreamer' do
        fill_in 'dreamer_first_name', with: 'New dreamer name'
        fill_in 'dreamer_last_name',  with: 'New dreamer last name'
        fill_in 'dreamer_birthday',   with: '05-02-2015'
        fill_in 'dreamer_password', with: 'password'
        fill_in 'dreamer_email',      with: 'email@example.ru'
        attach_file 'dreamer_avatar', FactoryHelpers::random_fixture_image
      end
      click_on 'Create Dreamer'
      page.should have_content 'Dreamer was successfully created.'
      page.should have_content 'New dreamer name'
    end
  end
  
  describe '#delete' do
    specify do
      within '#index_table_dreamers' do
        within "#dreamer_#{dreamer1.id}" do
          click_on 'Delete'
        end
      end
      page.should have_content 'Dreamer was successfully destroyed.'
      within '#index_table_dreamers' do
        page.should_not have_content dreamer1.first_name
        page.should have_content dreamer2.first_name
      end
    end
  end
end