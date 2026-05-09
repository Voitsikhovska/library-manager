class CreateAuthors < ActiveRecord::Migration[8.0]
  def change
    create_table :authors do |t|
      t.string :name
      t.text :bio
      t.integer :birth_year

      t.timestamps
    end
    add_index :authors, :name, unique: true
  end
end
