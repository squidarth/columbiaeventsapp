desc "Task run by Heroku cron add-on"
task :cron => :environment do
	if(Time.now.hour % 3 == 0)
		Event.fetch_all_from_facebook
		Event.update_attendings()
	end

end
