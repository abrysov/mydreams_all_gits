class CreateReactions < ActiveRecord::Migration
  def change
    create_table :reactions do |t|
      t.references :reactable, polymorphic: true, index: true, null: false
      t.references :dreamer, foreign_key: true, null: false
      t.string :reaction, null: false

      t.timestamps null: false
    end

    add_index :reactions, %i[reactable_id reactable_type dreamer_id reaction],
      unique: true, name: :index_reactions_on_reactable_and_dreamer_and_reaction
  end
end
