require 'rails_helper'

describe 'Fulfill Dream', js: true do
  let!(:dreamer) { FactoryGirl.create(:dreamer) }

  before do
    ActionMailer::Base.deliveries.clear
    sign_in_as_dreamer(dreamer)
    visit fulfill_account_fulfill_dreams_path
  end

  describe 'Fulfill' do
    context 'without data' do
      specify do
        within '.page-title' do
          page.should have_content 'Fulfill dream'
        end
        page.find('.form_btn.form_btn-yellow').click
        current_path.should be == fulfill_account_fulfill_dreams_path(locale: :en)
      end
    end

    context 'success' do
      specify do
        fill_in 'dream[title]', with: 'Some new title'
        fill_in 'dream[description]', with: 'description description'

        page.find('.form_btn.form_btn-yellow').click

        current_path.should be == success_fulfill_account_fulfill_dreams_path(locale: :en)
        page.should have_content 'Sent to approve'
        Dream.last.state.should be == 'needs_accepting'

        visit dreams_path(filter: {choose: :new})
        page.should_not have_content 'Some new title'

        visit account_dream_path(Dream.last, locale: :en)
        current_path.should be == account_dream_path(Dream.last, locale: :en)

        visit destroy_dreamer_session_path
        sign_in_as_dreamer

        visit account_dream_path(Dream.last, locale: :en)
        current_path.should be == root_path

        visit dreams_path(filter: {choose: :new})
        page.should_not have_content 'Some new title'
      end
    end
  end
  # pending 'admin approve fulfilled dream'
  # pending 'admin decline fulfilled dream'
end
