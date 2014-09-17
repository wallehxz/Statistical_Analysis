class CreateCustomForms < ActiveRecord::Migration
  def change
    create_table :custom_forms do |t|
      t.integer :custom_table_id
      t.string :value0
      t.string :value1
      t.string :value2
      t.string :value3
      t.string :value4
      t.string :value5
      t.string :value6
      t.string :value7
      t.string :value8
      t.string :value9

      t.timestamps
    end
  end
end
