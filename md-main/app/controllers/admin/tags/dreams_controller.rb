class Admin::Tags::DreamsController < Admin::Tags::ApplicationController
  def index
    @dreams = Dream.order(:id).
              includes(:dreamer, :hidden_tags).
              page params[:page]
  end

  def edit
    @dream = find_dream
  end

  def update
    @dream = find_dream
    @dream.hidden_tag_ids = tag_ids_from_names(dreams_params[:dream_hidden_tags])
    @dream.save
    render :edit
  end

  private

  def dreams_params
    params.require(:dream).permit(:tag_id, :active, dream_hidden_tags: [])
  end

  def find_dream
    Dream.find(params[:id])
  end

  def tag_ids_from_names(tag_names)
    Tag.where(name: tag_names).map(&:self_and_ancestor_ids).flatten.uniq
  end
end
