class Pro::SplashController < Pro::ApplicationController

	layout false
	skip_before_filter :authorize

	def index
	end
end