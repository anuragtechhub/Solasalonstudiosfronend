class Msa < ActiveRecord::Base

  has_paper_trail

  before_validation :generate_url_name, :on => :create
  before_save :fix_url_name
  after_save :update_computed_fields
  after_destroy :touch_msa
  has_many :locations

  def fix_url_name
    if self.url_name.present?
      self.url_name = self.url_name.gsub(/[^0-9a-zA-Z]/, '_')
      self.url_name = self.url_name.gsub('___', '_')
      self.url_name = self.url_name.gsub('_-_', '_')
      self.url_name = self.url_name.split('_')
      self.url_name = self.url_name.map{ |u| u.downcase }
      self.url_name = self.url_name.join('-')
    end
  end  

  def canonical_path
    "/regions/#{url_name}"
  end

  def canonical_url(locale=:en)
    "https://www.solasalonstudios.#{locale != :en ? 'ca' : 'com'}/regions/#{url_name}"
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
end