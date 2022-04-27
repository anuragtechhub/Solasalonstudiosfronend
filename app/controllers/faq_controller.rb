# frozen_string_literal: true

class FaqController < PublicWebsiteController
  def index
    redirect_to :home, status: :moved_permanently
  end
end
