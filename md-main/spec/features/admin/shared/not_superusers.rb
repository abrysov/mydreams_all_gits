RSpec.shared_examples 'not superusers' do

  let!(:dreamer1) { FactoryGirl.create(:dreamer) }

  before(:each) do
    visit admin_superuser_path
  end

  describe 'index page' do
    specify do
      page.should_not have_content 'Superuser'
    end
  end
end