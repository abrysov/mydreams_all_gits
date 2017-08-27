module Competitions
  module LetterSender
    ###
    # Usage:
    # Competitions::LetterSender.deliver(:summer, test: false)
    ###
    def self.deliver(method, test: true)
      if test
        test_mails.each { |test_email| CompetitionsMailer.send(method, test_email).deliver }
      else
        Email.available_for_newsletter.find_each do |email|
          next if email.email.blank?

          begin
            CompetitionsMailer.send(method, email.email).deliver
          rescue => e
            Honeybadger.notify(e)
            nil
          end
        end
      end
    end

    def self.test_mails
      %w(me@zzet.org selyukovag76@mail.ru t89250560000@mail.ru kochelev@yandex.ru)
    end
  end
end
