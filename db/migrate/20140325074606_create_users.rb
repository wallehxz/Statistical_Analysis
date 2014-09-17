class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :account
      t.string :password
      t.string :name
      t.string :phone
      t.string :picture
      t.datetime :lately_login
      t.datetime :sign_time
      t.string :role

      t.timestamps
    end
  end
end
