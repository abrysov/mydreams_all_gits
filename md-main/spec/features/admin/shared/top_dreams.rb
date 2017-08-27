RSpec.shared_examples 'top dreams' do

  102.times do |n|
    let!("top_dream#{n}".to_sym) { FactoryGirl.create(:top_dream) }
  end

  before(:each) do
        visit admin_top_dreams_path
  end

  describe 'index page' do
    specify do
      page.should have_content 'Top Dreams'
      within '#index_table_top_dreams' do
        within "#top_dream_#{top_dream0.id}" do
          page.should have_content top_dream0.title
          page.should have_content top_dream0.description
          within '.col-top_100' do
            page.should have_content 'Yes'
          end
        end
        within "#top_dream_#{top_dream1.id}" do
          page.should have_content top_dream1.title
          page.should have_content top_dream1.description
          within '.col-top_100' do
            page.should have_content 'Yes'
          end
        end
        within "#top_dream_#{top_dream100.id}" do
          page.should have_content top_dream100.title
          page.should have_content top_dream100.description
          within '.col-top_100' do
            page.should have_content 'No'
          end
        end
      end
    end
  end

  describe 'view page' do
    specify do
      within '#index_table_top_dreams' do
        within "#top_dream_#{top_dream0.id}" do
          click_on 'View'
        end
      end

      page.should have_content top_dream0.title
      page.should have_content top_dream0.description
    end
  end

  describe 'edit page' do
    specify do
      within '#index_table_top_dreams' do
        within "#top_dream_#{top_dream0.id}" do
          click_on 'Edit'
        end
      end
      page.should have_content 'Edit Top Dream'
      within 'form#edit_top_dream' do
        fill_in 'top_dream_title', with: 'New top dream title'
      end
      click_on 'Update Top dream'
      page.should have_content 'New top dream title'
    end
  end

  describe '#create' do
    specify do
      click_on 'New Top Dream'

      page.should have_content 'New Top Dream'
      within 'form#new_top_dream' do
        fill_in 'top_dream_title', with: 'New title val'
        fill_in 'top_dream_description', with: 'New description val'
      end
      click_on 'Create Top dream'
      page.should have_content 'New title val'
      page.should have_content 'New description val'
    end
  end

  describe '#delete' do
    specify do
      within '#index_table_top_dreams' do
        within "#top_dream_#{top_dream0.id}" do
          click_on 'Delete'
        end
      end
      within '#index_table_top_dreams' do
        page.should_not have_content top_dream0.title
        page.should_not have_content top_dream0.description

        page.should have_content top_dream2.title
        page.should have_content top_dream2.description
      end
    end
  end
end