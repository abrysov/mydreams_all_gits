class CreateAttachment
  attr_reader :file, :url

  READ_TIMEOUT = 5
  OPEN_TIMEOUT = 5

  def initialize(file:, url:)
    @url = url
    @file = file
  end

  def call
    if url
      Attachment.create!(file: fetch)
    elsif file
      Attachment.create!(file: file)
    end
  end

  def fetch
    Kernel.open(url, read_timeout: READ_TIMEOUT, open_timeout: OPEN_TIMEOUT)
  end
end
