require 'rails_helper'

RSpec.describe Account::FriendsController do
  render_views

  let(:dreamer) { create :light_dreamer }
  let!(:friend) { create :light_dreamer }
  let!(:friendship) { Friendship.create(member_ids: [dreamer.id, friend.id]) }
  before { sign_in dreamer }

  describe '#index' do
    subject { get :index }

    it { expect(response).to be_success }
  end
end
