class Account::DreamersController < Account::ApplicationController
  skip_before_action :check_if_active, :render_blocked_dreamer, only: :restore_profile

  before_action :expire_fragments, only: [
    :update, :upload_crop_avatar, :upload_crop_dreambook_bg, :remove_profile
  ]
  before_action :load_dreamer, only: [
    :edit, :update, :upload_crop_avatar, :update_page_bg, :upload_crop_dreambook_bg,
    :page_background_destroy, :dreambook_background_destroy
  ]

  def show
    redirect_to account_dreamer_dreams_path(params[:id])
  end

  def expire_fragments
    expire_fragment 'last_8_dreamers'
    expire_fragment 'last_40_dreamers'
  end

  def edit
    build_avatar
    build_dreamer
  end

  def update
    # TODO: Fix it
    if params[:dreamer][:password].blank?
      params[:dreamer].delete('password')
    end

    build_avatar
    build_dreamer

    render json: if save_dreamer
                   { id: @dreamer.id }
                 else
                   { errors: @dreamer.errors }
                 end
  end

  def update_page_bg
    @dreamer.page_bg = params[:page_bg]
    @dreamer.save(validates: false)
    redirect_to :back
  end

  def update_dreambook_bg
    @dreamer.dreambook_bg = params[:dreambook_bg]
    @dreamer.save(validates: false)

    render json: { errors: false }
  end

  def page_background_destroy
    @dreamer.remove_page_bg = true
    @dreamer.save
    redirect_to :back
  end

  def dreambook_background_destroy
    @dreamer.remove_dreambook_bg = true
    @dreamer.save
    redirect_to :back
  end

  def upload_crop_avatar
    f = avatar_params.delete(:avatar)
    @dreamer.update_attributes avatar_params
    @dreamer.assign_attributes avatar: f
    if @dreamer.save
      render json: { avatar_url: @dreamer.avatar.url(:medium) }
    else
      head 500
    end
  end

  def upload_crop_dreambook_bg
    f = dreambook_bg_params.delete(:dreambook_bg)
    @dreamer.update_attributes dreambook_bg_params
    @dreamer.assign_attributes dreambook_bg: f
    if @dreamer.save
      render json: { dreambook_bg_url: @dreamer.dreambook_bg.url(:cropped) }
    else
      head 500
    end
  end

  def remove_profile
    current_dreamer.mark_deleted
    Feed::Activity::Create.call(
      owner: current_dreamer,
      key: 'dreamer_deleted'
    )
    redirect_to :back
  end

  def restore_profile
    current_dreamer.restore!
    redirect_to account_dreamer_path(current_dreamer)
    flash[:success] = t('flash.success.restored')
  end

  private

  def build_avatar
    avatar = @dreamer.reload.avatar
    @large_avatar = avatar.try(:url, :large)
    @small_avatar = avatar.try(:url, :small)
  end

  def build_dreamer
    @dreamer ||= Dreamer.all.build
    p = dreamer_params
    if p[:password].blank?
      p.delete(:password)
    else
      p[:password_confirmation] = p[:password]
    end
    @dreamer.attributes = p
  end

  def save_dreamer
    @dreamer.save
  end

  def destroy_dreamer
    @dreamer.destroy
  end

  def apply_redirect(notice = '')
    redirect_to account_dreamer_path(current_dreamer), notice: notice
  end

  def dreamer_params
    return {} if params[:dreamer].blank?
    params.require(:dreamer).permit(
      :avatar, :avatar_cache, :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h,
      :img_crop_x, :img_crop_y, :img_crop_w, :img_crop_h, :email, :phone, :first_name, :last_name,
      :birthday, :gender, :phone, :password, :status, :dream_country_id, :dream_city_id
    )
  end

  def avatar_params
    params.permit :avatar, :avatar_cache, :avatar_crop_x, :avatar_crop_y, :avatar_crop_h,
                  :avatar_crop_w
  end

  def dreambook_bg_params
    params.permit :dreambook_bg, :dreambook_bg_crop_x, :dreambook_bg_crop_y, :dreambook_bg_crop_w,
                  :dreambook_bg_crop_h
  end
end
