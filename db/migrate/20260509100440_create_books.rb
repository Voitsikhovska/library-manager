class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.string :title
      t.text :description
      t.string :isbn
      t.integer :published_year
      t.references :user, null: false, foreign_key: true
      t.references :author, null: false, foreign_key: true

      t.timestamps
    end
    add_index :books, :isbn, unique: true
  end
end
