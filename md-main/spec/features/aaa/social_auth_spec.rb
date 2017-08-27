require 'rails_helper'

describe 'Social network loginization', js: true do
  # before do
  #   visit destroy_dreamer_session_path
  #   visit root_path
  # end
  #
  # describe 'twitter' do
  #   context 'with errors' do
  #     specify do
  #       within '.sm_group' do
  #         page.find('.sm_enter__item[data-type=twitter]').click
  #       end
  #       fill_in 'session[username_or_email]', with: 'wvq34341@cdnqa.com'
  #       fill_in 'session[password]', with: 'evrone2010'
  #       click_on 'Sign In'
  #       sleep 2
  #       current_path.should be == data_lack_dreamers_path(locale: :en)
  #       page.should have_content 'Data Lack'
  #
  #       page.find('#submit').click
  #
  #       page.should have_content 'Data Lack'
  #       current_path.should be == save_data_lack_dreamers_path(locale: :en)
  #       current_path.should_not be == account_root_path(locale: :en)
  #     end
  #   end
  #
  #   context 'new dreamer' do
  #     specify do
  #       within '.sm_group' do
  #         page.find('.sm_enter__item[data-type=twitter]').click
  #       end
  #       # fill_in 'session[username_or_email]', with: 'wvq34341@cdnqa.com'
  #       # fill_in 'session[password]', with: 'evrone2010'
  #       # click_on 'Sign In'
  #       sleep 2
  #       current_path.should be == data_lack_dreamers_path(locale: :en)
  #       page.should have_content 'Data Lack'
  #
  #       fill_in 'dreamer[email]', with: 'new_email@mail.ru'
  #       fill_in 'dreamer[birthday]', with: '10-10-2015'
  #       attach_file 'dreamer[avatar]', FactoryHelpers::random_fixture_image
  #
  #       page.find('#submit').click
  #
  #       page.should_not have_content 'Data Lack'
  #       current_path.should be == account_root_path(locale: :en)
  #     end
  #   end
  #
  #   context 'existing dreamer' do
  #     let!(:twitter_dreamer) { FactoryGirl.create(:twitter_dreamer) }
  #
  #     specify do
  #       within '.sm_group' do
  #         page.find('.sm_enter__item[data-type=twitter]').click
  #       end
  #
  #       page.should_not have_content 'Data Lack'
  #       current_path.should be == account_root_path(locale: :en)
  #     end
  #   end
  # end
end