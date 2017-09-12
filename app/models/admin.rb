class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable
  
  has_many :locations

  has_paper_trail

  #validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, :allow_blank => true
  #validates :email, :uniqueness => true, if: 'email.present?'
  validates :password, :presence => true, :on => :create, :reduce => true
  validates :password, :length => { :minimum => 8 }

  def title 
    email
  end

  def location_ids
    locations.pluck(:id) if locations
  end

  def forgot_password
    self.forgot_password_key = "#{SecureRandom.urlsafe_base64(3).gsub(/-|_/, '')}#{SecureRandom.hex(3)}".split('').shuffle.join
    if self.save
      email = PublicWebsiteMailer.forgot_password(self)
      if email && email.deliver 
        true
      else
        false
      end
    else
      false
    end
  end
end
