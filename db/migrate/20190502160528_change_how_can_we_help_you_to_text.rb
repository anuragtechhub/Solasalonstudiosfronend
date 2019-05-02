class ChangeHowCanWeHelpYouToText < ActiveRecord::Migration
  def change
  	change_column :request_tour_inquiries, :how_can_we_help_you, :text
  end
end
