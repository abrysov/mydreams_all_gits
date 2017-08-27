namespace :purchases do
  desc 'create products'
  task products: :environment do
    CreateProducts.call
  end
end
