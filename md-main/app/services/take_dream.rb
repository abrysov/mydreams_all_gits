class TakeDream
  attr_reader :original, :copied

  def initialize(original, copied)
    @original = original
    @copied = copied
  end

  def call
    return unless original

    copied.video = original.video
    copied.came_true = original.came_true
    copied.save
  end

  def self.call(*args)
    new(*args).call
  end
end
