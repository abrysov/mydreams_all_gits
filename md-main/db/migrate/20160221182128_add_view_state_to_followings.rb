class AddViewStateToFollowings < ActiveRecord::Migration
  def change
    add_column :followings, :view_state, :string
  end
end
