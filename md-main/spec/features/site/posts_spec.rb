require 'rails_helper'

describe 'Posts', js: true do
  let!(:dreamer1) { FactoryGirl.create(:dreamer) }
  let!(:post1) { FactoryGirl.create(:post, dreamer: dreamer1) }

  describe 'guest' do
    describe '#index' do
      before do
        visit destroy_dreamer_session_path
        visit account_posts_path(dreamer_id: dreamer1.id, locale: :en)
      end
      specify do
        page.should have_content post1.title
      end
    end
    describe '#new' do
      before { visit new_account_post_path }
      specify do
        current_path.should be == new_dreamer_session_path
      end
    end
  end

  describe 'auth user' do
    let!(:post2) { FactoryGirl.create(:post) }

    before do
      sign_in_as_dreamer(dreamer1)
    end

    describe '#index' do
      before do
        visit account_dreamer_posts_path(dreamer1, locale: :en)
      end

      specify do
        page.should have_content post1.title
        page.should_not have_content post2.title
      end
    end

    describe '#new' do
      before do
        visit new_account_dreamer_post_path(dreamer1, locale: :en)
      end
      context 'success' do
        specify do
          within 'form#new_post' do
            fill_in 'post[title]', with: 'valid title'
            fill_in_ckeditor 'post_body', with: 'valid body'
          end
          page.find('.form_btn.form_btn-yellow').click
          page.should_not have_css '.text-danger'
          page.should have_content 'valid title'
          page.should have_content post1.title
          page.should_not have_content post2.title
        end
      end

      context 'success' do
        specify do
          page.find('.form_btn.form_btn-yellow').click
          page.should have_css '.text-danger'
        end
      end
    end
  end
end
