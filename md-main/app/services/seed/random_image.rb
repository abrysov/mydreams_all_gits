module Seed
  class RandomImage
    def self.call
      random_name = %w{silver schwarz norris}.sample + '.jpg'
      random_image = File.join(Rails.root, '/spec/fixtures/', random_name)
      Rack::Test::UploadedFile.new(File.open(random_image))
    end
  end
end
