class CreateCountries < ActiveRecord::Migration[6.0]
  def change
    create_table :countries do |t|
      t.string :name
      t.string :slug
      t.string :iso2
      t.timestamps
    end

    add_index :countries, 'UPPER(iso2)', unique: true
  end
end
