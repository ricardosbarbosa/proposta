class Proposal < ActiveRecord::Base
  before_save :ensure_proposal_token

  attr_accessible :description, :title, :token
  has_many :comments

  def ensure_proposal_token
    if token.blank?
      self.token = generate_proposal_token
    end
  end
 
  private
  
  def generate_proposal_token
    loop do
      token = Devise.friendly_token
      break token unless Proposal.where(token: token).first
    end
  end
end
