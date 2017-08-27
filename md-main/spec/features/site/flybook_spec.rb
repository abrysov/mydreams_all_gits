require 'rails_helper'

describe 'Landing', js: true do
  let!(:dreamer) { FactoryGirl.create(:dreamer) }
  let!(:dream) { FactoryGirl.create(:dream, dreamer: dreamer) }
  let!(:accepted_friendship) { FactoryGirl.create(:accepted_friendship, dreamer: dreamer) }

  before do
    sign_in_as_dreamer(dreamer)
    visit flybook_dreamer_path(id: dreamer.id, locale: :en)
  end

  describe 'Header' do
    specify do
      within '.flybook' do
        page.should have_content dreamer.first_name
        within '.avatar__about__location' do
          page.should have_content dreamer.dream_city.name
          page.should have_content dreamer.dream_country.name
        end
        within '.avatar__about__age' do
          page.should have_content '20 years'
        end
        within '.activity__dreams' do
          page.should have_content 1
        end
        within '.account-info' do
          page.should have_content 'Friends 1'
        end
      end
    end
  end

  describe 'Content' do
    let!(:suggested_dream) { FactoryGirl.create(:suggested_dream, receiver: dreamer) }
    let!(:accepted_suggested_dream) { FactoryGirl.create(:accepted_suggested_dream, receiver: dreamer) }

    before do
      visit flybook_dreamer_path(id: dreamer.id, locale: :en)
    end

    specify do
      within '.main__content' do
        page.should have_content suggested_dream.title
        page.should have_content Date.today.strftime('%d %B %Y')
        page.should_not have_content accepted_suggested_dream.title

        within '.dream_owner' do
          page.should have_content dream.title
          page.should have_content Date.today.strftime('%d %B %Y')
        end
      end
    end
  end

  describe 'Navigation' do
    context 'data set 1' do
      specify do
        # Dreams
        within '#dreams_counter' do
          page.should have_content 1
        end
        within '#new_dreams_counter' do
          page.should have_content 0
        end
        # Friend Dreams
        within '#friend_dreams_counter' do
          page.should have_content 0
        end
        within '#new_friend_dreams_counter' do
          page.should have_content 0
        end
        # Messages
        within '#messages_counter' do
          page.should have_content 0
        end
        within '#new_messages_counter' do
          page.should have_content 0
        end
        # Friends
        within '#friends_counter' do
          page.should have_content 1
        end
        within '#new_friends_counter' do
          page.should have_content 0
        end
      end
    end

    context 'data set 2' do
      let!(:other_dreamer) { FactoryGirl.create(:dreamer) }
      let!(:dream) { FactoryGirl.create(:dream, dreamer: dreamer) }

      let!(:message) { FactoryGirl.create(:message, sender: other_dreamer, receiver: dreamer) }
      let!(:read_message) { FactoryGirl.create(:read_message, sender: other_dreamer, receiver: dreamer) }

      let!(:suggested_dream) { FactoryGirl.create(:suggested_dream, receiver: dreamer) }
      let!(:accepted_suggested_dream) { FactoryGirl.create(:accepted_suggested_dream, receiver: dreamer) }

      let!(:friendship) { FactoryGirl.create(:friendship, friend: dreamer) }
      let!(:accepted_friendship) { FactoryGirl.create(:accepted_friendship, dreamer: dreamer) }

      before do
        visit flybook_dreamer_path(id: dreamer.id, locale: :en)
      end

      specify do
        # Dreams
        within '#dreams_counter' do
          page.should have_content 1
        end
        within '#new_dreams_counter' do
          page.should have_content 1
        end
        # Friend Dreams
        within '#friend_dreams_counter' do
          page.should have_content 0
        end
        # page.should_not have_css '#new_friend_dreams_counter'
        # Messages
        within '#messages_counter' do
          page.should have_content 1
        end
        within '#new_messages_counter' do
          page.should have_content 1
        end
        # Friends
        within '#friends_counter' do
          page.should have_content 1
        end
        within '#new_friends_counter' do
          page.should have_content 1
        end
      end
    end
  end
end
