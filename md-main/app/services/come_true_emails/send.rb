module ComeTrueEmails
  class Send
    attr_reader :come_true_email, :test_send_mail

    def initialize(come_true_email:, test_send_mail: 'true')
      @come_true_email = come_true_email
      @test_send_mail = test_send_mail
    end

    def call
      return send_already_error if send_already?
      return dream_come_true_error if dream_come_true?

      dreamer = come_true_email.dream.dreamer
      sender = come_true_email.sender

      ActiveRecord::Base.transaction do
        email = if test_send_mail == 'true'
                  sender.emails.find_or_create_by(email: sender.email)
                  come_true_email.to_test!
                  sender.email
                else
                  dreamer.emails.find_or_create_by(email: dreamer.email)
                  come_true_email.to_send!
                  come_true_email.dream.fulfill_dream!
                  dreamer.email
                end

        DreamsMailer.come_true(come_true_email, email).deliver_now
        come_true_email.update_attributes(sended_at: Time.zone.now)
      end

      mail_sended? ? Result::Success.new(come_true_email) : mail_sended_error
    end

    def self.call(*args)
      new(*args).call
    end

    private

    def send_already?
      come_true_email.state == 'sended' && come_true_email.sended_at
    end

    def send_already_error
      Result::Error.new I18n.t('mailing_list.come_true_dreams.errors.already_send')
    end

    def dream_come_true?
      come_true_email.dream.came_true == true
    end

    def dream_come_true_error
      Result::Error.new I18n.t('mailing_list.come_true_dreams.errors.already_come_true')
    end

    def mail_sended?
      come_true_email.state == 'sended' || come_true_email.state == 'tested'
    end

    def mail_sended_error
      Result::Error.new I18n.t('mailing_list.come_true_dreams.errors.not_send')
    end
  end
end
