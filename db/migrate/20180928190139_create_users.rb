class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :password_digest
      t.string :encrypted_api_key
      t.string :encrypted_api_key_iv

      t.timestamps
    end
    add_index :users, :user_name, unique: true
  end
end
