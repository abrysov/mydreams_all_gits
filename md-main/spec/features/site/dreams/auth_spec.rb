require 'rails_helper'

describe 'Dreams', js: true do
  let!(:dreamer) { FactoryGirl.create(:dreamer) }
  let!(:everyone_allowed_dream) { FactoryGirl.create(:everyone_allowed_dream) }
  let!(:friends_allowed_dream) { FactoryGirl.create(:friends_allowed_dream) }
  let!(:nobody_allowed_dream) { FactoryGirl.create(:nobody_allowed_dream) }
  let!(:my_forbiden_dream) { FactoryGirl.create(:nobody_allowed_dream, dreamer: dreamer) }

  before do
    sign_in_as_dreamer(dreamer)
  end

  # describe 'list' do
  #   context 'user without friends' do
  #     let!(:my_dream) { FactoryGirl.create(:dream, dreamer: dreamer) }
  #     before do
  #       visit dreams_path
  #     end
  #     specify do
  #       page.should have_content my_dream.title
  #       page.should have_content everyone_allowed_dream.title
  #       page.should_not have_content friends_allowed_dream.title
  #       page.should_not have_content nobody_allowed_dream.title
  #     end
  #   end
  #
  #   context 'user with friends' do
  #     let!(:friend) { FactoryGirl.create(:dreamer) }
  #     let!(:friend_dream) { FactoryGirl.create(:dream, dreamer: friend) }
  #     let!(:forbiden_friend_dream) { FactoryGirl.create(:nobody_allowed_dream, dreamer: friend) }
  #
  #     let!(:accepted_friendship) { FactoryGirl.create(:accepted_friendship, dreamer: dreamer, friend: friend) }
  #
  #     before do
  #       visit dreams_path
  #     end
  #     specify do
  #       page.should have_content my_forbiden_dream.title
  #       page.should have_content everyone_allowed_dream.title
  #       page.should have_content friend_dream.title
  #       page.should_not have_content friends_allowed_dream.title
  #       page.should_not have_content nobody_allowed_dream.title
  #       page.should_not have_content forbiden_friend_dream.title
  #     end
  #   end
  # end

  describe 'show' do
    specify do
      visit account_dream_path(everyone_allowed_dream, locale: :en)
      page.should have_content everyone_allowed_dream.title
      page.find('[data-ctrl-type=share]').click
      page.should have_css '.sm_group'

      page.should have_css '[data-ctrl-type=borrow]'
      page.should have_css '[data-ctrl-type=like]'
      page.should have_css '[data-ctrl-type=recommend]'

      visit account_dream_path id: my_forbiden_dream.id
      page.should have_content my_forbiden_dream.title
      page.should_not have_css '.share_dream'

      visit account_dream_path id: friends_allowed_dream.id
      page.should_not have_content friends_allowed_dream.title
      page.should_not have_css '.share_dream'

      visit account_dream_path id: nobody_allowed_dream.id
      page.should_not have_content nobody_allowed_dream.title
      page.should_not have_css '.share_dream'
    end
  end

  describe '#like' do
    specify do
      visit account_dream_path id: everyone_allowed_dream.id
      within '.additional_data__likes' do
        page.should have_content 0
      end
      page.find('[data-ctrl-type=like]').click
      within '.additional_data__likes' do
        page.should have_content 1
      end
      page.find('[data-ctrl-type=like]').click
      within '.additional_data__likes' do
        page.should have_content 0
      end
    end
  end

  describe '#comments' do
    specify do
      visit account_dream_path id: everyone_allowed_dream.id
      within '.additional_data__comments' do
        page.should have_content 0
      end
    end
  end

  describe 'create' do
    context 'authenticated dreamer' do
      before do
        visit new_account_dream_path
      end
      specify do
        within '#new_dream' do
          fill_in 'dream[title]', with: 'Some dream title'
          fill_in 'dream[description]', with: 'Some dream description'
          fill_in 'dream[description]', with: 'Some dream description'
          # attach_file 'dream[photo]', FactoryHelpers::random_fixture_image
          page.find('.form_btn.form_btn-yellow').click
        end
        page.should have_content 'Some dream title'
      end
    end
  end
end
