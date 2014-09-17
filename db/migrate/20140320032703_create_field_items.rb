class CreateFieldItems < ActiveRecord::Migration
  def change
    create_table :field_items do |t|
      t.integer :field_id
      t.string :item_name
      t.integer :item_turn

      t.timestamps
    end
  end
end
