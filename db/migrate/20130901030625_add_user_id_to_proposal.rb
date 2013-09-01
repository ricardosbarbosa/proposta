class AddUserIdToProposal < ActiveRecord::Migration
  def change
    add_column :proposals, :user_id, :integer
    add_column :proposals, :user, :belongs_to
  end
end
