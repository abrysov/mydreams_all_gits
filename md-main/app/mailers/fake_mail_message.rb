class FakeMailMessage < Mail::Message
  def self.deliver
    false
  end
end
