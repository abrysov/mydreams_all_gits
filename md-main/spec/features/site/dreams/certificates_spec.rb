require 'rails_helper'

# include Rack::Test::Methods

describe 'purchasing certificates', js: true do
  let!(:dreamer) { FactoryGirl.create(:dreamer) }

  describe 'purchase process' do
    context 'purchase page' do
      before do
        CertificateType.create!([{id: 1, name: 'bronze', value: 1}])
        sign_in_as_dreamer(dreamer)
        visit belive_in_dream_account_belive_in_dream_index_path
      end

      specify do
        within '#new_dream' do
          fill_in 'dream[title]', with: 'ogurec'
          fill_in 'dream[description]', with: 'soleniy'

          page.execute_script("$('.js-add-mark:visible').click()")
          page.execute_script("$('.button-yellow:visible').click()")

          # find(:css, '.js-add-mark').click
          # find(:css, '.button-yellow').click
        end

        expect(page).to have_content 'ROBOXchange.com'

        invoice = Invoice.all.first
        invoice.success!
        invoice.save!

        signature = Digest::MD5.hexdigest [invoice.amount, 1, Rubykassa.first_password].join(':')
        visit "/robokassa/success?InvId=#{invoice.id}&OutSum=#{invoice.amount}&SignatureValue=#{signature}&Culture=ru-RU"

        sleep 100
        binding.pry
        puts
      end
    end
  end
end
