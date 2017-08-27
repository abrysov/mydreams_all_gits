require 'rails_helper'

RSpec.describe PhotosController do
  describe 'For signed in user' do
    before do
      @dreamer = create(:dreamer)
      sign_in @dreamer
    end

    describe 'PhotosController#upload' do
      before do
        post :upload, file: fixture_file_upload('avatar.jpg', 'image/jpg')
      end

      it { expect(response).to be_success }
      it { expect(@dreamer.reload.photos.last.read_attribute(:file)).not_to be_nil }
      it { expect(@dreamer.reload.photos.last.file.url).not_to be_nil }
    end
  end
end
