require 'rails_helper'

describe 'Photos list', js: true do

  describe 'list' do
    let!(:dreamer1) { FactoryGirl.create(:dreamer) }
    let!(:photo1) { FactoryGirl.create(:photo, dreamer: dreamer1) }

    context 'guest' do
      specify do
        visit dreamer_photos_path(dreamer_id: dreamer1.id, locale: :en)
        page.should have_content photo1.caption
        visit new_dreamer_photo_path(dreamer_id: dreamer1.id, locale: :en)
        current_path.should be == new_dreamer_session_path
        page.should have_content 'You need to sign in or sign up before continuing.'

        visit edit_dreamer_photo_path(dreamer_id: dreamer1.id, locale: :en, id: photo1.id)
        current_path.should be == new_dreamer_session_path
        page.should have_content 'You need to sign in or sign up before continuing.'
      end
    end

    describe 'authenticated dreamer' do
      before do
        sign_in_as_dreamer(dreamer1)
      end
      describe 'index' do
        specify do
          visit dreamer_photos_path(dreamer_id: dreamer1.id, locale: :en)
          page.should have_content photo1.caption
          visit new_dreamer_photo_path(dreamer_id: dreamer1.id, locale: :en)
          current_path.should be == new_dreamer_photo_path(dreamer_id: dreamer1.id, locale: :en)
        end
      end

      describe 'edit' do
        specify do
          visit edit_dreamer_photo_path(dreamer_id: dreamer1.id, locale: :en, id: photo1.id)
          fill_in 'photo[caption]', with: 'New photo caption'
          within "#edit_photo_#{photo1.id}" do
            page.find('input[type=submit]').click
          end

          visit dreamer_photos_path(dreamer_id: dreamer1.id, locale: :en)
          page.should have_content 'New photo caption'
        end
      end

      describe 'delete' do
        specify do
          visit dreamer_photos_path(dreamer_id: dreamer1.id, locale: :en)
          page.find('a.btn-danger[data-method=delete]').click
          page.driver.browser.switch_to.alert.accept
          page.should_not have_content photo1.caption
        end
      end
    end
  end
end
