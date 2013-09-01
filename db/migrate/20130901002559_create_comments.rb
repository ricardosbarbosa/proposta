class CreateComments < ActiveRecord::Migration
  def up
    create_table :comments do |t|
      t.belongs_to :proposal
      t.text :text

      t.timestamps
    end
    add_index :comments, :proposal_id
  end

  def down
  	drop_table :comments
  end

end
