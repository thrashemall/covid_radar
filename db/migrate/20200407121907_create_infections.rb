class CreateInfections < ActiveRecord::Migration[6.0]
  def change
    create_table :infections do |t|
      t.bigint  :country_id
      t.bigint  :confirmed, default: 0
      t.bigint  :recovered, default: 0
      t.bigint  :deaths, default: 0
      t.date    :date, null: false
      t.bigint  :confirmed_delta, default: 0
      t.integer :confirmed_rate, default: 0
      t.bigint  :recovered_delta, default: 0
      t.integer :recovered_rate, default: 0
      t.bigint  :deaths_delta, default: 0
      t.integer :deaths_rate, default: 0
      t.bigint  :confirmed_notified
      t.timestamps
    end

    add_index :infections, :country_id
    add_index :infections, :date, order: { date: :desc }
    add_index :infections, %i[country_id date], unique: true, order: { date: :desc }
    add_index :infections, :id, where: 'confirmed <> confirmed_notified'

    add_foreign_key :infections, :countries, on_delete: :cascade
  end
end
