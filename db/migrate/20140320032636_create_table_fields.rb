class CreateTableFields < ActiveRecord::Migration
  def change
    create_table :table_fields do |t|
      t.integer :table_id
      t.string :field_name
      t.string :field_type
      t.integer :field_turn

      t.timestamps
    end
  end
end
