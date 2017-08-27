class Moderate::AbusesController < Moderate::ApplicationController
  def create
    @abuse = Moderation::CreateAbuse.call(
      moderator: current_dreamer,
      abusable: abusable,
      text: abuse_params[:text]
    )
    abusable.approve
  end

  private

  def abusable
    @abusable ||= find_entity_object(
      abuse_params[:abusable_type],
      abuse_params[:abusable_id]
    )
  end

  def abuse_params
    params.require(:abuse).permit(:abusable_type, :abusable_id, :text)
  end
end
