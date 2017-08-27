RSpec.shared_examples 'static pages' do

  let!(:static_page1) { FactoryGirl.create(:static_page) }
  let!(:static_page2) { FactoryGirl.create(:static_page) }

  before(:each) do
    visit admin_static_pages_path
  end

  describe 'index page' do
    specify do
      page.should have_content 'Static Pages'
      within '#index_table_static_pages' do
        page.should have_content static_page1.title_ru
        page.should have_content static_page1.title_en
        page.should have_content static_page1.slug
        page.should have_content static_page1.body_en.to_s.truncate(30)
        page.should have_content static_page1.body_ru.to_s.truncate(30)

        page.should have_content static_page2.title_en
      end
    end
  end

  describe 'view page' do
    specify do
      within '#index_table_static_pages' do
        within "#static_page_#{static_page1.id}" do
          click_on 'View'
        end
      end

      page.should have_content static_page1.title_ru
      page.should have_content static_page1.title_en
      page.should have_content static_page1.slug
      page.should have_content static_page1.body_en.to_s
      page.should have_content static_page1.body_ru.to_s

      page.should_not have_content static_page2.title_en
    end
  end

  describe 'edit page' do
    specify do
      within '#index_table_static_pages' do
        within "#static_page_#{static_page1.id}" do
          click_on 'Edit'
        end
      end
      page.should have_content 'Edit Static Page'
      within 'form#edit_static_page' do
        fill_in 'static_page_title_en', with: 'New static_page title_en'
        fill_in 'static_page_title_ru', with: 'New static_page title_ru'
        fill_in 'static_page_slug', with: 'New static_page slug'
        fill_in 'static_page_body_en', with: 'New static_page body_en'
        fill_in 'static_page_body_ru', with: 'New static_page body_ru'
      end
      click_on 'Update Static page'
      page.should have_content 'Static page was successfully updated.'
      page.should have_content 'New static_page title_en'
    end
  end

  describe '#create' do
    specify do
      click_on 'New Static Page'

      page.should have_content 'New Static Page'
      within 'form#new_static_page' do
        fill_in 'static_page_title_en', with: 'New static_page title_en'
        fill_in 'static_page_title_ru', with: 'New static_page title_ru'
        fill_in 'static_page_slug', with: 'New static_page slug'
        fill_in 'static_page_body_en', with: 'New static_page body_en'
        fill_in 'static_page_body_ru', with: 'New static_page body_ru'
      end
      click_on 'Create Static page'
      page.should have_content 'Static page was successfully created.'
      page.should have_content 'New static_page title_en'
    end
  end

  describe '#delete' do
    specify do
      within '#index_table_static_pages' do
        within "#static_page_#{static_page1.id}" do
          click_on 'Delete'
        end
      end
      page.should have_content 'Static page was successfully destroyed.'
      within '#index_table_static_pages' do
        page.should_not have_content static_page1.title_en
        page.should have_content static_page2.title_en
      end
    end
  end

  describe 'visiting page' do
    before do
      visit "/#{static_page1.slug}"
    end
    specify do
      page.should have_content static_page1.title
      page.should have_content static_page1.body
    end
  end
end