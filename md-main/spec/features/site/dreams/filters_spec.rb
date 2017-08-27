require 'rails_helper'

describe 'Dreams', js: true do
  let!(:male_dreamer) { FactoryGirl.create(:dreamer, gender: 'male') }
  let!(:female_dreamer) { FactoryGirl.create(:dreamer, gender: 'female') }

  let!(:female_dream) { FactoryGirl.create(:admin_accepted_dream, dreamer: female_dreamer, comments_count: 2) }
  let!(:male_dream) { FactoryGirl.create(:admin_accepted_dream, dreamer: male_dreamer, comments_count: 4) }
  let!(:popular_dream) { FactoryGirl.create(:admin_accepted_dream, comments_count: 5) }

  let!(:top_dream) { FactoryGirl.create(:top_dream) }

  before do
    sign_in_as_dreamer
  end

  describe 'list' do
    context 'user without friends' do
      before do
        visit dreams_path
      end
      specify do
        page.should have_content top_dream.title

        page.should_not have_content female_dream.title
        page.should_not have_content male_dream.title
        page.should_not have_content popular_dream.title

        within '.content-tabs' do
          click_on 'Female TOP-50'
        end
        page.should_not have_content top_dream.title
        page.should_not have_content male_dream.title
        page.find('[data-type=dream]:nth-child(1)').should have_content female_dream.title

        within '.content-tabs' do
          click_on 'Male TOP-50'
        end

        page.should_not have_content top_dream.title
        page.should_not have_content female_dream.title
        page.find('[data-type=dream]:nth-child(1)').should have_content male_dream.title

        within '.content-tabs' do
          click_on 'Most discussed'
        end

        page.should_not have_content top_dream.title
        page.find('[data-type=dream]:nth-child(1)').should have_content popular_dream.title
        page.find('[data-type=dream]:nth-child(2)').should have_content male_dream.title
        page.find('[data-type=dream]:nth-child(3)').should have_content female_dream.title

        within '.content-tabs' do
          click_on 'New'
        end
        page.should_not have_content top_dream.title
        page.find('[data-type=dream]:nth-child(1)').should have_content popular_dream.title
        page.find('[data-type=dream]:nth-child(2)').should have_content male_dream.title
        page.find('[data-type=dream]:nth-child(3)').should have_content female_dream.title
      end
    end
  end
end
