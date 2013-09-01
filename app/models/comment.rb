class Comment < ActiveRecord::Base
  belongs_to :proposal
  attr_accessible :text, :proposal_id

  validates_presence_of :text
end
