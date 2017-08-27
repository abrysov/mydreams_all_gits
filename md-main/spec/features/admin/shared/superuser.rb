RSpec.shared_examples 'superusers' do

  let!(:dreamer1) { FactoryGirl.create(:dreamer) }
  let!(:dreamer2) { FactoryGirl.create(:dreamer) }

  let!(:dream1) { FactoryGirl.create(:dream, dreamer: dreamer1) }

  before(:each) do
    visit admin_superuser_path
  end

  describe 'become' do
    specify do
      page.should have_content 'Superuser'
      select dreamer1.full_name, from: 'entity_id'
      click_on 'Login'
      current_path.should be == root_path
      # session['warden.user.dreamer.key'][0][0].should be == dreamer1.id
      visit account_dreamer_dreams_path(dreamer1, locale: :en)
      page.should have_content dream1.title
    end
  end
end