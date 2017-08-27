RSpec.shared_examples 'dreamer cities' do
  let!(:city1) { FactoryGirl.create(:dream_city) }
  let!(:city2) { FactoryGirl.create(:dream_city) }

  before(:each) do
    visit admin_dreamer_cities_path
  end

  describe 'index page' do
    specify do
      page.should have_content 'Dreamer Cities'
      within '#index_table_dreamer_cities' do
        page.should have_content city1.name_ru
        page.should have_content city1.name_en
        page.should have_content city1.dream_country.name_en
        page.should have_content city2.name_en
      end
    end
  end

  describe 'view page' do
    specify do
      within '#index_table_dreamer_cities' do
        within "#dream_city_#{city1.id}" do
          click_on 'View'
        end
      end

      page.should have_content city1.name_ru
      page.should have_content city1.name_en
      page.should have_content city1.dream_country.name_en
      page.should_not have_content city2.name_en
    end
  end

  describe 'edit page' do
    let!(:other_country) { FactoryGirl.create(:dream_country) }

    specify do
      within '#index_table_dreamer_cities' do
        within "#dream_city_#{city1.id}" do
          click_on 'Edit'
        end
      end
      page.should have_content 'Edit Dreamer City'
      within 'form#edit_dream_city' do
        fill_in 'dream_city_name_ru', with: 'New dreamer city name ru'
        fill_in 'dream_city_name_en', with: 'New dreamer city name en'
        select other_country.name, from: 'dream_city_country_id'
      end
      click_on 'Update Dreamer city'
      page.should have_content 'Dreamer city was successfully updated.'
      page.should have_content 'New dreamer city name ru'
      page.should have_content 'New dreamer city name en'
      page.should have_content other_country.name
    end
  end

  describe '#create' do
    let!(:other_country) { FactoryGirl.create(:dream_country) }
    specify do
      click_on 'New Dreamer City'

      page.should have_content 'New Dreamer City'
      within 'form#new_dream_city' do
        fill_in 'dream_city_name_ru', with: 'New dreamer city name ru 2'
        fill_in 'dream_city_name_en', with: 'New dreamer city name en 2'
        select other_country.name, from: 'dream_city_country_id'
      end
      click_on 'Create Dreamer city'
      page.should have_content 'Dreamer city was successfully created.'
      page.should have_content 'New dreamer city name ru 2'
      page.should have_content 'New dreamer city name en 2'
    end
  end

  describe '#delete' do
    specify do
      within '#index_table_dreamer_cities' do
        within "#dream_city_#{city1.id}" do
          click_on 'Delete'
        end
      end
      page.should have_content 'Dreamer city was successfully destroyed.'
      within '#index_table_dreamer_cities' do
        page.should_not have_content city1.name_ru

        page.should have_content city2.name_ru
      end
    end
  end
end
