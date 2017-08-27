# Preview all emails at http://localhost:3000/rails/mailers/dreams_mailer
class DreamsMailerPreview < ActionMailer::Preview
  def come_true
    DreamsMailer.come_true(dreamer.dreams.first)
  end

  def come_true_with_additions
    additional_text = 'Дополнительный текст'
    DreamsMailer.come_true(dreamer.dreams.first, additional_text: additional_text)
  end

  private

  def dreamer
    @dreamer ||= Dreamer.where('email is not null').first
  end
end
