class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.belongs_to :user
      t.integer :user_id
      t.integer :role_id
      t.belongs_to :role

      t.timestamps
    end
    add_index :assignments, :user_id
    add_index :assignments, :role_id
  end
end
