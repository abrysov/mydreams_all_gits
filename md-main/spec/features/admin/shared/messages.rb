RSpec.shared_examples 'messages' do

  let!(:message) { FactoryGirl.create(:message) }
  let!(:read_message) { FactoryGirl.create(:read_message) }

  before(:each) do
    visit admin_messages_path
  end

  describe 'index page' do
    specify do
      page.should have_content 'Messages'
      within '#index_table_messages' do
        page.should have_content message.message.to_s.truncate(30)
        page.should have_content message.sender.full_name
        page.should have_content message.receiver.full_name

        page.should have_content read_message.message.to_s.truncate(30)
      end
    end
  end

  describe 'view page' do
    specify do
      within '#index_table_messages' do
        within "#message_#{message.id}" do
          click_on 'View'
        end
      end

      page.should have_content message.message
      page.should have_content message.sender.full_name
      page.should have_content message.receiver.full_name

      page.should_not have_content read_message.message
    end
  end

  describe 'edit page' do
    specify do
      within '#index_table_messages' do
        within "#message_#{message.id}" do
          click_on 'Edit'
        end
      end
      page.should have_content 'Edit Message'
      within 'form#edit_message' do
        fill_in 'message_message', with: 'New message message'
        select read_message.sender.full_name, from: 'Sender'
        select read_message.receiver.full_name, from: 'Receiver'
      end
      click_on 'Update Message'
      page.should have_content 'Message was successfully updated.'

      page.should have_content read_message.sender.full_name
      page.should have_content read_message.receiver.full_name
    end
  end

  describe '#create' do
    let!(:other_dreamer1) { FactoryGirl.create(:dreamer) }
    let!(:other_dreamer2) { FactoryGirl.create(:dreamer) }
    specify do
      click_on 'New Message'

      page.should have_content 'New Message'
      within 'form#new_message' do
        fill_in 'message_message', with: 'New message message 3'
        select other_dreamer1.full_name, from: 'Sender'
        select other_dreamer2.full_name, from: 'Receiver'
      end
      click_on 'Create Message'
      page.should have_content 'Message was successfully created.'
      page.should have_content 'New message message 3'
      page.should have_content other_dreamer1.full_name
      page.should have_content other_dreamer2.full_name
    end
  end

  describe '#delete' do
    specify do
      within '#index_table_messages' do
        within "#message_#{message.id}" do
          click_on 'Delete'
        end
      end
      page.should have_content 'Message was successfully destroyed.'
      within '#index_table_messages' do
        page.should_not have_content message.message.to_s.truncate(30)
        page.should have_content read_message.message.to_s.truncate(30)
      end
    end
  end
end