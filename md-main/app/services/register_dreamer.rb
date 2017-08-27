class RegisterDreamer
  attr_reader :dreamer, :form, :session

  def initialize(params)
    @params = params
  end

  def call
    # https://github.com/plataformatec/devise/blob/v3.5.3/lib/devise/models/confirmable.rb#L267
    # Do not create dreamer with email because we must save email in Email model
    # before sending any mails
    # After create dreamer we call :update_column method for save email
    # and send confirmation email manually


    @dreamer = Dreamer.new(@params)
    @dreamer.skip_confirmation_notification!
    @dreamer.unconfirmed_email = @dreamer.email

    ActiveRecord::Base.transaction do
      @dreamer.save!
      @dreamer.emails.create!(email: @dreamer.email)
      @dreamer.create_account(amount: 0)
      @dreamer.send_confirmation_instructions if @dreamer.email.present?
    end

    @dreamer
  end

  def self.call(*args)
    new(*args).call
  end
end
