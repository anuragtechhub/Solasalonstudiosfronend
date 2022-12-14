# frozen_string_literal: true

module Publically
  extend ActiveSupport::Concern
  included do
    before_create :set_public_id
  end

  def generate_public_id
    "#{SecureRandom.urlsafe_base64(3).gsub(/-|_/, '')}#{SecureRandom.hex(3)}".chars.shuffle.join
  end

  def set_public_id
    pid = generate_public_id
    pid = generate_public_id while self.class.where(public_id: pid).size.positive?
    self.public_id = pid
  end

  def to_param
    public_id
  end
end
