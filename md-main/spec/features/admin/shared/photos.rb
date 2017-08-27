RSpec.shared_examples 'photos' do

  let!(:photo1) { FactoryGirl.create(:photo) }
  let!(:photo2) { FactoryGirl.create(:photo) }
  let!(:other_dreamer) { FactoryGirl.create(:dreamer) }

  before(:each) do
    visit admin_photos_path
  end

  describe 'index page' do
    specify do
      page.should have_content 'Photos'
      within '#index_table_photos' do
        page.should have_content photo1.caption
        page.should have_content photo1.file.url
        page.should have_content photo1.dreamer.full_name

        page.should have_content photo2.caption
        page.should have_content photo2.file.url
        page.should have_content photo2.dreamer.full_name
      end
    end
  end

  describe 'view page' do
    specify do
      within '#index_table_photos' do
        within "#photo_#{photo1.id}" do
          click_on 'View'
        end
      end

      page.should have_content photo1.caption
      page.should have_content photo1.file.url
      page.should have_content photo1.dreamer.full_name

      page.should_not have_content photo2.caption
    end
  end

  describe 'edit page' do
    specify do
      within '#index_table_photos' do
        within "#photo_#{photo1.id}" do
          click_on 'Edit'
        end
      end
      page.should have_content 'Edit Photo'
      within 'form#edit_photo' do
        fill_in 'photo_caption', with: 'New photo caption'
        select other_dreamer.full_name, from: 'Dreamer'
        attach_file 'photo_file', FactoryHelpers::random_fixture_image
      end
      click_on 'Update Photo'
      page.should have_content 'Photo was successfully updated.'
      page.should have_content 'New photo caption'
      page.should have_content other_dreamer.full_name
    end
  end

  describe '#create' do
    specify do
      click_on 'New Photo'

      page.should have_content 'New Photo'
      within 'form#new_photo' do
        fill_in 'photo_caption', with: 'New caption val'
        select photo2.dreamer.full_name, from: 'Dreamer'
        attach_file 'photo_file', FactoryHelpers::random_fixture_image
      end
      click_on 'Create Photo'
      page.should have_content 'Photo was successfully created.'
      page.should have_content 'New caption val'
      page.should have_content photo2.dreamer.full_name
    end
  end

  describe '#delete' do
    specify do
      within '#index_table_photos' do
        within "#photo_#{photo1.id}" do
          click_on 'Delete'
        end
      end
      page.should have_content 'Photo was successfully destroyed.'
      within '#index_table_photos' do
        page.should_not have_content photo1.caption
        page.should_not have_content photo1.dreamer.full_name

        page.should have_content photo2.caption
        page.should have_content photo2.dreamer.full_name
      end
    end
  end
end