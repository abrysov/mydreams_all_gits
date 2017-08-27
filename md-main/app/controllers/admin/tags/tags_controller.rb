class Admin::Tags::TagsController < Admin::Tags::ApplicationController
  def index
    @tags = Tag.roots.
            order(:id).
            page params[:page]
  end

  def new
    @tag = Tag.new
  end

  def edit
    @tag = find_tag
  end

  def create
    @tag = Tag.new(tags_params)
    if @tag.save
      redirect_to [:admin, :tags, @tag]
    else
      render :edit
    end
  end

  def show
    @tag = find_tag
  end

  def update
    @tag = find_tag
    if @tag.update_attributes(tags_params)
      redirect_to [:admin, :tags, @tag]
    else
      render :edit
    end
  end

  def destroy
    tag = find_tag
    unless tag.leaf? || tag.root?
      parent = tag.parent
      tag.children.each do |child|
        parent.add_child(child)
      end
    end
    tag.destroy
    redirect_to admin_tags_tags_path
  end

  private

  def tags_params
    params.require(:tag).permit(:name, :parent_id, :active)
  end

  def find_tag
    Tag.find(params[:id])
  end
end
