class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable
  
  has_many :locations

  has_paper_trail

  #validates :email, :presence => true, :email => true

  def title 
    email
  end

  def location_ids
    locations.pluck(:id) if locations
  end
end
