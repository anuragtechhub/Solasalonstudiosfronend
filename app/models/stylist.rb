class Stylist < ActiveRecord::Base

  validates :name, :presence => true, :uniqueness => true
  validates :url_name, :presence => true, :uniqueness => true

  # define rails_admin enums
  [:hair, :skin, :nails, :massage, :teeth_whitening, :eyelash_extensions, :makeup, :tanning, :waxing, :brows, :accepting_new_clients].each do |name|
    define_method "#{name}_enum" do
      [['Yes', true], ['No', false]]
    end
  end

end
