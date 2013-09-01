class AddUserIdToProposal < ActiveRecord::Migration
  def change
    add_column :proposals, :user_id, :integer
  end
end
