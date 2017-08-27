require 'rails_helper'

describe 'Landing', js: true do
  let!(:dreamer) { FactoryGirl.create(:dreamer) }
  let(:image) { FactoryHelpers::random_fixture_image }

  before do
    sign_in_as_dreamer(dreamer)
  end

  specify do
    page.should have_content 'Edit data'

    within "#edit_dreamer_#{dreamer.id}" do
      find_field('dreamer[first_name]').value.should eq dreamer.first_name
      find_field('dreamer[last_name]').value.should eq dreamer.last_name
      find_field('dreamer[birthday]').value.should eq 20.years.ago.strftime('%d-%m-%Y')
    end

    fill_in 'dreamer[first_name]', with: 'New First name'
    fill_in 'dreamer[last_name]', with: 'Last First name'
    fill_in 'dreamer[email]', with: 'new_email@example.com'
    fill_in 'dreamer[birthday]', with: '08-08-2008'
    # page.find('.ik_select_link_text:contains(Rossiya)').click
    # page.find('.ik_select_option:visible[data-value=3]').click
    fill_in 'dreamer[phone]', with: '(123) 123-12-12'
    attach_file 'dreamer[avatar]', image

    page.find('#submit').click

    within "#edit_dreamer_#{dreamer.id}" do
      find_field('dreamer[first_name]').value.should eq 'New First name'
      find_field('dreamer[last_name]').value.should eq 'Last First name'
    end

    page.should_not have_css '.text-danger'
    page.should have_selector("img[src$='#{dreamer.reload.avatar.url(:large)}']")
  end
end