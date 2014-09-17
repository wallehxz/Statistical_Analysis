class CreateTableForms < ActiveRecord::Migration
  def change
    create_table :table_forms do |t|
      t.integer :table_id
      t.string :value1
      t.string :value2
      t.string :value3
      t.string :value4
      t.string :value5
      t.string :value6
      t.string :value7
      t.string :value8
      t.string :value9
      t.string :value10
      t.string :value11
      t.string :value12
      t.string :value13
      t.string :value14
      t.string :value15

      t.timestamps
    end
  end
end
