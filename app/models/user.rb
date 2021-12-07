class User < ActiveRecord::Base
  before_create :set_public_id

  has_paper_trail
  has_secure_password
  
  has_many :reset_passwords, :as => :userable
  has_many :video_views

  validates :email, :uniqueness => true
  validates :password, :presence => true, :on => :create, :reduce => true
  validates :password, :length => { :minimum => 8 }

  def most_recent_product_page
    product_pages.order(:updated_at => :desc).first
  end

  def generate_public_id
    Time.now.to_i.to_s + "#{SecureRandom.urlsafe_base64(3).gsub(/-|_/, '')}#{SecureRandom.hex(3)}".split('').shuffle.join
  end

  def set_public_id
    pid = generate_public_id
    while User.where(:public_id => pid).size > 0 do
      pid = generate_public_id
    end
    self.public_id = pid
  end
end

# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  public_id       :string(255)
#
