namespace :umsw do

  # any UMSW requests 2 weeks or older get auto-approved
  task :auto_approve => :environment do
    UpdateMySolaWebsite.pending.where('updated_at <= ?', 14.days.ago.end_of_day).each do |umsw|
      umsw.approved = true
      umsw.save
    end
  end

  # reminds franchisees they have un-approved UMSW requests one week before they are auto-approved
  task :one_week_before_reminder => :environment do
    umsw_reminder(7.days.ago)
  end

  # reminds franchisees they have un-approved UMSW requests two days before they are auto-approved
  task :two_days_before_reminder => :environment do
    umsw_reminder(12.days.ago)
  end

  task :orient => :environment do
    UpdateMySolaWebsite.pending.find_each do |umsw|
      begin
        umsw.force_orient
      rescue => e
        p "error #{e.inspect}"
      end
    end
  end

  private

  def umsw_reminder(time_frame=nil)
    return unless time_frame

    UpdateMySolaWebsite.pending.where('updated_at >= ? AND updated_at <= ?', time_frame.beginning_of_day, time_frame.end_of_day).each do |umsw|
      p "umsw #{umsw.name} --- #{umsw.updated_at}"
      email = PublicWebsiteMailer.update_my_sola_website_reminder(umsw)
      p "email = #{email.inspect}, #{email.body}"
      email.deliver if email
    end
  end

end
