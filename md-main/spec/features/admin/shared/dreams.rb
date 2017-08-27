RSpec.shared_examples 'dreams' do

  let!(:dream1) { FactoryGirl.create(:dream) }
  let!(:dream2) { FactoryGirl.create(:dream) }
  let!(:dream3) { FactoryGirl.create(:dream) }

  before(:each) do
    visit admin_dreams_path
  end

  describe 'index page' do
    specify do
      page.should have_content 'Dreams'
      within '#index_table_dreams' do
        page.should have_content dream1.title
        page.should have_content dream1.dreamer.full_name

        page.should have_content dream2.title
        page.should have_content dream2.dreamer.full_name
      end
    end
  end

  describe '#approve', js: true do
    let!(:not_approved_dream) { FactoryGirl.create(:not_approved_dream) }
    before { visit admin_dreams_path }
    specify do
      within '#index_table_dreams' do
        within "#dream_#{not_approved_dream.id}" do
          within '.col-needs_accepting' do
            page.should have_content 'YES'
          end
          click_on 'Подтвердить'
          within '.col-needs_accepting' do
            page.should have_content 'NO'
          end
        end
      end
    end
  end

  describe 'view page' do
    specify do
      within '#index_table_dreams' do
        within "#dream_#{dream1.id}" do
          click_on 'View'
        end
      end

      page.should have_content dream1.title
      page.should have_content dream1.description
      page.should have_content dream1.dreamer.full_name

      page.should_not have_content dream2.title
    end
  end

  describe 'edit page' do
    specify do
      within '#index_table_dreams' do
        within "#dream_#{dream1.id}" do
          click_on 'Edit'
        end
      end
      page.should have_content 'Edit Dream'
      within 'form#edit_dream' do
        fill_in 'dream_title', with: 'New dream title'
        attach_file 'dream_photo', FactoryHelpers::random_fixture_image
      end
      click_on 'Update Dream'
      page.should have_content 'Dream was successfully updated.'
      page.should have_content 'New dream title'
    end
  end

  describe '#create' do
    specify do
      click_on 'New Dream'

      page.should have_content 'New Dream'
      within 'form#new_dream' do
        fill_in 'dream_title', with: 'New title val'
        select dream2.dreamer.full_name, from: 'Dream'
        attach_file 'dream_photo', FactoryHelpers::random_fixture_image
      end
      click_on 'Create Dream'
      page.should have_content 'Dream was successfully created.'
      page.should have_content 'New title val'
      page.should have_content dream2.dreamer.full_name
    end
  end

  describe '#delete' do
    specify do
      within '#index_table_dreams' do
        within "#dream_#{dream1.id}" do
          click_on 'Delete'
        end
      end
      page.should have_content 'Dream was successfully destroyed.'
      within '#index_table_dreams' do
        page.should_not have_content dream1.title
        page.should_not have_content dream1.dreamer.full_name

        page.should have_content dream2.title
        page.should have_content dream2.dreamer.full_name
      end
    end
  end
end