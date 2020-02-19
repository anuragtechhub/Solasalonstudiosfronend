class Account < ActiveRecord::Base

  validates :api_key, :name, :uniqueness => true

  before_create :generate_api_key

  has_paper_trail
  
  private

  # comment
  
  def generate_api_key
    begin
      self.api_key = SecureRandom.hex
    end while self.class.exists?(api_key: api_key)
  end

end