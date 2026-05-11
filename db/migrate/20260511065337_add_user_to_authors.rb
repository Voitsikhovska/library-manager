class AddUserToAuthors < ActiveRecord::Migration[8.0]
  def up
    # Add user_id as nullable first
    add_reference :authors, :user, null: true, foreign_key: true

    # Assign existing authors to the first user
    first_user_id = User.first&.id
    if first_user_id
      execute "UPDATE authors SET user_id = #{first_user_id} WHERE user_id IS NULL"
    end

    # Now make it non-nullable
    change_column_null :authors, :user_id, false
  end

  def down
    remove_reference :authors, :user
  end
end
