class AddTokenToProposal < ActiveRecord::Migration
  def change
    add_column :proposals, :token, :string
  end
end
