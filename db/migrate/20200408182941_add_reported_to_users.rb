class AddReportedToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :reported, :boolean, null: false, default: false
    add_index :users, :id, where: 'reported = false'
  end
end
