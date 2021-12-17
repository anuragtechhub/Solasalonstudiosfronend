class SolaClassRegionState < ActiveRecord::Base
  belongs_to :sola_class_region

  validates :sola_class_region, uniqueness: { scope: :state, message: 'is already mapped to this state' }

  def state_enum
    [
      ['Alabama', 'Alabama'],
      ['Alaska', 'Alaska'],
      ['Arizona', 'Arizona'],
      ['Arkansas', 'Arkansas'],
      ['California', 'California'],
      ['Colorado', 'Colorado'],
      ['Connecticut', 'Connecticut'],
      ['Delaware', 'Delaware'],
      ['District of Columbia', 'District of Columbia'],
      ['Florida', 'Florida'],
      ['Georgia', 'Georgia'],
      ['Hawaii', 'Hawaii'],
      ['Idaho', 'Idaho'],
      ['Illinois', 'Illinois'],
      ['Indiana', 'Indiana'],
      ['Iowa', 'Iowa'],
      ['Kansas', 'Kansas'],
      ['Kentucky', 'Kentucky'],
      ['Louisiana', 'Louisiana'],
      ['Maine', 'Maine'],
      ['Maryland', 'Maryland'],
      ['Massachusetts', 'Massachusetts'],
      ['Michigan', 'Michigan'],
      ['Minnesota', 'Minnesota'],
      ['Mississippi', 'Mississippi'],
      ['Missouri', 'Missouri'],
      ['Montana', 'Montana'],
      ['Nebraska', 'Nebraska'],
      ['Nevada', 'Nevada'],
      ['New Hampshire', 'New Hampshire'],
      ['New Jersey', 'New Jersey'],
      ['New Mexico', 'New Mexico'],
      ['New York', 'New York'],
      ['North Carolina', 'North Carolina'],
      ['North Dakota', 'North Dakota'],
      ['Ohio', 'Ohio'],
      ['Oklahoma', 'Oklahoma'],
      ['Oregon', 'Oregon'],
      ['Pennsylvania', 'Pennsylvania'],
      ['Rhode Island', 'Rhode Island'],
      ['South Carolina', 'South Carolina'],
      ['South Dakota', 'South Dakota'],
      ['Tennessee', 'Tennessee'],
      ['Texas', 'Texas'],
      ['Utah', 'Utah'],
      ['Vermont', 'Vermont'],
      ['Virginia', 'Virginia'],
      ['Washington', 'Washington'],
      ['West Virginia', 'West Virginia'],
      ['Wisconsin', 'Wisconsin'],
      ['Wyoming', 'Wyoming']
    ]
  end
end

# == Schema Information
#
# Table name: sola_class_region_states
#
#  id                   :integer          not null, primary key
#  sola_class_region_id :integer
#  state                :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#
# Indexes
#
#  index_sola_class_region_states_on_sola_class_region_id  (sola_class_region_id)
#