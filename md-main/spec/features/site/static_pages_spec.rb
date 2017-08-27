require 'rails_helper'

describe 'Static Pages', js: true do
  let!(:static_page1) { FactoryGirl.create(:static_page) }
  let!(:static_page2) { FactoryGirl.create(:static_page) }

  before do
    visit static_page_path(static_page1.slug, locale: :en)
  end

  specify do
    page.should have_content static_page1.title_en
    page.should have_content static_page1.body_en
    page.should_not have_content static_page2.title_en
    page.should_not have_content static_page2.body_en
  end
end