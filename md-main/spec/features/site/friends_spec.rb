require 'rails_helper'

describe 'Friends', js: true do
  let!(:me) { FactoryGirl.create(:dreamer) }
  let!(:dreamer2) { FactoryGirl.create(:dreamer) }

  before do
    sign_in_as_dreamer(me)
  end

  context 'without friends' do
    before do
      visit account_friends_path
    end
    specify do
      page.should have_content 'You have no friends'
      page.should_not have_content dreamer2.first_name
    end
  end

  context 'with friends' do
    let!(:dreamer3) { FactoryGirl.create(:dreamer) }
    let!(:dreamer4) { FactoryGirl.create(:dreamer) }
    let!(:dream1) { FactoryGirl.create(:dream, dreamer: dreamer4) }
    let!(:dream2) { FactoryGirl.create(:dream, dreamer: dreamer4) }
    let!(:dream3) { FactoryGirl.create(:dream, dreamer: dreamer4) }
    let!(:dream4) { FactoryGirl.create(:dream, dreamer: dreamer4) }

    before do
      FactoryGirl.create(:friendship, dreamer: me, friend: dreamer3)
      FactoryGirl.create(:accepted_friendship, dreamer: me, friend: dreamer2)
      FactoryGirl.create(:accepted_friendship, dreamer: me, friend: dreamer4)

      visit account_friends_path
    end

    specify do
      page.should have_content '2 friends'
    end
  end
end