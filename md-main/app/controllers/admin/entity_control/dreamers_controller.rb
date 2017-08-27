class Admin::EntityControl::DreamersController < Admin::EntityControl::ApplicationController
  def index
    @dreamers = Dreamer.includes(:abuses).
                page params[:page]
  end

  def edit
    @dreamer = find_dreamer
  end

  def show
    @dreamer = find_dreamer
  end

  def update
    @dreamer = find_dreamer
    @dreamer.update(dreamers_params)
    block_or_delete_dreamer
    render :show
  end

  def destroy
    Dreamer.where(id: params[:id]).destroy_all
    redirect_to action: :index
  end

  private

  def dreamers_params
    params.require(:dreamer).permit(:first_name, :last_name, :is_vip,
                                    :project_dreamer, :gender, :role)
  end

  def find_dreamer
    @dreamer ||= Dreamer.find(params[:id])
  end

  def block_or_delete_dreamer
    params[:dreamer][:blocked_at] == '0' ? find_dreamer.unblock! : find_dreamer.block!
    params[:dreamer][:deleted_at] == '0' ? find_dreamer.mark_undeleted : find_dreamer.mark_deleted
  end
end
