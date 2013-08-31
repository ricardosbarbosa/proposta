class CreateProposals < ActiveRecord::Migration
  def up
    create_table :proposals do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end

  def down
  	drop_table :proposals
  end
end
