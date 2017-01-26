module Publically extend ActiveSupport::Concern

  included do
    before_create :set_public_id
  end

  def generate_public_id
    str = "#{SecureRandom.urlsafe_base64(3).gsub(/-|_/, '')}#{SecureRandom.hex(3)}".split('').shuffle.join
    str += Time.now.to_i.to_s
    str
  end

  def set_public_id
    pid = generate_public_id
    while self.class.where(:public_id => pid).size > 0 do
      pid = generate_public_id
    end
    self.public_id = pid
  end

  def to_param
    public_id
  end

end