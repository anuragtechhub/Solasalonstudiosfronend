# frozen_string_literal: true

class SejaSola < ActiveRecord::Base
end

# == Schema Information
#
# Table name: seja_solas
#
#  id              :integer          not null, primary key
#  area_de_atuacao :string(255)
#  email           :string(255)
#  nome            :string(255)
#  telefone        :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#
