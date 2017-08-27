Raven.configure do |config|
  config.dsn = 'https://9fb4584d157b4261931e7d3c5defd8ae:9a67fedadeae44a38c0866933df81131@app.getsentry.com/84849'
  config.environments = %w(staging production)
end
