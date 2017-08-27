class Admin::MailingList::ComeTrueDreamsController < Admin::MailingList::ApplicationController
  def index
    @dream_come_true_email = DreamComeTrueEmail.sended.
                             order(updated_at: :desc).
                             page(params[:page])
  end

  def show
    @dream_come_true_email = DreamComeTrueEmail.find params[:id]
  end

  def edit
    @dream_come_true_email = DreamComeTrueEmail.find params[:id]
  end

  def update
    @dream_come_true_email = DreamComeTrueEmail.find params[:id]

    if @dream_come_true_email.update(dream_come_true_email_params)
      ComeTrueEmails::AttachSnapshot.call(
        @dream_come_true_email, snapshot_type: params[:snapshot_type]
      )
      redirect_to admin_mailing_list_come_true_dream_path(id: @dream_come_true_email.id)
    else
      flash[:alert] = t('mailing_list.come_true_dreams.errors.already_come_true')
      render search_admin_mailing_list_come_true_dreams_path
    end
  end

  def send_mail
    @dream_come_true_email = DreamComeTrueEmail.find params[:come_true_email_id]

    result_send = ComeTrueEmails::Send.call(
      come_true_email: @dream_come_true_email, test_send_mail: params[:test_send_mail]
    )

    if result_send.success?
      flash[:success] = t('mailing_list.come_true_dreams.success.mail_sent')
      redirect_to admin_mailing_list_come_true_dream_path(id: @dream_come_true_email.id)
    else
      flash[:alert] = result_send.error
      redirect_to admin_mailing_list_root_path
    end
  end

  def search
    dream = Dream.not_came_true.find_by(id: params[:search])

    if dream
      @dream_come_true_email = DreamComeTrueEmail.find_or_create_by(
        dream: dream, sender: current_dreamer
      )
      redirect_to edit_admin_mailing_list_come_true_dream_path(id: @dream_come_true_email.id)
    elsif params[:search]
      flash[:alert] = t('mailing_list.come_true_dreams.errors.already_come_true')
      render search_admin_mailing_list_come_true_dreams_path
    end
  end

  private

  def dream_come_true_email_params
    params.permit(:additional_text)
  end
end
