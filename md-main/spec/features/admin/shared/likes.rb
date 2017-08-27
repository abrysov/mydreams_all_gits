RSpec.shared_examples 'likes' do

  let!(:dreamer1) { FactoryGirl.create(:dreamer) }
  let!(:dreamer2) { FactoryGirl.create(:dreamer) }

  let!(:dream1) { FactoryGirl.create(:dream, dreamer: dreamer1) }
  let!(:dream2) { FactoryGirl.create(:dream, dreamer: dreamer2) }

  let!(:like1) { FactoryGirl.create(:like, likeable: dream1) }
  let!(:like2) { FactoryGirl.create(:like, likeable: dream2) }

  before(:each) do
    visit admin_likes_path
  end

  describe 'index page' do
    specify do
      page.should have_content 'Likes'
      within '#index_table_likes' do
        page.should have_content dream2.title
        page.should have_content like1.dreamer.full_name

        page.should have_content like2.dreamer.full_name
      end
    end
  end

  describe '#delete' do
    specify do
      within '#index_table_likes' do
        within "#like_#{like1.id}" do
          click_on 'Delete'
        end
      end
      page.should have_content 'Like was successfully destroyed.'
      within '#index_table_likes' do
        page.should_not have_content dream1.title
        page.should_not have_content like1.dreamer.full_name

        page.should have_content dream2.title
      end
    end
  end
end