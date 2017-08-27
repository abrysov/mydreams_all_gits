class CreateVipStatuses < ActiveRecord::Migration
  def change
    create_table :vip_statuses do |t|
      t.references :dreamer, index: true
      t.integer :from_dreamer_id, references: :dreamer, index: :true
      t.datetime :paid_at
      t.datetime :completed_at
      t.integer :duration
      t.string :comment

      t.timestamps null: false
    end
  end
end
