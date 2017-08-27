require 'rails_helper'

describe 'Top Dreams', js: true do
  # 105.times do |n|
  #   let!("top_dream#{n}") { FactoryGirl.create(:top_dream) }
  # end

  2.times do |n|
    let!("top_dream#{n}") { FactoryGirl.create(:top_dream) }
  end

  describe '#index' do
    before { visit top_dreams_path }
    specify do
      page.should have_content top_dream0.title
      page.should have_content top_dream1.title
      # page.should_not have_content top_dream100.title
      # page.should_not have_content top_dream101.title
    end
  end

  describe '#show' do
    specify do
      visit top_dream_path id: top_dream0.id
      page.should have_content top_dream0.title
      # visit top_dream_path id: top_dream101.id
      # page.should_not have_content top_dream101.title
    end
  end
end
