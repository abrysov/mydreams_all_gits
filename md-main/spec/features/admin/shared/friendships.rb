RSpec.shared_examples 'friendships' do

  let!(:friendship1) { FactoryGirl.create(:friendship) }
  let!(:friendship2) { FactoryGirl.create(:friendship) }
  let!(:other_dreamer) { FactoryGirl.create(:dreamer) }

  before(:each) do
    visit admin_friendships_path
  end

  describe 'index page' do
    specify do
      page.should have_content 'Friendships'
      within '#index_table_friendships' do
        page.should have_content friendship1.dreamer.full_name
        page.should have_content friendship1.friend.full_name

        page.should have_content friendship2.dreamer.full_name
      end
    end
  end

  describe 'view page' do
    specify do
      within '#index_table_friendships' do
        within "#friendship_#{friendship1.id}" do
          click_on 'View'
        end
      end

      page.should have_content friendship1.dreamer.full_name
      page.should have_content friendship1.friend.full_name
    end
  end

  describe 'edit page' do
    specify do
      within '#index_table_friendships' do
        within "#friendship_#{friendship1.id}" do
          click_on 'Edit'
        end
      end
      page.should have_content 'Edit Friendship'
      within 'form#edit_friendship' do
        select friendship2.dreamer.full_name, from: 'Dreamer'
        select other_dreamer.full_name, from: 'Friend'
      end
      click_on 'Update Friendship'
      page.should have_content 'Friendship was successfully updated.'
      page.should have_content friendship2.dreamer.full_name
      page.should have_content other_dreamer.full_name
    end
  end

  describe '#create' do
    specify do
      click_on 'New Friendship'

      page.should have_content 'New Friendship'
      within 'form#new_friendship' do
        select friendship2.dreamer.full_name, from: 'Dreamer'
        select other_dreamer.full_name, from: 'Friend'
      end
      click_on 'Create Friendship'
      page.should have_content 'Friendship was successfully created.'
      page.should have_content friendship2.dreamer.full_name
      page.should have_content other_dreamer.full_name
    end
  end

  describe '#delete' do
    specify do
      within '#index_table_friendships' do
        within "#friendship_#{friendship1.id}" do
          click_on 'Delete'
        end
      end
      page.should have_content 'Friendship was successfully destroyed.'
      within '#index_table_friendships' do
        page.should_not have_content friendship1.dreamer.full_name
        page.should have_content friendship2.dreamer.full_name
      end
    end
  end
end