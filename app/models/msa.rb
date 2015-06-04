class Msa < ActiveRecord::Base

  after_destroy :touch_msa

  private

  def touch_msa
    Msa.all.first.touch
  end
end