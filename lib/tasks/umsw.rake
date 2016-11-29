namespace :umsw do
  
  # any UMSW requests 2 weeks or older get auto-approved
  task :auto_approve => :environment do
    
  end

  # reminds franchisees they have un-approved UMSW requests one week before they are auto-approved
  task :one_week_before_reminder => :environment do
    umsw_reminder(Date.today() - 7.days)
  end

  # reminds franchisees they have un-approved UMSW requests two days before they are auto-approved
  task :two_days_before_reminder => :environment do
    umsw_reminder(Date.today() - 12.days)
  end

  private

  def umsw_reminder(time_frame=nil)
    return unless time_frame

    UpdateMySolaWebsite.where('approved = ? AND updated_at >= ? AND updated_at <= ?', false, time_frame.beginning_of_day, time_frame.end_of_day).each do |umsw|
      p "umsw #{umsw.name} --- #{umsw.updated_at}"
    end
  end

end