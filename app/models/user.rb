class User < ActiveRecord::Base
  before_save :ensure_authentication_token
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
  :registerable,
  :omniauthable,
  :recoverable, 
  :rememberable, 
  :trackable
  # :validatable, 
  # :token_authenticatable, 
  # :confirmable,
  # :lockable, 
  # :timeoutable ,
   # :omniauthable

  # attr_accessible :title, :body
  attr_accessible :email, :password, :remember_me, :password_confirmation
  has_many :authentications, :dependent => :destroy

  has_many :assignments
  has_many :roles, :through => :assignments

  validates_presence_of :email
  validates_uniqueness_of :email

  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end

  def has_role? role
    role_symbols.include?(role)
  end

  def apply_omniauth(omni)
    authentications.build(:provider => omni['provider'],
                          :uid => omni['uid'],
                          :token => omni['credentials'].token,
                          :token_secret => omni['credentials'].secret)

    # password = Devise.friendly_token[0,20] if password.blank?
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end
 
  private
  
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

end
