desc "Task run by Heroku cron add-on"
task :cron => :environment do
	if(Time.now.hour % 3 == 0)
		Event.strip_events(3)
		Event.update_attendings()
	end

end
