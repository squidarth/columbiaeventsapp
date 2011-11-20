	desc "grab all facebook events"
	task :grab_events => :environment do
		Event.strip_events(3)
		Event.update_attendings()
	end
