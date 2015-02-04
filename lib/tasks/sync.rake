namespace :sync do
  
  task :locations => :environment do
    p 'sync locations!'
    db = get_database_client
    p "mysql db = #{db}"
    # results = db.query("SELECT * FROM exp_weblog_data WHERE field_id_9 = '#{email}' LIMIT 1")
    # p "results = #{results}"
    # results.each do |row|
    #   p "row=#{row}"
    # end
  end 

  def get_database_client
    Mysql2::Client.new(:host => 'solasalonstudios.com', :port => 3306, :database => 'sola_expressengine', :username => 'sola_stylist', :password => 'lostinthedream2014', :local_infile => false, :secure_auth => false)
  end

end