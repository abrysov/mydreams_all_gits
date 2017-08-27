require 'rails_helper'

describe 'Dreams', js: true do
  let!(:everyone_allowed_dream) { FactoryGirl.create(:everyone_allowed_dream) }
  let!(:friends_allowed_dream) { FactoryGirl.create(:friends_allowed_dream) }
  let!(:nobody_allowed_dream) { FactoryGirl.create(:nobody_allowed_dream) }
  let(:error_message) { 'You need to sign in or sign up before continuing.' }

  describe '#index' do
    before { visit dreams_path }
    specify do
      # page.should have_content everyone_allowed_dream.title
      # page.should_not have_content friends_allowed_dream.title
      # page.should_not have_content nobody_allowed_dream.title
    end
  end

  describe '#show' do
    specify do
      visit account_dream_path id: everyone_allowed_dream.id
      page.should have_content everyone_allowed_dream.title

      page.should_not have_css '.sm_group'
      page.should_not have_css '[data-ctrls-type=share]'
      page.should_not have_css '[data-ctrls-type=borrow]'
      page.should_not have_css '[data-ctrls-type=like]'
      page.should_not have_css '[data-ctrls-type=recommend]'

      visit account_dream_path id: friends_allowed_dream.id
      page.should_not have_content friends_allowed_dream.title

      visit account_dream_path id: nobody_allowed_dream.id
      page.should_not have_content nobody_allowed_dream.title
    end
  end

  describe '#new' do
    before { visit new_account_dream_path }
    specify do
      page.should have_content error_message
    end
  end

  describe '#edit' do
    before { visit edit_account_dream_path(id: everyone_allowed_dream.id) }
    specify do
      page.should have_content error_message
    end
  end

  # describe '#delete' do
  #   before { visit account_dream_path(id: everyone_allowed_dream.id), method: :delete }
  #   specify do
  #     page.should have_content error_message
  #   end
  # end
end
