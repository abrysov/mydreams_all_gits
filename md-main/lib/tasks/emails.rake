namespace :emails do
  desc 'fill by rejects email from Mandrill'
  task :fill_from_mandrill => :environment do
    Rails.logger.info 'starting filling Dreamer.emails from rejected email from db Mandrill'
    connection = Mandrill::API.new 'j1_1u_mTpLG6XtYKYcmWSg'
    Rails.logger.info 'connected to Mandrill' if connection
    mail_list = connection.rejects.list
    Rails.logger.info "processing #{mail_list.count}' emails"

    mail_list.each do |list|
      email = Email.where(email: list["remail"]).first
      attribute = list["reason"].sub('-','_').to_sym
      email.update( attribute => true ) if email
    end
  end
end
