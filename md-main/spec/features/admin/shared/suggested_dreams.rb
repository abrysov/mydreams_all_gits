RSpec.shared_examples 'suggested dreams' do

  let!(:suggested_dream1) { FactoryGirl.create(:suggested_dream) }
  let!(:suggested_dream2) { FactoryGirl.create(:suggested_dream) }


  before(:each) do
    visit admin_suggested_dreams_path
  end

  describe 'index page' do
    specify do
      page.should have_content 'Suggested Dreams'
      within '#index_table_suggested_dreams' do
        page.should have_content suggested_dream1.dream.title
        page.should have_content suggested_dream1.receiver.full_name

        page.should have_content suggested_dream2.dream.title
        page.should have_content suggested_dream2.receiver.full_name
      end
    end
  end

  describe 'view page' do
    specify do
      within '#index_table_suggested_dreams' do
        within "#suggested_dream_#{suggested_dream1.id}" do
          click_on 'View'
        end
      end

      page.should have_content suggested_dream1.dream.title
      page.should have_content suggested_dream1.receiver.full_name

      page.should_not have_content suggested_dream2.dream.title
    end
  end

  describe 'edit page' do
    let!(:other_dream) { FactoryGirl.create(:dream) }
    let!(:other_dreamer) { FactoryGirl.create(:dreamer) }
    specify do
      within '#index_table_suggested_dreams' do
        within "#suggested_dream_#{suggested_dream1.id}" do
          click_on 'Edit'
        end
      end
      page.should have_content 'Edit Suggested Dream'
      within 'form#edit_suggested_dream' do
        select other_dreamer.full_name, from: 'Receiver'
        select other_dream.title, from: 'Dream'
      end
      click_on 'Update Suggested dream'
      page.should have_content 'Suggested dream was successfully updated.'
      page.should have_content other_dreamer.full_name
      page.should have_content other_dream.title
    end
  end

  describe '#create' do
    let!(:other_dream) { FactoryGirl.create(:dream) }
    let!(:other_dreamer) { FactoryGirl.create(:dreamer) }
    specify do
      click_on 'New Suggested Dream'

      page.should have_content 'New Suggested Dream'
      within 'form#new_suggested_dream' do
        select other_dreamer.full_name, from: 'Receiver'
        select other_dream.title, from: 'Dream'
      end
      click_on 'Create Suggested dream'
      page.should have_content 'Suggested dream was successfully created.'
      page.should have_content other_dreamer.full_name
      page.should have_content other_dream.title
    end
  end

  describe '#delete' do
    specify do
      within '#index_table_suggested_dreams' do
        within "#suggested_dream_#{suggested_dream1.id}" do
          click_on 'Delete'
        end
      end
      page.should have_content 'Suggested dream was successfully destroyed.'
      within '#index_table_suggested_dreams' do
        page.should_not have_content suggested_dream1.dream.title
        page.should_not have_content suggested_dream1.receiver.full_name

        page.should have_content suggested_dream2.dream.title
        page.should have_content suggested_dream2.receiver.full_name
      end
    end
  end
end