require 'rails_helper'

describe 'Dreamers list', js: true do

  describe 'list' do
    9.times do |n|
      let!("dreamer#{n}") { FactoryGirl.create(:light_dreamer) }
    end

    context 'guest' do
      before do
        visit dreamers_path
      end
      specify do
        within '.card_group.group' do
          page.should have_content dreamer8.full_name
          page.should have_content dreamer7.full_name
          page.should have_content dreamer1.full_name
          page.should_not have_content dreamer0.full_name
        end
        page.should have_css '.pagination'
        within '.pagination' do
          click_on '2'
        end
        within '.card_group.group' do
          page.should have_content dreamer0.full_name
          page.should_not have_content dreamer1.full_name
          page.should_not have_content dreamer8.full_name
        end
      end
    end

    context 'authenticated dreamer' do
      before do
        sign_in_as_dreamer(dreamer8)
        visit dreamers_path
      end
      specify do
        within '.card_group.group' do
          page.should_not have_content dreamer8.full_name
          page.should have_content dreamer0.full_name
          page.should have_content dreamer7.full_name
        end
        page.should_not have_css '.pagination'
      end
    end
  end

  describe 'search' do
    let!(:dreamer1) { FactoryGirl.create(:dreamer) }
    let!(:dreamer2) { FactoryGirl.create(:dreamer) }

    before do
      visit dreamers_path
    end
    specify do
      fill_in 'search', with: dreamer1.full_name
      page.find('label.fast_search__btn').click

      page.should have_content dreamer1.full_name
      page.should_not have_content dreamer2.full_name
    end
  end

  describe 'filter' do
    let!(:young_male_dreamer) { FactoryGirl.create(:young_male_dreamer, visits_count: 4) }
    let!(:old_female_dreamer) { FactoryGirl.create(:old_female_dreamer, visits_count: 2) }
    let!(:vip_dreamer) { FactoryGirl.create(:vip_dreamer, visits_count: 7) }
    let!(:online_dreamer) { FactoryGirl.create(:online_dreamer) }

    before do
      visit dreamers_path
    end
    specify do
      within '.header + .container' do
        page.should have_content young_male_dreamer.full_name
        page.should have_content old_female_dreamer.full_name
        page.should have_content vip_dreamer.full_name
        page.should have_content online_dreamer.full_name
        within '.content-tabs' do
          click_on 'Online'
        end
        page.should have_content online_dreamer.full_name
        page.should_not have_content young_male_dreamer.full_name
        page.should_not have_content old_female_dreamer.full_name
        page.should_not have_content vip_dreamer.full_name
        within '.content-tabs' do
          click_on 'VIP'
        end
        page.should have_content vip_dreamer.full_name
        page.should_not have_content online_dreamer.full_name
        page.should_not have_content young_male_dreamer.full_name
        page.should_not have_content old_female_dreamer.full_name
        within '.content-tabs' do
          click_on 'Top'
        end
        page.find('[data-type=dreamer]:nth-child(1)').should have_content vip_dreamer.full_name
        page.find('[data-type=dreamer]:nth-child(2)').should have_content young_male_dreamer.full_name
        page.find('[data-type=dreamer]:nth-child(3)').should have_content old_female_dreamer.full_name
        page.find('[data-type=dreamer]:nth-child(4)').should have_content online_dreamer.full_name
        within '.content-tabs' do
          click_on 'New'
        end
        page.find('[data-type=dreamer]:nth-child(1)').should have_content online_dreamer.full_name
        page.find('[data-type=dreamer]:nth-child(2)').should have_content vip_dreamer.full_name
        page.find('[data-type=dreamer]:nth-child(3)').should have_content old_female_dreamer.full_name
        page.find('[data-type=dreamer]:nth-child(4)').should have_content young_male_dreamer.full_name
      end
    end
  end
end
