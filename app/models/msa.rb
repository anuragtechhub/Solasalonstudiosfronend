class Msa < ActiveRecord::Base

  after_save :expire_cache

  def expire_cache
    expire_action(:controller => '/locations', :action => 'index')
  end
end