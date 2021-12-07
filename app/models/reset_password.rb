class ResetPassword < ActiveRecord::Base

  before_create :set_public_id
  belongs_to :userable, polymorphic: true

  def email
    if userable_type == 'User'
      return userable.email
    else
      return userable.email_address
    end
  end

  private

  def generate_public_id
    Time.now.to_i.to_s + "#{SecureRandom.urlsafe_base64(4).gsub(/-|_/, '')}#{SecureRandom.hex(4)}".split('').shuffle.join
  end

  def set_public_id
    pid = generate_public_id
    while ResetPassword.where(:public_id => pid).size > 0 do
      pid = generate_public_id
    end
    self.public_id = pid
  end

end

# == Schema Information
#
# Table name: reset_passwords
#
#  id            :integer          not null, primary key
#  date_used     :datetime
#  userable_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  public_id     :string(255)
#  userable_id   :integer
#
