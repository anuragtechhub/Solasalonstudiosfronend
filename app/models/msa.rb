class Msa < ActiveRecord::Base

  has_paper_trail

  before_validation :generate_url_name, :on => :create
  before_save :fix_url_name
  after_save :update_computed_fields
  after_destroy :touch_msa
  has_many :locations

  validates :name, :presence => true#, :uniqueness => true
  validates :url_name, :presence => true, :uniqueness => true

  # TODO replace this bullshit with friendly_id.
  def fix_url_name
    if self.url_name.present?
      self.url_name = self.url_name
                          .downcase
                          .gsub(/\s+/,'_')
                          .gsub(/[^0-9a-zA-Z]/, '_')
                          .gsub('___', '_')
                          .gsub('_-_', '_')
                          .gsub('_', '-')
    end
  end

  def canonical_path
    "/regions/#{url_name}"
  end

  def canonical_url(locale=:en)
    "https://www.solasalonstudios.#{locale != :en ? 'ca' : 'com'}/regions/#{url_name}"
  end

  def generate_url_name
    if self.name
      url = self.name.downcase.gsub(/[^0-9a-zA-Z]/, '-')
      count = 1

      while Msa.where(:url_name => "#{url}#{count}").size > 0 do
        count = count + 1
      end

      self.url_name = "#{url}#{count}"
    end
  end

  private

  def update_computed_fields
    self.locations.each do |location|
      # update stylist location_name
      location.stylists.each do |stylist|
        stylist.msa_name = self.name
        stylist.save
      end
    end
  end

  def touch_msa
    Msa.all.first.touch
  end
end

# == Schema Information
#
# Table name: msas
#
#  id            :integer          not null, primary key
#  description   :text
#  name          :string(255)
#  tracking_code :text
#  url_name      :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  legacy_id     :string(255)
#
# Indexes
#
#  index_msas_on_name      (name)
#  index_msas_on_url_name  (url_name)
#
