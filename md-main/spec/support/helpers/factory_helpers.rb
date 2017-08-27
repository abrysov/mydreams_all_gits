module FactoryHelpers
  def self.uploaded_fixture_image
    Rack::Test::UploadedFile.new(File.open(random_fixture_image))
  end

  def self.uploaded_fixture_mp3
    Rack::Test::UploadedFile.new(File.open(fixture_mp3))
  end

  def self.uploaded_large_fixture_image
    Rack::Test::UploadedFile.new(File.open(fixture_mp3))
  end

  def self.random_fixture_image
    File.join(Rails.root, '/spec/fixtures/', %w{silver schwarz norris}.shuffle.first + '.jpg')
  end

  private

  def self.fixture_mp3
    File.join(Rails.root, '/spec/fixtures/silver.mp3')
  end

  def self.fixture_large_image
    File.join(Rails.root, '/spec/fixtures/2,7mb.jpg')
  end
end