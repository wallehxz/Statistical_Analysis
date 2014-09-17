class CreateCustomTables < ActiveRecord::Migration
  def change
    create_table :custom_tables do |t|
      t.string :name
      t.string :item0
      t.string :item1
      t.string :item2
      t.string :item3
      t.string :item4
      t.string :item5
      t.string :item6
      t.string :item7
      t.string :item8
      t.string :item9

      t.timestamps
    end
  end
end
