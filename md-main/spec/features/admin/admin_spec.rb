require 'rails_helper'

describe 'Admin' do
  before do
    sign_in_as_admin
  end

  describe 'can manage activities' do
    it_behaves_like 'activities'
  end

  describe 'can manage attachments' do
    it_behaves_like 'attachments'
  end

  describe 'can manage dreamer cities' do
    it_behaves_like 'dreamer cities'
  end

  describe 'can manage dreamer countries' do
    it_behaves_like 'dreamer countries'
  end

  describe 'can manage dreamers' do
    it_behaves_like 'dreamers'
  end

  describe 'can manage dreams' do
    it_behaves_like 'dreams'
  end

  describe 'can manage friendships' do
    it_behaves_like 'friendships'
  end

  describe 'can manage likes' do
    it_behaves_like 'likes'
  end

  describe 'can manage messages' do
    it_behaves_like 'messages'
  end

  describe 'can manage photos' do
    it_behaves_like 'photos'
  end

  describe 'can manage static pages' do
    it_behaves_like 'static pages'
  end

  describe 'can manage suggested dreams' do
    it_behaves_like 'suggested dreams'
  end

  describe 'can manage superusers' do
    it_behaves_like 'superusers'
  end

  describe 'can manage top dreams' do
    it_behaves_like 'top dreams'
  end
end
