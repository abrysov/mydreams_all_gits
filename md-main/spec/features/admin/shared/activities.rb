RSpec.shared_examples 'activities' do

  # let!(:message1) { FactoryGirl.create(:message) }
  # let!(:message2) { FactoryGirl.create(:message) }
  # let!(:attachment1) { FactoryGirl.create(:attachment, attachmentable: message1) }
  # let!(:attachment2) { FactoryGirl.create(:attachment, attachmentable: message2) }
  #
  # before(:each) do
  #   visit admin_attachments_path
  # end
  #
  # describe 'index page' do
  #   specify do
  #     page.should have_content 'Attachments'
  #     within '#index_table_attachments' do
  #       page.should have_content attachment1.file.url
  #       page.should have_content "Message ##{message1.id}"
  #
  #       page.should have_content attachment2.file.url
  #       page.should have_content "Message ##{message2.id}"
  #     end
  #   end
  # end
  #
  # describe '#delete' do
  #   specify do
  #     within '#index_table_attachments' do
  #       within "#attachment_#{attachment1.id}" do
  #         click_on 'Delete'
  #       end
  #     end
  #     page.should have_content 'Attachment was successfully destroyed.'
  #     within '#index_table_attachments' do
  #       page.should_not have_content "Message ##{message1.id}"
  #       page.should_not have_content attachment1.file.url
  #
  #       page.should have_content attachment2.file.url
  #       page.should have_content "Message ##{message2.id}"
  #     end
  #   end
  # end
end