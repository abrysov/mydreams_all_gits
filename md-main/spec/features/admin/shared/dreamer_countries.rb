RSpec.shared_examples 'dreamer countries' do

  let!(:country1) { FactoryGirl.create(:dreamer_country) }
  let!(:country2) { FactoryGirl.create(:dreamer_country) }

  before(:each) do
    visit admin_dreamer_countries_path
  end

  describe 'index page' do
    specify do
      page.should have_content 'Dreamer Countries'
      within '#index_table_dreamer_countries' do
        page.should have_content country1.name_ru
        page.should have_content country1.name_en
        page.should have_content country2.name_en
      end
    end
  end

  describe 'view page' do
    specify do
      within '#index_table_dreamer_countries' do
        within "#dreamer_country_#{country1.id}" do
          click_on 'View'
        end
      end

      page.should have_content country1.name_ru
      page.should have_content country1.name_en
      page.should_not have_content country2.name_en
    end
  end

  describe 'edit page' do
    let!(:other_country) { FactoryGirl.create(:dreamer_country) }

    specify do
      within '#index_table_dreamer_countries' do
        within "#dreamer_country_#{country1.id}" do
          click_on 'Edit'
        end
      end
      page.should have_content 'Edit Dreamer Country'
      within 'form#edit_dreamer_country' do
        fill_in 'dreamer_country_name_ru', with: 'New dreamer country name ru'
        fill_in 'dreamer_country_name_en', with: 'New dreamer country name en'
      end
      click_on 'Update Dreamer country'
      page.should have_content 'Dreamer country was successfully updated.'
      page.should have_content 'New dreamer country name ru'
      page.should have_content 'New dreamer country name en'
    end
  end

  describe '#create' do
    specify do
      click_on 'New Dreamer Country'

      page.should have_content 'New Dreamer Country'
      within 'form#new_dreamer_country' do
        fill_in 'dreamer_country_name_ru', with: 'New dreamer country name ru 2'
        fill_in 'dreamer_country_name_en', with: 'New dreamer country name en 2'
      end
      click_on 'Create Dreamer country'
      page.should have_content 'Dreamer country was successfully created.'
      page.should have_content 'New dreamer country name ru 2'
      page.should have_content 'New dreamer country name en 2'
    end
  end

  describe '#delete' do
    specify do
      within '#index_table_dreamer_countries' do
        within "#dreamer_country_#{country1.id}" do
          click_on 'Delete'
        end
      end
      page.should have_content 'Dreamer country was successfully destroyed.'
      within '#index_table_dreamer_countries' do
        page.should_not have_content country1.name_ru

        page.should have_content country2.name_ru
      end
    end
  end
end