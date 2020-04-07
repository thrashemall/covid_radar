class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.bigint :uid, null: false
      t.bigint :chat_id, null: false
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :language_code
      t.timestamps
    end

    add_index :users, %i[uid chat_id], unique: true
  end
end
