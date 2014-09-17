class CreateIdentityTables < ActiveRecord::Migration
  def change
    create_table :identity_tables do |t|
      t.integer :user_id
      t.string :table_name

      t.timestamps
    end
  end
end
