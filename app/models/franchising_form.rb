class FranchisingForm < ActiveRecord::Base
end

# == Schema Information
#
# Table name: franchising_forms
#
#  id                     :integer          not null, primary key
#  agree_to_receive_email :boolean
#  city                   :string(255)
#  email_address          :string(255)
#  first_name             :string(255)
#  last_name              :string(255)
#  liquid_capital         :string(255)
#  multi_unit_operator    :boolean
#  phone_number           :string(255)
#  state                  :string(255)
#  utm_campaign           :string(255)
#  utm_content            :string(255)
#  utm_medium             :string(255)
#  utm_source             :string(255)
#  utm_term               :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#
