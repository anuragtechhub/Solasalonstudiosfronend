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

# == Schema Information
#
# Table name: accounts
#
#  id         :integer          not null, primary key
#  api_key    :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_accounts_on_api_key  (api_key)
#
