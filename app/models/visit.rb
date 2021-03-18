class Visit < ActiveRecord::Base
  
  has_paper_trail

end

# == Schema Information
#
# Table name: visits
#
#  id                :integer          not null, primary key
#  ip_address        :string(255)
#  user_agent_string :string(255)
#  uuid              :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#
