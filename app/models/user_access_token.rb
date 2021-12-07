class UserAccessToken < ActiveRecord::Base
  belongs_to :stylist, inverse_of: :access_tokens
  belongs_to :admin, inverse_of: :access_tokens
  validates :stylist, :key, presence: true, if: proc { self.admin_id.blank? }
  validates :admin, :key, presence: true, if: proc { self.stylist_id.blank? }

  before_validation :set_key, on: [:create]

  def expiring?
    false
  end

  def refresh
    self
  end

  def user
    stylist || admin
  end

  private

  def set_key
    self.key ||= loop do
      key = SecureRandom.uuid

      break key unless self.class.where(key: key).exists?
    end
  end
end

# == Schema Information
#
# Table name: user_access_tokens
#
#  id         :integer          not null, primary key
#  key        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  admin_id   :integer
#  stylist_id :integer
#
# Indexes
#
#  index_user_access_tokens_on_admin_id    (admin_id)
#  index_user_access_tokens_on_key         (key)
#  index_user_access_tokens_on_stylist_id  (stylist_id)
#
