RSpec.shared_examples 'not dreamers' do

  let!(:dreamer1) { FactoryGirl.create(:dreamer) }

  before(:each) do
    visit admin_dreamers_path
  end

  describe 'index page' do
    specify do
      page.should_not have_content 'Dreamers'
      page.should_not have_css '#index_table_dreamers'
      page.should_not have_content dreamer1.email
      page.should_not have_content dreamer1.first_name
      page.should_not have_content dreamer1.last_name
    end
  end

  describe 'view' do
    before do
      visit admin_dreamer_path(dreamer1)
    end
    specify do
      page.should_not have_content 'Dreamers'
      page.should_not have_css '#index_table_dreamers'
      page.should_not have_content dreamer1.email
      page.should_not have_content dreamer1.first_name
      page.should_not have_content dreamer1.last_name
    end
  end

  describe 'edit' do
    before do
      visit edit_admin_dreamer_path(dreamer1)
    end
    specify do
      page.should_not have_content 'Dreamers'
      page.should_not have_css '#index_table_dreamers'
      page.should_not have_content dreamer1.email
      page.should_not have_content dreamer1.first_name
      page.should_not have_content dreamer1.last_name
    end
  end
end