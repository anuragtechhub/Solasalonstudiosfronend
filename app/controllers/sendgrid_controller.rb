class SendgridController < ApplicationController

  skip_before_action :verify_authenticity_token

  def events
  	p "events!!!"
  end

end